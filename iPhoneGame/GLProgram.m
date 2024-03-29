//
//  GLProgram.m
//  iPhoneGame
//
//  Created by Lion User on 23/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLProgram.h"

#include "GameConstants.h"

#pragma mark Function Pointer Definitions
typedef void (*GLInfoFunction)
(
	GLuint program, 
	GLenum pname, 
	GLint* params
);
typedef void (*GLLogFunction)
(
	GLuint program, 
	GLsizei bufsize, 
	GLsizei* length, 
	GLchar* infolog
);

#pragma mark -
#pragma mark Private Extension Method Declaration
@interface GLProgram()
{
	GLuint program;
	NSMutableArray  *attributes;
	NSMutableArray  *uniforms;
	GLuint vertShader, fragShader;
}
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (NSString *)logForOpenGLObject:(GLuint)object infoCallback:(GLInfoFunction)infoFunc logFunc:(GLLogFunction)logFunc;

@end
#pragma mark -

@implementation GLProgram
- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename
{
	if (self = [super init])
	{
		attributes = [[NSMutableArray alloc] init];
		uniforms = [[NSMutableArray alloc] init];
		NSString *vertShaderPathname, *fragShaderPathname;
		program = glCreateProgram();

		vertShaderPathname = [[NSBundle mainBundle] 
			pathForResource:vShaderFilename 
			ofType:@"vsh"];
		if (![self compileShader:&vertShader 
			type:GL_VERTEX_SHADER 
			file:vertShaderPathname])
			NSLog(@"Failed to compile vertex shader");

// Create and compile fragment shader
		fragShaderPathname = [[NSBundle mainBundle] 
			pathForResource:fShaderFilename 
			ofType:@"fsh"];
		if (![self compileShader:&fragShader 
			type:GL_FRAGMENT_SHADER 
			file:fragShaderPathname])
			NSLog(@"Failed to compile fragment shader");

		glAttachShader(program, vertShader);
		glAttachShader(program, fragShader);
	}

	return self;
}
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
	GLint status;
	const GLchar *source;
	/*
	NSString *constants = [[NSString alloc] initWithFormat:
								  @"#define BROWN1 vec4(%s, 1.0)\n"
								   "#define BROWN2 vec4(%s, 1.0)\n"
									"#define BROWN3 vec4(%s, 1.0)\n"
									"#define BROWN4 vec4(%s, 1.0)\n"
									"#define BROWN5 vec4(%s, 1.0)\n"
								   "#define RED6 vec4(%.2f, %.2f, %.2f, 1.0)\n"
								   "#define RED7 vec4(%.2f, %.2f, %.2f, 1.0)\n"
								   "#define RED8 vec4(%.2f, %.2f, %.2f, 1.0)\n"
								   "#define RED9 vec4(%.2f, %.2f, %.2f, 1.0)\n"
								   "#define RED10 vec4(%.2f, %.2f, %.2f, 1.0)\n",
								  BROWN1, BROWN2, BROWN3, BROWN4, BROWN5, RED6_0, RED6_1, RED6_2, RED7_0, RED7_1, RED7_2, RED8_0, RED8_1, RED8_2, RED9_0, RED9_1, RED9_2, RED10_0, RED10_1, RED10_2];
	*/
	 
	NSMutableString *fileSource = [NSMutableString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
	//[fileSource replaceOccurrencesOfString:@"#include Constants\n" withString:constants options:NSLiteralSearch range:NSMakeRange(0, [fileSource length])];
	
	//NSLog(@"%@", fileSource);
	
	source = (GLchar *)[fileSource UTF8String];
	if (!source)
	{
		NSLog(@"Failed to load vertex shader");
		return NO;
	}

	*shader = glCreateShader(type);
	glShaderSource(*shader, 1, &source, NULL);
	glCompileShader(*shader);

	glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
	return status == GL_TRUE;
}
#pragma mark -
- (GLuint)addAttribute:(NSString *)attributeName
{
	GLuint temp;
   if (![attributes containsObject:attributeName])
   {
		[attributes addObject:attributeName];
		temp = [self attributeIndex: attributeName];
		glBindAttribLocation(program, temp, [attributeName UTF8String]);
	}
	else
	{
		temp = [self attributeIndex: attributeName];
	}
	return temp;
}
- (GLuint)attributeIndex:(NSString *)attributeName
{
	return [attributes indexOfObject:attributeName];
}
- (GLuint)uniformIndex:(NSString *)uniformName
{
	return glGetUniformLocation(program, [uniformName UTF8String]);
}
#pragma mark -
- (BOOL)link
{
	GLint status;

	glLinkProgram(program);
	//glValidateProgram(program);
	
	
	GLint logLength;
	glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0) {
		GLchar *log = (GLchar *)malloc(logLength);
		glGetProgramInfoLog(program, logLength, &logLength, log);
		NSLog(@"Program link log:\n%s", log);
		free(log);
	}
	
	glGetProgramiv(program, GL_LINK_STATUS, &status);
	if (status == GL_FALSE)
		return NO;

	if (vertShader)
		glDeleteShader(vertShader);
	if (fragShader)
		glDeleteShader(fragShader);

	return YES;
}
- (void)use
{
	glUseProgram(program);
}
#pragma mark -
- (NSString *)logForOpenGLObject:(GLuint)object infoCallback:(GLInfoFunction)infoFunc logFunc:(GLLogFunction)logFunc
{
	GLint logLength = 0, charsWritten = 0;

	infoFunc(object, GL_INFO_LOG_LENGTH, &logLength);	
	if (logLength < 1)
		return nil;

	char *logBytes = malloc(logLength);
	logFunc(object, logLength, &charsWritten, logBytes);
	NSString *log = [[NSString alloc] initWithBytes:logBytes 
		length:logLength 
		encoding:NSUTF8StringEncoding];
	free(logBytes);
	return log;
}
- (NSString *)vertexShaderLog
{
	return [self logForOpenGLObject:vertShader infoCallback:(GLInfoFunction)&glGetProgramiv logFunc:(GLLogFunction)&glGetProgramInfoLog];

}
- (NSString *)fragmentShaderLog
{
	return [self logForOpenGLObject:fragShader infoCallback:(GLInfoFunction)&glGetProgramiv logFunc:(GLLogFunction)&glGetProgramInfoLog];
}
- (NSString *)programLog
{
	return [self logForOpenGLObject:program infoCallback:(GLInfoFunction)&glGetProgramiv logFunc:(GLLogFunction)&glGetProgramInfoLog];
}
#pragma mark -
- (void)dealloc
{
	if (vertShader)
		glDeleteShader(vertShader);

	if (fragShader)
		glDeleteShader(fragShader);

	if (program)
		glDeleteProgram(program);
}
@end
