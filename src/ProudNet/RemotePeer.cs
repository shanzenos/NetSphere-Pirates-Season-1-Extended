﻿using System.Collections.Concurrent;
using System.Net;
using System.Threading.Tasks;

namespace ProudNet
{
    public class RemotePeer
    {
        public P2PGroup Group { get; }
        public uint HostId { get; }
        internal Crypt Crypt { get; }
        internal ConcurrentDictionary<uint, P2PConnectionState> ConnectionStates { get; }
        internal ProudSession Session { get; }
        public IPEndPoint EndPoint { get; internal set; }     //p2p endpoints 
        public IPEndPoint LocalEndPoint { get; internal set; }

        internal RemotePeer(P2PGroup group, ProudSession session, Crypt crypt)
        {
            Group = group;
            HostId = session.HostId;
            Crypt = crypt;
            ConnectionStates = new ConcurrentDictionary<uint, P2PConnectionState>();
            Session = session;
        }

        public Task SendAsync(object message) => Session.SendAsync(message);
    }
}
