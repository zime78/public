//
//  NSObject+ObjectInterface.h
//  watchTest
//
//  Created by zimeVX on 2023/03/12.
//

#import "ObjectInterface.h"
#import "watchos_Watch_App-Swift.h"

@implementation ExpansionObj


+(void)testLog:(NSString *)log
{
    [Logger.shared appendWithLine:log];
}

@end

