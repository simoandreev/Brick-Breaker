//
//  Brick.m
//  Brick Breaker
//
//  Created by Simeon Andreev on 12/11/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import "Brick.h"

@implementation Brick {
    SKAction *_brickSmashSound;
}

-(instancetype)initWithType:(BrickType)type
{
    switch (type) {
        case Green:
            self = [super initWithImageNamed:@"BrickGreen"];
            break;
        case Blue:
            self = [super initWithImageNamed:@"BrickBlue"];
            break;
        case Grey:
            self = [super initWithImageNamed:@"BrickGrey"];
            break;
        case Yellow:
            self = [super initWithImageNamed:@"BrickYellow"];
            break;
        default:
            self = nil;
            break;
    }
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = kBrickCategory;
        self.physicsBody.dynamic = NO;
        self.type = type;
        self.indestructible = (type == Grey);
        self.spawnsExtraBall = (type == Yellow);
        
        //Setup sounds
        _brickSmashSound = [SKAction playSoundFileNamed:@"BrickSmash.caf" waitForCompletion:NO];
    }
    return self;
}

-(void)hit {
    switch (self.type) {
        case Green:
            [self createExplosion];
            [self runAction:_brickSmashSound];
            [self runAction:[SKAction removeFromParent]];
            break;
        case Blue:
            self.texture = [SKTexture textureWithImageNamed:@"BrickGreen"];
            self.type = Green;
            break;
        case Yellow:
            [self createExplosion];
            [self runAction:_brickSmashSound];
            [self runAction:[SKAction removeFromParent]];
            break;
        default:
            break;
    }
}

-(void)createExplosion
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Brick Explosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.position = self.position;
    [self.parent addChild:explosion];
    SKAction *removeExplosion = [SKAction sequence:@[[SKAction waitForDuration:explosion.particleLifetime + explosion.particleLifetimeRange],
                                                     [SKAction removeFromParent]]];
    [explosion runAction:removeExplosion];
}


@end
