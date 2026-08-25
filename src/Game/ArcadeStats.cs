using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;

namespace Netsphere
{
    // Stages a player has already cleared & related stats
    internal class ArcadeStats
    {
        public const byte Stages = 8;

        private readonly Player _player;
        private readonly HashSet<int> _cleared = new HashSet<int>();
        private bool _loaded;

        public ArcadeStats(Player player)
        {
            _player = player;
        }

        public bool IsStageCleared(byte difficulty, byte stage)
        {
            Load();
            return _cleared.Contains(Key(difficulty, stage));
        }

        public bool IsDifficultyCleared(byte difficulty)
        {
            for (byte stage = 1; stage <= Stages; stage++)
            {
                if (!IsStageCleared(difficulty, stage))
                    return false;
            }

            return true;
        }

        public void MarkStageCleared(byte difficulty, byte stage)
        {
            if (stage < 1 || stage > Stages)
                return;

            Load();
            if (!_cleared.Add(Key(difficulty, stage)))
            {
                return;
            }


            using (var db = GameDatabase.Open())
            {
                db.Execute(
                    "INSERT IGNORE INTO player_info_arcade (PlayerId, ClearedStages, Difficulty) VALUES (@playerId, @stage, @difficulty)",
                    new { playerId = (int)_player.Account.Id, stage = (int)stage, difficulty = (int)difficulty });
            }
        }

        public void ResetClears(byte difficulty)
        {
            Load();
            foreach (var key in _cleared.Where(k => k / 100 == difficulty).ToArray())
                _cleared.Remove(key);

            using (var db = GameDatabase.Open())
            {
                db.Execute(
                    "DELETE FROM player_info_arcade WHERE PlayerId = @playerId AND Difficulty = @difficulty",
                    new { playerId = (int)_player.Account.Id, difficulty = (int)difficulty });
            }
        }

        private void Load()
        {
            if (_loaded)
                return;

            _loaded = true;

            using (var db = GameDatabase.Open())
            {
                var rows = db.Query<ClearedRow>(
                    "SELECT ClearedStages, Difficulty FROM player_info_arcade WHERE PlayerId = @playerId",
                    new { playerId = (int)_player.Account.Id });

                foreach (var row in rows)
                    _cleared.Add(Key(row.Difficulty, row.ClearedStages));
            }
        }

        private static int Key(byte difficulty, byte stage)
        {
            return (difficulty * 100) + stage;
        }

        private class ClearedRow
        {
            public byte ClearedStages { get; set; }
            public byte Difficulty { get; set; }
        }
    }
}
