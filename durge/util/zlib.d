module durge.system.Zlib;

import std.conv : to;
import std.exception : ErrnoException;
import std.string : format;
import etc.c.zlib;

alias ZlibData = z_stream;

class ZlibException : Exception
{
    private int _errorCode;
    @property int errorCode() { return _errorCode; }

    private this(int errorCode, string zlibMessage)
    {
        _errorCode = errorCode;
        auto message = GetErrorMessage(errorCode, zlibMessage);
        super(message);
    }

    private string GetErrorMessage(int errorCode, string zlibMessage)
    {
        string message;

        switch (errorCode)
        {
            case Z_STREAM_END: message = "End of stream"; break;
            case Z_NEED_DICT: message = "Need dictionary"; break;
            case Z_STREAM_ERROR: message = "Stream error"; break;
            case Z_DATA_ERROR: message = "Data error"; break;
            case Z_MEM_ERROR: message = "Memory error"; break;
            case Z_BUF_ERROR: message = "Buffer error"; break;
            case Z_VERSION_ERROR: message = "Version error"; break;
            default: message = "Unknown error"; break;
        }

        return zlibMessage !is null
            ? "Zlib: %s (%s).".format(message, zlibMessage)
            : "Zlib: %s.".format(message);
    }
}

private void handleZlibError()(int errorCode, string zlibMessage)
{
    if (errorCode == Z_ERRNO)
    {
        throw new ErrnoException("Zlib: stdlib error.");
    }
    else
    {
        throw new ZlibException(errorCode, zlibMessage);
    }
}

static class Zlib
{
    static:

    void InflateInit(z_streamp strm)
    {
        auto result = inflateInit2(strm, -15);

        if (result != Z_OK)
        {
            handleZlibError!()(result, to!string(strm.msg));
        }
    }

    bool Inflate(z_streamp strm, int flush)
    {
        auto result = inflate(strm, flush);

        if (result == Z_STREAM_END)
        {
            return false;
        }

        if (result != Z_OK)
        {
            handleZlibError!()(result, to!string(strm.msg));
        }

        return true;
    }

    void InflateEnd(z_streamp strm)
    {
        auto result = inflateEnd(strm);

        if (result != Z_OK)
        {
            handleZlibError!()(result, to!string(strm.msg));
        }
    }

    void DeflateInit(z_streamp strm, int level)
    {
        auto result = deflateInit2(strm, level, Z_DEFLATED, -15, 8, Z_DEFAULT_STRATEGY);

        if (result != Z_OK)
        {
            handleZlibError!()(result, to!string(strm.msg));
        }
    }

    bool Deflate(z_streamp strm, int flush)
    {
        auto result = deflate(strm, flush);

        if (result == Z_STREAM_END)
        {
            return false;
        }

        if (result != Z_OK)
        {
            handleZlibError!()(result, to!string(strm.msg));
        }

        return true;
    }

    void DeflateEnd(z_streamp strm)
    {
        auto result = deflateEnd(strm);

        if (result != Z_OK)
        {
            handleZlibError!()(result, to!string(strm.msg));
        }
    }
}
