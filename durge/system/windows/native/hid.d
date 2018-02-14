module durge.system.windows.native.hid;

version (Windows):

import durge.system.windows.native.common;

enum // General
{
    FACILITY_HID_ERROR_CODE = 0x11,
}

enum // Error Codes
{
    HIDP_STATUS_SUCCESS                  = HIDP_ERROR_CODES(0x00, 0x00),
    HIDP_STATUS_NULL                     = HIDP_ERROR_CODES(0x08, 0x01),
    HIDP_STATUS_INVALID_PREPARSED_DATA   = HIDP_ERROR_CODES(0x0C, 0x01),
    HIDP_STATUS_INVALID_REPORT_TYPE      = HIDP_ERROR_CODES(0x0C, 0x02),
    HIDP_STATUS_INVALID_REPORT_LENGTH    = HIDP_ERROR_CODES(0x0C, 0x03),
    HIDP_STATUS_USAGE_NOT_FOUND          = HIDP_ERROR_CODES(0x0C, 0x04),
    HIDP_STATUS_VALUE_OUT_OF_RANGE       = HIDP_ERROR_CODES(0x0C, 0x05),
    HIDP_STATUS_BAD_LOG_PHY_VALUES       = HIDP_ERROR_CODES(0x0C, 0x06),
    HIDP_STATUS_BUFFER_TOO_SMALL         = HIDP_ERROR_CODES(0x0C, 0x07),
    HIDP_STATUS_INTERNAL_ERROR           = HIDP_ERROR_CODES(0x0C, 0x08),
    HIDP_STATUS_I8042_TRANS_UNKNOWN      = HIDP_ERROR_CODES(0x0C, 0x09),
    HIDP_STATUS_INCOMPATIBLE_REPORT_ID   = HIDP_ERROR_CODES(0x0C, 0x0A),
    HIDP_STATUS_NOT_VALUE_ARRAY          = HIDP_ERROR_CODES(0x0C, 0x0B),
    HIDP_STATUS_IS_VALUE_ARRAY           = HIDP_ERROR_CODES(0x0C, 0x0C),
    HIDP_STATUS_DATA_INDEX_NOT_FOUND     = HIDP_ERROR_CODES(0x0C, 0x0D),
    HIDP_STATUS_DATA_INDEX_OUT_OF_RANGE  = HIDP_ERROR_CODES(0x0C, 0x0E),
    HIDP_STATUS_BUTTON_NOT_PRESSED       = HIDP_ERROR_CODES(0x0C, 0x0F),
    HIDP_STATUS_REPORT_DOES_NOT_EXIST    = HIDP_ERROR_CODES(0x0C, 0x10),
    HIDP_STATUS_NOT_IMPLEMENTED          = HIDP_ERROR_CODES(0x0C, 0x20),
}

enum // Usage Page
{
    HID_USAGE_PAGE_UNDEFINED  = 0x00,
    HID_USAGE_PAGE_GENERIC    = 0x01,
    HID_USAGE_PAGE_SIMULATION = 0x02,
    HID_USAGE_PAGE_BUTTON     = 0x09,
}

enum // Generic Device Usage
{
    HID_USAGE_GENERIC_ALL                   = 0x00,
    HID_USAGE_GENERIC_POINTER               = 0x01,
    HID_USAGE_GENERIC_MOUSE                 = 0x02,
    HID_USAGE_GENERIC_JOYSTICK              = 0x04,
    HID_USAGE_GENERIC_GAMEPAD               = 0x05,
    HID_USAGE_GENERIC_KEYBOARD              = 0x06,
    HID_USAGE_GENERIC_KEYPAD                = 0x07,
    HID_USAGE_GENERIC_MULTI_AXIS_CONTROLLER = 0x08,
}

enum // Generic Control Usage
{
    HID_USAGE_GENERIC_X          = 0x30,
    HID_USAGE_GENERIC_Y          = 0x31,
    HID_USAGE_GENERIC_Z          = 0x32,
    HID_USAGE_GENERIC_RX         = 0x33,
    HID_USAGE_GENERIC_RY         = 0x34,
    HID_USAGE_GENERIC_RZ         = 0x35,
    HID_USAGE_GENERIC_SLIDER     = 0x36,  
    HID_USAGE_GENERIC_DIAL       = 0x37,
    HID_USAGE_GENERIC_WHEEL      = 0x38,
    HID_USAGE_GENERIC_HATSWITCH  = 0x39,
    HID_USAGE_GENERIC_DPAD_UP    = 0x90,
    HID_USAGE_GENERIC_DPAD_DOWN  = 0x91,
    HID_USAGE_GENERIC_DPAD_RIGHT = 0x92,
    HID_USAGE_GENERIC_DPAD_LEFT  = 0x93,
}

enum HIDP_REPORT_TYPE
{
    HidP_Input,
    HidP_Output,
    HidP_Feature,
}

alias LONG   NTSTATUS;
alias USHORT USAGE;
alias USAGE* PUSAGE;

struct HIDP_PREPARSED_DATA;

struct HIDP_CAPS
{
    USAGE  Usage;
    USAGE  UsagePage;
    USHORT InputReportByteLength;
    USHORT OutputReportByteLength;
    USHORT FeatureReportByteLength;
    USHORT[17] Reserved;
    USHORT NumberLinkCollectionNodes;
    USHORT NumberInputButtonCaps;
    USHORT NumberInputValueCaps;
    USHORT NumberInputDataIndices;
    USHORT NumberOutputButtonCaps;
    USHORT NumberOutputValueCaps;
    USHORT NumberOutputDataIndices;
    USHORT NumberFeatureButtonCaps;
    USHORT NumberFeatureValueCaps;
    USHORT NumberFeatureDataIndices;
}

struct HIDP_BUTTON_CAPS
{
    USAGE   UsagePage;
    UCHAR   ReportID;
    BOOLEAN IsAlias;
    USHORT  BitField;
    USHORT  LinkCollection;
    USAGE   LinkUsage;
    USAGE   LinkUsagePage;
    BOOLEAN IsRange;
    BOOLEAN IsStringRange;
    BOOLEAN IsDesignatorRange;
    BOOLEAN IsAbsolute;
    ULONG[10] Reserved;
    union
    {
        struct _Range
        {
            USAGE  UsageMin;
            USAGE  UsageMax;
            USHORT StringMin;
            USHORT StringMax;
            USHORT DesignatorMin;
            USHORT DesignatorMax;
            USHORT DataIndexMin;
            USHORT DataIndexMax;
        }
        _Range Range;
        struct _NotRange
        {
            USAGE  Usage;
            USAGE  Reserved1;
            USHORT StringIndex;
            USHORT Reserved2;
            USHORT DesignatorIndex;
            USHORT Reserved3;
            USHORT DataIndex;
            USHORT Reserved4;
        }
        _NotRange NotRange;
    }
}

struct HIDP_VALUE_CAPS
{
    USAGE   UsagePage;
    UCHAR   ReportID;
    BOOLEAN IsAlias;
    USHORT  BitField;
    USHORT  LinkCollection;
    USAGE   LinkUsage;
    USAGE   LinkUsagePage;
    BOOLEAN IsRange;
    BOOLEAN IsStringRange;
    BOOLEAN IsDesignatorRange;
    BOOLEAN IsAbsolute;
    BOOLEAN HasNull;
    UCHAR   Reserved;
    USHORT  BitSize;
    USHORT  ReportCount;
    USHORT[5] Reserved2;
    ULONG   UnitsExp;
    ULONG   Units;
    LONG    LogicalMin;
    LONG    LogicalMax;
    LONG    PhysicalMin;
    LONG    PhysicalMax;
    union
    {
        struct _Range
        {
            USAGE  UsageMin;
            USAGE  UsageMax;
            USHORT StringMin;
            USHORT StringMax;
            USHORT DesignatorMin;
            USHORT DesignatorMax;
            USHORT DataIndexMin;
            USHORT DataIndexMax;
        }
        _Range Range;
        struct _NotRange
        {
            USAGE  Usage;
            USAGE  Reserved1;
            USHORT StringIndex;
            USHORT Reserved2;
            USHORT DesignatorIndex;
            USHORT Reserved3;
            USHORT DataIndex;
            USHORT Reserved4;
        }
        _NotRange NotRange;
    }
}

alias HIDP_PREPARSED_DATA* PHIDP_PREPARSED_DATA;
alias HIDP_CAPS*           PHIDP_CAPS;
alias HIDP_BUTTON_CAPS*    PHIDP_BUTTON_CAPS;
alias HIDP_VALUE_CAPS*     PHIDP_VALUE_CAPS;

extern (Windows)
{
    nothrow:
    @nogc:

    NTSTATUS HidP_GetButtonCaps(HIDP_REPORT_TYPE ReportType, PHIDP_BUTTON_CAPS ButtonCaps, PUSHORT ButtonCapsLength, PHIDP_PREPARSED_DATA PreparsedData);
    NTSTATUS HidP_GetCaps(PHIDP_PREPARSED_DATA PreparsedData, PHIDP_CAPS Capabilities);
    NTSTATUS HidP_GetUsages(HIDP_REPORT_TYPE ReportType, USAGE UsagePage, USHORT LinkCollection, PUSAGE UsageList, PULONG UsageLength, PHIDP_PREPARSED_DATA PreparsedData, PCHAR Report, ULONG ReportLength);
    NTSTATUS HidP_GetUsageValue(HIDP_REPORT_TYPE ReportType, USAGE UsagePage, USHORT LinkCollection, USAGE Usage, PULONG UsageValue, PHIDP_PREPARSED_DATA PreparsedData, PCHAR Report, ULONG ReportLength);
    NTSTATUS HidP_GetValueCaps(HIDP_REPORT_TYPE ReportType, PHIDP_VALUE_CAPS ValueCaps, PUSHORT ValueCapsLength, PHIDP_PREPARSED_DATA PreparsedData);
    ULONG HidP_MaxUsageListLength(HIDP_REPORT_TYPE ReportType, USAGE UsagePage, PHIDP_PREPARSED_DATA PreparsedData);
}

NTSTATUS HIDP_ERROR_CODES(ULONG sev, ULONG code)
{
    return cast (NTSTATUS) ((sev << 28) | (FACILITY_HID_ERROR_CODE << 16) | code);
}

class HidException : WindowsException
{
	this(NTSTATUS errorCode)
	{
        super(errorCode, getErrorMessage(errorCode));
	}

	this(string message)
	{
        super(0, message);
	}

    private string getErrorMessage(NTSTATUS errorCode)
    {
        import std.format : format;

        auto symbol = getHidErrorSymbol(errorCode);
        auto message = getHidErrorMessage(errorCode);

        return message !is null
            ? "%s(0x%08X): %s".format(symbol, errorCode, message)
            : "Unknown error";
    }
}

private string getHidErrorSymbol(NTSTATUS errorCode)
{
    string symbol;

    switch (errorCode)
    {
        case HIDP_STATUS_NULL:                    symbol = "HIDP_STATUS_NULL"; break;
        case HIDP_STATUS_INVALID_PREPARSED_DATA:  symbol = "HIDP_STATUS_INVALID_PREPARSED_DATA"; break;
        case HIDP_STATUS_INVALID_REPORT_TYPE:     symbol = "HIDP_STATUS_INVALID_REPORT_TYPE"; break;
        case HIDP_STATUS_INVALID_REPORT_LENGTH:   symbol = "HIDP_STATUS_INVALID_REPORT_LENGTH"; break;
        case HIDP_STATUS_USAGE_NOT_FOUND:         symbol = "HIDP_STATUS_USAGE_NOT_FOUND"; break;
        case HIDP_STATUS_VALUE_OUT_OF_RANGE:      symbol = "HIDP_STATUS_VALUE_OUT_OF_RANGE"; break;
        case HIDP_STATUS_BAD_LOG_PHY_VALUES:      symbol = "HIDP_STATUS_BAD_LOG_PHY_VALUES"; break;
        case HIDP_STATUS_BUFFER_TOO_SMALL:        symbol = "HIDP_STATUS_BUFFER_TOO_SMALL"; break;
        case HIDP_STATUS_INTERNAL_ERROR:          symbol = "HIDP_STATUS_INTERNAL_ERROR"; break;
        case HIDP_STATUS_I8042_TRANS_UNKNOWN:     symbol = "HIDP_STATUS_I8042_TRANS_UNKNOWN"; break;
        case HIDP_STATUS_INCOMPATIBLE_REPORT_ID:  symbol = "HIDP_STATUS_INCOMPATIBLE_REPORT_ID"; break;
        case HIDP_STATUS_NOT_VALUE_ARRAY:         symbol = "HIDP_STATUS_NOT_VALUE_ARRAY"; break;
        case HIDP_STATUS_IS_VALUE_ARRAY:          symbol = "HIDP_STATUS_IS_VALUE_ARRAY"; break;
        case HIDP_STATUS_DATA_INDEX_NOT_FOUND:    symbol = "HIDP_STATUS_DATA_INDEX_NOT_FOUND"; break;
        case HIDP_STATUS_DATA_INDEX_OUT_OF_RANGE: symbol = "HIDP_STATUS_DATA_INDEX_OUT_OF_RANGE"; break;
        case HIDP_STATUS_BUTTON_NOT_PRESSED:      symbol = "HIDP_STATUS_BUTTON_NOT_PRESSED"; break;
        case HIDP_STATUS_REPORT_DOES_NOT_EXIST:   symbol = "HIDP_STATUS_REPORT_DOES_NOT_EXIST"; break;
        case HIDP_STATUS_NOT_IMPLEMENTED:         symbol = "HIDP_STATUS_NOT_IMPLEMENTED"; break;
        default: break;
    }

    return symbol;
}

private string getHidErrorMessage(HRESULT errorCode)
{
    string message;

    switch (errorCode)
    {
        case HIDP_STATUS_NULL:                    message = ""; break;
        case HIDP_STATUS_INVALID_PREPARSED_DATA:  message = "The preparsed data is not valid."; break;
        case HIDP_STATUS_INVALID_REPORT_TYPE:     message = "The report type is not valid."; break;
        case HIDP_STATUS_INVALID_REPORT_LENGTH:   message = "The report length is not valid."; break;
        case HIDP_STATUS_USAGE_NOT_FOUND:         message = "The usage does not exist in any report of the specified report type."; break;
        case HIDP_STATUS_VALUE_OUT_OF_RANGE:      message = ""; break;
        case HIDP_STATUS_BAD_LOG_PHY_VALUES:      message = "A logical or physical value is illegal."; break;
        case HIDP_STATUS_BUFFER_TOO_SMALL:        message = "The buffer is too small."; break;
        case HIDP_STATUS_INTERNAL_ERROR:          message = "Internal error."; break;
        case HIDP_STATUS_I8042_TRANS_UNKNOWN:     message = "A usage in the changed usage list mapped to an invalid keyboard scan code."; break;
        case HIDP_STATUS_INCOMPATIBLE_REPORT_ID:  message = "The usage does not exist in the specified report, but it does exist in a different report of the specified type."; break;
        case HIDP_STATUS_NOT_VALUE_ARRAY:         message = "The usage is not a usage value array."; break;
        case HIDP_STATUS_IS_VALUE_ARRAY:          message = "A data index specifies a usage value array."; break;
        case HIDP_STATUS_DATA_INDEX_NOT_FOUND:    message = "The data index is not valid."; break;
        case HIDP_STATUS_DATA_INDEX_OUT_OF_RANGE: message = "The data index is out of range."; break;
        case HIDP_STATUS_BUTTON_NOT_PRESSED:      message = "A usage is already set to OFF. "; break;
        case HIDP_STATUS_REPORT_DOES_NOT_EXIST:   message = "There are no reports of the specified type."; break;
        case HIDP_STATUS_NOT_IMPLEMENTED:         message = "The report size of data fields specified for the usage value array is not a multiple of eight bits."; break;
        default: break;
    }

    return message;
}

private template callHidFunc()
{
    void callHidFunc(NTSTATUS)(lazy NTSTATUS expression)
    {
        NTSTATUS result = expression();

        if (result != HIDP_STATUS_SUCCESS)
        {
            throw new HidException(result);
        }
    }
}

VOID _HidP_GetButtonCaps(HIDP_REPORT_TYPE ReportType, PHIDP_BUTTON_CAPS ButtonCaps, PUSHORT ButtonCapsLength, PHIDP_PREPARSED_DATA PreparsedData)
{
    callHidFunc!()(HidP_GetButtonCaps(ReportType, ButtonCaps, ButtonCapsLength, PreparsedData));
}

VOID _HidP_GetCaps(PHIDP_PREPARSED_DATA PreparsedData, PHIDP_CAPS Capabilities)
{
    callHidFunc!()(HidP_GetCaps(PreparsedData, Capabilities));
}

VOID _HidP_GetUsages(HIDP_REPORT_TYPE ReportType, USAGE UsagePage, USHORT LinkCollection, PUSAGE UsageList, PULONG UsageLength, PHIDP_PREPARSED_DATA PreparsedData, PCHAR Report, ULONG ReportLength)
{
    callHidFunc!()(HidP_GetUsages(ReportType, UsagePage, LinkCollection, UsageList, UsageLength, PreparsedData, Report, ReportLength));
}

VOID _HidP_GetUsageValue(HIDP_REPORT_TYPE ReportType, USAGE UsagePage, USHORT LinkCollection, USAGE Usage, PULONG UsageValue, PHIDP_PREPARSED_DATA PreparsedData, PCHAR Report, ULONG ReportLength)
{
    callHidFunc!()(HidP_GetUsageValue(ReportType, UsagePage, LinkCollection, Usage, UsageValue, PreparsedData, Report, ReportLength));
}

VOID _HidP_GetValueCaps(HIDP_REPORT_TYPE ReportType, PHIDP_VALUE_CAPS ValueCaps, PUSHORT ValueCapsLength, PHIDP_PREPARSED_DATA PreparsedData)
{
    callHidFunc!()(HidP_GetValueCaps(ReportType, ValueCaps, ValueCapsLength, PreparsedData));
}

ULONG _HidP_MaxUsageListLength(HIDP_REPORT_TYPE ReportType, USAGE UsagePage, PHIDP_PREPARSED_DATA PreparsedData)
{
    ULONG result = HidP_MaxUsageListLength(ReportType, UsagePage, PreparsedData);

    if (result == 0)
    {
        throw new HidException("The report type or preparsed data is not valid.");
    }

    return result;
}
