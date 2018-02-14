module durge.draw.files.png;
/+
import std.exception : enforceEx;
import std.conv : text;
import durge.system.Types;
import durge.system.io.Stream;
import durge.system.io.CrcStream;
import durge.draw.Color;
import durge.draw.Bitmap;
import durge.draw.ImageFile;

private struct PngSignature
{
    uint64 data;

    void validate()
    {
        if (data != 0x89504e470d0a1a0a)
        {
            throw new ImageFileException("Signature is invalid.");
        }
    }
}

private class PngChunk
{
    uint32 length;
    uint8[4] type;
    ubyte[] data;
    uint32 crc;

    @property bool isCritical()
    {
        return type[0] >= 'A' && type[0] <= 'Z';
    }

    void validate(const uint streamCrc)
    {
        foreach (ubyte b; type)
        {
            enforceEx!(ImageFileException)(b >= 'A' && b <= 'Z' || b >= 'a' && b <= 'z', "Chunk type is invalid.");
        }

        enforceEx!(ImageFileException)(streamCrc == crc, "Chunk CRC validation failed.");
    }
}

private class PngImageHeader
{
    private PngChunk _chunk;

    this(PngChunk chunk)
    {
        _chunk = chunk;
    }

    uint32 width;
    uint32 height;
    uint8 bitDepth;
    uint8 colorType;
    uint8 compressionMethod;
    uint8 filterMethod;
    uint8 interlaceMethod;

    void validate()
    {
        enforceEx!(ImageFileException)(width > 0, "Image width must not be zero.");
        enforceEx!(ImageFileException)(height > 0, "Image height must not be zero.");
        enforceEx!(ImageFileException)(bitDepth == 1 || bitDepth == 2 || bitDepth == 4 || bitDepth == 8 || bitDepth == 16,
                                       "Image bit depth is invalid.");
        enforceEx!(ImageFileException)(colorType == 0 || colorType == 2 || colorType == 3 || colorType == 4 || colorType == 6,
                                       "Image color type is invalid.");
        enforceEx!(ImageFileException)((colorType == 2 || colorType == 4 || colorType == 6) && (bitDepth == 8 || bitDepth == 16) ||
                                       colorType == 3 && bitDepth != 16,
                                       "Image bit depth and color type combination is invalid.");
        enforceEx!(ImageFileException)(compressionMethod == 0, "Image compression method is invalid.");
        enforceEx!(ImageFileException)(filterMethod == 0, "Image filter method is invalid.");
        enforceEx!(ImageFileException)(interlaceMethod == 0 || interlaceMethod == 1, "Image interlace method is invalid.");
    }
}

private class PngPalette
{
    private PngChunk _chunk;

    this(PngChunk chunk)
    {
        _chunk = chunk;
    }

    void validate()
    {

    }
}

private class PngImageData
{
    private PngChunk[] _chunks;

    this()
    {

    }

    void combine(PngChunk chunk)
    {
        _chunks ~= chunk;
    }

    void validate()
    {

    }
}

final class PngFile : ImageFile
{
    import std.algorithm : canFind;
    import std.algorithm.comparison : min;

    private static string[] knownChunkTypes = ["IHDR", "PLTE", "IDAT", "IEND"];

    this(Stream stream, bool closeStream = false)
    {
        super(stream, closeStream);
    }

    override Bitmap load()
    {
        PngChunk[] chunks;
        PngImageHeader imageHeader;
        PngPalette palette;
        PngImageData imageData;

        readSignature();
        readChunks(chunks);

        auto bitmap = new Bitmap(imageHeader.width, imageHeader.height, cast (ColorDepth) imageHeader.bitDepth);



        return bitmap;
    }

    private void readSignature()
    {
        PngSignature signature;

        if (!stream.readItem!()(signature))
        {
            throw new ImageFileException("Unexpected end of file.");
        }

        signature.validate();
    }

    private void readChunks(ref PngChunk[] chunks)
    {
        scope crcStream = new CrcStream(stream, CrcStreamMode.Read);

        while (true)
        {
            auto chunk = new PngChunk();

            readChunkHeader(chunk, crcStream);

            if (knownChunkTypes.canFind(chunk.type))
            {
                readChunkData(chunk, crcStream);
                readChunkCrc(chunk);
            }
            else if (chunk.isCritical)
            {
                throw new ImageFileException(text("Encountered unknown but critical chunk ", cast (string) chunk.type, "."));
            }
            else
            {
                skipChunkData(chunk, crcStream);
                readChunkCrc(chunk);
            }

            chunk.validate(crcStream.crc);

            if (!loadChunk(chunk))
            {
                break;
            }

            chunks ~= chunk;
        }

        enforceEx!(ImageFileException)(imageHeader !is null, "Chunk IHDR is missing.");
        enforceEx!(ImageFileException)(imageData !is null, "Chunk IDAT is missing.");

        imageData.validate();
    }

    private void readChunkHeader(PngChunk chunk, CrcStream crcStream)
    {
        if (!stream.readItem!()(chunk.length))
        {
            throw new ImageFileException("Unexpected end of file.");
        }

        if (!crcStream.readItem!()(chunk.type))
        {
            throw new ImageFileException("Unexpected end of file.");
        }
    }

    private void readChunkData(PngChunk chunk, CrcStream crcStream)
    {
        if (chunk.length == 0)
        {
            return;
        }

        chunk.data = new ubyte[chunk.length];
        auto bytesRead = crcStream.readItems!()(chunk.data);

        if (bytesRead < chunk.length)
        {
            chunk.data = null;
            throw new ImageFileException("Unexpected end of file.");
        }
    }

    private void skipChunkData(PngChunk chunk, CrcStream crcStream)
    {
        ubyte[4096] buffer;
        auto bytesLeft = chunk.length;

        while (bytesLeft > 0)
        {
            auto bytesToRead = min(bytesLeft, buffer.length);
            auto bytesRead = crcStream.readItems!()(buffer[0..bytesToRead]);

            if (bytesRead < bytesToRead)
            {
                throw new ImageFileException("Unexpected end of file.");
            }

            bytesLeft -= bytesRead;
        }
    }

    private void readChunkCrc(PngChunk chunk)
    {
        if (!stream.readItem!()(chunk.crc))
        {
            throw new ImageFileException("Unexpected end of file.");
        }
    }

    private bool loadChunk(PngChunk chunk)
    {
        switch (cast (string) chunk.type)
        {
            case "IHDR":
                if (_imageHeader !is null)
                {
                    throw new ImageFileException("Chunk IHDR must exist only once.");
                }

                _imageHeader = new PngImageHeader(chunk);
                _imageHeader.validate();
                break;

            case "PLTE":
                if (_palette !is null)
                {
                    throw new ImageFileException("Chunk PLTE must exist only once.");
                }

                _palette = new PngPalette(chunk);
                _palette.validate();
                break;

            case "IDAT":
                if (_imageData is null)
                {
                    _imageData = new PngImageData();
                }

                _imageData.combine(chunk);
                break;

            case "IEND":
                return false;

            default:
                break;
        }

        return true;
    }

    override void save(Bitmap bitmap)
    {
        enforceEx!(ArgumentException)(bitmap !is null, "Parameter bitmap must not be null.");
        enforceEx!(ArgumentException)(bitmap.depth == ColorDepth.Bits24, "Color depth must be 24 bits.");


    }
}
+/
