using System.Xml.Serialization;

namespace Netsphere.Resource.xml
{
    [XmlType(AnonymousType = true)]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "gm_support_item")]
    public class GmSupportItemDto
    {
        [XmlElement("item")]
        public GmSupportItemItemDto[] item { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class GmSupportItemItemDto
    {
        [XmlAttribute]
        public byte category { get; set; }

        [XmlAttribute]
        public byte sub_category { get; set; }

        [XmlAttribute]
        public byte number { get; set; }

        [XmlAttribute]
        public byte product { get; set; }
    }
}
