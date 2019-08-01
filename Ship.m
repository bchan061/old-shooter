//
//  Ship.m
//  ShootupSurvival
//
//  Created by Brandon on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ship.h"
#import "SimpleAudioEngine.h"

@implementation Ship
    - (id)init
    {
        if(self = [super init])
        {
            Frame = 0;
            PScore = 0;
            ShootFrame = -1;
            Weapon = 1;
            Lives = 5;
            InvFrame = -1;
            MinesLaid = 0;
        }
        return self;
    }
    - (id)initWithArguments: (bool) IsEnemy
    {
        if(self = [self init])
        {
            isEnemy = IsEnemy;
            shipRectangle = CGRectMake(0, 0, 25, 30);
            isFiring = false;
        }
        return self;
    }

- (void)HandleLives:(CCLabelTTF*)livesleft
{
    if(InvFrame == -1) { Lives--; InvFrame = 0; }
    if(Lives <= 0)
    {
        InvFrame = 0;
    }
    else { livesleft.string = [NSString stringWithFormat:@"Lives: %d", Lives]; }
}

- (CCSprite*)CreateBullet:(CGPoint)p:(int)type
{
    CCSprite* bullet = [CCSprite spriteWithFile:@"bullet.png"];
    bullet.tag = 1000+type;
    bullet.position = p;
    return bullet;
}

- (void)ResetShootFrame
{
    ShootCount = 0;
    ShootFrame = -1;
}

- (void)AddLive:(CCLabelTTF *)lives:(int)Wave
{
    if(Wave < 20)
    {
        if(PScore >= 150) { Lives++; [self AddScore:-150 :label]; lives.string = [NSString stringWithFormat:@"Lives: %d", Lives]; }
    }
    if(Wave >= 20)
    {
        if(PScore >= 200) { Lives++; [self AddScore:-200 :label]; lives.string = [NSString stringWithFormat:@"Lives: %d", Lives]; }
    }
}

- (int)GetWeapon { return Weapon; }
- (int)GetLives { return Lives; }

    - (void)Update: (CCLayer*) layer:(CCSprite*) s;
    {
        if (isFiring)
        {
            if (ShootFrame == -1)
            {
                switch (Weapon) {
                    case 1:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot.caf"];
                        ShootFrame = 0;
                    break;
                    case 2:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :1]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :3]];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot2.caf"];
                        ShootFrame = 0;
                    break;
                    case 3:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot.caf"];
                        ShootFrame = 0;
                    break;
                    case 4:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :4]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :6]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :8]];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot2.caf"];
                        ShootFrame = 0;
                    break;
                    case 5:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :1]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :3]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :4]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :6]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :7]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :8]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :9]];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot2.caf"];
                        ShootFrame = 0;
                    break;
                    case 6:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16):5] ];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot.caf"];
                        ShootFrame = 0;
                    break;
                    case 8:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :5]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y - 16) :5]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x+14, shipRectangle.origin.y) :5]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x-14, shipRectangle.origin.y) :5]];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot2.caf"];
                        ShootFrame = 0;
                    break;
                    case 9:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :1]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :3]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :7]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :9]];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot2.caf"];
                        ShootFrame = 0;
                    break;
                    case 10:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot2.caf"];
                        ShootFrame = 0;
                    break;
                    case 11:
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :2]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :4]];
                        [layer addChild:[self CreateBullet:CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y + 16) :6]];
                        ShootFrame = 0;
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shoot2.caf"];
                    break;
                        
                }
                ShootCount++;
            }
            if(ShootCount == 120) { ShootCount = 0; }
            if(ShootFrame >= 0) { ShootFrame++; }
        }
        if(ShootFrame >= 0)
        {
            switch (Weapon) {
                case 1:
                    if (ShootFrame == 15) { ShootFrame = -1; }
                break;
                case 2:
                    if (ShootFrame == 37) { ShootFrame = -1; }
                break;
                case 3:
                    if (ShootFrame == 7) { ShootFrame = -1; }
                break;
                case 4:
                    if (ShootFrame == 30) { ShootFrame = -1; }
                break;
                case 5:
                    if (ShootFrame == 40) { ShootFrame = -1; }
                break;
                case 6:
                    if (ShootFrame == 30) { ShootFrame = -1; }
                break;
                case 8:
                    if (ShootFrame == 75) { ShootFrame = -1; }
                break;
                case 9:
                    if (ShootFrame == 15) { ShootFrame = -1; }
                break;
                case 10:
                    if (ShootFrame == 60) { ShootFrame = -1; }
                break;
                case 11:
                    if (ShootCount == 60) { [self ResetShootFrame]; Weapon = 5; }
                    if (ShootFrame == 11) { ShootFrame = -1; }
                break;
            }
        }
        Frame++;
        if (Frame == 300) { Frame = 0; }
        if (InvFrame >= 0) {
            InvFrame++;
            if(InvFrame % 4 <= 2) { s.visible = false; }
            else if (InvFrame % 4 == 3) { s.visible = true; }
        }
        if (InvFrame == 60) { InvFrame = -1; s.visible = true; }
    }

    - (void)BuyWeapon:(CCMenuItem*)item
    {
        switch(item.tag)
        {
            case 10001: Weapon = 1; break;
            case 10002: if(PScore >= 25) { [self AddScore:-25 :label]; ShootFrame = 0; Weapon = 2; } break;
            case 10003: if(PScore >= 25) { [self AddScore:-25 :label]; ShootFrame = 0; Weapon = 3; } break;
            case 10004: if(PScore >= 50) { [self AddScore:-50 :label]; ShootFrame = 0; Weapon = 4; } break;
            case 10005: if(PScore >= 75) { [self AddScore:-75 :label]; ShootFrame = 0; Weapon = 5; } break;
            case 10006: if(PScore >= 100) { [self AddScore:-100 :label]; ShootFrame = 0; Weapon = 6; } break;
            case 10008: if(PScore >= 200) { [self AddScore:-200 :label]; ShootFrame = 0; Weapon = 8; } break;
            case 10009: if(PScore >= 350) { [self AddScore:-350 :label]; ShootFrame = 0; Weapon = 9; } break;
            case 10010: if(PScore >= 250) { [self AddScore:-250 :label]; ShootFrame = 0; Weapon = 10; } break;
        }
    }

    - (void)AddScore:(int)score :(CCLabelTTF *)scoret
    {
        PScore += score;
        label = scoret;
        scoret.string = [NSString stringWithFormat:@"Score: %d", PScore];
    }

    - (void)StartFiring { isFiring = true; }
    - (void)EndFiring { isFiring = false; }
    - (void)SetWeapon: (int)weapon { Weapon = weapon; }

    - (CGPoint)ReturnPoint
    {  
        return CGPointMake(shipRectangle.origin.x, shipRectangle.origin.y);
    }

    - (void)PointToRect:(CGPoint)point
    {
        shipRectangle = CGRectMake(point.x, point.y, 25, 30);
    }

    - (CGRect)GetRectangle { return shipRectangle; }

    - (void)dealloc
    {
        [super dealloc];
    }
@end
