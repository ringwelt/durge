module durge.system.windows.input.deviceinfo;

version (Windows):

import durge.common;
import durge.system.windows.native.common;
import durge.system.windows.native.hid;
import durge.system.windows.native.rawinput;
import durge.system.windows.native.registry;

class InputDeviceInfo
{
    private DWORD _type;
    private HANDLE _handle;
    private string _name;
    private string _description;
    private string _vendorName;
    private string _productName;
    private string _containerId;
    private USAGE _usagePage;
    private USAGE _usage;
    private bool _connected;
    private bool _enabled;
    private bool _extMouse;
    private PHIDP_PREPARSED_DATA _preparsedData;
    private HIDP_BUTTON_CAPS[] _buttonCaps;
    private HIDP_VALUE_CAPS[] _valueCaps;
    private ULONG _maxUsageListLength;
    private int[] _buttonUsagesDiff;
    private int _keyCount;
    private int _buttonCount;
    private int _axisCount;

    this(HANDLE handle)
    {
        log("InputDeviceInfo.this(0x%08X)", handle);

        enforceEx!ArgumentNullException(handle !is null, "handle");

        RID_DEVICE_INFO info;
        info.cbSize = RID_DEVICE_INFO.sizeof;
        _GetRawInputDeviceInfo(handle, &info);

        _type = info.dwType;
        _handle = handle;
        _name = _GetRawInputDeviceName(handle);
        _vendorName = getVendorName(_name);
        _productName = getProductName(_name);
        _containerId = getContainerId(_name);

        switch (info.dwType)
        {
            case RIM_TYPEKEYBOARD:
            {
                _usagePage = HID_USAGE_PAGE_GENERIC;
                _usage = HID_USAGE_GENERIC_KEYBOARD;
                _keyCount = info.keyboard.dwNumberOfKeysTotal;
                break;
            }

            case RIM_TYPEMOUSE:
            {
                _usagePage = HID_USAGE_PAGE_GENERIC;
                _usage = HID_USAGE_GENERIC_MOUSE;
                _buttonCount = info.mouse.dwNumberOfButtons;
                break;
            }

            case RIM_TYPEHID:
            {
                _usagePage = info.hid.usUsagePage;
                _usage = info.hid.usUsage;

                initHidCaps();
                break;
            }

            default:
            {
                break;
            }
        }

        _description = getDescription();
    }

    @property DWORD type() { return _type; }
    @property HANDLE handle() { return _handle; }
    @property string name() { return _name; }
    @property string description() { return _description; }
    @property string vendorName() { return _vendorName; }
    @property string productName() { return _productName; }
    @property string containerId() { return _containerId; }
    @property USAGE usagePage() { return _usagePage; }
    @property USAGE usage() { return _usage; }
    @property bool connected() { return _connected; }
    @property bool enabled() { return _enabled; }
    @property bool extMouse() { return _extMouse; }
    @property PHIDP_PREPARSED_DATA preparsedData() { return _preparsedData; }
    @property HIDP_BUTTON_CAPS[] buttonCaps() { return _buttonCaps; }
    @property HIDP_VALUE_CAPS[] valueCaps() { return _valueCaps; }
    @property ULONG maxUsageListLength() { return _maxUsageListLength; }
    @property int[] buttonUsagesDiff() { return _buttonUsagesDiff; }

    @property void connected(bool value) { _connected = value; }
    @property void enabled(bool value) { _enabled = value; }
    @property void extMouse(bool value) { _extMouse = value; }

    private string getDeviceRegValue(string deviceName, string valueName)
    {
        import std.algorithm.iteration : splitter;
        import std.array : array;

        scope parts = splitter(deviceName, '#').array;

        if (parts.length == 4 && (parts[0][0..4] == "\\\\?\\" || parts[0][0..4] == "\\??\\"))
        {
            parts[0] = parts[0][4..$];

            auto subKey = "SYSTEM\\\\CurrentControlSet\\\\Enum\\\\" ~ parts[0] ~ "\\\\" ~ parts[1] ~ "\\\\" ~ parts[2];
            auto value = _RegGetStringValue(HKEY_LOCAL_MACHINE, subKey, valueName);

            return value;
        }

        return null;
    }

    private string getVendorName(string deviceName)
    {
        import std.algorithm.iteration : splitter;
        import std.array : array;

        auto value = getDeviceRegValue(deviceName, "Mfg");
        scope parts = splitter(value, ';').array;

        return parts.length >= 2 ? parts[1] : null;
    }

    private string getProductName(string deviceName)
    {
        import std.algorithm.iteration : splitter;
        import std.array : array;

        auto value = getDeviceRegValue(deviceName, "DeviceDesc");
        scope parts = splitter(value, ';').array;

        return parts.length >= 2 ? parts[1] : null;
    }

    private string getContainerId(string deviceName)
    {
        import std.uni : toLower;
        auto value = getDeviceRegValue(deviceName, "ContainerID").toLower();

        if (value != "{00000000-0000-0000-0000-000000000000}" &&
            value != "{00000000-0000-0000-ffff-ffffffffffff}")
        {
            return value;
        }

        return null;
    }

    private string getDescription()
    {
        import std.array : appender;
        import std.string : format;

        string typeStr;

        final switch (_type)
        {
            case RIM_TYPEMOUSE:    typeStr = "SysMouse"; break;
            case RIM_TYPEKEYBOARD: typeStr = "SysKeyboard"; break;
            case RIM_TYPEHID:
            {
                if (_usagePage == HID_USAGE_PAGE_GENERIC)
                {
                    switch (_usage)
                    {
                        case HID_USAGE_GENERIC_POINTER:  typeStr = "HidPointer"; break;
                        case HID_USAGE_GENERIC_MOUSE:    typeStr = "HidMouse"; break;
                        case HID_USAGE_GENERIC_JOYSTICK: typeStr = "HidJoystick"; break;
                        case HID_USAGE_GENERIC_GAMEPAD:  typeStr = "HidGamepad"; break;
                        case HID_USAGE_GENERIC_KEYBOARD: typeStr = "HidKeyboard"; break;
                        case HID_USAGE_GENERIC_KEYPAD:   typeStr = "HidKeypad"; break;
                        case HID_USAGE_GENERIC_MULTI_AXIS_CONTROLLER: typeStr = "HidMultiAxisController"; break;
                        default: break;
                    }
                }

                if (typeStr is null)
                {
                    typeStr = "HidCustom";
                }

                break;
            }
        }

        scope ap = appender!string;
        ap.reserve(48);
        ap ~= typeStr;
        ap ~= " (";

        if (_keyCount > 0)
        {
            ap ~= _keyCount > 1 ? "%s keys".format(_keyCount) : "1 key";
            if (_buttonCount > 0 || _axisCount > 0) ap ~= ", ";
        }

        if (_buttonCount > 0)
        {
            ap ~= _buttonCount > 1 ? "%s buttons".format(_buttonCount) : "1 button";
            if (_axisCount > 0) ap ~= ", ";
        }

        if (_axisCount > 0)
        {
            ap ~= _axisCount > 1 ? "%s axes".format(_axisCount) : "1 axis";
        }

        ap ~= ")";
        return ap.data;
    }

    private void initHidCaps()
    {
        HIDP_CAPS hidCaps;

        // Todo: Alloc non paged memory

        _preparsedData = cast (PHIDP_PREPARSED_DATA) _GetRawInputPreparsedData(handle);
        _HidP_GetCaps(preparsedData, &hidCaps);

        log("LinkCollectionNodes %s InputButtonCaps %s InputValueCaps %s InputDataIndices %s OutputButtonCaps %s OutputValueCaps %s OutputDataIndices %s FeatureButtonCaps %s FeatureValueCaps %s FeatureDataIndices %s", hidCaps.NumberLinkCollectionNodes, hidCaps.NumberInputButtonCaps, hidCaps.NumberInputValueCaps, hidCaps.NumberInputDataIndices, hidCaps.NumberOutputButtonCaps, hidCaps.NumberOutputValueCaps, hidCaps.NumberOutputDataIndices, hidCaps.NumberFeatureButtonCaps, hidCaps.NumberFeatureValueCaps, hidCaps.NumberFeatureDataIndices);

        initHidButtons(&hidCaps);
        initHidValues(&hidCaps);
    }

    private void initHidButtons(PHIDP_CAPS hidCaps)
    {
        USHORT buttonCapsLength = hidCaps.NumberInputButtonCaps;

        if (buttonCapsLength > 0)
        {
            _buttonCaps = new HIDP_BUTTON_CAPS[buttonCapsLength + 1];
            _HidP_GetButtonCaps(HIDP_REPORT_TYPE.HidP_Input, _buttonCaps.ptr, &buttonCapsLength, _preparsedData);
            _buttonCaps = _buttonCaps[0..buttonCapsLength];
            _buttonUsagesDiff = new int[buttonCapsLength];

            auto usagesDiff = 0;

            foreach (i, ref caps; _buttonCaps)
            {
                import std.algorithm.comparison : max;
                _maxUsageListLength = max(_maxUsageListLength, _HidP_MaxUsageListLength(HIDP_REPORT_TYPE.HidP_Input, caps.UsagePage, _preparsedData));

                if (!caps.IsRange)
                {
                    caps.Range.UsageMin = caps.Range.UsageMax = caps.NotRange.Usage;
                    caps.Range.DataIndexMin = caps.Range.DataIndexMax = caps.NotRange.DataIndex;
                    caps.IsRange = true;
                }

                _buttonCount += caps.Range.UsageMax - caps.Range.UsageMin + 1;

                if (caps.UsagePage == HID_USAGE_PAGE_BUTTON)
                {
                    _buttonUsagesDiff[i] = caps.Range.UsageMin - 1;
                    usagesDiff += caps.Range.UsageMax - caps.Range.UsageMin + 1;
                }
            }

            foreach (i, ref caps; _buttonCaps)
            {
                if (caps.UsagePage != HID_USAGE_PAGE_BUTTON)
                {
                    _buttonUsagesDiff[i] = caps.Range.UsageMin - usagesDiff;
                    usagesDiff += caps.Range.UsageMax - caps.Range.UsageMin + 1;
                }
            }
        }
    }

    private void initHidValues(PHIDP_CAPS hidCaps)
    {
        USHORT valueCapsLength = hidCaps.NumberInputValueCaps;

        if (valueCapsLength > 0)
        {
            _valueCaps = new HIDP_VALUE_CAPS[valueCapsLength + 1];
            _HidP_GetValueCaps(HIDP_REPORT_TYPE.HidP_Input, _valueCaps.ptr, &valueCapsLength, _preparsedData);
            _valueCaps = _valueCaps[0..valueCapsLength];

            foreach (ref caps; _valueCaps)
            {
                if (!caps.IsRange)
                {
                    caps.Range.UsageMin = caps.Range.UsageMax = caps.NotRange.Usage;
                    caps.Range.DataIndexMin = caps.Range.DataIndexMax = caps.NotRange.DataIndex;
                    caps.IsRange = true;
                }

                _axisCount += caps.Range.UsageMax - caps.Range.UsageMin + 1;
            }
        }
    }
}
