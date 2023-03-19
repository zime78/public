//
//  UIView.h
//  Watch
//
//

#import <UIKit/UIKit.h>
@interface UIView : NSObject
+ (instancetype)init;
-  (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) CGRect frame;
@end
