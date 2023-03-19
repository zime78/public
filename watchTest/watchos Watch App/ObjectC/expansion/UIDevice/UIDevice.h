//
//  UIDevice.h
//  Watch
//
//

#import <UIKit/UIKit.h>
@interface UIDevice : NSObject

@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *systemVersion;
@property (nonatomic, assign) CGRect bounds;

+ (instancetype)currentDevice;
+ (NSString *)deviceID;
+ (NSString *)versionByAppNOS;
+ (NSString *)OSVersion;
+ (NSString*)appVersion;
+ (NSString*)carriarName;
+ (NSString *)modelName;

@end
