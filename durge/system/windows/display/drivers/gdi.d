module durge.system.windows.display.drivers.gdi;

version (Windows):

import durge.common;
import durge.draw.common;
import durge.system.display;
import durge.system.windows.native.common;
import durge.system.windows.native.gdi;
import durge.system.windows.native.windows;
import durge.system.windows.window;

private class WindowBitmap : Bitmap
{
    this(void* data, int width, int height, int depth)
    {
        log("WindowBitmap.this()");

        super(data, 0, width, height, depth);
    }
}

final class WindowsDisplayDriver : IDisplayDriver
{
    private Window _window;
    private HWND _windowHandle;
    private int _width, _height;
    private bool _useStretchBlt;
    private HBITMAP _bitmapHandle;
    private HPALETTE _paletteHandle;
    private HDC _hdcWindow;
    private HDC _hdcBitmap;
    private WindowBitmap _windowBitmap;

    this(Window window)
    {
        log("WindowsDisplayDriver.this()");

        enforceEx!ArgumentNullException(window !is null, "window");

        _window = window;
        _windowHandle = window.handle;
    }

    nothrow @nogc void dispose()
    {
        DeleteDCAndSetNull(_hdcBitmap);
        DeleteObjectAndSetNull(_bitmapHandle);
        ReleaseDCAndSetNull(_windowHandle, _hdcWindow);
    }

    @property string name() { return "gdi"; }

    DisplayModeInfo[] enumDisplayModes()
    {
        log("WindowsDisplayDriver.enumDisplayModes()");

        DEVMODE[] dms = _EnumAllDisplaySettings(null);
        auto builder = new DisplayModeInfoListBuilder();

        foreach (ref dm; dms)
        {
            if (dm.dmBitsPerPel != 8 && dm.dmBitsPerPel != 16 && dm.dmBitsPerPel != 32)
            {
                continue;
            }

            auto width = dm.dmPelsWidth;
            auto height = dm.dmPelsHeight;
            auto depth = dm.dmBitsPerPel;
            auto refreshRate = dm.dmDisplayFrequency;

            builder.addDisplayMode(name, width, height, depth, refreshRate);
        }

        return builder.modes;
    }

    void setDisplayMode(int width, int height, int depth, int refreshRate, bool fullscreen)
    {
        log("WindowsDisplayDriver.setDisplayMode()");

        enforceEx!ArgumentException(width > 0, "Parameter width must be greater zero.");
        enforceEx!ArgumentException(height > 0, "Parameter height must be greater zero.");
        enforceEx!ArgumentException(depth == 8 || depth == 16 || depth == 32, "Parameter depth must be 8, 16 or 32.");
        enforceEx!ArgumentException(refreshRate >= 0, "Parameter refreshRate must be zero or greater.");

        scope (success)
        {
            _width = width;
            _height = height;
        }

        _useStretchBlt = depth == 8;
        _hdcWindow = _GetDC(_window.handle);

        if (fullscreen)
        {
            initFullscreen(width, height, depth, refreshRate);
        }

        initWindowBitmap(width, height, depth);

        if (depth == 8)
        {
            initPalette(fullscreen);
        }
    }

    void resetDisplayMode()
    {
        log("WindowsDisplayDriver.resetDisplayMode()");

        delete _windowBitmap;

        /*if (_paletteHandle !is null)
        {
            _UnrealizeObject(_paletteHandle);
            _DeleteObjectAndSetNull(_paletteHandle);
        }*/

        ResetDisplaySettings(null);
        DeleteDCAndSetNull(_hdcBitmap);
        DeleteObjectAndSetNull(_bitmapHandle);
        ReleaseDCAndSetNull(_window.handle, _hdcWindow);
    }

    Bitmap getFrameBuffer()
    {
        return _windowBitmap;
    }

    void flipFrameBuffers()
    {
        if (_useStretchBlt)
        {
            _StretchBlt(_hdcWindow, 0, 0, _width, _height, _hdcBitmap, 0, 0, _width, _height, SRCCOPY);
        }
        else
        {
            _BitBlt(_hdcWindow, 0, 0, _width, _height, _hdcBitmap, 0, 0, SRCCOPY);
        }
    }

    private void initFullscreen(int width, int height, int depth, int refreshRate)
    {
        log("WindowsDisplayDriver.initFullscreen()");

        DEVMODE devMode;
        devMode.dmSize = DEVMODE.sizeof;

        _EnumDisplaySettings(null, ENUM_CURRENT_SETTINGS, &devMode);

        devMode.dmFields = DM_PELSWIDTH | DM_PELSHEIGHT | DM_BITSPERPEL | (refreshRate != 0 ? DM_DISPLAYFREQUENCY : 0);
        devMode.dmPelsWidth = width;
        devMode.dmPelsHeight = height;
        devMode.dmBitsPerPel = depth;
        devMode.dmDisplayFrequency = refreshRate;

        _ChangeDisplaySettings(null, &devMode, CDS_FULLSCREEN);
    }

    private void initWindowBitmap(int width, int height, int depth)
    {
        log("WindowsDisplayDriver.initWindowBitmap()");

        import durge.draw.color : Palette;

        BITMAPINFO bmi;
        bmi.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
        bmi.bmiHeader.biWidth = width;
        bmi.bmiHeader.biHeight = -height;
        bmi.bmiHeader.biPlanes = 1;
        bmi.bmiHeader.biSizeImage = 0;
        bmi.bmiHeader.biXPelsPerMeter = 0;
        bmi.bmiHeader.biYPelsPerMeter = 0;

        final switch (depth)
        {
            case 8:
            {
                bmi.bmiHeader.biBitCount = 8;
                bmi.bmiHeader.biCompression = BI_RGB;
                bmi.bmiHeader.biClrUsed = 256;
                bmi.bmiHeader.biClrImportant = 256;

                for (auto i = 0; i < 256; i++)
                {
                    bmi.bmiColors[i].rgbRed   = Palette.identity.entries[i].r;
                    bmi.bmiColors[i].rgbGreen = Palette.identity.entries[i].g;
                    bmi.bmiColors[i].rgbBlue  = Palette.identity.entries[i].b;
                }

                break;
            }

            case 16:
            {
                bmi.bmiHeader.biBitCount = 16;
                bmi.bmiHeader.biCompression = BI_BITFIELDS;
                bmi.bmiBitMasks[0] = 0b_11111000_00000000;
                bmi.bmiBitMasks[1] = 0b_00000111_11100000;
                bmi.bmiBitMasks[2] = 0b_00000000_00011111;

                break;
            }

            case 32:
            {
                bmi.bmiHeader.biBitCount = 32;
                bmi.bmiHeader.biCompression = BI_RGB;

                break;
            }
        }

        LPVOID data;

        _bitmapHandle = _CreateDIBSection(_hdcWindow, &bmi, DIB_RGB_COLORS, &data);
        _hdcBitmap = _CreateCompatibleDC(_hdcWindow);
        _SelectObject(_hdcBitmap, _bitmapHandle);

        _windowBitmap = new WindowBitmap(data, width, height, depth);
    }

    private void initPalette(bool fullscreen)
    {
        log("WindowsDisplayDriver.initPalette()");

        // Todo: initPalette()

        if (_GetDeviceCaps(_hdcWindow, RASTERCAPS) & RC_PALETTE)
        {
            if (fullscreen)
            {
                //_SetSystemPaletteUse(_hdcWindow, SYSPAL_NOSTATIC256);
            }

            LOGPALETTE palette;
            palette.palVersion = 0x300;
            palette.palNumEntries = 256;

            for (auto i = 0; i < 256; i++)
            {
                palette.palPalEntry[i].peRed   = Palette.identity.entries[i].r;
                palette.palPalEntry[i].peGreen = Palette.identity.entries[i].g;
                palette.palPalEntry[i].peBlue  = Palette.identity.entries[i].b;
                palette.palPalEntry[i].peFlags = PC_RESERVED | PC_NOCOLLAPSE;
            }

            /*_paletteHandle = _CreatePalette(&palette);
            _SelectPalette(_hdcWindow, _paletteHandle, FALSE);
            _RealizePalette(_hdcWindow);*/
        }
    }
}
