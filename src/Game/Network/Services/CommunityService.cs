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
            var accountId = message.AccountId & 0x0000FFFFFFFFFFFF;

            if (plr.Account.Id == accountId)
            {
                await session.SendAsync(new SUserDataAckMessage(plr.Map<Player, UserDataDto>()))
                    .ConfigureAwait(false);
                return;
            }

            Player target;
            if (plr.Channel == null || !plr.Channel.Players.TryGetValue(accountId, out target))
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

        private const string CombiFiller = "CampoCombiNose";
        private const int CombiTextCap = 32;
        private const uint WireCombiRequesting = 1;
        private const uint WireCombiAccepted = 2;
        private const uint WireCombiInbox = 2;
        private const uint WireCombiActive = 3;
        private const int AckCombiAdd = 0;
        private const int AckCombiDelete = 1;
        private const int AckCombiAccept = 2;
        private const int AckCombiDeny = 3;

        private static string NormalizeCombiText(string raw)
        {
            raw = (raw ?? "").Trim();
            raw = new string(raw.Where(ch => !char.IsControl(ch)).ToArray());
            return raw.Length > CombiTextCap ? raw.Substring(0, CombiTextCap) : raw;
        }

        private static CombiDto BuildCombiDto(ulong mateId, long exp, long battle, int match, long win, long defeat, uint wireState, string combiTitle, string mateNick, string stamp)
        {
            return new CombiDto
            {
                Unk1 = mateId,
                Unk2 = wireState,
                Unk3 = wireState,
                Unk4 = (uint)match,
                Unk5 = (ulong)exp,
                Unk6 = mateId,
                Unk7 = (ulong)battle,
                Unk8 = (ulong)win,
                Unk9 = (ulong)defeat,
                Unk10 = CombiFiller,
                Unk11 = mateNick ?? "",
                Unk12 = combiTitle ?? "",
                Unk13 = stamp ?? ""
            };
        }

        private static void PushCombiAck(Player to, int result, int slot, CombiDto dto)
        {
            to?.ChatSession?.SendAsync(new SCombiAckMessage(result, slot, dto));
        }

        private static CombiRowDto FindCombiPair(IDbConnection db, ulong a, ulong b)
        {
            return db.Find<CombiRowDto>(s => s
                .Where($"({nameof(CombiRowDto.PlayerId):C} = @A AND {nameof(CombiRowDto.CombiPlayerId):C} = @B) OR ({nameof(CombiRowDto.PlayerId):C} = @B AND {nameof(CombiRowDto.CombiPlayerId):C} = @A)")
                .WithParameters(new { A = (int)a, B = (int)b })).FirstOrDefault();
        }

        private static CombiRowDto FindCombiFor(IDbConnection db, ulong meId, ulong targetValue)
        {
            return db.Find<CombiRowDto>(s => s
                .Where($"({nameof(CombiRowDto.Id):C} = @T OR {nameof(CombiRowDto.PlayerId):C} = @T OR {nameof(CombiRowDto.CombiPlayerId):C} = @T) AND ({nameof(CombiRowDto.PlayerId):C} = @Me OR {nameof(CombiRowDto.CombiPlayerId):C} = @Me)")
                .WithParameters(new { T = (int)targetValue, Me = (int)meId })).FirstOrDefault();
        }

        private static bool CombiNameTaken(IDbConnection db, string name)
        {
            return db.Find<CombiRowDto>(s => s
                .Where($"{nameof(CombiRowDto.CombiName):C} = @N")
                .WithParameters(new { N = name })).Any();
        }

        public static void SendCombiList(Player p)
        {
            if (p?.Account == null || p.ChatSession == null)
                return;

            CombiRowDto[] rows;
            using (var db = GameDatabase.Open())
            {
                rows = db.Find<CombiRowDto>(s => s
                    .Where($"({nameof(CombiRowDto.PlayerId):C} = @Me OR {nameof(CombiRowDto.CombiPlayerId):C} = @Me) AND {nameof(CombiRowDto.State):C} = 1")
                    .WithParameters(new { Me = (int)p.Account.Id })).ToArray();
            }

            var selfId = (ulong)p.Account.Id;
            var entries = rows.Select(row =>
            {
                var ownerId = (ulong)row.PlayerId;
                var mateId = (ulong)row.CombiPlayerId;
                var iAmOwner = selfId == ownerId;
                var otherId = iAmOwner ? mateId : ownerId;

                var nickShown = iAmOwner ? (row.CombiMate ?? "") : NicknameOf(ownerId);
                if (string.IsNullOrWhiteSpace(nickShown))
                    nickShown = "Unknown";

                var wireState = row.State == 1 ? WireCombiAccepted : WireCombiRequesting;

                return BuildCombiDto(otherId, row.Exp, row.Battle, row.MatchCount, row.Win, row.Defeat, wireState, row.CombiName ?? "", nickShown, row.CombiDate ?? "");
            }).ToArray();

            p.ChatSession.SendAsync(new SCombiListAckMessage(entries));
        }

        public static void SyncCombisOnLogin(Player p)
        {
            if (p?.Account == null || p.ChatSession == null)
                return;

            SendCombiList(p);

            CombiRowDto[] pending;
            using (var db = GameDatabase.Open())
            {
                pending = db.Find<CombiRowDto>(s => s
                    .Where($"{nameof(CombiRowDto.CombiPlayerId):C} = @Me AND {nameof(CombiRowDto.State):C} = 0")
                    .WithParameters(new { Me = (int)p.Account.Id })).ToArray();
            }

            foreach (var row in pending)
            {
                var ownerId = (ulong)row.PlayerId;
                var ownerNick = NicknameOf(ownerId);
                if (string.IsNullOrWhiteSpace(ownerNick))
                    ownerNick = "Unknown";

                var inbox = BuildCombiDto(ownerId, row.Exp, row.Battle, row.MatchCount, row.Win, row.Defeat, WireCombiInbox, row.CombiName ?? "", ownerNick, row.CombiDate ?? "");
                PushCombiAck(p, 0, AckCombiAdd, inbox);
            }
        }

        [MessageHandler(typeof(CCombiReqMessage))]
        public void CombiActionReq(ChatSession session, CCombiReqMessage message)
        {
            var me = session.Player;
            if (me?.Account == null)
                return;

            var verb = message.Unk1;
            var targetValue = message.Unk2;
            var mateNick = NormalizeCombiText(message.Unk3);
            var combiTitle = NormalizeCombiText(message.Unk4);
            var stamp = DateTime.Now.ToString("yyyyMMddHHmmss");

            if (verb > 3)
            {
                session.SendAsync(new SCombiAckMessage(1, AckCombiAdd, BuildCombiDto(targetValue, 0, 0, 0, 0, 0, 0, combiTitle, mateNick, stamp)));
                return;
            }

            if (verb == 1)
            {
                CombiRowDto row;
                using (var db = GameDatabase.Open())
                {
                    row = FindCombiFor(db, me.Account.Id, targetValue);
                    if (row == null)
                    {
                        SendCombiList(me);
                        return;
                    }
                    db.Delete(row);
                }

                var ownerId = (ulong)row.PlayerId;
                var mateId = (ulong)row.CombiPlayerId;
                var otherId = ownerId == (ulong)me.Account.Id ? mateId : ownerId;
                var otherNick = NicknameOf(otherId);
                if (string.IsNullOrWhiteSpace(otherNick))
                    otherNick = "Unknown";

                PushCombiAck(me, 0, AckCombiDelete, BuildCombiDto(otherId, 0, 0, 0, 0, 0, WireCombiAccepted, row.CombiName ?? "", otherNick, row.CombiDate ?? ""));
                SendCombiList(me);

                var other = GameServer.Instance.PlayerManager[otherId];
                if (other != null)
                {
                    PushCombiAck(other, 0, AckCombiDelete, BuildCombiDto((ulong)me.Account.Id, 0, 0, 0, 0, 0, WireCombiAccepted, row.CombiName ?? "", me.Account.Nickname ?? "", row.CombiDate ?? ""));
                    SendCombiList(other);
                }
                return;
            }

            // accept Combi
            if (verb == 2)
            {
                CombiRowDto row;
                using (var db = GameDatabase.Open())
                {
                    row = FindCombiFor(db, me.Account.Id, targetValue);
                    if (row == null)
                    {
                        session.SendAsync(new SCombiAckMessage(1, AckCombiAccept, BuildCombiDto(targetValue, 0, 0, 0, 0, 0, 0, combiTitle, mateNick, stamp)));
                        SendCombiList(me);
                        return;
                    }
                    row.State = 1;
                    db.Update(row);
                }

                var ownerId = (ulong)row.PlayerId;
                var mateId = (ulong)row.CombiPlayerId;
                var otherId = ownerId == (ulong)me.Account.Id ? mateId : ownerId;
                var otherNick = NicknameOf(otherId);
                if (string.IsNullOrWhiteSpace(otherNick))
                    otherNick = "Unknown";

                PushCombiAck(me, 0, AckCombiAccept, BuildCombiDto(otherId, row.Exp, row.Battle, row.MatchCount, row.Win, row.Defeat, WireCombiActive, row.CombiName ?? "", otherNick, row.CombiDate ?? ""));
                SendCombiList(me);

                var other = GameServer.Instance.PlayerManager[otherId];
                if (other != null)
                {
                    PushCombiAck(other, 0, AckCombiAccept, BuildCombiDto((ulong)me.Account.Id, row.Exp, row.Battle, row.MatchCount, row.Win, row.Defeat, WireCombiActive, row.CombiName ?? "", me.Account.Nickname ?? "", row.CombiDate ?? ""));
                    SendCombiList(other);
                }
                return;
            }

            // decline Combi
            if (verb == 3)
            {
                CombiRowDto row;
                using (var db = GameDatabase.Open())
                {
                    row = FindCombiFor(db, me.Account.Id, targetValue);
                    if (row == null)
                        return;
                    db.Delete(row);
                }

                var ownerId = (ulong)row.PlayerId;
                var mateId = (ulong)row.CombiPlayerId;
                var otherId = ownerId == (ulong)me.Account.Id ? mateId : ownerId;

                var other = GameServer.Instance.PlayerManager[otherId];
                if (other != null)
                    PushCombiAck(other, 0, AckCombiDeny, BuildCombiDto((ulong)me.Account.Id, 0, 0, 0, 0, 0, WireCombiActive, row.CombiName ?? "", me.Account.Nickname ?? "", row.CombiDate ?? ""));
                return;
            }

            if (string.IsNullOrWhiteSpace(combiTitle))
            {
                session.SendAsync(new SCombiAckMessage(1, AckCombiAdd, BuildCombiDto(targetValue, 0, 0, 0, 0, 0, 0, combiTitle, mateNick, stamp)));
                return;
            }

            var targetId = targetValue;
            var targetNick = mateNick;

            if (targetId == 0 && !string.IsNullOrWhiteSpace(mateNick))
            {
                var byNick = GameServer.Instance.PlayerManager.Get(mateNick);
                if (byNick != null)
                {
                    targetId = (ulong)byNick.Account.Id;
                    targetNick = byNick.Account.Nickname;
                }
                else
                {
                    using (var authdb = AuthDatabase.Open())
                    {
                        var acc = authdb.Find<AccountDto>(s => s
                            .Where($"{nameof(AccountDto.Nickname):C} = @N")
                            .WithParameters(new { N = mateNick })).FirstOrDefault();
                        if (acc != null)
                        {
                            targetId = (ulong)acc.Id;
                            targetNick = acc.Nickname;
                        }
                    }
                }
            }
            else if (targetId != 0)
            {
                using (var authdb = AuthDatabase.Open())
                {
                    var acc = authdb.Get(new AccountDto { Id = (int)targetId });
                    if (acc != null)
                        targetNick = acc.Nickname;
                }
            }

            if (targetId == 0 || targetId == (ulong)me.Account.Id)
            {
                session.SendAsync(new SCombiAckMessage(1, AckCombiDelete, BuildCombiDto(targetValue, 0, 0, 0, 0, 0, 0, combiTitle, mateNick, stamp)));
                return;
            }

            int newId;
            using (var db = GameDatabase.Open())
            {
                if (CombiNameTaken(db, combiTitle) || FindCombiPair(db, me.Account.Id, targetId) != null)
                {
                    session.SendAsync(new SCombiAckMessage(1, AckCombiAdd, BuildCombiDto(targetId, 0, 0, 0, 0, 0, 0, combiTitle, targetNick, stamp)));
                    return;
                }

                newId = CombiIdGenerator.GetNextId();
                db.Insert(new CombiRowDto
                {
                    Id = newId,
                    PlayerId = (int)me.Account.Id,
                    CombiPlayerId = (int)targetId,
                    Exp = 0,
                    Battle = 0,
                    MatchCount = 0,
                    Win = 0,
                    Defeat = 0,
                    CombiName = combiTitle,
                    CombiMate = targetNick,
                    CombiDate = stamp,
                    State = 0
                });
            }

            PushCombiAck(me, 0, AckCombiAdd, BuildCombiDto(targetId, 0, 0, 0, 0, 0, WireCombiActive, combiTitle, targetNick, stamp));
            SendCombiList(me);

            var targetLive = GameServer.Instance.PlayerManager[targetId];
            if (targetLive != null)
            {
                PushCombiAck(targetLive, 0, AckCombiAdd, BuildCombiDto((ulong)me.Account.Id, 0, 0, 0, 0, 0, WireCombiInbox, combiTitle, me.Account.Nickname ?? "", stamp));
                SendCombiList(targetLive);
            }
        }

        [MessageHandler(typeof(CCheckCombiNameReqMessage))]
        public void CombiCheckNameReq(ChatSession session, CCheckCombiNameReqMessage message)
        {
            var me = session.Player;
            if (me?.Account == null)
                return;

            var wanted = NormalizeCombiText(message.Name);
            if (string.IsNullOrWhiteSpace(wanted))
            {
                session.SendAsync(new SCheckCombiNameAckMessage(100, wanted));
                return;
            }

            bool taken;
            using (var db = GameDatabase.Open())
                taken = CombiNameTaken(db, wanted);

            session.SendAsync(new SCheckCombiNameAckMessage(taken ? (uint)100 : (uint)0, wanted));
        }
    }
}
