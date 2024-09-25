using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Text;
using Dapper.FastCrud;
using Netsphere.Database.Auth;
using Netsphere.Network;
using Netsphere.Network.Message.Chat;

namespace Netsphere.Commands
{
    internal class GMCommands : ICommand
    {
        public string Name { get; }
        public bool AllowConsole { get; }
        public RoomManager RoomManager { get; }
        public SecurityLevel Permission { get; }
        public IReadOnlyList<ICommand> SubCommands { get; }

        public GMCommands()
        {
            Name = "gm";
            AllowConsole = true;
            Permission = SecurityLevel.GameMaster;
            SubCommands = new ICommand[] {new KickCommand(), new BanCommand(), new KillRoomCommand()};
        }

        public bool Execute(GameServer server, Player plr, string[] args)
        {
            return true;
        }

        public string Help()
        {
            var sb = new StringBuilder();
            sb.AppendLine(Name);
            foreach (var cmd in SubCommands)
            {
                sb.Append("\t");
                sb.AppendLine(cmd.Help());
            }
            return sb.ToString();
        }

        private class KickCommand : ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public KickCommand()
            {
                Name = "kick";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }

            public bool Execute(GameServer server, Player plr, string[] args)
            {
                if (args.Length < 1)
                    return false;
                Player kickedPlayer = GameServer.Instance.PlayerManager.Get(args[0]);
                if (kickedPlayer != null && kickedPlayer.Room != null)
                {
                    kickedPlayer.Room.Leave(kickedPlayer, RoomLeaveReason.ModeratorKick);
                    KickMessage(kickedPlayer);
                    return true;
                }
                return false;
            }

            private async Task KickMessage(Player kPlr)
            {
                await Task.Delay(2000);
                kPlr.ChatSession.SendAsync(new SChatMessageAckMessage(ChatType.Channel, kPlr.Account.Id, "SYSTEM", $"You have been kicked by Moderator"));
            }
            public string Help()
            {
                return Name;
            }
        }
        private class BanCommand: ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public BanCommand()
            {
                Name = "ban";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }
            public bool Execute(GameServer server, Player plr, string[] args)
            {
                if (args.Length < 3)
                    return false;
                Player bannedPlayer = GameServer.Instance.PlayerManager.Get(args[0]);
                int duration;
                if (!Int32.TryParse(args[1], out duration))
                    duration = 0;
                duration = 86400 * duration;
                
                string reason = args[2];
                if (bannedPlayer != null)
                {
                    if (bannedPlayer.Room != null)
                    {
                        bannedPlayer.Room.Leave(bannedPlayer, RoomLeaveReason.ModeratorKick);
                    }
                    bannedPlayer.Disconnect();
                    banPlayer(bannedPlayer, duration, reason);
                }
                return false;
            }
            private async Task banPlayer(Player banPlr,int banDur,string banRea)
            {
                using (var db = AuthDatabase.Open())
                {
                    var bannedDto = new BanDto
                    {
                        AccountId = unchecked((int)banPlr.Account.Id),
                        Date = DateTimeOffset.Now.ToUnixTimeSeconds(),
                        Duration = banDur,
                        Reason = banRea

                    };
                    await db.InsertAsync(bannedDto);
                }
            }
            public string Help()
            {
                return Name;
            }
        }
        private class KillRoomCommand: ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public KillRoomCommand()
            {
                Name = "killroom";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }
            public bool Execute(GameServer server, Player plr, string[] args)
            {
                if (args.Length < 2)
                    return false;
                uint channelId;
                uint roomId;
                if (!uint.TryParse(args[0], out channelId))
                    return false;
                if (!uint.TryParse(args[1], out roomId))
                    return false;
                Room room=server.ChannelManager.GetChannel(channelId).RoomManager.Get(roomId);

                if (room.Players.Count > 0)
                {
                    foreach (var kplr in room.Players.Values)
                        kplr.Room.Leave(kplr, RoomLeaveReason.ModeratorKick);
                }
                else
                {
                    room.RoomManager.Remove(room);
                }
                //todo add chat message to server explaining room was deleted
                return true;
            }
            public string Help()
            {
                return Name;
            }
        }
    }
}
