//
//  StartAtLoginController.m
//  Res Switcher
//
//  Created by Doug Mason on 1/3/21.
//

#import "StartAtLoginController.h"
#import <ServiceManagement/ServiceManagement.h>

@implementation StartAtLoginController

@synthesize identifier = _identifier;

#if !__has_feature(objc_arc)
- (void)dealloc {
    self.identifier = nil;
    [super dealloc];
}
#endif

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    BOOL automatic = NO;
    
    if ([theKey isEqualToString:@"startAtLogin"]) {
        automatic = NO;
    } else if ([theKey isEqualToString:@"enabled"]) {
        automatic = NO;
    } else {
        automatic=[super automaticallyNotifiesObserversForKey:theKey];
    }
    
    return automatic;
}

-(id)initWithIdentifier:(NSString*)identifier {
    self = [self init];
    if(self) {
        self.identifier = identifier;
    }
    return self;
}

-(void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
    [self startAtLogin];
#if !defined(NDEBUG)
    NSLog(@"Launcher '%@' %@ configured to start at login",
          self.identifier, (_enabled ? @"is" : @"is not"));
#endif
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)startAtLogin {
    if (!_identifier)
        return NO;
    
    BOOL isEnabled  = NO;
    
    // the easy and sane method (SMJobCopyDictionary) can pose problems when sandboxed. -_-
    CFArrayRef cfJobDicts = SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
    NSArray* jobDicts = CFBridgingRelease(cfJobDicts);
    
    if (jobDicts && [jobDicts count] > 0) {
        for (NSDictionary* job in jobDicts) {
            if ([_identifier isEqualToString:[job objectForKey:@"Label"]]) {
                isEnabled = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
    }
    
    if (isEnabled != _enabled) {
        [self willChangeValueForKey:@"enabled"];
        _enabled = isEnabled;
        [self didChangeValueForKey:@"enabled"];
    }
    
    return isEnabled;
}
#pragma clang diagnostic pop

- (void)setStartAtLogin:(BOOL)flag {
    if (!_identifier)
        return;
    
    [self willChangeValueForKey:@"startAtLogin"];
    
    if (!SMLoginItemSetEnabled((__bridge CFStringRef)_identifier, (flag) ? true : false)) {
        NSLog(@"SMLoginItemSetEnabled failed!");
        
        [self willChangeValueForKey:@"enabled"];
        _enabled = NO;
        [self didChangeValueForKey:@"enabled"];
    } else {
        [self willChangeValueForKey:@"enabled"];
        _enabled = YES;
        [self didChangeValueForKey:@"enabled"];
    }
    
    [self didChangeValueForKey:@"startAtLogin"];
}

- (BOOL)enabled
{
    return _enabled;
}

- (void)setEnabled:(BOOL)enabled
{
    [self setStartAtLogin:enabled];
}

@end
