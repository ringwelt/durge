module durge.system.streams.crc;

import std.exception : enforceEx;
import durge.common;
import durge.system.streams.stream;

enum CrcStreamMode
{
    Read,
    Write
}

final class CrcStream : Stream
{
    import std.digest.crc : CRC32;
    import std.stdio : EOF;

    private StreamFlags _flags;
    private Stream _stream;
    private CRC32 _crc;

    this(Stream stream)
    {
        this(stream, CrcStreamMode.Read);
    }

    this(Stream stream, CrcStreamMode mode)
    {
        enforceEx!ArgumentNullException(stream !is null, "stream");

        switch (mode)
        {
            case CrcStreamMode.Read:
            {
                enforceEx!ArgumentException(stream.flags & StreamFlags.CanRead, "Stream must support reading.");

                _flags = StreamFlags.CanRead;
                break;
            }

            case CrcStreamMode.Write:
            {
                enforceEx!ArgumentException(stream.flags & StreamFlags.CanWrite, "Stream must support writing.");

                _flags = StreamFlags.CanWrite;
                break;
            }

            default:
                throw new ArgumentException("Parameter mode is out of range.");
        }

        _crc = CRC32();
        _stream = stream;
    }

    @property Stream stream()
    {
        return _stream;
    }

    @property void stream(Stream stream)
    {
        enforceEx!ArgumentNullException(stream !is null, "stream");

        if (_flags & StreamFlags.CanRead)
        {
            enforceEx!ArgumentException(stream.flags & StreamFlags.CanRead, "Stream must support reading.");
        }

        if (_flags & StreamFlags.CanWrite)
        {
            enforceEx!ArgumentException(stream.flags & StreamFlags.CanWrite, "Stream must support writing.");
        }

        _stream = stream;
    }

    void reset()
    {
        _crc.start();
    }

    @property uint32 crc()
    {
        auto rawCrc = _crc.peek();
        return *(cast (uint32*) rawCrc.ptr);
    }

    override @property StreamFlags flags()
    {
        return _flags;
    }

    override int readByte()
    {
        enforceEx!StreamException(_flags & StreamFlags.CanRead, "Stream does not support reading.");

        auto value = _stream.readByte();

        if (value != EOF)
        {
            _crc.put(cast (ubyte) value);
        }

        return value;
    }

    override size_t readBytes(ubyte* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");
        enforceEx!StreamException(_flags & StreamFlags.CanRead, "Stream does not support reading.");

        auto bytesRead = _stream.readBytes(buffer, count);

        if (bytesRead > 0)
        {
            _crc.put(buffer[0..bytesRead]);
        }

        return bytesRead;
    }

    override void writeByte(ubyte value)
    {
        enforceEx!StreamException(_flags & StreamFlags.CanWrite, "Stream does not support writing.");

        _stream.writeByte(value);
        _crc.put(value);
    }

    override void writeBytes(const (ubyte)* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");
        enforceEx!StreamException(_flags & StreamFlags.CanWrite, "Stream does not support writing.");

        _stream.writeBytes(buffer, count);

        if (count > 0)
        {
            _crc.put(buffer[0..count]);
        }
    }
}
