//
//  MatrixFunctions.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef iPhoneGame_MatrixFunctions_h
#define iPhoneGame_MatrixFunctions_h

#import <GLKit/GLKit.h>

#import "GameConstants.h"

static __inline__ GLKMatrix4 CenterOrtho(float x, float y)
{
	GLKMatrix4 m = {
		2.0f / DYNAMIC_VIEW_WIDTH, 0.0f, 0.0f, 0.0f,
		0.0f, -2.0f / DYNAMIC_VIEW_HEIGHT, 0.0f, 0.0f,
		0.0f, 0.0f, -2.0f / VIEW_DISTANCE, 0.0f,
		x * -2.0f / DYNAMIC_VIEW_WIDTH, y * 2.0f / DYNAMIC_VIEW_HEIGHT, -1.0f, 1.0f
	};
	
	return m;
}

static __inline__ GLKMatrix4 CenterOrthoVector(GLKVector2 v)
{
	return CenterOrtho(v.x, v.y);
}

static __inline__ void MoveOrtho(GLKMatrix4 *m, float x, float y)
{
	//assumes you've already generated m
	m->m[12] = x * -2.0f / DYNAMIC_VIEW_WIDTH;
	m->m[13] = y * 2.0f / DYNAMIC_VIEW_HEIGHT;
}

static __inline__ void MoveOrthoVector(GLKMatrix4 *m, GLKVector2 v)
{
	MoveOrtho(m, v.x, v.y);
}

#endif
