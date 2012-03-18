attribute vec4 position;

uniform mat4 modelViewProjectionMatrix;
uniform vec4 color;

varying lowp vec4 fragmentColor;

void main()
{
	gl_Position = modelViewProjectionMatrix * position;
	gl_PointSize = 6.0;
	fragmentColor = color;
}