using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using BlubLib.DotNetty;
using BlubLib.DotNetty.Handlers.MessageHandling;
using DotNetty.Buffers;
using DotNetty.Transport.Channels;
using DotNetty.Transport.Channels.Sockets;
using ProudNet.Codecs;
using ProudNet.Serialization;
using ProudNet.Serialization.Messages;
using ProudNet.Serialization.Messages.Core;

namespace ProudNet.Handlers
{
    internal class CoreHandler : ProudMessageHandler //[p2p] peer to peer connections are primarily handled in this file
    {
        private readonly ProudServer _server;
        private readonly Lazy<DateTime> _startTime = new Lazy<DateTime>(() => Process.GetCurrentProcess().StartTime);

        public CoreHandler(ProudServer server)
        {
            _server = server;
        }

        [MessageHandler(typeof(RmiMessage))] // normal packet message
        public void RmiMessage(IChannelHandlerContext context, RmiMessage message)
        {
            var buffer = Unpooled.WrappedBuffer(message.Data);
            context.FireChannelRead(buffer);
        }

        [MessageHandler(typeof(CompressedMessage))] //message inside message/big message, compressed, decond and re-read
        public void CompressedMessage(IChannelHandlerContext context, CompressedMessage message)
        {
            var decompressed = message.Data.DecompressZLib();
            var buffer = Unpooled.WrappedBuffer(decompressed);
            context.Channel.Pipeline.Context<ProudFrameDecoder>().FireChannelRead(buffer);
        }

        [MessageHandler(typeof(EncryptedReliableMessage))]
        public void EncryptedReliableMessage(IChannelHandlerContext context, ProudSession session, EncryptedReliableMessage message)//reads proudnet message and decodes them to the server message (message inside message)
        {
            Crypt crypt;
            crypt = session.Crypt;
            var buffer = context.Allocator.Buffer(message.Data.Length);
            using (var src = new MemoryStream(message.Data))
            using (var dst = new WriteOnlyByteBufferStream(buffer, false))
                crypt.Decrypt(src, dst, true);
            context.Channel.Pipeline.Context<ProudFrameDecoder>().FireChannelRead(buffer);
        }

        [MessageHandler(typeof(NotifyCSEncryptedSessionKeyMessage))]
        public void NotifyCSEncryptedSessionKeyMessage(IChannelHandlerContext context, ProudSession session, NotifyCSEncryptedSessionKeyMessage message) //send client session encryption key
        {
            using (var rsa = new RSACryptoServiceProvider(1024))
            {
                rsa.ImportCspBlob(message.Key);
                session.Crypt = new Crypt(_server.Configuration.EncryptedMessageKeyLength);
                byte[] blob;
                using (var w = new MemoryStream().ToBinaryWriter(false))
                {
                    w.Write((byte)1);
                    w.Write((byte)2);
                    w.Write((byte)0);
                    w.Write((byte)0);
                    w.Write(26625);
                    w.Write(41984);
                    var encrypted = rsa.Encrypt(session.Crypt.RC4.Key, false);
                    w.Write(encrypted.Reverse());
                    blob = w.ToArray();
                }
                session.SendAsync(new NotifyCSSessionKeySuccessMessage(blob));
            }
        }

        [MessageHandler(typeof(NotifyServerConnectionRequestDataMessage))]//client connects to server, proudapi checks version n' shit
        public void NotifyServerConnectionRequestDataMessage(IChannelHandlerContext context, ProudSession session, NotifyServerConnectionRequestDataMessage message)
        {
            if (message.InternalNetVersion != Constants.NetVersion || message.Version != _server.Configuration.Version)
            {
                session.SendAsync(new NotifyProtocolVersionMismatchMessage());
                session.CloseAsync();
                return;
            }
            _server.AddSession(session);
            session.HandhsakeEvent.Set();
            session.SendAsync(new NotifyServerConnectSuccessMessage(session.HostId, _server.Configuration.Version, session.RemoteEndPoint)); // send success if everything is okay
        }

        [MessageHandler(typeof(UnreliablePingMessage))] //unreliable(udp) ping --> udp never tells u if peer got the message or not, --> "workaround" with client/server time, not accurate
        public void UnreliablePingHandler(IChannelHandlerContext context, ProudSession session, UnreliablePingMessage message)
        {
            session.UnreliablePing = TimeSpan.FromSeconds(message.Ping).TotalMilliseconds;
            var ts = DateTime.Now - _startTime.Value;
            session.SendUdpIfAvailableAsync(new UnreliablePongMessage(message.ClientTime, ts.TotalSeconds));
        }

        [MessageHandler(typeof(SpeedHackDetectorPingMessage))] 
        public void SpeedHackDetectorPingHandler(ProudSession session)
        {
            session.LastSpeedHackDetectorPing = DateTime.Now;
        }

        [MessageHandler(typeof(ReliableRelay1Message))] //Handles RT/Relay'd TCP messages --> client2server2client
        public void ReliableRelayHandler(IChannel channel, ProudSession session, ReliableRelay1Message message)
        {
            if (session.P2PGroup == null){return;}
            foreach (var destination in message.Destination)//this is bugging --> destinations are fucked for ex damage and other weird stuff like hp display
            {
                if (session.P2PGroup == null){return;}
                if (!session.P2PGroup.Members.ContainsKey(destination.HostId)){return;}       
                var target = _server.Sessions.GetValueOrDefault(destination.HostId);
                target?.SendAsync(new ReliableRelay2Message(new RelayDestinationDto(session.HostId, destination.FrameNumber), message.Data));
            }
        }

        [MessageHandler(typeof(UnreliableRelay1Message))] //Handles RT/Relay'd UDP messages --> client2server2client
        public void UnreliableRelayHandler(IChannel channel, ProudSession session, UnreliableRelay1Message message)
        {
            foreach (var destination in message.Destination)//this is bugging --> destinations are fucked for ex chat/damage/hp display
            {
                if (session.P2PGroup == null){return;}          
                if (!session.P2PGroup.Members.ContainsKey(destination)){return;}
                var target = _server.Sessions.GetValueOrDefault(destination);
                target?.SendUdpIfAvailableAsync(new UnreliableRelay2Message(session.HostId, message.Data));
            }
        }

        [MessageHandler(typeof(ServerHolepunchMessage))] //client trys to connect to server
        public void NotifyHolepunchSuccess(ProudServer server, ProudSession session, ServerHolepunchMessage message)
        {
            if (session.P2PGroup == null || !_server.UdpSocketManager.IsRunning || session.HolepunchMagicNumber != message.MagicNumber){return; }
            //Console.WriteLine($"{session.RemoteEndPoint} ServerHolepunchMessage!! {session.UdpEndPoint}");
            session.SendUdpAsync(new ServerHolepunchAckMessage(session.HolepunchMagicNumber, session.UdpEndPoint));// udp connection succeeded, sending return info
        }

        [MessageHandler(typeof(NotifyHolepunchSuccessMessage))] //client says return info is right
        public void NotifyHolepunchSuccess(ProudServer server, ProudSession session, NotifyHolepunchSuccessMessage message)
        {
            if (session.P2PGroup == null || !_server.UdpSocketManager.IsRunning || session.HolepunchMagicNumber != message.MagicNumber){return;}

            //Console.WriteLine($"{session.RemoteEndPoint} NotifyHolepunchSuccessMessage!! {message.LocalEndPoint} {message.EndPoint}");

            session.UdpEnabled = true;
            session.UdpLocalEndPoint = message.LocalEndPoint;
            session.SendUdpAsync(new NotifyClientServerUdpMatchedMessage(message.MagicNumber)); //matches, right client, right connection
        }

        [MessageHandler(typeof(PeerUdp_ServerHolepunchMessage))] //prepare p2p #3
        public void PeerUdp_ServerHolepunch(IChannel channel, ProudSession session, PeerUdp_ServerHolepunchMessage message)
        {
            if (!session.UdpEnabled || !_server.UdpSocketManager.IsRunning)
                return;
            var target = session.P2PGroup?.Members.GetValueOrDefault(message.HostId)?.Session;
            if (target == null || !target.UdpEnabled)
                return;
            session.SendUdpAsync(new PeerUdp_ServerHolepunchAckMessage(message.MagicNumber, target.UdpEndPoint, target.HostId));
        }

        [MessageHandler(typeof(PeerUdp_NotifyHolepunchSuccessMessage))] //request holepunch --> results in ServerHandler.cs
        public void PeerUdp_NotifyHolepunchSuccess(IChannel channel, ProudSession session, PeerUdp_NotifyHolepunchSuccessMessage message)
        {
            if (!session.UdpEnabled || !_server.UdpSocketManager.IsRunning)
                return;

            var A = session.P2PGroup?.Members[session.HostId];
            var B = session.P2PGroup?.Members[message.HostId];
            var connectionStateA = A.ConnectionStates.GetValueOrDefault(message.HostId);
            var connectionStateB = connectionStateA.RemotePeer.ConnectionStates[session.HostId];

            connectionStateA.RemotePeer.EndPoint = message.EndPoint;              //save endpoints
            connectionStateA.RemotePeer.LocalEndPoint = message.LocalEndPoint;    //save endpoints
            connectionStateA.PeerUdpHolepunchSuccess = true;                            //ready

            if (connectionStateB.PeerUdpHolepunchSuccess) //false at first, but then true for second client -> both clients are ready for holepunch
            {
                A.SendAsync(new RequestP2PHolepunchMessage(message.HostId, B.Session.UdpLocalEndPoint, new IPEndPoint(connectionStateA.RemotePeer.EndPoint.Address, connectionStateB.RemotePeer.LocalEndPoint.Port)));
                B.Session.SendAsync(new RequestP2PHolepunchMessage(session.HostId, A.Session.UdpLocalEndPoint, new IPEndPoint(connectionStateB.RemotePeer.EndPoint.Address, connectionStateA.RemotePeer.LocalEndPoint.Port)));
            }
        }
    }
}
