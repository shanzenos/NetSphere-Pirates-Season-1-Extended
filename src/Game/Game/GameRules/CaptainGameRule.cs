﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Netsphere.Game.Systems;
using Netsphere.Network.Data.GameRule;
using Netsphere.Network.Message.GameRule;

namespace Netsphere.Game.GameRules
{
    internal class CaptainGameRule : GameRuleBase
    {
        private static readonly TimeSpan s_captainNextroundTime = TimeSpan.FromSeconds(12);
        private static readonly TimeSpan s_captainRoundTime = TimeSpan.FromMinutes(5);
        private readonly CaptainHelper _captainHelper;
        private uint _currentRound;
        private TimeSpan _nextRoundTime = TimeSpan.Zero;
        private TimeSpan _subRoundTime = TimeSpan.Zero;
        private bool _waitingNextRound;

        public override GameRule GameRule => GameRule.Captain;
        public override Briefing Briefing { get; }

        public CaptainGameRule(Room room)
            : base(room)
        {
            Briefing = new CaptainBriefing(this);
            _captainHelper = new CaptainHelper(room);

            StateMachine.Configure(GameRuleState.Waiting)
                .PermitIf(GameRuleStateTrigger.StartGame, GameRuleState.Neutral, CanStartGame);

            StateMachine.Configure(GameRuleState.Neutral)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.StartResult, GameRuleState.EnteringResult)
                .OnEntry(_captainHelper.Reset);

            StateMachine.Configure(GameRuleState.EnteringResult)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.StartResult, GameRuleState.Result);

            StateMachine.Configure(GameRuleState.Result)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.EndGame, GameRuleState.Waiting)
                .OnEntry(UpdatePlayerStats);
        }

        public override void Initialize()
        {

            var teamMgr = Room.TeamManager;
            teamMgr.Add(Team.Alpha, (uint)(Room.Options.MatchKey.PlayerLimit / 2), (uint)(Room.Options.MatchKey.SpectatorLimit / 2));
            teamMgr.Add(Team.Beta, (uint)(Room.Options.MatchKey.PlayerLimit / 2), (uint)(Room.Options.MatchKey.SpectatorLimit / 2));
            _currentRound = 0;
            base.Initialize();
        }

        public override void Update(TimeSpan delta)
        {
            base.Update(delta);

            var teamMgr = Room.TeamManager;

            if (StateMachine.IsInState(GameRuleState.Playing) &&
                !StateMachine.IsInState(GameRuleState.EnteringResult) &&
                !StateMachine.IsInState(GameRuleState.Result) &&
                RoundTime >= TimeSpan.FromSeconds(5)) // Let the round run for at least 5 seconds - Fixes StartResult trigger on game start(race condition)
            {
                // Still have enough players?
                var min = teamMgr.Values.Min(team =>
                team.Values.Count(plr =>
                    plr.RoomInfo.State != PlayerState.Lobby &&
                    plr.RoomInfo.State != PlayerState.Spectating));
                if (min == 0)
                    StateMachine.Fire(GameRuleStateTrigger.StartResult);

                if (StateMachine.IsInState(GameRuleState.Neutral))
                {
                    // Did we reach ScoreLimit?
                    if (teamMgr.Values.Any(team => team.Score >= Room.Options.ScoreLimit))
                        StateMachine.Fire(GameRuleStateTrigger.StartResult);

                    // Did we reach round limit?
                    if (_currentRound >= Room.Options.TimeLimit.Minutes)
                        StateMachine.Fire(GameRuleStateTrigger.StartResult);

                    _captainHelper.Update(delta);

                    if (_waitingNextRound)
                    {
                        _nextRoundTime += delta;
                        if (_nextRoundTime >= s_captainNextroundTime)
                        {
                            _captainHelper.Reset();
                            _waitingNextRound = false;
                        }
                    }
                    else
                    {
                        if (_captainHelper.Any())
                        {
                            SubRoundEnd();
                            return;
                        }

                        _subRoundTime += delta;
                        if (_subRoundTime >= s_captainRoundTime)
                            SubRoundEnd();
                    }
                }
            }
        }

        public override void Cleanup()
        {
            var teamMgr = Room.TeamManager;
            teamMgr.Remove(Team.Alpha);
            teamMgr.Remove(Team.Beta);
            base.Cleanup();
        }

        public override void PlayerLeft(object room, RoomPlayerEventArgs e)
        {
            if (StateMachine.IsInState(GameRuleState.FirstHalf))
                //e.Player.CaptainMode.Loss++;

                base.PlayerLeft(room, e);
        }

        public override PlayerRecord GetPlayerRecord(Player plr)
        {
            return new CaptainPlayerRecord(plr);
        }

        public override void OnScoreTeamKill(Player killer, Player target, AttackAttribute attackAttribute)
        {
            //if (_captainHelper.Dead(target) && _captainHelper.Any())
            //    SubRoundEnd();

            GetRecord(target).Deaths++;

            base.OnScoreTeamKill(killer, target, attackAttribute);
        }

        public override void OnScoreKill(Player killer, Player assist, Player target, AttackAttribute attackAttribute)
        {
            if (_captainHelper.Dead(target))
            {
                //if (_captainHelper.Any())
                //    SubRoundEnd();

                GetRecord(killer).KillCaptains++;
                //killer.CaptainMode.CPTKilled++;
                if (assist != null)
                    GetRecord(assist).KillAssistCaptains++;
            }
            else
            {
                GetRecord(killer).Kills++;
                if (assist != null)
                    GetRecord(assist).KillAssists++;
            }

            GetRecord(target).Deaths++;

            base.OnScoreKill(killer, null, target, attackAttribute);
        }

        public override void OnScoreSuicide(Player plr)
        {
            //if (_captainHelper.Dead(plr) && _captainHelper.Any())
            //    SubRoundEnd();

            GetPlayerRecord(plr).Suicides++;

            base.OnScoreSuicide(plr);
        }

        private bool CanStartGame()
        {
            if (!StateMachine.IsInState(GameRuleState.Waiting))
                return false;

            var teams = Room.TeamManager.Values.ToArray();
            if (teams.Any(team => team.Count == 0)) // Do we have enough players?
                return false;

            // Is atleast one player per team ready?
            return teams.All(team => team.Players.Any(plr => plr.RoomInfo.IsReady || Room.Master == plr));
        }

        private void SubRoundEnd()
        {
            var teamwin = _captainHelper.TeamWin();
            _currentRound++;

            var teamMgr = Room.TeamManager;

            // Did we reach ScoreLimit or Round Limit?
            if (_currentRound >= Room.Options.TimeLimit.Minutes
                || teamMgr.Values.Any(team => team.Score >= Room.Options.ScoreLimit))
            {
                StateMachine.Fire(GameRuleStateTrigger.StartResult);
            }
            else
            {
                Room.Broadcast(
                    new SCaptainSubRoundEndReasonAckMessage
                    {
                        Unk1 = 0,
                        Unk2 = (byte)(teamwin.Team == Team.Alpha ? 1 : 2)
                    });
                Room.Broadcast(
                    new SEventMessageAckMessage(GameEventMessage.NextRoundIn, (ulong)s_captainNextroundTime.TotalMilliseconds, 0, 0, ""));

                _nextRoundTime = TimeSpan.Zero;
                _waitingNextRound = true;
            }

            teamwin.Players.First().RoomInfo.Team.Score++;

            _subRoundTime = TimeSpan.Zero;
        }

        private static CaptainPlayerRecord GetRecord(Player plr)
        {
            return (CaptainPlayerRecord)plr.RoomInfo.Stats;
        }

        private void UpdatePlayerStats()
        {
            var WinTeam = Room
                .TeamManager
                .PlayersPlaying
                .Aggregate(
                    (highestTeam, player) =>
                    (highestTeam == null || player.RoomInfo.Team.Score > highestTeam.RoomInfo.Team.Score) ?
                    player : highestTeam).RoomInfo.Team;

            /*foreach (var plr in Room.TeamManager.PlayersPlaying)
            {
                if (plr.RoomInfo.Team == WinTeam)
                    plr.CaptainMode.Won++;
                else
                    plr.CaptainMode.Loss++;
            }
        }*/
        }

        internal class CaptainHelper
        {
            public Room Room { get; }

            private IEnumerable<Player> _alpha;
            private IEnumerable<Player> _beta;
            private float _teamLife;

            public CaptainHelper(Room room)
            {
                Room = room;
                _alpha = from plr in Room.TeamManager.PlayersPlaying
                         where plr.RoomInfo.Team.Team == Team.Alpha
                         select plr;

                _beta = from plr in Room.TeamManager.PlayersPlaying
                        where plr.RoomInfo.Team.Team == Team.Beta
                        select plr;
            }

            public void Reset()
            {
                _alpha = from plr in Room.TeamManager.PlayersPlaying
                         where plr.RoomInfo.Team.Team == Team.Alpha
                         select plr;

                _beta = from plr in Room.TeamManager.PlayersPlaying
                        where plr.RoomInfo.Team.Team == Team.Beta
                        select plr;

                float max = (_alpha.Count() > _beta.Count()) ? _alpha.Count() : _beta.Count();

                _teamLife = max * 500.0f;

                var players = (from plr in Room.TeamManager.PlayersPlaying
                               select new CaptainLifeDto { AccountId = plr.Account.Id, HP = _teamLife / plr.RoomInfo.Team.Count() })
                              .ToArray();

                foreach (var plr in Room.TeamManager.PlayersPlaying)
                {
                    plr.RoomInfo.State = PlayerState.Alive;
                    //plr.CaptainMode.CPTCount++;
                }

                Room.Broadcast(new SCaptainLifeRoundSetUpAckMessage { Players = players });
                Room.Broadcast(new SEventMessageAckMessage(GameEventMessage.ResetRound, 0, 0, 0, ""));
            }

            public bool Dead(Player target)
            {
                if (target.RoomInfo.Team.Team == Team.Alpha)
                {
                    var isCaptain = (from plr in _alpha
                                     where plr == target
                                     select plr).Any();

                    _alpha = from plr in _alpha
                             where plr != target
                             select plr;

                    target.Room.Broadcast(new SCurrentRoundInformationAckMessage { Unk1 = _alpha.Count(), Unk2 = _beta.Count() });

                    return isCaptain;
                }

                if (target.RoomInfo.Team.Team == Team.Beta)
                {
                    var isCaptain = (from plr in _beta
                                     where plr == target
                                     select plr).Any();

                    _beta = from plr in _beta
                            where plr != target
                            select plr;

                    target.Room.Broadcast(new SCurrentRoundInformationAckMessage { Unk1 = _alpha.Count(), Unk2 = _beta.Count() });

                    return isCaptain;
                }

                return false;// we need this?
            }

            public bool Any()
            {
                return !_alpha.Any() || !_beta.Any();
            }

            public PlayerTeam TeamWin()
            {
                if (!_alpha.Any())
                    return Room.TeamManager.GetValueOrDefault(Team.Beta);

                if (!_beta.Any())
                    return Room.TeamManager.GetValueOrDefault(Team.Alpha);

                return (_alpha.Count() > _beta.Count()) ?
                    Room.TeamManager.GetValueOrDefault(Team.Alpha) :
                    Room.TeamManager.GetValueOrDefault(Team.Beta);
            }

            public void Update(TimeSpan delta)
            {
                _alpha = from plr in Room.TeamManager.PlayersPlaying
                         join oplr in _alpha on plr equals oplr
                         select plr;

                _beta = from plr in Room.TeamManager.PlayersPlaying
                        join oplr in _beta on plr equals oplr
                        select plr;
            }
        }

        internal class CaptainBriefing : Briefing
        {
            int Unk1;
            int Unk2;
            int Unk3;
            int Unk4;
            int Unk5;
            int Unk6;

            public CaptainBriefing(GameRuleBase RuleBase)
                : base(RuleBase)
            {
                Unk1 = 1;
                Unk2 = 2;
                Unk3 = 3;
                Unk4 = 4;
                Unk5 = 5;
                Unk6 = 6;
            }

            protected override void WriteData(BinaryWriter w, bool isResult)
            {
                base.WriteData(w, isResult);

                var gameRule = (CaptainGameRule)GameRule;

                w.Write(Unk1);
                w.Write(Unk2);
                w.Write(Unk3);
                w.Write(Unk4);
                w.Write(Unk5);
                w.Write(Unk6);
            }
        }

        internal class CaptainPlayerRecord : PlayerRecord
        {
            public override uint TotalScore => (5 * (WinRound + KillCaptains)) + (2 * Kills) + KillAssists + Heal - Suicides;
            public uint KillCaptains { get; set; }
            public uint KillAssistCaptains { get; set; }
            public uint WinRound { get; set; }
            public uint Heal { get; set; }
            public uint Domination { get; set; }

            public CaptainPlayerRecord(Player plr)
                : base(plr)
            {
            }

            public override void Serialize(BinaryWriter w, bool isResult)
            {
                base.Serialize(w, isResult);

                w.Write(KillCaptains);
                w.Write(KillAssistCaptains);
                w.Write(Kills);
                w.Write(KillAssists);
                w.Write(Heal);
                w.Write(WinRound);
                w.Write(Domination); // Here go domination score?
            }

            public override void Reset()
            {
                base.Reset();
                KillCaptains = 0;
                KillAssistCaptains = 0;
                Heal = 0;
            }

            /*public override uint GetExpGain(out uint bonusExp)
            {
                return GetExpGain(Config.Instance.Game.CaptainExpRates, out bonusExp);
            }

            public override uint GetPenGain(out uint bonusPen)
            {
                return GetPenGain(Config.Instance.Game.CaptainExpRates, out bonusPen);
            }*/
        }
    }
}
