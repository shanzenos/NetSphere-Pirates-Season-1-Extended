using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BlubLib.DotNetty.Handlers.MessageHandling;
using Dapper.FastCrud;
using Netsphere.Database.Game;
using Netsphere.Network.Data.Game;
using Netsphere.Network.Message.Game;
using NLog;
using NLog.Fluent;
using ProudNet.Handlers;

namespace Netsphere.Network.Services
{
    internal class MissionService : ProudMessageHandler
    {
        // ReSharper disable once InconsistentNaming
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();

        private static readonly Random Random = new Random();

        public static async Task SendMissionInfo(GameSession session)
        {
            var plr = session.Player;
            if (plr == null)
                return;

            TaskDto[] tasks = Array.Empty<TaskDto>();

            try
            {
                var rows = await LoadRows(plr).ConfigureAwait(false);
                await FillEmptySlots(plr, rows).ConfigureAwait(false);
                var resource = GameServer.Instance.ResourceCache.GetTasks();

                tasks = rows
                    .Select(row => new { row, info = resource.FirstOrDefault(t => t.Id == row.MissionId) })
                    .Where(x => x.info != null)
                    .Select(x => new TaskDto
                    {
                        Id = (uint)x.row.MissionId,
                        Slot = (byte)x.row.Slot,
                        Progress = (ushort)x.row.Progress,
                        RewardType = MissionRewardType.PEN,
                        Reward = x.info.Reward
                    })
                    .ToArray();
            }
            catch (Exception ex)
            {
                Logger.Warn()
                    .Account(session)
                    .Message($"Failed to load missions: {ex.Message}")
                    .Write();
            }

            await session.SendAsync(new STaskInfoAckMessage { Tasks = tasks })
                .ConfigureAwait(false);
        }

        [MessageHandler(typeof(CTaskRequestReqMessage))]
        public async Task TaskRequestReq(GameSession session, CTaskRequestReqMessage message)
        {
            var plr = session.Player;
            if (plr == null)
            {
                await session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask))
                    .ConfigureAwait(false);
                return;
            }

            if ((message.Type != 1 && message.Type != 2) || message.Slot > 2 || message.Level > 4)
            {
                await session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask))
                    .ConfigureAwait(false);
                return;
            }

            Resource.TaskInfo picked = null;
            try
            {
                var rows = await LoadRows(plr).ConfigureAwait(false);
                var taken = rows.Select(row => (uint)row.MissionId).ToArray();

                var candidates = GameServer.Instance.ResourceCache.GetTasks()
                    .Where(t => t.Type == message.Type && t.Level == message.Level)
                    .Where(t => !taken.Contains(t.Id))
                    .Where(t => t.MinLevel == 0 || plr.Level >= t.MinLevel)
                    .Where(t => t.MaxLevel == 0 || plr.Level <= t.MaxLevel)
                    .ToArray();

                picked = Pick(candidates, plr.Level);
                if (picked == null)
                {
                    await session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask))
                        .ConfigureAwait(false);
                    return;
                }

                using (var db = GameDatabase.Open())
                {
                    await db.InsertAsync(new PlayerMissionDto
                    {
                        PlayerId = (int)plr.Account.Id,
                        MissionId = (int)picked.Id,
                        Slot = message.Slot,
                        Progress = 0,
                        Completed = false
                    }).ConfigureAwait(false);
                }
            }
            catch (Exception ex)
            {
                Logger.Warn()
                    .Account(session)
                    .Message($"Failed to assign mission: {ex.Message}")
                    .Write();

                await session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask))
                    .ConfigureAwait(false);
                return;
            }

            await session.SendAsync(new STaskRequestAckMessage
            {
                TaskId = picked.Id,
                RewardType = MissionRewardType.PEN,
                Reward = picked.Reward,
                Slot = message.Slot
            }).ConfigureAwait(false);
        }

        [MessageHandler(typeof(CTaskNotifyReqMessage))]
        public async Task TaskNotifyReq(GameSession session, CTaskNotifyReqMessage message)
        {
            var plr = session.Player;
            if (plr == null)
                return;

            var info = GameServer.Instance.ResourceCache.GetTasks().FirstOrDefault(t => t.Id == message.TaskId);
            if (info == null)
                return;

            var progress = message.Progress > info.Goal ? info.Goal : message.Progress;
            var completed = false;

            try
            {
                using (var db = GameDatabase.Open())
                {
                    var row = (await db.FindAsync<PlayerMissionDto>(statement => statement
                            .Where($"{nameof(PlayerMissionDto.PlayerId):C} = @PlayerId AND {nameof(PlayerMissionDto.MissionId):C} = @MissionId")
                            .WithParameters(new { PlayerId = (int)plr.Account.Id, MissionId = (int)message.TaskId }))
                        .ConfigureAwait(false)).FirstOrDefault();

                    if (row == null || row.Completed)
                        return;

                    row.Progress = progress;
                    completed = info.Goal > 0 && progress >= info.Goal;
                    row.Completed = completed;
                    await db.UpdateAsync(row).ConfigureAwait(false);
                }
            }
            catch (Exception ex)
            {
                Logger.Warn()
                    .Account(session)
                    .Message($"Failed to store mission progress: {ex.Message}")
                    .Write();
                return;
            }

            Logger.Info()
                .Account(session)
                .Message($"Mission {message.TaskId} {progress}/{info.Goal} reported by the client")
                .Write();

            await session.SendAsync(new STaskUpdateAckMessage { TaskId = message.TaskId, Progress = (ushort)progress })
                .ConfigureAwait(false);

            if (!completed)
                return;

            Logger.Info()
                .Account(session)
                .Message($"Mission {message.TaskId} complete, {info.Reward} PEN")
                .Write();

            plr.PEN += info.Reward;
            await session.SendAsync(new SRefreshCashInfoAckMessage { PEN = plr.PEN, AP = plr.AP })
                .ConfigureAwait(false);
        }

        public static void OnWeaponKill(Player plr, AttackAttribute weapon)
        {
            var name = WeaponKey(weapon);
            if (name != null)
                Advance(plr, "TCCT_WEAPON_KILL", name, 1);
        }

        public static void OnGamePlayed(Player plr, GameRule rule, int mapId)
        {
            Func<Resource.TaskInfo, bool> sameMode = info => info.Mode == "TMT_COMMON" || info.Mode == ModeKey(rule);

            Advance(plr, "TCCT_ATTEND_GAME", null, 1, sameMode);
            Advance(plr, "TCCT_MAP_PLAY", mapId.ToString(), 1, sameMode);
        }

        private static string ModeKey(GameRule rule)
        {
            switch (rule)
            {
                case GameRule.Touchdown: return "TMT_TOUCH_DOWN";
                case GameRule.Deathmatch: return "TMT_DEATH_MATCH";
                case GameRule.Chaser: return "TMT_CHASER";
                default: return "";
            }
        }

        public static void OnLicense(Player plr, ItemLicense license)
        {
            var name = LicenseKey(license);
            if (name != null)
                Advance(plr, "TCCT_GET_LICENSE", name, 1);
        }

        public static void OnLevelUp(Player plr)
        {
            Advance(plr, "TCCT_LEVEL_UP", null, 0, info =>
            {
                int target;
                return int.TryParse(info.CheckerData, out target) && plr.Level >= target;
            });
        }

        private static void Advance(Player plr, string checker, string data, int amount,
            Func<Resource.TaskInfo, bool> extra = null)
        {
            if (plr?.Account == null || plr.Session == null)
                return;

            try
            {
                var resource = GameServer.Instance.ResourceCache.GetTasks();

                using (var db = GameDatabase.Open())
                {
                    var rows = db.Find<PlayerMissionDto>(statement => statement
                        .Where($"{nameof(PlayerMissionDto.PlayerId):C} = @PlayerId")
                        .WithParameters(new { PlayerId = (int)plr.Account.Id }));

                    foreach (var row in rows)
                    {
                        if (row.Completed)
                            continue;

                        var info = resource.FirstOrDefault(t => t.Id == row.MissionId);
                        if (info == null || info.Checker != checker)
                            continue;

                        if (data != null && info.CheckerData != data)
                            continue;

                        if (extra != null && !extra(info))
                            continue;

                        var goal = info.Goal == 0 ? 1 : info.Goal;
                        var progress = amount == 0 ? goal : row.Progress + amount;
                        if (progress > goal)
                            progress = goal;

                        if (progress == row.Progress)
                            continue;

                        row.Progress = progress;
                        row.Completed = progress >= goal;
                        db.Update(row);

                        plr.Session.SendAsync(new STaskUpdateAckMessage { TaskId = (uint)row.MissionId, Progress = (ushort)progress });

                        if (plr.Room != null)
                            plr.Session.SendAsync(new STaskIngameUpdateAckMessage { TaskId = (uint)row.MissionId, Progress = (ushort)progress });

                        Logger.Info()
                            .Account(plr)
                            .Message($"Mission {row.MissionId} {progress}/{goal} ({checker}{(data == null ? "" : " " + data)})")
                            .Write();

                        if (!row.Completed)
                            continue;

                        plr.PEN += info.Reward;
                        Logger.Info()
                            .Account(plr)
                            .Message($"Mission {row.MissionId} complete, {info.Reward} PEN")
                            .Write();

                        plr.Session.SendAsync(new SRefreshCashInfoAckMessage { PEN = plr.PEN, AP = plr.AP });
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Warn()
                    .Message($"Failed to advance missions for {checker}: {ex.Message}")
                    .Write();
            }
        }

        private static string WeaponKey(AttackAttribute weapon)
        {
            switch (weapon)
            {
                case AttackAttribute.PlasmaSwordCritical:
                case AttackAttribute.PlasmaSwordStandWeak:
                case AttackAttribute.PlasmaSwordStandStrong:
                case AttackAttribute.PlasmaSwordAttack2Weak:
                case AttackAttribute.PlasmaSwordAttack2:
                case AttackAttribute.PlasmaSwordJumpCritical:
                case AttackAttribute.PlasmaSwordJump:
                    return "ATTACKITEM_PLASMA_SWORD";

                case AttackAttribute.CounterSwordCounterCritical:
                case AttackAttribute.CounterSwordCounterAttack:
                case AttackAttribute.CounterSwordCritical:
                case AttackAttribute.CounterSwordAttack1:
                case AttackAttribute.CounterSwordAttack2:
                case AttackAttribute.CounterSwordAttack3:
                case AttackAttribute.CounterSwordAttack4:
                case AttackAttribute.CounterSwordJumpDash:
                    return "ATTACKITEM_COUNTER_SWORD";

                case AttackAttribute.BatSwordStandWeak:
                case AttackAttribute.BatSwordStandStrong:
                case AttackAttribute.BatSwordAttack2Weak:
                case AttackAttribute.BatSwordAttack2:
                case AttackAttribute.BatSwordCritical:
                case AttackAttribute.BatSwordJumpCritical:
                case AttackAttribute.BatSwordJump:
                    return "ATTACKITEM_STORM_BAT";

                case AttackAttribute.SubmachineGun:
                    return "ATTACKITEM_SUBMACHINE_GUN";

                case AttackAttribute.MachineGunLower:
                case AttackAttribute.MachineGunMiddle:
                case AttackAttribute.MachineGunUpper:
                    return "ATTACKITEM_HEAVYMACHINE_GUN";

                case AttackAttribute.AimedShot:
                case AttackAttribute.AimedShot2:
                    return "ATTACKITEM_RAIL_GUN";

                case AttackAttribute.MineLauncher:
                    return "ATTACKITEM_MINE_GUN";

                case AttackAttribute.MindEnergy:
                case AttackAttribute.MindStormAttack1:
                case AttackAttribute.MindStormAttack2:
                    return "ATTACKITEM_MIND_SHOCK";

                case AttackAttribute.SentryGunMachineGun:
                    return "ATTACKITEM_CENTRYGUN";

                case AttackAttribute.Revolver:
                    return "ATTACKITEM_REVOLVER";

                case AttackAttribute.Revolver2:
                    return "ATTACKITEM_REVOLVER2";

                case AttackAttribute.CannonadeShot:
                case AttackAttribute.CannonadeShot2:
                    return "ATTACKITEM_CANNONADE";

                case AttackAttribute.Mg2:
                    return "ATTACKITEM_MG2";

                case AttackAttribute.Smg3:
                case AttackAttribute.Smg3Gun:
                case AttackAttribute.Smg3Sword:
                    return "ATTACKITEM_SMG3";

                case AttackAttribute.Smg4:
                    return "ATTACKITEM_SMG4";

                default:
                    return null;
            }
        }

        private static string LicenseKey(ItemLicense license)
        {
            switch (license)
            {
                case ItemLicense.CounterSword: return "LICENSE_COUNTER_SWORD";
                case ItemLicense.StormBat: return "LICENSE_STORM_BAT";
                case ItemLicense.Revolver: return "LICENSE_REVOLVER";
                case ItemLicense.SemiRifle: return "LICENSE_SEMI_RIFLE";
                case ItemLicense.HeavymachineGun: return "LICENSE_HEAVYMACHINE_GUN";
                case ItemLicense.GaussRifle: return "LICENSE_GAUSS_RIFLE";
                case ItemLicense.RailGun: return "LICENSE_RAIL_GUN";
                case ItemLicense.Cannonade: return "LICENSE_CANNONADE";
                case ItemLicense.Sentrygun: return "LICENSE_CENTRYGUN";
                case ItemLicense.MineGun: return "LICENSE_MINE_GUN";
                case ItemLicense.MindEnergy: return "LICENSE_MIND_ENERGY";
                case ItemLicense.MindShock: return "LICENSE_MIND_SHOCK";
                case ItemLicense.Anchoring: return "LICENSE_ANCHORING";
                case ItemLicense.Flying: return "LICENSE_FLYING";
                case ItemLicense.Invisible: return "LICENSE_INVISIBLE";
                case ItemLicense.Shield: return "LICENSE_SHIELD";
                case ItemLicense.Block: return "LICENSE_BLOCK";
                case ItemLicense.Bind: return "LICENSE_BIND";
                default: return null;
            }
        }

        private static async Task FillEmptySlots(Player plr, List<PlayerMissionDto> rows)
        {
            var resource = GameServer.Instance.ResourceCache.GetTasks();
            var mine = rows
                .Select(row => new { row, info = resource.FirstOrDefault(t => t.Id == row.MissionId) })
                .Where(x => x.info != null)
                .ToList();

            var added = new List<PlayerMissionDto>();

            for (byte type = 1; type <= 2; type++)
            {
                var maxLevel = type == 1 ? 4 : 3;
                for (byte level = 0; level <= maxLevel; level++)
                {
                    var here = mine.Where(x => x.info.Type == type && x.info.Level == level).ToList();
                    if (here.Count >= 3)
                        continue;

                    var taken = mine.Select(x => x.info.Id).ToArray();
                    var candidates = resource
                        .Where(t => t.Type == type && t.Level == level)
                        .Where(t => !taken.Contains(t.Id))
                        .Where(t => t.MinLevel == 0 || plr.Level >= t.MinLevel)
                        .Where(t => t.MaxLevel == 0 || plr.Level <= t.MaxLevel)
                        .ToList();

                    for (var slot = 0; slot < 3; slot++)
                    {
                        if (here.Any(x => x.row.Slot == slot))
                            continue;

                        var picked = Pick(candidates.ToArray(), plr.Level);
                        if (picked == null)
                            break;

                        candidates.Remove(picked);
                        var row = new PlayerMissionDto
                        {
                            PlayerId = (int)plr.Account.Id,
                            MissionId = (int)picked.Id,
                            Slot = slot,
                            Progress = 0,
                            Completed = false
                        };
                        added.Add(row);
                        here.Add(new { row, info = picked });
                        mine.Add(new { row, info = picked });
                    }
                }
            }

            if (added.Count == 0)
                return;

            using (var db = GameDatabase.Open())
            {
                foreach (var row in added)
                    await db.InsertAsync(row).ConfigureAwait(false);
            }

            rows.AddRange(added);
        }

        private static async Task<List<PlayerMissionDto>> LoadRows(Player plr)
        {
            using (var db = GameDatabase.Open())
            {
                return (await db.FindAsync<PlayerMissionDto>(statement => statement
                        .Where($"{nameof(PlayerMissionDto.PlayerId):C} = @PlayerId")
                        .WithParameters(new { PlayerId = (int)plr.Account.Id }))
                    .ConfigureAwait(false)).ToList();
            }
        }

        private static Resource.TaskInfo Pick(Resource.TaskInfo[] candidates, byte playerLevel)
        {
            if (candidates.Length == 0)
                return null;

            var weights = candidates
                .Select(t => Math.Max(1, t.Chance + (playerLevel >= t.AddChanceLimitLevel ? t.AddChance : 0)))
                .ToArray();

            var roll = Random.Next(weights.Sum());
            for (var i = 0; i < candidates.Length; i++)
            {
                roll -= weights[i];
                if (roll < 0)
                    return candidates[i];
            }

            return candidates[candidates.Length - 1];
        }
    }
}
