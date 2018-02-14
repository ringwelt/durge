module durge.system.display.modeinfo;

import durge.common;

class DisplayModeInfo
{
    private string _driverName;
    private int _width;
    private int _height;
    private int _depth;
    private int[] _refreshRates;

    private this(string driverName, int width, int height, int depth)
    {
        _driverName = driverName;
        _width = width;
        _height = height;
        _depth = depth;
        _refreshRates = [0];
    }

    @property string driverName() { return _driverName; }
    @property int width() { return _width; }
    @property int height() { return _height; }
    @property int depth() { return _depth; }
    @property const(int)[] refreshRates() { return _refreshRates; }

    private void addRefreshRate(int refreshRate)
    {
        import std.algorithm : canFind;

        if (!_refreshRates.canFind(refreshRate))
        {
            _refreshRates ~= refreshRate;
        }
    }
}

class DisplayModeInfoListBuilder
{
    private DisplayModeInfo[] _modes;
    @property DisplayModeInfo[] modes() { return _modes; }

    void addDisplayMode(string driverName, int width, int height, int depth, int refreshRate)
    {
        enforceEx!ArgumentNullException(driverName !is null, "driverName");
        enforceEx!ArgumentException(width > 0, "Parameter width must be greater zero.");
        enforceEx!ArgumentException(height > 0, "Parameter height must be greater zero.");
        enforceEx!ArgumentException(depth == 8 || depth == 16 || depth == 32, "Parameter depth must be 8, 16 or 32.");
        enforceEx!ArgumentException(refreshRate >= 0, "Parameter refreshRate must be zero or greater.");

        import std.algorithm.iteration : filter;
        auto mode = _modes.filter!(m => m.driverName == driverName && m.width == width && m.height == height && m.depth == depth).frontOrNull;

        if (mode is null)
        {
            mode = new DisplayModeInfo(driverName, width, height, depth);
            _modes ~= mode;
        }

        mode.addRefreshRate(refreshRate);
    }
}
