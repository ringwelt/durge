module durge.system.windows.native.mouse;

version (Windows):

import durge.system.windows.native.common;
import durge.system.windows.native.windows;

enum // Window Mouse Activate
{
    MA_ACTIVATE         = 1,
    MA_ACTIVATEANDEAT   = 2,
    MA_NOACTIVATE       = 3,
    MA_NOACTIVATEANDEAT = 4,
}

enum // Window Messages
{
    WM_MOUSEACTIVATE     = 0x0021,
    WM_LBUTTONDOWN       = 0x0201,
    WM_RBUTTONDOWN       = 0x0204,
    WM_MBUTTONDOWN       = 0x0207,
}

enum // Hit Test
{
    HTERROR       = -2,
    HTTRANSPARENT = -1,
    HTNOWHERE     = 0,
    HTCLIENT      = 1,
    HTCAPTION     = 2,
    HTSYSMENU     = 3,
    HTGROWBOX     = 4,
    HTSIZE        = 4,
    HTMENU        = 5,
    HTHSCROLL     = 6,
    HTVSCROLL     = 7,
    HTMINBUTTON   = 8,
    HTREDUCE      = 8,
    HTMAXBUTTON   = 9,
    HTZOOM        = 9,
    HTLEFT        = 10,
    HTRIGHT       = 11,
    HTTOP         = 12,
    HTTOPLEFT     = 13,
    HTTOPRIGHT    = 14,
    HTBOTTOM      = 15,
    HTBOTTOMLEFT  = 16,
    HTBOTTOMRIGHT = 17,
    HTBORDER      = 18,
    HTCLOSE       = 20,
    HTHELP        = 21,
}

extern (Windows)
{
    nothrow:
    @nogc:

    BOOL ReleaseCapture();
    HWND SetCapture(HWND hWnd);
}

VOID _ReleaseCapture()
{
    BOOL result = ReleaseCapture();

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

HWND _SetCapture(HWND hWnd)
{
    SetLastError(0);
    HWND result = SetCapture(hWnd);
    DWORD errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return result;
}
