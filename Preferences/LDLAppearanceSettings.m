#import "LDLRootListController.h"

@implementation LDLAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed:1 green:0.47 blue:0.64 alpha:1];

}

- (UIStatusBarStyle)statusBarStyle {

    return UIStatusBarStyleDarkContent;

}

- (UIColor *)navigationBarTitleColor {

    return [UIColor whiteColor];

}

- (UIColor *)navigationBarTintColor {

    return [UIColor whiteColor];

}

- (UIColor *)tableViewCellSeparatorColor {

    return [[UIColor whiteColor] colorWithAlphaComponent:0];

}

- (UIColor *)navigationBarBackgroundColor {

    return [UIColor colorWithRed:1 green:0.47 blue:0.64 alpha:1];

}

- (BOOL)translucentNavigationBar {

    return YES;

}

@end