using System;
using System.Collections;
using System.Linq;
using System.Text;

namespace ProudNet
{
    public static class PacketLog
    {
        public static bool Enabled { get; set; } = true;

        public static Action<string> Sink { get; set; }

        public static void Log(string direction, object message, string who)
        {
            var sink = Sink;
            if (!Enabled || sink == null || message == null)
                return;

            try
            {
                var type = message.GetType();
                var sb = new StringBuilder();
                sb.Append(direction).Append(' ').Append(who).Append(' ').Append(type.Name).Append(" {");
                var first = true;
                foreach (var prop in type.GetProperties().Where(p => p.GetIndexParameters().Length == 0))
                {
                    if (!first)
                        sb.Append(", ");
                    first = false;
                    sb.Append(prop.Name).Append('=').Append(Format(prop.GetValue(message)));
                }
                sb.Append('}');
                sink(sb.ToString());
            }
            catch (Exception ex)
            {
                sink("Unable to log " + message.GetType().Name + ": " + ex.Message);
            }
        }

        private static string Format(object value)
        {
            if (value == null)
                return "null";
            if (value is byte[] bytes)
                return BitConverter.ToString(bytes.Take(64).ToArray()) + (bytes.Length > 64 ? "..." : "") + $"({bytes.Length})";
            if (value is string)
                return "\"" + value + "\"";
            if (value is IEnumerable enumerable)
                return "[" + string.Join(",", enumerable.Cast<object>().Take(16).Select(Format)) + "]";
            return value.ToString();
        }
    }
}
