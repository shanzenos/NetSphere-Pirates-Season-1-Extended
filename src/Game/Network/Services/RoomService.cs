using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using BlubLib.DotNetty.Handlers.MessageHandling;
using ExpressMapper.Extensions;
using Netsphere.Game.GameRules;
using Netsphere.Network.Data.Game;
using Netsphere.Network.Data.GameRule;
using Netsphere.Network.Message.Game;
using Netsphere.Network.Message.GameRule;
using Newtonsoft.Json;
using NLog;
using NLog.Fluent;
using ProudNet.Handlers;

namespace Netsphere.Network.Services
{
    internal class RoomService : ProudMessageHandler
    {
        // ReSharper disable once InconsistentNaming
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();

        [MessageHandler(typeof(CEnterPlayerReqMessage))]
        public void CEnterPlayerReq(GameSession session)
        {
            var plr = session.Player;

            plr.Room.Broadcast(new SEnterPlayerAckMessage(plr.Account.Id, plr.Account.Nickname,
                (byte)plr.RoomInfo.Team.Team, plr.RoomInfo.Mode, (int)plr.TotalExperience));
            session.SendAsync(new SChangeMasterAckMessage(plr.Room.Master.Account.Id));
            session.SendAsync(new SChangeRefeReeAckMessage(plr.Room.Host.Account.Id));
            plr.Room.BroadcastBriefing(false, plr);

            foreach (var other in plr.Room.Players.Values)
            {
                if (other == plr)
                    continue;

                plr.ChatSession?.SendAsync(
                    new Netsphere.Network.Message.Chat.SUserDataAckMessage(
                        other.Map<Player, Netsphere.Network.Data.Chat.UserDataDto>()));

                session.SendAsync(new SAvatarChangeAckMessage(BuildAvatar(other, null), Array.Empty<ChangeAvatarUnk2Dto>()));

                other.ChatSession?.SendAsync(
                    new Netsphere.Network.Message.Chat.SUserDataAckMessage(
                        plr.Map<Player, Netsphere.Network.Data.Chat.UserDataDto>()));

                other.Session?.SendAsync(new SAvatarChangeAckMessage(BuildAvatar(plr, null), Array.Empty<ChangeAvatarUnk2Dto>()));
            }
        }

        [MessageHandler(typeof(CMakeRoomReqMessage))]
        public void CMakeRoomReq(GameSession session, CMakeRoomReqMessage message)
        {
            var plr = session.Player; 
            if (!plr.Channel.RoomManager.GameRuleFactory.Contains(message.Room.MatchKey.GameRule))
            {
                Logger.Error()
                    .Account(plr)
                    .Message($"Game rule {message.Room.MatchKey.GameRule} does not exist")
                    .Write();
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask));
                return;
            }

            var map = GameServer.Instance.ResourceCache.GetMaps().GetValueOrDefault(message.Room.MatchKey.Map);
            if (map == null)
            {
                Logger.Error()
                    .Account(plr).Message($"Map {message.Room.MatchKey.Map} does not exist")
                    .Write();
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask));
                return;
            }
            if (!map.GameRules.Contains(message.Room.MatchKey.GameRule) && message.Room.MatchKey.GameRule != GameRule.Practice)
            {
                Logger.Error()
                    .Account(plr)
                    .Message($"Map {map.Id}({map.Name}) is not available for game rule {message.Room.MatchKey.GameRule}")
                    .Write();
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask));
                return;
            }

            bool isbalanced = true;
            if (message.Room.IsFriendly)
                isbalanced = false;

            var room = plr.Channel.RoomManager.Create(new RoomCreationOptions
            {
                Name = message.Room.Name,
                MatchKey = message.Room.MatchKey,
                TimeLimit = TimeSpan.FromMinutes(message.Room.TimeLimit),
                ScoreLimit = message.Room.ScoreLimit,
                Password = message.Room.Password,
                IsFriendly = message.Room.IsFriendly,
                IsBalanced = isbalanced, 
                MinLevel = message.Room.MinLevel,
                MaxLevel = message.Room.MaxLevel,
                ItemLimit = message.Room.EquipLimit,
                IsNoIntrusion = message.Room.IsNoIntrusion,

                ServerEndPoint = new IPEndPoint(IPAddress.Parse(Config.Instance.IP), Config.Instance.RelayListener.Port)
            }, RelayServer.Instance.P2PGroupManager.Create(true));

            try
            {
                room.Join(plr);
            }
            catch (RoomAccessDeniedException)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.CantEnterRoom));
            }
            catch (RoomLimitReachedException)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.CantEnterRoom));
            }
            catch (RoomException)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.ImpossibleToEnterRoom));
            }
            catch (Exception ex)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask));
                Logger.Error(ex.Message);
            }
        }

        [MessageHandler(typeof(CGameRoomEnterReqMessage))]
        public void CGameRoomEnterReq(GameSession session, CGameRoomEnterReqMessage message)
        {
            Logger.Debug(JsonConvert.SerializeObject(message, Formatting.Indented));

            var plr = session.Player;
            var room = plr.Channel.RoomManager[message.RoomId];
            if (room == null)
            {
                Logger.Error()
                    .Account(plr)
                    .Message($"Room {message.RoomId} in channel {plr.Channel.Id} not found")
                    .Write();
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.ImpossibleToEnterRoom));
                return;
            }

            if (room.IsChangingRules)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.RoomChangingRules));
                return;
            }
            if (!string.IsNullOrEmpty(room.Options.Password) && !room.Options.Password.Equals(message.Password) && plr.Account.SecurityLevel == SecurityLevel.User)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.PasswordError));
                return;
            }
            try
            {
                room.Join(plr);
            }
            catch (RoomAccessDeniedException)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.CantEnterRoom));
            }
            catch (RoomLimitReachedException)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.CantEnterRoom));
            }
            catch (RoomException)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.ImpossibleToEnterRoom));
            }
            catch (Exception ex)
            {
                session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask));
                Logger.Error(ex.Message);
            }
        }

        [MessageHandler(typeof(CJoinTunnelInfoReqMessage))]
        public void CJoinTunnelInfoReq(GameSession session)
        {
            var plr = session.Player;
            plr.Room.Leave(plr);
        }

        [MessageHandler(typeof(CChangeTeamReqMessage))]
        public void CChangeTeamReq(GameSession session, CChangeTeamReqMessage message)
        {
            var plr = session.Player;

            try
            {
                plr.Room.TeamManager.ChangeTeam(plr, message.Team);
            }
            catch (RoomException ex)
            {
                Logger.Error()
                    .Account(plr)
                    .Exception(ex).Message("Failed to change team to {0}", message.Team)
                    .Write();
            }
        }

        [MessageHandler(typeof(CPlayerGameModeChangeReqMessage))]
        public void CPlayerGameModeChangeReq(GameSession session, CPlayerGameModeChangeReqMessage message)
        {
            var plr = session.Player;

            try
            {
                plr.Room.TeamManager.ChangeMode(plr, message.Mode);
            }
            catch (RoomException ex)
            {
                Logger.Error()
                    .Account(plr)
                    .Exception(ex)
                    .Message($"Failed to change mode to {message.Mode}")
                    .Write();
            }
        }

        private static readonly Random TeamRng = new Random();

        [MessageHandler(typeof(CAutoMixingTeamReqMessage))]
        public void CAutoMixingTeamReq(GameSession session)
        {
            var plr = session.Player;
            var room = plr.Room;

            if (room.Master != plr ||
                !room.GameRuleManager.GameRule.StateMachine.IsInState(GameRuleState.Waiting))
                return;

            var alpha = room.TeamManager[Team.Alpha];
            var beta = room.TeamManager[Team.Beta];
            if (alpha == null || beta == null)
                return;

            var players = room.TeamManager.Players
                .Where(p => p.RoomInfo.Mode == PlayerGameMode.Normal)
                .OrderBy(p => TeamRng.Next())
                .ToArray();

            for (var i = 0; i < players.Length; i++)
            {
                var target = (i % 2) == 0 ? alpha : beta;
                if (players[i].RoomInfo.Team == target)
                    continue;

                try
                {
                    target.Join(players[i]);
                }
                catch (TeamLimitReachedException)
                {
                    // The other team is full, do not fill
                }
            }

            room.BroadcastBriefing();
        }

        [MessageHandler(typeof(CAutoAssingTeamReqMessage))]
        public void CAutoAssingTeamReq(GameSession session, CAutoAssingTeamReqMessage message)
        {
            var plr = session.Player;
            var room = plr.Room;

            if (room.Master != plr ||
                !room.GameRuleManager.GameRule.StateMachine.IsInState(GameRuleState.Waiting))
                return;

            var alpha = room.TeamManager[Team.Alpha];
            var beta = room.TeamManager[Team.Beta];
            if (alpha == null || beta == null)
                return;

            // Fill based on which side has less players
            while (true)
            {
                var from = alpha.Players.Count() > beta.Players.Count() ? alpha : beta;
                var to = from == alpha ? beta : alpha;
                if (from.Players.Count() - to.Players.Count() < 2)
                    break;

                var moving = from.Players.LastOrDefault(p => p.RoomInfo.Mode == PlayerGameMode.Normal);
                if (moving == null)
                    break;

                try
                {
                    to.Join(moving);
                }
                catch (TeamLimitReachedException)
                {
                    break;
                }
            }

            room.BroadcastBriefing();
        }

        [MessageHandler(typeof(CMixChangeTeamReqMessage))]
        public void CMixChangeTeamReq(GameSession session, CMixChangeTeamReqMessage message)
        {
            var plr = session.Player;
            var plrToMove = plr.Room.Players.GetValueOrDefault(message.PlayerToMove);
            var plrToReplace = plr.Room.Players.GetValueOrDefault(message.PlayerToReplace);
            var fromTeam = plr.Room.TeamManager[message.FromTeam];
            var toTeam = plr.Room.TeamManager[message.ToTeam];

            if (fromTeam == null || toTeam == null || plrToMove == null ||
                fromTeam != plrToMove.RoomInfo.Team ||
                (plrToReplace != null && toTeam != plrToReplace.RoomInfo.Team))
            {
                session.SendAsync(new SMixChangeTeamFailAckMessage());
                return;
            }

            if (plrToReplace == null)
            {
                try
                {
                    toTeam.Join(plrToMove);
                }
                catch (TeamLimitReachedException)
                {
                    session.SendAsync(new SMixChangeTeamFailAckMessage());
                }
            }
            else
            {
                fromTeam.Leave(plrToMove);
                toTeam.Leave(plrToReplace);
                fromTeam.Join(plrToReplace);
                toTeam.Join(plrToMove);

                plr.Room.Broadcast(new SMixChangeTeamAckMessage(plrToMove.Account.Id, plrToReplace.Account.Id,
                    fromTeam.Team, toTeam.Team));

                // SMixChangeTeamAckMessage alone doesn't seem to change the player list
                plr.Room.BroadcastBriefing();
            }
        }

        [MessageHandler(typeof(CBeginRoundReqMessage))]
        public void CBeginRoundReq(GameSession session)
        {
            var plr = session.Player;
            var stateMachine = plr.Room.GameRuleManager.GameRule.StateMachine;

            if (stateMachine.CanFire(GameRuleStateTrigger.StartGame))
                stateMachine.Fire(GameRuleStateTrigger.StartGame);
            else
                session.SendAsync(new SEventMessageAckMessage(GameEventMessage.CantStartGame, 0, 0, 0, ""));
        }

        [MessageHandler(typeof(CReadyRoundReqMessage))]
        public void CReadyRoundReq(GameSession session)
        {
            var plr = session.Player;

            plr.RoomInfo.IsReady = !plr.RoomInfo.IsReady;
            plr.Room.Broadcast(new SReadyRoundAckMessage(plr.Account.Id, plr.RoomInfo.IsReady));
        }

        [MessageHandler(typeof(CEventMessageReqMessage))]
        public void CEventMessageReq(GameSession session, CEventMessageReqMessage message)
        {
            var plr = session.Player;

            var intruding = plr.Room.GameRuleManager.GameRule.StateMachine.IsInState(GameRuleState.Playing)
                            && plr.RoomInfo.State == PlayerState.Lobby;

            if (intruding)
            {
                plr.RoomInfo.State = plr.RoomInfo.Mode == PlayerGameMode.Normal
                    ? PlayerState.Alive
                    : PlayerState.Spectating;
                //Specific Implementation since in chaser mode it gets called when intrusion from inside the room
                plr.Room.BroadcastBriefing(plr);

                var br = plr.Room.GameRuleManager.GameRule as BattleRoyalGameRule;
                if (br?.First != null)
                    session.SendAsync(new SGameRuleChangeTheFirstAckMessage(br.First.Account.Id));
            }

            plr.Room.Broadcast(new SEventMessageAckMessage(message.Event, session.Player.Account.Id, message.Unk1, message.Value, ""));

            if (intruding && plr.RoomInfo.State == PlayerState.Dead)
            {
                var room = plr.Room;
                Task.Delay(TimeSpan.FromSeconds(5)).ContinueWith(_ =>
                {
                    if (plr.Room != room || plr.RoomInfo.State != PlayerState.Dead)
                        return;

                    room.Broadcast(new SPlayerGameModeChangeAckMessage(plr.Account.Id, PlayerGameMode.Observer));
                });
            }
        }

        [MessageHandler(typeof(CItemsChangeReqMessage))]
        public void CItemsChangeReq(GameSession session, CItemsChangeReqMessage message)
        {
            var plr = session.Player;

            Logger.Debug()
                .Account(session)
                .Message($"Item sync - {JsonConvert.SerializeObject(message.Unk1, Formatting.Indented)}")
                .Write();

            if (message.Unk2.Length > 0)
            {
                Logger.Warn()
                    .Account(session)
                    .Message($"Unk2: {JsonConvert.SerializeObject(message.Unk2, Formatting.Indented)}")
                    .Write();
            }

            var @char = plr.CharacterManager.CurrentCharacter;
            var unk1 = new ChangeItemsUnkDto
            {
                AccountId = plr.Account.Id,
                Skills = @char.Skills.GetItems().Select(item => item?.ItemNumber ?? 0).ToArray(),
                Weapons = @char.Weapons.GetItems().Select(item => item?.ItemNumber ?? 0).ToArray(),
                Unk4 = message.Unk1.Unk4,
                Unk5 = message.Unk1.Unk5,
                Unk6 = message.Unk1.Unk6,
                HP = plr.GetMaxHP(),
                Unk8 = message.Unk1.Unk8
            };

            plr.Room.Broadcast(new SItemsChangeAckMessage(unk1, message.Unk2));
        }

        private static ChangeAvatarUnk1Dto BuildAvatar(Player plr, ChangeAvatarUnk1Dto from)
        {
            var @char = plr.CharacterManager.CurrentCharacter;
            var unk1 = new ChangeAvatarUnk1Dto
            {
                AccountId = plr.Account.Id,
                Skills = @char.Skills.GetItems().Select(item => item?.ItemNumber ?? 0).ToArray(),
                Weapons = @char.Weapons.GetItems().Select(item => item?.ItemNumber ?? 0).ToArray(),
                Costumes = new ItemNumber[(int)CostumeSlot.Max],
                Unk5 = from?.Unk5 ?? Array.Empty<int>(),
                Unk6 = from?.Unk6 ?? Array.Empty<int>(),
                Unk7 = from?.Unk7 ?? Array.Empty<int>(),
                Unk8 = from?.Unk8 ?? 0,
                Gender = @char.Gender,
                HP = plr.GetMaxHP(),
                Unk11 = from?.Unk11 ?? 0
            };

            // If no item equipped use the default item the character was created with
            for (CostumeSlot slot = 0; slot < CostumeSlot.Max; slot++)
            {
                var item = plr.CharacterManager.CurrentCharacter.Costumes.GetItem(slot)?.ItemNumber ?? 0;
                switch (slot)
                {
                    case CostumeSlot.Hair:
                        if (item == 0)
                            item = @char.Hair.ItemNumber;
                        break;

                    case CostumeSlot.Face:
                        if (item == 0)
                            item = @char.Face.ItemNumber;
                        break;

                    case CostumeSlot.Shirt:
                        if (item == 0)
                            item = @char.Shirt.ItemNumber;
                        break;

                    case CostumeSlot.Pants:
                        if (item == 0)
                            item = @char.Pants.ItemNumber;
                        break;

                    case CostumeSlot.Gloves:
                        if (item == 0)
                            item = @char.Gloves.ItemNumber;
                        break;

                    case CostumeSlot.Shoes:
                        if (item == 0)
                            item = @char.Shoes.ItemNumber;
                        break;
                }
                unk1.Costumes[(int)slot] = item;
            }

            return unk1;
        }

        [MessageHandler(typeof(CAvatarChangeReqMessage))]
        public void CAvatarChangeReq(GameSession session, CAvatarChangeReqMessage message)
        {
            var plr = session.Player;

            Logger.Debug()
                .Account(session)
                .Message($"Avatar sync - {JsonConvert.SerializeObject(message.Unk1, Formatting.Indented)}")
                .Write();

            if (message.Unk2.Length > 0)
            {
                Logger.Warn()
                    .Account(session)
                    .Message($"Unk2: {JsonConvert.SerializeObject(message.Unk2, Formatting.Indented)}")
                    .Write();
            }

            var unk1 = BuildAvatar(plr, message.Unk1);
            plr.Room.Broadcast(new SAvatarChangeAckMessage(unk1, message.Unk2));
        }

        [MessageHandler(typeof(CChangeRuleNotifyReqMessage))]
        public void CChangeRuleNotifyReq(GameSession session, CChangeRuleNotifyReqMessage message)
        {
            session.Player.Room.ChangeRules(message.Settings);
        }

        [MessageHandler(typeof(CLeavePlayerRequestReqMessage))]
        public void CLeavePlayerRequestReq(GameSession session, CLeavePlayerRequestReqMessage message)
        {
            var plr = session.Player;
            var room = plr.Room;

            switch (message.Reason)
            {
                case RoomLeaveReason.Kicked:
                    // Only the master can kick people and kick is only allowed in the lobby
                    if (room.Master != plr ||
                        !room.GameRuleManager.GameRule.StateMachine.IsInState(GameRuleState.Waiting))
                        return;
                    break;

                case RoomLeaveReason.AFK:
                    // The client kicks itself when afk is detected
                    if (message.AccountId != plr.Account.Id)
                        return;
                    break;

                default:
                    // Dont allow any other reasons for now
                    return;
            }

            var targetPlr = room.Players.GetValueOrDefault(message.AccountId);
            if (targetPlr == null)
                return;

            room.Leave(targetPlr, message.Reason);
        }

        #region Scores


        [MessageHandler(typeof(CSlaughterAttackPointReqMessage))]
        public void SlaughterAttackPointReq(GameSession session, CSlaughterAttackPointReqMessage message)
        {
            var room = session.Player?.Room;
            if (room?.GameRuleManager.GameRule.GameRule != GameRule.Chaser)
                return;
            //Logger.ForAccount(plr.Account).Information($"Charser Unk {message.Unk}");

            var rule = (ChaserGameRule)room.GameRuleManager.GameRule;
            if (rule.Chaser != session.Player)
                return;

            var target = room.Players.GetValueOrDefault(message.AccountId);
            if (target == null)
                return;

            rule.OnScoreAttack(target, message.Unk1, message.Unk2);
        }

        [MessageHandler(typeof(CSlaughterHealPointReqMessage))]
        public void CSlaughterHealPointReqMessage(GameSession session, CSlaughterHealPointReqMessage message)
        {
            var plr = session.Player;
            //Logger.ForAccount(plr.Account).Information($"Charser Unk {message.Unk}");

            if (plr?.Room == null)
                return;

            var resp = new SSlaughterHealPointAckMessage { AccountId = plr.Account.Id, Unk = message.Unk };
            plr.Room.Broadcast(resp);
        }

        [MessageHandler(typeof(CScoreKillReqMessage))]
        public void CScoreKillReq(GameSession session, CScoreKillReqMessage message)
        {
            var plr = session.Player;
            plr.RoomInfo.PeerId = message.Score.Target;

            var room = plr.Room;
            var killer = room.Players.GetValueOrDefault(message.Score.Killer.AccountId);
            if (killer == null)
                return;

            if (killer != plr && message.Score.Target.AccountId != plr.Account.Id)
                return;

            killer.RoomInfo.PeerId = message.Score.Killer;

            //Only count kills on actual players, not sentry weapons (Unk: 1=Player, 2=Sentry, 3=Sentiforce)
            if (message.Score.Target.PeerId.Unk != 1)
            {
                // Unless it's an arcade NPC, return nothing
                GetArcade(session)?.MonsterKilled(killer);
                return;
            }


            room.GameRuleManager.GameRule.OnScoreKill(killer, null, plr, message.Score.Weapon);
        }

        [MessageHandler(typeof(CScoreKillAssistReqMessage))]
        public void CScoreKillAssistReq(GameSession session, CScoreKillAssistReqMessage message)
        {
            var plr = session.Player;
            plr.RoomInfo.PeerId = message.Score.Target;

            var room = plr.Room;
            var assist = room.Players.GetValueOrDefault(message.Score.Assist.AccountId);
            if (assist == null)
                return;
            assist.RoomInfo.PeerId = message.Score.Assist;

            var killer = room.Players.GetValueOrDefault(message.Score.Killer.AccountId);
            if (killer == null)
                return;
            killer.RoomInfo.PeerId = message.Score.Killer;

            //Only count kills on actual players, not sentry weapons (Unk: 1=Player, 2=Sentry, 3=Sentiforce)
            if (message.Score.Target.PeerId.Unk != 1)
                return;

            room.GameRuleManager.GameRule.OnScoreKill(killer, assist, plr, message.Score.Weapon);
        }

        [MessageHandler(typeof(CScoreOffenseReqMessage))]
        public void CScoreOffenseReq(GameSession session, CScoreOffenseReqMessage message)
        {
            var plr = session.Player;
            plr.RoomInfo.PeerId = message.Score.Target;

            var room = plr.Room;
            var killer = room.Players.GetValueOrDefault(message.Score.Killer.AccountId);
            if (killer == null)
                return;
            killer.RoomInfo.PeerId = message.Score.Killer;

            if (room.Options.MatchKey.GameRule == GameRule.Touchdown)
                ((TouchdownGameRule)room.GameRuleManager.GameRule).OnScoreOffense(killer, null, plr, message.Score.Weapon);
        }

        [MessageHandler(typeof(CScoreOffenseAssistReqMessage))]
        public void CScoreOffenseAssistReq(GameSession session, CScoreOffenseAssistReqMessage message)
        {
            var plr = session.Player;
            plr.RoomInfo.PeerId = message.Score.Target;

            var room = plr.Room;
            var assist = room.Players.GetValueOrDefault(message.Score.Assist.AccountId);
            if (assist == null)
                return;
            assist.RoomInfo.PeerId = message.Score.Assist;

            var killer = room.Players.GetValueOrDefault(message.Score.Killer.AccountId);
            if (killer == null)
                return;
            killer.RoomInfo.PeerId = message.Score.Killer;

            if (room.Options.MatchKey.GameRule == GameRule.Touchdown)
                ((TouchdownGameRule)room.GameRuleManager.GameRule).OnScoreOffense(killer, assist, plr, message.Score.Weapon);
        }

        [MessageHandler(typeof(CScoreDefenseReqMessage))]
        public void CScoreDefenseReq(GameSession session, CScoreDefenseReqMessage message)
        {
            var plr = session.Player;
            plr.RoomInfo.PeerId = message.Score.Target;

            var room = plr.Room;
            var killer = room.Players.GetValueOrDefault(message.Score.Killer.AccountId);
            if (killer == null)
                return;
            killer.RoomInfo.PeerId = message.Score.Killer;

            if (room.Options.MatchKey.GameRule == GameRule.Touchdown)
                ((TouchdownGameRule)room.GameRuleManager.GameRule).OnScoreDefense(killer, null, plr, message.Score.Weapon);
        }

        [MessageHandler(typeof(CScoreDefenseAssistReqMessage))]
        public void CScoreDefenseAssistReq(GameSession session, CScoreDefenseAssistReqMessage message)
        {
            var plr = session.Player;
            plr.RoomInfo.PeerId = message.Score.Target;

            var room = plr.Room;
            var assist = room.Players.GetValueOrDefault(message.Score.Assist.AccountId);
            if (assist == null)
                return;
            assist.RoomInfo.PeerId = message.Score.Assist;

            var killer = room.Players.GetValueOrDefault(message.Score.Killer.AccountId);
            if (killer == null)
                return;
            killer.RoomInfo.PeerId = message.Score.Killer;

            if (room.Options.MatchKey.GameRule == GameRule.Touchdown)
                ((TouchdownGameRule)room.GameRuleManager.GameRule).OnScoreDefense(killer, assist, plr, message.Score.Weapon);
        }

        [MessageHandler(typeof(CScoreTeamKillReqMessage))]
        public void CScoreTeamKillReq(GameSession session, CScoreTeamKillReqMessage message)
        {
            var plr = session.Player;
            plr.RoomInfo.PeerId = message.Score.Target;

            var room = plr.Room;
            var killer = room.Players.GetValueOrDefault(message.Score.Killer.AccountId);
            if (killer == null)
                return;
            killer.RoomInfo.PeerId = message.Score.Killer;

            //Only count kills on actual players, not sentry weapons (Unk: 1=Player, 2=Sentry, 3=Sentiforce)
            if (message.Score.Target.PeerId.Unk != 1)
                return;

            room.GameRuleManager.GameRule.OnScoreTeamKill(killer, plr, message.Score.Weapon);
        }

        [MessageHandler(typeof(CScoreHealAssistReqMessage))]
        public void CScoreHealAssistReq(GameSession session, CScoreHealAssistReqMessage message)
        {
            var plr = session.Player;
            plr.RoomInfo.PeerId = message.Id;

            var room = plr.Room;
            room.GameRuleManager.GameRule.OnScoreHeal(plr);
        }

        [MessageHandler(typeof(CScoreSuicideReqMessage))]
        public void CScoreSuicideReq(GameSession session, CScoreSuicideReqMessage message)
        {
            var plr = session.Player;
            plr.RoomInfo.PeerId = message.Id;

            //Only count kills on actual players, not sentry weapons (Unk: 1=Player, 2=Sentry, 3=Sentiforce)
            if (message.Id.PeerId.Unk != 1)
                return;

            var room = plr.Room;
            room.GameRuleManager.GameRule.OnScoreSuicide(plr);
        }

        [MessageHandler(typeof(CScoreReboundReqMessage))]
        public void CScoreReboundReq(GameSession session, CScoreReboundReqMessage message)
        {
            var plr = session.Player;
            var room = plr.Room;

            Player newPlr = null;
            Player oldPlr = null;

            if (message.NewId != 0)
                newPlr = room.Players.GetValueOrDefault(message.NewId.AccountId);

            if (message.OldId != 0)
                oldPlr = room.Players.GetValueOrDefault(message.OldId.AccountId);

            if (newPlr != null)
                newPlr.RoomInfo.PeerId = message.NewId;

            if (oldPlr != null)
                oldPlr.RoomInfo.PeerId = message.OldId;

            if (room.Options.MatchKey.GameRule == GameRule.Touchdown)
                ((TouchdownGameRule)room.GameRuleManager.GameRule).OnScoreRebound(newPlr, oldPlr);
        }

        [MessageHandler(typeof(CScoreGoalReqMessage))]
        public void CScoreGoalReq(GameSession session, CScoreGoalReqMessage message)
        {
            var plr = session.Player;
            var room = plr.Room;

            var target = room.Players.GetValueOrDefault(message.PeerId.AccountId);
            if (target == null)
                return;
            target.RoomInfo.PeerId = message.PeerId;

            if (room.Options.MatchKey.GameRule == GameRule.Touchdown)
                ((TouchdownGameRule)room.GameRuleManager.GameRule).OnScoreGoal(target);
        }

        private static ArcadeGameRule GetArcade(GameSession session)
        {
            var room = session.Player?.Room;
            if (room == null || room.Options.MatchKey.GameRule != GameRule.Arcade)
                return null;

            return room.GameRuleManager.GameRule as ArcadeGameRule;
        }

        [MessageHandler(typeof(CMissionScoreReqMessage))]
        public void CMissionScoreReq(GameSession session, CMissionScoreReqMessage message)
        {
            session.SendAsync(new SMissionScoreAckMessage { Unk1 = session.Player.Account.Id, Unk2 = message.Unk });
            session.SendAsync(new SMissionNotifyAckMessage { Unk = message.Unk });
        }

        [MessageHandler(typeof(CArcadeAttackPointReqMessage))]
        public void CArcadeAttackPointReq(GameSession session, CArcadeAttackPointReqMessage message)
        {
            GetArcade(session)?.AttackPoint(session.Player, message.Unk);
        }

        [MessageHandler(typeof(CArcadeScoreSyncReqMessage))]
        public void CArcadeScoreSyncReq(GameSession session, CArcadeScoreSyncReqMessage message)
        {
            var arcade = GetArcade(session);
            arcade?.ScoreSync(message.Scores);
        }

        [MessageHandler(typeof(CArcadeBeginRoundReqMessage))]
        public void CArcadeBeginRoundReq(GameSession session, CArcadeBeginRoundReqMessage message)
        {
            var arcade = GetArcade(session);
            if (arcade == null)
            {
                session.SendAsync(new SArcadeBeginRoundAckMessage { Unk1 = message.Unk1, Unk2 = message.Unk2 });
                return;
            }
            arcade.StageBegin(session.Player);
        }

        [MessageHandler(typeof(CArcadeStageClearReqMessage))]
        public void CArcadeStageClearReq(GameSession session, CArcadeStageClearReqMessage message)
        {
            var arcade = GetArcade(session);
            arcade?.StageClear(message.Scores);
        }

        [MessageHandler(typeof(CArcadeStageFailedReqMessage))]
        public void CArcadeStageFailedReq(GameSession session, CArcadeStageFailedReqMessage message)
        { }

        [MessageHandler(typeof(CArcadeStageInfoReqMessage))]
        public void CArcadeStageInfoReq(GameSession session, CArcadeStageInfoReqMessage message)
        {
            //Logger.ForAccount(session.Player.Account)
            //.Debug($"Arcade Stage Info {message.Unk1} {message.Unk2}");
            GetArcade(session)?.StageInfo(message.Unk1, (byte)message.Unk2);

            session.SendAsync(new SArcadeStageInfoAckMessage { Unk1 = message.Unk1, Unk2 = message.Unk2 });
        }

        [MessageHandler(typeof(CArcadeEnablePlayTimeReqMessage))]
        public void CArcadeEnablePlayTimeReq(GameSession session, CArcadeEnablePlayTimeReqMessage message)
        {
            //Logger.ForAccount(session.Player.Account)
            //.Debug($"Arcade Playtime {message.Unk}");

            session.SendAsync(new SArcadeEnablePlayeTimeAckMessage { Unk = message.Unk });
        }

        [MessageHandler(typeof(CArcadeRespawnReqMessage))]
        public void CArcadeRespawnReq(GameSession session, CArcadeRespawnReqMessage message)
        {
            var arcade = GetArcade(session);
            if (arcade == null)
            {
                session.SendAsync(new SArcadeRespawnAckMessage { Unk = 0 });
                return;
            }
            arcade.Respawn(session.Player);
        }

        [MessageHandler(typeof(CArcadeStageReadyReqMessage))]
        public void CArcadeStageReadyReq(GameSession session, CArcadeStageReadyReqMessage message)
        {
            //Logger.ForAccount(session.Player.Account)
            //.Debug($"Arcade Stage Ready {message.Unk1} {message.Unk2}");

            session.Player.Room.Broadcast(new SArcadeStageReadyAckMessage { AccountId = session.Player.Account.Id });
        }

        [MessageHandler(typeof(CArcadeStageSelectReqMessage))]
        public void CArcadeStageSelectReq(GameSession session, CArcadeStageSelectReqMessage message)
        {
            var plr = session.Player;
            var room = plr.Room;

            if (room.Options.MatchKey.GameRule != GameRule.Arcade)
                return;

            ((ArcadeGameRule)room.GameRuleManager.GameRule).StageSelect(message.Unk1, message.Unk2);
        }

        [MessageHandler(typeof(CArcadeLoadingSucceesReqMessage))]
        public void CArcadeLoadingSucceesReq(GameSession session, CArcadeLoadingSucceesReqMessage message)
        {

            var plr = session.Player;

            if (plr?.Room == null || (plr.Room.GameRuleManager.GameRule.GameRule != GameRule.Arcade))
                return;

            session.SendAsync(new SArcadeLoadingSucceedAckMessage { AccountId = session.Player.Account.Id });
        }

        #endregion
    }
}
