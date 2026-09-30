using BlubLib.Serialization;

namespace Netsphere.Network.Data.Game
{
    [BlubContract]
    public class RandomShopItemDto
    {
        // 0 = costume, 1 = weapon
        [BlubMember(0)]
        public uint Tab { get; set; }

        [BlubMember(1)]
        public uint ItemNumber { get; set; }

        [BlubMember(2)]
        public uint Effect { get; set; }

        [BlubMember(3)]
        public uint Color { get; set; }

        [BlubMember(4)]
        public ItemPeriodType PeriodType { get; set; }

        [BlubMember(5)]
        public ushort Period { get; set; }
    }
}
