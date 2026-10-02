using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using Netsphere.Network;

namespace Netsphere.Shop
{
    internal class FumbiRollEntry
    {
        public ItemNumber ItemNumber { get; set; }
        public ItemPriceType PriceType { get; set; }
        public IList<ShopPrice> Periods { get; set; }
        public ItemPeriodType PeriodType { get; set; }
        public ushort Period { get; set; }
        public byte Color { get; set; }
        public int Weight { get; set; }
        public Gender Gender { get; set; }
    }

    internal static class FumbiShop
    {
        public const uint RollCostPEN = 10000;

        // same period pool the S4 fumbi uses, all equally likely
        private static readonly ItemPeriodType[] PeriodTypes =
        {
            ItemPeriodType.Days,
            ItemPeriodType.Days,
            ItemPeriodType.Days,
            ItemPeriodType.Days,
            ItemPeriodType.None
        };

        private static readonly ushort[] Periods = { 1, 3, 7, 30, 0 };

        private static readonly object Sync = new object();
        private static readonly Random Rng = new Random();
        private static readonly ConcurrentDictionary<Player, ulong> LastRoll = new ConcurrentDictionary<Player, ulong>();
        private static readonly ConcurrentDictionary<Player, uint> LastNumber = new ConcurrentDictionary<Player, uint>();

        private static List<FumbiRollEntry> _weaponPool;
        private static List<FumbiRollEntry> _costumePool;
        private static string _builtVersion;

        public static bool HasPool
        {
            get
            {
                EnsureBuilt();
                return _weaponPool.Count + _costumePool.Count > 0;
            }
        }

        // the client rejects a costume that does not match the character gender
        // (LOBBY_RANDOMSHOP_NOT_SEX), so the costume pool is filtered by the gender the
        // request carries.
        // selected is the item the player picked on the page (request HeldItemNumber, 0 if
        // none). for costumes the roll stays inside its sub category, so picking Shoes gives
        // shoes; the weapon tab rolls any weapon. with hold set that exact item is kept.
        // costume sub categories: 0 hair, 1 face, 2 top, 3 pants, 4 gloves, 5 shoes,
        // 6 accessories, 7 pets
        public static FumbiRollEntry Roll(bool isWeapon, Gender gender, byte category, uint selected, bool hold)
        {
            EnsureBuilt();

            var pool = isWeapon ? _weaponPool : _costumePool;
            if (!isWeapon)
                pool = pool.FindAll(e => e.Gender == Gender.None || e.Gender == gender);

            if (!isWeapon)
            {
                var sub = SubCategoryOf(category);
                if (sub >= 0)
                    pool = pool.FindAll(e => e.ItemNumber.SubCategory == sub);
            }

            if (selected != 0 && hold)
            {
                var wanted = new ItemNumber(selected);
                pool = pool.FindAll(e => e.ItemNumber == wanted);
            }

            if (pool.Count == 0)
                return null;

            var picked = pool[pool.Count - 1];

            var total = 0;
            for (var i = 0; i < pool.Count; i++)
                total += pool[i].Weight;

            if (total <= 0)
            {
                picked = pool[Rng.Next(pool.Count)];
            }
            else
            {
                var roll = Rng.Next(total);
                var acc = 0;
                for (var i = 0; i < pool.Count; i++)
                {
                    acc += pool[i].Weight;
                    if (roll < acc)
                    {
                        picked = pool[i];
                        break;
                    }
                }
            }

            var period = picked.Periods[Rng.Next(picked.Periods.Count)];
            return new FumbiRollEntry
            {
                ItemNumber = picked.ItemNumber,
                PriceType = picked.PriceType,
                Periods = picked.Periods,
                PeriodType = period.PeriodType,
                Period = period.Period,
                Color = picked.Color,
                Weight = picked.Weight,
                Gender = picked.Gender
            };
        }


        // the page buttons, Head Shirt Pants Glove Shoes, against the item number sub
        // category: 0 hair, 2 shirt, 3 pants, 4 gloves, 5 shoes
        private static int SubCategoryOf(byte category)
        {
            switch (category)
            {
                case 0: return 0;
                case 1: return 2;
                case 2: return 3;
                case 3: return 4;
                case 4: return 5;
                default: return -1;
            }
        }

        public static void SetLastRoll(Player player, ulong itemId, uint itemNumber)
        {
            LastRoll[player] = itemId;
            LastNumber[player] = itemNumber;
        }

        // on entering the pick state the client fills the item slot with the last rolled
        // item, so HeldItemNumber only means a real choice when it differs from it
        public static uint Selected(Player player, uint heldItemNumber)
        {
            uint last;
            if (LastNumber.TryGetValue(player, out last) && last == heldItemNumber)
                return 0;

            return heldItemNumber;
        }

        public static bool TryTakeLastRoll(Player player, out ulong itemId)
        {
            return LastRoll.TryRemove(player, out itemId);
        }

        public static void ClearLastRoll(Player player)
        {
            ulong itemId;
            LastRoll.TryRemove(player, out itemId);
        }

        public static void Remove(Player player)
        {
            if (player == null)
                return;
            ulong itemId;
            uint itemNumber;
            LastRoll.TryRemove(player, out itemId);
            LastNumber.TryRemove(player, out itemNumber);
        }

        private static void EnsureBuilt()
        {
            var shop = GameServer.Instance.ResourceCache.GetShop();
            if (_weaponPool != null && _builtVersion == shop.Version)
                return;

            lock (Sync)
            {
                if (_weaponPool != null && _builtVersion == shop.Version)
                    return;

                var weapons = new List<FumbiRollEntry>();
                var costumes = new List<FumbiRollEntry>();

                foreach (var item in shop.Items.Values)
                {
                    if (item.ItemNumber.Category != ItemCategory.Costume &&
                        item.ItemNumber.Category != ItemCategory.Weapon)
                        continue;

                    // the fumbi only has buttons for Head(0), Shirt(2), Pants(3), Glove(4)
                    // and Shoes(5). Face(1) and Acc(6) are not part of it
                    if (item.ItemNumber.Category == ItemCategory.Costume &&
                        (item.ItemNumber.SubCategory == 1 || item.ItemNumber.SubCategory > 5))
                        continue;

                    // in this shop data only 12 items (all skills) sit in the PEN price
                    // group, everything else is PREM. the roll is paid in PEN either way,
                    // so take whatever price group the item has, preferring PEN
                    ShopItemInfo info = null;
                    foreach (var candidate in item.ItemInfos)
                    {
                        if (!candidate.IsEnabled)
                            continue;
                        if (info == null || candidate.PriceGroup.PriceType == ItemPriceType.PEN)
                            info = candidate;
                    }
                    if (info == null)
                        continue;

                    ShopPrice best = null;
                    var periods = new List<ShopPrice>();
                    foreach (var price in info.PriceGroup.Prices)
                    {
                        if (!price.IsEnabled || price.Price <= 0)
                            continue;
                        if (best == null || price.Price < best.Price)
                            best = price;

                        for (var i = 0; i < Periods.Length; i++)
                        {
                            if (price.PeriodType == PeriodTypes[i] && price.Period == Periods[i])
                            {
                                periods.Add(price);
                                break;
                            }
                        }
                    }
                    if (best == null)
                        continue;

                    if (periods.Count == 0)
                        periods.Add(best);

                    var weight = Math.Max(1, 100000 / best.Price);
                    var entry = new FumbiRollEntry
                    {
                        ItemNumber = item.ItemNumber,
                        PriceType = info.PriceGroup.PriceType,
                        Periods = periods,
                        Color = 0,
                        Weight = weight,
                        Gender = item.Gender
                    };

                    if (item.ItemNumber.Category == ItemCategory.Weapon)
                        weapons.Add(entry);
                    else
                        costumes.Add(entry);
                }

                _weaponPool = weapons;
                _costumePool = costumes;
                _builtVersion = shop.Version;
            }
        }
    }
}
