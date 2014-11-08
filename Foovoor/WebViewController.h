

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property UIWebView *webView;

- (void)showView:(NSURL *)url;

@end
