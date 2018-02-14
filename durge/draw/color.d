module durge.draw.color;

import durge.common;

struct Color
{
    const static
    {
        auto white   = Color(0xffffff);
        auto silver  = Color(0xc0c0c0);
        auto gray    = Color(0x808080);
        auto black   = Color(0x000000);
        auto red     = Color(0xff0000);
        auto lime    = Color(0x00ff00);
        auto blue    = Color(0x0000ff);
        auto yellow  = Color(0xffff00);
        auto fuchsia = Color(0xff00ff);
        auto aqua    = Color(0x00ffff);
        auto maroon  = Color(0x800000);
        auto green   = Color(0x008000);
        auto navy    = Color(0x000080);
        auto olive   = Color(0x808000);
        auto purple  = Color(0x800080);
        auto teal    = Color(0x008080);
    }

    union
    {
        uint32 c;

        struct
        {
            uint8 b, g, r, a;
        }
    }

    pure: nothrow: @safe:

	this(uint32 c)
	{
        this.c = c;
	}

    this(int r, int g, int b, int a)
	{
		this.b = cast (uint8) b;
		this.g = cast (uint8) g;
		this.r = cast (uint8) r;
		this.a = cast (uint8) a;
	}

	this(int r, int g, int b)
	{
		this.b = cast (uint8) b;
		this.g = cast (uint8) g;
		this.r = cast (uint8) r;
		this.a = 0;
	}

    static auto from8(uint32 c)  { return Color((c & 0b_11100000), (c & 0b_00011100) << 3, (c & 0b_00000011) << 6); }
    static auto from16(uint32 c) { return Color((c & 0b_11111000_00000000) >> 8, (c & 0b_00000111_11100000) >> 3, (c & 0b_00000000_00011111) << 3); }
    static auto from32(uint32 c) { return Color(c & 0x00ffffff); }

    auto to8()  { return cast (uint8)  ((r & 0b_11100000) | (g & 0b_11100000) >> 3 | (b & 0b_11000000) >> 6); }
	auto to16() { return cast (uint16) ((r & 0b_11111000) << 8 | (g & 0b_11111100) << 3 | (b & 0b_11111000) >> 3); }
    auto to32() { return cast (uint32) (c & 0x00ffffff); }

    static auto from(TPixel, int depth)(TPixel c) if (depth == 8)  { return from8(c); }
    static auto from(TPixel, int depth)(TPixel c) if (depth == 16) { return from16(c); }
    static auto from(TPixel, int depth)(TPixel c) if (depth == 32) { return from32(c); }

    auto to(TPixel, int depth)() if (depth == 8)  { return cast (TPixel) to8; }
    auto to(TPixel, int depth)() if (depth == 16) { return cast (TPixel) to16; }
    auto to(TPixel, int depth)() if (depth == 32) { return cast (TPixel) to32; }
}

struct PaletteEntry
{
    uint8 r, g, b, a;
}

class Palette
{
    PaletteEntry[256] entries;

    static immutable Palette identity =
    ({
        Palette p = new Palette();

        for (auto i = 0; i < 256; i++)
        {
            auto c = Color.from8(i);

            p.entries[i].r = c.r;
            p.entries[i].g = c.g;
            p.entries[i].b = c.b;
        }

        return p;
    })();
}
