module durge.system.display.manager;

import durge.common;
import durge.draw.common;
import durge.system.display;

abstract class DisplayManager
{
    private IDisplayDriver[] _drivers;
    private IDisplayDriver _currDriver;

	protected this(IDisplayDriver[] drivers)
	{
        log("DisplayManager.this()");

        enforceEx!ArgumentNullException(drivers !is null, "drivers");

        _drivers = drivers;
        _currDriver = new NullDisplayDriver();

        logDisplayModes();
    }

    nothrow @nogc void dispose()
    {
        _currDriver.dispose();
    }

    @property IDisplayDriver[] drivers() { return _drivers; }
    @property IDisplayDriver currDriver() { return _currDriver; }

    private void logDisplayModes()
    {
        log("DisplayManager.logDisplayModes()");

        auto modes = enumDisplayModes();

        foreach (mode; modes)
        {
            import std.string : chop, format;

            string rrStr;
            foreach (rr; mode.refreshRates) rrStr ~= format("%s, ", rr);

            log("%s: %s x %s x %s (%s)", mode.driverName, mode.width, mode.height, mode.depth, rrStr.chop.chop);
        }
    }

    DisplayModeInfo[] enumDisplayModes()
    {
        log("DisplayManager.enumDisplayModes()");

        DisplayModeInfo[] modes;

        foreach (driver; _drivers)
        {
            modes ~= driver.enumDisplayModes();
        }

        return modes;
    }

    DisplayModeInfo[] enumDisplayModes(string driverName)
    {
        log("DisplayManager.enumDisplayModes()");

        enforceEx!ArgumentNullException(driverName !is null, "driverName");

        import std.algorithm.iteration : filter;
        auto driver = _drivers.filter!(d => d.name == driverName).frontOrNull;

        if (driver is null)
        {
            throw new Exception("Unknown display driver '" ~ driverName ~ "' .");
        }

        return driver.enumDisplayModes();
    }

    void setDisplayMode(string driverName, int width, int height, int depth, int refreshRate, bool fullscreen)
    {
        log("DisplayManager.setDisplayMode()");

        enforceEx!ArgumentNullException(driverName !is null, "driverName");
        enforceEx!ArgumentException(width > 0, "Parameter width must be greater zero.");
        enforceEx!ArgumentException(height > 0, "Parameter height must be greater zero.");
        enforceEx!ArgumentException(depth == 8 || depth == 16 || depth == 32, "Parameter depth must be 8, 16 or 32.");
        enforceEx!ArgumentException(refreshRate >= 0, "Parameter refreshRate must be zero or greater.");

        import std.algorithm.iteration : filter;
        auto driver = _drivers.filter!(d => d.name == driverName).frontOrNull;

        if (driver is null)
        {
            throw new Exception("Unknown display driver '" ~ driverName ~ "' .");
        }

        _currDriver.resetDisplayMode();
        _currDriver = driver;

        scope (failure) resetDisplayMode();
        _currDriver.setDisplayMode(width, height, depth, refreshRate, fullscreen);
    }

    void resetDisplayMode()
    {
        log("DisplayManager.resetDisplayMode()");

        _currDriver.resetDisplayMode();
    }

    Bitmap getFrameBuffer()
    {
        return _currDriver.getFrameBuffer();
    }

    void flipFrameBuffers()
    {
        _currDriver.flipFrameBuffers();
    }
}
