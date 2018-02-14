module durge.system.windows.display.drivers.ddraw;

version (Windows):

import durge.common;
import durge.draw.common;
import durge.system.display;
import durge.system.windows.native.common;
import durge.system.windows.native.ddraw;
import durge.system.windows.native.gdi;
import durge.system.windows.window;

private class SurfaceBitmap : Bitmap
{
    private LPDIRECTDRAWSURFACE7 _lpDDSurface;
    private bool _locked;

    this(LPDIRECTDRAWSURFACE7 lpDDSurface, int width, int height, int depth)
    {
        log("SurfaceBitmap.this()");

        _lpDDSurface = lpDDSurface;

        DDSURFACEDESC2 ddsd;
        ddsd.dwSize = DDSURFACEDESC2.sizeof;

        _lpDDSurface._Lock(null, &ddsd, DDLOCK_WAIT | DDLOCK_SURFACEMEMORYPTR, null);
        _locked = true;

        super(ddsd.lpSurface, ddsd.lPitch, width, height, depth);
    }

    nothrow @nogc private void dispose()
    {
        if (_lpDDSurface !is null && _locked)
        {
            _lpDDSurface.Unlock(null);
        }
    }

    @property bool locked() { return _locked; }

    void lock()
    {
        if (!_locked)
        {
            DDSURFACEDESC2 ddsd;
            ddsd.dwSize = DDSURFACEDESC2.sizeof;

            _lpDDSurface._Lock(null, &ddsd, DDLOCK_WAIT | DDLOCK_SURFACEMEMORYPTR, null);
            _locked = true;

            setData(ddsd.lpSurface, ddsd.lPitch);
        }
    }

    void unlock()
    {
        if (_locked)
        {
            _lpDDSurface._Unlock(null);
            _locked = false;
        }
    }
}

final class DirectDrawDisplayDriver : IDisplayDriver
{
    private Window _window;
    private int _width, _height;
    private bool _fullscreen;
    private bool _useStretchBlt;
    private LPDIRECTDRAW7 _lpDD;
    private LPDIRECTDRAWSURFACE7 _lpDDSurfaceFront;
    private LPDIRECTDRAWSURFACE7 _lpDDSurfaceBack;
    private LPDIRECTDRAWCLIPPER _lpDDClipper;
    private LPDIRECTDRAWPALETTE _lpDDPalette;
    private SurfaceBitmap _surfaceBitmap;

    this(Window window)
    {
        log("DirectDrawDisplayDriver.this()");

        enforceEx!ArgumentNullException(window !is null, "window");

        _window = window;
    }

    nothrow @nogc void dispose()
    {
        _surfaceBitmap.dispose();
        _lpDDPalette.ReleaseAndSetNull();
        _lpDDClipper.ReleaseAndSetNull();
        _lpDDSurfaceBack.ReleaseAndSetNull();
        _lpDDSurfaceFront.ReleaseAndSetNull();
        _lpDD.ReleaseAndSetNull();
    }

    @property string name() { return "ddraw"; }

    DisplayModeInfo[] enumDisplayModes()
    {
        log("DirectDrawDisplayDriver.enumDisplayModes()");

        if (_lpDD is null)
        {
            _DirectDrawCreateEx(null, cast (LPVOID*) &_lpDD, &IID_IDirectDraw7);
        }

        DDSURFACEDESC2[] ddsds = _lpDD._EnumAllDisplayModes();
        auto builder = new DisplayModeInfoListBuilder();

        foreach (ref ddsd; ddsds)
        {
            if (!isValidDisplayMode(ddsd))
            {
                continue;
            }

            auto width = ddsd.dwWidth;
            auto height = ddsd.dwHeight;
            auto depth = ddsd.ddpfPixelFormat.dwRGBBitCount;
            auto refreshRate = ddsd.dwRefreshRate;

            builder.addDisplayMode(name, width, height, depth, refreshRate);
        }

        return builder.modes;
    }

    private bool isValidDisplayMode(ref DDSURFACEDESC2 ddsd)
    {
        if (ddsd.ddpfPixelFormat.dwFlags == (DDPF_RGB | DDPF_PALETTEINDEXED8) &&
            ddsd.ddpfPixelFormat.dwRGBBitCount == 8)
        {
            return true;
        }

        if (ddsd.ddpfPixelFormat.dwFlags == DDPF_RGB &&
            ddsd.ddpfPixelFormat.dwRGBBitCount == 16 &&
            ddsd.ddpfPixelFormat.dwRBitMask == 0b_11111000_00000000 &&
            ddsd.ddpfPixelFormat.dwGBitMask == 0b_00000111_11100000 &&
            ddsd.ddpfPixelFormat.dwBBitMask == 0b_00000000_00011111)
        {
            return true;
        }

        if (ddsd.ddpfPixelFormat.dwFlags == DDPF_RGB &&
            ddsd.ddpfPixelFormat.dwRGBBitCount == 32 &&
            ddsd.ddpfPixelFormat.dwRBitMask == 0b_11111111_00000000_00000000 &&
            ddsd.ddpfPixelFormat.dwGBitMask == 0b_00000000_11111111_00000000 &&
            ddsd.ddpfPixelFormat.dwBBitMask == 0b_00000000_00000000_11111111)
        {
            return true;
        }

        return false;
    }

    void setDisplayMode(int width, int height, int depth, int refreshRate, bool fullscreen)
    {
        log("DirectDrawDisplayDriver.setDisplayMode()");

        enforceEx!ArgumentException(width > 0, "Parameter width must be greater zero.");
        enforceEx!ArgumentException(height > 0, "Parameter height must be greater zero.");
        enforceEx!ArgumentException(depth == 8 || depth == 16 || depth == 32, "Parameter depth must be 8, 16 or 32.");
        enforceEx!ArgumentException(refreshRate >= 0, "Parameter refreshRate must be zero or greater.");

        scope (success)
        {
            _width = width;
            _height = height;
            _fullscreen = fullscreen;
        }

        _useStretchBlt = false;

        if (_lpDD is null)
        {
            _DirectDrawCreateEx(null, cast (LPVOID*) &_lpDD, &IID_IDirectDraw7);
        }

        if (fullscreen)
        {
            initFullscreen(width, height, depth, refreshRate);
        }
        else
        {
            initWindowed(width, height, depth);

            DDPIXELFORMAT ddpfFront;
            ddpfFront.dwSize = DDPIXELFORMAT.sizeof;

            DDPIXELFORMAT ddpfBack;
            ddpfBack.dwSize = DDPIXELFORMAT.sizeof;

            _lpDDSurfaceFront._GetPixelFormat(&ddpfFront);
            _lpDDSurfaceBack._GetPixelFormat(&ddpfBack);

            _useStretchBlt = ddpfFront.dwFlags       != ddpfBack.dwFlags
                          || ddpfFront.dwRGBBitCount != ddpfBack.dwRGBBitCount
                          || ddpfFront.dwRBitMask    != ddpfBack.dwRBitMask
                          || ddpfFront.dwGBitMask    != ddpfBack.dwGBitMask
                          || ddpfFront.dwBBitMask    != ddpfBack.dwBBitMask;
        }

        _surfaceBitmap = new SurfaceBitmap(_lpDDSurfaceBack, width, height, depth);
    }

    void resetDisplayMode()
    {
        log("DirectDrawDisplayDriver.resetDisplayMode()");

        delete _surfaceBitmap;

        if (_lpDD !is null)
        {
            _lpDD.RestoreDisplayMode();
            _lpDD.SetCooperativeLevel(null, DDSCL_NORMAL);
        }

        _lpDDPalette.ReleaseAndSetNull();
        _lpDDClipper.ReleaseAndSetNull();
        _lpDDSurfaceBack.ReleaseAndSetNull();
        _lpDDSurfaceFront.ReleaseAndSetNull();
        _lpDD.ReleaseAndSetNull();
    }

    Bitmap getFrameBuffer()
    {
        if (_surfaceBitmap is null)
        {
            return null;
        }

        if (_lpDDSurfaceFront._IsLost() || _lpDDSurfaceBack._IsLost())
        {
            _lpDD._RestoreAllSurfaces();

            if (_lpDDSurfaceFront._IsLost() || _lpDDSurfaceBack._IsLost())
            {
                return null;
            }
        }

        if (!_surfaceBitmap.locked)
        {
            _surfaceBitmap.lock();
        }

        return _surfaceBitmap;
    }

    void flipFrameBuffers()
    {
        try
        {
            doFlipFrameBuffers();
        }
        catch (DirectDrawException ex)
        {
            if (ex.errorCode != DDERR_SURFACELOST)
            {
                throw ex;
            }
        }
    }

    private void doFlipFrameBuffers()
    {
        if (_surfaceBitmap.locked)
        {
            _surfaceBitmap.unlock();
        }

        if (_fullscreen)
        {
            _lpDDSurfaceFront._Flip(null, DDFLIP_WAIT | DDFLIP_NOVSYNC);
        }
        else
        {
            if (_useStretchBlt)
            {
                HDC hdcFront;
                HDC hdcBack;
                POINT offset;

                _ClientToScreen(_window.handle, &offset);

                _lpDDSurfaceFront._GetDC(&hdcFront);
                scope (exit) _lpDDSurfaceFront.ReleaseDC(hdcFront);

                _lpDDSurfaceBack._GetDC(&hdcBack);
                scope (exit) _lpDDSurfaceBack.ReleaseDC(hdcBack);

                _StretchBlt(hdcFront, offset.x, offset.y, _width, _height, hdcBack, 0, 0, _width, _height, SRCCOPY);
            }
            else
            {
                RECT rectFront;
                POINT offset;

                _SetRect(&rectFront, 0, 0, _width, _height);
                _ClientToScreen(_window.handle, &offset);
                _OffsetRect(&rectFront, offset.x, offset.y);

                _lpDDSurfaceFront._Blt(&rectFront, _lpDDSurfaceBack, null, DDBLT_WAIT, null);
            }
        }
    }

    private void initFullscreen(int width, int height, int depth, int refreshRate)
    {
        log("DirectDrawDisplayDriver.initFullscreen()");

        _lpDD._SetCooperativeLevel(_window.handle, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN | DDSCL_NOWINDOWCHANGES | DDSCL_ALLOWREBOOT);
        scope (failure) _lpDD.SetCooperativeLevel(null, DDSCL_NORMAL);

        _lpDD._SetDisplayMode(width, height, depth, refreshRate, DDSDM_STANDARDVGAMODE);
        scope (failure) _lpDD.RestoreDisplayMode();

        DDSURFACEDESC2 ddsd;
        ddsd.dwSize = DDSURFACEDESC2.sizeof;
        ddsd.dwFlags = DDSD_CAPS | DDSD_BACKBUFFERCOUNT;
        ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE | DDSCAPS_FLIP | DDSCAPS_COMPLEX;
        ddsd.dwBackBufferCount = 1;

        _lpDD._CreateSurface(&ddsd, &_lpDDSurfaceFront);

        DDSCAPS2 ddscaps;
        ddscaps.dwCaps = DDSCAPS_BACKBUFFER;

        _lpDDSurfaceFront._GetAttachedSurface(&ddscaps, &_lpDDSurfaceBack);

        if (depth == 8)
        {
            initPalette(_lpDDSurfaceFront);
        }
    }

    private void initWindowed(int width, int height, int depth)
    {
        log("DirectDrawDisplayDriver.initWindowed()");

        _lpDD._SetCooperativeLevel(_window.handle, DDSCL_NORMAL | DDSCL_NOWINDOWCHANGES);
        scope (failure) _lpDD.SetCooperativeLevel(null, DDSCL_NORMAL);

        DDSURFACEDESC2 ddsd;
        ddsd.dwSize = DDSURFACEDESC2.sizeof;
        ddsd.dwFlags = DDSD_CAPS;
        ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

        _lpDD._CreateSurface(&ddsd, &_lpDDSurfaceFront);
        _lpDD._CreateClipper(0, &_lpDDClipper);
        _lpDDClipper._SetHWnd(0, _window.handle);
        _lpDDSurfaceFront._SetClipper(_lpDDClipper);

        createOffscreenSurface(width, height, depth, &_lpDDSurfaceBack);

        if (depth == 8)
        {
            initPalette(_lpDDSurfaceBack);
        }
    }

    private void createOffscreenSurface(int width, int height, int depth, LPDIRECTDRAWSURFACE7* lplpDDSurface)
    {
        log("DirectDrawDisplayDriver.createOffscreenSurface()");

        DDSURFACEDESC2 ddsd;
        ddsd.dwSize = DDSURFACEDESC2.sizeof;
        ddsd.dwFlags = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT;
        ddsd.ddsCaps.dwCaps = DDSCAPS_OFFSCREENPLAIN;
        ddsd.dwWidth = width;
        ddsd.dwHeight = height;
        ddsd.ddpfPixelFormat.dwSize = DDPIXELFORMAT.sizeof;

        final switch (depth)
        {
            case 8:
            {
                ddsd.ddpfPixelFormat.dwFlags = DDPF_RGB | DDPF_PALETTEINDEXED8;
                ddsd.ddpfPixelFormat.dwRGBBitCount = 8;
                ddsd.ddpfPixelFormat.dwRBitMask = 0;
                ddsd.ddpfPixelFormat.dwGBitMask = 0;
                ddsd.ddpfPixelFormat.dwBBitMask = 0;
                break;
            }

            case 16:
            {
                ddsd.ddpfPixelFormat.dwFlags = DDPF_RGB;
                ddsd.ddpfPixelFormat.dwRGBBitCount = 16;
                ddsd.ddpfPixelFormat.dwRBitMask = 0b_11111000_00000000;
                ddsd.ddpfPixelFormat.dwGBitMask = 0b_00000111_11100000;
                ddsd.ddpfPixelFormat.dwBBitMask = 0b_00000000_00011111;
                break;
            }

            case 32:
            {
                ddsd.ddpfPixelFormat.dwFlags = DDPF_RGB;
                ddsd.ddpfPixelFormat.dwRGBBitCount = 32;
                ddsd.ddpfPixelFormat.dwRBitMask = 0b_11111111_00000000_00000000;
                ddsd.ddpfPixelFormat.dwGBitMask = 0b_00000000_11111111_00000000;
                ddsd.ddpfPixelFormat.dwBBitMask = 0b_00000000_00000000_11111111;
                break;
            }
        }

        _lpDD._CreateSurface(&ddsd, lplpDDSurface);
    }

    private void initPalette(LPDIRECTDRAWSURFACE7 lpDDSurface)
    {
        log("DirectDrawDisplayDriver.initPalette()");

        import durge.draw.color : Palette;

        _lpDD._CreatePalette(DDPCAPS_8BIT | DDPCAPS_ALLOW256, cast (LPPALETTEENTRY) Palette.identity.entries.ptr, &_lpDDPalette);
        lpDDSurface._SetPalette(_lpDDPalette);
    }
}
