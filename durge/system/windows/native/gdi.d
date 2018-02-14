module durge.system.windows.native.gdi;

version (Windows):

import durge.common;
import durge.system.windows.native.common;
import durge.system.windows.native.windows;

enum // General
{
    GDI_ERROR = 0xffffffffU,

    CCHDEVICENAME = 32,
    CCHFORMNAME   = 32,
}

enum // Get Monitor Flags
{
    MONITOR_DEFAULTTONULL    = 0,
    MONITOR_DEFAULTTOPRIMARY = 1,
    MONITOR_DEFAULTTONEAREST = 2,
}

enum // Enum Display Settings
{
    ENUM_CURRENT_SETTINGS  = -1,
    ENUM_REGISTRY_SETTINGS = -2,
}

enum // Change Display Settings
{
    CDS_UPDATEREGISTRY       = 0x00000001U,
    CDS_TEST                 = 0x00000002U,
    CDS_FULLSCREEN           = 0x00000004U,
    CDS_GLOBAL               = 0x00000008U,
    CDS_SET_PRIMARY          = 0x00000010U,
    CDS_VIDEOPARAMETERS      = 0x00000020U,
    CDS_ENABLE_UNSAFE_MODES  = 0x00000100U,
    CDS_DISABLE_UNSAFE_MODES = 0x00000200U,
    CDS_NORESET              = 0x10000000U,
    CDS_RESET_EX             = 0x20000000U,
    CDS_RESET                = 0x40000000U,
}

enum // Change Display Settings Result
{
    DISP_CHANGE_SUCCESSFUL  = 0,
    DISP_CHANGE_RESTART     = 1,
    DISP_CHANGE_FAILED      = -1,
    DISP_CHANGE_BADMODE     = -2,
    DISP_CHANGE_NOTUPDATED  = -3,
    DISP_CHANGE_BADFLAGS    = -4,
    DISP_CHANGE_BADPARAM    = -5,
    DISP_CHANGE_BADDUALVIEW = -6,
}

enum // Device Mode Fields
{
    DM_BITSPERPEL       = 0x00040000,
    DM_PELSWIDTH        = 0x00080000,
    DM_PELSHEIGHT       = 0x00100000,
    DM_DISPLAYFLAGS     = 0x00200000,
    DM_DISPLAYFREQUENCY = 0x00400000,
}

enum // Get Device Caps
{
    RASTERCAPS = 38,
}

enum // Device Raster Caps
{
    RC_PALETTE = 0x00000100U,
}

enum // DIB Section Usage
{
    DIB_RGB_COLORS = 0,
    DIB_PAL_COLORS = 1,
}

enum // Bitmap Compression
{
    BI_RGB       = 0,
    BI_RLE8      = 1,
    BI_RLE4      = 2,
    BI_BITFIELDS = 3,
    BI_JPEG      = 4,
    BI_PNG       = 5,
}

enum // Blit Flags
{
    SRCCOPY        = 0x00CC0020U,
    SRCPAINT       = 0x00EE0086U,
    SRCAND         = 0x008800C6U,
    SRCINVERT      = 0x00660046U,
    SRCERASE       = 0x00440328U,
    NOTSRCCOPY     = 0x00330008U,
    NOTSRCERASE    = 0x001100A6U,
    MERGECOPY      = 0x00C000CAU,
    MERGEPAINT     = 0x00BB0226U,
    PATCOPY        = 0x00F00021U,
    PATPAINT       = 0x00FB0A09U,
    PATINVERT      = 0x005A0049U,
    DSTINVERT      = 0x00550009U,
    BLACKNESS      = 0x00000042U,
    WHITENESS      = 0x00FF0062U,
    CAPTUREBLT     = 0x40000000U,
    NOMIRRORBITMAP = 0x80000000U,
}

enum // Palette Entry
{
    PC_RESERVED   = 1,
    PC_EXPLICIT   = 2,
    PC_NOCOLLAPSE = 4,
}

enum // System Palette
{
    SYSPAL_ERROR       = 0,
    SYSPAL_STATIC      = 1,
    SYSPAL_NOSTATIC    = 2,
    SYSPAL_NOSTATIC256 = 3,
}

enum // Window Messages
{
    WM_DISPLAYCHANGE = 0x007E,
}

alias HANDLE HBITMAP;
alias HANDLE HBRUSH;
alias HANDLE HDC;
alias HANDLE HGDIOBJ;
alias HANDLE HMONITOR;
alias HANDLE HPALETTE;

struct MONITORINFO
{
	DWORD cbSize;
	RECT  rcMonitor;
	RECT  rcWork;
	DWORD dwFlags;
}

struct DEVMODE
{
	WCHAR[CCHDEVICENAME] dmDeviceName;
	WORD  dmSpecVersion;
	WORD  dmDriverVersion;
	WORD  dmSize;
	WORD  dmDriverExtra;
	DWORD dmFields;
	union
	{
		struct
		{
            SHORT vdmOrientation;
            SHORT dmPaperSize;
            SHORT dmPaperLength;
            SHORT dmPaperWidth;
            SHORT dmScale;
            SHORT dmCopies;
            SHORT dmDefaultSource;
			SHORT dmPrintQuality;
		}
		struct
		{
			POINTL dmPosition;
			DWORD  dmDisplayOrientation;
			DWORD  dmDisplayFixedOutput;
		}
	}
    SHORT dmColor;
    SHORT dmDuplex;
    SHORT dmYResolution;
    SHORT dmTTOption;
    SHORT dmCollate;
	WCHAR[CCHFORMNAME] dmFormName;
	WORD  dmLogPixels;
	DWORD dmBitsPerPel;
	DWORD dmPelsWidth;
	DWORD dmPelsHeight;
	union
	{
		DWORD dmDisplayFlags;
		DWORD dmNup;
	}
	DWORD dmDisplayFrequency;
	DWORD dmICMMethod;
	DWORD dmICMIntent;
	DWORD dmMediaType;
	DWORD dmDitherType;
	DWORD dmReserved1;
	DWORD dmReserved2;
	DWORD dmPanningWidth;
	DWORD dmPanningHeight;
}

struct BITMAPINFOHEADER
{
	DWORD biSize;
	LONG  biWidth;
	LONG  biHeight;
	WORD  biPlanes;
	WORD  biBitCount;
	DWORD biCompression;
	DWORD biSizeImage;
	LONG  biXPelsPerMeter;
	LONG  biYPelsPerMeter;
	DWORD biClrUsed;
	DWORD biClrImportant;
}

struct BITMAPINFO
{
	BITMAPINFOHEADER bmiHeader;
    union
    {
        RGBQUAD[256] bmiColors;
        DWORD[3]     bmiBitMasks;
    }
}

struct RGBQUAD
{
	BYTE rgbBlue;
	BYTE rgbGreen;
	BYTE rgbRed;
	BYTE rgbReserved;
}

struct LOGPALETTE
{
    WORD palVersion;
    WORD palNumEntries;
    PALETTEENTRY[256] palPalEntry;
}

struct PALETTEENTRY
{
    BYTE peRed;
    BYTE peGreen;
    BYTE peBlue;
    BYTE peFlags;
}

struct POINT
{
	LONG x;
	LONG y;
}

struct RECT
{
	LONG left;
	LONG top;
	LONG right;
	LONG bottom;
}

struct SIZE
{
    LONG cx;
    LONG cy;
}

struct RGNDATAHEADER
{
    DWORD dwSize;
    DWORD iType;
    DWORD nCount;
    DWORD nRgnSize;
    RECT  rcBound;
}

struct RGNDATA
{
    RGNDATAHEADER rdh;
    RECT[1]       Buffer;
}

alias POINT POINTL;

alias MONITORINFO*  LPMONITORINFO;
alias DEVMODE*      LPDEVMODE;
alias BITMAPINFO*   LPBITMAPINFO;
alias RGBQUAD*      LPRGBQUAD;
alias LOGPALETTE*   LPLOGPALETTE;
alias PALETTEENTRY* LPPALETTEENTRY;
alias POINT*        LPPOINT;
alias RECT*         LPRECT;
alias SIZE*         LPSIZE;
alias RGNDATA*      LPRGNDATA;

alias const (BITMAPINFO)* LPCBITMAPINFO;
alias const (LOGPALETTE)* LPCLOGPALETTE;
alias const (RECT)*       LPCRECT;

extern (Windows)
{
    nothrow:
    @nogc:

    BOOL BitBlt(HDC hdcDest, INT nXDest, INT nYDest, INT nWidth, INT nHeight, HDC hdcSrc, INT nXSrc, INT nYSrc, DWORD dwRop);
    LONG ChangeDisplaySettingsExW(LPCWSTR lpszDeviceName, LPDEVMODE lpDevMode, HWND hWnd, DWORD dwFlags, LPVOID lParam);
    BOOL ClientToScreen(HWND hWnd, LPPOINT lpPoint);
    HDC CreateCompatibleDC(HDC hdc);
    HBITMAP CreateDIBSection(HDC hdc, LPCBITMAPINFO pbmi, UINT iUsage, LPVOID* ppvBits, HANDLE hSection, DWORD dwOffset);
    HPALETTE CreatePalette(LPCLOGPALETTE lplgpl);
    BOOL DeleteDC(HDC hdc);
    BOOL DeleteObject(HGDIOBJ hObject);
    BOOL EnumDisplaySettingsW(LPCWSTR lpszDeviceName, DWORD iModeNum, LPDEVMODE lpDevMode);
    HDC GetDC(HWND hWnd);
    INT GetDeviceCaps(HDC hdc, INT nIndex);
    BOOL GetMonitorInfoW(HMONITOR hMonitor, LPMONITORINFO lpmi);
    HMONITOR MonitorFromWindow(HWND hwnd, DWORD dwFlags);
    BOOL OffsetRect(LPRECT lprc, INT dx, INT dy);
    UINT RealizePalette(HDC hdc);
    INT ReleaseDC(HWND hWnd, HDC hDC);
    HGDIOBJ SelectObject(HDC hdc, HGDIOBJ hgdiobj);
    HPALETTE SelectPalette(HDC hdc, HPALETTE hpal, BOOL bForceBackground);
    BOOL SetRect(LPRECT lprc, INT xLeft, INT yTop, INT xRight, INT yBottom);
    UINT SetSystemPaletteUse(HDC hdc, UINT uUsage);
    BOOL StretchBlt(HDC hdcDest, INT nXOriginDest, INT nYOriginDest, INT nWidthDest, INT nHeightDest, HDC hdcSrc, INT nXOriginSrc, INT nYOriginSrc, INT nWidthSrc, INT nHeightSrc, DWORD dwRop);
    BOOL UnrealizeObject(HGDIOBJ hgdiobj);
}

alias ChangeDisplaySettingsExW ChangeDisplaySettingsEx;
alias EnumDisplaySettingsW EnumDisplaySettings;
alias GetMonitorInfoW GetMonitorInfo;

class ChangeDisplaySettingsException : WindowsException
{
	this(LONG errorCode)
	{
        super(errorCode, getErrorMessage(errorCode));
	}

    private string getErrorMessage(HRESULT errorCode)
    {
        import std.format : format;

        auto symbol = getChangeDisplaySettingsErrorSymbol(errorCode);
        auto message = getChangeDisplaySettingsErrorMessage(errorCode);

        return message !is null
            ? "%s(%s): %s".format(symbol, errorCode, message)
            : "Unknown error";
    }
}

private string getChangeDisplaySettingsErrorSymbol(LONG errorCode)
{
    string symbol;

    switch (errorCode)
    {
        case DISP_CHANGE_RESTART:     symbol = "DISP_CHANGE_RESTART"; break;
        case DISP_CHANGE_FAILED:      symbol = "DISP_CHANGE_FAILED"; break;
        case DISP_CHANGE_BADMODE:     symbol = "DISP_CHANGE_BADMODE"; break;
        case DISP_CHANGE_NOTUPDATED:  symbol = "DISP_CHANGE_NOTUPDATED"; break;
        case DISP_CHANGE_BADFLAGS:    symbol = "DISP_CHANGE_BADFLAGS"; break;
        case DISP_CHANGE_BADPARAM:    symbol = "DISP_CHANGE_BADPARAM"; break;
        case DISP_CHANGE_BADDUALVIEW: symbol = "DISP_CHANGE_BADDUALVIEW"; break;
        default: break;
    }

    return symbol;
}

private string getChangeDisplaySettingsErrorMessage(LONG errorCode)
{
    string message;

    switch (errorCode)
    {
        case DISP_CHANGE_RESTART:     message = "The computer must be restarted for the graphics mode to work."; break;
        case DISP_CHANGE_FAILED:      message = "The display driver failed the specified graphics mode."; break;
        case DISP_CHANGE_BADMODE:     message = "The graphics mode is not supported."; break;
        case DISP_CHANGE_NOTUPDATED:  message = "Unable to write settings to the registry."; break;
        case DISP_CHANGE_BADFLAGS:    message = "An invalid set of flags was passed in."; break;
        case DISP_CHANGE_BADPARAM:    message = "An invalid parameter was passed in. This can include an invalid flag or combination of flags."; break;
        case DISP_CHANGE_BADDUALVIEW: message = "The settings change was unsuccessful because the system is DualView capable."; break;
        default: break;
    }

    return message;
}

VOID _BitBlt(HDC hdcDest, INT nXDest, INT nYDest, INT nWidth, INT nHeight, HDC hdcSrc, INT nXSrc, INT nYSrc, DWORD dwRop)
{
    BOOL result = BitBlt(hdcDest, nXDest, nYDest, nWidth, nHeight, hdcSrc, nXSrc, nYSrc, dwRop);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

VOID _ChangeDisplaySettings(LPCWSTR lpszDeviceName, LPDEVMODE lpDevMode, DWORD dwFlags)
{
    LONG result = ChangeDisplaySettingsEx(lpszDeviceName, lpDevMode, null, dwFlags, null);

    if (result != DISP_CHANGE_SUCCESSFUL)
    {
        throw new ChangeDisplaySettingsException(result);
    }
}

VOID _ClientToScreen(HWND hWnd, LPPOINT lpPoint)
{
    BOOL result = ClientToScreen(hWnd, lpPoint);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

HDC _CreateCompatibleDC(HDC hdc)
{
    HDC result = CreateCompatibleDC(hdc);

    if (result is null)
    {
        throw new WindowsException();
    }

    return result;
}

HBITMAP _CreateDIBSection(HDC hdc, LPCBITMAPINFO pbmi, UINT iUsage, LPVOID* ppvBits)
{
    HBITMAP result = CreateDIBSection(hdc, pbmi, iUsage, ppvBits, null, 0);

    if (cast (UINT) result == ERROR_INVALID_PARAMETER)
    {
        throw new WindowsException(ERROR_INVALID_PARAMETER);
    }
    else if (result is null)
    {
        throw new WindowsException();
    }

    return result;
}

HPALETTE _CreatePalette(LPCLOGPALETTE lplgpl)
{
    HPALETTE result = CreatePalette(lplgpl);

    if (result is null)
    {
        throw new WindowsException();
    }

    return result;
}

VOID _DeleteDC(HDC hdc)
{
    BOOL result = DeleteDC(hdc);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

nothrow @nogc VOID DeleteDCAndSetNull(ref HDC hdc)
{
    if (hdc !is null)
    {
        DeleteDC(hdc);
        hdc = null;
    }
}

VOID _DeleteDCAndSetNull(ref HDC hdc)
{
    if (hdc !is null)
    {
        BOOL result = DeleteDC(hdc);

        if (result == FALSE)
        {
            throw new WindowsException();
        }

        hdc = null;
    }
}

VOID _DeleteObject(HGDIOBJ hObject)
{
    BOOL result = DeleteObject(hObject);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

nothrow @nogc VOID DeleteObjectAndSetNull(ref HGDIOBJ hObject)
{
    if (hObject !is null)
    {
        DeleteObject(hObject);
        hObject = null;
    }
}

VOID _DeleteObjectAndSetNull(ref HGDIOBJ hObject)
{
    if (hObject !is null)
    {
        BOOL result = DeleteObject(hObject);

        if (result == FALSE)
        {
            throw new WindowsException();
        }

        hObject = null;
    }
}

VOID _EnumDisplaySettings(LPCWSTR lpszDeviceName, DWORD iModeNum, LPDEVMODE lpDevMode)
{
    BOOL result = EnumDisplaySettings(lpszDeviceName, iModeNum, lpDevMode);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

DEVMODE[] _EnumAllDisplaySettings(LPCWSTR lpszDeviceName)
{
    DEVMODE[] devModes;

    for (auto iModeNum = 0; ; iModeNum++)
    {
        DEVMODE devMode;
        BOOL result = EnumDisplaySettings(lpszDeviceName, iModeNum, &devMode);

        if (result == FALSE)
        {
            if (iModeNum == 0)
            {
                throw new WindowsException();
            }

            break;
        }

        devModes ~= devMode;
    }

    return devModes;
}

HDC _GetDC(HWND hWnd)
{
    HDC result = GetDC(hWnd);

    if (result is null)
    {
        throw new WindowsException();
    }

    return result;
}

INT _GetDeviceCaps(HDC hdc, INT nIndex)
{
    SetLastError(0);
    INT result = GetDeviceCaps(hdc, nIndex);
    DWORD errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return result;
}

VOID _GetMonitorInfo(HMONITOR hMonitor, LPMONITORINFO lpmi)
{
    BOOL result = GetMonitorInfo(hMonitor, lpmi);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

HMONITOR _MonitorFromWindow(HWND hWnd, DWORD dwFlags)
{
    SetLastError(0);
    HMONITOR result = MonitorFromWindow(hWnd, dwFlags);
    DWORD errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return result;
}

VOID _OffsetRect(LPRECT lprc, INT dx, INT dy)
{
    BOOL result = OffsetRect(lprc, dx, dy);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

UINT _RealizePalette(HDC hdc)
{
    UINT result = RealizePalette(hdc);

    if (result == GDI_ERROR)
    {
        throw new WindowsException();
    }

    return result;
}

VOID _ReleaseDC(HWND hWnd, HDC hdc)
{
    INT result = ReleaseDC(hWnd, hdc);

    if (result == 0)
    {
        throw new WindowsException();
    }
}

nothrow @nogc VOID ReleaseDCAndSetNull(HWND hWnd, ref HDC hdc)
{
    if (hWnd !is null && hdc !is null)
    {
        ReleaseDC(hWnd, hdc);
        hdc = null;
    }
}

VOID _ReleaseDCAndSetNull(HWND hWnd, ref HDC hdc)
{
    if (hWnd !is null && hdc !is null)
    {
        INT result = ReleaseDC(hWnd, hdc);

        if (result == 0)
        {
            throw new WindowsException();
        }

        hdc = null;
    }
}

nothrow @nogc LONG ResetDisplaySettings(LPCWSTR lpszDeviceName)
{
    return ChangeDisplaySettingsEx(lpszDeviceName, null, null, 0, null);
}

VOID _ResetDisplaySettings(LPCWSTR lpszDeviceName)
{
    LONG result = ChangeDisplaySettingsEx(lpszDeviceName, null, null, 0, null);

    if (result != DISP_CHANGE_SUCCESSFUL)
    {
        auto message = getChangeDisplaySettingsErrorMessage(result);
        throw new WindowsException(0, message);
    }
}

HGDIOBJ _SelectObject(HDC hdc, HGDIOBJ hgdiobj)
{
    HGDIOBJ result = SelectObject(hdc, hgdiobj);

    if (result is null)
    {
        throw new WindowsException();
    }

    return result;
}

HPALETTE _SelectPalette(HDC hdc, HPALETTE hpal, BOOL bForceBackground)
{
    HPALETTE result = SelectPalette(hdc, hpal, bForceBackground);

    if (result is null)
    {
        throw new WindowsException();
    }

    return result;
}

VOID _SetRect(LPRECT lprc, INT xLeft, INT yTop, INT xRight, INT yBottom)
{
    BOOL result = SetRect(lprc, xLeft, yTop, xRight, yBottom);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

UINT _SetSystemPaletteUse(HDC hdc, UINT uUsage)
{
    UINT result = SetSystemPaletteUse(hdc, uUsage);

    if (result == SYSPAL_ERROR)
    {
        throw new WindowsException();
    }

    return result;
}

VOID _StretchBlt(HDC hdcDest, INT nXOriginDest, INT nYOriginDest, INT nWidthDest, INT nHeightDest, HDC hdcSrc, INT nXOriginSrc, INT nYOriginSrc, INT nWidthSrc, INT nHeightSrc, DWORD dwRop)
{
    BOOL result = StretchBlt(hdcDest, nXOriginDest, nYOriginDest, nWidthDest, nHeightDest, hdcSrc, nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc, dwRop);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

VOID _UnrealizeObject(HGDIOBJ hgdiobj)
{
    BOOL result = UnrealizeObject(hgdiobj);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}
