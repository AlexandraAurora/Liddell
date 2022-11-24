//
//  PreferenceKeys.h
//  Liddell
//
//  Created by Alexandra (@Traurige)
//

static NSString* const kPreferenceKeyEnabled = @"Enabled";
static NSString* const kPreferenceKeyShowIcon = @"ShowIcon";
static NSString* const kPreferenceKeyShowTitle = @"ShowTitle";
static NSString* const kPreferenceKeyShowMessage = @"ShowMessage";
static NSString* const kPreferenceKeyHeight = @"Height";
static NSString* const kPreferenceKeyCornerRadius = @"CornerRadius";
static NSString* const kPreferenceKeyOffset = @"Offset";
static NSString* const kPreferenceKeyScrollRate = @"ScrollRate";
static NSString* const kPreferenceKeyBackgroundColor = @"BackgroundColor";
static NSString* const kPreferenceKeyCustomBackgroundColor = @"CustomBackgroundColor";
static NSString* const kPreferenceKeyBlurMode = @"BlurMode";
static NSString* const kPreferenceKeyBlurAmount = @"BlurAmount";
static NSString* const kPreferenceKeyIconCornerRadius = @"IconCornerRadius";
static NSString* const kPreferenceKeyTextColor = @"TextColor";
static NSString* const kPreferenceKeyCustomTextColor = @"CustomTextColor";
static NSString* const kPreferenceKeyTextContent = @"TextContent";
static NSString* const kPreferenceKeyTitleFontSize = @"TitleFontSize";
static NSString* const kPreferenceKeyContentFontSize = @"ContentFontSize";
static NSString* const kPreferenceKeyBorderWidth = @"BorderWidth";
static NSString* const kPreferenceKeyBorderColor = @"BorderColor";
static NSString* const kPreferenceKeyCustomBorderColor = @"CustomBorderColor";

static const NSUInteger kBackgroundColorTypeNone = 0;
static const NSUInteger kBackgroundColorTypeAdaptive = 1;
static const NSUInteger kBackgroundColorTypeCustom = 2;
static const NSUInteger kBackgroundBlurTypeNone = 0;
static const NSUInteger kBackgroundBlurTypeLight = 1;
static const NSUInteger kBackgroundBlurTypeDark = 2;
static const NSUInteger kBackgroundBlurTypeAdaptive = 3;
static const NSUInteger kTextColorTypeBackground = 0;
static const NSUInteger kTextColorTypeAdaptive = 1;
static const NSUInteger kTextColorTypeCustom = 2;
static const NSUInteger kTextColorContentTypeTitle = 0;
static const NSUInteger kTextColorContentTypeContent = 1;
static const NSUInteger kTextColorContentTypeBoth = 2;
static const NSUInteger kBorderColorTypeAdaptive = 0;
static const NSUInteger kBorderColorTypeCustom = 1;

static BOOL const kPreferenceKeyEnabledDefaultValue = YES;
static BOOL const kPreferenceKeyShowIconDefaultValue = YES;
static BOOL const kPreferenceKeyShowTitleDefaultValue = YES;
static BOOL const kPreferenceKeyShowMessageDefaultValue = YES;
static CGFloat const kPreferenceKeyHeightDefaultValue = 40;
static CGFloat const kPreferenceKeyCornerRadiusDefaultValue = 8;
static CGFloat const kPreferenceKeyOffsetDefaultValue = 0;
static CGFloat const kPreferenceKeyScrollRateDefaultValue = 50;
static NSUInteger const kPreferenceKeyBackgroundColorDefaultValue = kBackgroundColorTypeNone;
static NSString* const kPreferenceKeyCustomBackgroundColorDefaultValue = @"000000";
static NSUInteger const kPreferenceKeyBlurModeDefaultValue = kBackgroundBlurTypeAdaptive;
static CGFloat const kPreferenceKeyBlurAmountDefaultValue = 1;
static CGFloat const kPreferenceKeyIconCornerRadiusDefaultValue = 0;
static NSUInteger const kPreferenceKeyTextColorDefaultValue = kTextColorTypeBackground;
static NSString* const kPreferenceKeyCustomTextColorDefaultValue = @"FFFFFF";
static NSUInteger const kPreferenceKeyTextContentDefaultValue = kTextColorContentTypeBoth;
static CGFloat const kPreferenceKeyTitleFontSizeDefaultValue = 15;
static CGFloat const kPreferenceKeyContentFontSizeDefaultValue = 14;
static CGFloat const kPreferenceKeyBorderWidthDefaultValue = 0;
static NSUInteger const kPreferenceKeyBorderColorDefaultValue = kBorderColorTypeAdaptive;
static NSString* const kPreferenceKeyCustomBorderColorDefaultValue = @"FFFFFF";
