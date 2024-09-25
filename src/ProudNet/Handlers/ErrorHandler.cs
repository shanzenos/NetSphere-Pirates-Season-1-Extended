﻿using System;
using DotNetty.Transport.Channels;
using Microsoft.Extensions.Logging;

namespace ProudNet.Handlers
{
    
    internal class ErrorHandler : ChannelHandlerAdapter
    {
        private readonly ProudServer _server;
        public ErrorHandler(ProudServer server)
        {
            _server = server;
        }

        public override void ExceptionCaught(IChannelHandlerContext context, Exception exception)
        {
            LoggerMessage.DefineScope($"Unhandled exception");
            var session = context.Channel.GetAttribute(ChannelAttributes.Session).Get();
            _server.RaiseError(new ErrorEventArgs(session, exception));
            //session?.CloseAsync();
        }
    }
}