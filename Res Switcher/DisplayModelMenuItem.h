//
//  DisplayModelMenuItem.h
//  Res Switcher
//
//  Created by Doug Mason on 1/2/21.
//

#import <Cocoa/Cocoa.h>

@interface DisplayModeMenuItem : NSMenuItem

+ (NSArray *)getMenuItemsForDisplay:(CGDirectDisplayID)display;

@end
