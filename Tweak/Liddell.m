//
//  Liddell.m
//  Liddell
//
//  Created by Alexandra (@Traurige)
//

#import "Liddell.h"

BBServer* bbServer;

#pragma mark - Notification class properties

static UIView* liddellView(NCNotificationShortLookView* self, SEL _cmd) {
    return (UIView *)objc_getAssociatedObject(self, (void *)liddellView);
};
static void setLiddellView(NCNotificationShortLookView* self, SEL _cmd, UIView* rawValue) {
    objc_setAssociatedObject(self, (void *)liddellView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static UIBlurEffect* liddellBlur(NCNotificationShortLookView* self, SEL _cmd) {
    return (UIBlurEffect *)objc_getAssociatedObject(self, (void *)liddellBlur);
};
static void setLiddellBlur(NCNotificationShortLookView* self, SEL _cmd, UIBlurEffect* rawValue) {
    objc_setAssociatedObject(self, (void *)liddellBlur, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static UIVisualEffectView* liddellBlurView(NCNotificationShortLookView* self, SEL _cmd) {
    return (UIVisualEffectView *)objc_getAssociatedObject(self, (void *)liddellBlurView);
};
static void setLiddellBlurView(NCNotificationShortLookView* self, SEL _cmd, UIVisualEffectView* rawValue) {
    objc_setAssociatedObject(self, (void *)liddellBlurView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static UIImageView* liddellIconView(NCNotificationShortLookView* self, SEL _cmd) {
    return (UIImageView *)objc_getAssociatedObject(self, (void *)liddellIconView);
};
static void setLiddellIconView(NCNotificationShortLookView* self, SEL _cmd, UIImageView* rawValue) {
    objc_setAssociatedObject(self, (void *)liddellIconView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static UILabel* liddellTitleLabel(NCNotificationShortLookView* self, SEL _cmd) {
    return (UILabel *)objc_getAssociatedObject(self, (void *)liddellTitleLabel);
};
static void setLiddellTitleLabel(NCNotificationShortLookView* self, SEL _cmd, UILabel* rawValue) {
    objc_setAssociatedObject(self, (void *)liddellTitleLabel, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static UILabel* liddellContentLabel(NCNotificationShortLookView* self, SEL _cmd) {
    return (UILabel *)objc_getAssociatedObject(self, (void *)liddellContentLabel);
};
static void setLiddellContentLabel(NCNotificationShortLookView* self, SEL _cmd, UILabel* rawValue) {
    objc_setAssociatedObject(self, (void *)liddellContentLabel, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Notification class hooks

void (* orig_NCNotificationShortLookView_didMoveToWindow)(NCNotificationShortLookView* self, SEL _cmd);
void override_NCNotificationShortLookView_didMoveToWindow(NCNotificationShortLookView* self, SEL _cmd) {
    orig_NCNotificationShortLookView_didMoveToWindow(self, _cmd);

    if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) {
        return;
    }

    if (![[[self _viewControllerForAncestor] delegate] isKindOfClass:objc_getClass("SBNotificationBannerDestination")]) {
        return;
    }

    // get the notification title
    // the title property of the hooked class is always uppercase for some reason
    UIViewController* controller;
    NCNotificationRequest* request;
    if ([[[self nextResponder] nextResponder] nextResponder]) {
        controller = (UIViewController *)[[[self nextResponder] nextResponder] nextResponder];
        if ([controller isKindOfClass:objc_getClass("NCNotificationShortLookViewController")] && [((NCNotificationShortLookViewController *) controller) notificationRequest]) {
            request = [((NCNotificationShortLookViewController *) controller) notificationRequest];
        }
    }

    if (!request || ![request content]) {
        return;
    }

    NCNotificationContent* content = [request content];

    // remove the original notification
    for (UIView* subview in [self subviews]) {
        if (subview == [self liddellView]) {
            continue;
        }
        [subview removeFromSuperview];
    }

    UIImage* icon = [[[UIDevice currentDevice] systemVersion] floatValue] < 15.0 ? [self icons][0] : [self prominentIcon];

    // liddell view
    if (![self liddellView]) {
        [self setLiddellView:[[UIView alloc] init]];
        [[self liddellView] setClipsToBounds:YES];
        [[[self liddellView] layer] setCornerRadius:pfCornerRadius];

        if (pfBackgroundColor == kBackgroundColorTypeAdaptive) {
            [[self liddellView] setBackgroundColor:[[libKitten backgroundColor:icon] colorWithAlphaComponent:1]];
        } else if (pfBackgroundColor == kBackgroundColorTypeCustom) {
            [[self liddellView] setBackgroundColor:[GcColorPickerUtils colorWithHex:pfCustomBackgroundColor]];
        }

        if (pfBorderWidth != 0) {
            [[[self liddellView] layer] setBorderWidth:pfBorderWidth];
            if (pfBorderColor == kBorderColorTypeAdaptive) {
                [[[self liddellView] layer] setBorderColor:[[[libKitten primaryColor:icon] colorWithAlphaComponent:1] CGColor]];
            } else if (pfBorderColor == kBorderColorTypeCustom) {
                [[[self liddellView] layer] setBorderColor:[[GcColorPickerUtils colorWithHex:pfCustomBorderColor] CGColor]];
            }
        }

        [self addSubview:[self liddellView]];

        [[self liddellView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self liddellView] topAnchor] constraintEqualToAnchor:[self topAnchor] constant:pfOffset],
            [[[self liddellView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self liddellView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self liddellView] heightAnchor] constraintEqualToConstant:pfHeight]
        ]];
    }


    // blur view
    if (pfBlurMode != kBackgroundBlurTypeNone && ![self liddellBlurView]) {
		if (pfBlurMode == kBackgroundBlurTypeLight) {
            [self setLiddellBlur:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        } else if (pfBlurMode == kBackgroundBlurTypeDark) {
            [self setLiddellBlur:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        } else if (pfBlurMode == kBackgroundBlurTypeAdaptive) {
            [self setLiddellBlur:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
        }

        [self setLiddellBlurView:[[UIVisualEffectView alloc] initWithEffect:[self liddellBlur]]];
		[[self liddellView] addSubview:[self liddellBlurView]];

        [[self liddellBlurView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self liddellBlurView] topAnchor] constraintEqualToAnchor:[[self liddellView] topAnchor]],
            [[[self liddellBlurView] leadingAnchor] constraintEqualToAnchor:[[self liddellView] leadingAnchor]],
            [[[self liddellBlurView] trailingAnchor] constraintEqualToAnchor:[[self liddellView] trailingAnchor]],
            [[[self liddellBlurView] bottomAnchor] constraintEqualToAnchor:[[self liddellView] bottomAnchor]]
        ]];
    }


    // icon view
    if (pfShowIcon && ![self liddellIconView]) {
        [self setLiddellIconView:[[UIImageView alloc] init]];
        [[self liddellIconView] setImage:icon];
        [[self liddellIconView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self liddellIconView] setClipsToBounds:YES];

        if (pfIconCornerRadius == -1) {
            [[[self liddellIconView] layer] setCornerRadius:(pfHeight - 13) / 2];
        } else {
            [[[self liddellIconView] layer] setCornerRadius:pfIconCornerRadius];
        }

        [[self liddellView] addSubview:[self liddellIconView]];

        [[self liddellIconView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self liddellIconView] leadingAnchor] constraintEqualToAnchor:[[self liddellView] leadingAnchor] constant:8],
            [[[self liddellIconView] centerYAnchor] constraintEqualToAnchor:[[self liddellView] centerYAnchor]],
            [[[self liddellIconView] heightAnchor] constraintEqualToConstant:pfHeight - 13],
            [[[self liddellIconView] widthAnchor] constraintEqualToConstant:pfHeight - 13]
        ]];
    }


    // title label
    if (pfShowTitle && ![self liddellTitleLabel]) {
        [self setLiddellTitleLabel:[[UILabel alloc] init]];
        [[self liddellTitleLabel] setText:[content header]];
        [[self liddellTitleLabel] setFont:[UIFont boldSystemFontOfSize:pfTitleFontSize]];
        if (pfTextContent == kTextColorContentTypeTitle || pfTextContent == kTextColorContentTypeBoth) {
            if (pfTextColor == kTextColorTypeBackground) {
                if (pfBackgroundColor == kBackgroundColorTypeNone) {
                    if (![[[self liddellBlurView] effect] isEqual:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]]) {
                        if ([[[self liddellBlurView] effect] isEqual:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]]) {
                            [[self liddellTitleLabel] setTextColor:[UIColor whiteColor]];
                        } else if ([[[self liddellBlurView] effect] isEqual:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]]) {
                            [[self liddellTitleLabel] setTextColor:[UIColor blackColor]];
                        }
                    } else {
                        [[self liddellTitleLabel] setTextColor:[UIColor labelColor]];
                    }
                } else {
                    if ([libKitten isDarkColor:[[self liddellView] backgroundColor]]) {
                        [[self liddellTitleLabel] setTextColor:[UIColor whiteColor]];
                    } else if (![libKitten isDarkColor:[[self liddellView] backgroundColor]]) {
                        [[self liddellTitleLabel] setTextColor:[UIColor blackColor]];
                    }
                }
            } else if (pfTextColor == kTextColorTypeAdaptive) {
                [[self liddellTitleLabel] setTextColor:[libKitten secondaryColor:icon]];
            } else if (pfTextColor == kTextColorTypeCustom) {
                [[self liddellTitleLabel] setTextColor:[GcColorPickerUtils colorWithHex:pfCustomTextColor]];
            }
        }
        [[self liddellView] addSubview:[self liddellTitleLabel]];

        [[self liddellTitleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (pfShowIcon && [self liddellIconView]) {
            [NSLayoutConstraint activateConstraints:@[
                [[[self liddellTitleLabel] leadingAnchor] constraintEqualToAnchor:[[self liddellIconView] trailingAnchor] constant:8],
                [[[self liddellTitleLabel] centerYAnchor] constraintEqualToAnchor:[[self liddellView] centerYAnchor]]
            ]];
        } else {
            [NSLayoutConstraint activateConstraints:@[
                [[[self liddellTitleLabel] leadingAnchor] constraintEqualToAnchor:[[self liddellView] leadingAnchor] constant:8],
                [[[self liddellTitleLabel] centerYAnchor] constraintEqualToAnchor:[[self liddellView] centerYAnchor]]
            ]];
        }
    }


    // content label
    if (pfShowMessage && ![self liddellContentLabel]) {
        [self setLiddellContentLabel:[[MarqueeLabel alloc] init]];

        // some apps send notifications starting with a line break, which causes the message to be hidden
        if ([self primaryText] && [self secondaryText]) {
            [[self liddellContentLabel] setText:[NSString stringWithFormat:@"%@: %@", [self primaryText], [self secondaryText]]];
        } else {
            [[self liddellContentLabel] setText:[[self secondaryText] stringByReplacingOccurrencesOfString:@"\n" withString:@": "]];
        }

        [[self liddellContentLabel] setFont:[UIFont systemFontOfSize:pfContentFontSize]];
        if (pfTextContent == kTextColorContentTypeContent || pfTextContent == kTextColorContentTypeBoth) {
            if (pfTextColor == kTextColorContentTypeTitle) {
                if (pfBackgroundColor == kBackgroundColorTypeNone) {
                    if (![[[self liddellBlurView] effect] isEqual:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]]) {
                        if ([[[self liddellBlurView] effect] isEqual:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]]) {
                            [[self liddellContentLabel] setTextColor:[UIColor whiteColor]];
                        } else if ([[[self liddellBlurView] effect] isEqual:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]]) {
                            [[self liddellContentLabel] setTextColor:[UIColor blackColor]];
                        }
                    } else {
                        [[self liddellContentLabel] setTextColor:[UIColor labelColor]];
                    }
                } else {
                    if ([libKitten isDarkColor:[[self liddellView] backgroundColor]]) {
                        [[self liddellContentLabel] setTextColor:[UIColor whiteColor]];
                    } else if (![libKitten isDarkColor:[[self liddellView] backgroundColor]]) {
                        [[self liddellContentLabel] setTextColor:[UIColor blackColor]];
                    }
                }
            } else if (pfTextColor == kTextColorTypeAdaptive) {
                [[self liddellContentLabel] setTextColor:[libKitten secondaryColor:icon]];
            } else if (pfTextColor == kTextColorTypeCustom) {
                [[self liddellContentLabel] setTextColor:[GcColorPickerUtils colorWithHex:pfCustomTextColor]];
            }
        }
        [[self liddellContentLabel] setScrollRate:pfScrollRate];
        [[self liddellContentLabel] setFadeLength:5];
        [[self liddellView] addSubview:[self liddellContentLabel]];

        [[self liddellContentLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        if ((pfShowIcon && pfShowTitle) || (!pfShowIcon && pfShowTitle)) {
            [NSLayoutConstraint activateConstraints:@[
                [[[self liddellContentLabel] leadingAnchor] constraintEqualToAnchor:[[self liddellTitleLabel] trailingAnchor] constant:8],
                [[[self liddellContentLabel] trailingAnchor] constraintEqualToAnchor:[[self liddellView] trailingAnchor] constant:-12],
                [[[self liddellContentLabel] centerYAnchor] constraintEqualToAnchor:[[self liddellView] centerYAnchor]]
            ]];
        } else if (pfShowIcon && !pfShowTitle) {
            [NSLayoutConstraint activateConstraints:@[
                [[[self liddellContentLabel] leadingAnchor] constraintEqualToAnchor:[[self liddellIconView] trailingAnchor] constant:8],
                [[[self liddellContentLabel] trailingAnchor] constraintEqualToAnchor:[[self liddellView] trailingAnchor] constant:-12],
                [[[self liddellContentLabel] centerYAnchor] constraintEqualToAnchor:[[self liddellView] centerYAnchor]]
            ]];
        } else if (!(pfShowIcon && [self liddellIconView]) && !(pfShowTitle && [self liddellTitleLabel])) {
            [NSLayoutConstraint activateConstraints:@[
                [[[self liddellContentLabel] leadingAnchor] constraintEqualToAnchor:[[self liddellView] leadingAnchor] constant:8],
                [[[self liddellContentLabel] trailingAnchor] constraintEqualToAnchor:[[self liddellView] trailingAnchor] constant:-12],
                [[[self liddellContentLabel] centerYAnchor] constraintEqualToAnchor:[[self liddellView] centerYAnchor]]
            ]];
        }
    }

    // the title is hidden behind the content label if the content label is too long
    // bringing it to the front fixes that issue
    [[self liddellView] bringSubviewToFront:[self liddellTitleLabel]];
}

void (* orig_NCNotificationShortLookView__setGrabberVisible)(NCNotificationShortLookView* self, SEL _cmd, BOOL visible);
void override_NCNotificationShortLookView__setGrabberVisible(NCNotificationShortLookView* self, SEL _cmd, BOOL visible) {
    orig_NCNotificationShortLookView__setGrabberVisible(self, _cmd, NO);
}

BBServer* (* orig_BBServer_initWithQueue)(BBServer* self, SEL _cmd, OS_dispatch_queue_serial* queue);
BBServer* override_BBServer_initWithQueue(BBServer* self, SEL _cmd, OS_dispatch_queue_serial* queue) {
    bbServer = orig_BBServer_initWithQueue(self, _cmd, queue);
    bbQueue = [self valueForKey:@"_queue"];
    return bbServer;
}

#pragma mark - Notification callbacks

static void show_test_banner() {
	BBBulletin* bulletin = [[objc_getClass("BBBulletin") alloc] init];
    NSProcessInfo* processInfo = [NSProcessInfo processInfo];

	[bulletin setTitle:@"Alice"];
    [bulletin setMessage:@"Another day, a different dream perhaps?"];
    [bulletin setSectionID:@"com.apple.MobileSMS"];
    [bulletin setBulletinID:[processInfo globallyUniqueString]];
    [bulletin setRecordID:[processInfo globallyUniqueString]];
    [bulletin setDate:[NSDate date]];

    if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:)]) {
        dispatch_sync(bbQueue, ^{
            [bbServer publishBulletin:bulletin destinations:15];
        });
    }
}

#pragma mark - Preferences

static void load_preferences() {
    preferences = [[NSUserDefaults alloc] initWithSuiteName:@"dev.traurige.liddell.preferences"];

    [preferences registerDefaults:@{
		kPreferenceKeyEnabled: @(kPreferenceKeyEnabledDefaultValue),
        kPreferenceKeyShowIcon: @(kPreferenceKeyShowIconDefaultValue),
        kPreferenceKeyShowTitle: @(kPreferenceKeyShowTitleDefaultValue),
        kPreferenceKeyShowMessage: @(kPreferenceKeyShowMessageDefaultValue),
        kPreferenceKeyHeight: @(kPreferenceKeyHeightDefaultValue),
        kPreferenceKeyCornerRadius: @(kPreferenceKeyCornerRadiusDefaultValue),
        kPreferenceKeyOffset: @(kPreferenceKeyOffsetDefaultValue),
        kPreferenceKeyScrollRate: @(kPreferenceKeyScrollRateDefaultValue),
        kPreferenceKeyBackgroundColor: @(kPreferenceKeyBackgroundColorDefaultValue),
        kPreferenceKeyCustomBackgroundColor: kPreferenceKeyCustomBackgroundColorDefaultValue,
        kPreferenceKeyBlurMode: @(kPreferenceKeyBlurModeDefaultValue),
        kPreferenceKeyIconCornerRadius: @(kPreferenceKeyIconCornerRadiusDefaultValue),
        kPreferenceKeyTextColor: @(kPreferenceKeyTextColorDefaultValue),
        kPreferenceKeyCustomTextColor: kPreferenceKeyCustomTextColorDefaultValue,
        kPreferenceKeyTextContent: @(kPreferenceKeyTextContentDefaultValue),
        kPreferenceKeyTitleFontSize: @(kPreferenceKeyTitleFontSizeDefaultValue),
        kPreferenceKeyContentFontSize: @(kPreferenceKeyContentFontSizeDefaultValue),
        kPreferenceKeyBorderWidth: @(kPreferenceKeyBorderWidthDefaultValue),
        kPreferenceKeyBorderColor: @(kPreferenceKeyBorderColorDefaultValue),
        kPreferenceKeyCustomBorderColor: kPreferenceKeyCustomBorderColorDefaultValue
	}];

    pfEnabled = [[preferences objectForKey:kPreferenceKeyEnabled] boolValue];
    pfShowIcon = [[preferences objectForKey:kPreferenceKeyShowIcon] boolValue];
    pfShowTitle = [[preferences objectForKey:kPreferenceKeyShowTitle] boolValue];
    pfShowMessage = [[preferences objectForKey:kPreferenceKeyShowMessage] boolValue];
    pfHeight = [[preferences objectForKey:kPreferenceKeyHeight] floatValue];
    pfCornerRadius = [[preferences objectForKey:kPreferenceKeyCornerRadius] floatValue];
    pfOffset = [[preferences objectForKey:kPreferenceKeyOffset] floatValue];
    pfScrollRate = [[preferences objectForKey:kPreferenceKeyScrollRate] floatValue];
    pfBackgroundColor = [[preferences objectForKey:kPreferenceKeyBackgroundColor] intValue];
    pfCustomBackgroundColor = [preferences objectForKey:kPreferenceKeyCustomBackgroundColor];
    pfBlurMode = [[preferences objectForKey:kPreferenceKeyBlurMode] intValue];
    pfIconCornerRadius = [[preferences objectForKey:kPreferenceKeyIconCornerRadius] floatValue];
    pfTextColor = [[preferences objectForKey:kPreferenceKeyTextColor] intValue];
    pfCustomTextColor = [preferences objectForKey:kPreferenceKeyCustomTextColor];
    pfTextContent = [[preferences objectForKey:kPreferenceKeyTextContent] intValue];
    pfTitleFontSize = [[preferences objectForKey:kPreferenceKeyTitleFontSize] floatValue];
    pfContentFontSize = [[preferences objectForKey:kPreferenceKeyContentFontSize] floatValue];
    pfBorderWidth = [[preferences objectForKey:kPreferenceKeyBorderWidth] floatValue];
    pfBorderColor = [[preferences objectForKey:kPreferenceKeyBorderColor] intValue];
    pfCustomBorderColor = [preferences objectForKey:kPreferenceKeyCustomBorderColor];
}

#pragma mark - Constructor

__attribute__((constructor)) static void initialize() {
    load_preferences();

	if (!pfEnabled) {
        return;
    }

    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellView", (objc_property_attribute_t[]){{"T", "@\"UIView\""}, {"N", ""}, {"V", "_liddellView"}}, 3);
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellView), (IMP)&liddellView, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellView:), (IMP)&setLiddellView, "v@:@");
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellBlur", (objc_property_attribute_t[]){{"T", "@\"UIBlurEffect\""}, {"N", ""}, {"V", "_liddellBlur"}}, 3);
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellBlur), (IMP)&liddellBlur, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellBlur:), (IMP)&setLiddellBlur, "v@:@");
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellBlurView", (objc_property_attribute_t[]){{"T", "@\"UIVisualEffectView\""}, {"N", ""}, {"V", "_liddellBlurView"}}, 3);
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellBlurView), (IMP)&liddellBlurView, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellBlurView:), (IMP)&setLiddellBlurView, "v@:@");
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellIconView", (objc_property_attribute_t[]){{"T", "@\"UIImageView\""}, {"N", ""}, {"V", "_liddellIconView"}}, 3);
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellIconView), (IMP)&liddellIconView, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellIconView:), (IMP)&setLiddellIconView, "v@:@");
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellTitleLabel", (objc_property_attribute_t[]){{"T", "@\"UILabel\""}, {"N", ""}, {"V", "_liddellTitleLabel"}}, 3);
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellTitleLabel), (IMP)&liddellTitleLabel, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellTitleLabel:), (IMP)&setLiddellTitleLabel, "v@:@");
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellContentLabel", (objc_property_attribute_t[]){{"T", "@\"UILabel\""}, {"N", ""}, {"V", "_liddellContentLabel"}}, 3);
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellContentLabel), (IMP)&liddellContentLabel, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellContentLabel:), (IMP)&setLiddellContentLabel, "v@:@");

    MSHookMessageEx(NSClassFromString(@"NCNotificationShortLookView"), @selector(didMoveToWindow), (IMP)&override_NCNotificationShortLookView_didMoveToWindow, (IMP *)&orig_NCNotificationShortLookView_didMoveToWindow);
    MSHookMessageEx(NSClassFromString(@"NCNotificationShortLookView"), @selector(_setGrabberVisible:), (IMP)&override_NCNotificationShortLookView__setGrabberVisible, (IMP *)&orig_NCNotificationShortLookView__setGrabberVisible);
    MSHookMessageEx(NSClassFromString(@"BBServer"), @selector(initWithQueue:), (IMP)&override_BBServer_initWithQueue, (IMP *)&orig_BBServer_initWithQueue);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)show_test_banner, (CFStringRef)@"dev.traurige.liddell.test_banner", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)load_preferences, (CFStringRef)@"dev.traurige.liddell.preferences.reload", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
