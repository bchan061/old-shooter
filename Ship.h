//
//  Ship.h
//  ShootupSurvival
//
//  Created by Brandon on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libs/cocos2d/cocos2d.h"
#import "libs/cocos2d-ui/cocos2d-ui.h"

// BULLET DIRECTIONS
// --------------------------
// Homing                   0
// UpLeft                   1
// Up                       2
// UpRight                  3
// Left                     4
// Mine                     5
// Right                    6
// DownLeft                 7
// Down                     8
// DownRight                9

@interface Ship : NSObject
{
    bool isEnemy;
    CGRect shipRectangle;
    int Weapon;
    bool isFiring;
    int Frame;
    int ShootFrame;
    int Lives;
    int InvFrame;
    int PScore;
    int MinesLaid;
    short ShootCount;
    CCLabelTTF* label;
}
-(id)initWithArguments:(bool) IsEnemy;
-(CGPoint)ReturnPoint;
-(void)PointToRect:(CGPoint) point;
-(CGRect)GetRectangle;
-(int)GetLives;
-(void)ResetShootFrame;
-(void)AddScore:(int)score:(CCLabelTTF*)scoret;
-(void)AddLive:(CCLabelTTF*)lives:(int)Wave;

-(void)HandleLives:(CCLabelTTF*)livesleft;
-(void)BuyWeapon:(CCButton*)item;

-(void)Update:(CCNode*)layer:(CCSprite*)s;

-(void)SetWeapon:(int)weapon;
-(int)GetWeapon;
-(void)StartFiring;
-(void)EndFiring;
@end
