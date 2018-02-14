module durge.system.windows.window;

version (Windows):

import durge.common;
import durge.event;
import durge.system.windows.native.common;
import durge.system.windows.native.gdi;
import durge.system.windows.native.keyboard;
import durge.system.windows.native.rawinput;
import durge.system.windows.native.windows;

class WindowMessageEventArgs : CancelEventArgs
{
    UINT uMsg;
    WPARAM wParam;
    LPARAM lParam;
    LRESULT lResult;

	this(UINT uMsg, WPARAM wParam, LPARAM lParam)
	{
		this.uMsg = uMsg;
		this.wParam = wParam;
		this.lParam = lParam;
	}
}

class KeyDownEventArgs : CancelEventArgs
{
    int keyCode;

    this(int keyCode)
    {
        this.keyCode = keyCode;
    }
}

class InputEventArgs : EventArgs
{
    HRAWINPUT hRawInput;
    bool foreground;

	this(HRAWINPUT hRawInput, bool foreground)
	{
		this.hRawInput = hRawInput;
        this.foreground = foreground;
	}
}

class InputDeviceChangedEventArgs : EventArgs
{
    HANDLE hDevice;
    bool removed;

	this(HANDLE hDevice, bool removed)
	{
		this.hDevice = hDevice;
		this.removed = removed;
	}
}

abstract class Window
{
    private HINSTANCE _instanceHandle;
    private LPCWSTR _className;
    private ATOM _classAtom;
    private HWND _handle;

    @property HWND handle() { return _handle; }

    Event!(Window, WindowMessageEventArgs) message;
    Event!(Window, EventArgs) create;
    Event!(Window, EventArgs) destroy;
    Event!(Window, CancelEventArgs) maximize;
    Event!(Window, CancelEventArgs) minimize;
    Event!(Window, CancelEventArgs) restore;
    Event!(Window, CancelEventArgs) close;
    Event!(Window, KeyDownEventArgs) keyDown;
    Event!(Window, InputEventArgs) input;
    Event!(Window, InputDeviceChangedEventArgs) inputDeviceChanged;
    Event!(Window, EventArgs) displayChange;

    this(HINSTANCE instanceHandle, string title)
    {
        log("Window.this()");

        enforceEx!ArgumentNullException(instanceHandle!is null, "instanceHandle");
        enforceEx!ArgumentNullException(title !is null, "title");

        import std.utf;

        _instanceHandle = instanceHandle;
        _className = this.classinfo.name.toUTF16z();
        _classAtom = _RegisterClass(_className, _instanceHandle, &staticWindowProc);
        _handle = _CreateWindow(_className, title, _instanceHandle, WS_OVERLAPPEDWINDOW, WS_EX_OVERLAPPEDWINDOW, cast (LPVOID) this);
    }

    nothrow @nogc ~this()
    {
        dispose();
    }

    nothrow @nogc void dispose()
    {
        DestroyWindowAndSetNull(_handle);

        if (_classAtom != 0)
        {
            UnregisterClass(_className, _instanceHandle);
            _classAtom = 0;
        }
    }

    protected void onMessage(WindowMessageEventArgs eventArgs)
    {
        message(this, eventArgs);
    }

    protected void onCreate(EventArgs eventArgs)
    {
        create(this, eventArgs);
    }

    protected void onDestroy(EventArgs eventArgs)
    {
        destroy(this, eventArgs);
    }

    protected void onMaximize(CancelEventArgs eventArgs)
    {
        maximize(this, eventArgs);
    }

    protected void onMinimize(CancelEventArgs eventArgs)
    {
        minimize(this, eventArgs);
    }
   
    protected void onRestore(CancelEventArgs eventArgs)
    {
        restore(this, eventArgs);
    }

    protected void onClose(CancelEventArgs eventArgs)
    {
        close(this, eventArgs);
    }

    protected void onKeyDown(KeyDownEventArgs eventArgs)
    {
        keyDown(this, eventArgs);
    }

    protected void onInput(InputEventArgs eventArgs)
    {
        input(this, eventArgs);
    }

    protected void onInputDeviceChanged(InputDeviceChangedEventArgs eventArgs)
    {
        inputDeviceChanged(this, eventArgs);
    }

    protected void onDisplayChange(EventArgs eventArgs)
    {
        displayChange(this, eventArgs);
    }

    extern (Windows)
    private static LRESULT staticWindowProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
    {
        if (uMsg != WM_INPUT && uMsg != WM_KEYDOWN && uMsg != WM_KEYUP && uMsg != WM_CHAR)
        {
            auto msgStr = getMsgStr(uMsg, wParam, lParam);
            log("Window.staticWindowProc(%s)", msgStr);
        }

        Window window;
        
        if (uMsg == WM_NCCREATE)
        {
            auto lpcs = cast (LPCREATESTRUCT) lParam;

            window = cast (Window) lpcs.lpCreateParams;
            window._handle = hWnd;

            version (Win32)
            {
                _SetWindowLong(hWnd, GWL_USERDATA, cast (LONG) cast (LPVOID) window);
            }
            version (Win64)
            {
                _SetWindowLongPtr(hWnd, GWLP_USERDATA, cast (LONG_PTR) cast (LPVOID) window);
            }
        }
        else
        {
            version (Win32)
            {
                window = cast (Window) cast (LPVOID) _GetWindowLong(hWnd, GWL_USERDATA);
            }
            version (Win64)
            {
                window = cast (Window) cast (LPVOID) _GetWindowLongPtr(hWnd, GWLP_USERDATA);
            }

            if (uMsg == WM_NCDESTROY)
            {
                version (Win32)
                {
                    _SetWindowLong(hWnd, GWL_USERDATA, 0);
                }
                version (Win64)
                {
                    _SetWindowLongPtr(hWnd, GWLP_USERDATA, 0);
                }

                if (window !is null)
                {
                    window._handle = null;
                }
            }
        }

        if (window !is null)
        {
            if (window.message.hasHandlers)
            {
                auto eventArgs = new WindowMessageEventArgs(uMsg, wParam, lParam);
                window.onMessage(eventArgs);

                if (eventArgs.cancel)
                {
                    return eventArgs.lResult;
                }
                
                uMsg = eventArgs.uMsg;
                wParam = eventArgs.wParam;
                lParam = eventArgs.lParam;
            }

            return window.windowProc(uMsg, wParam, lParam);
        }

        return _DefWindowProc(hWnd, uMsg, wParam, lParam);
    }

    protected LRESULT windowProc(UINT uMsg, WPARAM wParam, LPARAM lParam)
    {
        switch (uMsg)
        {
            case WM_CREATE:
            {
                onCreate(EventArgs.empty);
                break;
            }

            case WM_DESTROY:
            {
                onDestroy(EventArgs.empty);
                break;
            }

            case WM_CLOSE:
            {
                auto eventArgs = new CancelEventArgs();
                onClose(eventArgs);
                
                if (eventArgs.cancel)
                {
                    return 0;
                }

                break;
            }

            case WM_SYSCOMMAND:
            {
                auto command = wParam & 0xfff0;
                
                switch (command)
                {
                    case SC_MAXIMIZE:
                    {
                        auto eventArgs = new CancelEventArgs();
                        onMaximize(eventArgs);
                        
                        if (eventArgs.cancel)
                        {
                            return 0;
                        }
                        
                        break;
                    }

                    case SC_MINIMIZE:
                    {
                        auto eventArgs = new CancelEventArgs();
                        onMinimize(eventArgs);

                        if (eventArgs.cancel)
                        {
                            return 0;
                        }
                        
                        break;
                    }

                    case SC_RESTORE:
                    {
                        auto eventArgs = new CancelEventArgs();
                        onRestore(eventArgs);

                        if (eventArgs.cancel)
                        {
                            return 0;
                        }
                        
                        break;
                    }

                    default:
                    {
                        break;
                    }
                }
                
                break;
            }

            case WM_KEYDOWN:
            {
                auto eventArgs = new KeyDownEventArgs(lParam & 0x0f00);
                onKeyDown(eventArgs);

                if (eventArgs.cancel)
                {
                    return 0;
                }

                break;
            }

            case WM_INPUT:
            {
                auto eventArgs = new InputEventArgs(cast (HRAWINPUT) lParam, wParam == RIM_INPUTSINK);
                onInput(eventArgs);
                return 0;
            }

            case WM_INPUT_DEVICE_CHANGE:
            {
                auto eventArgs = new InputDeviceChangedEventArgs(cast (HANDLE) lParam, wParam == GIDC_REMOVAL);
                onInputDeviceChanged(eventArgs);
                return 0;
            }

            case WM_DISPLAYCHANGE:
            {
                onDisplayChange(EventArgs.empty);
                break;
            }

            default:
            {
                break;
            }
        }

        return _DefWindowProc(_handle, uMsg, wParam, lParam);
    }

    private static string getMsgStr(UINT uMsg, WPARAM wParam, LPARAM lParam)
    {
        import std.conv;
        import std.stdio;

        string[UINT] map;

        map[0x0001] = "WM_CREATE";
        map[0x0002] = "WM_DESTROY";
        map[0x0003] = "WM_MOVE";
        map[0x0005] = "WM_SIZE";
        map[0x0006] = "WM_ACTIVATE";
        map[0x0007] = "WM_SETFOCUS";
        map[0x0008] = "WM_KILLFOCUS";
        map[0x000A] = "WM_ENABLE";
        map[0x000D] = "WM_GETTEXT";
        map[0x000F] = "WM_PAINT";
        map[0x0010] = "WM_CLOSE";
        map[0x0012] = "WM_QUIT";
        map[0x0013] = "WM_QUERYOPEN";
        map[0x0014] = "WM_ERASEBKGND";
        map[0x0018] = "WM_SHOWWINDOW";
        map[0x001A] = "WM_WININICHANGE";
        map[0x001C] = "WM_ACTIVATEAPP";
        map[0x001F] = "WM_CANCELMODE";
        map[0x0020] = "WM_SETCURSOR";
        map[0x0021] = "WM_MOUSEACTIVATE";
        map[0x0024] = "WM_GETMINMAXINFO";
        map[0x0046] = "WM_WINDOWPOSCHANGING";
        map[0x0047] = "WM_WINDOWPOSCHANGED";
        map[0x004D] = "WM_KEYF1";
        map[0x0053] = "WM_HELP";
        map[0x007B] = "WM_CONTEXTMENU";
        map[0x007C] = "WM_STYLECHANGING";
        map[0x007D] = "WM_STYLECHANGED";
        map[0x007E] = "WM_DISPLAYCHANGE";
        map[0x007F] = "WM_GETICON";
        map[0x0081] = "WM_NCCREATE";
        map[0x0082] = "WM_NCDESTROY";
        map[0x0083] = "WM_NCCALCSIZE";
        map[0x0084] = "WM_NCHITTEST";
        map[0x0085] = "WM_NCPAINT";
        map[0x0086] = "WM_NCACTIVATE";
        map[0x0088] = "WM_SYNCPAINT";
        map[0x0090] = "WM_UAHDESTROYWINDOW";
        map[0x0093] = "WM_";
        map[0x0094] = "WM_";
        map[0x00A0] = "WM_NCMOUSEMOVE";
        map[0x00A1] = "WM_NCLBUTTONDOWN";
        map[0x00FE] = "WM_INPUT_DEVICE_CHANGE";
        map[0x00FF] = "WM_INPUT";
        map[0x0100] = "WM_KEYDOWN";
        map[0x0101] = "WM_KEYUP";
        map[0x0102] = "WM_CHAR";
        map[0x0104] = "WM_SYSKEYDOWN";
        map[0x0105] = "WM_SYSKEYUP";
        map[0x0106] = "WM_SYSCHAR";
        map[0x0111] = "WM_COMMAND";
        map[0x0112] = "WM_SYSCOMMAND";
        map[0x0113] = "WM_TIMER";
        map[0x0116] = "WM_INITMENU";
        map[0x0117] = "WM_INITMENUPOPUP";
        map[0x011F] = "WM_MENUSELECT";
        map[0x0121] = "WM_ENTERIDLE";
        map[0x0125] = "WM_UNINITMENUPOPUP";
        map[0x0200] = "WM_MOUSEMOVE";
        map[0x0201] = "WM_LBUTTONDOWN";
        map[0x0202] = "WM_LBUTTONUP";
        map[0x0204] = "WM_RBUTTONDOWN";
        map[0x0205] = "WM_RBUTTONUP";
        map[0x0211] = "WM_ENTERMENULOOP";
        map[0x0212] = "WM_EXITMENULOOP";
        map[0x0215] = "WM_CAPTURECHANGED";
        map[0x0216] = "WM_MOVING";
        map[0x0231] = "WM_ENTERSIZEMOVE";
        map[0x0232] = "WM_EXITSIZEMOVE";
        map[0x0281] = "WM_IME_SETCONTEXT";
        map[0x0282] = "WM_IME_NOTIFY";
        map[0x02A2] = "WM_NCMOUSELEAVE";
        map[0x0310] = "WM_PALETTEISCHANGING";
        map[0x0311] = "WM_PALETTECHANGED";
        map[0x0313] = "WM_POPUPSYSTEMMENU";
        map[0x031F] = "WM_DWMNCRENDERINGCHANGED";
        map[0x0320] = "WM_DWMCOLORIZATIONCOLORCHANGED";
        map[0x033F] = "WM_GETTITLEBARINFOEX";

        auto str = uMsg in map ? map[uMsg] : "WM_" ~ to!string(uMsg);

        if (uMsg == WM_ACTIVATE)
        {
            bool active = (wParam & 0xffff) != WA_INACTIVE;
            bool minimized = ((wParam >> 16) & 0xffff) != FALSE;

            str ~= active ? " active" : " inactive";
            str ~= minimized ? " minimized" : " normal";
        }
        else if (uMsg == WM_DISPLAYCHANGE)
        {
            str ~= " " ~ to!string(lParam & 0xff);
            str ~= "x" ~ to!string((lParam >> 16) & 0xff);
            str ~= " " ~ to!string(wParam);
        }
        else if (uMsg == WM_SYSCOMMAND)
        {
            str ~= " ";

            switch (wParam & 0xFFF0)
            {
                case 0xF060: str ~= "SC_CLOSE"; break;
                case 0xF180: str ~= "SC_CONTEXTHELP"; break;
                case 0xF160: str ~= "SC_DEFAULT"; break;
                case 0xF150: str ~= "SC_HOTKEY"; break;
                case 0xF080: str ~= "SC_HSCROLL"; break;
                case 0x0001: str ~= "SCF_ISSECURE"; break;
                case 0xF100: str ~= "SC_KEYMENU"; break;
                case 0xF030: str ~= "SC_MAXIMIZE"; break;
                case 0xF020: str ~= "SC_MINIMIZE"; break;
                case 0xF170: str ~= "SC_MONITORPOWER"; break;
                case 0xF090: str ~= "SC_MOUSEMENU"; break;
                case 0xF010: str ~= "SC_MOVE"; break;
                case 0xF040: str ~= "SC_NEXTWINDOW"; break;
                case 0xF050: str ~= "SC_PREVWINDOW"; break;
                case 0xF120: str ~= "SC_RESTORE"; break;
                case 0xF140: str ~= "SC_SCREENSAVE"; break;
                case 0xF000: str ~= "SC_SIZE"; break;
                case 0xF130: str ~= "SC_TASKLIST"; break;
                case 0xF070: str ~= "SC_VSCROLL"; break;
                default: str ~= to!string(wParam); break;
            }
        }

        return str;
    }
}
