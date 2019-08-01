//
//  AppDelegate.h
//  ShootupSurvival
//
//  Created by Brandon on 3/30/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "libs/cocos2d/Platforms/iOS/CCAppDelegate.h"

@class RootViewController;

@interface AppDelegate : CCAppDelegate {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
