module durge.draw.imagefile;

import durge.common;
import durge.draw.common;
import durge.draw.files.bmp;
import durge.draw.files.png;
import durge.system.streams;

class ImageFileException : Exception
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

static class ImageFileFactory
{
    import std.path : extension;
    import std.string : format;

    static ImageFile create(string name)
    {
        auto fileExt = extension(name);

        switch (fileExt)
        {
            case ".bmp":
                auto stream = new FileStream(name);
                return new BmpFile(stream, true);

            /*case ".png":
                auto stream = new FileStream(name);
                return new PngFile(stream, true);*/

            default:
                throw new ArgumentException("Image file extension (%s) not supported.".format(fileExt));
        }
    }
}

enum ImageFileType
{
    Bmp = "bmp",
    Png = "png"
}

abstract class ImageFile
{
    static Bitmap loadFile(string name)
    {
        auto imageFile = ImageFileFactory.create(name);
        return imageFile.load();
    }

    static void saveFile(string name, Bitmap bitmap)
    {
        auto imageFile = ImageFileFactory.create(name);
        imageFile.save(bitmap);
    }

    private Stream _stream;
    private bool _closeStream;

    this(Stream stream, bool closeStream = false)
    {
        enforceEx!(ArgumentException)(stream !is null, "Parameter stream must not be null.");

        _stream = stream;
        _closeStream = closeStream;
    }

    ~this()
    {
        // Todo: nothrow @nogc

        if (_closeStream)
        {
            _stream.close();
        }
    }

    @property protected Stream stream() { return _stream; }

    abstract Bitmap load();
    abstract void save(Bitmap bitmap);
}
