module durge.system.windows.display.manager;

version (Windows):

import durge.common;
import durge.system.display;
import durge.system.windows.display.drivers;
import durge.system.windows.renderwindow;

final class WindowsDisplayManager : DisplayManager
{
    private RenderWindow _renderWindow;
    private int _windowX, _windowY;
    private bool _inited, _suspended;
    private int _width, _height, _depth, _refreshRate;
    private bool _fullscreen;

    this(RenderWindow renderWindow)
    {
        log("WindowsDisplayManager.this()");

        enforceEx!ArgumentNullException(renderWindow !is null, "renderWindow");

        _renderWindow = renderWindow;
        _renderWindow.getPosition(_windowX, _windowY);

        super(cast (IDisplayDriver[])
        [
            new WindowsDisplayDriver(renderWindow),
            new DirectDrawDisplayDriver(renderWindow),
        ]);
    }

    override void setDisplayMode(string driverName, int width, int height, int depth, int refreshRate, bool fullscreen)
    {
        log("WindowsDisplayManager.setDisplayMode()");

        enforceEx!ArgumentNullException(driverName !is null, "driverName");
        enforceEx!ArgumentException(width > 0, "Parameter width must be greater zero.");
        enforceEx!ArgumentException(height > 0, "Parameter height must be greater zero.");
        enforceEx!ArgumentException(depth == 8 || depth == 16 || depth == 32, "Parameter depth must be 8, 16 or 32.");
        enforceEx!ArgumentException(refreshRate >= 0, "Parameter refreshRate must be zero or greater.");

        if (!_fullscreen)
        {
            _renderWindow.getPosition(_windowX, _windowY);
        }

        _inited = false;
        _suspended = false;

        scope (success)
        {
            _width = width;
            _height = height;
            _depth = depth;
            _refreshRate = refreshRate;
            _fullscreen = fullscreen;
        }

        super.setDisplayMode(driverName, width, height, depth, refreshRate, fullscreen);

        _renderWindow.setPositionAndSize(_windowX, _windowY, width, height, fullscreen);
        _renderWindow.setFocus(fullscreen || _renderWindow.focus);

        _inited = true;
    }

    override void resetDisplayMode()
    {
        log("WindowsDisplayManager.resetDisplayMode()");

        if (_inited)
        {
            _inited = false;
            _suspended = false;

            super.resetDisplayMode();
        }

        _renderWindow.setFocus(false);
        _renderWindow.hide();
    }

    void suspendDisplayMode()
    {
        log("WindowsDisplayManager.suspendDisplayMode()");

        if (_inited)
        {
            if (_fullscreen)
            {
                if (!_suspended)
                {
                    currDriver.resetDisplayMode();
                }

                _renderWindow.setFocus(false);
                _renderWindow.minimize();
            }
            else
            {
                _renderWindow.setFocus(false);
            }

            _suspended = true;
        }
    }

    void restoreDisplayMode(bool focus)
    {
        log("WindowsDisplayManager.restoreDisplayMode(%s)", focus);

        if (_inited)
        {
            if (_fullscreen)
            {
                if (_suspended)
                {
                    scope (failure) resetDisplayMode();
                    currDriver.setDisplayMode(_width, _height, _depth, _refreshRate, _fullscreen);
                }

                _renderWindow.setPositionAndSize(0, 0, _width, _height, _fullscreen);
                _renderWindow.setFocus(true);
            }
            else
            {
                _renderWindow.setFocus(focus);
            }

            _suspended = false;
        }
    }
}
