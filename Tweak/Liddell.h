//
//  Liddell.h
//  Liddell
//
//  Created by Alexandra (@Traurige)
//

#import <substrate.h>
#import <UIKit/UIKit.h>
#import "Liddell-Swift.h"
#import <Kitten/libKitten.h>
#import "GcUniversal/GcColorPickerUtils.h"
#import <Cephei/HBPreferences.h>

static const int kBackgroundColorTypeNone = 0;
static const int kBackgroundColorTypeAdaptive = 1;
static const int kBackgroundColorTypeCustom = 2;
static const int kBackgroundBlurTypeNone = 0;
static const int kBackgroundBlurTypeLight = 1;
static const int kBackgroundBlurTypeDark = 2;
static const int kBackgroundBlurTypeAdaptive = 3;
static const int kTextColorTypeBackground = 0;
static const int kTextColorTypeAdaptive = 1;
static const int kTextColorTypeCustom = 2;
static const int kTextColorContentTypeTitle = 0;
static const int kTextColorContentTypeContent = 1;
static const int kTextColorContentTypeBoth = 2;
static const int kBorderColorTypeAdaptive = 0;
static const int kBorderColorTypeCustom = 1;

dispatch_queue_t queue;

// preferences
HBPreferences* preferences;
BOOL pfEnabled;

// - visibility
BOOL pfShowIcon;
BOOL pfShowTitle;
BOOL pfShowMessage;
CGFloat pfHeight;
CGFloat pfCornerRadius;
CGFloat pfOffset;
CGFloat pfScrollRate;

// - background
NSUInteger pfBackgroundColor;
NSString* pfCustomBackgroundColor;
NSUInteger pfBlurMode;
CGFloat pfBlurAmount;

// - icon
CGFloat pfIconCornerRadius;

// - text
NSUInteger pfTextColor;
NSString* pfCustomTextColor;
NSUInteger pfTextContent;
NSUInteger pfTitleFontSize;
NSUInteger pfContentFontSize;

// - border
NSUInteger pfBorderWidth;
NSUInteger pfBorderColor;
NSString* pfCustomBorderColor;

@interface MTPlatterView : UIView
@end

@interface MTTitledPlatterView : MTPlatterView
@end

@interface NCNotificationShortLookView : MTTitledPlatterView
@property(nonatomic, copy)NSArray* icons;
@property(nonatomic, copy)NSString* primaryText;
@property(nonatomic, copy)NSString* secondaryText;
@property(nonatomic, retain)UIView* liddellView;
@property(nonatomic, retain)UIBlurEffect* liddellBlur;
@property(nonatomic, retain)UIVisualEffectView* liddellBlurView;
@property(nonatomic, retain)UIImageView* liddellIconView;
@property(nonatomic, retain)UILabel* liddellTitleLabel;
@property(nonatomic, retain)MarqueeLabel* liddellContentLabel;
@end

@interface NCNotificationContent : NSObject
@property(nonatomic, copy, readonly)NSString* header;
@end

@interface NCNotificationRequest : NSObject
@property(nonatomic, readonly)NCNotificationContent* content;
@end

@interface NCNotificationShortLookViewController : UIViewController
@property(nonatomic, retain)NCNotificationRequest* notificationRequest;
@end

@interface UIView (Liddell)
- (id)_viewControllerForAncestor;
@end

@interface BBAction : NSObject
+ (id)actionWithLaunchBundleID:(id)arg1 callblock:(id)arg2;
@end

@interface BBBulletin : NSObject
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* message;
@property(nonatomic, copy)NSString* sectionID;
@property(nonatomic, copy)NSString* bulletinID;
@property(nonatomic, copy)NSString* recordID;
@property(nonatomic, retain)NSDate* date;
@end

@interface BBServer : NSObject
- (void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2;
@end

@interface BBObserver : NSObject
@end
