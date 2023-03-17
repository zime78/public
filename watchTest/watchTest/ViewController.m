//
//  ViewController.m
//  watchTest
//
//  Created by zimeVX on 2023/03/09.
//

#import "ViewController.h"
#import "watchTest-Swift.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mInfoMessage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Logger.shared appendWithLine:@"viewDidLoad()"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:@"DataDidFlow"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DataDidFlow" object:nil];
}



- (void)handleNotification:(NSNotification *)notification {
    NSLog(@"Notification received: %@", notification.name);
//    NSDictionary *userInfo = notification.object;
//    NSString *message = userInfo[@"message"];
//    NSLog(@"Message: %@", message);
    
    if (notification.object != nil) {
        
        NSDictionary *objDic = notification.object;
        
        NSString *string = [[NSString alloc] initWithData:[objDic objectForKey:@"message"] encoding:NSUTF8StringEncoding];
        [self.mInfoMessage setText:string];
        
        NSLog(@"Message: %@", string);
    }
}

- (IBAction)onSendMessage:(id)sender {
    
    [MessageManager.shared onTestMessageWithMsg:@"phone Test message"];
}


@end
