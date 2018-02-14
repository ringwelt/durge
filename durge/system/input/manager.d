module durge.system.input.manager;

import durge.common;

enum KeyCode
{
    Unknown         = 0x00,
    Cancel          = 0x03,
    Backspace       = 0x08,
    Tab             = 0x09,
    Clear           = 0x0C,
    Return          = 0x0D,
    Shift           = 0x10,
    Control         = 0x11,
    Alt             = 0x12,
    Pause           = 0x13,
    CapsLock        = 0x14,
    Escape          = 0x1B,
    Space           = 0x20,

    // 0-9          = 0x30 - 0x39
    // A-Z          = 0x41 - 0x5A
    // a-z          = 0x61 - 0x7A

    OemSingleQuote  = 0x27,
    OemComma        = 0x2C,
    OemMinusSign    = 0x2D,
    OemPeriod       = 0x2E,
    OemSlash        = 0x2F,
    OemSemicolon    = 0x3B,
    OemLeftAngle    = 0x3C,
    OemEqualSign    = 0x3D,
    OemLeftBracket  = 0x5B,
    OemBackslash    = 0x5C,
    OemRightBracket = 0x5D,
    OemBackquote    = 0x60,

    LeftShift       = 0x80,
    RightShift      = 0x81,
    LeftControl     = 0x82,
    RightControl    = 0x83,
    LeftAlt         = 0x84,
    RightAlt        = 0x85,
    LeftMeta        = 0x86,
    RightMeta       = 0x87,
    ContextMenu     = 0x88,

    Print           = 0x8F,
    NumLock         = 0x90,
    ScrollLock      = 0x91,

    Insert          = 0x94,
    Delete          = 0x95,
    Home            = 0x96,
    End             = 0x97,
    PageUp          = 0x98,
    PageDown        = 0x99,
    Left            = 0x9A,
    Right           = 0x9B,
    Up              = 0x9C,
    Down            = 0x9D,

    Num0            = 0xA0,
    NumInsert       = KeyCode.Num0,
    Num1            = 0xA1,
    Num2            = 0xA2,
    Num3            = 0xA3,
    Num4            = 0xA4,
    Num5            = 0xA5,
    Num6            = 0xA6,
    Num7            = 0xA7,
    Num8            = 0xA8,
    Num9            = 0xA9,
    NumAdd          = 0xAA,
    NumSubtract     = 0xAB,
    NumMultiply     = 0xAC,
    NumDivide       = 0xAD,
    NumDecimal      = 0xAE,
    NumDelete       = KeyCode.NumDecimal,
    NumEnter        = 0xAF,

    F1              = 0xB4,
    F2              = 0xB5,
    F3              = 0xB6,
    F4              = 0xB7,
    F5              = 0xB8,
    F6              = 0xB9,
    F7              = 0xBA,
    F8              = 0xBB,
    F9              = 0xBC,
    F10             = 0xBD,
    F11             = 0xBE,
    F12             = 0xBF,
    F13             = 0xC0,
    F14             = 0xC1,
    F15             = 0xC2,
    F16             = 0xC3,
    F17             = 0xC4,
    F18             = 0xC5,
    F19             = 0xC6,
    F20             = 0xC7,
    F21             = 0xC8,
    F22             = 0xC9,
    F23             = 0xCA,
    F24             = 0xCB,

    Mouse1          = 0xD0,
    Mouse2          = 0xD1,
    Mouse3          = 0xD2,
    Mouse4          = 0xD3,
    Mouse5          = 0xD4,
    Mouse6          = 0xD5,
    Mouse7          = 0xD6,
    Mouse8          = 0xD7,
    Mouse9          = 0xD8,
    Mouse10         = 0xD9,
    Mouse11         = 0xDA,
    Mouse12         = 0xDB,
    Mouse13         = 0xDC,
    Mouse14         = 0xDD,
    Mouse15         = 0xDE,
    Mouse16         = 0xDF,
    Mouse17         = 0xE0,
    Mouse18         = 0xE1,
    Mouse19         = 0xE2,
    Mouse20         = 0xE3,
    Mouse21         = 0xE4,
    Mouse22         = 0xE5,
    Mouse23         = 0xE6,
    Mouse24         = 0xE7,
    Mouse25         = 0xE8,
    Mouse26         = 0xE9,
    Mouse27         = 0xEA,
    Mouse28         = 0xEB,
    Mouse29         = 0xEC,
    Mouse30         = 0xED,
    Mouse31         = 0xEE,
    Mouse32         = 0xEF,

    MouseMoveLeft   = 0xF2,
    MouseMoveRight  = 0xF3,
    MouseMoveUp     = 0xF4,
    MouseMoveDown   = 0xF5,
    MouseWheelUp    = 0xF6,
    MouseWheelDown  = 0xF7,

    Button1         = 0x100,
    Button2         = 0x101,
    Button3         = 0x102,
    Button4         = 0x103,
    Button5         = 0x104,
    Button6         = 0x105,
    Button7         = 0x106,
    Button8         = 0x107,
    Button9         = 0x108,
    Button10        = 0x109,
    Button11        = 0x10A,
    Button12        = 0x10B,
    Button13        = 0x10C,
    Button14        = 0x10D,
    Button15        = 0x10E,
    Button16        = 0x10F,
    Button17        = 0x110,
    Button18        = 0x111,
    Button19        = 0x112,
    Button20        = 0x113,
    Button21        = 0x114,
    Button22        = 0x115,
    Button23        = 0x116,
    Button24        = 0x117,
    Button25        = 0x118,
    Button26        = 0x119,
    Button27        = 0x11A,
    Button28        = 0x11B,
    Button29        = 0x11C,
    Button30        = 0x11D,
    Button31        = 0x11E,
    Button32        = 0x11F,
    Button33        = 0x120,
    Button34        = 0x121,
    Button35        = 0x122,
    Button36        = 0x123,
    Button37        = 0x124,
    Button38        = 0x125,
    Button39        = 0x126,
    Button40        = 0x127,
    Button41        = 0x128,
    Button42        = 0x129,
    Button43        = 0x12A,
    Button44        = 0x12B,
    Button45        = 0x12C,
    Button46        = 0x12D,
    Button47        = 0x12E,
    Button48        = 0x12F,
    Button49        = 0x130,
    Button50        = 0x131,
    Button51        = 0x132,
    Button52        = 0x133,
    Button53        = 0x134,
    Button54        = 0x135,
    Button55        = 0x136,
    Button56        = 0x137,
    Button57        = 0x138,
    Button58        = 0x139,
    Button59        = 0x13A,
    Button60        = 0x13B,
    Button61        = 0x13C,
    Button62        = 0x13D,
    Button63        = 0x13E,
    Button64        = 0x13F,
    Button65        = 0x140,
    Button66        = 0x141,
    Button67        = 0x142,
    Button68        = 0x143,
    Button69        = 0x144,
    Button70        = 0x145,
    Button71        = 0x146,
    Button72        = 0x147,
    Button73        = 0x148,
    Button74        = 0x149,
    Button75        = 0x14A,
    Button76        = 0x14B,
    Button77        = 0x14C,
    Button78        = 0x14D,
    Button79        = 0x14E,
    Button80        = 0x14F,
    Button81        = 0x150,
    Button82        = 0x151,
    Button83        = 0x152,
    Button84        = 0x153,
    Button85        = 0x154,
    Button86        = 0x155,
    Button87        = 0x156,
    Button88        = 0x157,
    Button89        = 0x158,
    Button90        = 0x159,
    Button91        = 0x15A,
    Button92        = 0x15B,
    Button93        = 0x15C,
    Button94        = 0x15D,
    Button95        = 0x15E,
    Button96        = 0x15F,
    Button97        = 0x160,
    Button98        = 0x161,
    Button99        = 0x162,
    Button100       = 0x163,
    Button101       = 0x164,
    Button102       = 0x165,
    Button103       = 0x166,
    Button104       = 0x167,
    Button105       = 0x168,
    Button106       = 0x169,
    Button107       = 0x16A,
    Button108       = 0x16B,
    Button109       = 0x16C,
    Button110       = 0x16D,
    Button111       = 0x16E,
    Button112       = 0x16F,
    Button113       = 0x170,
    Button114       = 0x171,
    Button115       = 0x172,
    Button116       = 0x173,
    Button117       = 0x174,
    Button118       = 0x175,
    Button119       = 0x176,
    Button120       = 0x177,
    Button121       = 0x178,
    Button122       = 0x179,
    Button123       = 0x17A,
    Button124       = 0x17B,
    Button125       = 0x17C,
    Button126       = 0x17D,
    Button127       = 0x17E,
    Button128       = 0x17F,

    DpadLeft        = 0x182,
    DpadRight       = 0x183,
    DpadUp          = 0x184,
    DpadDown        = 0x185,

    PadStart        = 0x186,
    PadSelect       = 0x187,

    Axis1Up         = 0x192,
    Axis1Down       = 0x193,
    Axis2Up         = 0x194,
    Axis2Down       = 0x195,
    Axis3Up         = 0x196,
    Axis3Down       = 0x197,
    Axis4Up         = 0x198,
    Axis4Down       = 0x199,
}

private immutable string[512] keyNames =
[
    "Null",
    "", "",
    "Cancel",
    "", "", "", "",
    "Backspace", "Tab",
    "", "",
    "Clear", "Return",
    "", "",
    "Shift", "Control", "Alt", "Pause", "CapsLock",
    "", "", "", "", "", "",
    "Escape",
    "", "", "", "",
    "Space",
    "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    ":", ";", "<", "=", ">", "?", "@",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "[", "\\", "]", "^", "_", "`",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "{", "|", "}", "~",
    "",
    "Left Shift", "Right Shift", "Left Control", "Right Control",
    "Left Alt", "Right Alt", "Left Windows", "Right Windows", "Context Menu",
    "", "", "", "", "", "",
    "Print", "Num Lock", "Scroll Lock",
    "", "",
    "Insert", "Delete", "Home", "End", "Page Up", "Page Down", "Left", "Right", "Up", "Down",
    "", "",
    "Num 0", "Num 1", "Num 2", "Num 3", "Num 4", "Num 5", "Num 6", "Num 7", "Num 8", "Num 9",
    "Num Add", "Num Sub", "Num Mul", "Num Div", "Num Decimal", "Num Enter",
    "", "", "", "",
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
    "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20", "F21", "F22", "F23", "F24",
    "", "", "", "",
    "Mouse 1", "Mouse 2", "Mouse 3", "Mouse 4", "Mouse 5", "Mouse 6", "Mouse 7", "Mouse 8",
    "Mouse 9", "Mouse 10", "Mouse 11", "Mouse 12", "Mouse 13", "Mouse 14", "Mouse 15", "Mouse 16",
    "Mouse 17", "Mouse 18", "Mouse 19", "Mouse 20", "Mouse 21", "Mouse 22", "Mouse 23", "Mouse 24",
    "Mouse 25", "Mouse 26", "Mouse 27", "Mouse 28", "Mouse 29", "Mouse 30", "Mouse 31", "Mouse 32",
    "", "",
    "Mouse Move Left", "Mouse Move Right", "Mouse Move Up", "Mouse Move Down", "Mouse Wheel Up", "Mouse Wheel Down",
    "", "", "", "", "", "", "", "",
    "Button 1", "Button 2", "Button 3", "Button 4", "Button 5", "Button 6", "Button 7", "Button 8",
    "Button 9", "Button 10", "Button 11", "Button 12", "Button 13", "Button 14", "Button 15", "Button 16",
    "Button 17", "Button 18", "Button 19", "Button 20", "Button 21", "Button 22", "Button 23", "Button 24",
    "Button 25", "Button 26", "Button 27", "Button 28", "Button 29", "Button 30", "Button 31", "Button 32",
    "Button 33", "Button 34", "Button 35", "Button 36", "Button 37", "Button 38", "Button 39", "Button 40",
    "Button 41", "Button 42", "Button 43", "Button 44", "Button 45", "Button 46", "Button 47", "Button 48",
    "Button 49", "Button 50", "Button 51", "Button 52", "Button 53", "Button 54", "Button 55", "Button 56",
    "Button 57", "Button 58", "Button 59", "Button 60", "Button 61", "Button 62", "Button 63", "Button 64",
    "Button 65", "Button 66", "Button 67", "Button 68", "Button 69", "Button 70", "Button 71", "Button 72",
    "Button 73", "Button 74", "Button 75", "Button 76", "Button 77", "Button 78", "Button 79", "Button 80",
    "Button 81", "Button 82", "Button 83", "Button 84", "Button 85", "Button 86", "Button 87", "Button 88",
    "Button 89", "Button 90", "Button 91", "Button 92", "Button 93", "Button 94", "Button 95", "Button 96",
    "Button 97", "Button 98", "Button 99", "Button 100", "Button 101", "Button 102", "Button 103", "Button 104",
    "Button 105", "Button 106", "Button 107", "Button 108", "Button 109", "Button 110", "Button 111", "Button 112",
    "Button 113", "Button 114", "Button 115", "Button 116", "Button 117", "Button 118", "Button 119", "Button 120",
    "Button 121", "Button 122", "Button 123", "Button 124", "Button 125", "Button 126", "Button 127", "Button 128",
    "", "",

    "Axis 1+", "Axis 1-", "Axis 2+", "Axis 2-", "Axis 3+", "Axis 3-", "Axis 4+", "Axis 4-",
    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",

    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",

    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",

    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "",
    "", "", "", "", "", "",
];

enum KeyState
{
    None = 0x00,
    Down = 0x01,
    Up   = 0x02,
}

abstract class InputManager
{
    private KeyState[512] _keyStates;
    private KeyCode[32] _keyBuffer;

    this()
    {
        log("InputManager.this()");
    }

    //pure nothrow @safe
    //{
        @property bool key(int keyCode)
        {
            return (_keyStates[keyCode & 0xff] & KeyState.Down) != 0;
        }

        @property string keyName(int keyCode)
        {
            return keyNames[keyCode & 0xff];
        }

        bool getKey(int keyCode, bool resetKey = false)
        {
            auto isDown = (_keyStates[keyCode & 0xff] & KeyState.Down) != 0;

            if (resetKey)
            {
                _keyStates[keyCode & 0xff] = KeyState.None;
            }

            return isDown;
        }

        protected void setKey(int keyCode, bool isDown, bool isUp = false)
        {
            auto keyState = &_keyStates[keyCode & 0xff];

            if (isDown)
            {
                log("setKey(%s 0x%02X %s %s %s)", keyCode, keyCode, isDown, isUp, keyName(keyCode));

                if (isUp)
                {
                    *keyState |= KeyState.Down | KeyState.Up;
                }
                else
                {
                    *keyState |= KeyState.Down;
                    *keyState &= ~KeyState.Up;
                }
            }
            else if (*keyState & KeyState.Down)
            {
                log("setKey(%s 0x%02X %s %s %s)", keyCode, keyCode, isDown, isUp, keyName(keyCode));

                *keyState |= KeyState.Up;
            }
        }

        void resetKey(int keyCode)
        {
            _keyStates[keyCode & 0xff] = KeyState.None;
        }

        void resetKeys(bool force = false)
        {
            foreach (ref keyState; _keyStates)
            {
                if (keyState & KeyState.Up || force)
                {
                    keyState = KeyState.None;
                }
            }
        }
    //}
}
