module durge.system.windows.renderwindow;

version (Windows):

import durge.common;
import durge.event;
import durge.system.windows.native.common;
import durge.system.windows.native.gdi;
import durge.system.windows.native.keyboard;
import durge.system.windows.native.mouse;
import durge.system.windows.native.windows;
import durge.system.windows.display.manager;
import durge.system.windows.input.manager;
import durge.system.windows.window;
import durge.system.windows.engine;

class WindowActivateEventArgs : EventArgs
{
    bool active;
    bool focus;

	this(bool active, bool focus)
	{
		this.active = active;
		this.focus = focus;
	}
}

class RenderWindow : Window
{
    private WindowsEngine _engine;
    private bool _active, _focus;
    private bool _forceActivate, _allowActivate, _allowResize;
    private bool _mouseHitClientArea;
    private bool _fullscreen;

    Event!(Window, WindowActivateEventArgs) activate;

	this(WindowsEngine engine, string title)
	{
        log("RenderWindow.this()");

        enforceEx!ArgumentNullException(engine !is null, "engine");
        enforceEx!ArgumentNullException(title !is null, "title");

        _engine = engine;
        _allowActivate = true;

        super(engine.instanceHandle, title);
	}

    @property bool active() { return _active; }
    @property bool focus() { return _focus; }

    protected override void onCreate(EventArgs eventArgs)
    {
        super.onCreate(eventArgs);
        _forceActivate = true;
    }

    protected void onActivate(WindowActivateEventArgs eventArgs)
    {
        activate(this, eventArgs);
    }
    
    protected override LRESULT windowProc(UINT uMsg, WPARAM wParam, LPARAM lParam)
    {
        switch (uMsg)
        {
            case WM_CLOSE:
            {
                return 0;
            }

            case WM_MOUSEACTIVATE:
            {
                // Remember if mouse hit client area for WM_ACTIVATE
                _mouseHitClientArea = (lParam & 0xffff) == HTCLIENT;
                return MA_ACTIVATE;
            }
                
            case WM_ACTIVATE:
            {
                scope (exit)
                {
                    _forceActivate = false;
                    _mouseHitClientArea = false;
                }

                if (_forceActivate)
                {
                    doActivate(true, true);
                    return 0;
                }

                auto activate = (wParam & 0xffff) != WA_INACTIVE;
                auto activateByMouseClick = (wParam & 0xffff) == WA_CLICKACTIVE;
                auto minimized = ((wParam >> 16) & 0xffff) != FALSE;

                if (activate && !minimized)
                {
                    // Always set focus in fullscreen, in windowed mode only when mouse clicked in client area
                    doActivate(true, _fullscreen || activateByMouseClick && _mouseHitClientArea);
                }
                else
                {
                    doActivate(false, false);
                }

                return 0;
            }
                
            case WM_LBUTTONDOWN:
            case WM_RBUTTONDOWN:
            case WM_MBUTTONDOWN:
            {
                doActivate(true, true);
                return 0;
            }

            case WM_WINDOWPOSCHANGING:
            {
                LPWINDOWPOS windowPos = cast (LPWINDOWPOS) lParam;
                windowPos.flags |= SWP_NOCOPYBITS | SWP_NOREDRAW;

                if (!_allowResize)
                {
                    windowPos.flags |= _fullscreen ? SWP_NOSIZE | SWP_NOMOVE : SWP_NOSIZE;
                }

                return 0;
            }

            default:
            {
                break;
            }
        }

        return super.windowProc(uMsg, wParam, lParam);
    }

    private void doActivate(bool active, bool focus)
    {
        log("RenderWindow.doActivate(%s, %s)", active, focus);

        if (_allowActivate)
        {
            _allowActivate = false;
            scope (exit) _allowActivate = true;

            auto eventArgs = new WindowActivateEventArgs(active, focus);
            onActivate(eventArgs);

            _active = active;
            _focus = focus;
        }
    }

    void getPosition(out int x, out int y)
    {
        log("RenderWindow.getPosition()");

        RECT windowRect;
        _GetWindowRect(handle, &windowRect);

        x = windowRect.left;
        y = windowRect.top;
    }

	void setPositionAndSize(int x, int y, int width, int height, bool fullscreen)
	{
        log("RenderWindow.setPositionAndSize(%s, %s, %s, %s, %s)", x, y, width, height, fullscreen);

        _allowResize = true;
        scope (exit) _allowResize = false;

        WINDOWPLACEMENT wndpl;
        wndpl.length = WINDOWPLACEMENT.sizeof;
        _GetWindowPlacement(handle, &wndpl);

        if (wndpl.showCmd == SW_SHOWMINIMIZED)
        {
            _ShowWindow(handle, SW_RESTORE);
        }

        if (fullscreen)
		{
            auto monitorHandle = _MonitorFromWindow(handle, MONITOR_DEFAULTTONEAREST);

            MONITORINFO monitorInfo;
            monitorInfo.cbSize = MONITORINFO.sizeof;

            _GetMonitorInfo(monitorHandle, &monitorInfo);
            auto monitorRect = &monitorInfo.rcMonitor;

            DWORD dwStyle = WS_POPUP;
            DWORD dwExStyle = WS_EX_TOPMOST;

            version (Win32)
            {
                _SetWindowLong(handle, GWL_STYLE, dwStyle);
                _SetWindowLong(handle, GWL_EXSTYLE, dwExStyle);
            }
            version (Win64)
            {
                _SetWindowLongPtr(handle, GWL_STYLE, dwStyle);
                _SetWindowLongPtr(handle, GWL_EXSTYLE, dwExStyle);
            }

            _SetWindowPos(handle, cast (HWND) HWND_TOPMOST, monitorRect.left, monitorRect.top, width, height,
				SWP_FRAMECHANGED | SWP_NOCOPYBITS | SWP_SHOWWINDOW);
		}
		else // windowed
		{
			DWORD dwStyle = WS_OVERLAPPED | WS_BORDER | WS_MINIMIZEBOX | WS_CAPTION | WS_SYSMENU;
			DWORD dwExStyle = 0;
			
            version (Win32)
            {
                _SetWindowLong(handle, GWL_STYLE, dwStyle);
                _SetWindowLong(handle, GWL_EXSTYLE, dwExStyle);
            }
            version (Win64)
            {
                _SetWindowLongPtr(handle, GWL_STYLE, dwStyle);
                _SetWindowLongPtr(handle, GWL_EXSTYLE, dwExStyle);
            }

            RECT windowRect;
            windowRect.left = 0;
            windowRect.top = 0;
            windowRect.right = width;
            windowRect.bottom = height;

            _AdjustWindowRect(&windowRect, dwStyle, dwExStyle);

            _SetWindowPos(handle, cast (HWND) HWND_NOTOPMOST, x, y,
                windowRect.right - windowRect.left, windowRect.bottom - windowRect.top,
				SWP_FRAMECHANGED | SWP_NOCOPYBITS | SWP_SHOWWINDOW);
        }

        _fullscreen = fullscreen;
	}

    void hide()
    {
        log("RenderWindow.hide()");

        _allowResize = true;
        scope (exit) _allowResize = false;

        _ShowWindow(handle, SW_HIDE);
    }

    void minimize()
    {
        log("RenderWindow.minimize()");

        _allowResize = true;
        scope (exit) _allowResize = false;

        _ShowWindow(handle, SW_MINIMIZE);
    }

    void setFocus(bool focus)
    {
        log("RenderWindow.setFocus(%s)", focus);

        if (focus)
        {
            _SetForegroundWindow(handle);

            RECT windowRect;
            _GetWindowRect(handle, &windowRect);

            _SetCapture(handle);
            _ClipCursor(&windowRect);
            _ShowCursor(FALSE);
        }
        else
        {
            _ReleaseCapture();
            _ClipCursor(null);
            _ShowCursor(TRUE);
        }
    }
}
