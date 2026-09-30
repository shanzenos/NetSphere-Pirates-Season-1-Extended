namespace Netsphere.Resource
{
    public class TaskInfo
    {
        public uint Id { get; set; }
        public byte Type { get; set; }
        public byte Level { get; set; }
        public int Chance { get; set; }
        public int AddChance { get; set; }
        public byte AddChanceLimitLevel { get; set; }
        public ushort Goal { get; set; }
        public uint Reward { get; set; }
        public byte MinLevel { get; set; }
        public byte MaxLevel { get; set; }
        public string Checker { get; set; }
        public string CheckerData { get; set; }
        public string Mode { get; set; }
    }
}
