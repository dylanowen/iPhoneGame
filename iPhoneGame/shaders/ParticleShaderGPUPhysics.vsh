attribute vec2 initialPosition;
attribute vec2 initialVelocity;
attribute vec4 color;
attribute float time;

uniform mat4 modelViewProjectionMatrix;
uniform float gravity;

varying lowp vec4 fragmentColor;

void main()
{
	vec4 position = vec4(0, 0, 0, 1);
	position.x = initialPosition.x + initialVelocity.x * time;
	position.y = initialPosition.y + initialVelocity.y * time - 0.5 * gravity * time * time;

	gl_Position = modelViewProjectionMatrix * position;
	gl_PointSize = 6.0 - time * 3.0;
	fragmentColor = color;
}


