﻿using BlubLib.Serialization;

namespace Netsphere.Network.Data.P2P
{
    [BlubContract]
    public class ItemDto
    {
        [BlubMember(0)]
        public ItemNumber ItemNumber { get; set; }

        [BlubMember(1)]
        public int Unk2 { get; set; }

        public ItemDto()
        {
            ItemNumber = 0;
        }

        public ItemDto(ItemNumber itemNumber, int unk2)
        {
            ItemNumber = itemNumber;
            Unk2 = unk2;
        }

        public override string ToString()
        {
            return ItemNumber.ToString();
        }
    }
}
