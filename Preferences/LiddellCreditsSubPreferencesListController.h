//
//  LiddellCreditsSubPreferencesListController.h
//  Liddell
//
//  Created by Alexandra (@Traurige)
//

#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

@interface LiddellAppearanceSettings : HBAppearanceSettings
@end

@interface LiddellCreditsSubPreferencesListController : HBListController
@property(nonatomic, retain)LiddellAppearanceSettings* appearanceSettings;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@end
