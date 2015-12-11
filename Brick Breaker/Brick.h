//
//  Brick.h
//  Brick Breaker
//
//  Created by Simeon Andreev on 12/11/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    Green = 1,
    Blue = 2,
    Grey = 3,
} BrickType;

static const uint32_t kBrickCategory = 0x1 << 2;

@interface Brick : SKSpriteNode

@property (nonatomic) BrickType type;
@property (nonatomic) BOOL indestructible;

-(instancetype)initWithType:(BrickType)type;

-(void)hit;

@end
