using System;
using System.Data;
using System.Linq;
using Dapper.FastCrud;
using Netsphere.Database.Game;
using Netsphere.Game.GameRules;
using Netsphere.Network.Data.Chat;
using Netsphere.Network.Data.Game;

namespace Netsphere
{
    internal class StatsManager
    {
        private bool _isFriendly;
        private readonly Player _owner;
        private BaseStats _active;

        public StatsManager(Player player, PlayerDto playerDto)
        {
            _owner = player;
            DeathMatch = new DMStats(_owner, playerDto);
            TouchDown = new TDStats(_owner, playerDto);
            Chaser = new ChaserStats(_owner, playerDto);
            BattleRoyal = new BRStats(_owner, playerDto);
            Captain = new CPTStats(_owner, playerDto);
            Arcade = new ArcadeStats(_owner);
        }

        public DMStats DeathMatch { get; }
        public TDStats TouchDown { get; }
        public ChaserStats Chaser { get; }
        public BRStats BattleRoyal { get; }
        public CPTStats Captain { get; }
        public ArcadeStats Arcade { get; }

        public ulong Won
        {
            get { return _active != null ? _active.Won : 0; }
            set
            {
                if (_active == null || _isFriendly)
                    return;
                _owner.TotalWins++;
                _active.Won = value;
            }
        }

        public ulong Loss
        {
            get { return _active != null ? _active.Loss : 0; }
            set
            {
                if (_active == null || _isFriendly)
                    return;
                _owner.TotalLosses++;
                _active.Loss = value;
            }
        }

        public ulong Kills
        {
            get { return _active != null ? _active.Kills : 0; }
            set
            {
                if (_active == null || _isFriendly)
                    return;
                _active.Kills = value;
            }
        }

        public ulong KillAssists
        {
            get { return _active != null ? _active.KillAssists : 0; }
            set
            {
                if (_active == null || _isFriendly)
                    return;
                _active.KillAssists = value;
            }
        }

        public ulong Deaths
        {
            get { return _active != null ? _active.Deaths : 0; }
            set
            {
                if (_active == null || _isFriendly)
                    return;
                _active.Deaths = value;
            }
        }

        public ulong Heal
        {
            get { return _active != null ? _active.Heal : 0; }
            set
            {
                if (_active == null || _isFriendly)
                    return;
                _active.Heal = value;
            }
        }

        public bool IsActive => _active != null && !_isFriendly;

        public void OnJoin(GameRuleBase game)
        {
            _active = null;
            _isFriendly = game.Room.Options.IsFriendly;
            switch (game.GameRule)
            {
                case GameRule.BattleRoyal:
                    _active = BattleRoyal;
                    break;
                case GameRule.Captain:
                    _active = Captain;
                    break;
                case GameRule.Chaser:
                    _active = Chaser;
                    break;
                case GameRule.Deathmatch:
                    _active = DeathMatch;
                    break;
                case GameRule.Touchdown:
                    _active = TouchDown;
                    break;
            }
        }

        public void Save(IDbConnection db)
        {
            DeathMatch.Save(db);
            TouchDown.Save(db);
            Chaser.Save(db);
            BattleRoyal.Save(db);
            Captain.Save(db);
        }
    }

    internal abstract class BaseStats
    {
        protected ulong _deaths;
        protected bool _existsInDatabase;
        protected ulong _heal;
        protected ulong _killAssists;
        protected ulong _kills;
        protected ulong _loss;
        protected bool _needsSave;
        protected ulong _won;

        protected BaseStats(Player player)
        {
            Player = player;
        }

        public Player Player { get; set; }

        public ulong Won
        {
            get { return _won; }
            set
            {
                if (_won == value)
                    return;
                _won = value;
                _needsSave = true;
            }
        }

        public ulong Loss
        {
            get { return _loss; }
            set
            {
                if (_loss == value)
                    return;
                _loss = value;
                _needsSave = true;
            }
        }

        public ulong Kills
        {
            get { return _kills; }
            set
            {
                if (_kills == value)
                    return;
                _needsSave = true;
                _kills = value;
            }
        }

        public ulong KillAssists
        {
            get { return _killAssists; }
            set
            {
                if (_killAssists == value)
                    return;
                _needsSave = true;
                _killAssists = value;
            }
        }

        public ulong Deaths
        {
            get { return _deaths; }
            set
            {
                if (_deaths == value)
                    return;
                _needsSave = true;
                _deaths = value;
            }
        }

        public ulong Heal
        {
            get { return _heal; }
            set
            {
                if (_heal == value)
                    return;
                _heal = value;
                _needsSave = true;
            }
        }

        public float WinRate => _won + _loss > 0 ? _won / (float)(_won + _loss) : 0.0f;
        protected float TotalMatches => Won + Loss;

        protected static float Round1(float value)
        {
            return (float)Math.Round(value, 1, MidpointRounding.AwayFromZero);
        }

        protected static uint ToUInt32(ulong value)
        {
            return value > uint.MaxValue ? uint.MaxValue : (uint)value;
        }

        protected float AveragePerMatch(float value, float defaultValue = 0.0f)
        {
            return TotalMatches > 0 ? Round1(value / TotalMatches) : defaultValue;
        }

        protected float WinPercent => Round1(WinRate * 100.0f);

        public abstract void Save(IDbConnection db);
    }

    internal class DMStats : BaseStats
    {
        public DMStats(Player player, PlayerDto playerDto)
            : base(player)
        {
            var record = playerDto.DeathmatchInfo.FirstOrDefault();
            _existsInDatabase = false;
            if (record != null)
            {
                _existsInDatabase = true;
                _won = record.Won;
                _loss = record.Loss;
                _kills = record.Kills;
                _killAssists = record.KillAssists;
                _deaths = record.Deaths;
                _heal = record.Heal;
            }
        }

        public override void Save(IDbConnection db)
        {
            if (!_needsSave)
                return;
            var row = new PlayerInfoDeathmatchDto
            {
                PlayerId = (int)Player.Account.Id,
                Won = Won,
                Loss = Loss,
                Kills = Kills,
                KillAssists = KillAssists,
                Deaths = Deaths,
                Heal = Heal
            };
            if (_existsInDatabase)
            {
                db.Update(row);
            }
            else
            {
                db.Insert(row);
                _existsInDatabase = true;
            }
            _needsSave = false;
        }

        public DMUserDataDto GetUserDataDto()
        {
            var weightedKills = Kills + (KillAssists / 2.0f);
            var ratio = Deaths > 0 ? weightedKills / Deaths : Kills > 0 ? 1.0f : 0.0f;
            return new DMUserDataDto
            {
                KillDeath = Round1(ratio),
                WinRate = WinPercent
            };
        }

        public DMStatsDto GetStatsDto()
        {
            return new DMStatsDto
            {
                Won = ToUInt32(Won),
                Lost = ToUInt32(Loss),
                Kills = ToUInt32(Kills),
                KillAssists = ToUInt32(KillAssists),
                Deaths = ToUInt32(Deaths)
            };
        }
    }

    internal class TDStats : BaseStats
    {
        private ulong _defense;
        private ulong _defenseAssist;
        private ulong _offense;
        private ulong _offenseAssist;
        private ulong _offenseRebound;
        private ulong _td;
        private ulong _tdassist;

        public TDStats(Player player, PlayerDto playerDto)
            : base(player)
        {
            var record = playerDto.TouchdownInfo.FirstOrDefault();
            _existsInDatabase = false;
            if (record != null)
            {
                _existsInDatabase = true;
                _won = record.Won;
                _loss = record.Loss;
                _td = record.TD;
                _tdassist = record.TDAssist;
                _offense = record.Offense;
                _offenseAssist = record.OffenseAssist;
                _offenseRebound = record.OffenseRebound;
                _defense = record.Defense;
                _defenseAssist = record.DefenseAssist;
                _kills = record.Kill;
                _killAssists = record.KillAssist;
                _heal = record.Heal;
            }
        }

        public ulong TD
        {
            get { return _td; }
            set
            {
                if (_td == value)
                    return;
                _td = value;
                _needsSave = true;
            }
        }

        public ulong TDAssist
        {
            get { return _tdassist; }
            set
            {
                if (_tdassist == value)
                    return;
                _tdassist = value;
                _needsSave = true;
            }
        }

        public ulong Offense
        {
            get { return _offense; }
            set
            {
                if (_offense == value)
                    return;
                _offense = value;
                _needsSave = true;
            }
        }

        public ulong OffenseAssist
        {
            get { return _offenseAssist; }
            set
            {
                if (_offenseAssist == value)
                    return;
                _offenseAssist = value;
                _needsSave = true;
            }
        }

        public ulong OffenseRebound
        {
            get { return _offenseRebound; }
            set
            {
                if (_offenseRebound == value)
                    return;
                _offenseRebound = value;
                _needsSave = true;
            }
        }

        public ulong Defense
        {
            get { return _defense; }
            set
            {
                if (_defense == value)
                    return;
                _defense = value;
                _needsSave = true;
            }
        }

        public ulong DefenseAssist
        {
            get { return _defenseAssist; }
            set
            {
                if (_defenseAssist == value)
                    return;
                _defenseAssist = value;
                _needsSave = true;
            }
        }

        public ulong TotalScore => 10 * TD + 5 * TDAssist + 4 * Offense +
            2 * OffenseAssist + 4 * Defense + 2 * DefenseAssist +
            2 * Kills + KillAssists + 2 * Heal;

        public override void Save(IDbConnection db)
        {
            if (!_needsSave)
                return;
            var row = new PlayerInfoTouchdownDto
            {
                PlayerId = (int)Player.Account.Id,
                Won = Won,
                Loss = Loss,
                TD = TD,
                TDAssist = TDAssist,
                Offense = Offense,
                OffenseAssist = OffenseAssist,
                Defense = Defense,
                DefenseAssist = DefenseAssist,
                Kill = Kills,
                KillAssist = KillAssists,
                OffenseRebound = OffenseRebound,
                Heal = Heal
            };
            if (_existsInDatabase)
            {
                db.Update(row);
            }
            else
            {
                db.Insert(row);
                _existsInDatabase = true;
            }
            _needsSave = false;
        }

        public TDUserDataDto GetUserDataDto()
        {
            return new TDUserDataDto
            {
                TotalScore = AveragePerMatch(TotalScore),
                TDScore = AveragePerMatch(10 * TD + 5 * TDAssist),
                OffenseScore = AveragePerMatch(4 * Offense + 2 * OffenseAssist),
                DefenseScore = AveragePerMatch(4 * Defense + 2 * DefenseAssist),
                KillScore = AveragePerMatch(2 * Kills + KillAssists),
                RecoveryScore = AveragePerMatch(2 * Heal),
                WinRate = WinPercent
            };
        }

        public TDStatsDto GetStatsDto()
        {
            return new TDStatsDto
            {
                Won = ToUInt32(Won),
                Lost = ToUInt32(Loss),
                MatchesTimes20 = ToUInt32((Won + Loss) * 20),
                TD = ToUInt32(TD),
                TDAssist = ToUInt32(TDAssist),
                Kills = ToUInt32(Kills),
                KillAssists = ToUInt32(KillAssists),
                Offense = ToUInt32(Offense),
                OffenseAssist = ToUInt32(OffenseAssist),
                Defense = ToUInt32(Defense),
                DefenseAssist = ToUInt32(DefenseAssist),
                Heal = ToUInt32(Heal)
            };
        }
    }

    internal class ChaserStats : BaseStats
    {
        private ulong _chasedRound;
        private ulong _chasedWon;
        private ulong _chaserRounds;
        private ulong _chaserWon;
        private ulong _chaserKills;

        public ChaserStats(Player player, PlayerDto playerDto)
            : base(player)
        {
            var record = playerDto.ChaserInfo.FirstOrDefault();
            _existsInDatabase = false;
            if (record != null)
            {
                _existsInDatabase = true;
                _chasedWon = record.ChasedWon;
                _chasedRound = record.ChasedRounds;
                _chaserWon = record.ChaserWon;
                _chaserRounds = record.ChaserRounds;
                _chaserKills = record.Kills;
            }
        }

        public ulong ChasedWon
        {
            get { return _chasedWon; }
            set
            {
                if (_chasedWon == value)
                    return;
                _chasedWon = value;
                _needsSave = true;
            }
        }

        public ulong ChasedRounds
        {
            get { return _chasedRound; }
            set
            {
                if (_chasedRound == value)
                    return;
                _chasedRound = value;
                _needsSave = true;
            }
        }

        public ulong ChaserWon
        {
            get { return _chaserWon; }
            set
            {
                if (_chaserWon == value)
                    return;
                _chaserWon = value;
                _needsSave = true;
            }
        }

        public ulong ChaserRounds
        {
            get { return _chaserRounds; }
            set
            {
                if (_chaserRounds == value)
                    return;
                _chaserRounds = value;
                _needsSave = true;
            }
        }

        public ulong Killed
        {
            get { return _chaserKills; }
            set
            {
                if (_chaserKills == value)
                    return;
                _chaserKills = value;
                _needsSave = true;
            }
        }

        public override void Save(IDbConnection db)
        {
            if (!_needsSave)
                return;
            var row = new PlayerInfoChaserDto
            {
                PlayerId = (int)Player.Account.Id,
                ChasedRounds = ChasedRounds,
                ChasedWon = ChasedWon,
                ChaserRounds = ChaserRounds,
                ChaserWon = ChaserWon,
                Kills = Killed
            };
            if (_existsInDatabase)
            {
                db.Update(row);
            }
            else
            {
                db.Insert(row);
                _existsInDatabase = true;
            }
            _needsSave = false;
        }

        public ChaserUserDataDto GetUserDataDto()
        {
            var catchRatio = ChaserRounds > 0 ? ChaserWon / (float)ChaserRounds : 0.0f;
            var escapeRatio = ChasedRounds > 0 ? ChasedWon / (float)ChasedRounds : 0.0f;
            return new ChaserUserDataDto
            {
                SurvivalProbability = Round1(escapeRatio * 100.0f),
                AllKillProbability = Round1(catchRatio * 100.0f)
            };
        }

        public ChaserStatsDto GetStatsDto()
        {
            return new ChaserStatsDto
            {
                ChasedWon = ToUInt32(ChasedWon),
                ChasedRounds = ToUInt32(ChasedRounds),
                ChaserWon = ToUInt32(ChaserWon),
                ChaserRounds = ToUInt32(ChaserRounds)
            };
        }
    }

    internal class BRStats : BaseStats
    {
        private ulong _firstKilled;
        private ulong _firstPlace;

        public BRStats(Player player, PlayerDto playerDto)
            : base(player)
        {
            var record = playerDto.BattleRoyalInfo.FirstOrDefault();
            _existsInDatabase = false;
            if (record != null)
            {
                _existsInDatabase = true;
                _won = record.Won;
                _loss = record.Loss;
                _kills = record.Kills;
                _killAssists = record.KillAssists;
                _firstKilled = record.FirstKilled;
                _firstPlace = record.FirstPlace;
            }
        }

        public ulong FirstKilled
        {
            get { return _firstKilled; }
            set
            {
                if (_firstKilled == value)
                    return;
                _needsSave = true;
                _firstKilled = value;
            }
        }

        public ulong FirstPlace
        {
            get { return _firstPlace; }
            set
            {
                if (_firstPlace == value)
                    return;
                _needsSave = true;
                _firstPlace = value;
            }
        }

        public float BRScore => WinPercent;

        public override void Save(IDbConnection db)
        {
            if (!_needsSave)
                return;
            var row = new PlayerInfoBattleRoyalDto
            {
                PlayerId = (int)Player.Account.Id,
                Won = Won,
                Loss = Loss,
                KillAssists = KillAssists,
                Kills = Kills,
                FirstKilled = FirstKilled,
                FirstPlace = FirstPlace
            };
            if (_existsInDatabase)
            {
                db.Update(row);
            }
            else
            {
                db.Insert(row);
                _existsInDatabase = true;
            }
            _needsSave = false;
        }

        public BRUserDataDto GetUserDataDto()
        {
            return new BRUserDataDto
            {
                Score = BRScore,
                CountFirstPlaceKilled = ToUInt32(FirstKilled),
                CountFirstPlace = ToUInt32(FirstPlace)
            };
        }

        public BRStatsDto GetStatsDto()
        {
            return new BRStatsDto
            {
                Won = ToUInt32(Won),
                Lost = ToUInt32(Loss),
                FirstKilled = ToUInt32(FirstKilled),
                FirstPlace = ToUInt32(FirstPlace)
            };
        }
    }

    internal class CPTStats : BaseStats
    {
        private ulong _cptCount;
        private ulong _cptKills;

        public CPTStats(Player player, PlayerDto playerDto)
            : base(player)
        {
            var record = playerDto.CaptainInfo.FirstOrDefault();
            _existsInDatabase = false;
            if (record != null)
            {
                _existsInDatabase = true;
                _won = record.Won;
                _loss = record.Loss;
                _cptKills = record.CPTKilled;
                _cptCount = record.CPTCount;
            }
        }

        public ulong CPTKilled
        {
            get { return _cptKills; }
            set
            {
                if (_cptKills == value)
                    return;
                _needsSave = true;
                _cptKills = value;
            }
        }

        public ulong CPTCount
        {
            get { return _cptCount; }
            set
            {
                if (_cptCount == value)
                    return;
                _needsSave = true;
                _cptCount = value;
            }
        }

        public override void Save(IDbConnection db)
        {
            if (!_needsSave)
                return;
            var row = new PlayerInfoCaptainDto
            {
                PlayerId = (int)Player.Account.Id,
                Won = Won,
                Loss = Loss,
                CPTCount = CPTCount,
                CPTKilled = CPTKilled
            };
            if (_existsInDatabase)
            {
                db.Update(row);
            }
            else
            {
                db.Insert(row);
                _existsInDatabase = true;
            }
            _needsSave = false;
        }

        public CPTUserDataDto GetUserDataDto()
        {
            return new CPTUserDataDto
            {
                Score = Round1(Loss > 0 ? Won / (float)Loss : Won),
                CaptainKill = ToUInt32(CPTKilled),
                Domination = ToUInt32(CPTCount)
            };
        }

        public CPTStatsDto GetStatsDto()
        {
            return new CPTStatsDto
            {
                Won = ToUInt32(Won),
                Lost = ToUInt32(Loss),
                CaptainKilled = ToUInt32(CPTKilled),
                Captain = ToUInt32(CPTCount)
            };
        }
    }
}
