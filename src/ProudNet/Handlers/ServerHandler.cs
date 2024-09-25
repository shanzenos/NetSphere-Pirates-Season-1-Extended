using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using BlubLib.DotNetty.Handlers.MessageHandling;
using ProudNet.Serialization.Messages;
using ProudNet.Serialization.Messages.Core;

namespace ProudNet.Handlers
{
    internal class ServerHandler : ProudMessageHandler //[p2p] peer to peer connections are primarily handled in this file
    {
        [MessageHandler(typeof(ReliablePingMessage))] //ping-pong, useless on dotnetty since i dont see any way here to get the very basic tcp-success message of the client to calc ping
        public Task ReliablePing(ProudSession session)
        {
            return session.SendAsync(new ReliablePongMessage()); //--> sends this message, CORE gets classic tcp protocol info that client got the message and calcs ping, missing here!!
        }

        [MessageHandler(typeof(P2PGroup_MemberJoin_AckMessage))] //client->response->joined p2p group (unreliable, cuz only for p2p)
        public void P2PGroupMemberJoinAck(ProudSession session, P2PGroup_MemberJoin_AckMessage message)
        {
            if (session.P2PGroup == null || session.HostId == message.AddedMemberHostId)
                return;

            var remotePeer = session.P2PGroup?.Members[session.HostId];
            var connectionState = remotePeer?.ConnectionStates.GetValueOrDefault(message.AddedMemberHostId);

            if (connectionState?.EventId != message.EventId)
                return;

            connectionState.IsJoined = true;
            var connectionStateB = connectionState.RemotePeer.ConnectionStates[session.HostId];
            if (connectionStateB.IsJoined)
            {
                remotePeer.SendAsync(new P2PRecycleCompleteMessage(connectionState.RemotePeer.HostId));  //something
                connectionState.RemotePeer.SendAsync(new P2PRecycleCompleteMessage(session.HostId));     //something
            }
        }

        [MessageHandler(typeof(NotifyP2PHolepunchSuccessMessage))] //result from RequestP2PHolepunchMessage, connect because local
        public void NotifyP2PHolepunchSuccess(ProudSession session, NotifyP2PHolepunchSuccessMessage message)
        {
            var group = session.P2PGroup;
            if (group == null || (session.HostId != message.A && session.HostId != message.B))
                return;
            
            var remotePeerA = group.Members.GetValueOrDefault(message.A);
            var remotePeerB = group.Members.GetValueOrDefault(message.B);
            
            if (remotePeerA == null || remotePeerB == null)
                return;
            
            var stateA = remotePeerA.ConnectionStates.GetValueOrDefault(remotePeerB.HostId);
            var stateB = remotePeerB.ConnectionStates.GetValueOrDefault(remotePeerA.HostId);
            
            if (stateA == null || stateB == null)
                return;
            
            if (session.HostId == remotePeerA.HostId)
                stateA.HolepunchSuccess = true;
            if (session.HostId == remotePeerB.HostId)
                stateB.HolepunchSuccess = true;

            //if (stateA.HolepunchSuccess && stateB.HolepunchSuccess) //prevents p2p from working correctly
            //{
            //}

            var notify = new NotifyDirectP2PEstablishMessage(message.A, message.B, message.ABSendAddr, message.ABRecvAddr, message.BASendAddr, message.BARecvAddr);
            remotePeerA.SendAsync(notify);
            remotePeerB.SendAsync(notify);
        }

        [MessageHandler(typeof(ShutdownTcpMessage))] //disconnect client
        public void ShutdownTcp(ProudSession session)
        {
            session.CloseAsync();
        }

        [MessageHandler(typeof(NotifyLogMessage))] //sends many debug info
        public void NotifyLog(NotifyLogMessage message)
        {
            //Logger<>.Debug($"{message.TraceId} - {message.Message}");
        }

        [MessageHandler(typeof(NotifyJitDirectP2PTriggeredMessage))] //result from RequestP2PHolepunchMessage, connect globally
        public void NotifyJitDirectP2PTriggered(ProudSession session, NotifyJitDirectP2PTriggeredMessage message)
        {
            var group = session.P2PGroup;

            if (group == null)
                return;

            var remotePeerA = group.Members.GetValueOrDefault(session.HostId);
            var remotePeerB = group.Members.GetValueOrDefault(message.HostId);

            if (remotePeerA == null || remotePeerB == null)
                return;

            var stateA = remotePeerA.ConnectionStates.GetValueOrDefault(remotePeerB.HostId);
            var stateB = remotePeerB.ConnectionStates.GetValueOrDefault(remotePeerA.HostId);

            if (stateA == null || stateB == null)
                return;

            if (session.HostId == remotePeerA.HostId)
                stateA.JitTriggered = true;
            if (session.HostId == remotePeerB.HostId)
                stateB.JitTriggered = true;

            //if (stateA.JitTriggered && stateB.JitTriggered) //prevents p2p from working correctly
            //{
            //}


            //Proud::INetServerImpl_CreateUdpSocketsIfNeeded(remotePeerA)  not needed? dunno it would send a S2C_RequestCreateUdpSocketMessage to client if it has no free sockets BUT its useless??? clients did already communicate?!
            //Proud::INetServerImpl_CreateUdpSocketsIfNeeded(remotePeerB)  not needed? dunno it would send a S2C_RequestCreateUdpSocketMessage to client if it has no free sockets BUT its useless??? clients did already communicate?!

            remotePeerA.SendAsync(new NewDirectP2PConnectionMessage(remotePeerB.HostId));
            remotePeerB.SendAsync(new NewDirectP2PConnectionMessage(remotePeerA.HostId));
        }

        [MessageHandler(typeof(NotifyNatDeviceNameDetectedMessage))]
        public void NotifyNatDeviceNameDetected()
        { }

        [MessageHandler(typeof(C2S_RequestCreateUdpSocketMessage))] //udp relay --> request udp socket for udp relay and/or p2p
        public void C2S_RequestCreateUdpSocket(ProudServer server, ProudSession session)
        {
            if (session.P2PGroup == null || !server.UdpSocketManager.IsRunning)
                return;
            var socket = server.UdpSocketManager.NextSocket();

            //Console.WriteLine($"{session.RemoteEndPoint}  new socket");

            session.UdpSocket = socket;
            session.HolepunchMagicNumber = Guid.NewGuid();
            session.SendAsync(new S2C_RequestCreateUdpSocketMessage(new IPEndPoint(server.UdpSocketManager.Address, ((IPEndPoint)socket.Channel.LocalAddress).Port))); //possible use for ----> create socket if needed???? maybe?????
        }

        [MessageHandler(typeof(C2S_CreateUdpSocketAckMessage))] //client has created a new socket available for p2p
        public void C2S_CreateUdpSocketAck(ProudServer server, ProudSession session, C2S_CreateUdpSocketAckMessage message)
        {
            if (session.P2PGroup == null || !server.UdpSocketManager.IsRunning)
                return;

            //Logger<>.Debug($"Client:{session.HostId} - Starting server holepunch");
            session.SendAsync(new RequestStartServerHolepunchMessage(session.HolepunchMagicNumber));
        }

        [MessageHandler(typeof(ReportC2SUdpMessageTrialCountMessage))]
        public void ReportC2SUdpMessageTrialCount()
        { }
    }
}
