//
//  NSObject+ObjectInterface.h
//  watchTest
//
//  Created by zimeVX on 2023/03/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpansionObj : NSObject


+(void)testLog:(NSString *)log;
+(void)onTestZip;
+(void)onCompressLogZip:(NSString *) filename;
+(void)testMessage:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
