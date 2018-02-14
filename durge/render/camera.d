module durge.render.camera;

import durge.common;
import durge.math.vector;

class Camera3D
{
	private Vector3D _position;
	private Vector3D _direction;
	private float_t _pitch;

	this()
	{
		_position = Vector3D(0.0, 0.0, 0.0);
		_direction = Vector3D(1.0, 0.0, 0.0);
		_pitch = 0.0;
	}

	@property Vector3D position() { return _position; }
	@property Vector3D direction() { return _direction; }
	@property float_t pitch() { return _pitch; }
}
