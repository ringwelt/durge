module durge.temp;

/+
private void RenderWindowOnDisplayChange(Window window)
{
    if (status == EngineStatus.Running)
    {
        fullscreen = false;
        status = EngineStatus.Restarting;
    }
}

private void RenderWindowOnKeyDown(int key)
{
    if (key == 'Q')
    {
        status = EngineStatus.Stopping;
    }
}

private void RenderWindowOnSwitchFullscreen()
{
    if (status == EngineStatus.Running)
    {
        fullscreen = !fullscreen;
        status = EngineStatus.Restarting;
    }
}

public enum EngineStatus
{
    Starting,
    Running,
    Restarting,
    Stopping
}

private Arguments _arguments;

public @property Arguments arguments()
{
    return _arguments;
}

public EngineStatus status;
public string configFileName;
public bool dedicated;
public bool fullscreen;
public int screenWidth;
public int screenHeight;
public PixelDepth screenDepth;

public this(string[] args)
{
    //_arguments = new Arguments(args);

    //_arguments

    status = EngineStatus.Starting;
    configFileName = "durge.config";
    dedicated = false;
    screenWidth = 640;
    screenHeight = 480;
    screenDepth = PixelDepth.Bits32;
    fullscreen = false;
}

protected abstract Bitmap GetFrameBuffer();
protected abstract void RenderFrameBuffer(Bitmap frameBuffer);

protected bool Frame()
{
	auto frameBuffer = GetFrameBuffer();

	for (auto i = 0; i < 10; i++)
	{
		RenderScene(frameBuffer);
	}

	RenderFPS(frameBuffer);
	RenderFrameBuffer(frameBuffer);

	return true;
}

private void RenderScene(Bitmap frameBuffer)
{
	auto p = cast (uint*) frameBuffer.lines[0];
	//auto j = uniform(0x7f7f7f, 0xffffff);
	auto j = uniform(0x000000, 0xffffff);

	for (auto i = 0; i < screenWidth * screenHeight; i++)
	{
		//*p++ = cast (uint) (uniform(0x7f, 0xff) << 16);
		*p++ = i ^ j;
	}
}

private int _frameIndex;
private long[30] _frameMsecs;
private MonoTime _prevTime;

private void RenderFPS(Bitmap frameBuffer)
{
	auto currTime = MonoTime.currTime;
	auto frameMsecs = (currTime - _prevTime).total!"msecs";

	_prevTime = currTime;
	_frameMsecs[_frameIndex++ % _frameMsecs.length] = frameMsecs;

	auto totalMsecs = 0;

	for (auto i = 0; i < _frameMsecs.length; i++)
	{
		totalMsecs += _frameMsecs[i];
	}

	if (totalMsecs == 0)
	{
		totalMsecs = 1;
	}

	auto fps = 1000 * _frameMsecs.length / totalMsecs;

	if (fps > 300)
	{
		fps = 300;
	}

	for (auto x = 0; x <= 300; x++)
	{
		for (auto y = 1; y <= 6; y++)
		{
			(cast (uint*) frameBuffer.lines[y + 4])[x + 5] = 0x000000;
		}
	}

	for (auto x = 0; x <= 300; x += 50)
	{
		for (auto y = 1; y <= 4; y++)
		{
			(cast (uint*) frameBuffer.lines[y + 4])[x + 5] = 0xafafaf;
		}
	}

	for (auto x = 0; x <= 300; x += 10)
	{
		for (auto y = 5; y <= 6; y++)
		{
			(cast (uint*) frameBuffer.lines[y + 4])[x + 5] = 0xafafaf;
		}
	}

	for (auto x = 0; x < fps; x++)
	{
		(cast (uint*) frameBuffer.lines[7])[x + 5] = 0xffffff;
		(cast (uint*) frameBuffer.lines[8])[x + 5] = 0xffffff;
	}
}
+/
/+
alias ConsoleVariant = Algebraic!(bool, int64, float64, string);

public class ConsoleVariable
{
	private string _name;
	private ConsoleVariant _value;

	public this(TValue)(string name, TValue defaultValue) if (isBoolean!TValue)
	{
		_name = name;
		_value = to!(bool)(defaultValue);
	}

	public this(TValue)(string name, TValue defaultValue) if (isIntegral!TValue || isSomeChar!TValue)
	{
		_name = name;
		_value = to!(int64)(defaultValue);
	}

	public this(TValue)(string name, TValue defaultValue) if (isFloatingPoint!TValue)
	{
		_name = name;
		_value = to!(float64)(defaultValue);
	}

	public this(TValue)(string name, TValue defaultValue) if (isSomeString!TValue || isNarrowString!TValue || isConvertibleToString!TValue)
	{
		_name = name;
		_value = to!(string)(defaultValue);
	}

	public @property string name()
	{
		return _name;
	}

	public TValue get(TValue)() if (isBoolean!TValue)
	{
		return to!(TValue)(_value.get!bool);
	}

	public TValue get(TValue)() if (isIntegral!TValue || isSomeChar!TValue)
	{
		return to!(TValue)(_value.get!int64);
	}

	public TValue get(TValue)() if (isFloatingPoint!TValue)
	{
		return to!(TValue)(_value.get!float64);
	}

	public TValue get(TValue)() if (isSomeString!TValue || isNarrowString!TValue || isConvertibleToString!TValue)
	{
		return to!(TValue)(_value.get!string);
	}

	public void set(TValue)(TValue value) if (isBoolean!TValue)
	{
		_value = to!(bool)(value);
	}

	public void set(TValue)(TValue value) if (isIntegral!TValue || isSomeChar!TValue)
	{
		_value = to!(int64)(value);
	}

	public void set(TValue)(TValue value) if (isFloatingPoint!TValue)
	{
		_value = to!(float64)(value);
	}

	public void set(TValue)(TValue value) if (isSomeString!TValue || isNarrowString!TValue || isConvertibleToString!TValue)
	{
		_value = to!(string)(value);
	}

	public void parseFromString(TStr)(TStr str) if (isSomeString!TStr || isNarrowString!TStr || isConvertibleToString!TStr)
	{
		auto type = _value.type;

		if (type == typeid (bool))
		{
			_value = to!bool(to!string(str));
		}
		else if (type == typeid (int64))
		{
			_value = to!int64(to!string(str));
		}
		else if (type == typeid (float64))
		{
			_value = to!float64(to!string(str));
		}
		else if (type == typeid (string))
		{
			_value = to!string(str);
		}
		else
		{
			assert(0);
		}
	}

	public override string toString()
	{
		return _value.toString();
	}
}

public class ConsoleAlias
{
	private string _value;

	public this()
	{
		_value = null;
	}

	public string value() { return _value; }

	public void value(string value)
	{

	}
}

public class VariableList
{

}

public abstract class Console
{
	public this()
	{
		_vars = new VariableList();

		auto var1 = new ConsoleVariable("boolVar", true);
		auto var2 = new ConsoleVariable("intVar", 42);
		auto var3 = new ConsoleVariable("floatVar", 37.5);
		auto var4 = new ConsoleVariable("strVar", "foo");
		auto var5 = new ConsoleVariable("strVar2", "bar"d);

		var1.parseFromString("true");
	}

	private VariableList _vars = new VariableList();
	public VariableList vars()
	{
		return this._vars;
	}
}

void aline(float x0, float y0, float x1, float y1)
{
    void plot(int x, int y, float a)
    {
        auto p = (cast (TPixel*) bitmap.lines[y]) + x;

        //auto c0 = Color.from!(TPixel, bitmap.depth)(*p);

        // Todo: Mix c0 * (1 - a) with pixel * a
    }

    float fpart(float x)
    {
        return x < 0 ? 1 - (x - floor(x)) : x - floor(x);
    }

    float rfpart(float x)
    {
        return 1 - fpart(x);
    }

    auto steep = abs(y1 - y0) > abs(x1 - x0);

    if (steep) { swap(x0, y0); swap(x1, y1); }
    if (x0 > x1) { swap(x0, x1); swap(y0, y1); }

    auto dx = x1 - x0;
    auto dy = y1 - y0;
    auto gradient = dy / dx;

    auto xend = cast (int) (x0 + 0.5);
    auto yend = y0 + gradient * (xend - x0);
    auto xgap = rfpart(x0 + 0.5);
    auto xpxl1 = xend;
    auto ypxl1 = cast (int) yend;

    if (steep)
    {
        plot(ypxl1,     xpxl1, rfpart(yend) * xgap);
        plot(ypxl1 + 1, xpxl1,  fpart(yend) * xgap);
    }
    else
    {
        plot(xpxl1, ypxl1,     rfpart(yend) * xgap);
        plot(xpxl1, ypxl1 + 1,  fpart(yend) * xgap);
    }

    auto intery = yend + gradient;

    xend = cast (int) (x1 + 0.5);
    yend = y1 + gradient * (xend - x1);
    xgap = fpart(x1 + 0.5);
    auto xpxl2 = xend;
    auto ypxl2 = cast (int) yend;

    if (steep)
    {
        plot(ypxl2  , xpxl2, rfpart(yend) * xgap);
        plot(ypxl2+1, xpxl2,  fpart(yend) * xgap);
    }
    else
    {
        plot(xpxl2, ypxl2,  rfpart(yend) * xgap);
        plot(xpxl2, ypxl2+1, fpart(yend) * xgap);
    }

    for (auto x = xpxl1 + 1; x <= xpxl2 - 1; x++)
    {
        if (steep)
        {
            plot(cast (int) intery,     x, rfpart(intery));
            plot(cast (int) intery + 1, x,  fpart(intery));
        }
        else
        {
            plot(x, cast (int) intery,     rfpart(intery));
            plot(x, cast (int) intery + 1,  fpart(intery));
        }

        intery += gradient;
    }
}

immutable string[128] scanCodeNames =
[
    "Null",

    // 1 - 10
    "Escape",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",

    // 11 - 20
    "0",
    "??? (ß)",
    "??? (´)",
    "Backspace",
    "Tab",
    "Q",
    "W",
    "E",
    "R",
    "T",

    // 21 - 30
    "Z",
    "U",
    "I",
    "O",
    "P",
    "??? (Ü)",
    "??? (+)",
    "Return", // isE0 = NumPad Enter
    "Left Control", // isE0 = Right Control, // isE1 = Pause
    "A",

    // 31 - 40
    "S",
    "D",
    "F",
    "G",
    "H",
    "J",
    "K",
    "L",
    "??? (Ö)",
    "??? (Ä)",

    // 41 - 50
    "??? (^)",
    "Left Shift",
    "??? (#)",
    "Y",
    "X",
    "C",
    "V",
    "B",
    "N",
    "M",

    // 51 - 60
    "??? (,)",
    "??? (.)",
    "??? (-)",  // isE0 = NumPad Div
    "Right Shift",
    "NumPad Mul", // isE0 = Print
    "Left Alt", // isE0 = Right Alt
    "Space",
    "Caps Lock",
    "F1",
    "F2",

    // 61 - 70
    "F3",
    "F4",
    "F5",
    "F6",
    "F7",
    "F8",
    "F9",
    "F10",
    "Num Lock",
    "Scroll Lock",

    // 71 - 80
    "NumPad 7", // isE0 = Home
    "NumPad 8", // isE0 = Up
    "NumPad 9", // isE0 = Page Up
    "NumPad Sub",
    "NumPad 4", // isE0 = Left
    "NumPad 5",
    "NumPad 6", // isE0 = Right
    "NumPad Add",
    "NumPad 1", // isE0 = End
    "NumPad 2", // isE0 = Down

    // 81 - 90
    "NumPad 3", // isE0 = Page Down
    "NumPad 0", // isE0 = Insert
    "NumPad Delete", // isE0 = Delete
    "",
    "",
    "??? (<)",
    "F11",
    "F12",
    "",
    "",

    // 91 - 100
    "", // isE0 = Left Win
    "", // isE0 = Right Win
    "", // isE0 = Apps
    "",
    "",
    "",
    "",
    "",
    "",
    "",
];

immutable string[256] virtualKeyNames =
[
    "",

    // 1 - 10
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "Backspace",
    "Tab",
    "",

    // 11 - 20
    "",
    "",
    "Return",
    "",
    "",
    "Shift (General)",
    "Control (General)",
    "Alt (General)",
    "Pause",
    "Caps Lock",

    // 21 - 30
    "",
    "",
    "",
    "",
    "",
    "",
    "Escape",
    "",
    "",
    "",

    // 31 - 40
    "",
    "Space",
    "Page Up",
    "Page Down",
    "End",
    "Home",
    "Left",
    "Up",
    "Right",
    "Down",

    // 41 - 50
    "",
    "",
    "",
    "Print",
    "Insert",
    "Delete",
    "",
    "0",
    "1",
    "2",

    // 51 - 60
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "",
    "",
    "",

    // 61 - 70
    "",
    "",
    "",
    "",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",

    // 71 - 80
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",

    // 81 - 90
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",

    // 91 - 100
    "",
    "",
    "Apps",
    "",
    "",
    "NumPad 0",
    "NumPad 1",
    "NumPad 2",
    "NumPad 3",
    "NumPad 4",

    // 101 - 110
    "NumPad 5",
    "NumPad 6",
    "NumPad 7",
    "NumPad 8",
    "NumPad 9",
    "NumPad Mul",
    "NumPad Add",
    "",
    "NumPad Sub",
    "",

    // 111 - 120
    "NumPad Div",
    "F1",
    "F2",
    "F3",
    "F4",
    "F5",
    "F6",
    "F7",
    "F8",
    "F9",

    // 121 - 130
    "F10",
    "F11",
    "F12",
    "F13",
    "F14",
    "F15",
    "F16",
    "F17",
    "F18",
    "F19",

    // 131 - 140
    "F20",
    "F21",
    "F22",
    "F23",
    "F24",
    "",
    "",
    "",
    "",
    "",

    // 141 - 150
    "",
    "",
    "",
    "Num Lock",
    "Scroll Lock",
    "",
    "",
    "",
    "",
    "",

    // 151 - 160
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "Left Shift",

    // 161 - 170
    "Right Shift",
    "Left Control",
    "Right Control",
    "Left Alt",
    "Right Alt",
    "",
    "",
    "",
    "",
    "",

    // 171 - 180
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",

    // 181 - 190
    "",
    "",
    "",
    "",
    "",
    "??? (Ü)",
    "??? (+)",
    "??? (,)",
    "??? (-)",
    "??? (.)",

    // 191 - 200
    "??? (#)",
    "??? (Ö)",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",

    // 201 - 210
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",

    // 211 - 220
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "??? (ß)",
    "??? (^)",

    // 221 - 230
    "??? (´)",
    "??? (Ä)",
    "",
    "",
    "",
    "??? (<)",
    "",
    "",
    "",
    "",

    // 231 - 240
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",

    // 241 - 250
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",

    // 251 - 255
    "",
    "",
    "",
    "",
    "",
];

foreach (ref bc; buttonCaps)
{
    auto buttonCount = bc.UsageMax - bc.UsageMin;

    log2("buttonCaps: %s %s %s %s %s %s %s %s %s %s %s %s",
        bc.UsagePage, bc.ReportID, bc.IsAlias, bc.BitField, bc.LinkCollection, bc.LinkUsage, bc.LinkUsagePage, bc.IsRange, bc.IsStringRange, bc.IsDesignatorRange, bc.IsAbsolute, "[]");

    //if (bc.IsRange)
    //log2("buttonCaps.Range: %s %s %s %s %s %s %s %s",
    //    bc.Range.UsageMin, bc.Range.UsageMax, bc.Range.StringMin, bc.Range.StringMax, bc.Range.DesignatorMin, bc.Range.DesignatorMax, bc.Range.DataIndexMin, bc.Range.DataIndexMax);

    //if (!bc.IsRange)
    //log2("buttonCaps.NotRange: %s %s %s %s %s %s %s %s",
    //    bc.NotRange.Usage, bc.NotRange.Reserved1, bc.NotRange.StringIndex, bc.NotRange.Reserved2, bc.NotRange.DesignatorIndex, bc.NotRange.Reserved3, bc.NotRange.DataIndex, bc.NotRange.Reserved4);
}

foreach (ref vc; valueCaps)
{
    log("bar %s", valueCapsLength);

    log2("valueCaps1: %s %s %s %s %s %s %s %s %s %s %s",
        vc.UsagePage, vc.ReportID, vc.IsAlias, vc.BitField, vc.LinkCollection, vc.LinkUsage, vc.LinkUsagePage, vc.IsRange, vc.IsStringRange, vc.IsDesignatorRange, vc.IsAbsolute);

    log2("valueCaps2: %s %s %s %s %s %s %s %s %s %s %s",
        vc.HasNull, vc.Reserved, vc.BitSize, vc.ReportCount, "[]", vc.UnitsExp, vc.Units, vc.LogicalMin, vc.LogicalMax, vc.PhysicalMin, vc.PhysicalMax);

    //if (vc.IsRange)
    //log2("valueCaps.Range: %s %s %s %s %s %s %s %s",
    //    vc.Range.UsageMin, vc.Range.UsageMax, vc.Range.StringMin, vc.Range.StringMax, vc.Range.DesignatorMin, vc.Range.DesignatorMax, vc.Range.DataIndexMin, vc.Range.DataIndexMax);

    //if (!vc.IsRange)
    //log2("valueCaps.NotRange: %s %s %s %s %s %s %s %s",
    //    vc.NotRange.Usage, vc.NotRange.Reserved1, vc.NotRange.StringIndex, vc.NotRange.Reserved2, vc.NotRange.DesignatorIndex, vc.NotRange.Reserved3, vc.NotRange.DataIndex, vc.NotRange.Reserved4);
}

enum KeyCode
{
    Unknown         = 0x00,

    Backspace       = 0x08,
    Tab             = 0x09,
    Return          = 0x0D,
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

    CapsLock        = 0x80,
    LeftShift       = 0x81,
    RightShift      = 0x82,
    LeftControl     = 0x83,
    RightControl    = 0x84,
    LeftAlt         = 0x85,
    RightAlt        = 0x86,
    LeftMeta        = 0x87,
    RightMeta       = 0x88,
    ContextMenu     = 0x89,

    Print           = 0x8C,
    ScrollLock      = 0x8D,
    Pause           = 0x8E,

    Insert          = 0x91,
    Delete          = 0x92,
    Home            = 0x93,
    End             = 0x94,
    PageUp          = 0x95,
    PageDown        = 0x96,

    Left            = 0x99,
    Up              = 0x9A,
    Right           = 0x9B,
    Down            = 0x9C,

    NumLock         = 0xA0,
    Num0            = 0xA1, // NumInsert
    Num1            = 0xA2,
    Num2            = 0xA3,
    Num3            = 0xA4,
    Num4            = 0xA5,
    Num5            = 0xA6,
    Num6            = 0xA7,
    Num7            = 0xA8,
    Num8            = 0xA9,
    Num9            = 0xAA,
    NumDecimal      = 0xAB, // NumDelete
    NumAdd          = 0xAC,
    NumSubtract     = 0xAD,
    NumMultiply     = 0xAE,
    NumDivide       = 0xAF,
    NumEnter        = 0xB0,

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

    MouseWheelUp    = 0xDC,
    MouseWheelDown  = 0xDD,

    Joystick1       = 0xE0,
    Joystick2       = 0xE1,
    Joystick3       = 0xE2,
    Joystick4       = 0xE3,
    Joystick5       = 0xE4,
    Joystick6       = 0xE5,
    Joystick7       = 0xE6,
    Joystick8       = 0xE7,
    Joystick9       = 0xE8,
    Joystick10      = 0xE9,
    Joystick11      = 0xEA,
    Joystick12      = 0xEB,

    Gamepad1        = 0xF0,
    Gamepad2        = 0xF1,
    Gamepad3        = 0xF2,
    Gamepad4        = 0xF3,
    Gamepad5        = 0xF4,
    Gamepad6        = 0xF5,
    Gamepad7        = 0xF6,
    Gamepad8        = 0xF7,
    Gamepad9        = 0xF8,
    Gamepad10       = 0xF9,
    Gamepad11       = 0xFA,
    Gamepad12       = 0xFB,
}

private immutable string[256] keyNames =
[
    "Null",
    "", "", "", "", "", "", "",
    "Backspace",
    "Tab",
    "", "", "",
    "Return",
    "", "", "", "", "", "", "", "", "", "", "", "", "",
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
    "Caps Lock", "Left Shift", "Right Shift", "Left Control", "Right Control",
    "Left Alt", "Right Alt", "Left Windows", "Right Windows", "Command",
    "", "",
    "Print", "Scroll Lock", "Pause",
    "", "",
    "Insert", "Delete", "Home", "End", "Page Up", "Page Down",
    "", "",
    "Left", "Up", "Right", "Down",
    "", "", "",
    "Num Lock", "Num 0", "Num 1", "Num 2", "Num 3", "Num 4", "Num 5", "Num 6", "Num 7", "Num 8", "Num 9",
    "Num Decimal", "Num Add", "Num Sub", "Num Mul", "Num Div", "Num Enter",
    "", "", "",
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
    "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20", "F21", "F22", "F23", "F24",
    "", "", "", "",
    "Mouse 1", "Mouse 2", "Mouse 3", "Mouse 4", "Mouse 5", "Mouse 6",
    "Mouse 7", "Mouse 8", "Mouse 9", "Mouse 10", "Mouse 11", "Mouse 12",
    "Mouse Wheel Up", "Mouse Wheel Down",
    "", "",
    "Joystick 1", "Joystick 2", "Joystick 3", "Joystick 4", "Joystick 5", "Joystick 6",
    "Joystick 7", "Joystick 8", "Joystick 9", "Joystick 10", "Joystick 11", "Joystick 12",
    "", "", "", "",
    "Gamepad 1", "Gamepad 2", "Gamepad 3", "Gamepad 4", "Gamepad 5", "Gamepad 6",
    "Gamepad 7", "Gamepad 8", "Gamepad 9", "Gamepad 10", "Gamepad 11", "Gamepad 12",
    "", "", "", "",
];
+/
