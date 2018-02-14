module durge.system.streams.memory;

import std.exception : enforceEx;
import durge.common;
import durge.system.streams.stream;

final class MemoryStream : Stream
{
    import std.stdio : EOF;

    private StreamFlags _flags;
    private ubyte[] _buffer;
    private size_t _position;

    this(ubyte[] buffer, bool readOnly = false)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");

        _flags = StreamFlags.CanRead | StreamFlags.CanSeek;
        _buffer = buffer;

        if (!readOnly)
        {
            _flags |= StreamFlags.CanWrite;
        }
    }

    override @property StreamFlags flags() { return _flags; }
    override @property long position() { return _position; }
    override @property void position(long value) { seek(value, SeekOrigin.Begin); }
    override @property long length() { return _buffer.length; }
    override @property bool eof() { return _position >= _buffer.length; }

    override long seek(long offset, SeekOrigin origin)
    {
        long newPosition;

        switch (origin)
        {
            case SeekOrigin.Begin: newPosition = offset; break;
            case SeekOrigin.Current: newPosition = _position + offset; break;
            case SeekOrigin.End: newPosition = _buffer.length + offset; break;
            default: throw new ArgumentException("Parameter origin is out of range.");
        }

        enforceEx!ArgumentException(newPosition >= 0, "New position must not be negative.");
        enforceEx!ArgumentException(newPosition <= _buffer.length, "New position must not be greater than buffer length.");

        _position = cast (size_t) newPosition;
        return _position;
    }

    override int readByte()
    {
        return _position < _buffer.length ? _buffer[_position++] : EOF;
    }

    override size_t readBytes(ubyte* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");

        auto bytesLeft = _buffer.length - _position;

        if (bytesLeft < count)
        {
            count = bytesLeft;
        }

        if (count > 0)
        {
            buffer[0..count] = _buffer[_position.._position + count];
            _position += count;
        }

        return count;
    }

    override void writeByte(ubyte value)
    {
        enforceEx!EndOfStreamException(_position < _buffer.length);

        _buffer[_position++] = cast (ubyte) value;
    }

    override void writeBytes(const (ubyte)* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");
        enforceEx!EndOfStreamException(_position + count < _buffer.length);

        if (count > 0)
        {
            _buffer[_position.._position + count] = buffer[0..count];
            _position += count;
        }
    }
}
