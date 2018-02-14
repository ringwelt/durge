module durge.system.streams.stream;

import std.exception : enforceEx;
import std.conv : text;
import durge.common;

class StreamException : Exception
{
    this(string msg, string file = __FILE__, size_t line = __LINE__)
    {
        super(msg, file, line);
    }

    this(string msg, Throwable next, string file = __FILE__, size_t line = __LINE__)
    {
        super(msg, next, file, line);
    }
}

class EndOfStreamException : StreamException
{
    this(string file = __FILE__, size_t line = __LINE__)
    {
        super("Unexpected end of stream.", file, line);
    }
}

enum StreamFlags
{
    None      = 0,
    CanRead   = 0b0001,
    CanWrite  = 0b0010,
    CanSeek   = 0b0100,
    CanResize = 0b1000
}

enum SeekOrigin
{
    Begin,
    Current,
    End
}

abstract class Stream
{
    import std.traits : isBasicType;

    @property StreamFlags flags()
    {
        return StreamFlags.None;
    }

    @property long position()
    {
        throw new StreamException("Stream does not support seeking.");
    }

    @property void position(long value)
    {
        throw new StreamException("Stream does not support seeking.");
    }

    @property long length()
    {
        throw new StreamException("Stream does not support seeking.");
    }

    @property void length(long value)
    {
        throw new StreamException("Stream does not support resizing.");
    }

    @property bool eof()
    {
        return false;
    }

    long seek(long offset, SeekOrigin origin)
    {
        throw new StreamException("Stream does not support seeking.");
    }

    int readByte()
    {
        throw new StreamException("Stream does not support reading.");
    }

    size_t readBytes(ubyte* buffer, size_t count)
    {
        throw new StreamException("Stream does not support reading.");
    }

    final bool readItem(T)(out T item)
        if (isBasicType!T || is(T == struct))
    {
        return readBytes(cast (ubyte*) &item, T.sizeof) == T.sizeof;
    }

    final size_t readItems(T)(T[] items)
        if (isBasicType!T || is(T == struct))
    {
        return readBytes(items.ptr, T.sizeof * items.length) / T.sizeof;
    }

    void writeByte(ubyte value)
    {
        throw new StreamException("Stream does not support writing.");
    }

    void writeBytes(const (ubyte)* buffer, size_t count)
    {
        throw new StreamException("Stream does not support writing.");
    }

    final void writeItem(T)(in T item)
        if (isBasicType!T || is(T == struct))
    {
        writeBytes(cast (ubyte*) &item, T.sizeof);
    }
 
    final void writeItems(T)(T[] items)
        if (isBasicType!T || is(T == struct))
    {
        writeBytes(items.ptr, T.sizeof * items.length);
    }

    void flush()
    {
        // do nothing.
    }

    void close()
    {
        // do nothing.
    }
}

final class NullStream : Stream
{
    override @property StreamFlags flags()
    {
        return StreamFlags.CanRead | StreamFlags.CanWrite;
    }

    override int readByte()
    {
        return 0;
    }

    override size_t readBytes(ubyte* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");

        if (count > 0)
        {
            buffer[0..count] = 0;
        }

        return count;
    }

    override void writeByte(ubyte value)
    {
        // do nothing.
    }

    override void writeBytes(const (ubyte)* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");

        // do nothing.
    }
}
