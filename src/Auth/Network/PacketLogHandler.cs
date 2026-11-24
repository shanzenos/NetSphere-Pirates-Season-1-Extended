using System.Threading.Tasks;
using DotNetty.Transport.Channels;
using ProudNet;
using ProudNet.Handlers;

namespace Netsphere.Network
{
    internal class PacketLogHandler : ProudMessageHandler
    {
        public override Task<bool> OnMessageReceived(IChannelHandlerContext context, object message)
        {
            ProudSession session;
            if (PacketLog.Enabled && GetParameter(context, message, out session))
                PacketLog.Log("C2S", message, session.HostId.ToString());

            return Task.FromResult(false);
        }
    }
}
