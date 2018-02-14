module durge.system.windows.native.rawinput;

version (Windows):

import durge.system.windows.native.common;
import durge.system.windows.native.hid;
import durge.system.windows.native.windows;

enum // Input Device Type
{
    RIM_TYPEMOUSE    = 0,
    RIM_TYPEKEYBOARD = 1,
    RIM_TYPEHID      = 2,
}

enum // Input Device Info Type
{
    RIDI_PREPARSEDDATA = 0x20000005U,
    RIDI_DEVICENAME    = 0x20000007U,
    RIDI_DEVICEINFO    = 0x2000000bU,
}

enum // Register Input Device Flags
{
    RIDEV_REMOVE       = 0x0001,
    RIDEV_EXCLUDE      = 0x0010,
    RIDEV_PAGEONLY     = 0x0020,
    RIDEV_NOLEGACY     = 0x0030,
    RIDEV_INPUTSINK    = 0x0100,
    RIDEV_CAPTUREMOUSE = 0x0200,
    RIDEV_NOHOTKEYS    = 0x0200,
    RIDEV_APPKEYS      = 0x0400,
    RIDEV_EXINPUTSINK  = 0x1000,
    RIDEV_DEVNOTIFY    = 0x2000,
    RIDEV_EXMODEMASK   = 0x00f0,
}

enum // GetRawInputData()
{
    RID_INPUT  = 0x10000003U,
    RID_HEADER = 0x10000005U,
}

enum // Keyboard Input Flags
{
    RI_KEY_MAKE            = 0x00,
    RI_KEY_BREAK           = 0x01,
    RI_KEY_E0              = 0x02,
    RI_KEY_E1              = 0x04,
    RI_KEY_TERMSRV_SET_LED = 0x08,
    RI_KEY_TERMSRV_SHADOW  = 0x10,
}

enum // Mouse Input Data Flags
{
    MOUSE_MOVE_RELATIVE      = 0x00,
    MOUSE_MOVE_ABSOLUTE      = 0x01,
    MOUSE_VIRTUAL_DESKTOP    = 0x02,
    MOUSE_ATTRIBUTES_CHANGED = 0x04,
    MOUSE_MOVE_NOCOALESCE    = 0x08,
}

enum // Mouse Button Flags
{
    RI_MOUSE_BUTTON_1_DOWN = 0x0001,
    RI_MOUSE_BUTTON_1_UP   = 0x0002,
    RI_MOUSE_BUTTON_2_DOWN = 0x0004,
    RI_MOUSE_BUTTON_2_UP   = 0x0008,
    RI_MOUSE_BUTTON_3_DOWN = 0x0010,
    RI_MOUSE_BUTTON_3_UP   = 0x0020,
    RI_MOUSE_BUTTON_4_DOWN = 0x0040,
    RI_MOUSE_BUTTON_4_UP   = 0x0080,
    RI_MOUSE_BUTTON_5_DOWN = 0x0100,
    RI_MOUSE_BUTTON_5_UP   = 0x0200,
    RI_MOUSE_WHEEL         = 0x0400,

    RI_MOUSE_LEFT_BUTTON_DOWN   = RI_MOUSE_BUTTON_1_DOWN,
    RI_MOUSE_LEFT_BUTTON_UP     = RI_MOUSE_BUTTON_1_UP,
    RI_MOUSE_RIGHT_BUTTON_DOWN  = RI_MOUSE_BUTTON_2_DOWN,
    RI_MOUSE_RIGHT_BUTTON_UP    = RI_MOUSE_BUTTON_2_UP,
    RI_MOUSE_MIDDLE_BUTTON_DOWN = RI_MOUSE_BUTTON_3_DOWN,
    RI_MOUSE_MIDDLE_BUTTON_UP   = RI_MOUSE_BUTTON_3_UP,
}

enum // Input Message
{
    RIM_INPUT     = 0,
    RIM_INPUTSINK = 1,
}

enum // Window Messages
{
    WM_INPUT_DEVICE_CHANGE = 0x00fe,
    WM_INPUT               = 0x00ff,
}

enum // Input Device Change
{
    GIDC_ARRIVAL = 1,
    GIDC_REMOVAL = 2,
}

alias HANDLE HRAWINPUT;

struct RAWINPUTDEVICELIST
{
	HANDLE hDevice;
	DWORD  dwType;
}

struct RAWINPUTDEVICE
{
    this(USHORT usGenericUsage)
    {
        this.usUsagePage = HID_USAGE_PAGE_GENERIC;
        this.usUsage = usGenericUsage;
    }

    this(USHORT usUsagePage, USHORT usUsage)
    {
        this.usUsagePage = usUsagePage;
        this.usUsage = usUsage;
    }

	USHORT usUsagePage;
	USHORT usUsage;
	DWORD  dwFlags;
	HWND   hwndTarget;
}

struct RID_DEVICE_INFO
{
	DWORD cbSize;
	DWORD dwType;
	union
	{
		RID_DEVICE_INFO_MOUSE    mouse;
		RID_DEVICE_INFO_KEYBOARD keyboard;
		RID_DEVICE_INFO_HID      hid;
	}
}

struct RID_DEVICE_INFO_KEYBOARD
{
	DWORD dwType;
	DWORD dwSubType;
	DWORD dwKeyboardMode;
	DWORD dwNumberOfFunctionKeys;
	DWORD dwNumberOfIndicators;
	DWORD dwNumberOfKeysTotal;
}

struct RID_DEVICE_INFO_MOUSE
{
	DWORD dwId;
	DWORD dwNumberOfButtons;
	DWORD dwSampleRate;
	BOOL  fHasHorizontalWheel;
}

struct RID_DEVICE_INFO_HID
{
	DWORD  dwVendorId;
	DWORD  dwProductId;
	DWORD  dwVersionNumber;
	USHORT usUsagePage;
	USHORT usUsage;
}

struct RAWINPUTHEADER
{
	DWORD  dwType;
	DWORD  dwSize;
	HANDLE hDevice;
	WPARAM wParam;
}

struct RAWINPUT
{
	RAWINPUTHEADER header;
	union
	{
		RAWMOUSE    mouse;
		RAWKEYBOARD keyboard;
		RAWHID      hid;
	}
}

struct RAWHID
{
	DWORD   dwSizeHid;
	DWORD   dwCount;
	BYTE[1] bRawData;
}

struct RAWKEYBOARD
{
	USHORT usMakeCode;
	USHORT usFlags;
	USHORT usReserved;
	USHORT usVKey;
	UINT   uiMessage;
	ULONG  ulExtraInformation;
}

struct RAWMOUSE
{
	USHORT usFlags;
	union
	{
		ULONG ulButtons;
		struct
		{
			USHORT usButtonFlags;
			USHORT usButtonData;
		}
	}
	ULONG ulRawButtons;
	LONG  lLastX;
	LONG  lLastY;
	ULONG ulExtraInformation;
}

alias RAWINPUTDEVICELIST* PRAWINPUTDEVICELIST;
alias RAWINPUTDEVICE*     PRAWINPUTDEVICE;
alias RAWINPUTHEADER*     PRAWINPUTHEADER;
alias RAWINPUT*           PRAWINPUT;
alias RAWKEYBOARD*        PRAWKEYBOARD;
alias RAWMOUSE*           PRAWMOUSE;
alias RAWHID*             PRAWHID;

extern (Windows)
{
    nothrow:
    @nogc:

    LRESULT DefRawInputProc(PRAWINPUT* paRawInput, INT nInput, UINT cbSizeHeader);
    UINT GetRawInputBuffer(PRAWINPUT pData, PUINT pcbSize, UINT cbSizeHeader);
    UINT GetRawInputData(HRAWINPUT hRawInput, UINT uiCommand, LPVOID pData, PUINT pcbSize, UINT cbSizeHeader);
    UINT GetRawInputDeviceInfoW(HANDLE hDevice, UINT uiCommand, LPVOID pData, PUINT pcbSize);
    UINT GetRawInputDeviceList(PRAWINPUTDEVICELIST pRawInputDeviceList, PUINT puiNumDevices, UINT cbSize);
    UINT GetRegisteredRawInputDevices(PRAWINPUTDEVICE pRawInputDevices, PUINT puiNumDevices, UINT cbSize);
    BOOL RegisterRawInputDevices(PRAWINPUTDEVICE pRawInputDevices, UINT uiNumDevices, UINT cbSize);
}

alias GetRawInputDeviceInfoW GetRawInputDeviceInfo;

VOID _DefRawInputProc(PRAWINPUT pRawInput)
{
    LRESULT result = DefRawInputProc(&pRawInput, 1, RAWINPUTHEADER.sizeof);

    if (result != 0)
    {
        throw new WindowsException(cast (DWORD) result);
    }
}

VOID _GetRawInputHeader(HRAWINPUT hRawInput, PRAWINPUTHEADER pRawInputHeader)
{
    UINT cbSize = pRawInputHeader.dwSize;
    UINT result = GetRawInputData(hRawInput, RID_HEADER, pRawInputHeader, &cbSize, RAWINPUTHEADER.sizeof);

    if (result != cbSize)
    {
        throw new WindowsException();
    }
}

UINT _GetRawInputDataSize(HRAWINPUT hRawInput)
{
    UINT cbSize;
    UINT result = GetRawInputData(hRawInput, RID_INPUT, null, &cbSize, RAWINPUTHEADER.sizeof);

    if (result != 0)
    {
        throw new WindowsException();
    }

    return cbSize;
}

VOID _GetRawInputData(HRAWINPUT hRawInput, PRAWINPUT pRawInput, UINT cbSize)
{
    UINT result = GetRawInputData(hRawInput, RID_INPUT, pRawInput, &cbSize, RAWINPUTHEADER.sizeof);

    if (result != cbSize)
    {
        throw new WindowsException();
    }
}

string _GetRawInputDeviceName(HANDLE hDevice)
{
    import std.string : chop;
    import std.utf : toUTF8;

    UINT cbSize;

    SetLastError(0);
    UINT result = GetRawInputDeviceInfo(hDevice, RIDI_DEVICENAME, null, &cbSize);
    DWORD errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    auto deviceName = new WCHAR[cbSize + 1];

    SetLastError(0);
    result = GetRawInputDeviceInfo(hDevice, RIDI_DEVICENAME, deviceName.ptr, &cbSize);
    errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return deviceName[0..cbSize].chop().toUTF8();
}

VOID _GetRawInputDeviceInfo(HANDLE hDevice, RID_DEVICE_INFO* pDeviceInfo)
{
    UINT cbSize = pDeviceInfo.cbSize;

    SetLastError(0);
    GetRawInputDeviceInfo(hDevice, RIDI_DEVICEINFO, pDeviceInfo, &cbSize);
    DWORD errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }
}

BYTE[] _GetRawInputPreparsedData(HANDLE hDevice)
{
    UINT cbSize;

    SetLastError(0);
    UINT result = GetRawInputDeviceInfo(hDevice, RIDI_PREPARSEDDATA, null, &cbSize);
    DWORD errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    auto preparsedData = new BYTE[cbSize];

    SetLastError(0);
    result = GetRawInputDeviceInfo(hDevice, RIDI_PREPARSEDDATA, preparsedData.ptr, &cbSize);
    errorCode = GetLastError();

    if (errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return preparsedData;
}

UINT _GetRawInputDeviceCount()
{
    UINT uiNumDevices;
    UINT result = GetRawInputDeviceList(null, &uiNumDevices, RAWINPUTDEVICELIST.sizeof);

    if (result == cast (UINT) -1)
    {
        throw new WindowsException();
    }

    return uiNumDevices;
}

VOID _GetRawInputDeviceList(PRAWINPUTDEVICELIST pRawInputDeviceList, UINT uiNumDevices)
{
    UINT result = GetRawInputDeviceList(pRawInputDeviceList, &uiNumDevices, RAWINPUTDEVICELIST.sizeof);

    if (result == cast (UINT) -1)
    {
        throw new WindowsException();
    }
}

RAWINPUTDEVICELIST[] _GetRawInputDeviceList()
{
    UINT uiNumDevices;
    UINT result = GetRawInputDeviceList(null, &uiNumDevices, RAWINPUTDEVICELIST.sizeof);

    if (result == cast (UINT) -1)
    {
        throw new WindowsException();
    }

    auto deviceList = new RAWINPUTDEVICELIST[uiNumDevices];
    result = GetRawInputDeviceList(deviceList.ptr, &uiNumDevices, RAWINPUTDEVICELIST.sizeof);

    if (result == cast (UINT) -1)
    {
        throw new WindowsException();
    }

    return deviceList;
}

nothrow @nogc BOOL RegisterRawInputDevices(PRAWINPUTDEVICE pRawInputDevices, UINT uiNumDevices)
{
    return RegisterRawInputDevices(pRawInputDevices, uiNumDevices, RAWINPUTDEVICE.sizeof);
}

VOID _RegisterRawInputDevices(PRAWINPUTDEVICE pRawInputDevices, UINT uiNumDevices)
{
    BOOL result = RegisterRawInputDevices(pRawInputDevices, uiNumDevices, RAWINPUTDEVICE.sizeof);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}
