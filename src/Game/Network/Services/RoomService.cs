﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using BlubLib.DotNetty.Handlers.MessageHandling;
using Netsphere.Game.GameRules;
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

            plr.Room.Broadcast(new SEnterPlayerAckMessage(plr.Account.Id, plr.Account.Nickname, 0, plr.RoomInfo.Mode, 0));
            session.SendAsync(new SChangeMasterAckMessage(plr.Room.Master.Account.Id));
            session.SendAsync(new SChangeRefeReeAckMessage(plr.Room.Host.Account.Id));
            plr.Room.BroadcastBriefing();
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

            bool bugged_room_restriction = true; //Locks chaser rooms to no-intrusion by default when created
            if (message.Room.MatchKey.GameRule != GameRule.Chaser)
                bugged_room_restriction = message.Room.IsNoIntrusion;

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
                IsNoIntrusion = bugged_room_restriction, //<--
                
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
            if (!string.IsNullOrEmpty(room.Options.Password) && !room.Options.Password.Equals(message.Password) && plr.Account.SecurityLevel==SecurityLevel.User)
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
            catch(Exception ex)
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
            plr.Room.Broadcast(new SEventMessageAckMessage(message.Event, session.Player.Account.Id, message.Unk1, message.Value, ""));
            //if (message.Event == GameEventMessage.BallReset && plr == plr.Room.Host)
            //{
            //    plr.Room.Broadcast(new SEventMessageAckMessage(GameEventMessage.BallReset, 0, 0, 0, ""));
            //    return;
            //}

            //if (message.Event != GameEventMessage.StartGame)
            //    return;

            if (plr.Room.GameRuleManager.GameRule.StateMachine.IsInState(GameRuleState.Playing) && plr.RoomInfo.State == PlayerState.Lobby)
            {
                plr.RoomInfo.State = plr.RoomInfo.Mode == PlayerGameMode.Normal
                    ? PlayerState.Alive
                    : PlayerState.Spectating;

                plr.Room.BroadcastBriefing();
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

            var @char = plr.CharacterManager.CurrentCharacter;
            var unk1 = new ChangeAvatarUnk1Dto
            {
                AccountId = plr.Account.Id,
                Skills = @char.Skills.GetItems().Select(item => item?.ItemNumber ?? 0).ToArray(),
                Weapons = @char.Weapons.GetItems().Select(item => item?.ItemNumber ?? 0).ToArray(),
                Costumes = new ItemNumber[(int)CostumeSlot.Max],
                Unk5 = message.Unk1.Unk5,
                Unk6 = message.Unk1.Unk6,
                Unk7 = message.Unk1.Unk7,
                Unk8 = message.Unk1.Unk8,
                Gender = plr.CharacterManager.CurrentCharacter.Gender,
                HP = plr.GetMaxHP(),
                Unk11 = message.Unk1.Unk11
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
                    if (room.Master != plr &&
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
        public void CSlaughterAttackPointReq(GameSession session, CSlaughterAttackPointReqMessage message)
        {
            var plr = session.Player;
            var room = plr.Room;

            //Logger.ForAccount(plr.Account).Information($"Charser Unk1 {message.Unk1}, unk2 {message.Unk2}");

            if (room.Options.MatchKey.GameRule == GameRule.Chaser)
                ((ChaserGameRule)room.GameRuleManager.GameRule).OnScoreAttack(plr, message.Unk1, message.Unk2);

            var resp = new SSlaughterAttackPointAckMessage
            {
                AccountId = message.AccountId,
                Unk1 = message.Unk1,
                Unk2 = message.Unk2
            };

            plr.Room.Broadcast(resp);
        }

        [MessageHandler(typeof(CSlaughterHealPointReqMessage))]
        public void CSlaughterHealPointReqMessage(GameSession session, CSlaughterHealPointReqMessage message)
        {
            var plr = session.Player;
            //Logger.ForAccount(plr.Account).Information($"Charser Unk {message.Unk}");
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
            killer.RoomInfo.PeerId = message.Score.Killer;

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

        [MessageHandler(typeof(CMissionScoreReqMessage))]
        public void CMissionScoreReq(GameSession session, CMissionScoreReqMessage message)
        {
            session.SendAsync(new SMissionScoreAckMessage { Unk1 = session.Player.Account.Id, Unk2 = message.Unk });
            session.SendAsync(new SMissionNotifyAckMessage { Unk = message.Unk });
        }

        [MessageHandler(typeof(CArcadeAttackPointReqMessage))]
        public void CArcadeAttackPointReq(GameSession session, CArcadeAttackPointReqMessage message)
        { }

        [MessageHandler(typeof(CArcadeScoreSyncReqMessage))]
        public void CArcadeScoreSyncReq(GameSession session, CArcadeScoreSyncReqMessage message)
        { }

        [MessageHandler(typeof(CArcadeBeginRoundReqMessage))]
        public void CArcadeBeginRoundReq(GameSession session, CArcadeBeginRoundReqMessage message)
        {
            //Logger.ForAccount(session.Player.Account)
              // .Debug($"Arcade Begin Round {message.Unk1} {message.Unk2}");

            session.SendAsync(new SArcadeBeginRoundAckMessage { Unk1 = message.Unk1, Unk2 = message.Unk2 });
        }

        [MessageHandler(typeof(CArcadeStageClearReqMessage))]
        public void CArcadeStageClearReq(GameSession session, CArcadeStageClearReqMessage message)
        { }

        [MessageHandler(typeof(CArcadeStageFailedReqMessage))]
        public void CArcadeStageFailedReq(GameSession session, CArcadeStageFailedReqMessage message)
        { }

        [MessageHandler(typeof(CArcadeStageInfoReqMessage))]
        public void CArcadeStageInfoReq(GameSession session, CArcadeStageInfoReqMessage message)
        {
            //Logger.ForAccount(session.Player.Account)
               //.Debug($"Arcade Stage Info {message.Unk1} {message.Unk2}");

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
            //Logger.ForAccount(session.Player.Account)
                //.Debug($"Arcade Respawn {message.Unk1} {message.Unk2}");

            session.SendAsync(new SArcadeRespawnAckMessage { Unk = 0 });
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

            var Arcade = ((ArcadeGameRule)room.GameRuleManager.GameRule);
            Arcade.Stage = message.Unk1;
            Arcade.SubStage = message.Unk2;

            room.Broadcast(new SArcadeStageSelectAckMessage { Unk1 = message.Unk1, Unk2 = message.Unk2 });
        }

        [MessageHandler(typeof(CArcadeLoadingSucceesReqMessage))]
        public void CArcadeLoadingSucceesReq(GameSession session, CArcadeLoadingSucceesReqMessage message)
        {
            var plr = session.Player;
            var room = plr.Room;

            var target = room.Players.GetValueOrDefault(plr.Account.Id);
            if (target == null)
                return;

            if (room.Options.MatchKey.GameRule != GameRule.Arcade)
                return;

            var Arcade = ((ArcadeGameRule)room.GameRuleManager.GameRule);

            Arcade.OnLoadingOk(plr);
        }

        #endregion
    }
}
