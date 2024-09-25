using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using BlubLib.IO;
using Netsphere.Network;
using Netsphere.Network.Message.GameRule;
//using Serilog;
//using Serilog.Core;

// ReSharper disable once CheckNamespace
namespace Netsphere.Game.GameRules
{
    internal class ChaserGameRule : GameRuleBase
    {
        private const uint PlayersNeededToStart = 2; // ToDo change to 4

        private static readonly TimeSpan s_nextChaserWaitTime = TimeSpan.FromSeconds(10);
        private static readonly TimeSpan s_spanTime = TimeSpan.FromSeconds(1);
        private readonly Random _random = new Random();

        private TimeSpan _chaserRoundTime;
        private TimeSpan _chaserTimer;
        private TimeSpan _nextChaserTimer;

        private bool _waitingNextChaser;
        private Player _bonus;

        public override GameRule GameRule => GameRule.Chaser;
        public override Briefing Briefing { get; }

        public Player Chaser { get; private set; }
        public Player Bonus
        {
            get { return _bonus; }
            private set
            {
                if (_bonus == value)
                    return;
                _bonus = value;
                if (StateMachine.IsInState(GameRuleState.Playing))
                    Room.Broadcast(new SChangeBonusTargetAckMessage(_bonus?.Account.Id ?? 0));
            }
        }

        public ChaserGameRule(Room room)
            : base(room)
        {
            Briefing = new ChaserBriefing(this);

            StateMachine.Configure(GameRuleState.Waiting)
                .PermitIf(GameRuleStateTrigger.StartGame, GameRuleState.Neutral, CanStartGame);

            StateMachine.Configure(GameRuleState.Neutral)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.StartResult, GameRuleState.EnteringResult)
                .OnEntry(() =>
                {
                    _waitingNextChaser = true;
                    NextChaser();
                });

            StateMachine.Configure(GameRuleState.EnteringResult)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.StartResult, GameRuleState.Result);

            StateMachine.Configure(GameRuleState.Result)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.EndGame, GameRuleState.Waiting)
                .OnEntry(() =>
                {
                    Bonus = null;
                    Chaser = null;
                    Room.Broadcast(new SChangeSlaughtererAckMessage(0));//fix for chaser display after match
                });
        }

        public override void Initialize() //fixed player displays
        {

            var playersPerTeam = Room.Options.MatchKey.PlayerLimit / 2;
            var spectatorsPerTeam = Room.Options.MatchKey.SpectatorLimit / 2;
            Room.TeamManager.Add(Team.Alpha, (uint)Room.Options.MatchKey.PlayerLimit, (uint)Room.Options.MatchKey.SpectatorLimit);
            Room.TeamManager.Add(Team.Beta, (uint)Room.Options.MatchKey.PlayerLimit, (uint)Room.Options.MatchKey.SpectatorLimit);

            base.Initialize();

        }

        public override void Cleanup()
        {
            Room.TeamManager.Remove(Team.Alpha);
            Room.TeamManager.Remove(Team.Beta);

            base.Cleanup();
        }

        public override void PlayerLeft(object room, RoomPlayerEventArgs e)
        {
            if (StateMachine.IsInState(GameRuleState.FirstHalf))
            base.PlayerLeft(room, e);
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
                // Still have enough players? (original implementation)
                /*if (
                (teamMgr.PlayersPlaying.Count() < PlayersNeededToStart)
                || (RoundTime >= Room.Options.TimeLimit)
                )
                {
                    StateMachine.Fire(GameRuleStateTrigger.StartResult);
                }
                */

                if (teamMgr.PlayersPlaying.Count() < PlayersNeededToStart) ///new result trigger
                    StateMachine.Fire(GameRuleStateTrigger.StartResult);

                if (RoundTime >= Room.Options.TimeLimit)
                    StateMachine.Fire(GameRuleStateTrigger.StartResult); ///new result trigger

                if (_waitingNextChaser)
                {
                    _nextChaserTimer += delta;
                    if (_nextChaserTimer >= s_nextChaserWaitTime)
                        NextChaser();
                }
                else
                {
                    _chaserTimer += delta;
                    if (_chaserTimer >= _chaserRoundTime)
                    {
                        var diff = Room.Options.TimeLimit - RoundTime;
                        if (diff >= _chaserRoundTime + s_nextChaserWaitTime)
                            ChaserLose();
                    }

                    if (_chaserTimer > s_spanTime && !GetPlayersAlive().Any())
                        ChaserWin();
                }
            }
        }

        public override PlayerRecord GetPlayerRecord(Player plr)
        {
            return new ChaserPlayerRecord(plr);
        }

        public override void OnScoreKill(Player killer, Player assist, Player target, AttackAttribute attackAttribute)  //old score kill
        {
            var stats = GetRecord(killer);
            stats.Kills++;
            //target.RoomInfo.State = PlayerState.Dead;

            if (killer == Chaser && target == Bonus)
            {
                stats.BonusKills++;
                Bonus = GetBonus();
            }

            target.RoomInfo.State = PlayerState.Dead;
            NextTarget();

            if (Chaser == target)
                ChaserLose();
            
            base.OnScoreKill(killer, null, target, attackAttribute);
        }
        
        public override void OnScoreSuicide(Player plr)
        {
            //plr.RoomInfo.State = PlayerState.Dead;

            if (Chaser == plr)
                ChaserLose();

            plr.RoomInfo.State = PlayerState.Dead;
            NextTarget();

            base.OnScoreSuicide(plr);
        }

        public void NextTarget()
        {
            var targetfound = false;
            var targetchances = new Dictionary<Player, int>();

            foreach (var plr in Room.TeamManager.PlayersPlaying.OrderBy(g => Guid.NewGuid()))
                if (plr.RoomInfo.State == PlayerState.Alive && plr != Chaser)
                    if (!targetfound)
                    {
                        Bonus = plr;
                        targetfound = true;
                        Room.Broadcast(new SChangeBonusTargetAckMessage(Bonus.Account.Id));
                    }
        }

        public void OnScoreAttack(Player plr, float unk1, float unk2)
        {
            var stats = GetRecord(plr);
            stats.Unk17 = unk1;
            stats.Unk18 = unk2;
        }

        public void RoundEnd()
        {
            _waitingNextChaser = true;
            _nextChaserTimer = TimeSpan.Zero;
            Room.Broadcast(new SEventMessageAckMessage(GameEventMessage.ChaserIn, (ulong)s_nextChaserWaitTime.TotalMilliseconds, 0, 0, ""));
        }

        public void NextChaser()
        {
            // Set round time (round time broken, using 60 sec for all players)
            _chaserRoundTime = TimeSpan.FromSeconds(60);
            _chaserRoundTime += TimeSpan.FromSeconds(Chaser != null ? 3 : 6);

            // Pool all the players in the room
            var ChaserCandidates = from plr in Room.TeamManager.PlayersPlaying
                    let stats = GetRecord(plr)
              select new { Player = plr };

            // something something Chaser timer
            _chaserTimer = TimeSpan.Zero;

            // Select a Chaser at random from the Chaser pool
            // Limit max trys to get a new chaser, prevent get stuck
            var _newChaserFounded = false;
            for (var trys = 0; trys < 10; trys++)
            {
                var index = _random.Next(0, ChaserCandidates.Count());
                var candidate = ChaserCandidates.ElementAt(index).Player;
                if (candidate == null)
                    continue;

                Chaser = ChaserCandidates.ElementAt(index).Player;
                break;
            }

            if (!_newChaserFounded)
            {
                var index = _random.Next(0, ChaserCandidates.Count());
                Chaser = ChaserCandidates.ElementAt(index).Player;
            }

            // Set everyone alive for the next round
            foreach (var plr in Room.TeamManager.PlayersPlaying)
            {
                plr.RoomInfo.State = PlayerState.Alive;
            }

            // Increase the Chaser's Chaser count in the Tab Screen
            GetRecord(Chaser).ChaserCount++;

           
            if (GetPlayersAlive() == null)
            {
                StateMachine.Fire(GameRuleStateTrigger.StartResult);
                return;
            }

            Bonus = GetBonus();
            Room.Broadcast(new SChangeSlaughtererAckMessage(
                Chaser.Account.Id,
                Room.TeamManager.PlayersPlaying
                .Where(plr => plr != Chaser)
                .Select(plr => plr.Account.Id).ToArray()
                ));
            NextTarget();
            _waitingNextChaser = false;
        }

        public void ChaserWin()
        {
            if (_waitingNextChaser)
                return;

            GetRecord(Chaser).Wins++;
            Room.Broadcast(new SScoreSLRoundWinAckMessage());
            RoundEnd();
        }

        public void ChaserLose()
        {
            if (_waitingNextChaser)
                return;

                foreach (var plr in GetPlayersAlive())
                GetRecord(plr).Survived++;
            Room.Broadcast(new SScoreRoundWinAckMessage());
            RoundEnd();
        }

        private bool CanStartGame()
        {
            if (!StateMachine.IsInState(GameRuleState.Waiting))
                return false;

            var countReady = Room.TeamManager.Values.Sum(team => team.Values.Count(plr => plr.RoomInfo.IsReady));
            if (countReady < PlayersNeededToStart - 1) // Sum doesn't include master so decrease players needed by 1
                return false;
            return true;
        }

        private Player GetBonus()
        {
            return GetPlayersAlive()
                .Aggregate((highestPlayer, player) => (highestPlayer == null || player.RoomInfo.Stats.TotalScore > highestPlayer.RoomInfo.Stats.TotalScore ? player : highestPlayer));
        }

        private IEnumerable<Player> GetPlayersAlive()
        {
            return Room.TeamManager.PlayersPlaying.Where(plr => plr != Chaser && plr.RoomInfo.State == PlayerState.Alive);
        }

        private static ChaserPlayerRecord GetRecord(Player plr)
        {
            return (ChaserPlayerRecord)plr.RoomInfo.Stats;
        }
    }

    internal class ChaserBriefing : Briefing
    {
        public long CurrentChaser { get; set; }
        public long CurrentChaserTarget { get; set; }

        public int Unk3 { get; set; }
        public int Unk4 { get; set; }
        public int Unk5 { get; set; }
        public int Unk6 { get; set; } //  *(_BYTE *)(v7 + 60) = v23 == 1;

        public IList<int> Unk7 { get; set; }
        public IList<long> Unk8 { get; set; }
        public IList<long> Unk9 { get; set; }

        public ChaserBriefing(GameRuleBase gameRule)
            : base(gameRule)
        {
            Unk7 = new List<int>();
            Unk8 = new List<long>();
            Unk9 = new List<long>();
        }

        protected override void WriteData(BinaryWriter w, bool isResult)
        {
            base.WriteData(w, isResult);

            var gameRule = (ChaserGameRule)GameRule;
            CurrentChaser = (long)(gameRule.Chaser?.Account.Id ?? 0);
            CurrentChaserTarget = (long)(gameRule.Bonus?.Account.Id ?? 0);
            //Unk8.Add(CurrentChaser); ///data from later ver
            //Unk9.Add(CurrentChaser); ///data from later ver
            //Unk6 = 1; ///Default is enabled, but seems buggy

            w.Write(CurrentChaser);
            w.Write(CurrentChaserTarget);

            w.Write(Unk3);
            w.Write(Unk4);
            w.Write(Unk5);
            w.Write(Unk6);

            w.Write(Unk7.Count);
            w.Write(Unk7);

            w.Write(Unk8.Count);
            w.Write(Unk8);

            w.Write(Unk9.Count);
            w.Write(Unk9);
        }
    }

    internal class ChaserPlayerRecord : PlayerRecord //last score code
    {
        public override uint TotalScore => GetTotalScore();

        public uint Unk1 { get; set; }
        public uint Unk2 { get; set; }
        public uint Unk3 { get; set; }
        public uint Unk4 { get; set; }
        public uint BonusKills { get; set; }
        public uint Unk5 { get; set; }
        public uint Unk6 { get; set; }
        public uint Unk7 { get; set; }
        public uint Unk8 { get; set; }
        public uint Wins { get; set; }
        public uint Survived { get; set; }
        public uint Unk9 { get; set; }
        public uint Unk10 { get; set; }
        public uint ChaserCount { get; set; }
        public uint Unk11 { get; set; }
        public uint Unk12 { get; set; }
        public uint Unk13 { get; set; }
        public uint Unk14 { get; set; }
        public uint Unk15 { get; set; }
        public uint Unk16 { get; set; }

        public float Unk17 { get; set; }
        public float Unk18 { get; set; }
        public float Unk19 { get; set; }
        public float Unk20 { get; set; }

        public byte Unk21 { get; set; }

        public ChaserPlayerRecord(Player plr)
            : base(plr)
        { }

        public override void Serialize(BinaryWriter w, bool isResult)
        {
            base.Serialize(w, isResult);

            w.Write(Unk1);
            w.Write(Unk2);
            w.Write(Unk3);
            w.Write(Unk4);
            w.Write(Kills);
            w.Write(BonusKills);
            w.Write(Unk5);
            w.Write(Unk6);
            w.Write(Unk7);
            w.Write(Unk8);
            w.Write(Wins);
            w.Write(Survived);
            w.Write(Unk9);
            w.Write(Unk10);
            w.Write(ChaserCount);
            w.Write(Unk11);
            w.Write(Unk12);
            w.Write(Unk13);
            w.Write(Unk14);
            w.Write(Unk15);
            w.Write(Unk16);

            w.Write(Unk17);
            w.Write(Unk18);
            w.Write(Unk19);
            w.Write(Unk20);

            w.Write(Unk21);
        }

        public override void Reset()
        {
            base.Reset();

            Unk1 = 0;
            Unk2 = 0;
            Unk3 = 0;
            Unk4 = 0;
            Kills = 0;
            BonusKills = 0;
            Unk5 = 0;
            Unk6 = 0;
            Unk7 = 0;
            Unk8 = 0;
            Wins = 0;
            Survived = 0;
            Unk9 = 0;
            Unk10 = 0;
            ChaserCount = 0;
            Unk11 = 0;
            Unk12 = 0;
            Unk13 = 0;
            Unk14 = 0;
            Unk15 = 0;
            Unk16 = 0;
            Unk17 = 0;
            Unk18 = 0;
            Unk19 = 0;
            Unk20 = 0;
            Unk21 = 0;
        }

        private uint GetTotalScore()
        {
            return Kills * 2 +
                BonusKills * 4 +
                Wins * 5 +
                Survived * 10
                + (uint)(Unk17 + Unk18);
        }
        
    }
}
