//
//  HelloWorldLayer.m
//  ShootupSurvival
//
//  Created by Brandon on 3/30/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Game.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        GameState = 0;
        Frame = 0;
        
        [super schedule:@selector(GameLoop:) interval:1/30.0f];
        
		size = [[CCDirector sharedDirector] viewSize];
        
		// create and initialize a Label
        copyright = [CCLabelTTF labelWithString:@"BRANDON CHAN PRESENTS" fontName:@"Courier" fontSize:18];
        title = [CCLabelTTF labelWithString:@"Shootup Survival" fontName:@"Courier" fontSize:48];
        tsolo = [CCLabelTTF labelWithString:@"Start Game" fontName:@"Courier" fontSize:48];
        topt = [CCLabelTTF labelWithString:@"" fontName:@"Courier" fontSize:48];
        logo = [CCSprite spriteWithImageNamed:@"brandon.png"];
        
		// ask director the the window size
	
		// position the label on the center of the screen
        copyright.position = CGPointMake(size.width/2+45, 75);
        copyright.color = 
        title.position = CGPointMake(size.width/2, 300);
        title.visible = false;
        tsolo.position = CGPointMake(size.width/2, 200);
        tsolo.color = ccRED;
        tsolo.visible = false;
        logo.position = CGPointMake(90, 75);
        
        [self addChild:copyright];
        [self addChild:title];
        [self addChild:tsolo];
        [self addChild:logo];
        
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        if(![prefs stringForKey:@"shootupsurvival-name"]) {
            [prefs setObject:@"Sally" forKey:@"shootupsurvival-name"];
        }
        if(![prefs integerForKey:@"shootupsurvival-wave"]) {
            [prefs setInteger:1 forKey:@"shootupsurvival-wave"];
        }
        [prefs synchronize];
        
        thighscore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %@ with Wave %d", [prefs stringForKey:@"shootupsurvival-name"], [prefs integerForKey:@"shootupsurvival-wave"]] fontName:@"Courier" fontSize:16];
        thighscore.position = ccp(size.width/2, 100);
        thighscore.visible = false;
        [self addChild:thighscore];
	}
	return self;
}

- (void) ChangeGameState: (int) State
{
    GameState = State;
    Frame = 0;
    switch(GameState) {
        case 1:
            [self removeChild:copyright cleanup:false];
            [self removeChild:logo cleanup:true];
            title.visible = true;
            tsolo.visible = true;
            thighscore.visible = true;
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.m4a" loop:true];
        break;
        case 2:
            title.visible = false;
            GameState = 1;
            CCScene *game = [Game scene];
            CCTransitionSplitRows *transition = [CCTransitionSplitRows transitionWithDuration:1.0 scene:game];
            [[CCDirector sharedDirector] replaceScene:transition];
        break;
    }
}

- (void) GameLoop: (CCTime) time
{
    Frame++;
    if (Frame == 150) { Frame = 0; }
    switch(GameState) {
        case 0:
            copyright.color = ccc3(255-(Frame*2), 255-(Frame*2), 255-(Frame*2));
            logo.color = ccc3(255-(Frame*2), 255-(Frame*2), 255-(Frame*2));
            if(Frame == 120)
            {
                [[SimpleAudioEngine sharedEngine] preloadEffect:@"shoot.caf"];
                [[SimpleAudioEngine sharedEngine] preloadEffect:@"shoot2.caf"];
                [[SimpleAudioEngine sharedEngine] preloadEffect:@"explode.caf"];
                [[SimpleAudioEngine sharedEngine] preloadEffect:@"finish.caf"];
                [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"title.m4a"];
                [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"background.m4a"];
                [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"boss.m4a"];
                [self ChangeGameState:1];
            }
        break;
    }
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    switch (GameState) {
        case 1:;
            CGRect collision = CGRectMake(0, 175, 480, 50);
            if (CGRectContainsPoint(collision, location)) { [self ChangeGameState:2]; }
            //if (CGRectContainsPoint(CGRectMake(0, 75, 480, 50), location)) { [[CCDirector sharedDirector] replaceScene:[Options scene]]; }
        break;
        case 2:
            
        break;
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	// don't forget to call "super dealloc"
    GameState = 1;
	[super dealloc];
}
@end
