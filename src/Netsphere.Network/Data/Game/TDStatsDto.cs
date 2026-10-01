using BlubLib.Serialization;

namespace Netsphere.Network.Data.Game
{
    [BlubContract]
    public class TDStatsDto
    {
        [BlubMember(0)]
        public uint Won { get; set; }

        [BlubMember(1)]
        public uint Lost { get; set; }

        [BlubMember(2)]
        public uint TD { get; set; }

        // client divides every average by this / 20.0f
        [BlubMember(3)]
        public uint MatchesTimes20 { get; set; }

        [BlubMember(4)]
        public uint TDAssist { get; set; }

        [BlubMember(5)]
        public uint Kills { get; set; }

        [BlubMember(6)]
        public uint KillAssists { get; set; }

        [BlubMember(7)]
        public uint Offense { get; set; }

        [BlubMember(8)]
        public uint OffenseAssist { get; set; }

        [BlubMember(9)]
        public uint Defense { get; set; }

        [BlubMember(10)]
        public uint DefenseAssist { get; set; }

        [BlubMember(11)]
        public uint Heal { get; set; }

        [BlubMember(12)]
        public uint Unk13 { get; set; }

        [BlubMember(13)]
        public uint Unk14 { get; set; }

        [BlubMember(14)]
        public uint Unk15 { get; set; }

        [BlubMember(15)]
        public uint Unk16 { get; set; }

        [BlubMember(16)]
        public uint Unk17 { get; set; }

        [BlubMember(17)]
        public uint Unk18 { get; set; }
    }
}
