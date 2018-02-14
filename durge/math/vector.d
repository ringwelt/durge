module durge.math.vector;

import durge.common;

struct Vector2D
{
	union
	{
		float_t[2] v = void;

		struct
		{
			float_t x = void;
			float_t y = void;
		}
	}

    pure: nothrow: @safe:

	this(float_t[2] v)
	{
		this.x = v[0];
		this.y = v[1];
	}

	this(float_t x, float_t y)
	{
		this.x = x;
		this.y = y;
	}

	this(Vector2D vector)
	{
		this.x = vector.x;
		this.y = vector.y;
	}

	float_t length()
	{
        import std.math : sqrt;

		return sqrt(this.x * this.x + this.y * this.y);
	}

	Vector2D normalize()
	{
		auto scale = 1.0 / this.length;

		return Vector2D(this.x * scale, this.y * scale);
	}

	Vector2D rotate(float_t angle)
	{
        import std.math : cos, sin;

		auto c = cos(angle);
		auto s = sin(angle);

        return Vector2D
        (
            this.x * c - this.y * s,
            this.x * s + this.y * c
        );
	}

	float_t dotProduct(Vector2D vector)
	{
		return this.x * vector.x + this.y * vector.y;
	}

	Vector2D opUnary(string op)() if (op == "-")
	{
		return Vector2D(-this.x, -this.y);
	}

	Vector2D opBinary(string op)(Vector2D vector) if (op == "+")
	{
		return Vector2D(this.x + vector.x, this.y + vector.y);
	}

	Vector2D opBinary(string op)(Vector2D vector) if (op == "-")
	{
		return Vector2D(this.x - vector.x, this.y - vector.y);
	}

	Vector2D opBinary(string op)(float_t scale) if (op == "*")
	{
		return Vector2D(this.x * scale, this.y * scale);
	}

	Vector2D opBinary(string op)(float_t scale) if (op == "/")
	{
		scale = 1.0 / scale;

		return Vector2D(this.x * scale, this.y * scale);
	}

	void opOpAssign(string op)(Vector2D vector) if (op == "+")
	{
		this.x += vector.x;
		this.y += vector.y;
	}

	void opOpAssign(string op)(Vector2D vector) if (op == "-")
	{
		this.x -= vector.x;
		this.y -= vector.y;
	}

	void opOpAssign(string op)(float_t scale) if (op == "*")
	{
		this.x *= scale;
		this.y *= scale;
	}

	void opOpAssign(string op)(float_t scale) if (op == "/")
	{
		scale = 1.0 / scale;

		this.x *= scale;
		this.y *= scale;
	}
}

struct Vector3D
{
	union
	{
		float_t[3] v = void;

		struct
		{
			float_t x = void;
			float_t y = void;
			float_t z = void;
		}
	}

    pure: nothrow: @safe:

	this(float_t[3] v)
	{
		this.x = v[0];
		this.y = v[1];
		this.z = v[2];
	}

	this(float_t x, float_t y, float_t z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	this(Vector2D vector)
	{
		this.x = vector.x;
		this.y = vector.y;
		this.z = 0.0;
	}

	this(Vector2D vector, float_t z)
	{
		this.x = vector.x;
		this.y = vector.y;
		this.z = z;
	}

	this(Vector3D vector)
	{
		this.x = vector.x;
		this.y = vector.y;
		this.z = vector.z;
	}

	float_t length()
	{
        import std.math : sqrt;

		return sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}

	Vector3D normalize()
	{
		auto scale = 1.0 / this.length;

		return Vector3D(this.x * scale, this.y * scale, this.z * scale);
	}

	Vector3D rotateX(float_t angleX)
	{
        import std.math : cos, sin;

		auto c = cos(angleX);
		auto s = sin(angleX);

		return Vector3D
        (
            this.x,
            this.y * c - this.z * s,
            this.z * c + this.y * s
        );
	}

	Vector3D rotateY(float_t angleY)
	{
        import std.math : cos, sin;

		auto c = cos(angleY);
		auto s = sin(angleY);

		return Vector3D
        (
            this.x * c + this.z * s,
            this.y,
            this.z * c - this.x * s
        );
	}

	Vector3D rotateZ(float_t angleZ)
	{
        import std.math : cos, sin;

		auto c = cos(angleZ);
		auto s = sin(angleZ);

		return Vector3D
        (
            this.x * c - this.y * s,
            this.x * s + this.y * c,
            this.z,
        );
	}

	float_t dotProduct(Vector3D vector)
	{
		return this.x * vector.x + this.y * vector.y + this.z * vector.z;
	}

	Vector3D crossProduct(Vector3D vector)
	{
		return Vector3D
        (
            this.y * vector.z - this.z * vector.y,
            this.z * vector.x - this.x * vector.z,
            this.x * vector.y - this.y * vector.x
        );
	}

	Vector3D opUnary(string op)() if (op == "-")
	{
		return Vector3D(-this.x, -this.y, -this.z);
	}

	Vector3D opBinary(string op)(Vector2D vector) if (op == "+")
	{
		return Vector3D(this.x + vector.x, this.y + vector.y, this.z);
	}

	Vector3D opBinary(string op)(Vector3D vector) if (op == "+")
	{
		return Vector3D(this.x + vector.x, this.y + vector.y, this.z + vector.z);
	}

	Vector3D opBinary(string op)(Vector2D vector) if (op == "-")
	{
		return Vector3D(this.x - vector.x, this.y - vector.y, this.z);
	}

	Vector3D opBinary(string op)(Vector3D vector) if (op == "-")
	{
		return Vector3D(this.x - vector.x, this.y - vector.y, this.z - vector.z);
	}

	Vector3D opBinary(string op)(float_t scale) if (op == "*")
	{
		return Vector3D(this.x * scale, this.y * scale, this.z * scale);
	}

	Vector3D opBinary(string op)(float_t scale) if (op == "/")
	{
		scale = 1.0 / scale;

		return Vector3D(this.x * scale, this.y * scale, this.z * scale);
	}

	void opOpAssign(string op)(Vector2D vector) if (op == "+")
	{
		this.x += vector.x;
		this.y += vector.y;
	}

	void opOpAssign(string op)(Vector3D vector) if (op == "+")
	{
		this.x += vector.x;
		this.y += vector.y;
		this.z += vector.z;
	}

	void opOpAssign(string op)(Vector2D vector) if (op == "-")
	{
		this.x -= vector.x;
		this.y -= vector.y;
	}

	void opOpAssign(string op)(Vector3D vector) if (op == "-")
	{
		this.x -= vector.x;
		this.y -= vector.y;
		this.z -= vector.z;
	}

	void opOpAssign(string op)(float_t scale) if (op == "*")
	{
		this.x *= scale;
		this.y *= scale;
		this.z *= scale;
	}

	void opOpAssign(string op)(float_t scale) if (op == "/")
	{
		scale = 1.0 / scale;

		this.x *= scale;
		this.y *= scale;
		this.z *= scale;
	}
}

struct Vector4D
{
	union
	{
		float_t[4] v = void;

		struct
		{
			float_t x = void;
			float_t y = void;
			float_t z = void;
			float_t w = void;
		}
	}

    pure: nothrow: @safe:

	this(float_t[4] v)
	{
		this.x = v[0];
		this.y = v[1];
		this.z = v[2];
		this.w = v[3];
	}

	this(float_t x, float_t y, float_t z, float_t w)
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	this(Vector2D vector)
	{
		this.x = vector.x;
		this.y = vector.y;
		this.z = 0.0;
		this.w = 0.0;
	}

	this(Vector2D vector, float_t z)
	{
		this.x = vector.x;
		this.y = vector.y;
		this.z = z;
		this.w = 0.0;
	}

	this(Vector2D vector, float_t z, float_t w)
	{
		this.x = vector.x;
		this.y = vector.y;
		this.z = z;
		this.w = w;
	}

	this(Vector3D vector)
	{
		this.x = vector.x;
		this.y = vector.y;
		this.z = vector.z;
		this.w = 0.0;
	}

	this(Vector3D vector, float_t w)
	{
		this.x = vector.x;
		this.y = vector.y;
		this.z = vector.z;
		this.w = w;
	}

	this(Vector4D vector)
	{
		this.x = vector.x;
		this.y = vector.y;
		this.z = vector.z;
		this.w = vector.w;
	}

	float_t length()
	{
        import std.math : sqrt;

		return sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}

	Vector4D normalize()
	{
		auto scale = 1.0 / this.length;

		return Vector4D(this.x * scale, this.y * scale, this.z * scale, this.w * scale);
	}

	float_t dotProduct(Vector4D vector)
	{
		return this.x * vector.x + this.y * vector.y + this.z * vector.z + this.w * vector.w;
	}

	Vector4D opUnary(string op)() if (op == "-")
	{
		return Vector4D(-this.x, -this.y, -this.z, -this.w);
	}

	Vector4D opBinary(string op)(Vector4D vector) if (op == "+")
	{
		return Vector4D(this.x + vector.x, this.y + vector.y, this.z + vector.z, this.w + vector.w);
	}

	Vector4D opBinary(string op)(Vector4D vector) if (op == "-")
	{
		return Vector4D(this.x - vector.x, this.y - vector.y, this.z - vector.z, this.w - vector.w);
	}

	Vector4D opBinary(string op)(float_t scale) if (op == "*")
	{
		return Vector4D(this.x * scale, this.y * scale, this.z * scale, this.w * scale);
	}

	Vector4D opBinary(string op)(float_t scale) if (op == "/")
	{
		scale = 1.0 / scale;

		return Vector4D(this.x * scale, this.y * scale, this.z * scale, this.w * scale);
	}

	void opOpAssign(string op)(Vector4D vector) if (op == "+")
	{
		this.x += vector.x;
		this.y += vector.y;
		this.z += vector.z;
		this.w += vector.w;
	}

	void opOpAssign(string op)(Vector4D vector) if (op == "-")
	{
		this.x -= vector.x;
		this.y -= vector.y;
		this.z -= vector.z;
		this.w -= vector.w;
	}

	void opOpAssign(string op)(float_t scale) if (op == "*")
	{
		this.x *= scale;
		this.y *= scale;
		this.z *= scale;
		this.w *= scale;
	}

	void opOpAssign(string op)(float_t scale) if (op == "/")
	{
		scale = 1.0 / scale;

		this.x *= scale;
		this.y *= scale;
		this.z *= scale;
		this.w *= scale;
	}
}
