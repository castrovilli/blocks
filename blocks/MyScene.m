//
//  MyScene.m
//  blocks
//
//  Created by Paul Jackson on 23/12/2013.
//  Copyright (c) 2013 PaulJ. All rights reserved.
//

#import "MyScene.h"
#import "SKNode+DebugDraw.h"

static NSString *BKSNodeNameBall   = @"ball";
static NSString *BKSNodeNamePaddle = @"paddle";
static NSString *BKSNodeNameBlock  = @"block";

typedef NS_ENUM(uint16_t, BKSCategory)
{
    BKSCategoryBall   = 1 << 1,
    BKSCategoryPaddle = 1 << 2,
    BKSCategoryBlock  = 1 << 3,
    BKSCategoryBottom = 1 << 4
};

@interface MyScene () <SKPhysicsContactDelegate>
@end

@implementation MyScene
{
    SKNode *_gameNode;
    BOOL _isRunning;
    BOOL _isPlaying;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        [self initializeScene];
    }
    return self;
}

- (void)initializeScene
{
    CGPathRef path;
    
    // World
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    _isRunning = NO;

    // Frame
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.friction = 0;
    
    // Paddle
    path = CGPathCreateWithRect(CGRectMake(-35, -5, 70, 10), nil);
    SKShapeNode *paddle = [SKShapeNode node];
    paddle.name = BKSNodeNamePaddle;
    paddle.path = path;
    paddle.fillColor = [SKColor whiteColor];
    paddle.position = CGPointMake(self.size.width / 2, self.size.height * 0.2);
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
    paddle.physicsBody.categoryBitMask = BKSCategoryPaddle;
    paddle.physicsBody.dynamic = NO;
    CGPathRelease(path);
    
    [self addChild:paddle];
    
    // Ball
    path = CGPathCreateWithRect(CGRectMake(-2.5, -2.5, 10, 10), nil);
    SKShapeNode *ball = [SKShapeNode node];
    ball.name = BKSNodeNameBall;
    ball.path = path;
    ball.fillColor = [SKColor whiteColor];
    ball.position = CGPointMake(self.size.width / 2, self.size.height * 0.4);
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:3.0];
    ball.physicsBody.categoryBitMask = BKSCategoryBall;
    ball.physicsBody.friction = 0;
    ball.physicsBody.restitution = 1.0;
    ball.physicsBody.linearDamping = 0.0;
    ball.physicsBody.mass *= 4;
    ball.physicsBody.allowsRotation = NO;
    CGPathRelease(path);
    
    [self addChild:ball];
    
    SKNode *bottom = [SKNode node];
    CGSize bottomSize = CGSizeMake(self.size.width, 1.0f);
    bottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bottomSize];
    bottom.physicsBody.categoryBitMask = BKSCategoryBottom;
    bottom.physicsBody.collisionBitMask = BKSCategoryBall;
    bottom.physicsBody.contactTestBitMask = BKSCategoryBall;
    bottom.physicsBody.dynamic = NO;
    bottom.position = CGPointMake(bottomSize.width / 2, 1.0f);
    
    [self addChild:bottom];
    [bottom attachDebugRectWithSize:bottomSize];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Start the level
    if (!_isRunning) {
        SKNode *ball = [self childNodeWithName:BKSNodeNameBall];
        [ball.physicsBody applyImpulse:CGVectorMake(1.0, 1.0)];
        _isRunning = YES;
    }
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    _isPlaying = [self.physicsWorld bodyAtPoint:location].categoryBitMask == BKSCategoryPaddle;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isPlaying) return;
    
    // Touch data
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    
    // Target
    SKShapeNode *paddle = (SKShapeNode *)[self childNodeWithName:BKSNodeNamePaddle];

    // Caclulate X
    CGFloat delta = (location.x - previousLocation.x);
    CGFloat paddleX = paddle.position.x + delta;
    
    // Clamp
    paddleX = MAX(paddleX, paddle.frame.size.width / 2);
    paddleX = MIN(paddleX, self.size.width - paddle.frame.size.width / 2);

    // Move
    paddle.position = CGPointMake(paddleX, paddle.position.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isPlaying = NO;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKShapeNode *ball = (SKShapeNode *)[self childNodeWithName:BKSNodeNameBall];
    ball.physicsBody = nil;
    ball.fillColor = ball.strokeColor = [SKColor redColor];
}

@end
