using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using BlubLib.DotNetty.Handlers.MessageHandling;
using Netsphere.Network.Data.Game;
using Netsphere.Network.Message.Game;
using Netsphere.Shop;
using NLog;
using NLog.Fluent;
using ProudNet.Handlers;

namespace Netsphere.Network.Services
{
    internal class ShopService : ProudMessageHandler
    {
        // ReSharper disable once InconsistentNaming
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();

        [MessageHandler(typeof(CNewShopUpdateCheckReqMessage))]
        public async Task ShopUpdateCheckHandler(GameSession session, CNewShopUpdateCheckReqMessage message)
        {
            var shop = GameServer.Instance.ResourceCache.GetShop();
            var version = shop.Version;
            await session.SendAsync(new SNewShopUpdateCheckAckMessage
            {
                Date01 = version,
                Date02 = version,
                Date03 = version,
                Date04 = version,
                Unk = 0
            }).ConfigureAwait(false);
            //session.Send(new SRandomShopInfoAckMessage
            //{
            //    Info = new RandomShopDto
            //    {
            //        ItemNumbers = new List<ItemNumber> { 2000001, 2000002, 2000003 },
            //        Effects = new List<uint> { 0, 0, 0 },
            //        Colors = new List<uint> { 2, 0, 0 },
            //        PeriodTypes = new List<ItemPeriodType> { ItemPeriodType.Hours, ItemPeriodType.Hours, ItemPeriodType.Hours },
            //        Periods = new List<ushort> { 2, 4, 10 },
            //        Unk6 = 10000,
            //    }
            //});

            if (message.Date01 == version &&
                message.Date02 == version &&
                message.Date03 == version &&
                message.Date04 == version)
            {
                return;
            }


            #region NewShopPrice

            using (var w = new BinaryWriter(new MemoryStream()))
            {
                w.Serialize(shop.Prices.Values.ToArray());

                await session.SendAsync(new SNewShopUpdateInfoAckMessage
                {
                    Type = ShopResourceType.NewShopPrice,
                    Data = w.ToArray(),
                    Date = version
                }).ConfigureAwait(false);
            }

            #endregion

            #region NewShopEffect

            using (var w = new BinaryWriter(new MemoryStream()))
            {
                w.Serialize(shop.Effects.Values.ToArray());

                await session.SendAsync(new SNewShopUpdateInfoAckMessage
                {
                    Type = ShopResourceType.NewShopEffect,
                    Data = w.ToArray(),
                    Date = version
                }).ConfigureAwait(false);
            }

            #endregion

            #region NewShopItem

            using (var w = new BinaryWriter(new MemoryStream()))
            {
                w.Serialize(shop.Items.Values.ToArray());

                await session.SendAsync(new SNewShopUpdateInfoAckMessage
                {
                    Type = ShopResourceType.NewShopItem,
                    Data = w.ToArray(),
                    Date = version
                }).ConfigureAwait(false);
            }

            #endregion

            // ToDo
            using (var w = new BinaryWriter(new MemoryStream()))
            {
                w.Write(0);

                await session.SendAsync(new SNewShopUpdateInfoAckMessage
                {
                    Type = ShopResourceType.NewShopUniqueItem,
                    Data = w.ToArray(),
                    Date = version
                }).ConfigureAwait(false);
            }

            using (var w = new BinaryWriter(new MemoryStream()))
            {
                w.Write(new byte[200]);

                await session.SendAsync(new SNewShopUpdateInfoAckMessage
                {
                    Type = (ShopResourceType)16,
                    Data = w.ToArray(),
                    Date = version
                }).ConfigureAwait(false);
            }
        }

        [MessageHandler(typeof(CLicensedReqMessage))]
        public void LicensedHandler(GameSession session, CLicensedReqMessage message)
        {
            try
            {
                session.Player.LicenseManager.Acquire(message.License);
            }
            catch (LicenseNotFoundException ex)
            {
                Logger.Error()
                    .Account(session)
                    .Exception(ex)
                    .Write();
            }
        }

        [MessageHandler(typeof(CExerciseLicenceReqMessage))]
        public void ExerciseLicenseHandler(GameSession session, CExerciseLicenceReqMessage message)
        {
            try
            {
                session.Player.LicenseManager.Acquire(message.License);
            }
            catch (LicenseException ex)
            {
                Logger.Error()
                    .Account(session)
                    .Exception(ex)
                    .Write();
            }
        }

        [MessageHandler(typeof(CBuyItemReqMessage))]
        public async Task BuyItemHandler(GameSession session, CBuyItemReqMessage message)
        {
            var shop = GameServer.Instance.ResourceCache.GetShop();
            var plr = session.Player;

            foreach (var item in message.Items)
            {
                var shopItemInfo = shop.GetItemInfo(item.ItemNumber, item.PriceType);
                if (shopItemInfo == null)
                {
                    Logger.Error()
                        .Account(session)
                        .Message($"No shop entry found for {item.ItemNumber} {item.PriceType} {item.Period}{item.PeriodType}")
                        .Write();

                    await session.SendAsync(new SBuyItemAckMessage(ItemBuyResult.UnkownItem))
                        .ConfigureAwait(false);
                    return;
                }
                if (!shopItemInfo.IsEnabled)
                {
                    Logger.Error()
                        .Account(session)
                        .Message($"No shop entry {item.ItemNumber} {item.PriceType} {item.Period}{item.PeriodType} is not enabled")
                        .Write();

                    await session.SendAsync(new SBuyItemAckMessage(ItemBuyResult.UnkownItem))
                        .ConfigureAwait(false);

                    return;
                }

                var priceGroup = shopItemInfo.PriceGroup;
                var price = priceGroup.GetPrice(item.PeriodType, item.Period);
                if (price == null)
                {
                    Logger.Error()
                        .Account(session)
                        .Message($"Invalid price group for shop entry {item.ItemNumber} {item.PriceType} {item.Period}{item.PeriodType}")
                        .Write();

                    await session.SendAsync(new SBuyItemAckMessage(ItemBuyResult.UnkownItem))
                        .ConfigureAwait(false);

                    return;
                }
                if (!price.IsEnabled)
                {
                    Logger.Error()
                        .Account(session)
                        .Message($"Shop entry {item.ItemNumber} {item.PriceType} {item.Period}{item.PeriodType} is not enabled")
                        .Write();

                    await session.SendAsync(new SBuyItemAckMessage(ItemBuyResult.UnkownItem))
                        .ConfigureAwait(false);

                    return;
                }

                if (item.Color > shopItemInfo.ShopItem.ColorGroup)
                {
                    Logger.Error()
                        .Account(session)
                        .Message($"Shop entry {item.ItemNumber} {item.PriceType} {item.Period}{item.PeriodType} has no color {item.Color}")
                        .Write();

                    await session.SendAsync(new SBuyItemAckMessage(ItemBuyResult.UnkownItem))
                        .ConfigureAwait(false);

                    return;
                }

                if (item.Effect != 0)
                {
                    if (shopItemInfo.EffectGroup.Effects.All(effect => effect.Effect != item.Effect))
                    {
                        Logger.Error()
                            .Account(session)
                            .Message($"Shop entry {item.ItemNumber} {item.PriceType} {item.Period}{item.PeriodType} has no effect {item.Effect}")
                            .Write();

                        await session.SendAsync(new SBuyItemAckMessage(ItemBuyResult.UnkownItem))
                                .ConfigureAwait(false);

                        return;
                    }
                }

                if (shopItemInfo.ShopItem.License != ItemLicense.None &&
                    !plr.LicenseManager.Contains(shopItemInfo.ShopItem.License) &&
                    Config.Instance.Game.EnableLicenseRequirement)
                {
                    Logger.Error()
                        .Account(session)
                        .Message($"Doesn't have license {shopItemInfo.ShopItem.License}")
                        .Write();

                    await session.SendAsync(new SBuyItemAckMessage(ItemBuyResult.UnkownItem))
                            .ConfigureAwait(false);

                    return;
                }

                // ToDo missing price types

                switch (shopItemInfo.PriceGroup.PriceType)
                {
                    case ItemPriceType.PEN:
                        if (plr.PEN < price.Price)
                        {
                            await session.SendAsync(new SBuyItemAckMessage(ItemBuyResult.NotEnoughMoney))
                                .ConfigureAwait(false);

                            return;
                        }
                        plr.PEN -= (uint)price.Price;
                        break;

                    case ItemPriceType.AP:
                    case ItemPriceType.Premium:
                        if (plr.AP < price.Price)
                        {
                            await session.SendAsync(new SBuyItemAckMessage(ItemBuyResult.NotEnoughMoney))
                                .ConfigureAwait(false);

                            return;
                        }
                        plr.AP -= (uint)price.Price;
                        break;

                    default:
                        Logger.Error()
                            .Account(session)
                            .Message($"Unknown PriceType {shopItemInfo.PriceGroup.PriceType}")
                            .Write();
                        return;
                }

                // ToDo
                //var purchaseDto = new PlayerPurchaseDto
                //{
                //    account_id = (int)plr.Account.Id,
                //    shop_item_id = item.ItemNumber,
                //    shop_item_info_id = shopItemInfo.Id,
                //    shop_price_id = price.Id,
                //    time = DateTimeOffset.Now.ToUnixTimeSeconds()
                //};
                //db.player_purchase.Add(purchaseDto);

                var plrItem = session.Player.Inventory.Create(shopItemInfo, price, item.Color, item.Effect, (uint)(price.PeriodType == ItemPeriodType.Units ? price.Period : 0));

                await session.SendAsync(new SBuyItemAckMessage(new[] { plrItem.Id }, item))
                    .ConfigureAwait(false);
                await session.SendAsync(new SRefreshCashInfoAckMessage(plr.PEN, plr.AP))
                    .ConfigureAwait(false);
            }
        }

        [MessageHandler(typeof(CRandomShopRollingStartReqMessage))]
        public async Task RandomShopRollHandler(GameSession session, CRandomShopRollingStartReqMessage message)
        {
            var plr = session.Player;
            if (plr == null)
                return;

            var tab = (uint)(message.IsWeapon ? 1 : 0);

            if (!FumbiShop.HasPool || plr.PEN < FumbiShop.RollCostPEN)
            {
                await session.SendAsync(new SRandomShopItemInfoAckMessage
                {
                    Item = new RandomShopItemDto { Tab = tab }
                }).ConfigureAwait(false);
                return;
            }

            // the shop item carries Gender (None/Male/Female), the character a CharacterGender
            // (Male/Female), and the request the same 0/1 as the character, 2 for either
            var gender = plr.CharacterManager.CurrentCharacter.Gender == CharacterGender.Female
                ? Gender.Female
                : Gender.Male;
            if (message.Gender == 0)
                gender = Gender.Male;
            else if (message.Gender == 1)
                gender = Gender.Female;

            var entry = FumbiShop.Roll(message.IsWeapon, gender,
                FumbiShop.Selected(plr, message.HeldItemNumber),
                message.HoldItem != 0);
            if (entry == null)
            {
                await session.SendAsync(new SRandomShopItemInfoAckMessage
                {
                    Item = new RandomShopItemDto { Tab = tab }
                }).ConfigureAwait(false);
                return;
            }

            plr.PEN -= FumbiShop.RollCostPEN;

            PlayerItem rolled;
            try
            {
                rolled = plr.Inventory.Create(
                    entry.ItemNumber,
                    entry.PriceType,
                    entry.PeriodType,
                    entry.Period,
                    entry.Color,
                    0,
                    (uint)(entry.PeriodType == ItemPeriodType.Units ? entry.Period : 0));
            }
            catch (Exception ex)
            {
                plr.PEN += FumbiShop.RollCostPEN;
                Logger.Error()
                    .Account(session)
                    .Exception(ex)
                    .Message($"Random shop failed to create item {entry.ItemNumber}")
                    .Write();

                await session.SendAsync(new SRandomShopItemInfoAckMessage
                {
                    Item = new RandomShopItemDto { Tab = tab }
                }).ConfigureAwait(false);
                return;
            }

            FumbiShop.SetLastRoll(plr, rolled.Id, entry.ItemNumber);

            var color = message.HoldColor != 0 && message.HeldColor >= 0
                ? (uint)message.HeldColor
                : entry.Color;
            var effect = message.HoldEffect != 0 && message.HeldEffect >= 0
                ? (uint)message.HeldEffect
                : 0u;

            await session.SendAsync(new SRandomShopItemInfoAckMessage
            {
                Item = new RandomShopItemDto
                {
                    Tab = tab,
                    ItemNumber = entry.ItemNumber,
                    Effect = effect,
                    Color = color,
                    PeriodType = entry.PeriodType,
                    Period = entry.Period
                }
            }).ConfigureAwait(false);

            await session.SendAsync(new SRefreshCashInfoAckMessage(plr.PEN, plr.AP))
                .ConfigureAwait(false);
        }

        [MessageHandler(typeof(CRandomShopItemGetReqMessage))]
        public async Task RandomShopItemGetHandler(GameSession session, CRandomShopItemGetReqMessage message)
        {
            var plr = session.Player;
            if (plr == null)
                return;

            FumbiShop.ClearLastRoll(plr);

            await session.SendAsync(new SRandomShopItemInfoAckMessage
            {
                Item = new RandomShopItemDto { Tab = message.Tab }
            }).ConfigureAwait(false);
        }

        [MessageHandler(typeof(CRandomShopItemSaleReqMessage))]
        public async Task RandomShopItemSaleHandler(GameSession session, CRandomShopItemSaleReqMessage message)
        {
            var plr = session.Player;
            if (plr == null)
                return;

            ulong itemId;
            if (FumbiShop.TryTakeLastRoll(plr, out itemId))
            {
                var item = plr.Inventory.GetItem(itemId);
                if (item != null)
                {
                    plr.Inventory.Remove(item);
                    plr.PEN += FumbiShop.RollCostPEN / 2;
                    await session.SendAsync(new SRefreshCashInfoAckMessage(plr.PEN, plr.AP))
                        .ConfigureAwait(false);
                }
            }

            await session.SendAsync(new SRandomShopItemInfoAckMessage
            {
                Item = new RandomShopItemDto { Tab = message.Tab }
            }).ConfigureAwait(false);
        }
    }
}
