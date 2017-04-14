//
//  ViewController.m
//  WKWebView的使用
//
//  Created by fungo on 2017/4/13.
//  Copyright © 2017年 Lineshine. All rights reserved.
//

#import "ViewController.h"
#import "UIWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (IBAction)showUIWebView:(id)sender {
    UIWebViewController *webVC = [[UIWebViewController alloc] init];
    webVC.webType = UIWebType;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)showWKWebView:(id)sender {
    UIWebViewController *webVC = [[UIWebViewController alloc] init];
    webVC.webType = WKWebType;
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
