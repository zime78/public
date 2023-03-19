//
//  UIDevice.m
//  Watch
//
//

#import "UIDevice.h"

@implementation UIDevice

+ (instancetype)currentDevice{
    static UIDevice *shared = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[UIDevice alloc] init];
        shared.systemVersion = @"0.0.1";
        shared.model = @"watch";
        shared.name = @"8.0";
    });

    return shared;
}

+ (NSString *)deviceID
{
    return @"";
}
+ (NSString *)versionByAppNOS
{
    return @"";
}

+ (NSString *)OSVersion
{
    return @"";
}

+ (NSString*)appVersion
{
    return @"";
}

+ (NSString*)carriarName
{
    return @"";
}

+ (NSString *)modelName
{
    return @"";
}


@end
