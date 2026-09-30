using System;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using BlubLib.DotNetty.Handlers.MessageHandling;
using Dapper.FastCrud;
using ExpressMapper.Extensions;
using Netsphere.Database.Auth;
using Netsphere.Database.Game;
using Netsphere.Network.Data.Chat;
using Netsphere.Network.Message.Chat;
using ProudNet.Handlers;

namespace Netsphere.Network.Services
{
    internal class CommunityService : ProudMessageHandler
    {
        [MessageHandler(typeof(CSetUserDataReqMessage))]
        public async Task SetUserDataHandler(ChatSession session, CSetUserDataReqMessage message)
        {
            var plr = session.Player;
            if (message.UserData.ChannelId > 0 && !plr.SentPlayerList && plr.Channel != null)
            {
                // We can't send the channel player list in Channel.Join because the client only accepts it here :/
                plr.SentPlayerList = true;
                var data = plr.Channel.Players.Values.Select(p => p.Map<Player, UserDataWithNickDto>()).ToArray();
                await session.SendAsync(new SChannelPlayerListAckMessage(data))
                    .ConfigureAwait(false);
            }

            // Tutorial reward logic
            const uint tutorialRoomId = 0xFFFFFFFD;
            const uint tutorialReward = 5000;
            const byte tutorialDone = 2;

            if (message.UserData.RoomId == tutorialRoomId)
            {
                plr.InTutorial = true;
            }
            else if (plr.InTutorial)
            {
                plr.InTutorial = false;

                if (plr.TutorialState != tutorialDone)
                {
                    plr.TutorialState = tutorialDone;
                    plr.PEN += tutorialReward;
                    plr.Save();

                    plr.Session?.SendAsync(new Netsphere.Network.Message.Game.SRefreshCashInfoAckMessage(plr.PEN, plr.AP));
                }
            }

            // Save settings if any of them changed
            var settings = plr.Settings;
            var name = nameof(UserDataDto.AllowCombiInvite);
            if (!settings.Contains(name) || settings.Get<CommunitySetting>(name) != message.UserData.AllowCombiInvite)
                settings.AddOrUpdate(name, message.UserData.AllowCombiInvite);

            name = nameof(UserDataDto.AllowFriendRequest);
            if (!settings.Contains(name) || settings.Get<CommunitySetting>(name) != message.UserData.AllowFriendRequest)
                settings.AddOrUpdate(name, message.UserData.AllowFriendRequest);

            name = nameof(UserDataDto.AllowRoomInvite);
            if (!settings.Contains(name) || settings.Get<CommunitySetting>(name) != message.UserData.AllowRoomInvite)
                settings.AddOrUpdate(name, message.UserData.AllowRoomInvite);

            name = nameof(UserDataDto.AllowInfoRequest);
            if (!settings.Contains(name) || settings.Get<CommunitySetting>(name) != message.UserData.AllowInfoRequest)
                settings.AddOrUpdate(name, message.UserData.AllowInfoRequest);
        }

        [MessageHandler(typeof(CGetUserDataReqMessage))]
        public async Task GetUserDataHandler(ChatSession session, CGetUserDataReqMessage message)
        {
            var plr = session.Player;
            if (plr.Account.Id == message.AccountId)
            {
                await session.SendAsync(new SUserDataAckMessage(plr.Map<Player, UserDataDto>()))
                    .ConfigureAwait(false);
                return;
            }

            Player target;
            if (!plr.Channel.Players.TryGetValue(message.AccountId, out target))
                return;

            switch (target.Settings.Get<CommunitySetting>(nameof(UserDataDto.AllowInfoRequest)))
            {
                case CommunitySetting.Deny:
                    // Not sure if there is an answer to this
                    return;

                case CommunitySetting.FriendOnly:
                    // ToDo
                    return;
            }

            await session.SendAsync(new SUserDataAckMessage(target.Map<Player, UserDataDto>()))
                .ConfigureAwait(false);
        }

        [MessageHandler(typeof(CDenyChatReqMessage))]
        public async Task DenyHandler(ChatServer service, ChatSession session, CDenyChatReqMessage message)
        {
            var plr = session.Player;

            if (message.Deny.AccountId == plr.Account.Id)
                return;

            Deny deny;
            switch (message.Action)
            {
                case DenyAction.Add:
                    if (plr.DenyManager.Contains(message.Deny.AccountId))
                        return;

                    var target = GameServer.Instance.PlayerManager[message.Deny.AccountId];
                    if (target == null)
                        return;

                    deny = plr.DenyManager.Add(target);
                    await session.SendAsync(new SDenyChatAckMessage(0, DenyAction.Add, deny.Map<Deny, DenyDto>()))
                        .ConfigureAwait(false);
                    break;

                case DenyAction.Remove:
                    deny = plr.DenyManager[message.Deny.AccountId];
                    if (deny == null)
                        return;

                    plr.DenyManager.Remove(message.Deny.AccountId);
                    await session.SendAsync(new SDenyChatAckMessage(0, DenyAction.Remove, deny.Map<Deny, DenyDto>()))
                        .ConfigureAwait(false);
                    break;
            }
        }
        private static string NicknameOf(ulong accountId)
        {
            var online = GameServer.Instance.PlayerManager[accountId];
            if (online?.Account != null)
                return online.Account.Nickname ?? "";
            using (var authdb = AuthDatabase.Open())
                return authdb.Get(new AccountDto { Id = (int)accountId })?.Nickname ?? "";
        }

        private const uint WirePopupState = 2;
        private const int WirePopupUnk = 0;
        private const uint WireFriendState = 3;
        private const int WireFriendUnk = 2;
        private const uint WireRemovedState = 4;
        private const int WireRemovedUnk = 1;
        private const uint WireDeclinedState = 5;
        private const int WireDeclinedUnk = 3;

        private const uint RelPendingOut = 1;
        private const uint RelPendingIn = 2;
        private const uint RelFriend = 3;

        public static void PushFriendAck(Player to, ulong accountId, string nick, uint state, int unk)
        {
            to?.ChatSession?.SendAsync(new SFriendAckMessage
            {
                Result = 0,
                Unk = unk,
                Friend = new FriendDto { AccountId = accountId, Nickname = nick ?? "", State = state }
            });
        }

        private static void SendFriendList(Player p)
        {
            if (p?.ChatSession == null)
                return;
            var friends = p.Friends.Where(kv => kv.Value == RelFriend).Select(kv => new FriendDto
            {
                AccountId = kv.Key,
                Nickname = NicknameOf(kv.Key),
                State = WireFriendState
            }).ToArray();
            p.ChatSession.SendAsync(new SFriendListAckMessage(friends));
        }

        private static PlayerFriendDto FindFriendRow(IDbConnection db, ulong a, ulong b)
        {
            return db.Find<PlayerFriendDto>(s => s
                .Where($"({nameof(PlayerFriendDto.PlayerId):C} = @A AND {nameof(PlayerFriendDto.FriendId):C} = @B) OR ({nameof(PlayerFriendDto.PlayerId):C} = @B AND {nameof(PlayerFriendDto.FriendId):C} = @A)")
                .WithParameters(new { A = (int)a, B = (int)b })).FirstOrDefault();
        }

        private static void SetStates(IDbConnection db, PlayerFriendDto row, ulong meId, uint myState, uint otherState)
        {
            if (row.PlayerId == (int)meId)
            {
                row.PlayerState = (int)myState;
                row.FriendState = (int)otherState;
            }
            else
            {
                row.FriendState = (int)myState;
                row.PlayerState = (int)otherState;
            }
            db.Update(row);
        }

        public static void SyncFriendsOnLogin(Player p)
        {
            if (p?.ChatSession == null)
                return;
            var friends = p.Friends.Where(kv => kv.Value == RelFriend).Select(kv => new FriendDto
            {
                AccountId = kv.Key,
                Nickname = NicknameOf(kv.Key),
                State = WireFriendState
            }).ToArray();
            p.ChatSession.SendAsync(new SFriendListAckMessage(friends));

            foreach (var kv in p.Friends.Where(kv => kv.Value == RelPendingIn).ToArray())
                PushFriendAck(p, kv.Key, NicknameOf(kv.Key), WirePopupState, WirePopupUnk);
        }

        [MessageHandler(typeof(CFriendReqMessage))]
        public void FriendRequest(ChatSession session, CFriendReqMessage message)
        {
            var me = session.Player;
            if (me?.Account == null || message.AccountId == me.Account.Id)
                return;

            var targetId = message.AccountId;
            var targetNick = message.Nickname;

            if (targetId == 0 && !string.IsNullOrWhiteSpace(message.Nickname))
            {
                var byNick = GameServer.Instance.PlayerManager.Get(message.Nickname);
                if (byNick != null)
                {
                    targetId = byNick.Account.Id;
                    targetNick = byNick.Account.Nickname;
                }
                else
                {
                    using (var authdb = AuthDatabase.Open())
                    {
                        var acc = authdb.Find<AccountDto>(s => s
                            .Where($"{nameof(AccountDto.Nickname):C} = @N")
                            .WithParameters(new { N = message.Nickname })).FirstOrDefault();
                        if (acc != null)
                        {
                            targetId = (ulong)acc.Id;
                            targetNick = acc.Nickname;
                        }
                    }
                }
            }

            if (targetId == 0 || targetId == me.Account.Id)
            {
                session.SendAsync(new SFriendAckMessage(1));
                return;
            }

            var target = GameServer.Instance.PlayerManager[targetId];
            if (string.IsNullOrEmpty(targetNick))
                targetNick = target?.Account?.Nickname ?? NicknameOf(targetId);

            uint removed;
            switch (message.Action)
            {
                case 0:
                    using (var db = GameDatabase.Open())
                    {
                        if (target == null)
                        {
                            using (var authdb = AuthDatabase.Open())
                            {
                                if (authdb.Get(new AccountDto { Id = (int)targetId }) == null)
                                {
                                    session.SendAsync(new SFriendAckMessage(1));
                                    return;
                                }
                            }
                        }

                        if (FindFriendRow(db, me.Account.Id, targetId) != null)
                            return;

                        if (target != null)
                        {
                            var setting = nameof(UserDataDto.AllowFriendRequest);
                            var allows = target.Settings.Contains(setting) &&
                                         target.Settings.Get<CommunitySetting>(setting) == CommunitySetting.Allow;
                            if (!allows)
                            {
                                session.SendAsync(new SFriendAckMessage(1));
                                return;
                            }
                        }

                        db.Insert(new PlayerFriendDto
                        {
                            Id = FriendIdGenerator.GetNextId(),
                            PlayerId = (int)me.Account.Id,
                            FriendId = (int)targetId,
                            PlayerState = (int)RelPendingOut,
                            FriendState = (int)RelPendingIn
                        });
                    }

                    me.Friends[targetId] = RelPendingOut;
                    if (target != null)
                    {
                        target.Friends[me.Account.Id] = RelPendingIn;
                        PushFriendAck(target, me.Account.Id, me.Account.Nickname, WirePopupState, WirePopupUnk);
                    }
                    break;

                case 2:
                    using (var db = GameDatabase.Open())
                    {
                        var row = FindFriendRow(db, me.Account.Id, targetId);
                        if (row == null)
                            return;
                        SetStates(db, row, me.Account.Id, RelFriend, RelFriend);
                    }

                    me.Friends[targetId] = RelFriend;
                    PushFriendAck(me, targetId, targetNick, WireFriendState, WireFriendUnk);

                    if (target != null)
                    {
                        target.Friends[me.Account.Id] = RelFriend;
                        PushFriendAck(target, me.Account.Id, me.Account.Nickname, WireFriendState, WireFriendUnk);
                    }
                    break;

                case 1:
                    using (var db = GameDatabase.Open())
                    {
                        var row = FindFriendRow(db, me.Account.Id, targetId);
                        if (row != null)
                            db.Delete(row);
                    }

                    me.Friends.TryRemove(targetId, out removed);
                    PushFriendAck(me, targetId, targetNick, WireRemovedState, WireRemovedUnk);

                    if (target != null)
                    {
                        target.Friends.TryRemove(me.Account.Id, out removed);
                        SendFriendList(target);
                    }
                    break;

                case 3:
                    using (var db = GameDatabase.Open())
                    {
                        var row = FindFriendRow(db, me.Account.Id, targetId);
                        if (row != null)
                            db.Delete(row);
                    }

                    me.Friends.TryRemove(targetId, out removed);
                    if (target != null)
                    {
                        target.Friends.TryRemove(me.Account.Id, out removed);
                        PushFriendAck(target, me.Account.Id, me.Account.Nickname, WireDeclinedState, WireDeclinedUnk);
                    }
                    break;
            }
        }
    }
}
