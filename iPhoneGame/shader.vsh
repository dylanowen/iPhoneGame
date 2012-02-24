attribute vec4 position;
attribute vec4 color;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

varying lowp vec4 fragmentColor;

void main()
{
	gl_Position = modelViewProjectionMatrix * position;
	gl_PointSize = 4.0;
	fragmentColor = color;
}