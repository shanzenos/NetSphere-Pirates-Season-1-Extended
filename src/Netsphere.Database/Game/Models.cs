using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Netsphere.Database.Game
{
    [Table("license_rewards")]
    public class LicenseRewardDto
    {
        [Key]
        public byte Id { get; set; }
        public int ShopItemInfoId { get; set; }
        public int ShopPriceId { get; set; }
        public byte Color { get; set; }
    }

    [Table("players")]
    public class PlayerDto
    {
        [Key]
        public int Id { get; set; }
        public byte TutorialState { get; set; }
        public byte Level { get; set; }
        public int TotalExperience { get; set; }
        public int PEN { get; set; }
        public int AP { get; set; }
        public int Coins1 { get; set; }
        public int Coins2 { get; set; }
        public byte CurrentCharacterSlot { get; set; }
        public int TotalMatches { get; set; }
        public int TotalWins { get; set; }
        public int TotalLosses { get; set; }
        public int TotalKills { get; set; }
        public int TotalDeaths { get; set; }

        public IList<PlayerInfoDeathmatchDto> DeathmatchInfo { get; set; } = new List<PlayerInfoDeathmatchDto>();
        public IList<PlayerInfoTouchdownDto> TouchdownInfo { get; set; } = new List<PlayerInfoTouchdownDto>();
        public IList<PlayerInfoChaserDto> ChaserInfo { get; set; } = new List<PlayerInfoChaserDto>();
        public IList<PlayerInfoBattleRoyalDto> BattleRoyalInfo { get; set; } = new List<PlayerInfoBattleRoyalDto>();
        public IList<PlayerInfoCaptainDto> CaptainInfo { get; set; } = new List<PlayerInfoCaptainDto>();
        public IList<PlayerCharacterDto> Characters { get; set; } = new List<PlayerCharacterDto>();
        public IList<PlayerDenyDto> Ignores { get; set; } = new List<PlayerDenyDto>();
        public IList<PlayerItemDto> Items { get; set; } = new List<PlayerItemDto>();
        public IList<PlayerLicenseDto> Licenses { get; set; } = new List<PlayerLicenseDto>();
        public IList<PlayerMailDto> Inbox { get; set; } = new List<PlayerMailDto>();
        public IList<PlayerSettingDto> Settings { get; set; } = new List<PlayerSettingDto>();
    }

    [Table("player_characters")]
    public class PlayerCharacterDto
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public byte Slot { get; set; }
        public byte Gender { get; set; }
        public byte BasicHair { get; set; }
        public byte BasicFace { get; set; }
        public byte BasicShirt { get; set; }
        public byte BasicPants { get; set; }
        public int? Weapon1Id { get; set; }
        public int? Weapon2Id { get; set; }
        public int? Weapon3Id { get; set; }
        public int? SkillId { get; set; }
        public int? HairId { get; set; }
        public int? FaceId { get; set; }
        public int? ShirtId { get; set; }
        public int? PantsId { get; set; }
        public int? GlovesId { get; set; }
        public int? ShoesId { get; set; }
        public int? AccessoryId { get; set; }
    }

    [Table("player_deny")]
    public class PlayerDenyDto
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public int DenyPlayerId { get; set; }
    }

    [Table("player_info_deathmatch")]
    public class PlayerInfoDeathmatchDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public ulong Won { get; set; }
        public ulong Loss { get; set; }
        public ulong Kills { get; set; }
        public ulong KillAssists { get; set; }
        public ulong Deaths { get; set; }
        public ulong Heal { get; set; }
    }

    [Table("player_info_touchdown")]
    public class PlayerInfoTouchdownDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public ulong Won { get; set; }
        public ulong Loss { get; set; }
        public ulong TD { get; set; }
        public ulong TDAssist { get; set; }
        public ulong Offense { get; set; }
        public ulong OffenseAssist { get; set; }
        public ulong Defense { get; set; }
        public ulong DefenseAssist { get; set; }
        public ulong Kill { get; set; }
        public ulong KillAssist { get; set; }
        public ulong OffenseRebound { get; set; }
        public ulong Heal { get; set; }
    }

    [Table("player_info_chaser")]
    public class PlayerInfoChaserDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public ulong ChasedWon { get; set; }
        public ulong ChasedRounds { get; set; }
        public ulong ChaserWon { get; set; }
        public ulong ChaserRounds { get; set; }
        public ulong Kills { get; set; }
    }

    [Table("player_info_battleroyal")]
    public class PlayerInfoBattleRoyalDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public ulong Won { get; set; }
        public ulong Loss { get; set; }
        public ulong Kills { get; set; }
        public ulong KillAssists { get; set; }
        public ulong FirstKilled { get; set; }
        public ulong FirstPlace { get; set; }
    }

    [Table("player_info_captain")]
    public class PlayerInfoCaptainDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public ulong Won { get; set; }
        public ulong Loss { get; set; }
        public ulong CPTKilled { get; set; }
        public ulong CPTCount { get; set; }
    }

    [Table("player_characters")]
    public class PlayerCharacterDto
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public byte Slot { get; set; }
        public byte Gender { get; set; }
        public byte BasicHair { get; set; }
        public byte BasicFace { get; set; }
        public byte BasicShirt { get; set; }
        public byte BasicPants { get; set; }
        public int? Weapon1Id { get; set; }
        public int? Weapon2Id { get; set; }
        public int? Weapon3Id { get; set; }
        public int? SkillId { get; set; }
        public int? HairId { get; set; }
        public int? FaceId { get; set; }
        public int? ShirtId { get; set; }
        public int? PantsId { get; set; }
        public int? GlovesId { get; set; }
        public int? ShoesId { get; set; }
        public int? AccessoryId { get; set; }
    }

    [Table("player_deny")]
    public class PlayerDenyDto
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public int DenyPlayerId { get; set; }
    }

    [Table("player_friends")]
    public class PlayerFriendDto
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public int FriendId { get; set; }
        public int PlayerState { get; set; }
        public int FriendState { get; set; }
    }

    [Table("combi")]
    public class CombiRowDto
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public int CombiPlayerId { get; set; }
        public long Exp { get; set; }
        public long Battle { get; set; }

        [Column("Match")]
        public int MatchCount { get; set; }

        public long Win { get; set; }
        public long Defeat { get; set; }
        public string CombiName { get; set; }
        public string CombiMate { get; set; }
        public string CombiDate { get; set; }
        public int State { get; set; }
    }

    [Table("player_items")]
    public class PlayerItemDto
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }
        
        public int ShopItemInfoId { get; set; }
        public int ShopPriceId { get; set; }
        public uint Effect { get; set; }
        public byte Color { get; set; }
        public long PurchaseDate { get; set; }
        public int Durability { get; set; }
        public int Count { get; set; }
    }

    [Table("player_licenses")]
    public class PlayerLicenseDto
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public byte License { get; set; }
        public long FirstCompletedDate { get; set; }
        public int CompletedCount { get; set; }
    }

    [Table("player_mails")]
    public class PlayerMailDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public int SenderPlayerId { get; set; }
        public long SentDate { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public bool IsMailNew { get; set; }
        public bool IsMailDeleted { get; set; }
    }

    [Table("player_settings")]
    public class PlayerSettingDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey(nameof(Player))]
        public int PlayerId { get; set; }
        public PlayerDto Player { get; set; }

        public string Setting { get; set; }
        public string Value { get; set; }
    }

    [Table("shop_effect_groups")]
    public class ShopEffectGroupDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public string Name { get; set; }

        public IList<ShopEffectDto> ShopEffects { get; set; } = new List<ShopEffectDto>();
    }

    [Table("shop_effects")]
    public class ShopEffectDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey(nameof(EffectGroup))]
        public int EffectGroupId { get; set; }
        public ShopEffectGroupDto EffectGroup { get; set; }

        public uint Effect { get; set; }
    }

    [Table("shop_price_groups")]
    public class ShopPriceGroupDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public string Name { get; set; }
        public byte PriceType { get; set; }

        public IList<ShopPriceDto> ShopPrices { get; set; } = new List<ShopPriceDto>();
    }

    [Table("shop_prices")]
    public class ShopPriceDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey(nameof(PriceGroup))]
        public int PriceGroupId { get; set; }
        public ShopPriceGroupDto PriceGroup { get; set; }

        public byte PeriodType { get; set; }
        public int Period { get; set; }
        public int Price { get; set; }
        public bool IsRefundable { get; set; }
        public int Durability { get; set; }
        public bool IsEnabled { get; set; }
    }

    [Table("shop_items")]
    public class ShopItemDto
    {
        [Key]
        public uint Id { get; set; }
        public byte RequiredGender { get; set; }
        public byte RequiredLicense { get; set; }
        public byte Colors { get; set; }
        public byte UniqueColors { get; set; }
        public byte RequiredLevel { get; set; }
        public byte LevelLimit { get; set; }
        public byte RequiredMasterLevel { get; set; }
        public bool IsOneTimeUse { get; set; }
        public bool IsDestroyable { get; set; }

        public IList<ShopItemInfoDto> ItemInfos { get; set; } = new List<ShopItemInfoDto>();
    }

    [Table("shop_iteminfos")]
    public class ShopItemInfoDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey(nameof(ShopItem))]
        public uint ShopItemId { get; set; }
        public ShopItemDto ShopItem { get; set; }

        public int PriceGroupId { get; set; }
        public int EffectGroupId { get; set; }
        public byte DiscountPercentage { get; set; }
        public bool IsEnabled { get; set; }
    }

    [Table("shop_version")]
    public class ShopVersionDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public byte Id { get; set; }
        public string Version { get; set; }
    }

    [Table("start_items")]
    public class StartItemDto
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public int ShopItemInfoId { get; set; }
        public int ShopPriceId { get; set; }
        public int ShopEffectId { get; set; }
        public byte Color { get; set; }
        public int Count { get; set; }
        public byte RequiredSecurityLevel { get; set; }
    }
}
