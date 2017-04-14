//
//  UIWebViewController.h
//  WKWebView的使用
//
//  Created by fungo on 2017/4/13.
//  Copyright © 2017年 Lineshine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WebType) {
    UIWebType,
    WKWebType
};

@interface UIWebViewController : UIViewController

@property(nonatomic) WebType webType;

@end
