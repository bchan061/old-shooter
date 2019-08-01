//
//  Instructions.m
//  ShootupSurvival
//
//  Created by Brandon on 8/7/12.
//
//

#import "Instructions.h"

@implementation Instructions
    +(CCScene*)scene
    {
        CCScene* scene = [CCScene node];
        Instructions* layer = [Instructions node];
        [scene addChild: layer];
        return scene;
    }
    
@end
