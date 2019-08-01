//
//  Game.m
//  ShootupSurvival
//
//  Created by Brandon on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "Game.h"
#import "SimpleAudioEngine.h"

@implementation Game

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Game *layer = [Game node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    if (self=[super init]) {
        size = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = true;
        SecsLeft = 10;
        Wave = 0;
        OnBreak = true;
        PlayerShip = [[Ship alloc] initWithArguments:false];
        background = [CCSprite spriteWithFile:@"background.png" rect:CGRectMake(0, 0, size.width, size.height)];
        background.position = ccp(size.width/2, size.height/2);
        secsleft = [CCLabelTTF labelWithString:@"Next wave in: 10" fontName:@"Courier" fontSize:32];
        secsleft.position = ccp(size.width/2, size.height/2);
        wave = [CCLabelTTF labelWithString:@"Wave 0" fontName:@"Courier" fontSize:16];
        wave.position = ccp(30, size.height-10);
        player = [CCSprite spriteWithFile:@"ship.png"];
        player.position = ccp(size.width/2-14, 15);
        foesleft = [CCLabelTTF labelWithString:@"Enemies Left: 0" fontName:@"Courier" fontSize:16];
        foesleft.position = ccp(75, size.height-30);
        livesleft = [CCLabelTTF labelWithString:@"Lives: 5" fontName:@"Courier" fontSize:16];
        livesleft.position = ccp(size.width-45, 10);
        ready = [CCLabelTTF labelWithString:@"Tap to Skip Timer" fontName:@"Courier" fontSize:16];
        ready.position = ccp(size.width-80, size.height-12);
        ready.color = ccRED;
        scoret = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Courier" fontSize:16];
        scoret.position = ccp(size.width/2, 10);
        scoret.color = ccGREEN;
        shopt = [CCLabelTTF labelWithString:@"Tap for Shop" fontName:@"Courier" fontSize:16];
        shopt.position = ccp(size.width-60, 30);
        shopt.color = ccRED;
        survive = [CCLabelTTF labelWithString:@"Survived to Wave 0\nTap the Screen" fontName:@"Courier" fontSize:24];
        survive.position = ccp(size.width/2, size.height/2);
        survive.color = ccRED;
        survive.visible = false;
        bossc = [CCLabelTTF labelWithString:@"BOSS APPROACHING" fontName:@"Courier" fontSize:36];
        bossc.position = ccp(size.width/2, size.height/2-50);
        bossc.color = ccRED;
        bossc.visible = false;
        hscoreview = [[UIAlertView alloc] initWithTitle:@"High Score - Enter your Name" message:@" " delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil];
        hscore = [CCLabelTTF labelWithString:@"High Score: with " fontName:@"Courier" fontSize:16];
        hscore.position = ccp(size.width/2, size.height/2-50);
        hscore.visible = false;
        pause = [CCLabelTTF labelWithString:@"Tap to Pause" fontName:@"Courier" fontSize:16];
        pause.position = ccp(65, 10);
        pause.color = ccRED;
        tf = [[UITextField alloc] initWithFrame:CGRectMake(12, 32, 260, 25)];
        [tf setBackgroundColor:[UIColor whiteColor]];
        [hscoreview addSubview:tf];
        prefs = [NSUserDefaults standardUserDefaults];
        if([prefs integerForKey:@"shootupsurvival-wave"] >= 60) { player.color = ccc3(255, 215, 0); }
        
        cpulives = 0;
        IsPaused = false;
        IsDead = false;
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        [self CreateMenu];        
        [self schedule:@selector(CountDownTimer:) interval:1];
        
        [self addChild:background];
        [self addChild:wave];
        [self addChild:secsleft];
        [self addChild:player];
        [self addChild:foesleft];
        [self addChild:livesleft];
        [self addChild:ready];
        [self addChild:scoret];
        [self addChild:shop];
        [self addChild:shopt];
        [self addChild:survive];
        [self addChild:bossc];
        [self addChild:hscore];
        [self addChild:pause];
    }
    return self;
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Accept"]) {
        NSString *a = tf.text;
        if(a.length >= 15) { a = @"Player"; }
        [prefs setInteger:Wave forKey:@"shootupsurvival-wave"];
        [prefs setObject:a forKey:@"shootupsurvival-name"];
        [prefs synchronize];
        hscore.string = [NSString stringWithFormat:@"High Score: %@ with Wave %d", [prefs stringForKey:@"shootupsurvival-name"], [prefs integerForKey:@"shootupsurvival-wave"]];
    }
}

- (void)Die
{
    for(CCNode* node in [self children])
    {
        [PlayerShip EndFiring];
        node.visible = false;
    }
    IsDead = true;
    survive.string = [NSString stringWithFormat:@"Survived to Wave %d", Wave];
    survive.visible = true;
    hscore.string = [NSString stringWithFormat:@"High Score: %@ with Wave %d", [prefs stringForKey:@"shootupsurvival-name"], [prefs integerForKey:@"shootupsurvival-wave"]];
    hscore.visible = true;
    if([prefs integerForKey:@"shootupsurvival-wave"] < Wave) {
        [hscoreview show];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!IsPaused) { [PlayerShip StartFiring]; }
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if([PlayerShip GetLives] > 0) {
        if(!IsPaused) { [PlayerShip PointToRect:location]; }
        if(shopt.visible) {
            if(CGRectContainsPoint(CGRectMake(360, 10, 100, 100), location)) { shop.visible = !shop.visible; return; };
            if(OnBreak) {
                if(CGRectContainsPoint(CGRectMake(300, 260, 180, 100), location)) { SecsLeft = 0; secsleft.visible = false; [PlayerShip PointToRect:ccp(size.width/2, 50)]; return; }
            }
        }
        if(CGRectContainsPoint(CGRectMake(0, 0, 120, 45), location))
        {
            IsPaused = !IsPaused;
            if(IsPaused) { pause.string = @"Tap to Play"; }
            else { pause.string = @"Tap to Pause"; }
        }
    }
    else { [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]]; }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if([PlayerShip GetLives] > 0 && !IsPaused) { [PlayerShip PointToRect:location]; }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([PlayerShip GetLives] && !IsPaused) { [PlayerShip EndFiring]; }
}

- (void)MenuRedirector:(CCMenuItem*)f { if(f.tag == 10007) { [PlayerShip AddLive:livesleft :Wave]; } }

- (void)UpdateMenu
{
    [self removeChild:shop cleanup:true];
    weapon1 = [CCMenuItemFont itemFromString:@"Rapid Shot (25)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon1.tag = 10003;
    weapon2 = [CCMenuItemFont itemFromString:@"4-Point Star (50)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon2.tag = 10004;
    weapon3 = [CCMenuItemFont itemFromString:@"8-Point Star (75)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon3.tag = 10005;
    weapon4 = [CCMenuItemFont itemFromString:@"Pulsar (350)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon4.tag = 10009;
    weapon5 = [CCMenuItemFont itemFromString:@"4-Point Mine (200)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon5.tag = 10008;
    weapon6 = [CCMenuItemFont itemFromString:@"Mine (100)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon6.tag = 10006;
    weapon7 = [CCMenuItemFont itemFromString:@"Extra Live (200)" target:self selector:@selector(MenuRedirector:)]; weapon7.tag = 10007;
    weapon8 = [CCMenuItemFont itemFromString:@"Super Shot (300)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon8.tag = 10010;
    shop = [CCMenu menuWithItems:weapon1, weapon2, weapon3, weapon4, weapon5, weapon6, weapon7, weapon8, nil];
    [shop alignItemsVertically];
    [self addChild:shop];
    shop.visible = false;
}

- (void)CreateMenu
{
    CCMenuItemFont.fontName = @"Courier";
    [CCMenuItemFont setFontSize:16];
    weapon1 = [CCMenuItemFont itemFromString:@"Normal Shot (0)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon1.tag = 10001;
    weapon2 = [CCMenuItemFont itemFromString:@"Spread Shot (25)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon2.tag = 10002;
    weapon3 = [CCMenuItemFont itemFromString:@"Rapid Shot (25)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon3.tag = 10003;
    weapon4 = [CCMenuItemFont itemFromString:@"4-Point Star (50)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon4.tag = 10004;
    weapon5 = [CCMenuItemFont itemFromString:@"8-Point Star (75)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon5.tag = 10005;
    weapon6 = [CCMenuItemFont itemFromString:@"Mine (100)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon6.tag = 10006;
    weapon7 = [CCMenuItemFont itemFromString:@"Extra Live (150)" target:self selector:@selector(MenuRedirector:)]; weapon7.tag = 10007;
    weapon8 = [CCMenuItemFont itemFromString:@"4-Point Mine (200)" target:PlayerShip selector:@selector(BuyWeapon:)]; weapon8.tag = 10008;
    shop = [CCMenu menuWithItems:weapon1, weapon2, weapon3, weapon4, weapon5, weapon6, weapon7, weapon8, nil];
    [shop alignItemsVertically];
    shop.visible = false;
}

- (void)AddEnemies:(int)GWave
{
    bool a = false;
    if(GWave % 20 != 0)
    {
        int y = ((GWave % 10)*2);
        if(y == 0) { y = 2; }
        for (int x = 0; x <= y; x++)
        {
            CCSprite* enemy;
            int t = rand()%4;
            if ((GWave < 10 || GWave >= 30)) { enemy = [CCSprite spriteWithFile:@"enemyship1.png"]; enemy.tag = 2001; enemy.lives = 1; }
            if (((GWave >= 10 && GWave < 20) || GWave >= 30) && a == false)
            {
                if(GWave >= 30 && t == 1) { enemy = [CCSprite spriteWithFile:@"enemyship2.png"]; enemy.tag = 2002; enemy.lives = 1; a = true; } 
                enemy = [CCSprite spriteWithFile:@"enemyship2.png"]; enemy.tag = 2002; enemy.lives = 1;
            }
            if ((GWave >= 20) && a == false)
            {
                if(GWave >= 30 && t == 2) { enemy = [CCSprite spriteWithFile:@"enemyship3.png"]; enemy.tag = 2003; enemy.lives = 2; a = true; }
                enemy = [CCSprite spriteWithFile:@"enemyship3.png"]; enemy.tag = 2003; enemy.lives = 2;
            }
            if ((GWave >= 30) && a == false)
            {
                if(GWave >= 30 && t == 3) { enemy = [CCSprite spriteWithFile:@"enemyship4.png"]; enemy.tag = 2004; enemy.lives = 3; a = true; }
                enemy = [CCSprite spriteWithFile:@"enemyship4.png"]; enemy.tag = 2004; enemy.lives = 3;
            }
            enemy.position = ccp(rand()%1420-480, rand()%360+300);
            enemy.lives += cpulives;
            [self addChild:enemy];
            a = false;
        }
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.m4a" loop:true];
    }
    else
    {
        if(GWave >= 40) { cpulives++; }
        if(GWave == 20)
        {
            CCSprite *boss = [CCSprite spriteWithFile:@"boss1.png"];
            boss.lives = 50;
            boss.position = ccp(rand()%1420-480, rand()%360+450);
            boss.tag = 3001;
            [self addChild:boss];
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"boss.m4a" loop:true];
        }
        else if(GWave == 40)
        {
            CCSprite *boss = [CCSprite spriteWithFile:@"boss2.png"];
            boss.lives = 50;
            boss.position = ccp(rand()%1420-480, rand()%360+450);
            boss.tag = 3002;
            [self addChild:boss];
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"boss.m4a" loop:true];
        }
        else
        {
            int y = ((GWave % 10)*2);
            if(y == 0) { y = 2; }
            for (int x = 0; x <= y; x++)
            {
                CCSprite* enemy;
                if ((GWave < 10 || GWave >= 30) && a == false) { enemy = [CCSprite spriteWithFile:@"enemyship1.png"]; enemy.tag = 2001; enemy.lives = 1; a = true; }
                if (((GWave >= 10 && GWave < 20) || GWave >= 30) && a == false) { enemy = [CCSprite spriteWithFile:@"enemyship2.png"]; enemy.tag = 2002; enemy.lives = 1; a = true; }
                if ((GWave >= 20) && a == false) { enemy = [CCSprite spriteWithFile:@"enemyship3.png"]; enemy.tag = 2003; enemy.lives = 2; a = true; }
                if ((GWave >= 30) && a == false) { enemy = [CCSprite spriteWithFile:@"enemyship4.png"]; enemy.tag = 2004; enemy.lives = 3; a = true; }
                enemy.position = ccp(rand()%1420-480, rand()%360+300);
                enemy.lives += cpulives;
                [self addChild:enemy];
                a = false;
            }
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.m4a" loop:true];            
        }
    }
}

- (int)GetEnemyCount
{
    int a = 0;
    for (CCNode* node in [self children])
    {
        if([self IsEnemy:node]) { a += 1; }
    }
    return a;
}

- (void)UpdateEnemyCount
{
    foesleft.string = [NSString stringWithFormat:@"Enemies Left: %d", [self GetEnemyCount]];
    foesleft.position = ccp(foesleft.boundingBox.size.width/2, size.height-30);
    if([self GetEnemyCount] <= 0)
    {
        SecsLeft = 10;
        OnBreak = true;
        secsleft.string = @"Next wave in: 10";
        secsleft.visible = true;
        ready.visible = true;
        [[SimpleAudioEngine sharedEngine] playEffect:@"finish.caf"];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        if(Wave == 20) { [self UpdateMenu]; }
        shopt.visible = true;
    }
}

- (void)CreateEnemyBullet:(CGPoint)p:(int)type
{
    if(!IsDead) {
        CCSprite* bullet = [CCSprite spriteWithFile:@"bullet.png"];
        bullet.tag = 1010+type;
        bullet.position = p;
        bullet.color = ccc3(255, 0, 0);
        [self addChild:bullet];
    }
}

- (void)CountDownTimer: (int) timeElapsed 
{
    if(OnBreak) {
        SecsLeft--;
        secsleft.string = [NSString stringWithFormat:@"Next wave in: %d", SecsLeft];
        if(SecsLeft > 0)
        {
            if(Wave == 19 || Wave == 39)
            {
                if(SecsLeft%2 == 0) { bossc.visible = true; }
                else { bossc.visible = false; }
            }
        }
        else
        {
            SecsLeft = 15;
            secsleft.visible = false;
            OnBreak = false;
            Wave++;
            wave.string = [NSString stringWithFormat:@"Wave %d", Wave];
            wave.position = ccp(wave.boundingBox.size.width/2, size.height-10);
            ready.visible = false;
            shopt.visible = false;
            shop.visible = false;
            bossc.visible = false;
            
            [self AddEnemies:Wave];
            [self UpdateEnemyCount];
        }
    }
}

- (void)Sound_Shoot { if(!IsDead) { [[SimpleAudioEngine sharedEngine] playEffect:@"shoot.caf"]; } }
- (void)Sound_Shoot2 { if(!IsDead) { [[SimpleAudioEngine sharedEngine] playEffect:@"shoot2.caf"]; } }

- (void)IsEnemyDead:(CCNode*)foe
{
    foe.lives--;
    [[SimpleAudioEngine sharedEngine] playEffect:@"explode.caf"];
    switch (foe.tag)
    {
        case 2001: [PlayerShip AddScore:2 :scoret]; break;
        case 2002: [PlayerShip AddScore:4 :scoret]; break;
        case 2003: if (foe.lives <= 0) { [PlayerShip AddScore:6 :scoret]; } break;
        case 2004: if (foe.lives <= 0) { [PlayerShip AddScore:6 :scoret]; } break;
        case 3001: if (foe.lives <= 0) { [PlayerShip AddScore:50 :scoret]; } break;
        case 3002: if (foe.lives <= 0) { [PlayerShip AddScore:100 :scoret]; } break;
    }
    switch (foe.tag)
    {
        case 2001:
        case 2002:
        case 2003:
        case 2004:
        case 3001:
        case 3002:
            if(foe.lives <= 0) { [self removeChild:foe cleanup:true]; }
        break;
    }
}

- (bool)IsEnemy:(CCNode*)noda
{
    return ((noda.tag >= 2001 && noda.tag <= 2004) || (noda.tag >= 3001 && noda.tag <= 3002));
}

- (void)draw
{
    player.position = [PlayerShip ReturnPoint];
    if(!IsPaused) { [PlayerShip Update:self :player]; [self update]; }
    [super draw];
}

- (void)update
{
    for (CCNode* node in [self children])
    {
        switch(node.tag)
        {
            case 2001:
                if(node.position.y < [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y+1); }
                else if(node.position.y > [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y-1); }
                if(node.position.x < [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x+1, node.position.y); }
                else if(node.position.x > [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x-1, node.position.y); }
                if(CGRectIntersectsRect([PlayerShip GetRectangle], node.boundingBox) || CGRectContainsRect([PlayerShip GetRectangle], node.boundingBox)) { [PlayerShip HandleLives:livesleft]; }
                if(node.shipCountdown == 120) { [self CreateEnemyBullet: ccp(node.position.x, node.position.y-8) :8]; [self Sound_Shoot]; }
                if(node.shipCountdown == 240) { node.shipCountdown = 0; }
            break;
            case 2002:
                if(node.position.y < [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y+1); }
                else if(node.position.y > [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y-1); }
                if(node.position.x < [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x+1, node.position.y); }
                else if(node.position.x > [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x-1, node.position.y); }
                if(CGRectIntersectsRect([PlayerShip GetRectangle], node.boundingBox) || CGRectContainsRect([PlayerShip GetRectangle], node.boundingBox)) { [PlayerShip HandleLives:livesleft]; }
                if(node.shipCountdown == 40) { [self CreateEnemyBullet: ccp(node.position.x-2, node.position.y-13) :8]; [self Sound_Shoot]; }
                else if(node.shipCountdown == 80) { [self CreateEnemyBullet: ccp(node.position.x+2, node.position.y-13) :8]; [self Sound_Shoot]; }
                if(node.shipCountdown == 120) { [self CreateEnemyBullet: ccp(node.position.x-2, node.position.y-13) :8]; [self Sound_Shoot]; node.shipCountdown = 0; }
            break;
            case 2003:
                if(node.position.y < [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y+2); }
                else if(node.position.y > [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y-2); }
                if(node.position.x < [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x+2, node.position.y); }
                else if(node.position.x > [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x-2, node.position.y); }
                if(CGRectIntersectsRect([PlayerShip GetRectangle], node.boundingBox) || CGRectContainsRect([PlayerShip GetRectangle], node.boundingBox)) { [PlayerShip HandleLives:livesleft]; }
                if(node.shipCountdown == 100) { [self CreateEnemyBullet:ccp(node.position.x, node.position.y-11) :0]; [self Sound_Shoot2]; }
                if(node.shipCountdown == 200) { node.shipCountdown = 0; }
            break;
            case 2004:
                if(node.position.y < [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y+2); }
                else if(node.position.y > [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y-2); }
                if(node.position.x < [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x+2, node.position.y); }
                else if(node.position.x > [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x-2, node.position.y); }
                if(CGRectIntersectsRect([PlayerShip GetRectangle], node.boundingBox) || CGRectContainsRect([PlayerShip GetRectangle], node.boundingBox)) { [PlayerShip HandleLives:livesleft]; }
                if(node.shipCountdown == 100)
                {
                    [self CreateEnemyBullet:ccp(node.position.x, node.position.y-16) :2];
                    [self CreateEnemyBullet:ccp(node.position.x, node.position.y-16) :4];
                    [self CreateEnemyBullet:ccp(node.position.x, node.position.y-16) :6];
                    [self CreateEnemyBullet:ccp(node.position.x, node.position.y-16) :8];
                    [self Sound_Shoot2];
                }
                if(node.shipCountdown == 200) { node.shipCountdown = 0; }
                break;
            case 3001:
                if(node.position.y < [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y+1); }
                else if(node.position.y > [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y-1); }
                if(node.position.x < [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x+1, node.position.y); }
                else if(node.position.x > [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x-1, node.position.y); }
                if(CGRectIntersectsRect([PlayerShip GetRectangle], CGRectMake(node.position.x-30, node.position.y-38, 60, 76)) || CGRectContainsRect([PlayerShip GetRectangle], CGRectMake(node.position.x-30, node.position.y-38, 60, 76))) { [PlayerShip HandleLives:livesleft]; }
                if(node.shipCountdown == 25)
                {
                    [self CreateEnemyBullet:ccp(node.position.x-15, node.position.y-38) :8];
                    [self CreateEnemyBullet:ccp(node.position.x+15, node.position.y-38) :8];
                    [self CreateEnemyBullet:ccp(node.position.x-30, node.position.y+38) :4];
                    [self CreateEnemyBullet:ccp(node.position.x+30, node.position.y+38) :6];
                    [self Sound_Shoot];
                }
                if(node.shipCountdown == 50) { node.shipCountdown = 0; }
            break;
            case 3002:
                if(node.position.y < [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y+1); }
                else if(node.position.y > [PlayerShip ReturnPoint].y+15) { node.position = ccp(node.position.x, node.position.y-1); }
                if(node.position.x < [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x+1, node.position.y); }
                else if(node.position.x > [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x-1, node.position.y); }
                if(CGRectIntersectsRect([PlayerShip GetRectangle], CGRectMake(node.position.x-29, node.position.y-26, 58, 52)) || CGRectContainsRect([PlayerShip GetRectangle], CGRectMake(node.position.x-29, node.position.y-26, 58, 52))) { [PlayerShip HandleLives:livesleft]; }
                if(node.shipCountdown == 12)
                {
                    [self CreateEnemyBullet:ccp(node.position.x, node.position.y-26) :8];
                    [self CreateEnemyBullet:ccp(node.position.x-29, node.position.y) :4];
                    [self CreateEnemyBullet:ccp(node.position.x+29, node.position.y) :6];
                    [self Sound_Shoot2];
                }
                if(node.shipCountdown == 25) { node.shipCountdown = 0; }
            break;
        }
        
        node.shipCountdown++;
        
        if((node.tag >= 1001 && node.tag <= 1009) || node.tag == 1020)
        {
            for (CCNode* noda in [self children])
            {
                if(noda.position.x > -50 && noda.position.x < 520 && noda.position.y < 450 && noda.position.y > 0)
                {
                    if([self IsEnemy:noda])
                    {
                        if(CGRectIntersectsRect(noda.boundingBox, node.boundingBox) || CGRectContainsRect(noda.boundingBox, node.boundingBox)) { [self IsEnemyDead:noda]; [self removeChild:node cleanup:true];  [self UpdateEnemyCount]; return; }
                        if(CGRectIntersectsRect([PlayerShip GetRectangle], noda.boundingBox) || CGRectContainsRect([PlayerShip GetRectangle], noda.boundingBox)) { [PlayerShip HandleLives:livesleft]; }
                    }
                }
            }
        }
        if(node.tag >= 1010 && node.tag <= 1019)
        {
            if(CGRectIntersectsRect([PlayerShip GetRectangle], node.boundingBox) || CGRectContainsRect([PlayerShip GetRectangle], node.boundingBox)) { [PlayerShip HandleLives:livesleft]; [self removeChild:node cleanup:true]; return; }
        }
        if(node.tag >= 1000 && node.tag <= 1019) {
            if(node.position.y-3 >= 360 || node.position.y+3 <= 0) { [self removeChild:node cleanup:true]; return; }
            if(node.position.x+3 <= 0 || node.position.x-3 >= 480) { [self removeChild:node cleanup:true]; return; }
            switch (node.tag) {
                case 1010: if(node.position.x > [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x-2, node.position.y); } else if (node.position.x < [PlayerShip ReturnPoint].x) { node.position = ccp(node.position.x+2, node.position.y); } node.position = ccp(node.position.x, node.position.y-2); break;
                case 1001: case 1011: node.position = ccp(node.position.x-2, node.position.y+2); break;
                case 1002: case 1012: node.position = ccp(node.position.x, node.position.y+4); break;
                case 1003: case 1013: node.position = ccp(node.position.x+2, node.position.y+2); break;
                case 1004: case 1014: node.position = ccp(node.position.x-4, node.position.y); break;
                case 1006: case 1016: node.position = ccp(node.position.x+4, node.position.y); break;
                case 1007: case 1017: node.position = ccp(node.position.x-2, node.position.y-2); break;
                case 1008: case 1018: node.position = ccp(node.position.x, node.position.y-4); break;
                case 1009: case 1019: node.position = ccp(node.position.x+2, node.position.y-2); break;
            }
        }
        if(node.tag == 500) {
            if(CGRectIntersectsRect([PlayerShip GetRectangle], node.boundingBox) || CGRectContainsRect([PlayerShip GetRectangle], node.boundingBox)) {
                if([PlayerShip GetWeapon] != 11) {
                    [PlayerShip AddScore:75 :scoret];
                    [PlayerShip ResetShootFrame];
                    [PlayerShip SetWeapon:11];
                    [self removeChild:node cleanup:true]; return;
                }
            }
            node.position = ccp(node.position.x, node.position.y-2);
            if(node.position.y-8 < 0) { [self removeChild:node cleanup:true]; return; }
        }
    }
    if (rand()%9000 == 0) {
        CCSprite* s = [CCSprite spriteWithFile:@"powerup.png"];
        s.position = ccp(rand()%400, 960);
        s.tag = 500;
        [self addChild:s];
    }
    if([PlayerShip GetLives] <= 0) { [self Die]; }
    
    Frame++;
    if(Frame == 300) { Frame = 0; }
}

- (void)dealloc 
{
    [PlayerShip dealloc];
    [hscoreview dealloc];
    [super dealloc];
}

@end
