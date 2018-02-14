module durge.system.windows.native.windows;

version (Windows):

import durge.system.windows.native.common;
import durge.system.windows.native.gdi;

enum // General
{
    CW_USEDEFAULT = cast (INT) 0x80000000U,
}

enum // Window Class Style
{
    CS_VREDRAW         = 0x00000001U,
    CS_HREDRAW         = 0x00000002U,
    CS_DBLCLKS         = 0x00000008U,
    CS_OWNDC           = 0x00000020U,
    CS_CLASSDC         = 0x00000040U,
    CS_PARENTDC        = 0x00000080U,
    CS_NOCLOSE         = 0x00000200U,
    CS_SAVEBITS        = 0x00000800U,
    CS_BYTEALIGNCLIENT = 0x00001000U,
    CS_BYTEALIGNWINDOW = 0x00002000U,
    CS_GLOBALCLASS     = 0x00004000U,
    CS_DROPSHADOW      = 0x00020000U,
}

enum // SetWindowPos()
{
    HWND_NOTOPMOST = -2,
    HWND_TOPMOST   = -1,
    HWND_TOP       = 0,
    HWND_BOTTOM    = 1,
}

enum // PeekMessage()
{
    PM_RNOEMOVE = 0,
    PM_REMOVE   = 1,
    PM_NOYIELD  = 2,
}

enum // Sys Command
{
    SCF_ISSECURE    = 0x0001,
    SC_CLOSE        = 0xF060,
    SC_CONTEXTHELP  = 0xF180,
    SC_DEFAULT      = 0xF160,
    SC_HOTKEY       = 0xF150,
    SC_HSCROLL      = 0xF080,
    SC_KEYMENU      = 0xF100,
    SC_MAXIMIZE     = 0xF030,
    SC_MINIMIZE     = 0xF020,
    SC_MONITORPOWER = 0xF170,
    SC_MOUSEMENU    = 0xF090,
    SC_MOVE         = 0xF010,
    SC_NEXTWINDOW   = 0xF040,
    SC_PREVWINDOW   = 0xF050,
    SC_RESTORE      = 0xF120,
    SC_SCREENSAVE   = 0xF140,
    SC_SIZE         = 0xF000,
    SC_TASKLIST     = 0xF130,
    SC_VSCROLL      = 0xF070,
}

enum // ShowWindow()
{
    SW_HIDE            = 0,
    SW_SHOWNORMAL      = 1,
    SW_SHOWMINIMIZED   = 2,
    SW_SHOWMAXIMIZED   = 3,
    SW_SHOWNOACTIVATE  = 4,
    SW_SHOW            = 5,
    SW_MINIMIZE        = 6,
    SW_SHOWMINNOACTIVE = 7,
    SW_SHOWNA          = 8,
    SW_RESTORE         = 9,
    SW_SHOWDEFAULT     = 10,
    SW_FORCEMINIMIZE   = 11,

    SW_NORMAL   = SW_SHOWNORMAL,
    SW_MAXIMIZE = SW_SHOWMAXIMIZED,
}

enum // SetWindowPos()
{
    SWP_NOSIZE         = 0x0001,
    SWP_NOMOVE         = 0x0002,
    SWP_NOZORDER       = 0x0004,
    SWP_NOREDRAW       = 0x0008,
    SWP_NOACTIVATE     = 0x0010,
    SWP_FRAMECHANGED   = 0x0020,
    SWP_DRAWFRAME      = 0x0020,
    SWP_SHOWWINDOW     = 0x0040,
    SWP_HIDEWINDOW     = 0x0080,
    SWP_NOCOPYBITS     = 0x0100,
    SWP_NOOWNERZORDER  = 0x0200,
    SWP_NOREPOSITION   = 0x0200,
    SWP_NOSENDCHANGING = 0x0400,
    SWP_DEFERERASE     = 0x2000,
    SWP_ASYNCWINDOWPOS = 0x4000,
}

enum // Window Messages
{
    WM_CREATE            = 0x0001,
    WM_DESTROY           = 0x0002,
    WM_PAINT             = 0x000F,
    WM_CLOSE             = 0x0010,
    WM_QUIT              = 0x0012,
    WM_WINDOWPOSCHANGING = 0x0046,
    WM_WINDOWPOSCHANGED  = 0x0047,
    WM_NCCREATE          = 0x0081,
    WM_NCDESTROY         = 0x0082,
    WM_SYSCOMMAND        = 0x0112,
}

enum // Window Styles
{
    WS_OVERLAPPED   = 0x00000000U,
    WS_MAXIMIZEBOX  = 0x00010000U,
    WS_MINIMIZEBOX  = 0x00020000U,
    WS_GROUP        = 0x00020000U,
    WS_THICKFRAME   = 0x00040000U,
    WS_SYSMENU      = 0x00080000U,
    WS_HSCROLL      = 0x00100000U,
    WS_VSCROLL      = 0x00200000U,
    WS_DLGFRAME     = 0x00400000U,
    WS_BORDER       = 0x00800000U,
    WS_MAXIMIZE     = 0x01000000U,
    WS_CLIPCHILDREN = 0x02000000U,
    WS_CLIPSIBLINGS = 0x04000000U,
    WS_DISABLED     = 0x08000000U,
    WS_VISIBLE      = 0x10000000U,
    WS_MINIMIZE     = 0x20000000U,
    WS_CHILD        = 0x40000000U,
    WS_POPUP        = 0x80000000U,

    WS_CAPTION = WS_BORDER | WS_DLGFRAME,
    WS_ICONIC  = WS_MINIMIZE,
    WS_SIZEBOX = WS_THICKFRAME,
    WS_TILED   = WS_OVERLAPPED,

    WS_CHILDWINDOW      = WS_CHILD,
    WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX,
    WS_POPUPWINDOW      = WS_POPUP | WS_BORDER | WS_SYSMENU,
    WS_TILEDWINDOW      = WS_OVERLAPPEDWINDOW,
}

enum // Window Styles Ex
{
    WS_EX_DLGMODALFRAME   = 0x00000001U,
    WS_EX_NOPARENTNOTIFY  = 0x00000004U,
    WS_EX_TOPMOST         = 0x00000008U,
    WS_EX_ACCEPTFILES     = 0x00000010U,
    WS_EX_TRANSPARENT     = 0x00000020U,
    WS_EX_MDICHILD        = 0x00000040U,
    WS_EX_TOOLWINDOW      = 0x00000080U,
    WS_EX_WINDOWEDGE      = 0x00000100U,
    WS_EX_CLIENTEDGE      = 0x00000200U,
    WS_EX_CONTEXTHELP     = 0x00000400U,
    WS_EX_RIGHT           = 0x00001000U,
    WS_EX_LEFT            = 0x00000000U,
    WS_EX_RTLREADING      = 0x00002000U,
    WS_EX_LTRREADING      = 0x00000000U,
    WS_EX_LEFTSCROLLBAR   = 0x00004000U,
    WS_EX_RIGHTSCROLLBAR  = 0x00000000U,
    WS_EX_CONTROLPARENT   = 0x00010000U,
    WS_EX_STATICEDGE      = 0x00020000U,
    WS_EX_APPWINDOW       = 0x00040000U,
    WS_EX_LAYERED         = 0x00080000U,
    WS_EX_NOINHERITLAYOUT = 0x00100000U,
    WS_EX_LAYOUTRTL       = 0x00400000U,
    WS_EX_COMPOSITED      = 0x02000000U,
    WS_EX_NOACTIVATE      = 0x08000000U,

    WS_EX_OVERLAPPEDWINDOW  = WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE,
    WS_EX_PALETTEWINDOW     = WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST,
}

version (Win32) enum // GetWindowLong()
{
    GWL_WNDPROC   = -4,
    GWL_HINSTANCE = -6,
    GWL_ID        = -12,
    GWL_STYLE     = -16,
    GWL_EXSTYLE   = -20,
    GWL_USERDATA  = -21,
}

version (Win64) enum // GetWindowLong()
{
    GWLP_WNDPROC    = -4,
    GWLP_HINSTANCE  = -6,
    GWLP_HWNDPARENT = -8,
    GWLP_ID         = -12,
    GWL_STYLE       = -16,
    GWL_EXSTYLE     = -20,
    GWLP_USERDATA   = -21,
}

alias HANDLE HICON;
alias HICON  HCURSOR;
alias HANDLE HMENU;
alias HANDLE HWND;

struct CREATESTRUCT
{
    LPVOID    lpCreateParams;
    HINSTANCE hInstance;
    HMENU     hMenu;
    HWND      hwndParent;
    INT       cy;
    INT       cx;
    INT       y;
    INT       x;
    LONG      style;
    LPCWSTR   lpszName;
    LPCWSTR   lpszClass;
    DWORD     dwExStyle;
}

struct MSG
{
	HWND   hWnd;
	UINT   message;
	WPARAM wParam;
	LPARAM lParam;
	DWORD  time;
	POINT  pt;
}

struct WINDOWPLACEMENT
{
    UINT  length;
    UINT  flags;
    UINT  showCmd;
    POINT ptMinPosition;
    POINT ptMaxPosition;
    RECT  rcNormalPosition;
}

struct WINDOWPOS
{
	HWND hWnd;
	HWND hWndInsertAfter;
	int  x;
	int  y;
	int  cx;
	int  cy;
	UINT flags;
}

struct WNDCLASSEXW
{
	UINT      cbSize;
	UINT      style;
	WNDPROC   lpfnWndProc;
	INT       cbClsExtra;
	INT       cbWndExtra;
	HINSTANCE hInstance;
	HICON     hIcon;
	HCURSOR   hCursor;
	HBRUSH    hbrBackground;
	LPCWSTR   lpszMenuName;
	LPCWSTR   lpszClassName;
	HICON     hIconSm;
}

alias CREATESTRUCT*    LPCREATESTRUCT;
alias MSG*             LPMSG;
alias WINDOWPLACEMENT* LPWINDOWPLACEMENT;
alias WINDOWPOS*       LPWINDOWPOS;

alias const (WNDCLASSEXW)* PCWNDCLASSEXW;

extern (Windows)
{
    alias LRESULT function(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) WNDPROC;

    nothrow:
    @nogc:

    BOOL AdjustWindowRectEx(LPRECT lpRect, DWORD dwStyle, BOOL bMenu, DWORD dwExStyle);
    BOOL ClipCursor(LPCRECT lpRect);
    HWND CreateWindowExW(DWORD dwExStyle, LPCWSTR lpClassName, LPCWSTR lpWindowName, DWORD dwStyle, INT x, INT y, INT nWidth, INT nHeight, HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, LPVOID lpParam);
    LRESULT DefWindowProcW(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
    BOOL DestroyWindow(HWND hWnd);
    LRESULT DispatchMessageW(LPMSG lpMsg);
    BOOL GetClientRect(HWND hWnd, LPRECT lpRect);
    version (Win32) LONG GetWindowLongW(HWND hWnd, INT nIndex);
    version (Win64) LONG_PTR GetWindowLongPtrW(HWND hWnd, INT nIndex);
    BOOL GetWindowPlacement(HWND hWnd, LPWINDOWPLACEMENT lpwndpl);
    BOOL GetWindowRect(HWND hWnd, LPRECT lpRect);
    BOOL PeekMessageW(LPMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg);
    ATOM RegisterClassExW(PCWNDCLASSEXW lpwcx);
    BOOL SetForegroundWindow(HWND hWnd);
    version (Win32) LONG SetWindowLongW(HWND hWnd, INT nIndex, LONG dwNewLong);
    version (Win64) LONG_PTR SetWindowLongPtrW(HWND hWnd, INT nIndex, LONG_PTR dwNewLong);
    BOOL SetWindowPos(HWND hWnd, HWND hWndInsertAfter, INT x, INT y, INT cx, INT cy, UINT uFlags);
    INT ShowCursor(BOOL bShow);
    BOOL ShowWindow(HWND hWnd, INT nCmdShow);
    BOOL TranslateMessage(LPMSG lpMsg);
    BOOL UnregisterClassW(LPCWSTR lpClassName, HINSTANCE hInstance);
}

alias CreateWindowExW CreateWindowEx;
alias DefWindowProcW DefWindowProc;
alias DispatchMessageW DispatchMessage;
version (Win32) alias GetWindowLongW GetWindowLong;
version (Win64) alias GetWindowLongPtrW GetWindowLongPtr;
alias PeekMessageW PeekMessage;
alias RegisterClassExW RegisterClassEx;
version (Win32) alias SetWindowLongW SetWindowLong;
version (Win64) alias SetWindowLongPtrW SetWindowLongPtr;
alias UnregisterClassW UnregisterClass;

VOID _AdjustWindowRect(LPRECT lpRect, DWORD dwStyle, DWORD dwExStyle)
{
    BOOL result = AdjustWindowRectEx(lpRect, dwStyle, FALSE, dwExStyle);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

VOID _ClipCursor(LPCRECT lpRect)
{
    BOOL result = ClipCursor(lpRect);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

HWND _CreateWindow(LPCWSTR lpClassName, string windowName, HINSTANCE hInstance, DWORD dwStyle, DWORD dwExStyle, LPVOID lpParam)
{
    import std.utf : toUTF16z;

    HWND hWnd = CreateWindowEx(dwExStyle, lpClassName, windowName.toUTF16z(), dwStyle,
                               0, 0, 0, 0, null, null, hInstance, lpParam);

    if (hWnd is null)
    {
        throw new WindowsException();
    }

    return hWnd;
}

LRESULT _DefWindowProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

VOID _DestroyWindow(HWND hWnd)
{
    BOOL result = DestroyWindow(hWnd);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

nothrow @nogc VOID DestroyWindowAndSetNull(ref HWND hWnd)
{
    if (hWnd !is null)
    {
        DestroyWindow(hWnd);
        hWnd = null;
    }
}

VOID _DestroyWindowAndSetNull(ref HWND hWnd)
{
    if (hWnd !is null)
    {
        BOOL result = DestroyWindow(hWnd);

        if (result == FALSE)
        {
            throw new WindowsException();
        }

        hWnd = null;
    }
}

VOID _DispatchMessage(LPMSG lpMsg)
{
    DispatchMessage(lpMsg);
}

VOID _GetClientRect(HWND hWnd, LPRECT lpRect)
{
    BOOL result = GetClientRect(hWnd, lpRect);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

version (Win32) LONG _GetWindowLong(HWND hWnd, INT uIndex)
{
    SetLastError(0);
    LONG result = GetWindowLong(hWnd, uIndex);
    DWORD errorCode = GetLastError();

    if (result == 0 && errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return result;
}

version (Win64) LONG_PTR _GetWindowLongPtr(HWND hWnd, INT nIndex)
{
    SetLastError(0);
    LONG_PTR result = GetWindowLongPtr(hWnd, nIndex);
    DWORD errorCode = GetLastError();

    if (result == 0 && errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return result;
}

VOID _GetWindowPlacement(HWND hWnd, LPWINDOWPLACEMENT lpwndpl)
{
    BOOL result = GetWindowPlacement(hWnd, lpwndpl);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

VOID _GetWindowRect(HWND hWnd, LPRECT lpRect)
{
    BOOL result = GetWindowRect(hWnd, lpRect);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

BOOL _PeekMessage(LPMSG lpMsg, UINT wRemoveMsg)
{
    return PeekMessage(lpMsg, null, 0, 0, wRemoveMsg);
}

ATOM _RegisterClass(LPCWSTR lpClassName, HINSTANCE hInstance, WNDPROC wndProc)
{
    WNDCLASSEXW windowClass;
    windowClass.cbSize = WNDCLASSEXW.sizeof;
    windowClass.style = CS_CLASSDC;
    windowClass.lpfnWndProc = wndProc;
    windowClass.hInstance = hInstance;
    windowClass.lpszClassName = lpClassName;

    ATOM result = RegisterClassEx(&windowClass);

    if (result == 0)
    {
        throw new WindowsException();
    }

    return result;
}

VOID _SetForegroundWindow(HWND hWnd)
{
    BOOL result = SetForegroundWindow(hWnd);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

version (Win32) LONG _SetWindowLong(HWND hWnd, INT uIndex, LONG dwNewLong)
{
    SetLastError(0);
    LONG result = SetWindowLong(hWnd, uIndex, dwNewLong);
    DWORD errorCode = GetLastError();

    if (result == 0 && errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return result;
}

version (Win64) LONG_PTR _SetWindowLongPtr(HWND hWnd, INT uIndex, LONG_PTR dwNewLong)
{
    SetLastError(0);
    LONG_PTR result = SetWindowLongPtr(hWnd, uIndex, dwNewLong);
    DWORD errorCode = GetLastError();

    if (result == 0 && errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return result;
}

VOID _SetWindowPos(HWND hWnd, HWND hWndInsertAfter, INT x, INT y, INT cx, INT cy, UINT uFlags)
{
    BOOL result = SetWindowPos(hWnd, hWndInsertAfter, x, y, cx, cy, uFlags);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

VOID _ShowCursor(BOOL bShow)
{
    SetLastError(0);
    INT result = ShowCursor(bShow);
    DWORD errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    while (bShow != FALSE && result < 0 || bShow == FALSE && result >= 0)
    {
        SetLastError(0);
        result = ShowCursor(bShow);
        errorCode = GetLastError();

        if (errorCode != 0)
        {
            throw new WindowsException(errorCode);
        }
    }
}

BOOL _ShowWindow(HWND hWnd, INT nCmdShow)
{
    SetLastError(0);
    BOOL result = ShowWindow(hWnd, nCmdShow);
    DWORD errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return result;
}

VOID _TranslateMessage(LPMSG lpMsg)
{
    TranslateMessage(lpMsg);
}

VOID _UnregisterClass(LPCWSTR lpClassName, HINSTANCE hInstance)
{
    BOOL result = UnregisterClass(lpClassName, hInstance);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}
