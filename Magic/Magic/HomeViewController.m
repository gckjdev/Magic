//
//  HomeViewController.m
//  Magic
//
//  Created by pipi on 15/5/27.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "HomeViewController.h"
#import "MobClickUtils.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    NSString* HOME_URL = [MobClickUtils getStringValueByKey:@"HOME_URL" defaultValue:@"http://www.taoshi.biz/Weixin/Home/Index"];
    
//    [self loadCookies];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [_webView loadRequest:request];
    
    // Do any additional setup after loading the view.
    CGRect rect = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20);
    UIWebView* webView = [[UIWebView alloc] initWithFrame:rect];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:HOME_URL]];
    [urlRequest setHTTPShouldHandleCookies:YES];
    [self addCookies:cookies forRequest:urlRequest];
    [webView loadRequest:urlRequest];
    webView.delegate = self;
    
    [self.view addSubview:webView];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)addCookies:(NSArray *)cookies forRequest:(NSMutableURLRequest *)request
{
    if ([cookies count] > 0)
    {
        NSHTTPCookie *cookie;
        NSString *cookieHeader = nil;
        for (cookie in cookies)
        {
            if (!cookieHeader)
            {
                cookieHeader = [NSString stringWithFormat: @"%@=%@",[cookie name],[cookie value]];
            }
            else
            {
                cookieHeader = [NSString stringWithFormat: @"%@; %@=%@",cookieHeader,[cookie name],[cookie value]];
            }
        }
        if (cookieHeader)
        {
            [request setValue:cookieHeader forHTTPHeaderField:@"Cookie"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadCookies
{
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    NSLog(@"cookie dictionary found is %@",cookieDictionary);
    
    for (int i=0; i < cookieDictionary.count; i++)
    {
        NSLog(@"cookie found is %@",[cookieDictionary objectAtIndex:i]);
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"<shouldStartLoadWithRequest> %@", request);
//    [self saveCookies];
    [self printCookies];
    return YES;
}

- (void)printCookies
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSLog(@"cookies=%@", [cookies description]);
    for (NSHTTPCookie* cookie in cookies){
        NSLog(@"cookie=%@", cookie);
    }
}

- (void)saveCookies
{
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.name];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithInt:cookie.version] forKey:NSHTTPCookieVersion];
        
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    NSLog(@"<saveCookies> %@", [cookieArray description]);
    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self saveCookies];
    [self printCookies];
}

@end
