module durge.system.config;

class Config
{
    private string _displayDriver;
    private int _width;
    private int _height;
    private int _depth;
    private int _refreshRate;
    private bool _fullscreen;

    this()
    {
        _displayDriver = "ddraw";
        _displayDriver = "gdi";
        _width = 640;
        _height = 480;
        _depth = 32;
        _refreshRate = 0;
        _fullscreen = false;
    }

    @property string displayDriver() { return _displayDriver; }
    @property int width() { return _width; }
    @property int height() { return _height; }
    @property int depth() { return _depth; }
    @property int refreshRate() { return _refreshRate; }
    @property bool fullscreen() { return _fullscreen; }

    @property void displayDriver(string value) { _displayDriver = value; }
    @property void width(int value) { _width = value; }
    @property void height(int value) { _height = value; }
    @property void depth(int value) { _depth = value; }
    @property void refreshRate(int value) { _refreshRate = value; }
    @property void fullscreen(bool value) { _fullscreen = value; }
}
