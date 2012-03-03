attribute vec4 position;

uniform mat4 modelViewProjectionMatrix;

void main()
{
	gl_Position = modelViewProjectionMatrix * position;
	gl_PointSize = 4.0;
}