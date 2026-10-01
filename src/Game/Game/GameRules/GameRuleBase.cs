using System;
using System.Linq;
using Netsphere.Network.Data.GameRule;
using Netsphere.Network.Message.GameRule;
using Stateless;

namespace Netsphere.Game.GameRules
{
    internal abstract class GameRuleBase
    {
        private static readonly TimeSpan PreHalfTimeWaitTime = TimeSpan.FromSeconds(9);
        private static readonly TimeSpan PreResultWaitTime = TimeSpan.FromSeconds(9);
        private static readonly TimeSpan HalfTimeWaitTime = TimeSpan.FromSeconds(24);
        private static readonly TimeSpan ResultWaitTime = TimeSpan.FromSeconds(14);
        internal bool notInitialBriefing;

        public abstract GameRule GameRule { get; }
        public Room Room { get; }
        public abstract Briefing Briefing { get; }
        public StateMachine<GameRuleState, GameRuleStateTrigger> StateMachine { get; }

        public TimeSpan GameTime { get; private set; }
        public TimeSpan RoundTime { get; private set; }

        protected GameRuleBase(Room room)
        {
            Room = room;
            Room.PlayerJoined += PlayerJoined;
            Room.PlayerJoining += PlayerJoining;
            Room.PlayerLeft += PlayerLeft;
            StateMachine = new StateMachine<GameRuleState, GameRuleStateTrigger>(GameRuleState.Waiting);
            StateMachine.OnTransitioned(StateMachine_OnTransition);
        }

        public virtual void Initialize()
        { }

        public virtual void Cleanup()
        { }

        public virtual void Reload()
        { }

        public virtual void PlayerJoined(object room, RoomPlayerEventArgs e)
        { }

        public virtual void PlayerJoining(object room, RoomPlayerEventArgs e)
        { }

        public virtual void PlayerLeft(object room, RoomPlayerEventArgs e)
        { }

        public virtual void Update(TimeSpan delta)
        {
            RoundTime += delta;
            if (StateMachine.IsInState(GameRuleState.Playing))
            {
                GameTime += delta;

                foreach (var plr in Room.TeamManager.PlayersPlaying)
                {
                    plr.RoomInfo.PlayTime += delta;
                    plr.RoomInfo.CharacterPlayTime[plr.CharacterManager.CurrentSlot] += delta;
                }
            }

            #region HalfTime

            if (StateMachine.IsInState(GameRuleState.EnteringHalfTime))
            {
                if (RoundTime >= PreHalfTimeWaitTime)
                {
                    RoundTime = TimeSpan.Zero;
                    StateMachine.Fire(GameRuleStateTrigger.StartHalfTime);
                }
                else
                {
                    Room.Broadcast(new SEventMessageAckMessage(GameEventMessage.HalfTimeIn, 2, 0, 0,
                        ((int)(PreHalfTimeWaitTime - RoundTime).TotalSeconds + 1).ToString()));
                }
            }

            if (StateMachine.IsInState(GameRuleState.HalfTime))
            {
                if (RoundTime >= HalfTimeWaitTime)
                    StateMachine.Fire(GameRuleStateTrigger.StartSecondHalf);
            }

            #endregion

            #region Result

            if (StateMachine.IsInState(GameRuleState.EnteringResult))
            {
                if (RoundTime >= PreResultWaitTime)
                {
                    RoundTime = TimeSpan.Zero;
                    StateMachine.Fire(GameRuleStateTrigger.StartResult);
                }
                else
                {
                    Room.Broadcast(new SEventMessageAckMessage(GameEventMessage.ResultIn, 3, 0, 0,
                        (int)(PreResultWaitTime - RoundTime).TotalSeconds + 1 + " second(s)"));
                }
            }

            if (StateMachine.IsInState(GameRuleState.Result))
            {
                if (RoundTime >= ResultWaitTime)
                    StateMachine.Fire(GameRuleStateTrigger.EndGame);
            }

            #endregion
        }

        public abstract PlayerRecord GetPlayerRecord(Player plr);
        
        public virtual void OnAttackPointMessage(Player plr, CSlaughterAttackPointReqMessage message)
        { }

        #region Scores

        public virtual void OnScoreKill(Player killer, Player assist, Player target, AttackAttribute attackAttribute)
        {
            killer.RoomInfo.Stats.Kills++;
            killer.TotalKills++;
            killer.stats.Kills++;
            //target.RoomInfo.Stats.Deaths++; //original

            //if (assist != null) //original
            if (target != null)
            {
                //assist.RoomInfo.Stats.KillAssists++;  //originaL
                target.RoomInfo.Stats.Deaths++;
                target.TotalDeaths++;
                target.stats.Deaths++;

                /* Room.Broadcast(
                     new SScoreKillAssistAckMessage(new ScoreAssistDto(killer.RoomInfo.PeerId, assist.RoomInfo.PeerId, //original
                         target.RoomInfo.PeerId, attackAttribute)));  */
                if (assist != null)
               {
                    assist.RoomInfo.Stats.KillAssists++;
                    assist.stats.KillAssists++;

                    Room.Broadcast(
                    new SScoreKillAssistAckMessage(new ScoreAssistDto(killer.RoomInfo.PeerId, assist.RoomInfo.PeerId,
                    target.RoomInfo.PeerId, attackAttribute)));
                }
                else
                {
                    Room.Broadcast(
                    new SScoreKillAckMessage(new ScoreDto(killer.RoomInfo.PeerId, target.RoomInfo.PeerId,
                    attackAttribute)));
                }
            }
            else
            {
                Room.Broadcast(
                    new SScoreKillAckMessage(new ScoreDto(killer.RoomInfo.PeerId, 0,
                    attackAttribute)));
            }           //new SScoreKillAckMessage(new ScoreDto(killer.RoomInfo.PeerId, target.RoomInfo.PeerId, //original
                        //attackAttribute)));
        }

        public virtual void OnScoreTeamKill(Player killer, Player target, AttackAttribute attackAttribute)
        {
            target.RoomInfo.Stats.Deaths++;
            target.TotalDeaths++;
            target.stats.Deaths++;

            Room.Broadcast(
                new SScoreTeamKillAckMessage(new Score2Dto(killer.RoomInfo.PeerId, target.RoomInfo.PeerId,
                    attackAttribute)));
        }

        public virtual void OnScoreHeal(Player plr)
        {
            plr.stats.Heal++;
            Room.Broadcast(new SScoreHealAssistAckMessage(plr.RoomInfo.PeerId));
        }

        public virtual void OnScoreSuicide(Player plr)
        {
            plr.RoomInfo.Stats.Deaths++;
            plr.TotalDeaths++;
            plr.stats.Deaths++;
            Room.Broadcast(new SScoreSuicideAckMessage(plr.RoomInfo.PeerId, AttackAttribute.KillOneSelf));
        }

        #endregion

        private void AccumulateModeStats(Player plr, bool isBattleRoyalFirst)
        {
            if (!plr.stats.IsActive)
                return;

            switch (GameRule)
            {
                case GameRule.Touchdown:
                    var td = plr.RoomInfo.Stats as TouchdownPlayerRecord;
                    if (td != null)
                    {
                        plr.stats.TouchDown.TD += td.TDScore;
                        plr.stats.TouchDown.TDAssist += td.TDAssistScore;
                        plr.stats.TouchDown.Offense += td.OffenseScore;
                        plr.stats.TouchDown.OffenseAssist += td.OffenseAssistScore;
                        plr.stats.TouchDown.Defense += td.DefenseScore;
                        plr.stats.TouchDown.DefenseAssist += td.DefenseAssistScore;
                        plr.stats.TouchDown.OffenseRebound += td.OffenseReboundScore;
                    }
                    break;

                case GameRule.BattleRoyal:
                    var br = plr.RoomInfo.Stats as BattleRoyalPlayerRecord;
                    if (br != null)
                        plr.stats.BattleRoyal.FirstKilled += br.BonusKills;
                    if (isBattleRoyalFirst)
                        plr.stats.BattleRoyal.FirstPlace++;
                    break;

                case GameRule.Captain:
                    var cpt = plr.RoomInfo.Stats as CaptainGameRule.CaptainPlayerRecord;
                    if (cpt != null)
                    {
                        plr.stats.Captain.CPTKilled += cpt.KillCaptains;
                        plr.stats.Captain.CPTCount += cpt.Domination;
                    }
                    break;

                case GameRule.Chaser:
                    var ch = plr.RoomInfo.Stats as ChaserPlayerRecord;
                    if (ch != null)
                    {
                        plr.stats.Chaser.ChaserRounds += ch.ChaserCount;
                        plr.stats.Chaser.ChaserWon += ch.Wins;
                        plr.stats.Chaser.ChasedWon += ch.Survived;
                        plr.stats.Chaser.ChasedRounds += ch.Survived;
                    }
                    break;
            }
        }

        private void StateMachine_OnTransition(StateMachine<GameRuleState, GameRuleStateTrigger>.Transition transition)
        {
            RoundTime = TimeSpan.Zero;

            if (transition.Destination == GameRuleState.FirstHalf || transition.Destination == GameRuleState.Neutral)
            {
                foreach (var plr in Room.TeamManager.Players)
                    plr.stats.OnJoin(this);
            }

            switch (transition.Destination)
            {
                //case GameRuleState.FullGame:
                case GameRuleState.Neutral:
                    GameTime = TimeSpan.Zero;
                    foreach (var team in Room.TeamManager.Values)
                        team.Score = 0;
                    foreach ( // ToDo Use one of the Player properties
                        var plr in
                            Room.TeamManager.Values.SelectMany(
                                team =>
                                    team.Values.Where(
                                        plr =>
                                            plr.RoomInfo.IsReady || Room.Master == plr ||
                                            plr.RoomInfo.Mode == PlayerGameMode.Spectate)))
                    {
                        plr.RoomInfo.Reset();
                        plr.RoomInfo.State = plr.RoomInfo.Mode == PlayerGameMode.Normal
                            ? PlayerState.Alive
                            : PlayerState.Spectating;
                        plr.Session.SendAsync(new SBeginRoundAckMessage());
                    }

                    /*Room.BroadcastBriefing(); //old
                    Room.Broadcast(new SChangeStateAckMessage(GameState.Playing));
                    if (transition.Destination == GameRuleState.FirstHalf)
                        Room.Broadcast(new SChangeSubStateAckMessage(GameTimeState.FirstHalf));
                    break;*/
                    Room.BroadcastBriefing(); //new
                    Room.Broadcast(new SChangeStateAckMessage(GameState.Playing));
                    if (transition.Destination == GameRuleState.Neutral)
                        Room.Broadcast(new SChangeSubStateAckMessage(GameTimeState.Neutral));
                    else
                        Room.Broadcast(new SChangeSubStateAckMessage(GameTimeState.FirstHalf));
                    break;


                case GameRuleState.FirstHalf:
                //case GameRuleState.Neutral:
                    GameTime = TimeSpan.Zero;
                    foreach (var team in Room.TeamManager.Values)
                        team.Score = 0;
                    foreach ( 
                        var plr in
                            Room.TeamManager.Values.SelectMany(
                                team =>
                                    team.Values.Where(
                                        plr =>
                                            plr.RoomInfo.IsReady || Room.Master == plr ||
                                            plr.RoomInfo.Mode == PlayerGameMode.Spectate)))
                    {
                        plr.RoomInfo.Reset();
                        plr.RoomInfo.State = plr.RoomInfo.Mode == PlayerGameMode.Normal
                            ? PlayerState.Alive
                            : PlayerState.Spectating;
                        plr.Session.SendAsync(new SBeginRoundAckMessage());
                    }

                    Room.BroadcastBriefing();
                    Room.Broadcast(new SChangeStateAckMessage(GameState.Playing));
                    Room.Broadcast(new SChangeSubStateAckMessage(GameTimeState.FirstHalf));
                    break;

                case GameRuleState.HalfTime:
                    Room.Broadcast(new SChangeSubStateAckMessage(GameTimeState.HalfTime));
                    break;

                case GameRuleState.SecondHalf:
                    Room.Broadcast(new SChangeSubStateAckMessage(GameTimeState.SecondHalf));
                    break;

                case GameRuleState.Result:
                    foreach (var plr in Room.TeamManager.PlayersPlaying)
                    {
                        foreach (var @char in plr.CharacterManager)
                        {
                            var loss = (int)plr.RoomInfo.CharacterPlayTime[@char.Slot].TotalMinutes *
                                       Config.Instance.Game.DurabilityLossPerMinute;
                            loss += (int)plr.RoomInfo.Stats.Deaths * Config.Instance.Game.DurabilityLossPerDeath;

                            foreach (var item in @char.Weapons.GetItems().Where(item => item != null && item.Durability != -1))
                                item.LoseDurabilityAsync(loss).Wait();

                            foreach (var item in @char.Costumes.GetItems().Where(item => item != null && item.Durability != -1))
                                item.LoseDurabilityAsync(loss).Wait();

                            foreach (var item in @char.Skills.GetItems().Where(item => item != null && item.Durability != -1))
                                item.LoseDurabilityAsync(loss).Wait();
                        }
                    }

                    foreach (var plr in Room.TeamManager.Players.Where(plr => plr.RoomInfo.State != PlayerState.Lobby))
                        plr.RoomInfo.State = PlayerState.Waiting;

                    if (Room.TeamManager.Values.Any())
                    {
                        var maxScore = Room.TeamManager.Values.Max(t => t.Score);
                        var winnerTeam = Room.TeamManager.Values.First(t => t.Score == maxScore).Team;
                        var brFirst = Room.TeamManager.PlayersPlaying
                            .OrderByDescending(p => p.RoomInfo.Stats.TotalScore)
                            .FirstOrDefault();
                        foreach (var plr in Room.TeamManager.PlayersPlaying.ToArray())
                        {
                            plr.TotalMatches++;
                            if (plr.RoomInfo.Team != null && plr.RoomInfo.Team.Team == winnerTeam)
                                plr.stats.Won++;
                            else
                                plr.stats.Loss++;
                            AccumulateModeStats(plr, plr == brFirst);
                        }
                    }

                    Room.Broadcast(new SChangeStateAckMessage(GameState.Result));
                    Room.BroadcastBriefing(true);
                    break;

                case GameRuleState.Waiting:
                    foreach (var plr in Room.TeamManager.Players.Where(plr => plr.RoomInfo.State != PlayerState.Lobby))
                    {
                        plr.RoomInfo.Reset();
                        plr.RoomInfo.State = PlayerState.Lobby;
                    }

                    Room.Broadcast(new SChangeStateAckMessage(GameState.Waiting));
                    Room.BroadcastBriefing();
                    break;
            }
        }
    }
}