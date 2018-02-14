module durge.system.streams.file;

import std.exception : enforceEx;
import std.conv : text;
import durge.common;
import durge.system.streams.stream;

enum FileMode
{
    Open,
    OpenOrCreate,
    Create,
    CreateNew,
    Append,
    Truncate
}

enum FileAccess
{
    Read      = 0b0001,
    Write     = 0b0010,
    ReadWrite = Read | Write
}

enum FileShare
{
    None      = 0,
    Read      = 0b0001,
    Write     = 0b0010,
    ReadWrite = Read | Write,
}

enum FileOptions
{
    None             = 0,
    DeleteOnClose    = 0b0001,
    SequentialAccess = 0b0010,
    RandomAccess     = 0b0100,
    WriteThrough     = 0b1000
}

final class FileStream : Stream
{
    import std.algorithm.comparison : min;
    import std.stdio : EOF;

    version (Windows)
    {
        import durge.system.windows.native.common;
        import durge.system.windows.native.file;

        private template wrapWindowsException()
        {
            TExpression wrapWindowsException(TExpression)(lazy TExpression expression, lazy string message)
            {
                try
                {
                    return expression();
                }
                catch (WindowsException ex)
                {
                    throw new StreamException(message, ex);
                }
            }
        }
    }

    private const defaultBufferSize = 8192;

    private StreamFlags _flags;
    private HANDLE _handle;
    private long _position;
    private long _appendStart;
    private size_t _bufferSize;
    private ubyte[] _buffer;
    private size_t _readBufferPosition;
    private size_t _readBufferLength;
    private size_t _writeBufferPosition;

    this(string name)
    {
        this(name, FileMode.Open);
    }

    this(string name, FileMode mode)
    {
        auto access = mode == FileMode.Create || mode == FileMode.CreateNew
            ? FileAccess.ReadWrite
            : mode == FileMode.Append || mode == FileMode.Truncate
                ? FileAccess.Write
                : FileAccess.Read;

        auto options = access == FileAccess.Read
            ? FileOptions.SequentialAccess
            : access == FileAccess.ReadWrite
                ? FileOptions.RandomAccess
                : FileOptions.None;

        this(name, mode, access, FileShare.Read, options, defaultBufferSize);
    }

    this(string name, FileMode mode, FileAccess access)
    {
        this(name, mode, access, FileShare.Read, FileOptions.None, defaultBufferSize);
    }

    this(string name, FileMode mode, FileAccess access, FileOptions options)
    {
        this(name, mode, access, FileShare.Read, options, defaultBufferSize);
    }

    this(string name, FileMode mode, FileAccess access, FileShare share, FileOptions options, size_t bufferSize)
    {
        enforceEx!ArgumentException(bufferSize > 0, "Parameter bufferSize must be greater 0.");

        _flags = StreamFlags.None;
        _appendStart = -1;
        _bufferSize = bufferSize;

        open(name, mode, access, share, options);
    }

    ~this()
    {
        enforceEx!(StreamException)(_handle is null, "Stream must be closed before destructor is called.");
    }

    private void open(string name, FileMode mode, FileAccess access, FileShare share, FileOptions options)
    {
        enforceEx!ArgumentNullException(name !is null, "name");
        enforceEx!ArgumentException((access & FileAccess.Write) == 0 &&
                                    (mode == FileMode.Create || mode == FileMode.CreateNew || mode == FileMode.Append || mode == FileMode.Truncate),
                                    text("File access must be 'Write' when mode is '", mode, "'."));
        enforceEx!ArgumentException(access & FileAccess.Read && mode == FileMode.Append,
                                    "File access must not be 'Read' when mode is 'Append'.");

        DWORD dwDesiredAccess, dwShareMode, dwCreationDisposition;
        DWORD dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OPEN_NO_RECALL;

        switch (mode)
        {
            case FileMode.Open: dwCreationDisposition = OPEN_EXISTING; break;
            case FileMode.OpenOrCreate: dwCreationDisposition = OPEN_ALWAYS; break;
            case FileMode.Create: dwCreationDisposition = CREATE_ALWAYS; break;
            case FileMode.CreateNew: dwCreationDisposition = CREATE_NEW; break;
            case FileMode.Append: dwCreationDisposition = OPEN_ALWAYS; break;
            case FileMode.Truncate: dwCreationDisposition = TRUNCATE_EXISTING; break;
            default: throw new ArgumentException("Parameter mode is out of range.");
        }

        if (access & FileAccess.Read) dwDesiredAccess |= GENERIC_READ;
        if (access & FileAccess.Write) dwDesiredAccess |= GENERIC_WRITE;

        if (share & FileShare.Read) dwShareMode |= FILE_SHARE_READ;
        if (share & FileShare.Write) dwShareMode |= FILE_SHARE_WRITE;

        if (options & FileOptions.DeleteOnClose) dwFlagsAndAttributes |= FILE_FLAG_DELETE_ON_CLOSE;
        if (options & FileOptions.SequentialAccess) dwFlagsAndAttributes |= FILE_FLAG_SEQUENTIAL_SCAN;
        if (options & FileOptions.RandomAccess) dwFlagsAndAttributes |= FILE_FLAG_RANDOM_ACCESS;
        if (options & FileOptions.WriteThrough) dwFlagsAndAttributes |= FILE_FLAG_WRITE_THROUGH;

        _handle = wrapWindowsException!()(_CreateFile(name, dwDesiredAccess, dwShareMode, dwCreationDisposition, dwFlagsAndAttributes), "Failed to open file.");

        scope (failure)
        {
            wrapWindowsException!()(_CloseHandle(_handle), "Failed to close file.");
        }

        DWORD fileType = wrapWindowsException!()(_GetFileType(_handle), "Failed to get file type.");
        enforceEx!ArgumentException(fileType == FILE_TYPE_DISK, text("Non files are not supported."));

        _flags = StreamFlags.CanSeek;

        if (access & FileAccess.Read) _flags |= StreamFlags.CanRead;
        if (access & FileAccess.Write) _flags |= StreamFlags.CanWrite | StreamFlags.CanResize;

        if (mode == FileMode.Append)
        {
            seekInternal(0, SeekOrigin.End);
            _appendStart = _position;
        }
    }

    override @property StreamFlags flags()
    {
        return _flags;
    }

    override @property long position()
    {
        enforceEx!StreamException(_handle !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanSeek, "Stream does not support seeking.");

        verifyPosition();

        return _position - (_readBufferLength - _readBufferPosition) + _writeBufferPosition;
    }

    override @property void position(long value)
    {
        seek(value, SeekOrigin.Begin);
    }

    override @property long length()
    {
        enforceEx!StreamException(_handle !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanSeek, "Stream does not support seeking.");

        verifyPosition();

        auto nativeLength = wrapWindowsException!()(_GetFileSize(_handle), "Failed to get file length.");

        if (_position + _writeBufferPosition > nativeLength)
        {
            return _position + _writeBufferPosition;
        }

        return nativeLength;
    }

    override @property void length(long value)
    {
        alias value newLength;

        enforceEx!ArgumentException(newLength >= 0, "New length must not be negative.");
        enforceEx!ArgumentException(_appendStart < 0 || newLength >= _appendStart,
                                    "New length must not be less initial file length when mode is 'Append'.");
        enforceEx!StreamException(_handle !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanResize, "Stream does not support resizing.");
        enforceEx!StreamException(_flags & StreamFlags.CanSeek, "Stream does not support seeking.");
        enforceEx!StreamException(_flags & StreamFlags.CanWrite, "Stream does not support writing.");

        if (_writeBufferPosition > 0)
        {
            flushWriteBuffer();
        }
        else if (_readBufferPosition < _readBufferLength)
        {
            flushReadBuffer();
        }

        _readBufferPosition = 0;
        _readBufferLength = 0;

        verifyPosition();

        auto prevPosition = _position;
        seekInternal(newLength, SeekOrigin.Begin);

        wrapWindowsException!()(_SetEndOfFile(_handle), "Failed to set end of file.");

        if (prevPosition < newLength)
        {
            seekInternal(prevPosition, SeekOrigin.Begin);
        }
    }

    override @property bool eof()
    {
        if (_flags & StreamFlags.CanSeek)
        {
            return position >= length;
        }

        return false;
    }

    override long seek(long offset, SeekOrigin origin)
    {
        enforceEx!StreamException(_handle !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanSeek, "Stream does not support seeking.");

        if (_writeBufferPosition > 0)
        {
            flushWriteBuffer();
        }
        else if (_readBufferPosition < _readBufferLength)
        {
            flushReadBuffer();
        }

        _readBufferPosition = 0;
        _readBufferLength = 0;

        verifyPosition();

        auto nativeLength = wrapWindowsException!()(_GetFileSize(_handle), "Failed to get file length.");
        long newPosition;

        switch (origin)
        {
            case SeekOrigin.Begin: newPosition = offset; break;
            case SeekOrigin.Current: newPosition = _position + offset; break;
            case SeekOrigin.End: newPosition = nativeLength + offset; break;
            default: throw new ArgumentException("Parameter origin is out of range.");
        }

        enforceEx!ArgumentException(newPosition >= 0, "New position must not be negative.");
        enforceEx!ArgumentException(_appendStart < 0 || newPosition >= _appendStart,
                                    "New position must not be less initial file length when mode is 'Append'.");
        enforceEx!ArgumentException(_flags & StreamFlags.CanWrite || newPosition <= nativeLength,
                                    "New position must not be greater file length when access is 'Read'.");

        seekInternal(offset, origin);
        return _position;
    }

    override int readByte()
    {
        enforceEx!StreamException(_handle !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanRead, "Stream does not support reading.");

        if (_writeBufferPosition > 0)
        {
            flushWriteBuffer();
        }
        else if (_readBufferPosition == _readBufferLength)
        {
            fillReadBuffer();
        }

        if (_readBufferPosition == _readBufferLength)
        {
            return EOF;
        }

        return _buffer[_readBufferPosition++];
    }

    override size_t readBytes(ubyte* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");
        enforceEx!StreamException(_handle !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanRead, "Stream does not support reading.");

        if (count == 0)
        {
            return 0;
        }

        if (_writeBufferPosition > 0)
        {
            flushWriteBuffer();
        }

        size_t bytesRead;

        if (_readBufferPosition < _readBufferLength)
        {
            auto byteCount = min(_readBufferLength - _readBufferPosition, count);

            buffer[0..byteCount] = _buffer[_readBufferPosition.._readBufferPosition + byteCount];
            _readBufferPosition += byteCount;

            buffer += byteCount;
            count -= byteCount;

            bytesRead += byteCount;

            if (count == 0)
            {
                return bytesRead;
            }
        }

        if (count >= _buffer.length)
        {
            bytesRead += readInternal(buffer, count);
        }
        else
        {
            fillReadBuffer();

            auto byteCount = min(_readBufferLength, count);

            if (byteCount > 0)
            {
                buffer[0..byteCount] = _buffer[0..byteCount];
                _readBufferPosition += byteCount;

                bytesRead += byteCount;
            }
        }

        return bytesRead;
    }

    override void writeByte(ubyte value)
    {
        enforceEx!StreamException(_handle !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanWrite, "Stream does not support writing.");

        if (_readBufferPosition < _readBufferLength)
        {
            flushReadBuffer();
        }
        else if (_writeBufferPosition == _buffer.length)
        {
            flushWriteBuffer();
        }

        if (_buffer is null)
        {
            _buffer = new ubyte[_bufferSize];
        }

        _buffer[_writeBufferPosition++] = value;
    }

    override void writeBytes(const (ubyte)* buffer, size_t count)
    {
        enforceEx!ArgumentNullException(buffer !is null, "buffer");
        enforceEx!StreamException(_handle !is null, "Stream is already closed.");
        enforceEx!StreamException(_flags & StreamFlags.CanWrite, "Stream does not support writing.");

        if (count == 0)
        {
            return;
        }

        if (_readBufferPosition < _readBufferLength)
        {
            flushReadBuffer();
        }
        else if (_writeBufferPosition == _buffer.length)
        {
            flushWriteBuffer();
        }
        else if (_writeBufferPosition > 0)
        {
            auto byteCount = min(_buffer.length - _writeBufferPosition, count);

            _buffer[_writeBufferPosition.._writeBufferPosition + byteCount] = buffer[0..byteCount];
            _writeBufferPosition += byteCount;

            buffer += byteCount;
            count -= byteCount;

            if (_writeBufferPosition == _buffer.length)
            {
                flushWriteBuffer();
            }

            if (count == 0)
            {
                return;
            }
        }

        if (count > _buffer.length)
        {
            writeInternal(buffer, count);
        }
        else
        {
            if (_buffer is null)
            {
                _buffer = new ubyte[_bufferSize];
            }

            _buffer[_writeBufferPosition.._writeBufferPosition + count] = buffer[0..count];
            _writeBufferPosition += count;
        }
    }

    override void flush()
    {
        enforceEx!StreamException(_handle !is null, "Stream is already closed.");

        if (_readBufferPosition < _readBufferLength && _readBufferLength > 0)
        {
            flushReadBuffer();
        }
        else if (_writeBufferPosition > 0)
        {
            flushWriteBuffer();
        }

        if (_flags & StreamFlags.CanWrite)
        {
            wrapWindowsException!()(_FlushFileBuffers(_handle), "Failed to flush file buffers.");
        }
    }

    override void close()
    {
        if (_handle !is null)
        {
            if (_writeBufferPosition > 0)
            {
                flushWriteBuffer();
            }

            wrapWindowsException!()(_CloseHandle(_handle), "Failed to close file handle.");
            _handle = null;
        }
    }

    private void verifyPosition()
    {
        auto actualPosition = wrapWindowsException!()(_GetFilePointer(_handle), "Failed to get file position.");
        enforceEx!StreamException(actualPosition == _position, "Native file position is not in sync.");
    }

    private void fillReadBuffer()
    {
        if (_buffer is null)
        {
            _buffer = new ubyte[_bufferSize];
        }

        _readBufferLength = readInternal(_buffer.ptr, _buffer.length);
        _readBufferPosition = 0;
    }

    private void flushReadBuffer()
    {
        auto bytesNotRead = _readBufferLength - _readBufferPosition;

        if (bytesNotRead != 0)
        {
            _position = wrapWindowsException!()(_SetFilePointer(_handle, -bytesNotRead, FILE_CURRENT), "Failed to set file position.");
        }

        _readBufferPosition = 0;
        _readBufferLength = 0;
    }

    private void flushWriteBuffer()
    {
        writeInternal(_buffer.ptr, _writeBufferPosition);
        _writeBufferPosition = 0;
    }

    private void seekInternal(long offset, SeekOrigin origin)
    {
        DWORD dwMoveMethod;

        final switch (origin)
        {
            case SeekOrigin.Begin: dwMoveMethod = FILE_BEGIN; break;
            case SeekOrigin.Current: dwMoveMethod = FILE_CURRENT; break;
            case SeekOrigin.End: dwMoveMethod = FILE_END; break;
        }

        _position = wrapWindowsException!()(_SetFilePointer(_handle, offset, dwMoveMethod), "Failed to set file position.");
    }

    private size_t readInternal(ubyte* buffer, size_t count)
    {
        auto bytesRead = wrapWindowsException!()(_ReadFile(_handle, buffer, cast (DWORD) count), "Failed to read from file.");

        _position += bytesRead;
        return bytesRead;
    }

    private void writeInternal(const (ubyte)* buffer, size_t count)
    {
        auto bytesWritten = wrapWindowsException!()(_WriteFile(_handle, buffer, cast (DWORD) count), "Failed to write to file.");
        enforceEx!StreamException(bytesWritten == count, "Failed to write to file.");

        _position += bytesWritten;
    }
}
