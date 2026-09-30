using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Netsphere.Network;
using Netsphere.Network.Message.Game;

namespace Netsphere.Commands
{
    internal class AdminCommands : ICommand
    {
        public string Name { get; }
        public bool AllowConsole { get; }
        public SecurityLevel Permission { get; }
        public IReadOnlyList<ICommand> SubCommands { get; }

        public AdminCommands()
        {
            Name = "admin";
            AllowConsole = true;
            Permission = SecurityLevel.GameMaster;
            SubCommands = new ICommand[]
            {
                new OnlineCommand(),
                new WhereCommand(),
                new NoticeCommand(),
                new PenCommand(),
                new ApCommand(),
                new LevelCommand(),
                new SecLevelCommand(),
                new EndMatchCommand()
            };
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

        private static void Say(Player plr, string message)
        {
            if (plr == null)
                Console.WriteLine(message);
            else
                plr.SendConsoleMessage(S4Color.Green + message);
        }

        private static Player Find(GameServer server, Player plr, string nickname)
        {
            var target = server.PlayerManager.Get(nickname);
            if (target == null)
                Say(plr, $"{nickname} is not online");

            return target;
        }

        private class OnlineCommand : ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public OnlineCommand()
            {
                Name = "online";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }

            public bool Execute(GameServer server, Player plr, string[] args)
            {
                var players = server.PlayerManager.ToArray();
                var text = new StringBuilder($"{players.Length} online: ");
                foreach (var p in players)
                    text.Append(p.Account.Nickname + " ");

                Say(plr, text.ToString());
                return true;
            }

            public string Help()
            {
                return Name;
            }
        }

        private class WhereCommand : ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public WhereCommand()
            {
                Name = "where";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }

            public bool Execute(GameServer server, Player plr, string[] args)
            {
                if (args.Length < 1)
                {
                    Say(plr, Help());
                    return true;
                }

                var target = Find(server, plr, args[0]);
                if (target == null)
                    return true;

                var channel = target.Channel != null ? target.Channel.Id.ToString() : "none";
                var room = target.Room != null
                    ? $"{target.Room.Id} ({target.Room.GameRuleManager.GameRule.GameRule}, {target.Room.GameRuleManager.GameRule.StateMachine.State})"
                    : "none";

                Say(plr, $"{target.Account.Nickname}: channel {channel}, room {room}, level {target.Level}");
                return true;
            }

            public string Help()
            {
                return Name + " <nickname>";
            }
        }

        private class NoticeCommand : ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public NoticeCommand()
            {
                Name = "notice";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }

            public bool Execute(GameServer server, Player plr, string[] args)
            {
                if (args.Length < 1)
                {
                    Say(plr, Help());
                    return true;
                }

                server.BroadcastNotice(string.Join(" ", args));
                return true;
            }

            public string Help()
            {
                return Name + " <message>";
            }
        }

        private class PenCommand : ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public PenCommand()
            {
                Name = "pen";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }

            public bool Execute(GameServer server, Player plr, string[] args)
            {
                uint amount;
                if (args.Length < 2 || !uint.TryParse(args[1], out amount))
                {
                    Say(plr, Help());
                    return true;
                }

                var target = Find(server, plr, args[0]);
                if (target == null)
                    return true;

                target.PEN = amount;
                target.Save();
                target.Session?.SendAsync(new SRefreshCashInfoAckMessage(target.PEN, target.AP));
                Say(plr, $"{target.Account.Nickname} now has {amount} PEN");
                return true;
            }

            public string Help()
            {
                return Name + " <nickname> <amount>";
            }
        }

        private class ApCommand : ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public ApCommand()
            {
                Name = "ap";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }

            public bool Execute(GameServer server, Player plr, string[] args)
            {
                uint amount;
                if (args.Length < 2 || !uint.TryParse(args[1], out amount))
                {
                    Say(plr, Help());
                    return true;
                }

                var target = Find(server, plr, args[0]);
                if (target == null)
                    return true;

                target.AP = amount;
                target.Save();
                target.Session?.SendAsync(new SRefreshCashInfoAckMessage(target.PEN, target.AP));
                Say(plr, $"{target.Account.Nickname} now has {amount} AP");
                return true;
            }

            public string Help()
            {
                return Name + " <nickname> <amount>";
            }
        }

        private class LevelCommand : ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public LevelCommand()
            {
                Name = "level";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }

            public bool Execute(GameServer server, Player plr, string[] args)
            {
                byte level;
                if (args.Length < 2 || !byte.TryParse(args[1], out level))
                {
                    Say(plr, Help());
                    return true;
                }

                var target = Find(server, plr, args[0]);
                if (target == null)
                    return true;

                var exp = server.ResourceCache.GetExperience();
                var info = exp.GetValueOrDefault(level);
                if (info == null)
                {
                    Say(plr, $"Level {level} is not in the experience table");
                    return true;
                }

                target.Level = level;
                target.TotalExperience = (uint)info.TotalExperience;
                target.Save();
                Say(plr, $"{target.Account.Nickname} is now level {level}");
                return true;
            }

            public string Help()
            {
                return Name + " <nickname> <level>";
            }
        }

        private class SecLevelCommand : ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public SecLevelCommand()
            {
                Name = "seclevel";
                AllowConsole = true;
                Permission = SecurityLevel.Developer;
                SubCommands = new ICommand[0];
            }

            public bool Execute(GameServer server, Player plr, string[] args)
            {
                byte level;
                if (args.Length < 2 || !byte.TryParse(args[1], out level))
                {
                    Say(plr, Help());
                    return true;
                }

                var target = Find(server, plr, args[0]);
                if (target == null)
                    return true;

                target.Account.SecurityLevel = (SecurityLevel)level;
                Say(plr, $"{target.Account.Nickname} is {(SecurityLevel)level} until he logs out");
                return true;
            }

            public string Help()
            {
                return Name + " <nickname> <0 user, 1 gm, 2 developer>";
            }
        }

        private class EndMatchCommand : ICommand
        {
            public string Name { get; }
            public bool AllowConsole { get; }
            public SecurityLevel Permission { get; }
            public IReadOnlyList<ICommand> SubCommands { get; }

            public EndMatchCommand()
            {
                Name = "endmatch";
                AllowConsole = true;
                Permission = SecurityLevel.GameMaster;
                SubCommands = new ICommand[0];
            }

            public bool Execute(GameServer server, Player plr, string[] args)
            {
                uint roomId;
                if (args.Length < 1 || !uint.TryParse(args[0], out roomId))
                {
                    Say(plr, Help());
                    return true;
                }

                var room = server.ChannelManager
                    .SelectMany(c => c.RoomManager)
                    .FirstOrDefault(r => r.Id == roomId);

                if (room == null)
                {
                    Say(plr, $"No room {roomId}");
                    return true;
                }

                var rule = room.GameRuleManager.GameRule;
                if (!rule.StateMachine.IsInState(GameRuleState.Playing))
                {
                    Say(plr, $"Room {roomId} is not playing");
                    return true;
                }

                rule.StateMachine.Fire(GameRuleStateTrigger.StartResult);
                Say(plr, $"Room {roomId} sent to the result screen");
                return true;
            }

            public string Help()
            {
                return Name + " <room id>";
            }
        }
    }
}
