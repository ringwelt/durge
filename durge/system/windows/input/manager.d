module durge.system.windows.input.manager;

version (Windows):

import durge.common;
import durge.system.input.manager;
import durge.system.windows.input.deviceinfo;
import durge.system.windows.native.common;
import durge.system.windows.native.hid;
import durge.system.windows.native.keyboard;
import durge.system.windows.native.rawinput;
import durge.system.windows.window;

private immutable int[256] virtualkeyMap =
[
    0, 0, 0, 0, 0, 0, 0, 0,
    KeyCode.Backspace, KeyCode.Tab,
    0, 0, 0,
    KeyCode.Return,
    0, 0, 0, 0, 0,
    KeyCode.Pause, KeyCode.CapsLock,
    0, 0, 0, 0, 0, 0,
    KeyCode.Escape,
    0, 0, 0, 0,
    KeyCode.Space, KeyCode.PageUp, KeyCode.PageDown, KeyCode.End, KeyCode.Home,
    KeyCode.Left, KeyCode.Up, KeyCode.Right, KeyCode.Down,
    0, 0,
    KeyCode.NumEnter, KeyCode.Print, KeyCode.Insert, KeyCode.Delete,
    0,
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    0, 0, 0, 0, 0, 0, 0,
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    KeyCode.LeftMeta, KeyCode.RightMeta, KeyCode.ContextMenu,
    0, 0,
    KeyCode.Num0, KeyCode.Num1, KeyCode.Num2, KeyCode.Num3, KeyCode.Num4,
    KeyCode.Num5, KeyCode.Num6, KeyCode.Num7, KeyCode.Num8, KeyCode.Num9,
    KeyCode.NumMultiply, KeyCode.NumAdd,
    0,
    KeyCode.NumSubtract, KeyCode.NumDecimal, KeyCode.NumDivide,
    KeyCode.F1, KeyCode.F2, KeyCode.F3, KeyCode.F4, KeyCode.F5, KeyCode.F6, KeyCode.F7, KeyCode.F8,
    KeyCode.F9, KeyCode.F10, KeyCode.F11, KeyCode.F12, KeyCode.F13, KeyCode.F14, KeyCode.F15, KeyCode.F16,
    KeyCode.F17, KeyCode.F18, KeyCode.F19, KeyCode.F20, KeyCode.F21, KeyCode.F22, KeyCode.F23, KeyCode.F24,
    0, 0, 0, 0, 0, 0, 0, 0,
    KeyCode.NumLock, KeyCode.ScrollLock,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    KeyCode.LeftShift, KeyCode.RightShift, KeyCode.LeftControl, KeyCode.RightControl, KeyCode.LeftAlt, KeyCode.RightAlt,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    KeyCode.OemLeftBracket, KeyCode.OemRightBracket, KeyCode.OemComma, KeyCode.OemSlash, KeyCode.OemPeriod, KeyCode.OemBackslash, KeyCode.OemSemicolon,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    KeyCode.OemMinusSign, KeyCode.OemBackquote, KeyCode.OemEqualSign, KeyCode.OemSingleQuote,
    0, 0, 0,
    KeyCode.OemLeftAngle,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];

private immutable int[256] hidGenericUsageMap =
[
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, KeyCode.PadStart, KeyCode.PadSelect,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    KeyCode.DpadUp, KeyCode.DpadDown, KeyCode.DpadRight, KeyCode.DpadLeft, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];

final class WindowsInputManager : InputManager
{
    private Window _window;
    private bool _enabled;
    private BYTE[] _rawInputBuffer;
    private USAGE[] _usageList;
    private InputDeviceInfo[] _devices;
    private RAWINPUTDEVICE[] _rids;

    this(Window window)
    {
        log("WindowsInputManager.this()");

        enforceEx!ArgumentNullException(window !is null, "window");

        super();
        _window = window;

        _rids =
        [
            RAWINPUTDEVICE(HID_USAGE_GENERIC_POINTER),
            RAWINPUTDEVICE(HID_USAGE_GENERIC_MOUSE),
            RAWINPUTDEVICE(HID_USAGE_GENERIC_JOYSTICK),
            RAWINPUTDEVICE(HID_USAGE_GENERIC_GAMEPAD),
            RAWINPUTDEVICE(HID_USAGE_GENERIC_KEYBOARD),
            RAWINPUTDEVICE(HID_USAGE_GENERIC_KEYPAD),
            RAWINPUTDEVICE(HID_USAGE_GENERIC_MULTI_AXIS_CONTROLLER),
        ];
    }

    nothrow @nogc void dispose()
    {
        foreach (ref rid; _rids)
        {
            rid.dwFlags = RIDEV_REMOVE;
            rid.hwndTarget = null;
        }

        RegisterRawInputDevices(_rids.ptr, cast (UINT) _rids.length);
        _enabled = false;
    }

    @property bool enabled() { return _enabled; }

    bool initDevices()
    {
        log("WindowsInputManager.initDevices()");

        scope rids = _GetRawInputDeviceList();
        auto modified = false;

        // Check if new devices exist

        foreach (ref rid; rids)
        {
            import std.algorithm.iteration : filter;
            auto device = _devices.filter!(d => d.handle == rid.hDevice).frontOrNull;

            if (device is null)
            {
                _devices ~= new InputDeviceInfo(rid.hDevice);
                modified = true;
            }
        }

        // Check if devices are connected

        foreach (device; _devices)
        {
            auto connected = testConnected(device);
            modified = modified || connected != device.connected;
            device.connected = connected;
        }

        if (modified)
        {
            // Enable standard devices

            foreach (device; _devices)
            {
                device.enabled = device.connected && device.usagePage == HID_USAGE_PAGE_GENERIC && (
                    device.usage == HID_USAGE_GENERIC_POINTER || device.usage == HID_USAGE_GENERIC_MOUSE ||
                    device.usage == HID_USAGE_GENERIC_JOYSTICK || device.usage == HID_USAGE_GENERIC_GAMEPAD ||
                    device.usage == HID_USAGE_GENERIC_KEYBOARD || device.usage == HID_USAGE_GENERIC_KEYPAD ||
                    device.usage == HID_USAGE_GENERIC_MULTI_AXIS_CONTROLLER);
            }

            // Enable hid devices which extend standard mouse devices

            foreach (device1; _devices) if (device1.type == RIM_TYPEMOUSE && device1.containerId !is null)
            foreach (device2; _devices) if (device2.type == RIM_TYPEHID && device2.containerId == device1.containerId)
            {
                device2.enabled = device2.connected;
                device2.extMouse = true;
            }

            // Reserve memory for hid usage list

            ULONG maxUsageListLength = cast (ULONG) _usageList.length;

            foreach (device; _devices) if (device.type == RIM_TYPEHID && device.connected && device.enabled)
            {
                import std.algorithm.comparison : max;
                maxUsageListLength = max(maxUsageListLength, device.maxUsageListLength);
            }

            if (maxUsageListLength > 0 && maxUsageListLength > _usageList.length)
            {
                delete _usageList;
                _usageList = new USAGE[maxUsageListLength];
            }

            // Debug log devices

            foreach (device; _devices)
            {
                log("Device: 0x%08X %s %s %s %s", device.handle, device.description, device.containerId, device.connected ? "connected" : "" , device.enabled ? "enabled" : "");

                auto i = 0;
  
                foreach (ref caps; device.buttonCaps)
                for (auto usage = caps.Range.UsageMin, dataIndex = caps.Range.DataIndexMin; usage <= caps.Range.UsageMax; usage++, dataIndex++, i++)
                {
                    log(" Button %02s usagePage 0x%04X usage 0x%04X dataIndex %02s # %s", i, caps.UsagePage, usage, dataIndex, getUsageName(caps.UsagePage, usage));
                }

                i = 0;

                foreach (ref caps; device.valueCaps)
                for (auto usage = caps.Range.UsageMin, dataIndex = caps.Range.DataIndexMin; usage <= caps.Range.UsageMax; usage++, dataIndex++, i++)
                {
                    log(" Axis   %02s usagePage 0x%04X usage 0x%04X dataIndex %02s # %s", i, caps.UsagePage, usage, dataIndex, getUsageName(caps.UsagePage, usage));
                }
            }
        }

        return modified;
    }

    private bool testConnected(InputDeviceInfo device)
    {
        import std.utf : toUTF16z;
        import durge.system.windows.native.file;

        HANDLE deviceHandle = CreateFile(device.name.toUTF16z(), 0, FILE_SHARE_READ | FILE_SHARE_WRITE, null, OPEN_EXISTING, 0, null);

        if (deviceHandle == cast (HANDLE) INVALID_HANDLE_VALUE)
        {
            auto errorCode = GetLastError();

            if (errorCode == ERROR_FILE_NOT_FOUND)
            {
                return false;
            }

            throw new WindowsException(errorCode);
        }

        CloseHandle(deviceHandle);
        return true;
    }

    private string getUsageName(USHORT usagePage, USHORT usage)
    {
        if (usagePage == HID_USAGE_PAGE_GENERIC)
        {
            switch (usage)
            {
                case 0x30: return "X";
                case 0x31: return "Y";
                case 0x32: return "Z";
                case 0x33: return "Rx";
                case 0x34: return "Ry";
                case 0x35: return "Rz";
                case 0x36: return "Slider";
                case 0x37: return "Dial";
                case 0x38: return "Wheel";
                case 0x39: return "Hat Switch";
                case 0x3A: return "Counted Buffer";
                case 0x3B: return "Byte Count";
                case 0x3C: return "Motion Wakeup";
                case 0x3D: return "Start";
                case 0x3E: return "Select";

                case 0x40: return "Vx";
                case 0x41: return "Vy";
                case 0x42: return "Vz";
                case 0x43: return "Vbrx";
                case 0x44: return "Vbry";
                case 0x45: return "Vbrz";
                case 0x46: return "Vno";
                case 0x47: return "Feature Notification";
                case 0x48: return "Resolution Multiplier";

                case 0x80: return "System Control";

                case 0x90: return "Dpad Up";
                case 0x91: return "Dpad Down";
                case 0x92: return "Dpad Right";
                case 0x93: return "Dpad Left";
                default: break;
            }
        }
        else if (usagePage == HID_USAGE_PAGE_SIMULATION)
        {
            switch (usage)
            {
                case 0xC4: return "Accelerator";
                case 0xC5: return "Brake";
                default: break;
            }
        }
        else if (usagePage == HID_USAGE_PAGE_BUTTON)
        {
            switch (usage)
            {
                case 0x01: return "Button Primary";
                case 0x02: return "Button Secondary";
                case 0x03: return "Button Tertiary";
                default: break;
            }

            import std.string : format;
            return "Button %s".format(usage);
        }

        return "Unknown";
    }

    void setEnabled(bool enabled)
    {
        log("WindowsInputManager.setEnabled(%s)", enabled);

        foreach (device; _devices)
        {
            if (device.enabled)
            {
                import std.algorithm.iteration : filter;
                auto ridr = _rids.filter!(r => r.usUsagePage == device.usagePage && r.usUsage == device.usage);

                if (ridr.empty)
                {
                    _rids ~= RAWINPUTDEVICE(device.usagePage, device.usage);
                }
            }
        }

        foreach (ref rid; _rids)
        {
            if (enabled)
            {
                rid.dwFlags = RIDEV_DEVNOTIFY;
                rid.hwndTarget = _window.handle;

                if (rid.usUsagePage == HID_USAGE_PAGE_GENERIC && rid.usUsage == HID_USAGE_GENERIC_KEYBOARD ||
                    rid.usUsagePage == HID_USAGE_PAGE_GENERIC && rid.usUsage == HID_USAGE_GENERIC_MOUSE)
                {
                    rid.dwFlags |= RIDEV_NOLEGACY | RIDEV_NOHOTKEYS;
                }
            }
            else
            {
                rid.dwFlags = RIDEV_REMOVE;
                rid.hwndTarget = null;
            }
        }

        _RegisterRawInputDevices(_rids.ptr, cast (UINT) _rids.length);
        _enabled = enabled;
    }

    void parseInput(HRAWINPUT hRawInput)
    {
        enforceEx!ArgumentNullException(hRawInput !is null, "hRawInput");

        auto size = _GetRawInputDataSize(hRawInput);
        ensureBufferSize(size);

        auto pRawInput = cast (PRAWINPUT) _rawInputBuffer.ptr;
        _GetRawInputData(hRawInput, pRawInput, size);

        //log("0x%08X", pRawInput.header.hDevice);

        import std.algorithm.iteration : filter;
        auto device = _devices.filter!(d => d.handle == pRawInput.header.hDevice).frontOrNull;

        if (device !is null && device.enabled)
        {
            switch (pRawInput.header.dwType)
            {
                case RIM_TYPEKEYBOARD: parseKeyboardInput(&pRawInput.keyboard); return;
                case RIM_TYPEMOUSE: parseMouseInput(&pRawInput.mouse); return;
                case RIM_TYPEHID: parseHidInput(device, &pRawInput.hid); return;
                default: break;
            }
        }

        _DefRawInputProc(pRawInput); 
    }

    private void ensureBufferSize(int size)
    {
        if (_rawInputBuffer.length < size)
        {
            // Todo: Alloc non paged memory

            delete _rawInputBuffer;
            _rawInputBuffer = new ubyte[size];
        }
    }

    private void parseKeyboardInput(PRAWKEYBOARD pRawKeyboard)
    {
        USHORT virtualKey = pRawKeyboard.usVKey;
        USHORT scanCode = pRawKeyboard.usMakeCode;
        auto isDown = (pRawKeyboard.usFlags & RI_KEY_BREAK) == 0;
        auto isE0 = (pRawKeyboard.usFlags & RI_KEY_E0) != 0;
        auto isE1 = (pRawKeyboard.usFlags & RI_KEY_E1) != 0;

        if (virtualKey == 255)
        {
            return;
        }

        fixKeyCodes(virtualKey, scanCode, isE0, isE1);

        auto keyCode = virtualkeyMap[virtualKey & 0xff];
        setKey(keyCode, isDown);
    }

    private void fixKeyCodes(ref USHORT virtualKey, ref USHORT scanCode, bool isE0, bool isE1)
    {
        switch (virtualKey)
        {
            case VK_SHIFT: virtualKey = cast (USHORT) _MapVirtualKey(scanCode, MAPVK_VSC_TO_VK_EX); break; // Determine VK_LSHIFT and VK_RSHIFT
            case VK_NUMLOCK: scanCode = cast (USHORT) _MapVirtualKey(virtualKey, MAPVK_VK_TO_VSC) | 0x100; break; // Change PAUSE to NUMLOCK
            case VK_PAUSE: if (isE1) scanCode = 0x45; break; // Change CONTROL to PAUSE
            default: break;
        }

        if (isE0)
        {
            switch (virtualKey)
            {
                case VK_CONTROL: virtualKey = VK_RCONTROL; break;
                case VK_MENU:    virtualKey = VK_RMENU;    break;
                case VK_RETURN:  virtualKey = VK_EXECUTE;  break; // Instead of missing VK_NUMPADENTER
                default: break;
            }
        }
        else
        {
            switch (virtualKey)
            {
                case VK_CONTROL: virtualKey = VK_LCONTROL; break;
                case VK_MENU:    virtualKey = VK_LMENU;    break;
                case VK_END:     virtualKey = VK_NUMPAD1;  break;
                case VK_DOWN:    virtualKey = VK_NUMPAD2;  break;
                case VK_NEXT:    virtualKey = VK_NUMPAD3;  break;
                case VK_LEFT:    virtualKey = VK_NUMPAD4;  break;
                case VK_CLEAR:   virtualKey = VK_NUMPAD5;  break;
                case VK_RIGHT:   virtualKey = VK_NUMPAD6;  break;
                case VK_HOME:    virtualKey = VK_NUMPAD7;  break;
                case VK_UP:      virtualKey = VK_NUMPAD8;  break;
                case VK_PRIOR:   virtualKey = VK_NUMPAD9;  break;
                case VK_INSERT:  virtualKey = VK_NUMPAD0;  break;
                case VK_DELETE:  virtualKey = VK_DECIMAL;  break;
                default: break;
            }
        }

        if (isE1)
        {
            scanCode = cast (USHORT) _MapVirtualKey(virtualKey, MAPVK_VK_TO_VSC);
        }
    }

    private void parseMouseInput(PRAWMOUSE pRawMouse)
    {
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_1_DOWN) setKey(KeyCode.Mouse1, true);
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_1_UP)   setKey(KeyCode.Mouse1, false);
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_2_DOWN) setKey(KeyCode.Mouse2, true);
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_2_UP)   setKey(KeyCode.Mouse2, false);
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_3_DOWN) setKey(KeyCode.Mouse3, true);
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_3_UP)   setKey(KeyCode.Mouse3, false);
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_4_DOWN) setKey(KeyCode.Mouse4, true);
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_4_UP)   setKey(KeyCode.Mouse4, false);
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_5_DOWN) setKey(KeyCode.Mouse5, true);
        if (pRawMouse.usButtonFlags & RI_MOUSE_BUTTON_5_UP)   setKey(KeyCode.Mouse5, false);

        if (pRawMouse.usButtonFlags & RI_MOUSE_WHEEL)
        {
            auto wheelDelta = cast (SHORT) pRawMouse.usButtonData;

            setKey(KeyCode.MouseWheelUp, wheelDelta > 0, true);
            setKey(KeyCode.MouseWheelDown, wheelDelta < 0, true);
        }

        if (pRawMouse.lLastX != 0 || pRawMouse.lLastY != 0)
        {
            log("mx %02s my %02s", pRawMouse.lLastX, pRawMouse.lLastY);
        }

        /*log("Flags %s Buttons %s Flags %s Data %s Raw %s LastX %s LastY %s Extra %s",
            pRawMouse.usFlags,
            pRawMouse.ulButtons,
            pRawMouse.usButtonFlags,
            pRawMouse.usButtonData,
            pRawMouse.ulRawButtons,
            pRawMouse.lLastX,
            pRawMouse.lLastY,
            pRawMouse.ulExtraInformation);*/
    }

    private void parseHidInput(InputDeviceInfo device, PRAWHID pRawHid)
    {
        for (auto i = 0; i < pRawHid.dwCount; i++)
        {
            auto a = i * pRawHid.dwSizeHid;
            auto b = a + pRawHid.dwSizeHid;
            auto report = (cast (PCHAR) &pRawHid.bRawData[0])[a..b];

            import std.string : format;
            auto s = "0x";
            foreach (c; report) s ~= format("%02X", c);
            log(s);

            parseHidButtons(device, report);
            parseHidValues(device, report);
        }
    }

    private void parseHidButtons(InputDeviceInfo device, CHAR[] report)
    {
        auto baseKeyCode = device.extMouse ? KeyCode.Mouse1 : KeyCode.Button1;
        auto minButton = device.extMouse ? 5 : 0;
        auto maxButton = device.extMouse ? 31 : 127;

        for (auto button = minButton; button <= maxButton; button++)
        {
            //setKey(baseKeyCode + button, false);
        }

        /*setKey(KeyCode.DpadLeft, false);
        setKey(KeyCode.DpadRight, false);
        setKey(KeyCode.DpadUp, false);
        setKey(KeyCode.DpadDown, false);
        setKey(KeyCode.PadStart, false);
        setKey(KeyCode.PadSelect, false);*/

        foreach (i, ref caps; device.buttonCaps)
        {
            ULONG usageListLength = cast (ULONG) _usageList.length;
            _HidP_GetUsages(HIDP_REPORT_TYPE.HidP_Input, caps.UsagePage, 0, _usageList.ptr, &usageListLength, device.preparsedData, report.ptr, cast (ULONG) report.length);

            foreach (usage; _usageList)
            {
                if (caps.UsagePage == HID_USAGE_PAGE_GENERIC && usage < hidGenericUsageMap.length)
                {
                    auto keyCode = hidGenericUsageMap[usage];

                    if (keyCode != KeyCode.Unknown)
                    {
                        setKey(keyCode, true);
                        continue;
                    }
                }

                auto button = usage - device.buttonUsagesDiff[i];

                if (button >= minButton && button <= maxButton)
                {
                    setKey(baseKeyCode + button, true);
                }
            }
        }
    }

    private void parseHidValues(InputDeviceInfo device, CHAR[] report)
    {
        foreach (ref caps; device.valueCaps)
        {
            for (auto i = 0, usage = caps.Range.UsageMin; usage <= caps.Range.UsageMax; i++, usage++)
            {
                ULONG usageValue;
                _HidP_GetUsageValue(HIDP_REPORT_TYPE.HidP_Input, caps.UsagePage, 0, usage, &usageValue, device.preparsedData, report.ptr, cast (ULONG) report.length);

                log("bf %s bs %s di %s nu %s abs %s lmi %s lma %s pmi %s pma %s u %s ue %s val %s", caps.BitField, caps.BitSize, caps.Range.DataIndexMin + i, caps.HasNull, caps.IsAbsolute, caps.LogicalMin, caps.LogicalMax, caps.PhysicalMin, caps.PhysicalMax, caps.Units, caps.UnitsExp, usageValue);
            }
        }
    }
}
