//
//  UIWebViewController.m
//  WKWebView的使用
//
//  Created by fungo on 2017/4/13.
//  Copyright © 2017年 Lineshine. All rights reserved.
//

#import "UIWebViewController.h"
#import <WebKit/WebKit.h>

@interface UIWebViewController () <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) UIWebView *uiWebView;
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation UIWebViewController

- (void)dealloc {
    NSLog(@"WebViewController dead");
    
    if (_webType == WKWebType) {
        [_wkWebView.configuration.userContentController removeAllUserScripts];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    if (_webType == UIWebType) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.delegate = self;
        [self.view addSubview:webView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
        [webView loadRequest:request];
        self.uiWebView = webView;
        
    } else {
        
        // 创建配置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        WKUserContentController* userContent = [[WKUserContentController alloc] init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        [userContent addScriptMessageHandler:self name:@"NativeMethod"];
        /*window.webkit.messageHandlers.NativeMethod.postMessage("close");*/
        
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent;
        // 自定义配置创建WKWebView
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        
//        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"readme" ofType:@"html"]]]];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        //开了支持滑动返回
        webView.allowsBackForwardNavigationGestures = YES;
        [self.view addSubview:webView];
        self.wkWebView = webView;
    }
}

#pragma mark - UIWeb Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //这里修改导航栏的标题，动态改变
    self.title = webView.title;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    self.title = webView.title;
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    if (navigationAction.navigationType == WKNavigationTypeBackForward) {
        //判断是返回类型
        //可以在这里找到指定的历史页面做跳转
        if (webView.backForwardList.backList.count > 0) {
            
            //得到现在加载的list
            WKBackForwardListItem * item = webView.backForwardList.currentItem;
            //循环遍历，得到你想退出到
            for (WKBackForwardListItem * backItem in webView.backForwardList.backList) {
                //添加判断条件
                [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
            }
        }
    }
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"NativeMethod"]) {
        // 判断message的内容，然后做相应的操作
        if ([message.body isEqualToString:@"close"]) {
            NSLog(@"JS callback");
        }
    }
}

@end
