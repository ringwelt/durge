module durge.draw.drawer;

import durge.common;
import durge.draw.bitmap;
import durge.draw.color;
import durge.draw.font;

static class DrawerFactory
{
	static IDrawer create(Bitmap bitmap)
	{
		final switch (bitmap.depth)
		{
			case 8:  return new Drawer8!(uint8, 8)(bitmap);
			case 16: return new Drawer16!(uint16, 16)(bitmap);
			case 32: return new Drawer32!(uint32, 32)(bitmap);
		}
	}
}

interface IDrawer
{
	@property Color color();
	@property void color(Color value);
	@property IFont font();
	@property void font(IFont value);

    Color getPixel(int x, int y);
    void setPixel(int x, int y, Color c);

    void clear();
	void point(int x, int y);
	void hline(int x0, int x1, int y);
	void vline(int x, int y0, int y1);
    void line(float_t x0, float_t y0, float_t x1, float_t y1);
    void aaline(float_t x0, float_t y0, float_t x1, float_t y1);
    void rectangle(int x0, int y0, int x1, int y1);
    void frectangle(int x0, int y0, int x1, int y1);
    void circle(int x, int y, int radius);
    void fcircle(int x, int y, int radius);
    void triangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2);
    void aatriangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2);
    void ftriangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2);
    void quadangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2, float_t x3, float_t y3);
    void aaquadangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2, float_t x3, float_t y3);
    void fquadangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2, float_t x3, float_t y3);
    void blit(int x, int y, Bitmap src, int sx0, int sy0, int sx1, int sy1);
}

abstract class Drawer(TPixel, int depth) : IDrawer
{
	protected this(Bitmap bitmap)
	{
        enforceEx!ArgumentNullException(bitmap !is null, "bitmap");

		_bitmap = bitmap;
        _color = Color(0xffffff);
        _font = Font.temp;
	}

	private Bitmap _bitmap;
	private Color _color;
    private TPixel _pixel;
	private IFont _font;

	@property Bitmap bitmap() { return _bitmap; }
	@property Color color() { return _color; }
    @property TPixel pixel() { return _pixel; }
	@property IFont font() { return _font; }

	@property void color(Color value)
    {
        _color = value;
        _pixel = value.to!(TPixel, depth)();
    }

 	@property void font(IFont value)
    {
        enforceEx!ArgumentNullException(value !is null, "value");

        _font = value;
    }

    Color getPixel(int x, int y)
    {
        return Color.from!(TPixel, depth)((cast (TPixel*) bitmap.lines[y])[x]);
    }

    void setPixel(int x, int y, Color c)
    {
        (cast (TPixel*) bitmap.lines[y])[x] = c.to!(TPixel, depth)();
    }

    void clear()
    {
        /*if (bitmap.parent is null)
        {
            auto d = bitmap.height * bitmap.pixelsPerLine;
            auto p = cast (TPixel*) bitmap.data;

            for (auto i = 0; i <= d; i++)
            {
                *p++ = pixel;
            }
        }
        else*/
        //{
            auto x0 = 0;
            auto x1 = bitmap.width - 1;

            for (auto y = 0; y < bitmap.height; y++)
            {
                hlineInner(x0, x1, y);
            }
        //}
    }

	void point(int x, int y)
	{
		if (bitmap.clip)
		{
			if (x < bitmap.minx || x > bitmap.maxx)
            {
                return;
            }

			if (y < bitmap.miny || y > bitmap.maxy)
            {
                return;
            }
		}

        pointInner(x, y);
	}

	package void pointInner(int x, int y)
	{
        (cast (TPixel*) bitmap.lines[y])[x] = pixel;
	}

	void hline(int x0, int x1, int y)
	{
        import std.algorithm.mutation : swap;

		if (x0 > x1) swap(x0, x1);

		if (bitmap.clip)
		{
			if (y < bitmap.miny || y > bitmap.maxy)
            {
                return;
            }

			if (x0 < bitmap.minx) x0 = bitmap.minx;
			if (x1 > bitmap.maxx) x1 = bitmap.maxx;

            if (x1 > x0)
            {
                return;
            }
		}

        hlineInner(x0, x1, y);
	}

	package void hlineInner(int x0, int x1, int y)
	{
		auto dx = x1 - x0;
		auto p = (cast (TPixel*) bitmap.lines[y]) + x0;

		for (auto i = 0; i <= dx; i++)
		{
			*p++ = pixel;
		}
	}

	void vline(int x, int y0, int y1)
	{
        import std.algorithm.mutation : swap;

		if (y0 > y1) swap(y0, y1);

		if (bitmap.clip)
		{
			if (x < bitmap.minx || x > bitmap.maxx)
            {
                return;
            }

			if (y0 < bitmap.miny) y0 = bitmap.miny;
			if (y1 > bitmap.maxy) y1 = bitmap.maxy;

            if (y1 > y0)
            {
                return;
            }
		}

        vlineInner(x, y0, y1);
	}

	package void vlineInner(int x, int y0, int y1)
	{
		auto dy = y1 - y0;
		auto p = (cast (TPixel*) bitmap.lines[y0]) + x;

		for (auto i = 0; i <= dy; i++)
		{
			*p = pixel;
			p = cast (TPixel*) (cast (void*) p + bitmap.pitch);
		}
	}

    void line(float_t x0, float_t y0, float_t x1, float_t y1)
    {
        // Draw line with Bresenham algorithm

        import std.algorithm.mutation : swap;

        if (y0 > y1)
        {
            swap(x0, x1);
            swap(y0, y1);
        }

        if (bitmap.clip && !clipLine(x0, y0, x1, y1))
        {
            return;
        }

        int roundi(float_t v)
        {
            return cast (int) (v + 0.5);
        }

        auto x0i = roundi(x0);
        auto y0i = roundi(y0);
        auto x1i = roundi(x1);
        auto y1i = roundi(y1);

        if (y0i == y1i)
        {
            hline(x0i, x1i, y0i);
            return;
        }

        if (x0i == x1i)
        {
            vline(x0i, y0i, y1i);
            return;
        }

        auto p = (cast (TPixel*) bitmap.lines[y0i]) + x0i;

        auto dxi = x1i - x0i;
        auto dyi = y1i - y0i;

        if (dxi == dyi)
        {
            for (auto i = 0; i <= dxi; i++)
            {
                *p++ = pixel;
                p = cast (TPixel*) (cast (void*) p + bitmap.pitch);
            }
        }
        else if (dxi > dyi)
        {
            auto err = dxi >> 1;
            *p = pixel;

            for (auto i = 0; i < dxi; i++)
            {
                err -= dyi;

                if (err < 0)
                {
                    p = cast (TPixel*) (cast (void*) p + bitmap.pitch);
                    err += dxi;
                }

                *p++ = pixel;
            }
        }
        else
        {
            auto err = dyi >> 1;
            *p = pixel;

            for (auto i = 0; i < dyi; i++)
            {
                err -= dxi;

                if (err < 0)
                {
                    p++;
                    err += dyi;
                }

                *p = pixel;
                p = cast (TPixel*) (cast (void*) p + bitmap.pitch);
            }
        }
    }

    void aaline(float_t x0, float_t y0, float_t x1, float_t y1)
    {
        // Draw anti aliased line with Xiaolin Wu algorithm

        import std.algorithm.mutation : swap;
        import std.math : abs, floor, round;

        auto dx = x1 - x0;
        auto dy = y1 - y0;

        TPixel* function(Bitmap, int, int) getp;

        if (dx.abs < dy.abs)
        {
            swap(x0, y0);
            swap(x1, y1);
            swap(dx, dy);

            getp = (bitmap, x, y)
            {
                return (cast (TPixel*) bitmap.lines[y]) + x;
            };
        }
        else
        {
            getp = (bitmap, x, y)
            {
                return (cast (TPixel*) bitmap.lines[x]) + y;
            };
        }

        void setc(int x, int y, float_t br)
        {
            auto p = getp(bitmap, x, y);
            auto c0 = Color.from!(TPixel, depth)(*p);
            alias c1 = color;

            auto c = Color
            (
                cast (uint8) (c0.r * br + c1.r * (1 - br)),
                cast (uint8) (c0.g * br + c1.g * (1 - br)),
                cast (uint8) (c0.b * br + c1.b * (1 - br))
            );

            *p = c.to!(TPixel, depth);
        }

        float fpart(float_t v)
        {
            return v - floor(v);
        }

        float_t rfpart(float_t v)
        {
            return 1 - fpart(v);
        }

        if (x0 > x1)
        {
            swap(x0, x1);
            swap(y0, y1);
        }

        auto yincr = dy / dx;

        auto xend0 = round(x0);
        auto yend0 = y0 + yincr * (xend0 - x0);
        auto xgap0 = rfpart(x0 + 0.5);

        auto x0i = cast (int)       xend0;
        auto y0i = cast (int) floor(yend0);

        setc(x0i, y0i,    rfpart(yend0) * xgap0);
        setc(x0i, y0i + 1, fpart(yend0) * xgap0);

        auto xend1 = floor(x1);
        auto yend1 = y1 + yincr * (xend1 - x1);
        auto xgap1 = fpart(x1 + 0.5);

        auto x1i = cast (int)       xend1;
        auto y1i = cast (int) floor(yend1);

        setc(x1i, y1i,    rfpart(yend1) * xgap1);
        setc(x1i, y1i + 1, fpart(yend1) * xgap1);

        auto py = yend0 + yincr;

        for (auto xi = x0i + 1; xi < x1i; xi++)
        {
            setc(xi, cast (int) py.floor,    rfpart(py));
            setc(xi, cast (int) py.floor + 1, fpart(py));

            py += yincr;
        }
    }

    package bool clipLine(ref float_t x0, ref float_t y0, ref float_t x1, ref float_t y1)
    {
        // Clip line with Cohen-Sutherland algorithm

        enum
        {
            ClipNone   = 0,
            ClipLeft   = 0b_0001,
            ClipRight  = 0b_0010,
            ClipTop    = 0b_0100,
            ClipBottom = 0b_1000
        }

        auto clip0 = ClipNone;
        auto clip1 = ClipNone;

        if (x0 < bitmap.minx) clip0 |= ClipLeft; else
        if (x0 > bitmap.maxx) clip0 |= ClipRight;

        if (y0 < bitmap.miny) clip0 |= ClipTop; else
        if (y0 > bitmap.maxy) clip0 |= ClipBottom;

        if (x1 < bitmap.minx) clip1 |= ClipLeft; else
        if (x1 > bitmap.maxx) clip1 |= ClipRight;

        if (y1 < bitmap.miny) clip1 |= ClipTop; else
        if (y1 > bitmap.maxy) clip1 |= ClipBottom;

        if (!clip0 && !clip1)
        {
            return true;
        }

        if (clip0 & clip1)
        {
            return false;
        }

        auto dx = x1 - x0;
        auto dy = y1 - y0;

        do
        {
            if (clip0)
            {
                if (clip0 & ClipLeft)
                {
                    y0 += (bitmap.minx - x0) * dy / dx;
                    x0 = bitmap.minx;
                }
                else if (clip0 & ClipRight)
                {
                    y0 += (bitmap.maxx - x0) * dy / dx;
                    x0 = bitmap.maxx;
                }

                if (clip0 & ClipTop)
                {
                    x0 += (bitmap.miny - y0) * dx / dy;
                    y0 = bitmap.miny;
                }
                else if (clip0 & ClipBottom)
                {
                    x0 += (bitmap.maxy - y0) * dx / dy;
                    y0 = bitmap.maxy;
                }

                clip0 = ClipNone;

                if (x0 < bitmap.minx) clip0 |= ClipLeft; else
                if (x0 > bitmap.maxx) clip0 |= ClipRight;

                if (y0 < bitmap.miny) clip0 |= ClipTop; else
                if (y0 > bitmap.maxy) clip0 |= ClipBottom;

                if (clip0 & clip1)
                {
                    return false;
                }
            }

            if (clip1)
            {
                if (clip1 & ClipLeft)
                {
                    y1 += (bitmap.minx - x1) * dy / dx;
                    x1 = bitmap.minx;
                }
                else if (clip1 & ClipRight)
                {
                    y1 += (bitmap.maxx - x1) * dy / dx;
                    x1 = bitmap.maxx;
                }

                if (clip1 & ClipTop)
                {
                    x1 += (bitmap.miny - y1) * dx / dy;
                    y1 = bitmap.miny;
                }
                else if (clip1 & ClipBottom)
                {
                    x1 += (bitmap.maxy - y1) * dx / dy;
                    y1 = bitmap.maxy;
                }

                clip1 = ClipNone;

                if (x1 < bitmap.minx) clip1 |= ClipLeft; else
                if (x1 > bitmap.maxx) clip1 |= ClipRight;

                if (y1 < bitmap.miny) clip1 |= ClipTop; else
                if (y1 > bitmap.maxy) clip1 |= ClipBottom;

                if (clip0 & clip1)
                {
                    return false;
                }
            }
        }
        while (clip0 || clip1);

        return true;
    }

    void rectangle(int x0, int y0, int x1, int y1)
    {
        import std.algorithm.mutation : swap;

        if (x0 > x1) swap(x0, x1);
        if (y0 > y1) swap(y0, y1);

        if (bitmap.clip)
        {
            if (x1 < bitmap.minx || x0 > bitmap.maxx)
            {
                return;
            }

            if (y1 < bitmap.miny || y0 > bitmap.maxy)
            {
                return;
            }

            bool clipLeft, clipRight, clipTop, clipBottom;

            if (x0 < bitmap.minx) { x0 = bitmap.minx; clipLeft = true; }
            if (x1 > bitmap.maxx) { x1 = bitmap.maxx; clipRight = true; }

            if (y0 < bitmap.miny) { y0 = bitmap.miny; clipTop = true; }
            if (y1 > bitmap.maxy) { y1 = bitmap.maxy; clipBottom = true; }

            if (!clipTop)    hlineInner(x0, x1, y0++);
            if (!clipBottom) hlineInner(x0, x1, y1--);

            if (y1 >= y0)
            {
                if (!clipLeft)  vlineInner(x0, y0, y1);
                if (!clipRight) vlineInner(x1, y0, y1);
            }
        }
        else
        {
            hlineInner(x0, x1, y0++);
            hlineInner(x0, x1, y1--);

            if (y1 >= y0)
            {
                vlineInner(x0, y0, y1);
                vlineInner(x1, y0, y1);
            }
        }
    }

    void frectangle(int x0, int y0, int x1, int y1)
    {
        import std.algorithm.mutation : swap;

        if (x0 > x1) swap(x0, x1);
        if (y0 > y1) swap(y0, y1);

        if (bitmap.clip)
        {
            if (x0 < bitmap.minx) x0 = bitmap.minx;
            if (x1 > bitmap.maxx) x1 = bitmap.maxx;

            if (y0 < bitmap.miny) y0 = bitmap.miny;
            if (y1 > bitmap.maxy) y1 = bitmap.maxy;

            if (x0 > x1 || y0 > y1)
            {
                return;
            }
        }

        for (auto y = y0; y <= y1; y++)
        {
            hlineInner(x0, x1, y);
        }
    }

    void circle(int x, int y, int radius)
    {
        // Draw circle with Bresenham / midpoint algorithm

        void delegate(int, int) pointf = bitmap.clip ? &point : &pointInner;

        auto px = radius - 1;
        auto py = 0;
        auto dx = 1;
        auto dy = 1;
        auto err = dx - (radius << 1);

        while (px >= py)
        {
            pointf(x - px, y - py);
            pointf(x + px, y - py);
            pointf(x - px, y + py);
            pointf(x + px, y + py);
            pointf(x - py, y + px);
            pointf(x + py, y + px);
            pointf(x - py, y - px);
            pointf(x + py, y - px);

            if (err <= 0)
            {
                py++;
                err += dy;
                dy += 2;
            }

            if (err > 0)
            {
                px--;
                dx += 2;
                err += (-radius << 1) + dx;
            }
        }
    }

    void fcircle(int x, int y, int radius)
    {
        // Draw filled circle with Bresenham / midpoint algorithm

        void delegate(int, int, int) hlinef = bitmap.clip ? &hline : &hlineInner;

        auto px = radius - 1;
        auto py = 0;
        auto dx = 1;
        auto dy = 1;
        auto err = dx - (radius << 1);

        while (px >= py)
        {
            hlinef(x - px, x + px, y + py);
            hlinef(x - px, x + px, y - py);
            hlinef(x - py, x + py, y + px);
            hlinef(x - py, x + py, y - px);

            if (err <= 0)
            {
                py++;
                err += dy;
                dy += 2;
            }

            if (err > 0)
            {
                px--;
                dx += 2;
                err += (-radius << 1) + dx;
            }
        }
    }

    void triangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2)
    {
        if (bitmap.clip)
        {
            // Todo: Clip triangle
        }
    
        line(x0, y0, x1, y1);
        line(x1, y1, x2, y2);
        line(x2, y2, x0, y0);
    }

    void aatriangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2)
    {
        if (bitmap.clip)
        {
            // Todo: Clip triangle
        }

        aaline(x0, y0, x1, y1);
        aaline(x1, y1, x2, y2);
        aaline(x2, y2, x0, y0);
    }

    void ftriangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2)
    {
        import std.algorithm.mutation : swap;

        if (y0 > y1) { swap(x0, x1); swap(y0, y1); }
        if (y0 > y2) { swap(x0, x2); swap(y0, y2); }
        if (y1 > y2) { swap(x1, x2); swap(y1, y2); }

        int roundi(float_t v)
        {
            return cast (int) (v + 0.5);
        }

        auto yi  = roundi(y0);
        auto y1i = roundi(y1);
        auto y2i = roundi(y2);

        auto px0 = x0;
        auto px1 = x0;
        auto px2 = x1;

        auto x0incr = (x2 - x0) / (y2 - y0);
        auto x1incr = (x1 - x0) / (y1 - y0);
        auto x2incr = (x2 - x1) / (y2 - y1);

        for (; yi <= y1i; yi++)
        {
            px0 += x0incr;
            px1 += x1incr;

            hline(roundi(px0), roundi(px1), yi);
        }

        for (; yi <= y2i; yi++)
        {
            px0 += x0incr;
            px2 += x2incr;

            hline(roundi(px0), roundi(px2), yi);
        }
    }

    void quadangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2, float_t x3, float_t y3)
    {
        if (bitmap.clip)
        {
            // Todo: Clip quadangle
        }

        line(x0, y0, x1, y1);
        line(x1, y1, x2, y2);
        line(x2, y2, x3, y3);
        line(x3, y3, x0, y0);
    }

    void aaquadangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2, float_t x3, float_t y3)
    {
        if (bitmap.clip)
        {
            // Todo: Clip quadangle
        }

        aaline(x0, y0, x1, y1);
        aaline(x1, y1, x2, y2);
        aaline(x2, y2, x3, y3);
        aaline(x3, y3, x0, y0);
    }

    void fquadangle(float_t x0, float_t y0, float_t x1, float_t y1, float_t x2, float_t y2, float_t x3, float_t y3)
    {
        import std.algorithm.mutation : swap;

        if (y0 > y1) { swap(x0, x1); swap(y0, y1); }
        if (y0 > y2) { swap(x0, x2); swap(y0, y2); }
        if (y0 > y3) { swap(x0, x3); swap(y0, y3); }
        if (y1 > y2) { swap(x1, x2); swap(y1, y2); }
        if (y1 > y3) { swap(x1, x3); swap(y1, y3); }
        if (y2 > y3) { swap(x2, x3); swap(y2, y3); }

        int roundi(float_t v)
        {
            return cast (int) (v + 0.5);
        }

        auto yi  = roundi(y0);
        auto y1i = roundi(y1);
        auto y2i = roundi(y2);
        auto y3i = roundi(y3);

        auto px0 = x0;
        auto px1 = x0;
        auto px2 = x1;
        auto px3 = x2;

        auto x0incr = (x2 - x0) / (y2 - y0);
        auto x1incr = (x1 - x0) / (y1 - y0);
        auto x2incr = (x3 - x1) / (y3 - y1);
        auto x3incr = (x3 - x2) / (y3 - y2);

        for (; yi <= y1i; yi++)
        {
            px0 += x0incr;
            px1 += x1incr;

            hline(roundi(px0), roundi(px1), yi);
        }

        for (; yi <= y2i; yi++)
        {
            px0 += x0incr;
            px2 += x2incr;

            hline(roundi(px0), roundi(px2), yi);
        }

        for (; yi <= y3i; yi++)
        {
            px3 += x3incr;
            px2 += x2incr;

            hline(roundi(px3), roundi(px2), yi);
        }
    }

    void blit(int x, int y, Bitmap src, int sx0, int sy0, int sx1, int sy1)
    {
        import std.algorithm.mutation : swap;
        alias dst = bitmap;

        if (sx0 > sx1) swap(sx0, sx1);
        if (sy0 > sy1) swap(sy0, sy1);

        alias dx0 = x;
        alias dy0 = y;
        auto  dx1 = x + sx1 - sx0;
        auto  dy1 = y + sy1 - sy0;

        if (sx0 < 0)
        {
            auto gapx = 0 - sx0;
            dx0 += gapx;
            sx0 += gapx;
        }

        if (sx1 >= src.width)
        {
            auto gapx = sx1 - src.width - 1;
            dx1 -= gapx;
            sx1 -= gapx;
        }

        if (sy0 < 0)
        {
            auto gapy = 0 - sy0;
            dy0 += gapy;
            sy0 += gapy;
        }

        if (sy1 >= src.height)
        {
            auto gapy = sy1 - src.height - 1;
            dy1 -= gapy;
            sy1 -= gapy;
        }

        if (dst.clip)
        {
            if (dx0 < dst.minx)
            {
                auto gapx = dst.minx - dx0;
                dx0 += gapx;
                sx0 += gapx;
            }

            if (dx1 > dst.maxx)
            {
                auto gapy = dx1 - dst.maxx;
                dx1 -= gapy;
                sx1 -= gapy;
            }

            if (dy0 < dst.miny)
            {
                auto gapx = dst.miny - dy0;
                dy0 += gapx;
                sy0 += gapx;
            }

            if (dy1 > dst.maxy)
            {
                auto gapy = dy1 - dst.maxy;
                dy1 -= gapy;
                sy1 -= gapy;
            }

            if (sx0 > sx1 || sy0 > sy1)
            {
                return;
            }
        }

        auto dx = sx1 - sx0;
        auto dy = sy1 - sy0;

        if (src.depth != dst.depth)
        {
            assert(0);
        }

        auto sp = (cast (TPixel*) src.lines[sy0]) + sx0;
        auto dp = (cast (TPixel*) dst.lines[dy0]) + dx0;

        auto sd = src.pitch - (dx - 1) * (src.depth >> 3);
        auto dd = dst.pitch - (dx - 1) * (dst.depth >> 3);

        for (auto i = 0; i <= dy; i++)
        {
            for (auto j = 0; j <= dx; j++)
            {
                *dp++ = *sp++;
            }

            sp = cast (TPixel*) (cast (void*) sp + sd);
            dp = cast (TPixel*) (cast (void*) dp + dd);
        }
    }

    void write(int x, int y, string s)
    {
        font.write(bitmap, x, y, s);
    }
}

class Drawer8(TPixel, int depth) : Drawer!(TPixel, depth)
{
	this(Bitmap bitmap)
	{
		super(bitmap);
	}
}

class Drawer16(TPixel, int depth) : Drawer!(TPixel, depth)
{
	this(Bitmap bitmap)
	{
		super(bitmap);
	}
}

class Drawer32(TPixel, int depth) : Drawer!(TPixel, depth)
{
	this(Bitmap bitmap)
	{
		super(bitmap);
	}
}
