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
#import "../Preferences/PreferenceKeys.h"

dispatch_queue_t bbQueue;

NSUserDefaults* preferences;
BOOL pfEnabled;
BOOL pfShowIcon;
BOOL pfShowTitle;
BOOL pfShowMessage;
CGFloat pfHeight;
CGFloat pfCornerRadius;
CGFloat pfOffset;
CGFloat pfScrollRate;
NSUInteger pfBackgroundColor;
NSString* pfCustomBackgroundColor;
NSUInteger pfBlurMode;
CGFloat pfIconCornerRadius;
NSUInteger pfTextColor;
NSString* pfCustomTextColor;
NSUInteger pfTextContent;
NSUInteger pfTitleFontSize;
NSUInteger pfContentFontSize;
NSUInteger pfBorderWidth;
NSUInteger pfBorderColor;
NSString* pfCustomBorderColor;

@interface MTPlatterView : UIView
@end

@interface MTTitledPlatterView : MTPlatterView
@end

@interface NCNotificationShortLookView : MTTitledPlatterView
@property(nonatomic, copy)NSArray* icons;
@property(nonatomic, copy)UIImage* prominentIcon;
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

@interface DispatchObject : OS_object
@end

@interface DispatchQueue : DispatchObject
@end

@interface OS_dispatch_queue_serial : DispatchQueue
@end

@interface SBHIconModel : NSObject
@property(nonatomic, copy, readonly)NSSet* visibleIconIdentifiers;
@end

@interface SBIconModel : SBHIconModel
@end

@interface SBIconController : UIViewController
- (SBIconModel *)model;
@end

@interface SBApplicationController : NSObject
+ (instancetype)sharedInstance;
- (NSArray *)allInstalledApplications;
@end

@interface SBApplication : NSObject
@property(nonatomic, readonly)NSString* bundleIdentifier;
@end
