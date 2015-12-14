//
//  Menu.m
//  Brick Breaker
//
//  Created by Simeon Andreev on 12/14/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import "Menu.h"

@implementation Menu

SKSpriteNode *_menuPanel;
SKSpriteNode *_playButton;
SKLabelNode *_panelText;
SKLabelNode *_buttonText;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _menuPanel = [SKSpriteNode spriteNodeWithImageNamed:@"MenuPanel"];
        _playButton = [SKSpriteNode spriteNodeWithImageNamed:@"Button"];
        
        _panelText = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
        _panelText.text = @"LEVEL 1";
        _panelText.fontColor = [SKColor grayColor];
        _panelText.fontSize = 15;
        _panelText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [_menuPanel addChild:_panelText];
        
        _buttonText = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
        _buttonText.name = @"Play Button";
        _buttonText.text = @"PLAY";
        _buttonText.position = CGPointMake(0, 2);
        _buttonText.fontColor = [SKColor grayColor];
        _buttonText.fontSize = 15;
        _buttonText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _playButton.name = @"Play Button";
        [_playButton addChild:_buttonText];
        
        
        _menuPanel.position = CGPointZero;
        [self addChild:_menuPanel];
        
        _playButton.position = CGPointMake(0, -((_menuPanel.size.height * 0.5) + (_playButton.size.height * 0.5) + 10));
        [self addChild:_playButton];
        
    }
    return self;
}

-(void)setLevelNumber:(int)levelNumber
{
    NSLog(@"Level number :%d", levelNumber);
    _levelNumber = levelNumber;
    _panelText.text = [NSString stringWithFormat:@"Level %d", levelNumber];
}

-(void)show {
    SKAction *slideLeft = [SKAction moveByX:-260.0 y:0.0 duration:0.5];
    slideLeft.timingMode = SKActionTimingEaseOut;
    SKAction *slideRight = [SKAction moveByX:260.0 y:0.0 duration:0.5];
    slideRight.timingMode = SKActionTimingEaseOut;
    _menuPanel.position = CGPointMake(260, _menuPanel.position.y);
    _playButton.position = CGPointMake(-260, _playButton.position.y);
    [_menuPanel runAction:slideLeft];
    [_playButton runAction:slideRight];
    self.hidden = NO;
}

-(void)hide {
    SKAction *slideLeft = [SKAction moveByX:-260.0 y:0.0 duration:0.5];
    slideLeft.timingMode = SKActionTimingEaseIn;
    SKAction *slideRight = [SKAction moveByX:260.0 y:0.0 duration:0.5];
    slideRight.timingMode = SKActionTimingEaseIn;
    _menuPanel.position = CGPointMake(0, _menuPanel.position.y);
    _playButton.position = CGPointMake(0, _playButton.position.y);
    [_menuPanel runAction:slideLeft];
    [_playButton runAction:slideRight completion:^{
        self.hidden = YES;
    }];
}

@end
