//
//  NSObject+ObjectInterface.h
//  watchTest
//
//  Created by zimeVX on 2023/03/12.
//

#import "ObjectInterface.h"
#import "ZipArchive.h"
#import "Utils.h"
#include "Command.h"

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif
#import "UIView.h"

#import "watchos_Watch_App-Swift.h"

@implementation ExpansionObj


+(void)testLog:(NSString *)log
{
    [Logger.shared appendWithLine:log];
    commandLog();
    [Utils onLog];
}

//swift 에서 Object함수 호출 -> swift함수로 phone으로 Message전송
+(void)testMessage:(NSString *)msg
{
    [MessageManager.shared onTestMessageWithMsg:msg];
    commandLog();
    [Utils onLog];
    
    //실제 동작은 안되는 뷰 호출함(컴파일 오류를 막기위해서 사용.
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

+(void)onTestZip
{
    @try {
        //압축파일 저장할 위치
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentDirectory = [paths objectAtIndex:0];
        NSString *strPathName = [documentDirectory stringByAppendingPathComponent:@"logFiles.zip"];
        
        //파일이 존재하면 삭제함.
        if ([NSFileManager.defaultManager fileExistsAtPath:strPathName]) {
            [NSFileManager.defaultManager removeItemAtPath:strPathName error:nil];
        }
        
        //압축할 파일Path및 폴더지정
        NSMutableArray *listZipFileList = [NSMutableArray arrayWithCapacity:1];
        [listZipFileList addObject:[documentDirectory stringByAppendingPathComponent:@"Logs"]];
        
        if ([SSZipArchive createZipFileAtPath:strPathName withFilesAtPaths:listZipFileList]) {
            NSLog(@"압축성공!! %@", strPathName);
        }
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    
}
@end

