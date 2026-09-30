using System.Xml.Serialization;

namespace Netsphere.Resource.xml
{
    [XmlType(AnonymousType = true)]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "task")]
    public class TaskListDto
    {
        [XmlArray("compulsory_task")]
        [XmlArrayItem("base_setting", IsNullable = false)]
        public TaskBaseSettingDto[] compulsory_task { get; set; }

        [XmlArray("weekly_task")]
        [XmlArrayItem("base_setting", IsNullable = false)]
        public TaskBaseSettingDto[] weekly_task { get; set; }

        [XmlAttribute]
        public string string_table { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class TaskBaseSettingDto
    {
        [XmlElement("level_setting")]
        public TaskLevelSettingDto[] level_setting { get; set; }

        [XmlAttribute]
        public string name_key { get; set; }

        [XmlAttribute]
        public string mode_type { get; set; }

        [XmlAttribute]
        public string category { get; set; }

        [XmlAttribute]
        public string name { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class TaskLevelSettingDto
    {
        public TaskSelectConditionDto select_condition { get; set; }

        public TaskCompletConditionDto complet_condition { get; set; }

        public TaskRewardDto reward { get; set; }

        [XmlAttribute]
        public uint id { get; set; }

        [XmlAttribute]
        public byte level { get; set; }

        [XmlAttribute]
        public int chance_value { get; set; }

        [XmlAttribute]
        public int add_chance_value { get; set; }

        [XmlAttribute]
        public byte add_chan_limit_lv { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class TaskSelectConditionDto
    {
        public TaskValueDto min_level { get; set; }

        public TaskValueDto max_level { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class TaskCompletConditionDto
    {
        public TaskValueDto repetetion { get; set; }

        public TaskCheckerDto checker_type { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class TaskCheckerDto
    {
        [XmlAttribute]
        public string value { get; set; }

        [XmlAttribute]
        public string data { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class TaskRewardDto
    {
        public TaskValueDto pen { get; set; }
    }

    [XmlType(AnonymousType = true)]
    public class TaskValueDto
    {
        [XmlAttribute]
        public string value { get; set; }
    }
}
