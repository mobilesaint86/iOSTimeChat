//
//  UIWindow+AHKAdditions.h
//  AHKActionSheetExample
//


#import <UIKit/UIKit.h>

@interface UIWindow (AHKAdditions)

- (UIViewController *)ahk_viewControllerForStatusBarStyle;
- (UIViewController *)ahk_viewControllerForStatusBarHidden;
- (UIImage *)ahk_snapshot;

@end
