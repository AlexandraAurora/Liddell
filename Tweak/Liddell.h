#import <UIKit/UIKit.h>
#import <Kitten/libKitten.h>
#import "GcUniversal/GcColorPickerUtils.h"
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

// visibility
BOOL showIconSwitch = YES;
BOOL showTitleSwitch = YES;
BOOL showMessageSwitch = YES;

// style
NSString* heightValue = @"40";
NSString* cornerRadiusValue = @"8";
NSString* offsetValue = @"0";

// background
NSString* backgroundColorValue = @"0";
NSString* customBackgroundColorValue = @"000000";
NSString* blurModeValue = @"3";
NSString* blurAmountValue = @"1";

// icon
NSString* iconCornerRadiusValue = @"0";

// text
NSString* textColorValue = @"0";
NSString* customTextColorValue = @"FFFFFF";
NSString* textContentValue = @"2";
NSString* titleFontSizeValue = @"15";
NSString* contentFontSizeValue = @"14";

// border
NSString* borderWidthValue = @"0";
NSString* borderColorValue = @"0";
NSString* customBorderColorValue = @"FFFFFF";

@interface MTPlatterView : UIView
@end

@interface MTTitledPlatterView : MTPlatterView
@end

@interface NCNotificationShortLookView : MTTitledPlatterView
@property(nonatomic, copy)NSArray* icons;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* primaryText;
@property(nonatomic, copy)NSString* secondaryText;
@property(nonatomic, retain)UIView* liddellView;
@property(nonatomic, retain)UIBlurEffect* liddellBlur;
@property(nonatomic, retain)UIVisualEffectView* liddellBlurView;
@property(nonatomic, retain)UIImageView* liddellIconView;
@property(nonatomic, retain)UILabel* liddellTitleLabel;
@property(nonatomic, retain)UILabel* liddellContentLabel;
@end

@interface UIView (Liddell)
- (id)_viewControllerForAncestor;
@end

@interface UILabel (Liddell)
- (void)setMarqueeEnabled:(BOOL)arg1;
- (void)setMarqueeRunning:(BOOL)arg1;
@end