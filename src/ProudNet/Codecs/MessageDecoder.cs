using System.Collections.Generic;
using System.IO;
using System.Linq;
using DotNetty.Buffers;
using DotNetty.Codecs;
using DotNetty.Transport.Channels;
using ProudNet.Serialization;
using ProudNet.Serialization.Messages;
using ReadOnlyByteBufferStream = BlubLib.DotNetty.ReadOnlyByteBufferStream;
using System;

namespace ProudNet.Codecs
{
    internal class MessageDecoder : MessageToMessageDecoder<IByteBuffer>
    {
        private readonly MessageFactory[] _userMessageFactories;

        public MessageDecoder(MessageFactory[] userMessageFactories)
        {
            _userMessageFactories = userMessageFactories;
        }

        protected override void Decode(IChannelHandlerContext context, IByteBuffer message, List<object> output)
        {
            using (var r = new ReadOnlyByteBufferStream(message, false).ToBinaryReader(false))
            {
                var opCode = r.ReadUInt16();
                var isInternal = opCode >= 64000;
                var factory = isInternal
                    ? RmiMessageFactory.Default
                    : _userMessageFactories.FirstOrDefault(userFactory => userFactory.ContainsOpCode(opCode));

                if (factory == null)
                {
#if DEBUG
                    Console.ForegroundColor = ConsoleColor.DarkYellow;
                    Console.WriteLine($"Unkown Opcode!: [{opCode}] " + message.ToArray().ToHexString());
                    Console.ResetColor();
#else
                    throw new ProudException($"No {nameof(MessageFactory)} found for opcode {opCode}");
#endif
                }
#if DEBUG
                //Console.ForegroundColor = ConsoleColor.DarkYellow;
                //Console.WriteLine($"[OPCODE]: [{opCode}] " + message.ToArray().ToHexString());
                //Console.ResetColor();
#endif
                try
                {
                    var newmessage = factory.GetMessage(opCode, r);
                    if (newmessage != null)
                        output.Add(newmessage);
                }
                catch (Exception ex)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine($"[CatchedProudNet-Error]: {ex.Message}");
                    Console.ResetColor();
                }
            }
        }
    }
}
