module durge.math.matrix;

import durge.common;
import durge.math.vector;

class Matrix3X3
{
	float_t[3][3] m = void;

    pure: nothrow: @safe:

	this()
	{
		
	}

	this(Matrix3X3 matrix)
	{
		this.m = matrix.m;
	}

	float_t determinant()
	{
		return
			this.m[0][0] * this.m[1][1] * this.m[2][2] +
			this.m[0][1] * this.m[1][2] * this.m[2][0] +
			this.m[0][2] * this.m[1][0] * this.m[2][1] -

			this.m[0][2] * this.m[1][1] * this.m[2][0] -
			this.m[0][1] * this.m[1][0] * this.m[2][2] -
			this.m[0][0] * this.m[1][2] * this.m[2][1];
	}

	void transform(TVector2D)(TVector2D[] vectors)
	{
		for (auto i = 0; i < vectors.length; i++)
		{
			auto vector = &vectors[i];
			auto temp = vector;
	
			vector.x = temp.x * this.m[0][0] + temp.y * this.m[0][1] + this.m[0][2];
			vector.y = temp.x * this.m[1][0] + temp.y * this.m[1][1] + this.m[1][2];
		}
	}

	void transform(Vector3D[] vectors)
	{
		for (auto i = 0; i < vectors.length; i++)
		{
			auto vector = &vectors[i];
			auto temp = vector;
	
			vector.x = temp.x * this.m[0][0] + temp.y * this.m[0][1] + temp.z * this.m[0][2];
			vector.y = temp.x * this.m[1][0] + temp.y * this.m[1][1] + temp.z * this.m[1][2];
			vector.z = temp.x * this.m[2][0] + temp.y * this.m[2][1] + temp.z * this.m[2][2];
		}
	}

	Matrix3X3 opBinary(string op)(float_t scale) if (op == "*" || op == "/")
	{
		auto result = new Matrix3X3();

		if (op == "/")
		{
			scale = 1.0 / scale;
		}

		result.m[0][0] = this.m[0][0] * scale;
		result.m[0][1] = this.m[0][1] * scale;
		result.m[0][2] = this.m[0][2] * scale;

		result.m[1][0] = this.m[1][0] * scale;
		result.m[1][1] = this.m[1][1] * scale;
		result.m[1][2] = this.m[1][2] * scale;

		result.m[2][0] = this.m[2][0] * scale;
		result.m[2][1] = this.m[2][1] * scale;
		result.m[2][2] = this.m[2][2] * scale;

		return result;
	}

	Matrix3X3 opBinary(string op)(Matrix3X3 matrix) if (op == "*")
	{
		auto result = new Matrix3X3();

		for (auto v = 0; v < 3; v++)
		for (auto u = 0; u < 3; u++)
		{
			result.m[v][u] =
				this.m[v][0] * matrix.m[0][u] +
				this.m[v][1] * matrix.m[1][u] +
				this.m[v][2] * matrix.m[2][u];
		}

		return result;
	}

	static Matrix3X3 zero()
	{
		auto result = new Matrix3X3();

		result.m[0][0] = 0.0;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = 0.0;
		result.m[1][2] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 0.0;

		return result;
	}

	static Matrix3X3 identity()
	{
		auto result = new Matrix3X3();

		result.m[0][0] = 1.0;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = 1.0;
		result.m[1][2] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 1.0;

		return result;
	}

	static Matrix3X3 translation(TVector2D)(TVector2D vector)
	{
		auto result = new Matrix3X3();

		result.m[0][0] = 1.0;
		result.m[0][1] = 0.0;
		result.m[0][2] = vector.x;

		result.m[1][0] = 0.0;
		result.m[1][1] = 1.0;
		result.m[1][2] = vector.y;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 1.0;

		return result;
	}

	static Matrix3X3 scaling(float_t scale)
	{
		auto result = new Matrix3X3();
		
		result.m[0][0] = scale;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = scale;
		result.m[1][2] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 1.0;

		return result;
	}

	static Matrix3X3 scaling(float_t scaleX, float_t scaleY)
	{
		auto result = new Matrix3X3();

		result.m[0][0] = scaleX;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = scaleY;
		result.m[1][2] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 1.0;

		return result;
	}

	static Matrix3X3 rotation(float_t angle)
	{
        import std.math : cos, sin;

		auto result = new Matrix3X3();
		auto c = cos(angle);
		auto s = sin(angle);

		result.m[0][0] = c;
		result.m[0][1] = -s;
		result.m[0][2] = 0.0;

		result.m[1][0] = s;
		result.m[1][1] = c;
		result.m[1][2] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 1.0;

		return result;
	}
}

class Matrix4X4
{
	float_t[4][4] m = void;

    pure: nothrow: @safe:

	this()
	{
		
	}

	this(Matrix4X4 matrix)
	{
		this.m = matrix.m;
	}

	float_t determinant()
	{
		return
			this.m[0][0] * this.m[1][1] * this.m[2][2] * this.m[3][3] +
			this.m[0][0] * this.m[1][2] * this.m[2][3] * this.m[3][1] +
			this.m[0][0] * this.m[1][3] * this.m[2][1] * this.m[3][2] +

			this.m[0][1] * this.m[1][0] * this.m[2][3] * this.m[3][2] +
			this.m[0][1] * this.m[1][2] * this.m[2][0] * this.m[3][3] +
			this.m[0][1] * this.m[1][3] * this.m[2][2] * this.m[3][0] +

			this.m[0][2] * this.m[1][0] * this.m[2][1] * this.m[3][3] +
			this.m[0][2] * this.m[1][1] * this.m[2][3] * this.m[3][0] +
			this.m[0][2] * this.m[1][3] * this.m[2][0] * this.m[3][1] +

			this.m[0][3] * this.m[1][0] * this.m[2][2] * this.m[3][1] +
			this.m[0][3] * this.m[1][1] * this.m[2][0] * this.m[3][2] +
			this.m[0][3] * this.m[1][2] * this.m[2][1] * this.m[3][0] -

			this.m[0][0] * this.m[1][1] * this.m[2][3] * this.m[3][2] -
			this.m[0][0] * this.m[1][2] * this.m[2][1] * this.m[3][3] -
			this.m[0][0] * this.m[1][3] * this.m[2][2] * this.m[3][1] -

			this.m[0][1] * this.m[1][0] * this.m[2][2] * this.m[3][3] -
			this.m[0][1] * this.m[1][2] * this.m[2][3] * this.m[3][0] -
			this.m[0][1] * this.m[1][3] * this.m[2][0] * this.m[3][2] -

			this.m[0][2] * this.m[1][0] * this.m[2][3] * this.m[3][1] -
			this.m[0][2] * this.m[1][1] * this.m[2][0] * this.m[3][3] -
			this.m[0][2] * this.m[1][3] * this.m[2][1] * this.m[3][0] -

			this.m[0][3] * this.m[1][0] * this.m[2][1] * this.m[3][2] -
			this.m[0][3] * this.m[1][1] * this.m[2][2] * this.m[3][0] -
			this.m[0][3] * this.m[1][2] * this.m[2][0] * this.m[3][1];
	}

	void transform(Vector3D[] vectors)
	{
		for (auto i = 0; i < vectors.length; i++)
		{
			auto vector = &vectors[i];
			auto temp = vector;
	
			vector.x = temp.x * this.m[0][0] + temp.y * this.m[0][1] + temp.z * this.m[0][2] + this.m[0][3];
			vector.y = temp.x * this.m[1][0] + temp.y * this.m[1][1] + temp.z * this.m[1][2] + this.m[1][3];
			vector.z = temp.x * this.m[2][0] + temp.y * this.m[2][1] + temp.z * this.m[2][2] + this.m[2][3];
		}
	}

	void transform(Vector4D[] vectors)
	{
		for (auto i = 0; i < vectors.length; i++)
		{
			auto vector = &vectors[i];
			auto temp = vector;
	
			vector.x = temp.x * this.m[0][0] + temp.y * this.m[0][1] + temp.z * this.m[0][2] + temp.w * this.m[0][3];
			vector.y = temp.x * this.m[1][0] + temp.y * this.m[1][1] + temp.z * this.m[1][2] + temp.w * this.m[1][3];
			vector.z = temp.x * this.m[2][0] + temp.y * this.m[2][1] + temp.z * this.m[2][2] + temp.w * this.m[2][3];
			vector.w = temp.x * this.m[3][0] + temp.y * this.m[3][1] + temp.z * this.m[3][2] + temp.w * this.m[3][3];
		}
	}

	Matrix4X4 opBinary(string op)(float_t scale) if (op == "*" || op == "/")
	{
		auto result = new Matrix4X4();

		if (op == "/")
		{
			scale = 1.0 / scale;
		}

		result.m[0][0] = this.m[0][0] * scale;
		result.m[0][1] = this.m[0][1] * scale;
		result.m[0][2] = this.m[0][2] * scale;
		result.m[0][3] = this.m[0][3] * scale;

		result.m[1][0] = this.m[1][0] * scale;
		result.m[1][1] = this.m[1][1] * scale;
		result.m[1][2] = this.m[1][2] * scale;
		result.m[1][3] = this.m[1][3] * scale;

		result.m[2][0] = this.m[2][0] * scale;
		result.m[2][1] = this.m[2][1] * scale;
		result.m[2][2] = this.m[2][2] * scale;
		result.m[2][3] = this.m[2][3] * scale;

		result.m[3][0] = this.m[3][0] * scale;
		result.m[3][1] = this.m[3][1] * scale;
		result.m[3][2] = this.m[3][2] * scale;
		result.m[3][3] = this.m[3][3] * scale;

		return result;
	}

	Matrix4X4 opBinary(string op)(Matrix4X4 matrix) if (op == "*")
	{
		auto result = new Matrix4X4();

		for (auto v = 0; v < 4; v++)
		for (auto u = 0; u < 4; u++)
		{
			result.m[v][u] =
				this.m[v][0] * matrix.m[0][u] +
				this.m[v][1] * matrix.m[1][u] +
				this.m[v][2] * matrix.m[2][u] +
				this.m[v][3] * matrix.m[3][u];
		}

		return result;
	}

	static Matrix4X4 zero()
	{
		auto result = new Matrix4X4();

		result.m[0][0] = 0.0;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;
		result.m[0][3] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = 0.0;
		result.m[1][2] = 0.0;
		result.m[1][3] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 0.0;
		result.m[2][3] = 0.0;

		result.m[3][0] = 0.0;
		result.m[3][1] = 0.0;
		result.m[3][2] = 0.0;
		result.m[3][3] = 0.0;

		return result;
	}

	static Matrix4X4 identity()
	{
		auto result = new Matrix4X4();

		result.m[0][0] = 1.0;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;
		result.m[0][3] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = 1.0;
		result.m[1][2] = 0.0;
		result.m[1][3] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 1.0;
		result.m[2][3] = 0.0;

		result.m[3][0] = 0.0;
		result.m[3][1] = 0.0;
		result.m[3][2] = 0.0;
		result.m[3][3] = 1.0;

		return result;
	}

	static Matrix4X4 translation(Vector3D vector)
	{
		auto result = new Matrix4X4();

		result.m[0][0] = 1.0;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;
		result.m[0][3] = vector.x;

		result.m[1][0] = 0.0;
		result.m[1][1] = 1.0;
		result.m[1][2] = 0.0;
		result.m[1][3] = vector.y;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 1.0;
		result.m[2][3] = vector.z;

		result.m[3][0] = 0.0;
		result.m[3][1] = 0.0;
		result.m[3][2] = 0.0;
		result.m[3][3] = 1.0;

		return result;
	}

	static Matrix4X4 scaling(float_t scale)
	{
		auto result = new Matrix4X4();
		
		result.m[0][0] = scale;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;
		result.m[0][3] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = scale;
		result.m[1][2] = 0.0;
		result.m[1][3] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = scale;
		result.m[2][3] = 0.0;

		result.m[3][0] = 0.0;
		result.m[3][1] = 0.0;
		result.m[3][2] = 0.0;
		result.m[3][3] = 1.0;

		return result;
	}

	static Matrix4X4 scaling(float_t scaleX, float_t scaleY, float_t scaleZ)
	{
		auto result = new Matrix4X4();

		result.m[0][0] = scaleX;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;
		result.m[0][3] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = scaleY;
		result.m[1][2] = 0.0;
		result.m[1][3] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = scaleZ;
		result.m[2][3] = 0.0;

		result.m[3][0] = 0.0;
		result.m[3][1] = 0.0;
		result.m[3][2] = 0.0;
		result.m[3][3] = 1.0;

		return result;
	}

	static Matrix4X4 rotationX(float_t angleX)
	{
        import std.math : cos, sin;

		auto result = new Matrix4X4();
		auto c = cos(angleX);
		auto s = sin(angleX);

		result.m[0][0] = 1.0;
		result.m[0][1] = 0.0;
		result.m[0][2] = 0.0;
		result.m[0][3] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = c;
		result.m[1][2] = -s;
		result.m[1][3] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = s;
		result.m[2][2] = c;
		result.m[2][3] = 0.0;

		result.m[3][0] = 0.0;
		result.m[3][1] = 0.0;
		result.m[3][2] = 0.0;
		result.m[3][3] = 1.0;

		return result;
	}

	static Matrix4X4 rotationY(float_t angleY)
	{
        import std.math : cos, sin;

		auto result = new Matrix4X4();
		auto c = cos(angleY);
		auto s = sin(angleY);

		result.m[0][0] = c;
		result.m[0][1] = 0.0;
		result.m[0][2] = s;
		result.m[0][3] = 0.0;

		result.m[1][0] = 0.0;
		result.m[1][1] = 1.0;
		result.m[1][2] = 0.0;
		result.m[1][3] = 0.0;

		result.m[2][0] = -s;
		result.m[2][1] = 0.0;
		result.m[2][2] = c;
		result.m[2][3] = 0.0;

		result.m[3][0] = 0.0;
		result.m[3][1] = 0.0;
		result.m[3][2] = 0.0;
		result.m[3][3] = 1.0;

		return result;
	}

	static Matrix4X4 rotationZ(float_t angleZ)
	{
        import std.math : cos, sin;

		auto result = new Matrix4X4();
		auto c = cos(angleZ);
		auto s = sin(angleZ);

		result.m[0][0] = c;
		result.m[0][1] = -s;
		result.m[0][2] = 0.0;
		result.m[0][3] = 0.0;

		result.m[1][0] = s;
		result.m[1][1] = c;
		result.m[1][2] = 0.0;
		result.m[1][3] = 0.0;

		result.m[2][0] = 0.0;
		result.m[2][1] = 0.0;
		result.m[2][2] = 1.0;
		result.m[2][3] = 0.0;

		result.m[3][0] = 0.0;
		result.m[3][1] = 0.0;
		result.m[3][2] = 0.0;
		result.m[3][3] = 1.0;

		return result;
	}

	static Matrix4X4 rotation(Vector3D vector, float_t angle)
	{
        import std.math : cos, sin;

		auto result = new Matrix4X4();
		auto c = cos(angle);
		auto s = sin(angle);
		auto t = 1 - cos(angle);

		result.m[0][0] = t * vector.x * vector.x + c;
		result.m[0][1] = t * vector.x * vector.y - s * vector.z;
		result.m[0][2] = t * vector.x * vector.z + s * vector.y;
		result.m[0][3] = 0.0;

		result.m[1][0] = t * vector.x * vector.y + s * vector.z;
		result.m[1][1] = t * vector.y * vector.y + c;
		result.m[1][2] = t * vector.y * vector.z - s * vector.x;
		result.m[1][3] = 0.0;

		result.m[2][0] = t * vector.x * vector.z - s * vector.y;
		result.m[2][1] = t * vector.y * vector.z + s * vector.x;
		result.m[2][2] = t * vector.z * vector.z + c;
		result.m[2][3] = 0.0;

		result.m[3][0] = 0.0;
		result.m[3][1] = 0.0;
		result.m[3][2] = 0.0;
		result.m[3][3] = 1.0;

		return result;
	}
}
