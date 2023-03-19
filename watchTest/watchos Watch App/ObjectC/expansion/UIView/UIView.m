//
//  UIView.m
//  Watch
//
//

#import "UIView.h"

@implementation UIView

+ (instancetype)init{
    static UIView *shared = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[UIView alloc] init];
    });

    return shared;
}

-  (instancetype)initWithFrame:(CGRect)frame{
    static UIView *shared = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[UIView alloc] init];
        shared.frame = frame;
    });

    return shared;
}
@end
