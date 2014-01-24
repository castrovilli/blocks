//
//  SKShapeNode+DebugDraw.m
//  blocks
//
//  Created by Paul Jackson on 24/01/2014.
//  Copyright (c) 2014 PaulJ. All rights reserved.
//

#import "SKNode+DebugDraw.h"

static BOOL kDebugDraw = YES;

@implementation SKNode (DebugDraw)

- (void)attachDebugRectWithSize:(CGSize)size
{
    CGRect pathRect = CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height);
    CGPathRef path = CGPathCreateWithRect(pathRect ,nil);
    
    [self attachDebugFrameFromPath:path];
    CGPathRelease(path);
}

- (void)attachDebugFrameFromPath:(CGPathRef)path
{
    if (kDebugDraw == NO) return;
    
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = path;
    shape.strokeColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
    shape.lineWidth = 1.0;
    
    [self addChild:shape];
}

@end
