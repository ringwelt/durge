module durge.system.streams.deflate;

import core.stdc.errno;
import std.exception : enforceEx;
import durge.common;
import durge.system.streams.stream;

enum DeflateStreamMode
{
    Compress,
    Decompress
}

enum CompressionLevel
{
    Default = -1,
    None    =  0,
    Fastest =  1,
    Best    =  9
}

final class DeflateStream : Stream
{
    import std.algorithm.comparison : min;
    import std.stdio : EOF;
    import etc.c.zlib : Z_NO_FLUSH, Z_SYNC_FLUSH, Z_FINISH;
    import durge.system.Zlib;

    private TExpression wrapZlibException(TExpression)(lazy TExpression expression, lazy string message)
    {
        try
        {
            return expression();
        }
        catch (ZlibException exception)
        {
            throw new StreamException(message, exception);
        }
    }

    private const defaultBufferSize = 8192;

    private StreamFlags _flags;
    private Stream _stream;
    private int _level;
    private ZlibData _zlib;
    private size_t _bufferSize;
    private ubyte[] _inBuffer;
    private ubyte[] _outBuffer;
    private size_t _inBufferPosition;
    private size_t _outBufferPosition;

    this(Stream stream, DeflateStreamMode mode)
    {
        this(stream, mode, CompressionLevel.Default);
    }

    this(Stream stream, CompressionLevel level)
    {
        this(stream, DeflateStreamMode.Compress, cast (int) level);
    }

    this(Stream stream, int level)
    {
        this(stream, DeflateStreamMode.Compress, level);
    }

    private this(Stream stream, DeflateStreamMode mode, int level)
    {
        enforceEx!ArgumentNullException(stream !is null, "stream");
        enforceEx!ArgumentException(level >= -1 && level <= 9, "Parameter level is out of range.");

        switch (mode)
        {
            case DeflateStreamMode.Compress:
            {
                enforceEx!ArgumentException(stream.flags & StreamFlags.CanRead, "Stream must support reading.");

                _flags = StreamFlags.CanRead;
                break;
            }

            case DeflateStreamMode.Decompress:
            {
                enforceEx!ArgumentException(stream.flags & StreamFlags.CanWrite, "Stream must support writing.");

                _flags = StreamFlags.CanWrite;
                break;
            }

            default:
                throw new ArgumentException("Parameter mode is out of range.");
        }

        _stream = stream;
        _level = level;
        _bufferSize = defaultBufferSize;
    }

    ~this()
    {
        enforceEx!(StreamException)(_stream is null, "Stream must be closed before destructor is called.");
    }

    @property Stream stream() { return _stream; }
    override @property StreamFlags flags() { return _flags; }

    // Todo: readByte()
    /+override int readByte()
    {
        enforceEx!StreamException(_stream !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanRead, "Stream does not support reading.");

        if (_outBuffer is null)
        {
            readInit();
        }

        if (_outBufferPosition == _outBufferLength)
        {
            _zlib.next_out = _outBuffer.ptr;
            _zlib.avail_out = _outBuffer.length;

            readInflate();
        }

        auto value = EOF;

        if (_outBufferPosition < _outBufferLength)
        {
            value = _outBuffer[_outBufferPosition];
            _outBufferPosition++;
        }

        return value;
    }+/

    // Todo: readBytes()
    /+override size_t readBytes(ubyte* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");
        enforceEx!StreamException(_stream !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanRead, "Stream does not support reading.");

        if (count == 0)
        {
            return 0;
        }

        if (_outBuffer is null)
        {
            readInit();
        }

        size_t bytesInflated = 0;

        do
        {
            auto bytesToInflate = min(count, _zlib.avail_in.max);

            /* set n to the maximum amount of len that fits in an unsigned int */
            n = -1;

            if (n > len)
            {
                n = len;
            }

            /* first just try copying data from the output buffer */
            if (state->x.have)
            {
                if (state->x.have < n)
                {
                    n = state->x.have;
                }

                memcpy(buf, state->x.next, n);

                state->x.next += n;
                state->x.have -= n;
            }
            /* output buffer empty -- return if we're at the end of the input */
            else if (state->eof && state->strm.avail_in == 0)
            {
                state->past = 1;        /* tried to read past end */
                break;
            }
            /* need output data -- for small len or new stream load up our output buffer */
            else if (n < (state->size << 1))
            {
                /* get more output */
                do
                {
                    _zlib.next_out = _outBuffer.ptr;
                    _zlib.avail_out = _outBuffer.length;

                    readInflate();
                }
                while (state->x.have == 0 && (!state->eof || strm->avail_in));

                continue; /* no progress yet -- go back to copy above */
                /* the copy above assures that we will leave with space in the output buffer, allowing at least one gzungetc() to succeed */
            }
            else
            {
                _zlib.next_out = cast (ubyte*) buf;
                _zlib.avail_out = n;

                readInflate();

                n = state->x.have;
                state->x.have = 0;
            }

            buffer += bytesToInflate;
            count -= bytesToInflate;
            bytesInflated += bytesToInflate;
        }
        while (count > 0);

        return bytesInflated;
    }+/

    override void writeByte(ubyte value)
    {
        enforceEx!StreamException(_stream !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanWrite, "Stream does not support writing.");

        if (_inBuffer is null)
        {
            writeInit();
        }

        _inBuffer[_inBufferPosition] = value;
        _inBufferPosition++;

        if (_inBufferPosition == _inBuffer.length)
        {
            _zlib.next_in = _inBuffer.ptr;
            _zlib.avail_in = cast (uint32) _inBufferPosition;

            writeDeflate(Z_NO_FLUSH);
        }
    }

    override void writeBytes(const (ubyte)* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");
        enforceEx!StreamException(_stream !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanWrite, "Stream does not support writing.");

        if (count == 0)
        {
            return;
        }

        if (_inBuffer is null)
        {
            writeInit();
        }

        if (count < _inBuffer.length)
        {
            do
            {
                auto byteCount = min(_inBuffer.length - _inBufferPosition, count);

                _inBuffer[_inBufferPosition.._inBufferPosition + byteCount] = buffer[0..byteCount];
                _inBufferPosition += byteCount;

                buffer += byteCount;
                count -= byteCount;

                if (_inBufferPosition == _inBuffer.length)
                {
                    _zlib.next_in = _inBuffer.ptr;
                    _zlib.avail_in = cast (uint32) _inBufferPosition;

                    writeDeflate(Z_NO_FLUSH);
                }
            }
            while (count > 0);
        }
        else
        {
            if (_inBufferPosition > 0)
            {
                _zlib.next_in = _inBuffer.ptr;
                _zlib.avail_in = cast (uint32) _inBufferPosition;

                writeDeflate(Z_NO_FLUSH);
            }

            do
            {
                auto bytesToDeflate = min(count, _zlib.avail_in.max);

                _zlib.next_in = buffer;
                _zlib.avail_in = bytesToDeflate;

                buffer += bytesToDeflate;
                count -= bytesToDeflate;

                writeDeflate(Z_NO_FLUSH);
            }
            while (count > 0);
        }
    }

    override void flush()
    {
        enforceEx!StreamException(_stream !is null, "Stream is already closed.");

        if (_inBuffer !is null)
        {
            if (_flags & StreamFlags.CanWrite)
            {
                writeDeflate(Z_SYNC_FLUSH);
            }
        }

        _stream.flush();
    }

    override void close()
    {
        if (_stream !is null)
        {
            if (_inBuffer !is null)
            {
                if (_flags & StreamFlags.CanRead)
                {
                    readEnd();
                }
                else if (_flags & StreamFlags.CanWrite)
                {
                    writeDeflate(Z_FINISH);
                    writeEnd();
                }
            }

            _stream = null;
        }
    }

    // Todo: readInit()
    /+private void readInit()
    {
        wrapZlibException!()(Zlib.InflateInit(&_zlib), "Failed to init inflate.");

        _inBuffer = new ubyte[defaultBufferSize];
        _outBuffer = new ubyte[defaultBufferSize << 1];

        _inBufferPosition = 0;
        _inBufferLength = 0;
        _outBufferPosition = 0;
        _outBufferLength = 0;

        _zlib.next_in = null;
        _zlib.avail_in = 0;

        _zlib.next_out = _outBuffer.ptr;
        _zlib.avail_out = _outBuffer.length;
    }+/

    // Todo: readInflate()
    /+private int readInflate()
    {
        auto endOfStream = false;
        uint16 had;

        /* fill output buffer up to end of deflate stream */
        auto had = strm->avail_out;

        do
        {
            if (_zlib.avail_in == 0)
            {
                auto bytesRead = _stream.readBytes(_inBuffer.ptr, _inBuffer.length);

                if (bytesRead == 0)
                {
                    return EOF;
                }

                _inBufferLength = bytesRead;
                _inBufferPosition = 0;

                _zlib.next_in = _inBuffer.ptr;
                _zlib.avail_in = _inBufferLength;
            }

            if (_zlib.avail_in == 0)
            {
                gz_error(state, Z_BUF_ERROR, "unexpected end of file");
                break;
            }

            endOfStream = wrapZlibException!()(Zlib.Inflate(&_zlib, Z_NO_FLUSH), "Failed to inflate.");
        }
        while (_zlib.avail_out > 0 && !endOfStream);

        /* update available output */
        state->x.have = had - strm->avail_out;
        state->x.next = strm->next_out - state->x.have;

        /* if the gzip stream completed successfully, look for another */
        if (ret == Z_STREAM_END)
            state->how = LOOK;

        /* good decompression */
        return 0;

        _outBufferPosition = 0;
        _outBufferLength = _outBuffer.length - _zlib.avail_out;
    }+/

    // Todo: readEnd()
    private void readEnd()
    {
        wrapZlibException!()(Zlib.InflateEnd(&_zlib), "Failed to end inflate.");

        _inBuffer = null;
        _outBuffer = null;

        _inBufferPosition = 0;
        //_inBufferLength = 0;
        _outBufferPosition = 0;
        //_outBufferLength = 0;

        _zlib.next_in = null;
        _zlib.avail_in = 0;

        _zlib.next_out = null;
        _zlib.avail_out = 0;
    }

    private void writeInit()
    {
        wrapZlibException!()(Zlib.DeflateInit(&_zlib, _level), "Failed to init deflate.");

        _inBuffer = new ubyte[defaultBufferSize << 1];
        _outBuffer = new ubyte[defaultBufferSize];

        _inBufferPosition = 0;
        _outBufferPosition = 0;

        _zlib.next_in = null;
        _zlib.avail_in = 0;

        _zlib.next_out = _outBuffer.ptr;
        _zlib.avail_out = cast (uint32) _outBuffer.length;
    }

    private void writeDeflate(int flush)
    {
        auto endOfStream = false;
        uint bytesDeflated;

        do
        {
            if (_zlib.avail_out == 0 || endOfStream)
            {
                _stream.writeBytes(_outBuffer.ptr, _outBufferPosition);
                _outBufferPosition = 0;

                _zlib.next_out = _outBuffer.ptr;
                _zlib.avail_out = cast (uint32) _outBuffer.length;
            }

            auto prevAvailOut = _zlib.avail_out;
            endOfStream = wrapZlibException!()(Zlib.Deflate(&_zlib, flush), "Failed to deflate.");

            bytesDeflated = prevAvailOut - _zlib.avail_out;
            _outBufferPosition += bytesDeflated;
        }
        while (bytesDeflated > 0);

        _inBufferPosition = 0;
    }

    private void writeEnd()
    {
        wrapZlibException!()(Zlib.DeflateEnd(&_zlib), "Failed to end deflate.");

        _inBuffer = null;
        _outBuffer = null;

        _inBufferPosition = 0;
        _outBufferPosition = 0;

        _zlib.next_in = null;
        _zlib.avail_in = 0;

        _zlib.next_out = null;
        _zlib.avail_out = 0;
    }
}
