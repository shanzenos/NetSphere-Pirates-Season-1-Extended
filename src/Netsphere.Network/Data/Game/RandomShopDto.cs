﻿using System;
using BlubLib.Serialization;
using Netsphere.Network.Serializers;

namespace Netsphere.Network.Data.Game
{
    [BlubContract]
    public class RandomShopDto
    {
        [BlubMember(0, typeof(ArrayWithIntPrefixSerializer))]
        public ItemNumber[] ItemNumbers { get; set; }

        [BlubMember(1, typeof(ArrayWithIntPrefixSerializer))]
        public uint[] Effects { get; set; }

        [BlubMember(2, typeof(ArrayWithIntPrefixSerializer))]
        public uint[] Colors { get; set; }

        [BlubMember(3, typeof(ArrayWithIntPrefixSerializer))]
        public ItemPeriodType[] PeriodTypes { get; set; }

        [BlubMember(4, typeof(ArrayWithIntPrefixSerializer))]
        public ushort[] Periods { get; set; }

        [BlubMember(5)]
        public uint Unk6 { get; set; }

        public RandomShopDto()
        {
            ItemNumbers = Array.Empty<ItemNumber>();
            Effects = Array.Empty<uint>();
            Colors = Array.Empty<uint>();
            PeriodTypes = Array.Empty<ItemPeriodType>();
            Periods = Array.Empty<ushort>();
        }
    }
}
