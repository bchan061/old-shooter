//
//  Game.h
//  ShootupSurvival
//
//  Created by Brandon on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Ship.h"

@interface Game : CCNode
{
    CCSprite *background;
    CCSprite *player;
    Ship *PlayerShip;
    CCLabelTTF *wave;
    CCLabelTTF *secsleft;
    CCLabelTTF *foesleft;
    CCLabelTTF *livesleft;
    CCLabelTTF *ready;
    CCLabelTTF *scoret;
    CCLabelTTF *shopt;
    CCLabelTTF *bossc;
    CCLabelTTF *hscore;
    CCLabelTTF *pause;
    
    CCLabelTTF *survive;
    
    CCMenu* shop;
    CCMenuItem* weapon1;
    CCMenuItem* weapon2;
    CCMenuItem* weapon3;
    CCMenuItem* weapon4;
    CCMenuItem* weapon5;
    CCMenuItem* weapon6;
    CCMenuItem* weapon7;
    CCMenuItem* weapon8;
    
    int SecsLeft;
    int Wave;
    int Frame;
    bool OnBreak;
    bool IsPaused;
    bool IsDead;
    CGSize size;
 
    UIAlertView *hscoreview;
    UITextField *tf;
    NSUserDefaults *prefs;
    
    int cpulives;
    
}
+(CCScene *) scene;
-(void)CreateMenu;
-(void)update;
-(void)AddEnemies:(int)Wave;
-(void)Die;

@end
