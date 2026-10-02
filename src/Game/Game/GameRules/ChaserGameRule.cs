using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using BlubLib.IO;
using ExpressMapper.Extensions;
using Netsphere.Network;
using Netsphere.Network.Message.GameRule;

namespace Netsphere.Game.GameRules
{
    internal class ChaserGameRule : GameRuleBase
    {
        private const uint PlayersNeededToStart = 2; // Allow starting with just 2 players

        private static readonly TimeSpan s_nextChaserWaitTime = TimeSpan.FromSeconds(10); //Delay between chaser rounds
        private static readonly TimeSpan s_spanTime = TimeSpan.FromSeconds(1); //Buffer after chaser is chosen
        private readonly Random _random = new Random();

        private TimeSpan _chaserRoundTime; // Time allowed per round
        public TimeSpan _chaserTimer; // Timer for current chaser
        private TimeSpan _nextChaserTimer; // Countdown until next chaser selection

        private bool _waitingNextChaser;
        private bool _roundComplete;
        private Player _bonus; // Bonus target player

        private bool _scoringDisabled = false;

        private Player LastChaser;

        private readonly List<Player> _forcedSpectators = new List<Player>();

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

                // Notify all players of new bonus target
                if (StateMachine.IsInState(GameRuleState.Playing))
                    Room.Broadcast(new SChangeBonusTargetAckMessage(_bonus?.Account.Id ?? 0));
            }
        }

        public ChaserGameRule(Room room)
            : base(room)
        {
            Briefing = new ChaserBriefing(this);

            // Game state transitions
            StateMachine.Configure(GameRuleState.Waiting)
                .PermitIf(GameRuleStateTrigger.StartGame, GameRuleState.Neutral, CanStartGame);

            StateMachine.Configure(GameRuleState.Neutral)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.StartResult, GameRuleState.EnteringResult)
                .OnEntry(() =>
                {
                    _waitingNextChaser = true;
                    NextChaser();
                    notInitialBriefing = true;
                });

            StateMachine.Configure(GameRuleState.EnteringResult)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.StartResult, GameRuleState.Result)
            .OnEntry(() =>
            {
                Bonus = null;
                Chaser = null;
            });

            StateMachine.Configure(GameRuleState.Result)
                .SubstateOf(GameRuleState.Playing)
                .Permit(GameRuleStateTrigger.EndGame, GameRuleState.Waiting)
                .OnEntry(() =>
                {
                    Bonus = null;
                    Chaser = null;
                    _waitingNextChaser = false;

                    foreach (var spectator in _forcedSpectators.ToArray())
                    {
                        _forcedSpectators.Remove(spectator);
                        if (spectator.Room != Room)
                            continue;

                        spectator.RoomInfo.Mode = PlayerGameMode.Normal;
                        Room.Broadcast(new SPlayerGameModeChangeAckMessage(spectator.Account.Id, PlayerGameMode.Normal));
                    }

                    // Fix for chaser display lingering after match ends
                    Room.Broadcast(new SChangeSlaughtererAckMessage(0));
                });
        }

        public override void Initialize()
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
            //if target is in the list of players alive remove it
            var targetPlayersAlive = GetPlayersAlive().ToList();
            foreach (var target in targetPlayersAlive)
            {
                if (target == e.Player)
                {
                    targetPlayersAlive.Remove(e.Player);
                }
            }

            if (StateMachine.IsInState(GameRuleState.Neutral) || StateMachine.IsInState(GameRuleState.Playing))
            {
                base.PlayerLeft(room, e);
                //If chaser is leaving player, set chaser to null & set chaser lose
                if (e.Player == Chaser)
                {
                    Chaser = null;
                    ChaserLose(false);
                }

                else if (e.Player != Chaser)
                {
                    //If player leaving is the target/bonus, set null & fire off next target
                    if (e.Player == Bonus)
                    {
                        Bonus = null;
                        NextTarget();

                    }
                }
            }
        }

        public override void Update(TimeSpan delta)
        {
            base.Update(delta);

            var teamMgr = Room.TeamManager;

            if (StateMachine.IsInState(GameRuleState.Playing) &&
                !StateMachine.IsInState(GameRuleState.EnteringResult) &&
                !StateMachine.IsInState(GameRuleState.Result) &&
                RoundTime >= TimeSpan.FromSeconds(5))
            {
                // Prevent premature result trigger if not enough players
                if (teamMgr.PlayersPlaying.Count() < PlayersNeededToStart)
                    StateMachine.Fire(GameRuleStateTrigger.StartResult);

                if (RoundTime >= Room.Options.TimeLimit)
                    StateMachine.Fire(GameRuleStateTrigger.StartResult);

                // Chaser round time logic
                if (RoundTime >= Room.Options.TimeLimit - _chaserRoundTime)
                {
                    if (!GetPlayersAlive().Any())
                    {
                        ChaserWin();
                    }
                    if (_chaserTimer >= _chaserRoundTime)
                    {
                        ChaserLose();
                    }
                    if (_roundComplete)
                    {
                        StateMachine.Fire(GameRuleStateTrigger.StartResult);
                    }
                }

                if (_waitingNextChaser)
                {
                    // Disable scoring only during intermission
                    _scoringDisabled = true;
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

                    // Chaser wins if no players are alive
                    if (_chaserTimer > s_spanTime && !GetPlayersAlive().Any())
                        ChaserWin();
                }
            }
        }

        public TimeSpan ChaserRoundTime => _chaserRoundTime;
        public TimeSpan ChaserElapsed => _chaserTimer;

        public override PlayerRecord GetPlayerRecord(Player plr)
        {
            return new ChaserPlayerRecord(plr);
        }

        public void OnScoreAttack(Player plr, float unk1, float unk2)
        {
            var stats = GetRecord(plr);
            stats.SwordRanking += 1;
            stats.GunRanking += unk2;

            foreach (var plrInRoom in Room.TeamManager.PlayersPlaying)
            {
                if (Chaser == plrInRoom)
                {
                    // Do nothing, if you send score data to chaser it will duplicate the score
                }
                else
                {
                    // Send Score update packets to remaining players
                    plrInRoom.Session.SendAsync(new SSlaughterAttackPointAckMessage
                    {
                        AccountId = plr.Account.Id,
                        Unk1 = 1,
                        Unk2 = unk2 // Send gun ranking

                    });
                }
            }
        }

        public override void OnScoreKill(Player killer, Player assist, Player target, AttackAttribute attackAttribute)
        {
            // Prevent scoring during intermission or state transitions
            if (_scoringDisabled || !StateMachine.IsInState(GameRuleState.Playing))
            {
                return;
            }

            var stats = GetRecord(killer);

            target.RoomInfo.State = PlayerState.Dead;

            // If no-one left alive, trigger chaser win
            if (!GetPlayersAlive().Any(plr => plr != Chaser))
            {
                ChaserWin();
            }

            // Chaser Loses if they become the target
            if (Chaser == target)
            {
                ChaserLose();
            }

            base.OnScoreKill(killer, null, target, attackAttribute);

            target.RoomInfo.State = PlayerState.Dead;

            if (killer == Chaser && target == Bonus)
            {
                if (stats.Kills > 0)
                    stats.Kills--;
                stats.BonusKills++;

                NextTarget(); // Try to select new bonus target
            }

        }

        // Log scores for players
        private void LogScore(Player player, string phase)
        {
            var record = GetRecord(player);
            Console.WriteLine($"[{phase}] Player: {player.Account.Id}, Kills: {record.Kills}, BonusKills: {record.BonusKills}, TotalScore: {record.TotalScore}");
        }

        public override void OnScoreSuicide(Player plr)
        {
            if (Chaser == plr)
            {
                ChaserLose();
            }

            plr.RoomInfo.State = PlayerState.Dead;

            var targetPlayersAlive = GetPlayersAlive().ToList();
            targetPlayersAlive.Remove(plr);

            List<Player> alivePlayersExceptChaser = new List<Player>();

            foreach (var player in GetPlayersAlive())
            {
                if (player != Chaser)
                {
                    alivePlayersExceptChaser.Add(player);
                }
            }

            List<ulong> playerIds = new List<ulong>();

            foreach (var player in alivePlayersExceptChaser)
            {
                playerIds.Add((ulong)player.Account.Id);
            }

            NextTarget();

            base.OnScoreSuicide(plr);
        }

        public void NextTarget()
        {
            if (!StateMachine.IsInState(GameRuleState.Playing))
                return;
            // WIP
            // Try to select a new bonus target from alive non-chaser players
            Bonus = GetBonus();

            if ( Bonus != null) {
                Room.Broadcast(new SChangeBonusTargetAckMessage(Bonus.Account.Id));// Notify players of new bonus target
            }
            return;
        }

        private Player GetBonus()
        {
            // Return the player with the highest total score that isn't the chaser
            var scoreList = GetPlayersAlive()
                .OrderByDescending(plr => plr.RoomInfo.Stats.TotalScore);

            return scoreList.FirstOrDefault();

        }

        public void ParkIntruder(Player plr)
        {
            plr.RoomInfo.State = PlayerState.Dead;

            if (!_forcedSpectators.Contains(plr))
                _forcedSpectators.Add(plr);

            Room.Broadcast(new SEnterPlayerAckMessage(plr.Account.Id, plr.Account.Nickname,
                (byte)plr.RoomInfo.Team.Team, plr.RoomInfo.Mode, (int)plr.TotalExperience));

            var timeState = StateMachine.IsInState(GameRuleState.Neutral)
                ? GameTimeState.Neutral
                : GameTimeState.FirstHalf;
            plr.Session.SendAsync(new SRefreshGameRuleInfoAckMessage(GameState.Playing, timeState,
                (int)RoundTime.TotalMilliseconds));
        }
        
        public void RoundEnd()
        {
            if (Chaser != null)
                GetRecord(Chaser).ChaserCount++;

            _roundComplete = true;
            _waitingNextChaser = true;
            _nextChaserTimer = TimeSpan.Zero;

            foreach (var spectator in _forcedSpectators)
            {
                if (spectator.Room != Room)
                    continue;

                spectator.Session?.SendAsync(new SBriefingAckMessage(false, false, Briefing.ToArray(false)));
            }

            //Check remaining room time against chaser round time
            var diff = Room.Options.TimeLimit - RoundTime;
            if (diff <= TimeSpan.FromSeconds(30))
            {
                StateMachine.Fire(GameRuleStateTrigger.StartResult);
                return;
            }

            Room.Broadcast(new SEventMessageAckMessage(GameEventMessage.ChaserIn, (ulong)s_nextChaserWaitTime.TotalMilliseconds, 0, 0, ""));
        }

        public void NextChaser()
        {
            _roundComplete = false;

            _scoringDisabled = false;

            foreach (var spectator in _forcedSpectators.ToArray())
            {
                _forcedSpectators.Remove(spectator);
                if (spectator.Room != Room)
                    continue;

                spectator.RoomInfo.Mode = PlayerGameMode.Normal;
                spectator.RoomInfo.State = PlayerState.Alive;
                spectator.RoomInfo.State = PlayerState.Alive;
                Room.Broadcast(new SPlayerGameModeChangeAckMessage(spectator.Account.Id, PlayerGameMode.Normal));

                Room.Broadcast(new SEnterPlayerAckMessage(spectator.Account.Id, spectator.Account.Nickname,
                    (byte)spectator.RoomInfo.Team.Team, PlayerGameMode.Normal, (int)spectator.TotalExperience));

                spectator.Session?.SendAsync(new SBeginRoundAckMessage());
            }

            //Round duration based on player count, TODO: Needs adjusting to specific times per player #
            _chaserRoundTime = Room.Players.Count < 7
                ? TimeSpan.FromSeconds(60)
                : TimeSpan.FromSeconds(Room.Players.Count * 10);
            _chaserRoundTime += TimeSpan.FromSeconds(Chaser != null ? 3 : 6);

            var chaserCandidates = Room.TeamManager.PlayersPlaying.ToList();
            _chaserTimer = TimeSpan.Zero;

            //Search for valid new chaser
            for (var trys = 0; trys < 10; trys++)
            {
                var index = _random.Next(0, chaserCandidates.Count);
                var candidate = chaserCandidates[index];

                if (candidate != null && candidate != LastChaser)
                {
                    Chaser = candidate;
                    break;
                }
            }

            if (Chaser == null)
            {
                var index = _random.Next(0, chaserCandidates.Count);
                Chaser = chaserCandidates[index];
            }

            // Reset player states
            foreach (var plr in Room.TeamManager.PlayersPlaying)
                plr.RoomInfo.State = PlayerState.Alive;

            LastChaser = Chaser;

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

            // Broadcast the round win message
            Room.Broadcast(new SScoreSLRoundWinAckMessage());
            RoundEnd();
        }

        public void ChaserLose(bool paysOut = true)
        {
            if (_waitingNextChaser)
                return;

            if (paysOut)
            {
                foreach (var plr in Room.TeamManager.PlayersPlaying)
                {
                    if (plr == Chaser)
                        continue;

                    if (_forcedSpectators.Contains(plr))
                        continue;

                    GetRecord(plr).Wins++;

                    if (plr.RoomInfo.State == PlayerState.Alive)
                        GetRecord(plr).Survived++;
                }
            }

            Room.Broadcast(new SScoreRoundWinAckMessage());

            RoundEnd();
        }

        private bool CanStartGame()
        {
            if (!StateMachine.IsInState(GameRuleState.Waiting))
                return false;

            var countReady = Room.TeamManager.Values.Sum(team => team.Values.Count(plr => plr.RoomInfo.IsReady));

            // Check all players in room
            if (countReady < PlayersNeededToStart - 1) //Excluding room master
                return false;

            return true;
        }

        public IEnumerable<Player> GetPlayersAlive()
        {
            return Room.TeamManager.PlayersPlaying.Where(plr => plr != Chaser && plr.RoomInfo.State == PlayerState.Alive);
        }

        private static ChaserPlayerRecord GetRecord(Player plr)
        {
            return (ChaserPlayerRecord)plr.RoomInfo.Stats;
        }
    }

// Chaser Briefing Section
internal class ChaserBriefing : Briefing
    {
        public long CurrentChaser { get; set; }
        public long CurrentChaserTarget { get; set; }

        public int Unk3 { get; set; }
        public int Unk4 { get; set; }
        public int Unk5 { get; set; }
        public int Unk6 { get; set; }

        public IList<int> Unk7 { get; set; }
        public IList<long> Unk8 { get; set; }
        public IList<long> Unk9 { get; set; } // Players alive

        public int RoundTime { get; set; }

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

            //List of chasers
            Unk8 = new List<long> { CurrentChaser };

            //Alive player list (exclude chaser)
            Unk9 = gameRule.GetPlayersAlive()
                .Where(player => player != gameRule.Chaser)
                .Select(player => (long)player.Account.Id)
                .ToList();

            Unk6 = 1;

            Unk3 = (int)gameRule.ChaserElapsed.TotalMilliseconds;
            Unk4 = (int)gameRule.ChaserRoundTime.TotalMilliseconds;
            Unk5 = (int)gameRule.ChaserRoundTime.TotalMilliseconds;

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

    //Chaser Player Record
    internal class ChaserPlayerRecord : PlayerRecord
    {
        public ChaserPlayerRecord(Player plr) : base(plr) { }

        public override uint TotalScore => GetTotalScore();

        public static bool ProbeFields = false;

        // Additional stats
        public int Unk1 { get; set; }
        public int Unk2 { get; set; }
        public int Unk3 { get; set; }
        public int Unk4 { get; set; }
        public uint BonusKills { get; set; }
        public int Unk5 { get; set; }
        public int Unk6 { get; set; }
        public int Unk7 { get; set; }
        public int Unk8 { get; set; }
        public uint Wins { get; set; }
        public uint Survived { get; set; }
        public int Unk9 { get; set; }
        public int Unk10 { get; set; }
        public uint ChaserCount { get; set; }
        public int Unk11 { get; set; }
        public int Unk12 { get; set; }
        public int Unk13 { get; set; }
        public int Unk14 { get; set; }
        public int Unk15 { get; set; }
        public int Unk16 { get; set; }

        // Sword & Gun Ranks
        public float SwordRanking { get; set; }
        public float GunRanking { get; set; }

        public float Unk19 { get; set; }
        public float Unk20 { get; set; }

        public byte Unk21 { get; set; }

        public override void Serialize(BinaryWriter w, bool isResult)
        {
            base.Serialize(w, isResult);

            Console.WriteLine($"[wire] {Player.Account.Nickname}: kills={Kills} bonus={BonusKills} " +
                              $"wins={Wins} survived={Survived} chaser={ChaserCount} " +
                              $"sword={SwordRanking} gun={GunRanking} state={Player.RoomInfo.State} " +
                              $"points={Kills * 2 + BonusKills * 4 + Wins * 5 + Survived * 10}");

            if (ProbeFields)
            {
                w.Write(11);       // Unk1
                w.Write(12);       // Unk2
                w.Write(13);       // Unk3
                w.Write(14);       // Unk4
                w.Write(15u);      // Kills
                w.Write(16u);      // BonusKills
                w.Write(17);       // Unk5
                w.Write(18);       // Unk6
                w.Write(19);       // Unk7
                w.Write(20);       // Unk8
                w.Write(21u);      // Wins
                w.Write(22u);      // Survived
                w.Write(23);       // Unk9
                w.Write(24);       // Unk10
                w.Write(25u);      // ChaserCount
                w.Write(26);       // Unk11
                w.Write(27);       // Unk12
                w.Write(28);       // Unk13
                w.Write(29);       // Unk14
                w.Write(30);       // Unk15
                w.Write(31);       // Unk16
                w.Write(32f);      // SwordRanking
                w.Write(33f);      // GunRanking
                w.Write(34f);      // Unk19
                w.Write(35f);      // Unk20
                w.Write((byte)36); // Unk21
                return;
            }

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
            w.Write(SwordRanking);
            w.Write(GunRanking);
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
            SwordRanking = 0;
            GunRanking = 0;
            Unk19 = 0;
            Unk20 = 0;
            Unk21 = 0;
        }

        private uint GetTotalScore()
        {
            var totalScore = Kills * 2 +
                             BonusKills * 4 +
                             Wins * 5 +
                             Survived * 10;
							 //+ (uint)(Unk17 + Unk18);
            return totalScore;
        }
    }
}