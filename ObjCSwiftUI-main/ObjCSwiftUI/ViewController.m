//
//  ViewController.m
//  ObjCSwiftUI
//
//  Created by Corey Davis on 1/16/21.
//

#import "ViewController.h"
#import "ObjCSwiftUI-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)showSwiftUIView:(id)sender {
    UIViewController *vc = [SwiftUIViewFactory makeSwiftUIViewWithDismissHandler:^{
        [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
