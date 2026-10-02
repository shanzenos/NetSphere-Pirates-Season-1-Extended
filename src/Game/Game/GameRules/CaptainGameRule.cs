using System;
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
        private static readonly TimeSpan s_captainRoundTime = TimeSpan.FromMinutes(3);
        private readonly CaptainHelper _captainHelper;
        private readonly IList<Player> _intruders = new List<Player>();
        private uint _currentRound;
        private int _roundLimit;
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

            //Captain doesn't have half-time in it's gamestate
            StateMachine.Configure(GameRuleState.Waiting)
                .PermitIf(GameRuleStateTrigger.StartGame, GameRuleState.Neutral, CanStartGame);

            StateMachine.Configure(GameRuleState.Neutral)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.StartResult, GameRuleState.EnteringResult)
                .OnEntry(StartRound);

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

            _roundLimit = Room.Options.TimeLimit.Minutes;
            Room.Options.TimeLimit = s_captainRoundTime;
            _nextRoundTime = TimeSpan.Zero;
            _subRoundTime = TimeSpan.Zero;
            _waitingNextRound = false;
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

                    // Time limit of the room is the number of rounds in this mode
                    if (_currentRound >= _roundLimit)
                        StateMachine.Fire(GameRuleStateTrigger.StartResult);



                    _captainHelper.Update(delta);

                    if (_waitingNextRound)
                    {
                        _nextRoundTime += delta;
                        if (_nextRoundTime >= s_captainNextroundTime)
                        {
                            StartRound();
                            _waitingNextRound = false;
                        }
                    }
                    else
                    {
                        if (_captainHelper.RoundOver())
                        {
                            SubRoundEnd();
                            return;
                        }

                        // Rounds are 3 minutes, room time is based on number of rounds
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

        public void IntrudeCompleted(Player plr)
        {
            var record = plr.RoomInfo.Stats as CaptainPlayerRecord;
            if (record != null)
                record.IsCaptain = false;

            if (!_intruders.Contains(plr))
                _intruders.Add(plr);

            var timeState = StateMachine.IsInState(GameRuleState.Neutral)
                ? GameTimeState.Neutral
                : GameTimeState.FirstHalf;

            plr.Session?.SendAsync(new SRefreshGameRuleInfoAckMessage(GameState.Playing, timeState,
                (int)RoundTime.TotalMilliseconds));
        }

        public override void PlayerLeft(object room, RoomPlayerEventArgs e)
        {
            base.PlayerLeft(room, e);

            // End round if no-one alive or on enemy team
            if (StateMachine.IsInState(GameRuleState.Playing) && !_waitingNextRound)
            {
                _captainHelper.Dead(e.Player);
                if (_captainHelper.RoundOver())
                    SubRoundEnd();
            }
        }

        public override PlayerRecord GetPlayerRecord(Player plr)
        {
            return new CaptainPlayerRecord(plr);
        }

        public override void OnScoreTeamKill(Player killer, Player target, AttackAttribute attackAttribute)
        {
            _captainHelper.Dead(target);
            base.OnScoreTeamKill(killer, target, attackAttribute);

            if (!_waitingNextRound && _captainHelper.RoundOver())
                SubRoundEnd();
        }

        public override void OnScoreKill(Player killer, Player assist, Player target, AttackAttribute attackAttribute)
        {
            var wasCaptain = _captainHelper.Dead(target);

            base.OnScoreKill(killer, assist, target, attackAttribute);

            if (wasCaptain)
            {
                GetRecord(killer).KillCaptains++;
                if (GetRecord(killer).Kills > 0)
                    GetRecord(killer).Kills--;

                if (assist != null)
                {
                    GetRecord(assist).KillAssistCaptains++;
                    if (GetRecord(assist).KillAssists > 0)
                        GetRecord(assist).KillAssists--;
                }
            }

            if (!_waitingNextRound && _captainHelper.RoundOver())
                SubRoundEnd();
        }

        public override void OnScoreSuicide(Player plr)
        {
            _captainHelper.Dead(plr);
            GetRecord(plr).Suicides++;
            base.OnScoreSuicide(plr);

            if (!_waitingNextRound && _captainHelper.RoundOver())
                SubRoundEnd();
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

        private void StartRound()
        {
            _captainHelper.Reset();
            _subRoundTime = TimeSpan.Zero;

            Room.Broadcast(new SCurrentRoundInformationAckMessage
            {
                Unk1 = (int)_currentRound + 1,
                Unk2 = 0
            });

        }

        private void SubRoundEnd()
        {
            var teamwin = _captainHelper.TeamWin();
            _currentRound++;

            // Increase teamwin score
            if (teamwin != null)
            {
                teamwin.Score++;

                // give all players winRound score
                foreach (var plr in teamwin.PlayersPlaying)
                    GetRecord(plr).WinRound++;
            }

            var teamMgr = Room.TeamManager;

            _nextRoundTime = TimeSpan.Zero;
            _subRoundTime = TimeSpan.Zero;
            _waitingNextRound = true;

            foreach (var intruder in _intruders)
            {
                if (intruder.Room != Room)
                    continue;

                intruder.Session?.SendAsync(new SBriefingAckMessage(false, false, Briefing.ToArray(false)));
            }

            _intruders.Clear();

            // Did we reach ScoreLimit or Round Limit?
            if (_currentRound >= _roundLimit
                || teamMgr.Values.Any(team => team.Score >= Room.Options.ScoreLimit))
            {
                StateMachine.Fire(GameRuleStateTrigger.StartResult);
                return;
            }

            if (teamwin != null)
            {
                Room.Broadcast(
                    new SCaptainSubRoundEndReasonAckMessage
                    {
                        Unk1 = 3,
                        Unk2 = (byte)teamwin.Team
                    });
            }

            Room.Broadcast(
                new SEventMessageAckMessage(GameEventMessage.NextRoundIn, (ulong)s_captainNextroundTime.TotalMilliseconds, 0, 0, ""));
        }

        private static CaptainPlayerRecord GetRecord(Player plr)
        {
            return (CaptainPlayerRecord)plr.RoomInfo.Stats;
        }

        private void UpdatePlayerStats()
        {
            // todo

            /*
			var WinTeam = Room
                .TeamManager
                .PlayersPlaying
                .Aggregate(
                    (highestTeam, player) =>
                    (highestTeam == null || player.RoomInfo.Team.Score > highestTeam.RoomInfo.Team.Score) ?
                    player : highestTeam).RoomInfo.Team;
					*/

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

            private readonly List<Player> _alpha = new List<Player>();
            private readonly List<Player> _beta = new List<Player>();

            public CaptainHelper(Room room)
            {
                Room = room;
            }

            public void Reset()
            {
                _alpha.Clear();
                _beta.Clear();

                foreach (var plr in Room.TeamManager.PlayersPlaying)
                {
                    if (plr.RoomInfo.Team == null)
                        continue;

                    if (plr.RoomInfo.Team.Team == Team.Alpha)
                        _alpha.Add(plr);
                    else if (plr.RoomInfo.Team.Team == Team.Beta)
                        _beta.Add(plr);
                }

                var life = (_alpha.Count > _beta.Count ? _alpha.Count : _beta.Count) * 500.0f;

                var alphaLife = life / Math.Max(1, _alpha.Count);
                var betaLife = life / Math.Max(1, _beta.Count);

                var players = _alpha.Select(plr => new CaptainLifeDto { AccountId = plr.Account.Id, HP = alphaLife })
                    .Concat(_beta.Select(plr => new CaptainLifeDto { AccountId = plr.Account.Id, HP = betaLife }))
                    .ToArray();

                foreach (var plr in _alpha.Concat(_beta))
                {
                    plr.RoomInfo.State = PlayerState.Alive;

                    var record = plr.RoomInfo.Stats as CaptainPlayerRecord;
                    if (record != null)
                        record.IsCaptain = true;
                }

                Room.Broadcast(new SCaptainLifeRoundSetUpAckMessage { Players = players });
                Room.Broadcast(new SEventMessageAckMessage(GameEventMessage.ResetRound, 0, 0, 0, ""));
            }

            public bool Dead(Player target)
            {
                if (!(_alpha.Remove(target) | _beta.Remove(target)))
                    return false;

                var record = target.RoomInfo?.Stats as CaptainPlayerRecord;
                if (record != null)
                    record.IsCaptain = false;

                return true;
            }

            public bool RoundOver()
            {
                return _alpha.Count == 0 || _beta.Count == 0;
            }

            public PlayerTeam TeamWin()
            {
                if (_alpha.Count == 0)
                    return Room.TeamManager.GetValueOrDefault(Team.Beta);

                if (_beta.Count == 0)
                    return Room.TeamManager.GetValueOrDefault(Team.Alpha);

                if (_alpha.Count > _beta.Count)
                    return Room.TeamManager.GetValueOrDefault(Team.Alpha);

                if (_beta.Count > _alpha.Count)
                    return Room.TeamManager.GetValueOrDefault(Team.Beta);

                var alphaScore = _alpha.Sum(plr => (long)plr.RoomInfo.Stats.TotalScore);
                var betaScore = _beta.Sum(plr => (long)plr.RoomInfo.Stats.TotalScore);

                if (alphaScore > betaScore)
                    return Room.TeamManager.GetValueOrDefault(Team.Alpha);

                if (betaScore > alphaScore)
                    return Room.TeamManager.GetValueOrDefault(Team.Beta);

                return null;
            }

            public void Update(TimeSpan delta)
            {
                var playing = Room.TeamManager.PlayersPlaying.ToArray();
                _alpha.RemoveAll(plr => !playing.Contains(plr));
                _beta.RemoveAll(plr => !playing.Contains(plr));
            }
        }

        internal class CaptainBriefing : Briefing
        {
            public CaptainBriefing(GameRuleBase RuleBase)
                : base(RuleBase)
            {
            }

            protected override void WriteData(BinaryWriter w, bool isResult)
            {
                base.WriteData(w, isResult);

                var gameRule = (CaptainGameRule)GameRule;

                w.Write((int)gameRule._currentRound);
                w.Write(0);
                w.Write(0);
                w.Write(0);
                w.Write(0);
                w.Write(0);
            }
        }

        internal class CaptainPlayerRecord : PlayerRecord
        {
            public override uint TotalScore
            {
                get
                {
                    var earned = (5 * (KillCaptains + WinRound)) + KillAssistCaptains + (2 * Kills) + KillAssists + Heal;
                    return Suicides >= earned ? 0 : earned - Suicides;
                }
            }
            public uint KillCaptains { get; set; }
            public uint KillAssistCaptains { get; set; }
            public uint WinRound { get; set; }
            public uint Heal { get; set; }
            public uint Domination { get; set; }
            public bool IsCaptain { get; set; }

            public CaptainPlayerRecord(Player plr)
                : base(plr)
            {
            }

            public override void Serialize(BinaryWriter w, bool isResult)
            {
                base.Serialize(w, isResult);

                w.Write(Kills);
                w.Write(KillAssists);
                w.Write(Heal);
                w.Write(0);
                w.Write(0);
                w.Write(0);
                w.Write(KillAssistCaptains);
                w.Write(KillCaptains);
                w.Write(WinRound);
                w.Write(Deaths);
                w.Write(IsCaptain);
                w.Write(0);
            }

            public override void Reset()
            {
                base.Reset();
                KillCaptains = 0;
                KillAssistCaptains = 0;
                Heal = 0;
                WinRound = 0;
                Domination = 0;
                IsCaptain = false;
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
