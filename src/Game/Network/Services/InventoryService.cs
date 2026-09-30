using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BlubLib.DotNetty.Handlers.MessageHandling;
using Netsphere.Network.Data.Game;
using Netsphere.Network.Message.Game;
using NLog;
using NLog.Fluent;
using ProudNet.Handlers;
using Dapper.FastCrud;
using Netsphere.Database.Auth;

namespace Netsphere.Network.Services
{
    internal class InventoryService : ProudMessageHandler
    {
        // ReSharper disable once InconsistentNaming
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();

        private static readonly Random _capsuleRng = new Random();

        [MessageHandler(typeof(CUseItemReqMessage))]
        public async Task UseItemHandler(GameSession session, CUseItemReqMessage message)
        {
            var plr = session.Player;
            var @char = plr.CharacterManager[message.CharacterSlot];
            var item = plr.Inventory[message.ItemId];

            if (@char == null || item == null || (plr.Room != null && plr.RoomInfo.State != PlayerState.Lobby))
            {
                await session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask))
                    .ConfigureAwait(false);
                return;
            }

            try
            {
                switch (message.Action)
                {
                    case UseItemAction.Equip:
                        @char.Equip(item, message.EquipSlot);
                        break;

                    case UseItemAction.UnEquip:
                        @char.UnEquip(item.ItemNumber.Category, message.EquipSlot);
                        break;
                }
            }
            catch (CharacterException ex)
            {
                Logger.Error()
                    .Account(session)
                    .Exception(ex)
                    .Write();
                await session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask))
                    .ConfigureAwait(false);
            }
        }

        [MessageHandler(typeof(CRepairItemReqMessage))]
        public async Task RepairItemHandler(GameSession session, CRepairItemReqMessage message)
        {
            var shop = GameServer.Instance.ResourceCache.GetShop();

            foreach (var id in message.Items)
            {
                var item = session.Player.Inventory[id];
                if (item == null)
                {
                    Logger.Error()
                        .Account(session)
                        .Message($"Item {id} not found")
                        .Write();
                    await session.SendAsync(new SRepairItemAckMessage { Result = ItemRepairResult.Error0 })
                        .ConfigureAwait(false);
                    return;
                }
                if (item.Durability == -1)
                {
                    Logger.Error()
                        .Account(session)
                        .Message($"Item {item.ItemNumber} {item.PriceType} {item.PeriodType} {item.Period} can not be repaired")
                        .Write();
                    await session.SendAsync(new SRepairItemAckMessage { Result = ItemRepairResult.Error1 })
                        .ConfigureAwait(false);
                    return;
                }

                var cost = item.CalculateRepair();
                if (session.Player.PEN < cost)
                {
                    await session.SendAsync(new SRepairItemAckMessage { Result = ItemRepairResult.NotEnoughMoney })
                        .ConfigureAwait(false);
                    return;
                }

                var price = shop.GetPrice(item);
                if (price == null)
                {
                    Logger.Error()
                        .Account(session)
                        .Message($"No shop entry found for {item.ItemNumber} {item.PriceType} {item.PeriodType} {item.Period}")
                        .Write();
                    await session.SendAsync(new SRepairItemAckMessage { Result = ItemRepairResult.Error4 })
                        .ConfigureAwait(false);
                    return;
                }
                if (item.Durability >= price.Durability)
                {
                    await session.SendAsync(new SRepairItemAckMessage { Result = ItemRepairResult.OK, ItemId = item.Id })
                        .ConfigureAwait(false);
                    continue;
                }

                item.Durability = price.Durability;
                session.Player.PEN -= cost;

                await session.SendAsync(new SRepairItemAckMessage { Result = ItemRepairResult.OK, ItemId = item.Id })
                        .ConfigureAwait(false);
                await session.SendAsync(new SRefreshCashInfoAckMessage { PEN = session.Player.PEN, AP = session.Player.AP })
                        .ConfigureAwait(false);
            }
        }

        [MessageHandler(typeof(CRefundItemReqMessage))]
        public async Task RefundItemHandler(GameSession session, CRefundItemReqMessage message)
        {
            var shop = GameServer.Instance.ResourceCache.GetShop();

            var item = session.Player.Inventory[message.ItemId];
            if (item == null)
            {
                Logger.Error()
                    .Account(session)
                    .Message($"Item {message.ItemId} not found")
                    .Write();
                await session.SendAsync(new SRefundItemAckMessage { Result = ItemRefundResult.Failed })
                    .ConfigureAwait(false);
                return;
            }

            var price = shop.GetPrice(item);
            if (price == null)
            {
                Logger.Error()
                    .Account(session)
                    .Message($"No shop entry found for {item.ItemNumber} {item.PriceType} {item.PeriodType} {item.Period}")
                    .Write();
                await session.SendAsync(new SRefundItemAckMessage { Result = ItemRefundResult.Failed })
                    .ConfigureAwait(false);
                return;
            }
            if (!price.CanRefund)
            {
                Logger.Error()
                    .Account(session)
                    .Message($"Cannot refund {item.ItemNumber} {item.PriceType} {item.PeriodType} {item.Period}")
                    .Write();
                await session.SendAsync(new SRefundItemAckMessage { Result = ItemRefundResult.Failed })
                    .ConfigureAwait(false);
                return;
            }

            session.Player.PEN += item.CalculateRefund();
            session.Player.Inventory.Remove(item);

            await session.SendAsync(new SRefundItemAckMessage { Result = ItemRefundResult.OK, ItemId = item.Id })
                    .ConfigureAwait(false);
            await session.SendAsync(new SRefreshCashInfoAckMessage { PEN = session.Player.PEN, AP = session.Player.AP })
                    .ConfigureAwait(false);
        }

        [MessageHandler(typeof(CDiscardItemReqMessage))]
        public async Task DiscardItemHandler(GameSession session, CDiscardItemReqMessage message) //fixed
        {
            var shop = GameServer.Instance.ResourceCache.GetShop();

            var item = session.Player.Inventory[message.ItemId];
            if (item == null)
            {
                Logger.Error()
                    .Account(session)
                    .Message($"Item {message.ItemId} not found")
                    .Write();
                await session.SendAsync(new SDiscardItemAckMessage { Result = 2 })
                    .ConfigureAwait(false);
                return;
            }

            var shopItem = shop.GetItem(item.ItemNumber);
            if (shopItem == null)
            {
                Logger.Error()
                    .Account(session)
                    .Message($"No shop entry found for {item.ItemNumber} {item.PriceType} {item.PeriodType} {item.Period}")
                    .Write();
                await session.SendAsync(new SDiscardItemAckMessage { Result = 2 })
                    .ConfigureAwait(false);
                return;
            }
            if (shopItem.IsDestroyable)
            {
                Logger.Error()
                    .Account(session)
                    .Message($"Cannot discard {item.ItemNumber} {item.PriceType} {item.PeriodType} {item.Period}")
                    .Write();
                await session.SendAsync(new SDiscardItemAckMessage { Result = 2 })
                    .ConfigureAwait(false);
                return;
            }

            session.Player.Inventory.Remove(item);
            await session.SendAsync(new SDiscardItemAckMessage { Result = 0, ItemId = item.Id })
                .ConfigureAwait(false);
        }

        private static CapsuleRewardDto CreateShopItem(Player plr, uint itemNumber, byte color, uint effect)
        {
            try
            {
                var shop = GameServer.Instance.ResourceCache.GetShop();
                var shopItem = shop.GetItem(itemNumber);
                if (shopItem == null || shopItem.ItemInfos == null || shopItem.ItemInfos.Count == 0)
                {
                    Logger.Error($"[CAPSULE] reward item {itemNumber} not in shop, skipped");
                    return null;
                }

                var info = shopItem.ItemInfos[0];
                if (info.PriceGroup == null || info.PriceGroup.Prices == null || info.PriceGroup.Prices.Count == 0)
                {
                    Logger.Error($"[CAPSULE] reward item {itemNumber} has no price, skipped");
                    return null;
                }

                var item = plr.Inventory.Create(info, info.PriceGroup.Prices[0], color, effect, 1);
                return new CapsuleRewardDto(item.Id, 1);
            }
            catch (Exception ex)
            {
                Logger.Error($"[CAPSULE] reward item {itemNumber} create failed: {ex.Message}");
                return null;
            }
        }

        [MessageHandler(typeof(CUseCapsuleReqMessage))]
        public async Task UseCapsuleReq(GameSession session, CUseCapsuleReqMessage message)
        {
            var plr = session.Player;
            var capsule = plr.Inventory[message.ItemId];
            if (capsule == null)
            {
                await session.SendAsync(new SUseCapsuleAckMessage(1)).ConfigureAwait(false);
                return;
            }

            var rewards = new List<CapsuleRewardDto>();
            var table = GameServer.Instance.ResourceCache.GetItemRewards();
            Netsphere.Resource.xml.ItemRewardItemDto def;

            if (!table.TryGetValue(capsule.ItemNumber, out def) || def.group == null)
            {
                Console.WriteLine($"[CAPSULE-TEST] no rewards for capsule {(uint)capsule.ItemNumber}, giving debug item 2000000");
                var dbgReward = CreateShopItem(plr, 2000000, 0, 0);
                if (dbgReward != null)
                    rewards.Add(dbgReward);
            }
            else
            {
                foreach (var group in def.group)
                {
                    if (group.reward == null || group.reward.Length == 0)
                        continue;

                    var totalRate = group.reward.Sum(r => r.Rate);
                    if (totalRate <= 0)
                        continue;

                    var roll = _capsuleRng.Next(0, totalRate);
                    Netsphere.Resource.xml.ItemRewardEntryDto picked = null;
                    var acc = 0;
                    foreach (var r in group.reward)
                    {
                        acc += r.Rate;
                        if (roll < acc) { picked = r; break; }
                    }
                    if (picked == null)
                        continue;

                    if (picked.Type == (uint)CapsuleRewardType.PEN)
                    {
                        plr.PEN += picked.Value;
                        rewards.Add(new CapsuleRewardDto(picked.Value));
                    }
                    else
                    {
                        uint effect = 0;
                        if (!string.IsNullOrEmpty(picked.Effects))
                            uint.TryParse(picked.Effects.Split(',')[0], out effect);

                        var itemReward = CreateShopItem(plr, picked.Data, picked.Color, effect);
                        if (itemReward != null)
                            rewards.Add(itemReward);
                    }
                }
            }

            plr.Inventory.Remove(capsule);
            await session.SendAsync(new SUseCapsuleAckMessage(rewards.ToArray(), 3)).ConfigureAwait(false);
            await session.SendAsync(new SRefreshCashInfoAckMessage { PEN = plr.PEN, AP = plr.AP }).ConfigureAwait(false);
        }
        //session.Send(new SUseCapsuleAckMessage(new List<CapsuleRewardDto>
        //{
        //    new CapsuleRewardDto(CapsuleRewardType.Item, 0, 64, 0),
        //    new CapsuleRewardDto(CapsuleRewardType.Item, 0, 154, 123),
        //    new CapsuleRewardDto(CapsuleRewardType.PEN, 9999, 0, 0),
        //    //new CapsuleRewardDto(CapsuleRewardType.PEN, 2, 0, 0),
        //    //new CapsuleRewardDto(CapsuleRewardType.PEN, 3, 0, 0),
        //}, 3));
    }
           //todo unimplemented nickname change item         
         /*[MessageHandler(typeof(CUseChangeNickNameItemReqMessage))]
        public async Task CUseChangeNickNameItemReq(GameSession session, CUseItemReqMessage message)
        {
            using (var db = AuthDatabase.Open())
            {
                var something = new AccountDto
                {
                    Id = unchecked((int)Plr.Account.Id),
                    Username = null,
                    Nickname = null,
                    Password = null,
                    Salt = null,
                    SecurityLevel = null

                await db.SendAsync(new SServerResultInfoAckMessage((ServerResult)1))
                .ConfigureAwait(false);
            }
        
            catch (CharacterException ex)
            {
                Logger.Error()
                    .Account(session)
                    .Exception(ex)
                    .Write();
                await session.SendAsync(new SServerResultInfoAckMessage(ServerResult.FailedToRequestTask))
                    .ConfigureAwait(false);
            }
        }*/

    }
