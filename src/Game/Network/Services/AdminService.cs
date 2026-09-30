using System;
using System.Threading.Tasks;
using BlubLib.DotNetty.Handlers.MessageHandling;
using Netsphere.Network.Message.Game;
using NLog;
using NLog.Fluent;
using ProudNet.Handlers;

namespace Netsphere.Network.Services
{
    internal class AdminService : ProudMessageHandler
    {
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();

        [MessageHandler(typeof(CAdminShowWindowReqMessage))]
        public Task ShowWindowHandler(GameSession session)
        {
            return session.SendAsync(new SAdminShowWindowAckMessage(session.Player.Account.SecurityLevel <= SecurityLevel.User));
        }

        [MessageHandler(typeof(CAdminActionReqMessage))]
        public void AdminActionHandler(GameServer server, GameSession session, CAdminActionReqMessage message)
        {
            var args = message.Command.GetArgs();
            try
            {
                if (!server.CommandManager.Execute(session.Player, args))
                    session.Player.SendConsoleMessage(S4Color.Red + "Unknown command");
            }
            catch (Exception ex)
            {
                Logger.Error()
                    .Account(session)
                    .Exception(ex)
                    .Message($"Command failed: {message.Command}")
                    .Write();

                session.Player.SendConsoleMessage(S4Color.Red + "Command failed");
            }
        }
    }
}
