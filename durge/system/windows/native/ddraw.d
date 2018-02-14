module durge.system.windows.native.ddraw;

version (Windows):

import durge.system.windows.native.common;
import durge.system.windows.native.gdi;
import durge.system.windows.native.windows;

enum // General
{
    DD_OK    = S_OK,
    DD_FALSE = S_FALSE,

    DD_ROP_SPACE = 256 / 32,
    MAX_DDDEVICEID_STRING = 512,

    _FACDD = 0x876,
}

enum // Error Codes
{
    DDERR_ALREADYINITIALIZED           = MAKE_DDHRESULT(5),
    DDERR_CANNOTATTACHSURFACE          = MAKE_DDHRESULT(10),
    DDERR_CANNOTDETACHSURFACE          = MAKE_DDHRESULT(20),
    DDERR_CURRENTLYNOTAVAIL            = MAKE_DDHRESULT(40),
    DDERR_EXCEPTION                    = MAKE_DDHRESULT(55),
    DDERR_GENERIC                      = E_FAIL,
    DDERR_HEIGHTALIGN                  = MAKE_DDHRESULT(90),
    DDERR_INCOMPATIBLEPRIMARY          = MAKE_DDHRESULT(95),
    DDERR_INVALIDCAPS                  = MAKE_DDHRESULT(100),
    DDERR_INVALIDCLIPLIST              = MAKE_DDHRESULT(110),
    DDERR_INVALIDMODE                  = MAKE_DDHRESULT(120),
    DDERR_INVALIDOBJECT                = MAKE_DDHRESULT(130),
    DDERR_INVALIDPARAMS                = E_INVALIDARG,
    DDERR_INVALIDPIXELFORMAT           = MAKE_DDHRESULT(145),
    DDERR_INVALIDRECT                  = MAKE_DDHRESULT(150),
    DDERR_LOCKEDSURFACES               = MAKE_DDHRESULT(160),
    DDERR_NO3D                         = MAKE_DDHRESULT(170),
    DDERR_NOALPHAHW                    = MAKE_DDHRESULT(180),
    DDERR_NOSTEREOHARDWARE             = MAKE_DDHRESULT(181),
    DDERR_NOSURFACELEFT                = MAKE_DDHRESULT(182),
    DDERR_NOCLIPLIST                   = MAKE_DDHRESULT(205),
    DDERR_NOCOLORCONVHW                = MAKE_DDHRESULT(210),
    DDERR_NOCOOPERATIVELEVELSET        = MAKE_DDHRESULT(212),
    DDERR_NOCOLORKEY                   = MAKE_DDHRESULT(215),
    DDERR_NOCOLORKEYHW                 = MAKE_DDHRESULT(220),
    DDERR_NODIRECTDRAWSUPPORT          = MAKE_DDHRESULT(222),
    DDERR_NOEXCLUSIVEMODE              = MAKE_DDHRESULT(225),
    DDERR_NOFLIPHW                     = MAKE_DDHRESULT(230),
    DDERR_NOGDI                        = MAKE_DDHRESULT(240),
    DDERR_NOMIRRORHW                   = MAKE_DDHRESULT(250),
    DDERR_NOTFOUND                     = MAKE_DDHRESULT(255),
    DDERR_NOOVERLAYHW                  = MAKE_DDHRESULT(260),
    DDERR_OVERLAPPINGRECTS             = MAKE_DDHRESULT(270),
    DDERR_NORASTEROPHW                 = MAKE_DDHRESULT(280),
    DDERR_NOROTATIONHW                 = MAKE_DDHRESULT(290),
    DDERR_NOSTRETCHHW                  = MAKE_DDHRESULT(310),
    DDERR_NOT4BITCOLOR                 = MAKE_DDHRESULT(316),
    DDERR_NOT4BITCOLORINDEX            = MAKE_DDHRESULT(317),
    DDERR_NOT8BITCOLOR                 = MAKE_DDHRESULT(320),
    DDERR_NOTEXTUREHW                  = MAKE_DDHRESULT(330),
    DDERR_NOVSYNCHW                    = MAKE_DDHRESULT(335),
    DDERR_NOZBUFFERHW                  = MAKE_DDHRESULT(340),
    DDERR_NOZOVERLAYHW                 = MAKE_DDHRESULT(350),
    DDERR_OUTOFCAPS                    = MAKE_DDHRESULT(360),
    DDERR_OUTOFMEMORY                  = E_OUTOFMEMORY,
    DDERR_OUTOFVIDEOMEMORY             = MAKE_DDHRESULT(380),
    DDERR_OVERLAYCANTCLIP              = MAKE_DDHRESULT(382),
    DDERR_OVERLAYCOLORKEYONLYONEACTIVE = MAKE_DDHRESULT(384),
    DDERR_PALETTEBUSY                  = MAKE_DDHRESULT(387),
    DDERR_COLORKEYNOTSET               = MAKE_DDHRESULT(400),
    DDERR_SURFACEALREADYATTACHED       = MAKE_DDHRESULT(410),
    DDERR_SURFACEALREADYDEPENDENT      = MAKE_DDHRESULT(420),
    DDERR_SURFACEBUSY                  = MAKE_DDHRESULT(430),
    DDERR_CANTLOCKSURFACE              = MAKE_DDHRESULT(435),
    DDERR_SURFACEISOBSCURED            = MAKE_DDHRESULT(440),
    DDERR_SURFACELOST                  = MAKE_DDHRESULT(450),
    DDERR_SURFACENOTATTACHED           = MAKE_DDHRESULT(460),
    DDERR_TOOBIGHEIGHT                 = MAKE_DDHRESULT(470),
    DDERR_TOOBIGSIZE                   = MAKE_DDHRESULT(480),
    DDERR_TOOBIGWIDTH                  = MAKE_DDHRESULT(490),
    DDERR_UNSUPPORTED                  = E_NOTIMPL,
    DDERR_UNSUPPORTEDFORMAT            = MAKE_DDHRESULT(510),
    DDERR_UNSUPPORTEDMASK              = MAKE_DDHRESULT(520),
    DDERR_INVALIDSTREAM                = MAKE_DDHRESULT(521),
    DDERR_VERTICALBLANKINPROGRESS      = MAKE_DDHRESULT(537),
    DDERR_WASSTILLDRAWING              = MAKE_DDHRESULT(540),
    DDERR_DDSCAPSCOMPLEXREQUIRED       = MAKE_DDHRESULT(542),
    DDERR_XALIGN                       = MAKE_DDHRESULT(560),
    DDERR_INVALIDDIRECTDRAWGUID        = MAKE_DDHRESULT(561),
    DDERR_DIRECTDRAWALREADYCREATED     = MAKE_DDHRESULT(562),
    DDERR_NODIRECTDRAWHW               = MAKE_DDHRESULT(563),
    DDERR_PRIMARYSURFACEALREADYEXISTS  = MAKE_DDHRESULT(564),
    DDERR_NOEMULATION                  = MAKE_DDHRESULT(565),
    DDERR_REGIONTOOSMALL               = MAKE_DDHRESULT(566),
    DDERR_CLIPPERISUSINGHWND           = MAKE_DDHRESULT(567),
    DDERR_NOCLIPPERATTACHED            = MAKE_DDHRESULT(568),
    DDERR_NOHWND                       = MAKE_DDHRESULT(569),
    DDERR_HWNDSUBCLASSED               = MAKE_DDHRESULT(570),
    DDERR_HWNDALREADYSET               = MAKE_DDHRESULT(571),
    DDERR_NOPALETTEATTACHED            = MAKE_DDHRESULT(572),
    DDERR_NOPALETTEHW                  = MAKE_DDHRESULT(573),
    DDERR_BLTFASTCANTCLIP              = MAKE_DDHRESULT(574),
    DDERR_NOBLTHW                      = MAKE_DDHRESULT(575),
    DDERR_NODDROPSHW                   = MAKE_DDHRESULT(576),
    DDERR_OVERLAYNOTVISIBLE            = MAKE_DDHRESULT(577),
    DDERR_NOOVERLAYDEST                = MAKE_DDHRESULT(578),
    DDERR_INVALIDPOSITION              = MAKE_DDHRESULT(579),
    DDERR_NOTAOVERLAYSURFACE           = MAKE_DDHRESULT(580),
    DDERR_EXCLUSIVEMODEALREADYSET      = MAKE_DDHRESULT(581),
    DDERR_NOTFLIPPABLE                 = MAKE_DDHRESULT(582),
    DDERR_CANTDUPLICATE                = MAKE_DDHRESULT(583),
    DDERR_NOTLOCKED                    = MAKE_DDHRESULT(584),
    DDERR_CANTCREATEDC                 = MAKE_DDHRESULT(585),
    DDERR_NODC                         = MAKE_DDHRESULT(586),
    DDERR_WRONGMODE                    = MAKE_DDHRESULT(587),
    DDERR_IMPLICITLYCREATED            = MAKE_DDHRESULT(588),
    DDERR_NOTPALETTIZED                = MAKE_DDHRESULT(589),
    DDERR_UNSUPPORTEDMODE              = MAKE_DDHRESULT(590),
    DDERR_NOMIPMAPHW                   = MAKE_DDHRESULT(591),
    DDERR_INVALIDSURFACETYPE           = MAKE_DDHRESULT(592),
    DDERR_NOOPTIMIZEHW                 = MAKE_DDHRESULT(600),
    DDERR_NOTLOADED                    = MAKE_DDHRESULT(601),
    DDERR_NOFOCUSWINDOW                = MAKE_DDHRESULT(602),
    DDERR_NOTONMIPMAPSUBLEVEL          = MAKE_DDHRESULT(603),
    DDERR_DCALREADYCREATED             = MAKE_DDHRESULT(620),
    DDERR_NONONLOCALVIDMEM             = MAKE_DDHRESULT(630),
    DDERR_CANTPAGELOCK                 = MAKE_DDHRESULT(640),
    DDERR_CANTPAGEUNLOCK               = MAKE_DDHRESULT(660),
    DDERR_NOTPAGELOCKED                = MAKE_DDHRESULT(680),
    DDERR_MOREDATA                     = MAKE_DDHRESULT(690),
    DDERR_EXPIRED                      = MAKE_DDHRESULT(691),
    DDERR_TESTFINISHED                 = MAKE_DDHRESULT(692),
    DDERR_NEWMODE                      = MAKE_DDHRESULT(693),
    DDERR_D3DNOTINITIALIZED            = MAKE_DDHRESULT(694),
    DDERR_VIDEONOTACTIVE               = MAKE_DDHRESULT(695),
    DDERR_NOMONITORINFORMATION         = MAKE_DDHRESULT(696),
    DDERR_NODRIVERSUPPORT              = MAKE_DDHRESULT(697),
    DDERR_DEVICEDOESNTOWNSURFACE       = MAKE_DDHRESULT(699),
    DDERR_NOTINITIALIZED               = CO_E_NOTINITIALIZED,
}

enum // Enumerate Display Modes
{
    DDEDM_REFRESHRATES     = 0x00000001,
    DDEDM_STANDARDVGAMODES = 0x00000002,
}

enum // Enumerate Surfaces
{
    DDENUMSURFACES_ALL          = 0x00000001,
    DDENUMSURFACES_MATCH        = 0x00000002,
    DDENUMSURFACES_NOMATCH      = 0x00000004,
    DDENUMSURFACES_CANBECREATED = 0x00000008,
    DDENUMSURFACES_DOESEXIST    = 0x00000010,
}

enum // Enum Callback Return Values
{
    DDENUMRET_CANCEL = 0,
    DDENUMRET_OK     = 1,
}

enum // Cooperative Level
{
    DDSCL_FULLSCREEN         = 0x00000001,
    DDSCL_ALLOWREBOOT        = 0x00000002,
    DDSCL_NOWINDOWCHANGES    = 0x00000004,
    DDSCL_NORMAL             = 0x00000008,
    DDSCL_EXCLUSIVE          = 0x00000010,
    DDSCL_ALLOWMODEX         = 0x00000040,
    DDSCL_SETFOCUSWINDOW     = 0x00000080,
    DDSCL_SETDEVICEWINDOW    = 0x00000100,
    DDSCL_CREATEDEVICEWINDOW = 0x00000200,
    DDSCL_MULTITHREADED      = 0x00000400,
    DDSCL_FPUSETUP           = 0x00000800,
    DDSCL_FPUPRESERVE        = 0x00001000,
}

enum // Set Display Mode Flags
{
    DDSDM_STANDARDVGAMODE = 0x00000001,
}

enum // Surface Desc Flags
{
    DDSD_CAPS            = 0x00000001,
    DDSD_HEIGHT          = 0x00000002,
    DDSD_WIDTH           = 0x00000004,
    DDSD_PITCH           = 0x00000008,
    DDSD_BACKBUFFERCOUNT = 0x00000020,
    DDSD_ZBUFFERBITDEPTH = 0x00000040,
    DDSD_ALPHABITDEPTH   = 0x00000080,
    DDSD_LPSURFACE       = 0x00000800,
    DDSD_PIXELFORMAT     = 0x00001000,
    DDSD_CKDESTOVERLAY   = 0x00002000,
    DDSD_CKDESTBLT       = 0x00004000,
    DDSD_CKSRCOVERLAY    = 0x00008000,
    DDSD_CKSRCBLT        = 0x00010000,
    DDSD_MIPMAPCOUNT     = 0x00020000,
    DDSD_REFRESHRATE     = 0x00040000,
    DDSD_LINEARSIZE      = 0x00080000,
    DDSD_TEXTURESTAGE    = 0x00100000,
    DDSD_FVF             = 0x00200000,
    DDSD_SRCVBHANDLE     = 0x00400000,
    DDSD_DEPTH           = 0x00800000,
    DDSD_ALL             = 0x00fff9ee,
}

enum // Surface Caps
{
    DDSCAPS_ALPHA           = 0x00000002,
    DDSCAPS_BACKBUFFER      = 0x00000004,
    DDSCAPS_COMPLEX         = 0x00000008,
    DDSCAPS_FLIP            = 0x00000010,
    DDSCAPS_FRONTBUFFER     = 0x00000020,
    DDSCAPS_OFFSCREENPLAIN  = 0x00000040,
    DDSCAPS_OVERLAY         = 0x00000080,
    DDSCAPS_PALETTE         = 0x00000100,
    DDSCAPS_PRIMARYSURFACE  = 0x00000200,
    DDSCAPS_SYSTEMMEMORY    = 0x00000800,
    DDSCAPS_TEXTURE         = 0x00001000,
    DDSCAPS_3DDEVICE        = 0x00002000,
    DDSCAPS_VIDEOMEMORY     = 0x00004000,
    DDSCAPS_VISIBLE         = 0x00008000,
    DDSCAPS_WRITEONLY       = 0x00010000,
    DDSCAPS_ZBUFFER         = 0x00020000,
    DDSCAPS_OWNDC           = 0x00040000,
    DDSCAPS_LIVEVIDEO       = 0x00080000,
    DDSCAPS_HWCODEC         = 0x00100000,
    DDSCAPS_MODEX           = 0x00200000,
    DDSCAPS_MIPMAP          = 0x00400000,
    DDSCAPS_ALLOCONLOAD     = 0x04000000,
    DDSCAPS_VIDEOPORT       = 0x08000000,
    DDSCAPS_LOCALVIDMEM     = 0x10000000,
    DDSCAPS_NONLOCALVIDMEM  = 0x20000000,
    DDSCAPS_STANDARDVGAMODE = 0x40000000,
    DDSCAPS_OPTIMIZED       = 0x80000000,
}

enum // Pixel Format
{
    DDPF_ALPHAPIXELS       = 0x00000001,
    DDPF_ALPHA             = 0x00000002,
    DDPF_FOURCC            = 0x00000004,
    DDPF_PALETTEINDEXED4   = 0x00000008,
    DDPF_PALETTEINDEXEDTO8 = 0x00000010,
    DDPF_PALETTEINDEXED8   = 0x00000020,
    DDPF_RGB               = 0x00000040,
    DDPF_COMPRESSED        = 0x00000080,
    DDPF_RGBTOYUV          = 0x00000100,
    DDPF_YUV               = 0x00000200,
    DDPF_ZBUFFER           = 0x00000400,
    DDPF_PALETTEINDEXED1   = 0x00000800,
    DDPF_PALETTEINDEXED2   = 0x00001000,
    DDPF_ZPIXELS           = 0x00002000,
    DDPF_STENCILBUFFER     = 0x00004000,
    DDPF_ALPHAPREMULT      = 0x00008000,
    DDPF_LUMINANCE         = 0x00020000,
    DDPF_BUMPLUMINANCE     = 0x00040000,
    DDPF_BUMPDUDV          = 0x00080000,
}

enum // Lock Surface Flags
{
    DDLOCK_SURFACEMEMORYPTR        = 0x00000000,
    DDLOCK_WAIT                    = 0x00000001,
    DDLOCK_EVENT                   = 0x00000002,
    DDLOCK_READONLY                = 0x00000010,
    DDLOCK_WRITEONLY               = 0x00000020,
    DDLOCK_NOSYSLOCK               = 0x00000800,
    DDLOCK_NOOVERWRITE             = 0x00001000,
    DDLOCK_DISCARDCONTENTS         = 0x00002000,
    DDLOCK_OKTOSWAP                = 0x00002000,
    DDLOCK_DONOTWAIT               = 0x00004000,
    DDLOCK_HASVOLUMETEXTUREBOXRECT = 0x00008000,
    DDLOCK_NODIRTYUPDATE           = 0x00010000,
}

enum // Blit Surface Flags
{
    DDBLT_ALPHADEST                = 0x00000001,
    DDBLT_ALPHADESTCONSTOVERRIDE   = 0x00000002,
    DDBLT_ALPHADESTNEG             = 0x00000004,
    DDBLT_ALPHADESTSURFACEOVERRIDE = 0x00000008,
    DDBLT_ALPHAEDGEBLEND           = 0x00000010,
    DDBLT_ALPHASRC                 = 0x00000020,
    DDBLT_ALPHASRCCONSTOVERRIDE    = 0x00000040,
    DDBLT_ALPHASRCNEG              = 0x00000080,
    DDBLT_ALPHASRCSURFACEOVERRIDE  = 0x00000100,
    DDBLT_ASYNC                    = 0x00000200,
    DDBLT_COLORFILL                = 0x00000400,
    DDBLT_DDFX                     = 0x00000800,
    DDBLT_DDROPS                   = 0x00001000,
    DDBLT_KEYDEST                  = 0x00002000,
    DDBLT_KEYDESTOVERRIDE          = 0x00004000,
    DDBLT_KEYSRC                   = 0x00008000,
    DDBLT_KEYSRCOVERRIDE           = 0x00010000,
    DDBLT_ROP                      = 0x00020000,
    DDBLT_ROTATIONANGLE            = 0x00040000,
    DDBLT_ZBUFFER                  = 0x00080000,
    DDBLT_ZBUFFERDESTCONSTOVERRIDE = 0x00100000,
    DDBLT_ZBUFFERDESTOVERRIDE      = 0x00200000,
    DDBLT_ZBUFFERSRCCONSTOVERRIDE  = 0x00400000,
    DDBLT_ZBUFFERSRCOVERRIDE       = 0x00800000,
    DDBLT_WAIT                     = 0x01000000,
    DDBLT_DEPTHFILL                = 0x02000000,
    DDBLT_DONOTWAIT                = 0x08000000,
    DDBLT_PRESENTATION             = 0x10000000,
    DDBLT_LAST_PRESENTATION        = 0x20000000,
    DDBLT_EXTENDED_FLAGS           = 0x40000000,
    DDBLT_EXTENDED_LINEAR_CONTENT  = 0x00000004,
}

enum // Flip Surface Flags
{
    DDFLIP_WAIT      = 0x00000001,
    DDFLIP_EVEN      = 0x00000002,
    DDFLIP_ODD       = 0x00000004,
    DDFLIP_NOVSYNC   = 0x00000008,
    DDFLIP_INTERVAL2 = 0x02000000,
    DDFLIP_INTERVAL3 = 0x03000000,
    DDFLIP_INTERVAL4 = 0x04000000,
    DDFLIP_STEREO    = 0x00000010,
    DDFLIP_DONOTWAIT = 0x00000020,
}

enum // Palette Caps
{
    DDPCAPS_4BIT               = 0x00000001,
    DDPCAPS_8BITENTRIES        = 0x00000002,
    DDPCAPS_8BIT               = 0x00000004,
    DDPCAPS_INITIALIZE         = 0x00000000,
    DDPCAPS_PRIMARYSURFACE     = 0x00000010,
    DDPCAPS_PRIMARYSURFACELEFT = 0x00000020,
    DDPCAPS_ALLOW256           = 0x00000040,
    DDPCAPS_VSYNC              = 0x00000080,
    DDPCAPS_1BIT               = 0x00000100,
    DDPCAPS_2BIT               = 0x00000200,
    DDPCAPS_ALPHA              = 0x00000400,
}

struct DDCAPS
{
    DWORD    dwSize;
    DWORD    dwCaps;
    DWORD    dwCaps2;
    DWORD    dwCKeyCaps;
    DWORD    dwFXCaps;
    DWORD    dwFXAlphaCaps;
    DWORD    dwPalCaps;
    DWORD    dwSVCaps;
    DWORD    dwAlphaBltConstBitDepths;
    DWORD    dwAlphaBltPixelBitDepths;
    DWORD    dwAlphaBltSurfaceBitDepths;
    DWORD    dwAlphaOverlayConstBitDepths;
    DWORD    dwAlphaOverlayPixelBitDepths;
    DWORD    dwAlphaOverlaySurfaceBitDepths;
    DWORD    dwZBufferBitDepths;
    DWORD    dwVidMemTotal;
    DWORD    dwVidMemFree;
    DWORD    dwMaxVisibleOverlays;
    DWORD    dwCurrVisibleOverlays;
    DWORD    dwNumFourCCCodes;
    DWORD    dwAlignBoundarySrc;
    DWORD    dwAlignSizeSrc;
    DWORD    dwAlignBoundaryDest;
    DWORD    dwAlignSizeDest;
    DWORD    dwAlignStrideAlign;
    DWORD[DD_ROP_SPACE] dwRops;
    DDSCAPS  ddsOldCaps;
    DWORD    dwMinOverlayStretch;
    DWORD    dwMaxOverlayStretch;
    DWORD    dwMinLiveVideoStretch;
    DWORD    dwMaxLiveVideoStretch;
    DWORD    dwMinHwCodecStretch;
    DWORD    dwMaxHwCodecStretch;
    DWORD    dwReserved1;
    DWORD    dwReserved2;
    DWORD    dwReserved3;
    DWORD    dwSVBCaps;
    DWORD    dwSVBCKeyCaps;
    DWORD    dwSVBFXCaps;
    DWORD[DD_ROP_SPACE] dwSVBRops;
    DWORD    dwVSBCaps;
    DWORD    dwVSBCKeyCaps;
    DWORD    dwVSBFXCaps;
    DWORD[DD_ROP_SPACE] dwVSBRops;
    DWORD    dwSSBCaps;
    DWORD    dwSSBCKeyCaps;
    DWORD    dwSSBFXCaps;
    DWORD[DD_ROP_SPACE] dwSSBRops;
    DWORD    dwMaxVideoPorts;
    DWORD    dwCurrVideoPorts;
    DWORD    dwSVBCaps2;
    DWORD    dwNLVBCaps;
    DWORD    dwNLVBCaps2;
    DWORD    dwNLVBCKeyCaps;
    DWORD    dwNLVBFXCaps;
    DWORD[DD_ROP_SPACE] dwNLVBRops;
    DDSCAPS2 ddsCaps;
}

struct DDDEVICEIDENTIFIER2
{
    CHAR[MAX_DDDEVICEID_STRING] szDriver;
    CHAR[MAX_DDDEVICEID_STRING] szDescription;
    LARGE_INTEGER liDriverVersion;
    DWORD         dwVendorId;
    DWORD         dwDeviceId;
    DWORD         dwSubSysId;
    DWORD         dwRevision;
    GUID          guidDeviceIdentifier;
    DWORD         dwWHQLLevel;
}

struct DDSURFACEDESC
{
    DWORD dwSize;
    DWORD dwFlags;
    DWORD dwHeight;
    DWORD dwWidth;
    union
    {
        LONG  lPitch;
        DWORD dwLinearSize;
    }
    DWORD dwBackBufferCount;
    union
    {
        DWORD dwMipMapCount;
        DWORD dwZBufferBitDepth;
        DWORD dwRefreshRate;
    }
    DWORD         dwAlphaBitDepth;
    DWORD         dwReserved;
    LPVOID        lpSurface;
    DDCOLORKEY    ddckCKDestOverlay;
    DDCOLORKEY    ddckCKDestBlt;
    DDCOLORKEY    ddckCKSrcOverlay;
    DDCOLORKEY    ddckCKSrcBlt;
    DDPIXELFORMAT ddpfPixelFormat;
    DDSCAPS       ddsCaps;
}

struct DDSURFACEDESC2
{
    DWORD dwSize;
    DWORD dwFlags;
    DWORD dwHeight;
    DWORD dwWidth;
    union
    {
        LONG  lPitch;
        DWORD dwLinearSize;
    }
    union
    {
        DWORD dwBackBufferCount;
        DWORD dwDepth;
    }
    union
    {
        DWORD dwMipMapCount;
        DWORD dwRefreshRate;
        DWORD dwSrcVBHandle;
    }
    DWORD  dwAlphaBitDepth;
    DWORD  dwReserved;
    LPVOID lpSurface;
    union
    {
        DDCOLORKEY ddckCKDestOverlay;
        DWORD      dwEmptyFaceColor;
    }
    DDCOLORKEY ddckCKDestBlt;
    DDCOLORKEY ddckCKSrcOverlay;
    DDCOLORKEY ddckCKSrcBlt;
    union
    {
        DDPIXELFORMAT ddpfPixelFormat;
        DWORD         dwFVF;
    }
    DDSCAPS2 ddsCaps;
    DWORD    dwTextureStage;
}

struct DDSCAPS
{
    DWORD dwCaps;
}

struct DDSCAPS2
{
    DWORD dwCaps;
    DWORD dwCaps2;
    DWORD dwCaps3;
    union
    {
        DWORD dwCaps4;
        DWORD dwVolumeDepth;
    }
}

struct DDPIXELFORMAT
{
    DWORD dwSize;
    DWORD dwFlags;
    DWORD dwFourCC;
    union
    {
        DWORD dwRGBBitCount;
        DWORD dwYUVBitCount;
        DWORD dwZBufferBitDepth;
        DWORD dwAlphaBitDepth;
        DWORD dwLuminanceBitCount;
        DWORD dwBumpBitCount;
        DWORD dwPrivateFormatBitCount;
    }
    union
    {
        DWORD dwRBitMask;
        DWORD dwYBitMask;
        DWORD dwStencilBitDepth;
        DWORD dwLuminanceBitMask;
        DWORD dwBumpDuBitMask;
        DWORD dwOperations;
    }
    union
    {
        DWORD dwGBitMask;
        DWORD dwUBitMask;
        DWORD dwZBitMask;
        DWORD dwBumpDvBitMask;
        struct _MultiSampleCaps
        {
            WORD wFlipMSTypes;
            WORD wBltMSTypes;
        }
        _MultiSampleCaps MultiSampleCaps;
    }
    union
    {
        DWORD dwBBitMask;
        DWORD dwVBitMask;
        DWORD dwStencilBitMask;
        DWORD dwBumpLuminanceBitMask;
    }
    union
    {
        DWORD dwRGBAlphaBitMask;
        DWORD dwYUVAlphaBitMask;
        DWORD dwLuminanceAlphaBitMask;
        DWORD dwRGBZBitMask;
        DWORD dwYUVZBitMask;
    }
}

struct DDBLTFX
{
    DWORD dwSize;
    DWORD dwDDFX;
    DWORD dwROP;
    DWORD dwDDROP;
    DWORD dwRotationAngle;
    DWORD dwZBufferOpCode;
    DWORD dwZBufferLow;
    DWORD dwZBufferHigh;
    DWORD dwZBufferBaseDest;
    DWORD dwZDestConstBitDepth;
    union
    {
        DWORD               dwZDestConst;
        LPDIRECTDRAWSURFACE lpDDSZBufferDest;
    }
    DWORD dwZSrcConstBitDepth;
    union
    {
        DWORD               dwZSrcConst;
        LPDIRECTDRAWSURFACE lpDDSZBufferSrc;
    }
    DWORD dwAlphaEdgeBlendBitDepth;
    DWORD dwAlphaEdgeBlend;
    DWORD dwReserved;
    DWORD dwAlphaDestConstBitDepth;
    union
    {
        DWORD               dwAlphaDestConst;
        LPDIRECTDRAWSURFACE lpDDSAlphaDest;
    }
    DWORD dwAlphaSrcConstBitDepth;
    union
    {
        DWORD               dwAlphaSrcConst;
        LPDIRECTDRAWSURFACE lpDDSAlphaSrc;
    }
    union
    {
        DWORD               dwFillColor;
        DWORD               dwFillDepth;
        DWORD               dwFillPixel;
        LPDIRECTDRAWSURFACE lpDDSPattern;
    }
    DDCOLORKEY ddckDestColorkey;
    DDCOLORKEY ddckSrcColorkey;
}

struct DDBLTBATCH
{
    LPRECT              lprDest;
    LPDIRECTDRAWSURFACE lpDDSSrc;
    LPRECT              lprSrc;
    DWORD               dwFlags;
    LPDDBLTFX           lpDDBltFx;
}

struct DDCOLORKEY
{
    DWORD dwColorSpaceLowValue;
    DWORD dwColorSpaceHighValue;
}

struct DDOVERLAYFX
{
    DWORD dwSize;
    DWORD dwAlphaEdgeBlendBitDepth;
    DWORD dwAlphaEdgeBlend;
    DWORD dwReserved;
    DWORD dwAlphaDestConstBitDepth;
    union
    {
        DWORD               dwAlphaDestConst;
        LPDIRECTDRAWSURFACE lpDDSAlphaDest;
    }
    DWORD dwAlphaSrcConstBitDepth;
    union
    {
        DWORD               dwAlphaSrcConst;
        LPDIRECTDRAWSURFACE lpDDSAlphaSrc;
    }
    DDCOLORKEY dckDestColorkey;
    DDCOLORKEY dckSrcColorkey;
    DWORD      dwDDFX;
    DWORD      dwFlags;
}

alias DDCAPS*              LPDDCAPS;
alias DDDEVICEIDENTIFIER2* LPDDDEVICEIDENTIFIER2;
alias DDSURFACEDESC*       LPDDSURFACEDESC;
alias DDSURFACEDESC2*      LPDDSURFACEDESC2;
alias DDSCAPS*             LPDDSCAPS;
alias DDSCAPS2*            LPDDSCAPS2;
alias DDPIXELFORMAT*       LPDDPIXELFORMAT;
alias DDBLTFX*             LPDDBLTFX;
alias DDBLTBATCH*          LPDDBLTBATCH;
alias DDCOLORKEY*          LPDDCOLORKEY;
alias DDOVERLAYFX*         LPDDOVERLAYFX;

GUID IID_IDirectDraw         = GUID(0x6C14DB80, 0xA733, 0x11CE, [0xA5, 0x21, 0x00, 0x20, 0xAF, 0x0B, 0xE5, 0x60]);
GUID IID_IDirectDraw7        = GUID(0x15e65ec0, 0x3b9c, 0x11d2, [0xb9, 0x2f, 0x00, 0x60, 0x97, 0x97, 0xea, 0x5b]);
GUID IID_IDirectDrawSurface  = GUID(0x6C14DB81, 0xA733, 0x11CE, [0xA5, 0x21, 0x00, 0x20, 0xAF, 0x0B, 0xE5, 0x60]);
GUID IID_IDirectDrawSurface7 = GUID(0x06675a80, 0x3b9b, 0x11d2, [0xb9, 0x2f, 0x00, 0x60, 0x97, 0x97, 0xea, 0x5b]);
GUID IID_IDirectDrawPalette  = GUID(0x6C14DB84, 0xA733, 0x11CE, [0xA5, 0x21, 0x00, 0x20, 0xAF, 0x0B, 0xE5, 0x60]);
GUID IID_IDirectDrawClipper  = GUID(0x6C14DB85, 0xA733, 0x11CE, [0xA5, 0x21, 0x00, 0x20, 0xAF, 0x0B, 0xE5, 0x60]);

interface IDirectDraw : IUnknown
{

}

interface IDirectDraw7 : IUnknown
{
    extern (Windows):
    nothrow:
    @nogc:

    HRESULT Compact();
    HRESULT CreateClipper(DWORD dwFlags, LPDIRECTDRAWCLIPPER* lplpDDClipper, LPUNKNOWN pUnkOuter);
    HRESULT CreatePalette(DWORD dwFlags, LPPALETTEENTRY lpDDColorArray, LPDIRECTDRAWPALETTE* lplpDDPalette, LPUNKNOWN pUnkOuter);
    HRESULT CreateSurface(LPDDSURFACEDESC2 lpDDSurfaceDesc2, LPDIRECTDRAWSURFACE7* lplpDDSurface, LPUNKNOWN pUnkOuter);
    HRESULT DuplicateSurface(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAWSURFACE7* lplpDupDDSurface);
    HRESULT EnumDisplayModes(DWORD dwFlags, LPDDSURFACEDESC2 lpDDSurfaceDesc2, LPVOID lpContext, LPDDENUMMODESCALLBACK2 lpEnumModesCallback);
    HRESULT EnumSurfaces(DWORD dwFlags, LPDDSURFACEDESC2 lpDDSD2, LPVOID lpContext, LPDDENUMSURFACESCALLBACK7 lpEnumSurfacesCallback);
    HRESULT FlipToGDISurface();
    HRESULT GetCaps(LPDDCAPS lpDDDriverCaps, LPDDCAPS lpDDHELCaps);
    HRESULT GetDisplayMode(LPDDSURFACEDESC2 lpDDSurfaceDesc2);
    HRESULT GetFourCCCodes(LPDWORD lpNumCodes, LPDWORD lpCodes);
    HRESULT GetGDISurface(LPDIRECTDRAWSURFACE7* lplpGDIDDSSurface);
    HRESULT GetMonitorFrequency(LPDWORD lpdwFrequency);
    HRESULT GetScanLine(LPDWORD lpdwScanLine);
    HRESULT GetVerticalBlankStatus(LPBOOL lpbIsInVB);
    HRESULT Initialize(LPGUID lpGUID);
    HRESULT RestoreDisplayMode();
    HRESULT SetCooperativeLevel(HWND hWnd, DWORD dwFlags);
    HRESULT SetDisplayMode(DWORD dwWidth, DWORD dwHeight, DWORD dwBPP, DWORD dwRefreshRate, DWORD dwFlags);
    HRESULT WaitForVerticalBlank(DWORD dwFlags, HANDLE hEvent);
    HRESULT GetAvailableVidMem(LPDDSCAPS2 lpDDSCaps2, LPDWORD lpdwTotal, LPDWORD lpdwFree);
    HRESULT GetSurfaceFromDC(HDC hdc, LPDIRECTDRAWSURFACE7* lpDDS);
    HRESULT RestoreAllSurfaces();
    HRESULT TestCooperativeLevel();
    HRESULT GetDeviceIdentifier(LPDDDEVICEIDENTIFIER2 lpdddi, DWORD dwFlags);
    HRESULT StartModeTest(LPSIZE lpModesToTest, DWORD dwNumEntries, DWORD dwFlags);
    HRESULT EvaluateMode(DWORD dwFlags, LPDWORD pSecondsUntilTimeout);
}

interface IDirectDrawClipper : IUnknown
{
    extern (Windows):
    nothrow:
    @nogc:

    HRESULT GetClipList(LPRECT lpRect, LPRGNDATA lpClipList, LPDWORD lpdwSize);
    HRESULT GetHWnd(HWND* lphWnd);
    HRESULT Initialize(LPDIRECTDRAW lpDD, DWORD dwFlags);
    HRESULT IsClipListChanged(LPBOOL lpbChanged);
    HRESULT SetClipList(LPRGNDATA lpClipList, DWORD dwFlags);
    HRESULT SetHWnd(DWORD dwFlags, HWND hWnd);
}

interface IDirectDrawPalette : IUnknown
{
    extern (Windows):
    nothrow:
    @nogc:

    HRESULT GetCaps(LPDWORD lpdwCaps);
    HRESULT GetEntries(DWORD dwFlags, DWORD dwBase, DWORD dwNumEntries, LPPALETTEENTRY lpEntries);
    HRESULT Initialize(LPDIRECTDRAW lpDD, DWORD dwFlags, LPPALETTEENTRY lpDDColorTable);
    HRESULT SetEntries(DWORD dwFlags, DWORD dwStartingEntry, DWORD dwCount, LPPALETTEENTRY lpEntries);
}

interface IDirectDrawSurface : IUnknown
{

}

interface IDirectDrawSurface7 : IUnknown
{
    extern (Windows):
    nothrow:
    @nogc:

    HRESULT AddAttachedSurface(LPDIRECTDRAWSURFACE7 lpDDSurface);
    HRESULT AddOverlayDirtyRect(LPRECT lpRect);
    HRESULT Blt(LPRECT lpDestRect, LPDIRECTDRAWSURFACE7 lpDDSrcSurface, LPRECT lpSrcRect, DWORD dwFlags, LPDDBLTFX lpDDBltFx);
    HRESULT BltBatch(LPDDBLTBATCH lpDDBltBatch, DWORD dwCount, DWORD dwFlags);
    HRESULT BltFast(DWORD dwX, DWORD dwY, LPDIRECTDRAWSURFACE7 lpDDSrcSurface, LPRECT lpSrcRect, DWORD dwFlags); // LPDDBLTFX lpDDBltFx
    HRESULT DeleteAttachedSurface(DWORD dwFlags, LPDIRECTDRAWSURFACE7 lpDDSAttachedSurface);
    HRESULT EnumAttachedSurfaces(LPVOID lpContext, LPDDENUMSURFACESCALLBACK7 lpEnumSurfacesCallback);
    HRESULT EnumOverlayZOrders(DWORD dwFlags, LPVOID lpContext, LPDDENUMSURFACESCALLBACK7 lpfnCallback);
    HRESULT Flip(LPDIRECTDRAWSURFACE7 lpDDSurfaceTargetOverride, DWORD dwFlags);
    HRESULT GetAttachedSurface(LPDDSCAPS2 lpDDSCaps, LPDIRECTDRAWSURFACE7* lplpDDAttachedSurface);
    HRESULT GetBltStatus(DWORD dwFlags);
    HRESULT GetCaps(LPDDSCAPS2 lpDDSCaps);
    HRESULT GetClipper(LPDIRECTDRAWCLIPPER* lplpDDClipper);
    HRESULT GetColorKey(DWORD dwFlags, LPDDCOLORKEY lpDDColorKey);
    HRESULT GetDC(HDC* lphDC);
    HRESULT GetFlipStatus(DWORD dwFlags);
    HRESULT GetOverlayPosition(LPLONG lplX, LPLONG lplY);
    HRESULT GetPalette(LPDIRECTDRAWPALETTE* lplpDDPalette);
    HRESULT GetPixelFormat(LPDDPIXELFORMAT lpDDPixelFormat);
    HRESULT GetSurfaceDesc(LPDDSURFACEDESC2 lpDDSurfaceDesc);
    HRESULT Initialize(LPDIRECTDRAW lpDD, LPDDSURFACEDESC2 lpDDSurfaceDesc);
    HRESULT IsLost();
    HRESULT Lock(LPRECT lpDestRect, LPDDSURFACEDESC2 lpDDSurfaceDesc, DWORD dwFlags, HANDLE hEvent);
    HRESULT ReleaseDC(HDC hDC);
    HRESULT Restore();
    HRESULT SetClipper(LPDIRECTDRAWCLIPPER lpDDClipper);
    HRESULT SetColorKey(DWORD dwFlags, LPDDCOLORKEY lpDDColorKey);
    HRESULT SetOverlayPosition(LONG lX, LONG lY);
    HRESULT SetPalette(LPDIRECTDRAWPALETTE lpDDPalette);
    HRESULT Unlock(LPRECT lpRect);
    HRESULT UpdateOverlay(LPRECT lpSrcRect, LPDIRECTDRAWSURFACE7 lpDDDestSurface, LPRECT lpDestRect, DWORD dwFlags, LPDDOVERLAYFX lpDDOverlayFx);
    HRESULT UpdateOverlayDisplay(DWORD dwFlags);
    HRESULT UpdateOverlayZOrder(DWORD dwFlags, LPDIRECTDRAWSURFACE7 lpDDSReference);
    HRESULT GetDDInterface(LPVOID* lplpDD);
    HRESULT PageLock(DWORD dwFlags);
    HRESULT PageUnlock(DWORD dwFlags);
    HRESULT SetSurfaceDesc(LPDDSURFACEDESC2 lpDDsd2, DWORD dwFlags);
    HRESULT SetPrivateData(REFGUID guidTag, LPVOID lpData, DWORD cbSize, DWORD dwFlags);
    HRESULT GetPrivateData(REFGUID guidTag, LPVOID lpBuffer, LPDWORD lpcbBufferSize);
    HRESULT FreePrivateData(REFGUID guidTag);
    HRESULT GetUniquenessValue(LPDWORD lpValue);
    HRESULT ChangeUniquenessValue();
    HRESULT SetPriority(DWORD dwPriority);
    HRESULT GetPriority(LPDWORD lpdwPriority);
    HRESULT SetLOD(DWORD dwMaxLOD);
    HRESULT GetLOD(LPDWORD lpdwMaxLOD);
}

alias IDirectDraw         LPDIRECTDRAW;
alias IDirectDraw7        LPDIRECTDRAW7;
alias IDirectDrawClipper  LPDIRECTDRAWCLIPPER;
alias IDirectDrawPalette  LPDIRECTDRAWPALETTE;
alias IDirectDrawSurface  LPDIRECTDRAWSURFACE;
alias IDirectDrawSurface7 LPDIRECTDRAWSURFACE7;

extern (Windows)
{
    alias BOOL function(LPGUID lpGUID, LPWSTR lpDriverDescription, LPWSTR lpDriverName, LPVOID lpContext) LPDDENUMCALLBACK;
    alias BOOL function(LPGUID lpGUID, LPWSTR lpDriverDescription, LPWSTR lpDriverName, LPVOID lpContext, HMONITOR hm) LPDDENUMCALLBACKEX;
    alias HRESULT function(LPDDSURFACEDESC lpDDSurfaceDesc, LPVOID lpContext) LPDDENUMMODESCALLBACK;
    alias HRESULT function(LPDDSURFACEDESC2 lpDDSurfaceDesc, LPVOID lpContext) LPDDENUMMODESCALLBACK2;
    alias HRESULT function(LPDIRECTDRAWSURFACE lpDDSurface, LPDDSURFACEDESC lpDDSurfaceDesc, LPVOID lpContext) LPDDENUMSURFACESCALLBACK;
    alias HRESULT function(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDDSURFACEDESC2 lpDDSurfaceDesc, LPVOID lpContext) LPDDENUMSURFACESCALLBACK7;

    nothrow:
    @nogc:

    HRESULT DirectDrawCreate(LPGUID lpGUID, LPDIRECTDRAW* lplpDD, LPUNKNOWN pUnkOuter);
    HRESULT DirectDrawCreateClipper(DWORD dwFlags, LPDIRECTDRAWCLIPPER* lplpDDClipper, LPUNKNOWN pUnkOuter);
    HRESULT DirectDrawCreateEx(LPGUID lpGUID, LPVOID* lplpDD, REFIID iid, LPUNKNOWN pUnkOuter);
    HRESULT DirectDrawEnumerateW(LPDDENUMCALLBACK lpCallback, LPVOID lpContext);
    HRESULT DirectDrawEnumerateExW(LPDDENUMCALLBACKEX lpCallback, LPVOID lpContext, DWORD dwFlags);
}

alias DirectDrawEnumerateW DirectDrawEnumerate;
alias DirectDrawEnumerateExW DirectDrawEnumerateEx;

HRESULT MAKE_DDHRESULT(ULONG code)
{
    return MAKE_HRESULT(1, _FACDD, code);
}

class DirectDrawException : WindowsException
{
	this(HRESULT errorCode)
	{
        super(errorCode, getErrorMessage(errorCode));
	}

    private string getErrorMessage(HRESULT errorCode)
    {
        import std.format : format;

        auto symbol = getDirectDrawErrorSymbol(errorCode);
        auto message = getDirectDrawErrorMessage(errorCode);

        return message !is null
            ? "%s(0x%08X): %s".format(symbol, errorCode, message)
            : "Unknown error";
    }
}

private string getDirectDrawErrorSymbol(HRESULT errorCode)
{
    string symbol;

    switch (errorCode)
    {
        case DDERR_ALREADYINITIALIZED:           symbol = "DDERR_ALREADYINITIALIZED"; break;
        case DDERR_CANNOTATTACHSURFACE:          symbol = "DDERR_CANNOTATTACHSURFACE"; break;
        case DDERR_CANNOTDETACHSURFACE:          symbol = "DDERR_CANNOTDETACHSURFACE"; break;
        case DDERR_CURRENTLYNOTAVAIL:            symbol = "DDERR_CURRENTLYNOTAVAIL"; break;
        case DDERR_EXCEPTION:                    symbol = "DDERR_EXCEPTION"; break;
        case DDERR_GENERIC:                      symbol = "DDERR_GENERIC"; break;
        case DDERR_HEIGHTALIGN:                  symbol = "DDERR_HEIGHTALIGN"; break;
        case DDERR_INCOMPATIBLEPRIMARY:          symbol = "DDERR_INCOMPATIBLEPRIMARY"; break;
        case DDERR_INVALIDCAPS:                  symbol = "DDERR_INVALIDCAPS"; break;
        case DDERR_INVALIDCLIPLIST:              symbol = "DDERR_INVALIDCLIPLIST"; break;
        case DDERR_INVALIDMODE:                  symbol = "DDERR_INVALIDMODE"; break;
        case DDERR_INVALIDOBJECT:                symbol = "DDERR_INVALIDOBJECT"; break;
        case DDERR_INVALIDPARAMS:                symbol = "DDERR_INVALIDPARAMS"; break;
        case DDERR_INVALIDPIXELFORMAT:           symbol = "DDERR_INVALIDPIXELFORMAT"; break;
        case DDERR_INVALIDRECT:                  symbol = "DDERR_INVALIDRECT"; break;
        case DDERR_LOCKEDSURFACES:               symbol = "DDERR_LOCKEDSURFACES"; break;
        case DDERR_NO3D:                         symbol = "DDERR_NO3D"; break;
        case DDERR_NOALPHAHW:                    symbol = "DDERR_NOALPHAHW"; break;
        case DDERR_NOSTEREOHARDWARE:             symbol = "DDERR_NOSTEREOHARDWARE"; break;
        case DDERR_NOSURFACELEFT:                symbol = "DDERR_NOSURFACELEFT"; break;
        case DDERR_NOCLIPLIST:                   symbol = "DDERR_NOCLIPLIST"; break;
        case DDERR_NOCOLORCONVHW:                symbol = "DDERR_NOCOLORCONVHW"; break;
        case DDERR_NOCOOPERATIVELEVELSET:        symbol = "DDERR_NOCOOPERATIVELEVELSET"; break;
        case DDERR_NOCOLORKEY:                   symbol = "DDERR_NOCOLORKEY"; break;
        case DDERR_NOCOLORKEYHW:                 symbol = "DDERR_NOCOLORKEYHW"; break;
        case DDERR_NODIRECTDRAWSUPPORT:          symbol = "DDERR_NODIRECTDRAWSUPPORT"; break;
        case DDERR_NOEXCLUSIVEMODE:              symbol = "DDERR_NOEXCLUSIVEMODE"; break;
        case DDERR_NOFLIPHW:                     symbol = "DDERR_NOFLIPHW"; break;
        case DDERR_NOGDI:                        symbol = "DDERR_NOGDI"; break;
        case DDERR_NOMIRRORHW:                   symbol = "DDERR_NOMIRRORHW"; break;
        case DDERR_NOTFOUND:                     symbol = "DDERR_NOTFOUND"; break;
        case DDERR_NOOVERLAYHW:                  symbol = "DDERR_NOOVERLAYHW"; break;
        case DDERR_OVERLAPPINGRECTS:             symbol = "DDERR_OVERLAPPINGRECTS"; break;
        case DDERR_NORASTEROPHW:                 symbol = "DDERR_NORASTEROPHW"; break;
        case DDERR_NOROTATIONHW:                 symbol = "DDERR_NOROTATIONHW"; break;
        case DDERR_NOSTRETCHHW:                  symbol = "DDERR_NOSTRETCHHW"; break;
        case DDERR_NOT4BITCOLOR:                 symbol = "DDERR_NOT4BITCOLOR"; break;
        case DDERR_NOT4BITCOLORINDEX:            symbol = "DDERR_NOT4BITCOLORINDEX"; break;
        case DDERR_NOT8BITCOLOR:                 symbol = "DDERR_NOT8BITCOLOR"; break;
        case DDERR_NOTEXTUREHW:                  symbol = "DDERR_NOTEXTUREHW"; break;
        case DDERR_NOVSYNCHW:                    symbol = "DDERR_NOVSYNCHW"; break;
        case DDERR_NOZBUFFERHW:                  symbol = "DDERR_NOZBUFFERHW"; break;
        case DDERR_NOZOVERLAYHW:                 symbol = "DDERR_NOZOVERLAYHW"; break;
        case DDERR_OUTOFCAPS:                    symbol = "DDERR_OUTOFCAPS"; break;
        case DDERR_OUTOFMEMORY:                  symbol = "DDERR_OUTOFMEMORY"; break;
        case DDERR_OUTOFVIDEOMEMORY:             symbol = "DDERR_OUTOFVIDEOMEMORY"; break;
        case DDERR_OVERLAYCANTCLIP:              symbol = "DDERR_OVERLAYCANTCLIP"; break;
        case DDERR_OVERLAYCOLORKEYONLYONEACTIVE: symbol = "DDERR_OVERLAYCOLORKEYONLYONEACTIVE"; break;
        case DDERR_PALETTEBUSY:                  symbol = "DDERR_PALETTEBUSY"; break;
        case DDERR_COLORKEYNOTSET:               symbol = "DDERR_COLORKEYNOTSET"; break;
        case DDERR_SURFACEALREADYATTACHED:       symbol = "DDERR_SURFACEALREADYATTACHED"; break;
        case DDERR_SURFACEALREADYDEPENDENT:      symbol = "DDERR_SURFACEALREADYDEPENDENT"; break;
        case DDERR_SURFACEBUSY:                  symbol = "DDERR_SURFACEBUSY"; break;
        case DDERR_CANTLOCKSURFACE:              symbol = "DDERR_CANTLOCKSURFACE"; break;
        case DDERR_SURFACEISOBSCURED:            symbol = "DDERR_SURFACEISOBSCURED"; break;
        case DDERR_SURFACELOST:                  symbol = "DDERR_SURFACELOST"; break;
        case DDERR_SURFACENOTATTACHED:           symbol = "DDERR_SURFACENOTATTACHED"; break;
        case DDERR_TOOBIGHEIGHT:                 symbol = "DDERR_TOOBIGHEIGHT"; break;
        case DDERR_TOOBIGSIZE:                   symbol = "DDERR_TOOBIGSIZE"; break;
        case DDERR_TOOBIGWIDTH:                  symbol = "DDERR_TOOBIGWIDTH"; break;
        case DDERR_UNSUPPORTED:                  symbol = "DDERR_UNSUPPORTED"; break;
        case DDERR_UNSUPPORTEDFORMAT:            symbol = "DDERR_UNSUPPORTEDFORMAT"; break;
        case DDERR_UNSUPPORTEDMASK:              symbol = "DDERR_UNSUPPORTEDMASK"; break;
        case DDERR_INVALIDSTREAM:                symbol = "DDERR_INVALIDSTREAM"; break;
        case DDERR_VERTICALBLANKINPROGRESS:      symbol = "DDERR_VERTICALBLANKINPROGRESS"; break;
        case DDERR_WASSTILLDRAWING:              symbol = "DDERR_WASSTILLDRAWING"; break;
        case DDERR_DDSCAPSCOMPLEXREQUIRED:       symbol = "DDERR_DDSCAPSCOMPLEXREQUIRED"; break;
        case DDERR_XALIGN:                       symbol = "DDERR_XALIGN"; break;
        case DDERR_INVALIDDIRECTDRAWGUID:        symbol = "DDERR_INVALIDDIRECTDRAWGUID"; break;
        case DDERR_DIRECTDRAWALREADYCREATED:     symbol = "DDERR_DIRECTDRAWALREADYCREATED"; break;
        case DDERR_NODIRECTDRAWHW:               symbol = "DDERR_NODIRECTDRAWHW"; break;
        case DDERR_PRIMARYSURFACEALREADYEXISTS:  symbol = "DDERR_PRIMARYSURFACEALREADYEXISTS"; break;
        case DDERR_NOEMULATION:                  symbol = "DDERR_NOEMULATION"; break;
        case DDERR_REGIONTOOSMALL:               symbol = "DDERR_REGIONTOOSMALL"; break;
        case DDERR_CLIPPERISUSINGHWND:           symbol = "DDERR_CLIPPERISUSINGHWND"; break;
        case DDERR_NOCLIPPERATTACHED:            symbol = "DDERR_NOCLIPPERATTACHED"; break;
        case DDERR_NOHWND:                       symbol = "DDERR_NOHWND"; break;
        case DDERR_HWNDSUBCLASSED:               symbol = "DDERR_HWNDSUBCLASSED"; break;
        case DDERR_HWNDALREADYSET:               symbol = "DDERR_HWNDALREADYSET"; break;
        case DDERR_NOPALETTEATTACHED:            symbol = "DDERR_NOPALETTEATTACHED"; break;
        case DDERR_NOPALETTEHW:                  symbol = "DDERR_NOPALETTEHW"; break;
        case DDERR_BLTFASTCANTCLIP:              symbol = "DDERR_BLTFASTCANTCLIP"; break;
        case DDERR_NOBLTHW:                      symbol = "DDERR_NOBLTHW"; break;
        case DDERR_NODDROPSHW:                   symbol = "DDERR_NODDROPSHW"; break;
        case DDERR_OVERLAYNOTVISIBLE:            symbol = "DDERR_OVERLAYNOTVISIBLE"; break;
        case DDERR_NOOVERLAYDEST:                symbol = "DDERR_NOOVERLAYDEST"; break;
        case DDERR_INVALIDPOSITION:              symbol = "DDERR_INVALIDPOSITION"; break;
        case DDERR_NOTAOVERLAYSURFACE:           symbol = "DDERR_NOTAOVERLAYSURFACE"; break;
        case DDERR_EXCLUSIVEMODEALREADYSET:      symbol = "DDERR_EXCLUSIVEMODEALREADYSET"; break;
        case DDERR_NOTFLIPPABLE:                 symbol = "DDERR_NOTFLIPPABLE"; break;
        case DDERR_CANTDUPLICATE:                symbol = "DDERR_CANTDUPLICATE"; break;
        case DDERR_NOTLOCKED:                    symbol = "DDERR_NOTLOCKED"; break;
        case DDERR_CANTCREATEDC:                 symbol = "DDERR_CANTCREATEDC"; break;
        case DDERR_NODC:                         symbol = "DDERR_NODC"; break;
        case DDERR_WRONGMODE:                    symbol = "DDERR_WRONGMODE"; break;
        case DDERR_IMPLICITLYCREATED:            symbol = "DDERR_IMPLICITLYCREATED"; break;
        case DDERR_NOTPALETTIZED:                symbol = "DDERR_NOTPALETTIZED"; break;
        case DDERR_UNSUPPORTEDMODE:              symbol = "DDERR_UNSUPPORTEDMODE"; break;
        case DDERR_NOMIPMAPHW:                   symbol = "DDERR_NOMIPMAPHW"; break;
        case DDERR_INVALIDSURFACETYPE:           symbol = "DDERR_INVALIDSURFACETYPE"; break;
        case DDERR_NOOPTIMIZEHW:                 symbol = "DDERR_NOOPTIMIZEHW"; break;
        case DDERR_NOTLOADED:                    symbol = "DDERR_NOTLOADED"; break;
        case DDERR_NOFOCUSWINDOW:                symbol = "DDERR_NOFOCUSWINDOW"; break;
        case DDERR_NOTONMIPMAPSUBLEVEL:          symbol = "DDERR_NOTONMIPMAPSUBLEVEL"; break;
        case DDERR_DCALREADYCREATED:             symbol = "DDERR_DCALREADYCREATED"; break;
        case DDERR_NONONLOCALVIDMEM:             symbol = "DDERR_NONONLOCALVIDMEM"; break;
        case DDERR_CANTPAGELOCK:                 symbol = "DDERR_CANTPAGELOCK"; break;
        case DDERR_CANTPAGEUNLOCK:               symbol = "DDERR_CANTPAGEUNLOCK"; break;
        case DDERR_NOTPAGELOCKED:                symbol = "DDERR_NOTPAGELOCKED"; break;
        case DDERR_MOREDATA:                     symbol = "DDERR_MOREDATA"; break;
        case DDERR_EXPIRED:                      symbol = "DDERR_EXPIRED"; break;
        case DDERR_TESTFINISHED:                 symbol = "DDERR_TESTFINISHED"; break;
        case DDERR_NEWMODE:                      symbol = "DDERR_NEWMODE"; break;
        case DDERR_D3DNOTINITIALIZED:            symbol = "DDERR_D3DNOTINITIALIZED"; break;
        case DDERR_VIDEONOTACTIVE:               symbol = "DDERR_VIDEONOTACTIVE"; break;
        case DDERR_NOMONITORINFORMATION:         symbol = "DDERR_NOMONITORINFORMATION"; break;
        case DDERR_NODRIVERSUPPORT:              symbol = "DDERR_NODRIVERSUPPORT"; break;
        case DDERR_DEVICEDOESNTOWNSURFACE:       symbol = "DDERR_DEVICEDOESNTOWNSURFACE"; break;
        case DDERR_NOTINITIALIZED:               symbol = "DDERR_NOTINITIALIZED"; break;
        default: break;
    }

    return symbol;
}

private string getDirectDrawErrorMessage(HRESULT errorCode)
{
    string message;

    switch (errorCode)
    {
        case DDERR_ALREADYINITIALIZED:           message = "The object has already been initialized."; break;
        case DDERR_CANNOTATTACHSURFACE:          message = "A surface cannot be attached to another requested surface."; break;
        case DDERR_CANNOTDETACHSURFACE:          message = "A surface cannot be detached from another requested surface."; break;
        case DDERR_CURRENTLYNOTAVAIL:            message = "No support is currently available."; break;
        case DDERR_EXCEPTION:                    message = "An exception was encountered while performing the requested operation."; break;
        case DDERR_GENERIC:                      message = "There is an undefined error condition."; break;
        case DDERR_HEIGHTALIGN:                  message = "The height of the provided rectangle is not a multiple of the required alignment."; break;
        case DDERR_INCOMPATIBLEPRIMARY:          message = "The primary surface creation request does not match the existing primary surface."; break;
        case DDERR_INVALIDCAPS:                  message = "One or more of the capability bits passed to the callback function are incorrect."; break;
        case DDERR_INVALIDCLIPLIST:              message = "DirectDraw does not support the provided clip list."; break;
        case DDERR_INVALIDMODE:                  message = "DirectDraw does not support the requested mode."; break;
        case DDERR_INVALIDOBJECT:                message = "DirectDraw received a pointer that was an invalid DirectDraw object."; break;
        case DDERR_INVALIDPARAMS:                message = "One or more of the parameters passed to the method are incorrect."; break;
        case DDERR_INVALIDPIXELFORMAT:           message = "The pixel format was invalid as specified."; break;
        case DDERR_INVALIDRECT:                  message = "The provided rectangle was invalid."; break;
        case DDERR_LOCKEDSURFACES:               message = "One or more surfaces are locked, causing the failure of the requested operation."; break;
        case DDERR_NO3D:                         message = "No 3-D hardware or emulation is present."; break;
        case DDERR_NOALPHAHW:                    message = "No alpha-acceleration hardware is present or available, causing the failure of the requested operation."; break;
        case DDERR_NOSTEREOHARDWARE:             message = "There is no stereo hardware present or available."; break;
        case DDERR_NOSURFACELEFT:                message = "There is no hardware present that supports stereo surfaces."; break;
        case DDERR_NOCLIPLIST:                   message = "No clip list is available."; break;
        case DDERR_NOCOLORCONVHW:                message = "No color-conversion hardware is present or available."; break;
        case DDERR_NOCOOPERATIVELEVELSET:        message = "A create function was called without the IDirectDraw7::SetCooperativeLevel method."; break;
        case DDERR_NOCOLORKEY:                   message = "The surface does not currently have a color key."; break;
        case DDERR_NOCOLORKEYHW:                 message = "There is no hardware support for the destination color key."; break;
        case DDERR_NODIRECTDRAWSUPPORT:          message = "DirectDraw support is not possible with the current display driver."; break;
        case DDERR_NOEXCLUSIVEMODE:              message = "The operation requires the application to have exclusive mode, but the application does not have exclusive mode."; break;
        case DDERR_NOFLIPHW:                     message = "Flipping visible surfaces is not supported."; break;
        case DDERR_NOGDI:                        message = "No GDI is present."; break;
        case DDERR_NOMIRRORHW:                   message = "No mirroring hardware is present or available."; break;
        case DDERR_NOTFOUND:                     message = "The requested item was not found."; break;
        case DDERR_NOOVERLAYHW:                  message = "No overlay hardware is present or available."; break;
        case DDERR_OVERLAPPINGRECTS:             message = "The source and destination rectangles are on the same surface and overlap each other."; break;
        case DDERR_NORASTEROPHW:                 message = "No appropriate raster-operation hardware is present or available."; break;
        case DDERR_NOROTATIONHW:                 message = "No rotation hardware is present or available."; break;
        case DDERR_NOSTRETCHHW:                  message = "There is no hardware support for stretching."; break;
        case DDERR_NOT4BITCOLOR:                 message = "The DirectDrawSurface object is not using a 4-bit color palette, and the requested operation requires a 4-bit color palette."; break;
        case DDERR_NOT4BITCOLORINDEX:            message = "The DirectDrawSurface object is not using a 4-bit color index palette, and the requested operation requires a 4-bit color index palette."; break;
        case DDERR_NOT8BITCOLOR:                 message = "The DirectDrawSurface object is not using an 8-bit color palette, and the requested operation requires an 8-bit color palette."; break;
        case DDERR_NOTEXTUREHW:                  message = "The operation cannot be carried out because no texture-mapping hardware is present or available."; break;
        case DDERR_NOVSYNCHW:                    message = "There is no hardware support for vertical blank–synchronized operations."; break;
        case DDERR_NOZBUFFERHW:                  message = "The operation to create a z-buffer in display memory or to perform a bit block transfer (bitblt), using a z-buffer cannot be carried out because there is no hardware support for z-buffers."; break;
        case DDERR_NOZOVERLAYHW:                 message = "The overlay surfaces cannot be z-layered, based on the z-order because the hardware does not support z-ordering of overlays."; break;
        case DDERR_OUTOFCAPS:                    message = "The hardware needed for the requested operation has already been allocated."; break;
        case DDERR_OUTOFMEMORY:                  message = "DirectDraw does not have enough memory to perform the operation."; break;
        case DDERR_OUTOFVIDEOMEMORY:             message = "DirectDraw does not have enough display memory to perform the operation."; break;
        case DDERR_OVERLAYCANTCLIP:              message = "The hardware does not support clipped overlays."; break;
        case DDERR_OVERLAYCOLORKEYONLYONEACTIVE: message = "An attempt was made to have more than one color key active on an overlay."; break;
        case DDERR_PALETTEBUSY:                  message = "Access to this palette is refused because the palette is locked by another thread."; break;
        case DDERR_COLORKEYNOTSET:               message = "No source color key is specified for this operation."; break;
        case DDERR_SURFACEALREADYATTACHED:       message = "An attempt was made to attach a surface to another surface to which it is already attached."; break;
        case DDERR_SURFACEALREADYDEPENDENT:      message = "An attempt was made to make a surface a dependency of another surface on which it is already dependent."; break;
        case DDERR_SURFACEBUSY:                  message = "Access to the surface is refused because the surface is locked by another thread."; break;
        case DDERR_CANTLOCKSURFACE:              message = "Access to this surface is refused because an attempt was made to lock the primary surface without Display Control Interface (DCI) support."; break;
        case DDERR_SURFACEISOBSCURED:            message = "Access to the surface is refused because the surface is obscured."; break;
        case DDERR_SURFACELOST:                  message = "Access to the surface is refused because the surface memory is gone. Call the IDirectDrawSurface7::Restore method on this surface to restore the memory associated with it."; break;
        case DDERR_SURFACENOTATTACHED:           message = "The requested surface is not attached."; break;
        case DDERR_TOOBIGHEIGHT:                 message = "The height requested by DirectDraw is too large."; break;
        case DDERR_TOOBIGSIZE:                   message = "The size requested by DirectDraw is too large. However, the individual height and width are valid sizes."; break;
        case DDERR_TOOBIGWIDTH:                  message = "The width requested by DirectDraw is too large."; break;
        case DDERR_UNSUPPORTED:                  message = "The operation is not supported."; break;
        case DDERR_UNSUPPORTEDFORMAT:            message = "The pixel format requested is not supported by DirectDraw."; break;
        case DDERR_UNSUPPORTEDMASK:              message = "The bitmask in the pixel format requested is not supported by DirectDraw."; break;
        case DDERR_INVALIDSTREAM:                message = "The specified stream contains invalid data."; break;
        case DDERR_VERTICALBLANKINPROGRESS:      message = "A vertical blank is in progress."; break;
        case DDERR_WASSTILLDRAWING:              message = "The previous bitblt operation that is transferring information to or from this surface is incomplete."; break;
        case DDERR_DDSCAPSCOMPLEXREQUIRED:       message = "New for DirectX 7.0. The surface requires the DDSCAPS_COMPLEX flag."; break;
        case DDERR_XALIGN:                       message = "The provided rectangle was not horizontally aligned on a required boundary."; break;
        case DDERR_INVALIDDIRECTDRAWGUID:        message = "The globally unique identifier (GUID) passed to the DirectDrawCreate function is not a valid DirectDraw driver identifier."; break;
        case DDERR_DIRECTDRAWALREADYCREATED:     message = "A DirectDraw object representing this driver has already been created for this process."; break;
        case DDERR_NODIRECTDRAWHW:               message = "Hardware-only DirectDraw object creation is not possible; the driver does not support any hardware."; break;
        case DDERR_PRIMARYSURFACEALREADYEXISTS:  message = "This process has already created a primary surface."; break;
        case DDERR_NOEMULATION:                  message = "Software emulation is not available."; break;
        case DDERR_REGIONTOOSMALL:               message = "The region passed to the IDirectDrawClipper::GetClipList method is too small."; break;
        case DDERR_CLIPPERISUSINGHWND:           message = "An attempt was made to set a clip list for a DirectDrawClipper object that is already monitoring a window handle."; break;
        case DDERR_NOCLIPPERATTACHED:            message = "No DirectDrawClipper object is attached to the surface object."; break;
        case DDERR_NOHWND:                       message = "Clipper notification requires a window handle, or no window handle has been previously set as the cooperative level window handle."; break;
        case DDERR_HWNDSUBCLASSED:               message = "DirectDraw is prevented from restoring state because the DirectDraw cooperative-level window handle has been subclassed."; break;
        case DDERR_HWNDALREADYSET:               message = "The DirectDraw cooperative-level window handle has already been set. It cannot be reset while the process has surfaces or palettes created."; break;
        case DDERR_NOPALETTEATTACHED:            message = "No palette object is attached to this surface."; break;
        case DDERR_NOPALETTEHW:                  message = "There is no hardware support for 16- or 256-color palettes."; break;
        case DDERR_BLTFASTCANTCLIP:              message = "A DirectDrawClipper object is attached to a source surface that has passed into a call to the IDirectDrawSurface7::BltFast method."; break;
        case DDERR_NOBLTHW:                      message = "No bit block transferring hardware is present."; break;
        case DDERR_NODDROPSHW:                   message = "No DirectDraw raster-operation (ROP) hardware is available."; break;
        case DDERR_OVERLAYNOTVISIBLE:            message = "The IDirectDrawSurface7::GetOverlayPosition method was called on a hidden overlay."; break;
        case DDERR_NOOVERLAYDEST:                message = "The IDirectDrawSurface7::GetOverlayPosition method is called on an overlay that the IDirectDrawSurface7::UpdateOverlay method has not been called on to establish as a destination."; break;
        case DDERR_INVALIDPOSITION:              message = "The position of the overlay on the destination is no longer valid."; break;
        case DDERR_NOTAOVERLAYSURFACE:           message = "An overlay component is called for a nonoverlay surface."; break;
        case DDERR_EXCLUSIVEMODEALREADYSET:      message = "An attempt was made to set the cooperative level when it was already set to exclusive."; break;
        case DDERR_NOTFLIPPABLE:                 message = "An attempt was made to flip a surface that cannot be flipped."; break;
        case DDERR_CANTDUPLICATE:                message = "Primary and 3-D surfaces, or surfaces that are implicitly created, cannot be duplicated."; break;
        case DDERR_NOTLOCKED:                    message = "An attempt was made to unlock a surface that was not locked."; break;
        case DDERR_CANTCREATEDC:                 message = "Windows cannot create any more device contexts (DCs), or a DC has requested a palette-indexed surface when the surface had no palette and the display mode was not palette-indexed (in this case, DirectDraw cannot select a proper palette into the DC)."; break;
        case DDERR_NODC:                         message = "No device context (DC) has ever been created for this surface."; break;
        case DDERR_WRONGMODE:                    message = "This surface cannot be restored because it was created in a different mode."; break;
        case DDERR_IMPLICITLYCREATED:            message = "The surface cannot be restored because it is an implicitly created surface."; break;
        case DDERR_NOTPALETTIZED:                message = "The surface being used is not a palette-based surface."; break;
        case DDERR_UNSUPPORTEDMODE:              message = "The display is currently in an unsupported mode."; break;
        case DDERR_NOMIPMAPHW:                   message = "No mipmap-capable texture mapping hardware is present or available."; break;
        case DDERR_INVALIDSURFACETYPE:           message = "The surface was of the wrong type."; break;
        case DDERR_NOOPTIMIZEHW:                 message = "The device does not support optimized surfaces."; break;
        case DDERR_NOTLOADED:                    message = "The surface is an optimized surface, but it has not yet been allocated any memory."; break;
        case DDERR_NOFOCUSWINDOW:                message = "An attempt was made to create or set a device window without first setting the focus window."; break;
        case DDERR_NOTONMIPMAPSUBLEVEL:          message = "An attempt was made to set a palette on a mipmap sublevel."; break;
        case DDERR_DCALREADYCREATED:             message = "A device context (DC) has already been returned for this surface. Only one DC can be retrieved for each surface."; break;
        case DDERR_NONONLOCALVIDMEM:             message = "An attempt was made to allocate nonlocal video memory from a device that does not support nonlocal video memory."; break;
        case DDERR_CANTPAGELOCK:                 message = "An attempt to page-lock a surface failed. Page lock does not work on a display-memory surface or an emulated primary surface."; break;
        case DDERR_CANTPAGEUNLOCK:               message = "An attempt to page-unlock a surface failed. Page unlock does not work on a display-memory surface or an emulated primary surface."; break;
        case DDERR_NOTPAGELOCKED:                message = "An attempt was made to page-unlock a surface with no outstanding page locks."; break;
        case DDERR_MOREDATA:                     message = "There is more data available than the specified buffer size can hold."; break;
        case DDERR_EXPIRED:                      message = "The data has expired and is therefore no longer valid."; break;
        case DDERR_TESTFINISHED:                 message = "New for DirectX 7.0. When returned by the IDirectDraw7::StartModeTest method, this value means that no test could be initiated because all the resolutions chosen for testing already have refresh rate information in the registry. When returned by IDirectDraw7::EvaluateMode, the value means that DirectDraw has completed a refresh rate test."; break;
        case DDERR_NEWMODE:                      message = "New for DirectX 7.0. When IDirectDraw7::StartModeTest is called with the DDSMT_ISTESTREQUIRED flag, it might return this value to denote that some or all of the resolutions can and should be tested. IDirectDraw7::EvaluateMode returns this value to indicate that the test has switched to a new display mode."; break;
        case DDERR_D3DNOTINITIALIZED:            message = "Direct3D has not yet been initialized."; break;
        case DDERR_VIDEONOTACTIVE:               message = "The video port is not active."; break;
        case DDERR_NOMONITORINFORMATION:         message = "New for DirectX 7.0. Testing cannot proceed because the monitor has no associated EDID data."; break;
        case DDERR_NODRIVERSUPPORT:              message = "New for DirectX 7.0. Testing cannot proceed because the display adapter driver does not enumerate refresh rates."; break;
        case DDERR_DEVICEDOESNTOWNSURFACE:       message = "Surfaces created by one DirectDraw device cannot be used directly by another DirectDraw device."; break;
        case DDERR_NOTINITIALIZED:               message = "An attempt was made to call an interface method of a DirectDraw object created by CoCreateInstance before the object was initialized."; break;
        default: break;
    }

    return message;
}

private template callDirectDrawFunc()
{
    void callDirectDrawFunc(HRESULT)(lazy HRESULT expression)
    {
        HRESULT result = expression();

        if (result != DD_OK)
        {
            throw new DirectDrawException(result);
        }
    }
}

VOID _DirectDrawCreate(LPGUID lpGUID, LPDIRECTDRAW* lplpDD)
{
    callDirectDrawFunc!()(DirectDrawCreate(lpGUID, lplpDD, null));
}

VOID _DirectDrawCreateClipper(DWORD dwFlags, LPDIRECTDRAWCLIPPER* lplpDDClipper)
{
    callDirectDrawFunc!()(DirectDrawCreateClipper(dwFlags, lplpDDClipper, null));
}

VOID _DirectDrawCreateEx(LPGUID lpGUID, LPVOID* lplpDD, REFIID iid)
{
    callDirectDrawFunc!()(DirectDrawCreateEx(lpGUID, lplpDD, iid, null));
}

VOID _DirectDrawEnumerate(LPDDENUMCALLBACK lpCallback, LPVOID lpContext)
{
    callDirectDrawFunc!()(DirectDrawEnumerate(lpCallback, lpContext));
}

VOID _DirectDrawEnumerateEx(LPDDENUMCALLBACKEX lpCallback, LPVOID lpContext, DWORD dwFlags)
{
    callDirectDrawFunc!()(DirectDrawEnumerateEx(lpCallback, lpContext, dwFlags));
}

VOID _Compact(LPDIRECTDRAW7 lpDD)
{
    callDirectDrawFunc!()(lpDD.Compact());
}

VOID _CreateClipper(LPDIRECTDRAW7 lpDD, DWORD dwFlags, LPDIRECTDRAWCLIPPER* lplpDDClipper)
{
    callDirectDrawFunc!()(lpDD.CreateClipper(dwFlags, lplpDDClipper, null));
}

VOID _CreatePalette(LPDIRECTDRAW7 lpDD, DWORD dwFlags, LPPALETTEENTRY lpDDColorArray, LPDIRECTDRAWPALETTE* lplpDDPalette)
{
    callDirectDrawFunc!()(lpDD.CreatePalette(dwFlags, lpDDColorArray, lplpDDPalette, null));
}

VOID _CreateSurface(LPDIRECTDRAW7 lpDD, LPDDSURFACEDESC2 lpDDSurfaceDesc2, LPDIRECTDRAWSURFACE7* lplpDDSurface)
{
    callDirectDrawFunc!()(lpDD.CreateSurface(lpDDSurfaceDesc2, lplpDDSurface, null));
}

VOID _DuplicateSurface(LPDIRECTDRAW7 lpDD, LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAWSURFACE7* lplpDupDDSurface)
{
    callDirectDrawFunc!()(lpDD.DuplicateSurface(lpDDSurface, lplpDupDDSurface));
}

VOID _EnumDisplayModes(LPDIRECTDRAW7 lpDD, DWORD dwFlags, LPDDSURFACEDESC2 lpDDSurfaceDesc2, LPVOID lpContext, LPDDENUMMODESCALLBACK2 lpEnumModesCallback)
{
    callDirectDrawFunc!()(lpDD.EnumDisplayModes(dwFlags, lpDDSurfaceDesc2, lpContext, lpEnumModesCallback));
}

DDSURFACEDESC2[] _EnumAllDisplayModes(LPDIRECTDRAW7 lpDD)
{
    LPDDENUMMODESCALLBACK2 callback = function(LPDDSURFACEDESC2 lpDDSurfaceDesc, LPVOID lpContext)
    {
        *(cast (DDSURFACEDESC2[]*) lpContext) ~= *lpDDSurfaceDesc;
        return DDENUMRET_OK;
    };

    DDSURFACEDESC2[] modes;
    callDirectDrawFunc!()(lpDD.EnumDisplayModes(DDEDM_REFRESHRATES | DDEDM_STANDARDVGAMODES, null, &modes, callback));
    return modes;
}

VOID _EnumSurfaces(LPDIRECTDRAW7 lpDD, DWORD dwFlags, LPDDSURFACEDESC2 lpDDSD2, LPVOID lpContext, LPDDENUMSURFACESCALLBACK7 lpEnumSurfacesCallback)
{
    callDirectDrawFunc!()(lpDD.EnumSurfaces(dwFlags, lpDDSD2, lpContext, lpEnumSurfacesCallback));
}

VOID _FlipToGDISurface(LPDIRECTDRAW7 lpDD)
{
    callDirectDrawFunc!()(lpDD.FlipToGDISurface());
}

VOID _GetCaps(LPDIRECTDRAW7 lpDD, LPDDCAPS lpDDDriverCaps, LPDDCAPS lpDDHELCaps)
{
    callDirectDrawFunc!()(lpDD.GetCaps(lpDDDriverCaps, lpDDHELCaps));
}

VOID _GetDisplayMode(LPDIRECTDRAW7 lpDD, LPDDSURFACEDESC2 lpDDSurfaceDesc2)
{
    callDirectDrawFunc!()(lpDD.GetDisplayMode(lpDDSurfaceDesc2));
}

VOID _GetFourCCCodes(LPDIRECTDRAW7 lpDD, LPDWORD lpNumCodes, LPDWORD lpCodes)
{
    callDirectDrawFunc!()(lpDD.GetFourCCCodes(lpNumCodes, lpCodes));
}

VOID _GetGDISurface(LPDIRECTDRAW7 lpDD, LPDIRECTDRAWSURFACE7* lplpGDIDDSSurface)
{
    callDirectDrawFunc!()(lpDD.GetGDISurface(lplpGDIDDSSurface));
}

VOID _GetMonitorFrequency(LPDIRECTDRAW7 lpDD, LPDWORD lpdwFrequency)
{
    callDirectDrawFunc!()(lpDD.GetMonitorFrequency(lpdwFrequency));
}

VOID _GetScanLine(LPDIRECTDRAW7 lpDD, LPDWORD lpdwScanLine)
{
    callDirectDrawFunc!()(lpDD.GetScanLine(lpdwScanLine));
}

VOID _GetVerticalBlankStatus(LPDIRECTDRAW7 lpDD, LPBOOL lpbIsInVB)
{
    callDirectDrawFunc!()(lpDD.GetVerticalBlankStatus(lpbIsInVB));
}

VOID _Initialize(LPDIRECTDRAW7 lpDD, LPGUID lpGUID)
{
    callDirectDrawFunc!()(lpDD.Initialize(lpGUID));
}

VOID _RestoreDisplayMode(LPDIRECTDRAW7 lpDD)
{
    callDirectDrawFunc!()(lpDD.RestoreDisplayMode());
}

VOID _SetCooperativeLevel(LPDIRECTDRAW7 lpDD, HWND hWnd, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDD.SetCooperativeLevel(hWnd, dwFlags));
}

VOID _SetDisplayMode(LPDIRECTDRAW7 lpDD, DWORD dwWidth, DWORD dwHeight, DWORD dwBPP, DWORD dwRefreshRate, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDD.SetDisplayMode(dwWidth, dwHeight, dwBPP, dwRefreshRate, dwFlags));
}

VOID _WaitForVerticalBlank(LPDIRECTDRAW7 lpDD, DWORD dwFlags, HANDLE hEvent)
{
    callDirectDrawFunc!()(lpDD.WaitForVerticalBlank(dwFlags, hEvent));
}

VOID _GetAvailableVidMem(LPDIRECTDRAW7 lpDD, LPDDSCAPS2 lpDDSCaps2, LPDWORD lpdwTotal, LPDWORD lpdwFree)
{
    callDirectDrawFunc!()(lpDD.GetAvailableVidMem(lpDDSCaps2, lpdwTotal, lpdwFree));
}

VOID _GetSurfaceFromDC(LPDIRECTDRAW7 lpDD, HDC hdc, LPDIRECTDRAWSURFACE7* lpDDS)
{
    callDirectDrawFunc!()(lpDD.GetSurfaceFromDC(hdc, lpDDS));
}

VOID _RestoreAllSurfaces(LPDIRECTDRAW7 lpDD)
{
    callDirectDrawFunc!()(lpDD.RestoreAllSurfaces());
}

VOID _TestCooperativeLevel(LPDIRECTDRAW7 lpDD)
{
    callDirectDrawFunc!()(lpDD.TestCooperativeLevel());
}

VOID _GetDeviceIdentifier(LPDIRECTDRAW7 lpDD, LPDDDEVICEIDENTIFIER2 lpdddi, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDD.GetDeviceIdentifier(lpdddi, dwFlags));
}

VOID _StartModeTest(LPDIRECTDRAW7 lpDD, LPSIZE lpModesToTest, DWORD dwNumEntries, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDD.StartModeTest(lpModesToTest, dwNumEntries, dwFlags));
}

VOID _EvaluateMode(LPDIRECTDRAW7 lpDD, DWORD dwFlags, LPDWORD pSecondsUntilTimeout)
{
    callDirectDrawFunc!()(lpDD.EvaluateMode(dwFlags, pSecondsUntilTimeout));
}

VOID _Release(LPDIRECTDRAW7 lpDD)
{
    if (lpDD !is null)
    {
        lpDD.Release();
    }
}

VOID _GetClipList(LPDIRECTDRAWCLIPPER lpDDClipper, LPRECT lpRect, LPRGNDATA lpClipList, LPDWORD lpdwSize)
{
    callDirectDrawFunc!()(lpDDClipper.GetClipList(lpRect, lpClipList, lpdwSize));
}

VOID _GetHWnd(LPDIRECTDRAWCLIPPER lpDDClipper, HWND* lphWnd)
{
    callDirectDrawFunc!()(lpDDClipper.GetHWnd(lphWnd));
}

VOID _Initialize(LPDIRECTDRAWCLIPPER lpDDClipper, LPDIRECTDRAW lpDD, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDClipper.Initialize(lpDD, dwFlags));
}

VOID _IsClipListChanged(LPDIRECTDRAWCLIPPER lpDDClipper, LPBOOL lpbChanged)
{
    callDirectDrawFunc!()(lpDDClipper.IsClipListChanged(lpbChanged));
}

VOID _SetClipList(LPDIRECTDRAWCLIPPER lpDDClipper, LPRGNDATA lpClipList, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDClipper.SetClipList(lpClipList, dwFlags));
}

VOID _SetHWnd(LPDIRECTDRAWCLIPPER lpDDClipper, DWORD dwFlags, HWND hWnd)
{
    callDirectDrawFunc!()(lpDDClipper.SetHWnd(dwFlags, hWnd));
}

VOID _Release(LPDIRECTDRAWCLIPPER lpDDClipper)
{
    if (lpDDClipper !is null)
    {
        lpDDClipper.Release();
    }
}

VOID _GetCaps(LPDIRECTDRAWPALETTE lpDDPalette, LPDWORD lpdwCaps)
{
    callDirectDrawFunc!()(lpDDPalette.GetCaps(lpdwCaps));
}

VOID _GetEntries(LPDIRECTDRAWPALETTE lpDDPalette, DWORD dwFlags, DWORD dwBase, DWORD dwNumEntries, LPPALETTEENTRY lpEntries)
{
    callDirectDrawFunc!()(lpDDPalette.GetEntries(dwFlags, dwBase, dwNumEntries, lpEntries));
}

VOID _Initialize(LPDIRECTDRAWPALETTE lpDDPalette, LPDIRECTDRAW lpDD, DWORD dwFlags, LPPALETTEENTRY lpDDColorTable)
{
    callDirectDrawFunc!()(lpDDPalette.Initialize(lpDD, dwFlags, lpDDColorTable));
}

VOID _SetEntries(LPDIRECTDRAWPALETTE lpDDPalette, DWORD dwFlags, DWORD dwStartingEntry, DWORD dwCount, LPPALETTEENTRY lpEntries)
{
    callDirectDrawFunc!()(lpDDPalette.SetEntries(dwFlags, dwStartingEntry, dwCount, lpEntries));
}

VOID _Release(LPDIRECTDRAWPALETTE lpDDPalette)
{
    if (lpDDPalette !is null)
    {
        lpDDPalette.Release();
    }
}

VOID _AddAttachedSurface(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAWSURFACE7 lpDDAttachSurface)
{
    callDirectDrawFunc!()(lpDDSurface.AddAttachedSurface(lpDDAttachSurface));
}

VOID _AddOverlayDirtyRect(LPDIRECTDRAWSURFACE7 lpDDSurface, LPRECT lpRect)
{
    callDirectDrawFunc!()(lpDDSurface.AddOverlayDirtyRect(lpRect));
}

VOID _Blt(LPDIRECTDRAWSURFACE7 lpDDSurface, LPRECT lpDestRect, LPDIRECTDRAWSURFACE7 lpDDSrcSurface, LPRECT lpSrcRect, DWORD dwFlags, LPDDBLTFX lpDDBltFx)
{
    callDirectDrawFunc!()(lpDDSurface.Blt(lpDestRect, lpDDSrcSurface, lpSrcRect, dwFlags, lpDDBltFx));
}

VOID _BltBatch(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDDBLTBATCH lpDDBltBatch, DWORD dwCount, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDSurface.BltBatch(lpDDBltBatch, dwCount, dwFlags));
}

VOID _BltFast(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwX, DWORD dwY, LPDIRECTDRAWSURFACE7 lpDDSrcSurface, LPRECT lpSrcRect, DWORD dwFlags) // LPDDBLTFX lpDDBltFx
{
    callDirectDrawFunc!()(lpDDSurface.BltFast(dwX, dwY, lpDDSrcSurface, lpSrcRect, dwFlags));
}

VOID _DeleteAttachedSurface(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags, LPDIRECTDRAWSURFACE7 lpDDSAttachedSurface)
{
    callDirectDrawFunc!()(lpDDSurface.DeleteAttachedSurface(dwFlags, lpDDSAttachedSurface));
}

VOID _EnumAttachedSurfaces(LPDIRECTDRAWSURFACE7 lpDDSurface, LPVOID lpContext, LPDDENUMSURFACESCALLBACK7 lpEnumSurfacesCallback)
{
    callDirectDrawFunc!()(lpDDSurface.EnumAttachedSurfaces(lpContext, lpEnumSurfacesCallback));
}

VOID _EnumOverlayZOrders(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags, LPVOID lpContext, LPDDENUMSURFACESCALLBACK7 lpfnCallback)
{
    callDirectDrawFunc!()(lpDDSurface.EnumOverlayZOrders(dwFlags, lpContext, lpfnCallback));
}

VOID _Flip(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAWSURFACE7 lpDDSurfaceTargetOverride, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDSurface.Flip(lpDDSurfaceTargetOverride, dwFlags));
}

VOID _GetAttachedSurface(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDDSCAPS2 lpDDSCaps, LPDIRECTDRAWSURFACE7* lplpDDAttachedSurface)
{
    callDirectDrawFunc!()(lpDDSurface.GetAttachedSurface(lpDDSCaps, lplpDDAttachedSurface));
}

VOID _GetBltStatus(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDSurface.GetBltStatus(dwFlags));
}

VOID _GetCaps(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDDSCAPS2 lpDDSCaps)
{
    callDirectDrawFunc!()(lpDDSurface.GetCaps(lpDDSCaps));
}

VOID _GetClipper(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAWCLIPPER* lplpDDClipper)
{
    callDirectDrawFunc!()(lpDDSurface.GetClipper(lplpDDClipper));
}

VOID _GetColorKey(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags, LPDDCOLORKEY lpDDColorKey)
{
    callDirectDrawFunc!()(lpDDSurface.GetColorKey(dwFlags, lpDDColorKey));
}

VOID _GetDC(LPDIRECTDRAWSURFACE7 lpDDSurface, HDC* lphDC)
{
    callDirectDrawFunc!()(lpDDSurface.GetDC(lphDC));
}

VOID _GetFlipStatus(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDSurface.GetFlipStatus(dwFlags));
}

VOID _GetOverlayPosition(LPDIRECTDRAWSURFACE7 lpDDSurface, LPLONG lplX, LPLONG lplY)
{
    callDirectDrawFunc!()(lpDDSurface.GetOverlayPosition(lplX, lplY));
}

VOID _GetPalette(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAWPALETTE* lplpDDPalette)
{
    callDirectDrawFunc!()(lpDDSurface.GetPalette(lplpDDPalette));
}

VOID _GetPixelFormat(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDDPIXELFORMAT lpDDPixelFormat)
{
    callDirectDrawFunc!()(lpDDSurface.GetPixelFormat(lpDDPixelFormat));
}

VOID _GetSurfaceDesc(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDDSURFACEDESC2 lpDDSurfaceDesc)
{
    callDirectDrawFunc!()(lpDDSurface.GetSurfaceDesc(lpDDSurfaceDesc));
}

VOID _Initialize(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAW lpDD, LPDDSURFACEDESC2 lpDDSurfaceDesc)
{
    callDirectDrawFunc!()(lpDDSurface.Initialize(lpDD, lpDDSurfaceDesc));
}

BOOL _IsLost(LPDIRECTDRAWSURFACE7 lpDDSurface)
{
    HRESULT result = lpDDSurface.IsLost();

    if (result != DD_OK && result != DDERR_SURFACELOST)
    {
        throw new DirectDrawException(result);
    }

    return result == DDERR_SURFACELOST;
}

VOID _Lock(LPDIRECTDRAWSURFACE7 lpDDSurface, LPRECT lpDestRect, LPDDSURFACEDESC2 lpDDSurfaceDesc, DWORD dwFlags, HANDLE hEvent)
{
    callDirectDrawFunc!()(lpDDSurface.Lock(lpDestRect, lpDDSurfaceDesc, dwFlags, hEvent));
}

VOID _ReleaseDC(LPDIRECTDRAWSURFACE7 lpDDSurface, HDC hDC)
{
    callDirectDrawFunc!()(lpDDSurface.ReleaseDC(hDC));
}

VOID _Restore(LPDIRECTDRAWSURFACE7 lpDDSurface)
{
    callDirectDrawFunc!()(lpDDSurface.Restore());
}

VOID _SetClipper(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAWCLIPPER lpDDClipper)
{
    callDirectDrawFunc!()(lpDDSurface.SetClipper(lpDDClipper));
}

VOID _SetColorKey(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags, LPDDCOLORKEY lpDDColorKey)
{
    callDirectDrawFunc!()(lpDDSurface.SetColorKey(dwFlags, lpDDColorKey));
}

VOID _SetOverlayPosition(LPDIRECTDRAWSURFACE7 lpDDSurface, LONG lX, LONG lY)
{
    callDirectDrawFunc!()(lpDDSurface.SetOverlayPosition(lX, lY));
}

VOID _SetPalette(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAWPALETTE lpDDPalette)
{
    callDirectDrawFunc!()(lpDDSurface.SetPalette(lpDDPalette));
}

VOID _Unlock(LPDIRECTDRAWSURFACE7 lpDDSurface, LPRECT lpRect)
{
    callDirectDrawFunc!()(lpDDSurface.Unlock(lpRect));
}

VOID _UpdateOverlay(LPDIRECTDRAWSURFACE7 lpDDSurface, LPRECT lpSrcRect, LPDIRECTDRAWSURFACE7 lpDDDestSurface, LPRECT lpDestRect, DWORD dwFlags, LPDDOVERLAYFX lpDDOverlayFx)
{
    callDirectDrawFunc!()(lpDDSurface.UpdateOverlay(lpSrcRect, lpDDDestSurface, lpDestRect, dwFlags, lpDDOverlayFx));
}

VOID _UpdateOverlayDisplay(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDSurface.UpdateOverlayDisplay(dwFlags));
}

VOID _UpdateOverlayZOrder(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags, LPDIRECTDRAWSURFACE7 lpDDSReference)
{
    callDirectDrawFunc!()(lpDDSurface.UpdateOverlayZOrder(dwFlags, lpDDSReference));
}

VOID _GetDDInterface(LPDIRECTDRAWSURFACE7 lpDDSurface, LPVOID* lplpDD)
{
    callDirectDrawFunc!()(lpDDSurface.GetDDInterface(lplpDD));
}

VOID _PageLock(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDSurface.PageLock(dwFlags));
}

VOID _PageUnlock(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDSurface.PageUnlock(dwFlags));
}

VOID _SetSurfaceDesc(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDDSURFACEDESC2 lpDDsd2, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDSurface.SetSurfaceDesc(lpDDsd2, dwFlags));
}

VOID _SetPrivateData(LPDIRECTDRAWSURFACE7 lpDDSurface, REFGUID guidTag, LPVOID lpData, DWORD cbSize, DWORD dwFlags)
{
    callDirectDrawFunc!()(lpDDSurface.SetPrivateData(guidTag, lpData, cbSize, dwFlags));
}

VOID _GetPrivateData(LPDIRECTDRAWSURFACE7 lpDDSurface, REFGUID guidTag, LPVOID lpBuffer, LPDWORD lpcbBufferSize)
{
    callDirectDrawFunc!()(lpDDSurface.GetPrivateData(guidTag, lpBuffer, lpcbBufferSize));
}

VOID _FreePrivateData(LPDIRECTDRAWSURFACE7 lpDDSurface, REFGUID guidTag)
{
    callDirectDrawFunc!()(lpDDSurface.FreePrivateData(guidTag));
}

VOID _GetUniquenessValue(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDWORD lpValue)
{
    callDirectDrawFunc!()(lpDDSurface.GetUniquenessValue(lpValue));
}

VOID _ChangeUniquenessValue(LPDIRECTDRAWSURFACE7 lpDDSurface)
{
    callDirectDrawFunc!()(lpDDSurface.ChangeUniquenessValue());
}

VOID _SetPriority(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwPriority)
{
    callDirectDrawFunc!()(lpDDSurface.SetPriority(dwPriority));
}

VOID _GetPriority(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDWORD lpdwPriority)
{
    callDirectDrawFunc!()(lpDDSurface.GetPriority(lpdwPriority));
}

VOID _SetLOD(LPDIRECTDRAWSURFACE7 lpDDSurface, DWORD dwMaxLOD)
{
    callDirectDrawFunc!()(lpDDSurface.SetLOD(dwMaxLOD));
}

VOID _GetLOD(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDWORD lpdwMaxLOD)
{
    callDirectDrawFunc!()(lpDDSurface.GetLOD(lpdwMaxLOD));
}

VOID _Release(LPDIRECTDRAWSURFACE7 lpDDSurface)
{
    if (lpDDSurface !is null)
    {
        lpDDSurface.Release();
    }
}
