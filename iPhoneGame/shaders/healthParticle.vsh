attribute vec2 initialPosition;
attribute float time; //ranges from 0 to 1.5

uniform mat4 modelViewProjectionMatrix;

varying lowp vec4 fragmentColor;

void main()
{
	vec4 position = vec4(0, 0, 0, 1);
	position.x = initialPosition.x + cos(time * 20.0) * 2.0;
	position.y = initialPosition.y - time * 10.0;
	
	gl_Position = modelViewProjectionMatrix * position;
	gl_PointSize = 6.0 - time;
	
	float temp = 0.6 + time * 0.26;
	fragmentColor = vec4(temp, temp, 0.0, 1.0);
}


