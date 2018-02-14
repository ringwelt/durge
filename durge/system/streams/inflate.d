module durge.system.streams.inflate;
/+
import core.stdc.errno;
import std.exception : enforceEx;
import durge.system.Types;
import durge.system.io.Stream;

final class InflateStream : Stream
{
    import std.algorithm.comparison : min;
    import std.stdio : EOF;
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
    private ZlibData _zlib;
    //private size_t _bytesAvailable;      // uint16  state->x.have  number of bytes available at x.next
    //private ubyte* _nextByte;            // ubyte*  state->x.next  next output data to deliver or write
    //private size_t _position;            // int64   state->x.pos   current position in uncompressed data
    //private size_t _bytesWanted;         // uint16  state->want    requested buffer size, default is GZBUFSIZE
    private size_t _bufferSize;          // uint16  state->size    buffer size, zero if not allocated yet
    private ubyte[] _inBuffer;        // ubyte*  state->in      input buffer (double-sized when writing)
    private ubyte[] _outBuffer;       // ubyte*  state->out     output buffer (double-sized when reading)
    private size_t _inBufferPosition;
    private size_t _inBufferLength;
    private size_t _outBufferPosition;
    private size_t _outBufferLength;

    this(Stream stream)
    {
        enforceEx!ArgumentNullException(stream !is null, "stream");
        enforceEx!ArgumentException(stream.flags & StreamFlags.CanRead, "Stream must support reading.");

        _flags = StreamFlags.CanRead;
        _stream = stream;
        _bufferSize = defaultBufferSize;
    }

    ~this()
    {
        enforceEx!(StreamException)(_stream is null, "Stream must be closed before destructor is called.");
    }

    @property Stream stream() { return _stream; }
    override @property StreamFlags flags() { return _flags; }


    override void close()
    {
        if (_stream !is null)
        {
            if (_outBuffer !is null)
            {
                readEnd();
            }

            _stream = null;
        }
    }

}
+/
