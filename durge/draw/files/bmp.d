module durge.draw.files.bmp;

import durge.common;
import durge.draw.common;
import durge.draw.imagefile;
import durge.system.streams;

private struct BmpFileHeader
{
    private uint16 type;
    private uint32 size;
    private uint32 reserved;
    private uint32 offBits;

    void validate()
    {
        enforceEx!(ImageFileException)(type == 0x424d, "File type is invalid.");
        enforceEx!(ImageFileException)(offBits >= BmpFileHeader.sizeof + BmpInfoHeader.sizeof, "Image data offset is invalid.");
    }
}

private struct BmpInfoHeader
{
    private uint32 size;
    private int32 width;
    private int32 height;
    private uint16 planes;
    private uint16 bitCount;
    private uint32 compression;
    private uint32 sizeImage;
    private int32 xPelsPerMeter;
    private int32 yPelsPerMeter;
    private uint32 clrUsed;
    private uint32 clrImportant;

    void validate()
    {
        import std.conv : text;

        enforceEx!(ImageFileException)(size == BmpInfoHeader.sizeof, "Info header size is invalid.");
        enforceEx!(ImageFileException)(width > 0, "Image width must be greater zero.");
        enforceEx!(ImageFileException)(height != 0, "Image height must not be zero.");
        enforceEx!(ImageFileException)(planes == 1, text("Number of planes (", planes, ") not supported."));
        enforceEx!(ImageFileException)(bitCount == 24, text("Bit count (", bitCount, ") not supported."));
        enforceEx!(ImageFileException)(compression == 0, text("Compression (", compression, ") not supported."));
    }
}

final class BmpFile : ImageFile
{
    import std.algorithm.comparison : min;
    import std.math : abs;

    this(Stream stream, bool closeStream = false)
    {
        super(stream, closeStream);
    }

    override Bitmap load()
    {
        BmpFileHeader fileHeader;
        BmpInfoHeader infoHeader;

        readFileHeader(fileHeader);
        readInfoHeader(infoHeader);

        auto bitmap = new Bitmap(infoHeader.width, abs(infoHeader.height), 32);

        skipBytes(fileHeader.offBits - (BmpFileHeader.sizeof + BmpInfoHeader.sizeof));
        readImageData(infoHeader, bitmap);

        return bitmap;
    }

    private void readFileHeader(ref BmpFileHeader fileHeader)
    {
        if (!stream.readItem!()(fileHeader))
        {
            throw new ImageFileException("Unexpected end of file.");
        }

        fileHeader.validate();
    }

    private void readInfoHeader(ref BmpInfoHeader infoHeader)
    {
        if (!stream.readItem!()(infoHeader))
        {
            throw new ImageFileException("Unexpected end of file.");
        }

        infoHeader.validate();
    }

    private void skipBytes(size_t count)
    {
        enforceEx!ArgumentException(count >= 0, "Parameter count must be zero or greater.");

        if (count == 0)
        {
            return;
        }

        if (stream.flags & StreamFlags.CanSeek)
        {
            stream.seek(count, SeekOrigin.Current);
        }
        else
        {
            ubyte[4096] buffer;
            auto bytesLeft = count;

            while (bytesLeft > 0)
            {
                auto bytesToRead = min(bytesLeft, buffer.length);
                auto bytesRead = stream.readItems!()(buffer[0..bytesToRead]);

                if (bytesRead < bytesToRead)
                {
                    throw new ImageFileException("Unexpected end of file.");
                }

                bytesLeft -= bytesRead;
            }
        }
    }

    private void readImageData(ref BmpInfoHeader infoHeader, Bitmap bitmap)
    {
        auto rowSize = ((infoHeader.bitCount * infoHeader.width + 31) / 32) * 4;
        auto rowData = new ubyte[rowSize];
        auto y = infoHeader.height > 0 ? infoHeader.height - 1 : 0;
        auto yincr = infoHeader.height > 0 ? -1 : 1;

        for (auto i = 0; i < bitmap.height; i++, y += yincr)
        {
            if (i == bitmap.height - 1)
            {
                rowSize = (infoHeader.bitCount * infoHeader.width + 7) / 8;
                rowData = rowData[0..rowSize];
            }

            auto bytesRead = stream.readItems!()(rowData);

            if (bytesRead < rowData.length)
            {
                throw new ImageFileException("Unexpected end of file.");
            }

            for (auto x = 0; x < bitmap.width; x++)
            {
                auto b = rowData[x * 3 + 0];
                auto g = rowData[x * 3 + 1];
                auto r = rowData[x * 3 + 2];
                auto c = Color(r, g, b);

                bitmap.drawer.setPixel(x, y, c);
            }
        }
    }

    override void save(Bitmap bitmap)
    {
        enforceEx!(ArgumentException)(bitmap !is null, "Parameter bitmap must not be null.");
        enforceEx!(NotSupportedException)(bitmap.depth == 24, "Color depth is not supported.");

        writeFileHeader(bitmap);
        writeInfoHeader(bitmap);
        writeImageData(bitmap);
    }

    private void writeFileHeader(Bitmap bitmap)
    {
        BmpFileHeader fileHeader;

        auto rowSize = ((24 * bitmap.width + 31) / 32) * 4;

        fileHeader.type = 0x424d;
        fileHeader.size = cast (uint32) (BmpFileHeader.sizeof + BmpInfoHeader.sizeof + rowSize * bitmap.height);
        fileHeader.reserved = 0;
        fileHeader.offBits = BmpFileHeader.sizeof + BmpInfoHeader.sizeof;

        stream.writeItem!()(fileHeader);
    }

    private void writeInfoHeader(Bitmap bitmap)
    {
        BmpInfoHeader infoHeader;

        auto rowSize = ((24 * bitmap.width + 31) / 32) * 4;

        infoHeader.size = BmpInfoHeader.sizeof;
        infoHeader.width = bitmap.width;
        infoHeader.height = bitmap.height;
        infoHeader.planes = 1;
        infoHeader.bitCount = 24;
        infoHeader.compression = 0;
        infoHeader.sizeImage = rowSize * bitmap.height;
        infoHeader.xPelsPerMeter = 0;
        infoHeader.yPelsPerMeter = 0;
        infoHeader.clrUsed = 0;
        infoHeader.clrImportant = 0;

        stream.writeItem!()(infoHeader);
    }

    private void writeImageData(Bitmap bitmap)
    {
        auto rowSize = ((24 * bitmap.width + 31) / 32) * 4;
        auto rowData = new ubyte[rowSize];

        rowData[$ - 1] = 0;
        rowData[$ - 2] = 0;
        rowData[$ - 3] = 0;

        for (auto y = bitmap.height - 1; y >= 0; y--)
        {
            for (auto x = 0; x < bitmap.width; x++)
            {
                auto c = bitmap.drawer.getPixel(x, y);

                rowData[x * 3 + 0] = c.b;
                rowData[x * 3 + 1] = c.g;
                rowData[x * 3 + 2] = c.r;
            }

            stream.writeItems!()(rowData);
        }
    }
}
