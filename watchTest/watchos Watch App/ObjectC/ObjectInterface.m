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

//테스트용
#if TARGET_OS_WATCH
    #import "UIView.h"
#else
    #import <UIKit/UIKit.h>
#endif


#import "watchos_Watch_App-Swift.h"

@implementation ExpansionObj


+(void)testLog:(NSString *)log
{
    [Logger.shared appendWithLine:log];
 
    //c 코드 동작확인
    commandLog();
    
    //object-c 코드 동작체크
    [Utils onLog];
    
    //watch -> phone 로그 전송
    [MessageManager.shared onDebugLog:log];

    NSLog(@"[LOG] %@",log);
}

//swift 에서 Object함수 호출 -> swift함수로 phone으로 Message전송
+(void)testMessage:(NSString *)msg
{
    [MessageManager.shared onTestMessageWithMsg:msg];
    
    //c 코드 동작확인
    commandLog();
    
    //object-c 코드 동작체크
    [Utils onLog];
    
    //실제 동작은 안되는코드(컴파일 오류 체크용)
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

+(void)onTestZip
{
    [self onCompressLogZip:@"logFiles.zip"];
}

+(void)onCompressLogZip:(NSString *) filename
{
    @try {
        //압축파일 저장할 위치
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentDirectory = [paths objectAtIndex:0];
        NSString *strPathName = [documentDirectory stringByAppendingPathComponent:filename];
        
        //파일이 존재하면 삭제함.
        if ([NSFileManager.defaultManager fileExistsAtPath:strPathName]) {
            [NSFileManager.defaultManager removeItemAtPath:strPathName error:nil];
        }
                
        if ([SSZipArchive createZipFileAtPath:strPathName withContentsOfDirectory:[documentDirectory stringByAppendingPathComponent:@"Logs"]]) {
            NSLog(@"압축성공!! %@", strPathName);
        }
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
}
@end

