

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong) UIWebView *webView;

- (void)showView:(NSURL *)url;

@end
