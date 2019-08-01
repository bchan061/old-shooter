//
//  HelloWorldLayer.h
//  ShootupSurvival
//
//  Created by Brandon on 3/30/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "libs/cocos2d/cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCNode
{
    int GameState;
    int Frame;
    int Difficulty;
    CGSize size;
    CCLabelTTF *copyright;
    CCLabelTTF *title;
    CCLabelTTF *tsolo;
    CCLabelTTF *topt;
    CCLabelTTF *thighscore;
    CCSprite *logo;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
