using System.Xml.Serialization;

namespace Netsphere.Resource.xml
{
    [XmlType(AnonymousType = true)]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "ItemReward")]
    public class ItemRewardDto
    {
        [XmlElement("item")]
        public ItemRewardItemDto[] item { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class ItemRewardItemDto
    {
        [XmlAttribute("Number")]
        public uint Number { get; set; }

        [XmlElement("group")]
        public ItemRewardGroupDto[] group { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class ItemRewardGroupDto
    {
        [XmlElement("reward")]
        public ItemRewardEntryDto[] reward { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class ItemRewardEntryDto
    {
        [XmlAttribute("Type")]
        public uint Type { get; set; }

        [XmlAttribute("Data")]
        public uint Data { get; set; }

        [XmlAttribute("PriceType")]
        public uint PriceType { get; set; }

        [XmlAttribute("PeriodType")]
        public uint PeriodType { get; set; }

        [XmlAttribute("Color")]
        public byte Color { get; set; }

        [XmlAttribute("Value")]
        public uint Value { get; set; }

        [XmlAttribute("Effects")]
        public string Effects { get; set; }

        [XmlAttribute("Rate")]
        public int Rate { get; set; }
    }
}
