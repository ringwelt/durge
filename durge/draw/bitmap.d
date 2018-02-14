module durge.draw.bitmap;

import durge.common;
import durge.draw.drawer;

class Bitmap
{
	private Bitmap _parent;
    private int _width;
    private int _height;
    private int _depth;
	private bool _clip;
	private int _minx;
	private int _maxx;
	private int _miny;
	private int _maxy;
    private bool _deleteData;
	private void* _data;
    private int _pitch;
	private void*[] _lines;
	private IDrawer _drawer;

	this(int width, int height, int depth)
	{
        enforceEx!ArgumentException(width > 0, "Parameter width must be greater zero.");
        enforceEx!ArgumentException(height > 0, "Parameter height must be greater zero.");
        enforceEx!ArgumentException(depth == 8 || depth == 16 || depth == 32, "Parameter depth must be 8, 16 or 32.");

		_parent = null;
		_width = width;
		_height = height;
		_depth = depth;
		_clip = true;
		_minx = 0;
		_maxx = width - 1;
		_miny = 0;
		_maxy = height - 1;
		_data = new ubyte[height * width * (depth >> 3)].ptr;
        _deleteData = true;
        _pitch = width * (depth >> 3);
		_lines = new void*[height];
		_drawer = DrawerFactory.create(this);

		for (auto i = 0; i < height; i++)
		{
			_lines[i] = _data + i * _pitch;
		}
	}

	this(Bitmap parent, int x, int y, int width, int height)
	{
        enforceEx!ArgumentNullException(parent !is null, "parent");
        enforceEx!ArgumentException(x >= 0, "Parameter x must be greater or equal to zero.");
        enforceEx!ArgumentException(y >= 0, "Parameter y must be greater or equal to zero.");
        enforceEx!ArgumentException(width > 0, "Parameter width must be greater zero.");
        enforceEx!ArgumentException(height > 0, "Parameter height must be greater zero.");

		_parent = parent;
		_width = width;
		_height = height;
		_depth = parent.depth;
		_clip = true;
		_minx = 0;
		_maxx = width - 1;
		_miny = 0;
		_maxy = height - 1;
		_data = parent.data + y * parent.pitch + x * (parent.depth >> 3);
        _pitch = parent.pitch;
		_lines = new void*[height];
		_drawer = parent._drawer;

		for (auto i = 0; i < height; i++)
		{
			_lines[i] = parent._lines[i + y] + x * (_parent.depth >> 3);
		}
	}

	protected this(void* data, int pitch, int width, int height, int depth)
	{
        enforceEx!ArgumentNullException(data !is null, "data");
        enforceEx!ArgumentException(pitch >= 0, "Parameter pitch must be zero or greater.");
        enforceEx!ArgumentException(width > 0, "Parameter width must be greater zero.");
        enforceEx!ArgumentException(height > 0, "Parameter height must be greater zero.");
        enforceEx!ArgumentException(depth == 8 || depth == 16 || depth == 32, "Parameter depth must be 8, 16 or 32.");

		_parent = null;
		_width = width;
		_height = height;
		_depth = depth;
		_clip = true;
		_minx = 0;
		_maxx = width - 1;
		_miny = 0;
		_maxy = height - 1;
		_data = data;
        _pitch = pitch != 0 ? pitch : width * (depth >> 3);
		_lines = new void*[height];
		_drawer = DrawerFactory.create(this);

		for (auto i = 0; i < height; i++)
		{
			_lines[i] = _data + i * _pitch;
		}
	}

    nothrow ~this()
    {
        delete _lines;

        if (_deleteData)
        {
            delete _data;
        }
    }

    protected void setData(void* data, int pitch)
    {
        enforceEx!ArgumentNullException(data !is null, "data");
        enforceEx!ArgumentException(pitch >= 0, "Parameter pitch must be zero or greater.");

		_data = data;
        _pitch = pitch;

		for (auto i = 0; i < height; i++)
		{
			_lines[i] = _data + i * _pitch;
		}
    }

	@property Bitmap parent() { return _parent; }
	@property int width() { return _width; }
	@property int height() { return _height; }
	@property int depth() { return _depth; }
	@property bool clip() { return _clip; }
	@property void clip(bool value) { _clip = value; }
	@property int minx() { return _minx; }
	@property int maxx() { return _maxx; }
	@property int miny() { return _miny; }
	@property int maxy() { return _maxy; }
	@property void* data() { return _data; }
	@property int pitch() { return _pitch; }
	@property void*[] lines() { return _lines; }
    @property IDrawer drawer() { return _drawer; }

	@property void minx(bool value)
    {
        enforceEx!ArgumentException(value >= 0, "Parameter value must be zero or greater.");
        enforceEx!ArgumentException(value < width, "Parameter value must be lower than bitmap width.");

        _minx = value;
    }

	@property void maxx(bool value)
    {
        enforceEx!ArgumentException(value >= 0, "Parameter value must be zero or greater.");
        enforceEx!ArgumentException(value < width, "Parameter value must be lower than bitmap width.");

        _maxx = value;
    }

	@property void miny(bool value)
    {
        enforceEx!ArgumentException(value >= 0, "Parameter value must be zero or greater.");
        enforceEx!ArgumentException(value < height, "Parameter value must be lower than bitmap height.");

        _miny = value;
    }

	@property void maxy(bool value)
    {
        enforceEx!ArgumentException(value >= 0, "Parameter value must be zero or greater.");
        enforceEx!ArgumentException(value < height, "Parameter value must be lower than bitmap height.");

        _maxy = value;
    }
}
