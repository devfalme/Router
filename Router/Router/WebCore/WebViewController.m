
//
//  WebViewController.m
//  WebDemo
//
//  Created by MacPro on 10/11/18.
//  Copyright © 2018 MacPro. All rights reserved.
//

#import "WebViewController.h"
#import "WZFlashButton.h"
#import "WebRightMenuView.h"
#import "SVProgressHUD.h"
#import "UIColor+Hex.h"
#import "AppDelegate+RotationExtension.h"
#import <WebKit/WebKit.h>
#import "WebViewController.h"
#define S_Height [UIScreen mainScreen].bounds.size.height
#define S_Width [UIScreen mainScreen].bounds.size.width
#define IsIphoneX ([[UIApplication sharedApplication] statusBarFrame].size.height > 20)
#define Bottom_Height (IsIphoneX?34+49:49)
@interface WebViewController () < WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate >

@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) WKWebView *webView;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) WebRightMenuView *menuView;

@property (nonatomic, copy) NSString *themeHexColor;
@property (nonatomic, copy) NSString *tmpShareUrl;

@end

static CGFloat OffY_Top = 50;
static CGFloat OffY_Bottom = 50;

@implementation WebViewController

#pragma mark - < LifeCycle >
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"正在加载.."];
    [self setupUI];
}


#pragma mark - < KVO >
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [SVProgressHUD dismiss];
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        if (object == self.webView) {
            [self.progressView setAlpha:1.0f];
            BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
            [self.progressView setProgress:[change[@"new"] doubleValue] animated:animated];
            
            // Once complete, fade out UIProgressView
            if(self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
            self.titleLabel.text = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - < WKWebViewDelegate >
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    [self showAlterViewControllerWithMessage:message];
}

//获取网页提示框事件
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
        if (message.length > 6) {
        //此处根据提示框信息message截取分享网址(仅适用于新平台)
        NSString *scheme = [message substringToIndex:5];
        if ([scheme isEqualToString:@"share"]) {
            NSArray *adsd = [message componentsSeparatedByString:@"share:"];
            self.tmpShareUrl = adsd.lastObject;
            [self shareAction];
            completionHandler();
            return;
        }
    }
    if ([message isEqualToString:@"退出棋牌游戏"]) {
        [self forceRotationScreenOrientationToPortrait];
        completionHandler();
        return;
    }
    //获取网页提示信息并展示
    [self showAlterViewControllerWithMessage:message];
    completionHandler();
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *url = navigationAction.request.URL.absoluteString;
    
    if (url.length > 5) {
        if ([[url substringWithRange:NSMakeRange(url.length-4, 4)] isEqualToString:@".apk"]) {
            [self showAlterViewControllerWithMessage:@"请选择“iPhone下载”"];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    if ([url containsString:@"joinGamePlay"]) {
        [self forceRotationScreenOrientationToLandscape];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    if (![navigationAction.request.URL.scheme isEqualToString:@"https"] &&
        ![navigationAction.request.URL.scheme isEqualToString:@"http"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    //web加载结束
}

#pragma mark - < Action >
//初始化UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"000000"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tmpShareUrl = [self.shareUrl copy];
    if (!self.navigationController) {
        [self.view addSubview:self.topView];
    }
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.menuView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

}


//底部button的点击事件
- (void)bottomButtonClick:(NSInteger)tag {
    
    switch (tag) {
        case 0: //后退
        {
            [self.menuView hiddenMenuAnimation];
            if ([_webView canGoBack]) {
                [_webView goBack];
            }
            break;
        }
        case 1: //前进
        {
            [self.menuView hiddenMenuAnimation];
            if ([_webView canGoForward]) {
                [_webView goForward];
            }
            break;
        }
        case 2: //主页
        {
            [self.menuView hiddenMenuAnimation];
            NSURL *webURL = [NSURL URLWithString:self.webUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:webURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:8];
            //            [_webView loadRequest:[NSURLRequest requestWithURL:webURL]];
            [_webView loadRequest:request];
            break;
        }
        case 3: //刷新
        {
            [self.menuView hiddenMenuAnimation];
            [_webView reloadFromOrigin];
            break;
        }
        case 4: { // 菜单
            [self.menuView showMenuAnimation];
            break;
        }
        default:
            break;
    }
}

/**< 菜单按钮点击事件 */
- (void)menuButtonClick:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
            [self.menuView hiddenMenuAnimation];
            [self shareAction];
            
            break;
        case 1:
            [self.menuView hiddenMenuAnimation];
            [self clearWebCache];
            break;
        default:
            break;
    }
}

/**< 强制旋转屏幕为横屏 */
- (void)forceRotationScreenOrientationToLandscape {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isLandscape = YES;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    //上一句话是防止手动先把设备置为竖屏,导致下面的语句失效.
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [self resetFrame];
    [_webView setAllowsBackForwardNavigationGestures:false];
}

/**< 强制旋转屏幕为竖屏 */
- (void)forceRotationScreenOrientationToPortrait {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isLandscape = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    //上一句话是防止手动先把设备置为横屏,导致下面的语句失效.
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self resetFrame];
    [_webView setAllowsBackForwardNavigationGestures:true];
}

- (void)resetFrame {
    
    CGRect frame = self.webView.frame;
    CGSize size = CGSizeMake(S_Width, S_Height);
    if (size.width > size.height) {
        /**< 横屏 */
        frame.size.width = size.width;
        frame.size.height = size.height;
        frame.origin.x = 0;
        frame.origin.y = 0;
        self.webView.frame = frame;
        self.bottomView.hidden = YES;
    } else {
        /**< 竖屏 */
        frame.size.width = size.width;
        frame.origin.x = 0;
        CGFloat y = 20;
        CGFloat offBottom = Bottom_Height;
        if (IsIphoneX) {
            y= OffY_Top;
            offBottom += OffY_Bottom;
        }
        frame.origin.y = y;
        frame.size.height = size.height-y-offBottom;
        self.webView.frame = frame;
        self.bottomView.hidden = NO;
    }
    
}

//弹出警告框
- (void)showAlterViewControllerWithMessage:(NSString *)message {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alter addAction:action];
    [self presentViewController:alter animated:YES completion:^{ }];
}

- (void)shareAction {
    if (!self.tmpShareUrl.length || !self.shareContent.length) return;
    NSString *textToShare = self.shareContent;
    NSString *shareLink = self.tmpShareUrl;
    NSURL *urlToShare = [NSURL URLWithString:shareLink];
    NSArray *activityItems = @[textToShare,urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {};
        activityVC.completionWithItemsHandler = myBlock;
    }
    activityVC.excludedActivityTypes = @[
                                         UIActivityTypeMail,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         ];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)clearWebCache {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除缓存？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD showWithStatus:@"清除缓存.."];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            //// All kinds of data
            NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
            //// Date from
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            //// Execute
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                NSURL *webURL = [NSURL URLWithString:weakSelf.webUrl];
                [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:webURL]];
                [self showAlterViewControllerWithMessage:@"清除缓存成功！"];
            }];
        } else {
            NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
            NSError *errors;
            [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
            NSURL *webURL = [NSURL URLWithString:weakSelf.webUrl];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:webURL]];
            [self showAlterViewControllerWithMessage:@"清除缓存成功！"];
        }
    }];
    [alter addAction:action1];
    [alter addAction:action2];
    [self presentViewController:alter animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - < Getter >
- (NSString *)themeHexColor {
    
    if (!_themeHexColor) {
        _themeHexColor = @"F3F4F5";
    }
    return _themeHexColor;
}

- (WKWebView *)webView {
    
    if (!_webView) {
        
        CGFloat y;
        
        if (self.navigationController) {
            y = 0;
        }else{
            if (IsIphoneX) {
                y = 88.0;
            }else{
                y = 64.0;
            }
        }
        CGRect frame = CGRectMake(0, y, S_Width, S_Height - y - Bottom_Height);
        
        WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize =10;
        config.preferences.javaScriptEnabled =YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically =NO;
        config.allowsInlineMediaPlayback = YES;
        NSMutableString *javascript = [NSMutableString string];
        
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];
        //禁止选择
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];

        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
        [_webView.configuration.userContentController addUserScript:noneSelectScript];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        [_webView setMultipleTouchEnabled:YES];
        [_webView setAutoresizesSubviews:YES];
        [_webView.scrollView setAlwaysBounceVertical:YES];
        [_webView setAllowsBackForwardNavigationGestures:true];

        [_webView sizeToFit];
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGFloat y;
        
        if (self.navigationController) {
            y = 0;
        }else{
            if (IsIphoneX) {
                y = 88;
            }else{
                y = 64;
            }
        }
        
        CGRect frame = CGRectMake(0, y, S_Width, 1);
        _progressView = [UIProgressView new];
        _progressView.frame = frame;
        _progressView.progressTintColor = [UIColor colorWithHexString:@"3492FF"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"e9e9e9"];
    }
    return _progressView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        
        NSArray *cates = @[@"首页",@"后退",@"前进",@"刷新",@"菜单"];
        CGFloat y = CGRectGetMaxY(self.webView.frame);
        CGFloat btnHeight;
        if (IsIphoneX) {
            btnHeight = S_Height - y - 34;
        }else{
            btnHeight = S_Height - y;
        }
        
        CGFloat btnWidth = S_Width/cates.count;
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, y, S_Width, Bottom_Height)];
        _bottomView.backgroundColor = [UIColor colorWithHexString:self.themeHexColor];
//        //后题，前进，首页，刷新，菜单（菜单里有“分享”+“清除缓存”）
        
        NSBundle *bundle = [NSBundle bundleForClass:[WebViewController class]];
        NSURL *url = [bundle URLForResource:@"web" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        
        for (NSInteger i = 0; i < cates.count; i ++) {
            CGRect frame = CGRectMake(btnWidth * i, 0, btnWidth, btnHeight);
            WZFlashButton *flashBtn = [[WZFlashButton alloc] initWithFrame:frame];
            
            NSString *path = [imageBundle pathForResource:[NSString stringWithFormat:@"webControl%ld",(long)i] ofType:@"png"];
            
            flashBtn.centerImgView.image = [UIImage imageWithContentsOfFile:path];
            flashBtn.backgroundColor = [UIColor colorWithHexString:self.themeHexColor];
            flashBtn.flashColor = [UIColor colorWithHexString:@"e1e1e1"];
            flashBtn.tag = i;
            flashBtn.clickBlock = ^(WZFlashButton *flashButton) {
                [self bottomButtonClick:flashButton.tag];
            };
            [_bottomView addSubview:flashBtn];
        }
    }
    return _bottomView;
}

- (WebRightMenuView *)menuView {
    
    if (!_menuView) {
        CGFloat y = CGRectGetMaxY(self.webView.frame);
        NSArray *cates = @[@"分享",@"清除缓存"];
        CGFloat btnHeight;
        if (IsIphoneX) {
            btnHeight = S_Height - y - 34;
        }else{
            btnHeight = S_Height - y;
        }
        CGFloat menuHeight = btnHeight*cates.count;
        CGFloat menuWidth = S_Width/5;
        CGFloat hiddenY = CGRectGetMaxY(self.webView.frame);
        CGFloat showY = hiddenY - menuHeight;
        CGFloat x = S_Width - menuWidth;
        menuWidth -= 1;

        CGRect showFrame = CGRectMake(x, showY, menuWidth, menuHeight);
        CGRect hiddenFrame = CGRectMake(x, hiddenY, menuWidth, 0);
        CGMutablePathRef springsPath = NULL;
        CGFloat springsDrawY = 0.f;
        CGPathMoveToPoint(springsPath, nil, 0, springsDrawY);
        
        _menuView = [[WebRightMenuView alloc] initWithFrame:hiddenFrame];
        _menuView.hiddenFrame = hiddenFrame;
        _menuView.showFrame = showFrame;
        _menuView.clipsToBounds = YES;
        _menuView.backgroundColor = [[UIColor colorWithHexString:self.themeHexColor] colorWithAlphaComponent:0.95];
        
        for (NSInteger i = 0; i < cates.count; i ++) {
            UIButton *btn = [UIButton new];
            btn.frame = CGRectMake(0, btnHeight*i, menuWidth, btnHeight);
            btn.tag = i;
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitle:cates[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_menuView addSubview:btn];
            
            if (i == 0) {
                CGFloat lineWidth = menuWidth *0.8;
                CGFloat x = (menuWidth - lineWidth)/2;
                CALayer *lineLayer = [CALayer layer];
                lineLayer.backgroundColor = [UIColor colorWithHexString:@"41465E"].CGColor;
                lineLayer.frame = CGRectMake(x, btnHeight, lineWidth, 1);
                [_menuView.layer addSublayer:lineLayer];
            }
        }
        
    }
    return _menuView;
}

- (UIView *)topView {
    if (!_topView) {
        CGFloat height = 0;
        if (!self.navigationController) {
            if (IsIphoneX) {
                height = 88.0;
            }else{
                height = 64.0;
            }
        }
        
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_Width, height)];
        _topView.backgroundColor = [UIColor colorWithHexString:self.themeHexColor];
        if (!self.navigationController) {
            [_topView addSubview:self.titleLabel];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, height-.5, S_Width, .5)];
        line.backgroundColor = UIColor.grayColor;
        [_topView addSubview:line];
    }return _topView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat y;
        if (IsIphoneX) {
            y = 44.0;
        }else{
            y = 20.0;
        }
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, y, S_Width - 70.0, 44)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _titleLabel.textColor = [UIColor colorWithHexString:@"41465E"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }return _titleLabel;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
@end

