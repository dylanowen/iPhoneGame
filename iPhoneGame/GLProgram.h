//
//  GLProgram.h
//  iPhoneGame
//
//  Created by Lion User on 23/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

//copied from http://iphonedevelopment.blogspot.com/2010/11/opengl-es-20-for-ios-chapter-4.html

@interface GLProgram : NSObject 
{
@public 
	GLuint program;
}
- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename 
fragmentShaderFilename:(NSString *)fShaderFilename;
- (GLuint)addAttribute:(NSString *)attributeName;
- (GLuint)attributeIndex:(NSString *)attributeName;
- (GLuint)uniformIndex:(NSString *)uniformName;
- (BOOL)link;
- (void)use;
- (NSString *)vertexShaderLog;
- (NSString *)fragmentShaderLog;
- (NSString *)programLog;
@end

