//
//  GameScene.m
//  Brick Breaker
//
//  Created by Simeon Andreev on 12/10/15.
//  Copyright (c) 2015 Simeon Andreev. All rights reserved.
//

#import "GameScene.h"
#import "Brick.h"

static const uint32_t kBallCategory   = 0x1 << 0;
static const uint32_t kPaddleCategory = 0x1 << 1;

@implementation GameScene {
    SKSpriteNode *_paddle;
    CGPoint _touchLocation;
    CGFloat _ballSpeed;
    SKNode *_brickLayer;
    BOOL _ballReleased;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    // Set contact delgate.
    self.physicsWorld.contactDelegate = self;
    
    // Turn off gravity.
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    
    // Setup edge.
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    //Setup Paddle
    _paddle = [SKSpriteNode spriteNodeWithImageNamed:@"Paddle"];
    _paddle.position = CGPointMake(self.size.width * 0.5, 90);
    _paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_paddle.size];
    _paddle.physicsBody.dynamic = NO;
    _paddle.physicsBody.categoryBitMask = kPaddleCategory;
    [self addChild:_paddle];
    
    // Set initial values.
    _ballSpeed = 250.0;
    _ballReleased = NO;
    
    // Setup brick layer.
    _brickLayer = [SKNode node];
    _brickLayer.position = CGPointMake(0, self.size.height);
    [self addChild:_brickLayer];
    
    // Load level.
    [self loadLevel:0];
    
    // Create positioning ball.
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"BallBlue"];
    ball.position = CGPointMake(0, _paddle.size.height);
    [_paddle addChild:ball];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        _touchLocation = [touch locationInNode:self];
    
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_ballReleased) {
        _ballReleased = YES;
        [_paddle removeAllChildren];
        [self createBallWithLocation:CGPointMake(_paddle.position.x, _paddle.position.y + _paddle.size.height) andVelocity:CGVectorMake(0, _ballSpeed)];
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    } else {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    
    if (firstBody.categoryBitMask == kBallCategory && secondBody.categoryBitMask == kBrickCategory) {
        if ([secondBody.node respondsToSelector:@selector(hit)]) {
            [secondBody.node performSelector:@selector(hit)];
        }
    }
    
    if (firstBody.categoryBitMask == kBallCategory && secondBody.categoryBitMask == kPaddleCategory) {
        if (firstBody.node.position.y > secondBody.node.position.y) {
            // Get contact point in paddle coordinates.
            CGPoint pointInPaddle = [secondBody.node convertPoint:contact.contactPoint fromNode:self];
            // Get contact position as a percentage of the paddle's width.
            CGFloat x = (pointInPaddle.x + secondBody.node.frame.size.width * 0.5) / secondBody.node.frame.size.width;
            // Cap percentage and flip it.
            CGFloat multiplier = 1.0 - fmaxf(fminf(x, 1.0),0.0);
            // Calculate angle based on ball position in paddle.
            CGFloat angle = (M_PI_2 * multiplier) + M_PI_4;
            // Convert angle to vector.
            CGVector direction = CGVectorMake(cosf(angle), sinf(angle));
            // Set ball's velocity based on direction and speed.
            firstBody.velocity = CGVectorMake(direction.dx * _ballSpeed, direction.dy * _ballSpeed);
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // Calculate how far touch has moved on x axis.
        CGFloat xMovement = [touch locationInNode:self].x - _touchLocation.x;
        // Move paddle distance of touch.
        _paddle.position = CGPointMake(_paddle.position.x + xMovement, _paddle.position.y);
        
        CGFloat paddleMinX = -_paddle.size.width * 0.25;
        CGFloat paddleMaxX = self.size.width + (_paddle.size.width * 0.25);
        // Cap paddle's position so it remains on screen.
        if (_paddle.position.x < paddleMinX) {
            _paddle.position = CGPointMake(paddleMinX, _paddle.position.y);
        }
        if (_paddle.position.x > paddleMaxX) {
            _paddle.position = CGPointMake(paddleMaxX, _paddle.position.y);
        }

        _touchLocation = [touch locationInNode:self];
    }
}

-(SKSpriteNode*)createBallWithLocation:(CGPoint)position andVelocity:(CGVector)velocity
{
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"BallBlue"];
    ball.name = @"ball";
    ball.position = position;
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width * 0.5];
    ball.physicsBody.friction = 0.0;
    ball.physicsBody.linearDamping = 0.0;
    ball.physicsBody.restitution = 1.0;
    ball.physicsBody.velocity = velocity;
    ball.physicsBody.categoryBitMask = kBallCategory;
    ball.physicsBody.contactTestBitMask = kPaddleCategory | kBrickCategory;
    [self addChild:ball];
    return ball;
}

-(void)loadLevel:(int)levelNumber
{
    NSArray *level = nil;
    switch (levelNumber) {
        case 0:
            level = @[@[@1,@1,@1,@1,@1,@1],
                      @[@1,@1,@1,@1,@1,@1],
                      @[@0,@0,@0,@0,@0,@0],
                      @[@0,@0,@0,@0,@0,@0],
                      @[@2,@2,@3,@3,@2,@2]];
            break;
        default:
            break;
    }
    
    int row = 0;
    int col = 0;
    for (NSArray *rowBricks in level) {
        col = 0;
        for (NSNumber *brickType in rowBricks) {
            if ([brickType intValue] > 0) {
                Brick *brick = [[Brick alloc] initWithType:(BrickType)[brickType intValue]];
                if (brick) {
                    brick.position = CGPointMake(2 + (brick.size.width * 0.5) + ((brick.size.width + 3) * col)
                                                 , -(2 + (brick.size.height * 0.5) + ((brick.size.height + 3) * row)));
                    [_brickLayer addChild:brick];
                }
            }
            col++;
        }
        row++;
    }
}
@end
