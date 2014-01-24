//
//  SKShapeNode+DebugDraw.h
//  blocks
//
//  Created by Paul Jackson on 24/01/2014.
//  Copyright (c) 2014 PaulJ. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (DebugDraw)

- (void)attachDebugRectWithSize:(CGSize)size;
- (void)attachDebugFrameFromPath:(CGPathRef)path;

@end
