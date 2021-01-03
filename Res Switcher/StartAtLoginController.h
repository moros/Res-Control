//
//  StartAtLoginController.h
//  Res Switcher
//
//  Created by Doug Mason on 1/3/21.
//

#import <Foundation/Foundation.h>

@interface StartAtLoginController : NSObject {
    NSString *_identifier;
    NSURL    *_url;
    BOOL _enabled;
}

@property (assign, nonatomic, readwrite)   BOOL startAtLogin;
@property (assign, nonatomic, readwrite)   BOOL enabled;
@property (copy, nonatomic, readwrite)     NSString *identifier;

-(id)initWithIdentifier:(NSString*)identifier;

@end
