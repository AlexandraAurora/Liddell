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

    // check if the notification is a banner
    if (![[[self _viewControllerForAncestor] delegate] isKindOfClass:objc_getClass("SBNotificationBannerDestination")]) {
        return;
    }

    // get the actual notification title, the title property of the hooked class is always uppercase
    UIViewController* controller;
    NCNotificationRequest* request;
    if ([[[self nextResponder] nextResponder] nextResponder]) {
        controller = (UIViewController *)[[[self nextResponder] nextResponder] nextResponder];
        if ([controller isKindOfClass:objc_getClass("NCNotificationShortLookViewController")] && [((NCNotificationShortLookViewController *) controller) notificationRequest])
            request = [((NCNotificationShortLookViewController *) controller) notificationRequest];
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

    // liddell view
    if (![self liddellView]) {
        self.liddellView = [[UIView alloc] init];
        [[self liddellView] setClipsToBounds:YES];
        [[[self liddellView] layer] setCornerRadius:pfCornerRadius];

        if (pfBackgroundColor == kBackgroundColorTypeAdaptive) {
            [[self liddellView] setBackgroundColor:[[libKitten backgroundColor:[[self icons] objectAtIndex:0]] colorWithAlphaComponent:1]];
        } else if (pfBackgroundColor == kBackgroundColorTypeCustom) {
            [[self liddellView] setBackgroundColor:[GcColorPickerUtils colorWithHex:pfCustomBackgroundColor]];
        }

        if (pfBorderWidth != 0) {
            [[[self liddellView] layer] setBorderWidth:pfBorderWidth];
            if (pfBorderColor == kBorderColorTypeAdaptive) {
                [[[self liddellView] layer] setBorderColor:[[[libKitten primaryColor:[[self icons] objectAtIndex:0]] colorWithAlphaComponent:1] CGColor]];
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
            self.liddellBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        } else if (pfBlurMode == kBackgroundBlurTypeDark) {
            self.liddellBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else if (pfBlurMode == kBackgroundBlurTypeAdaptive) {
            self.liddellBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        }

		self.liddellBlurView = [[UIVisualEffectView alloc] initWithEffect:[self liddellBlur]];
        [[self liddellBlurView] setAlpha:pfBlurAmount];
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
        self.liddellIconView = [[UIImageView alloc] init];
        [[self liddellIconView] setImage:[[self icons] objectAtIndex:0]];
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
        self.liddellTitleLabel = [[UILabel alloc] init];
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
                [[self liddellTitleLabel] setTextColor:[libKitten secondaryColor:[[self icons] objectAtIndex:0]]];
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

    // this fixes a bug which causes the app name to disappear on long notification messages
    [[self liddellTitleLabel] layoutIfNeeded];


    // content label
    if (pfShowMessage && ![self liddellContentLabel]) {
        self.liddellContentLabel = [[MarqueeLabel alloc] init];

        // some apps sent notifications starting with a line break, which causes the message to be hidden
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
                [[self liddellContentLabel] setTextColor:[libKitten secondaryColor:[[self icons] objectAtIndex:0]]];
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
}

void (* orig_NCNotificationShortLookView__setGrabberVisible)(NCNotificationShortLookView* self, SEL _cmd, BOOL arg1);
void override_NCNotificationShortLookView__setGrabberVisible(NCNotificationShortLookView* self, SEL _cmd, BOOL arg1) {
    orig_NCNotificationShortLookView__setGrabberVisible(self, _cmd, NO);
}

id (* orig_BBServer_initWithQueue)(BBServer* self, SEL _cmd, id arg1);
id override_BBServer_initWithQueue(BBServer* self, SEL _cmd, id arg1) {
    bbServer = orig_BBServer_initWithQueue(self, _cmd, arg1);
    queue = [self valueForKey:@"_queue"];
    return bbServer;
}

#pragma mark - Test notification

void testBanner() {
	BBBulletin* bulletin = [[objc_getClass("BBBulletin") alloc] init];
    NSProcessInfo* processInfo = [NSProcessInfo processInfo];

	[bulletin setTitle:@"Alice"];
    [bulletin setMessage:@"Another day, a different dream perhaps?"];
    [bulletin setSectionID:@"com.apple.MobileSMS"];
    [bulletin setBulletinID:[processInfo globallyUniqueString]];
    [bulletin setRecordID:[processInfo globallyUniqueString]];
    [bulletin setDate:[NSDate date]];

    if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:)]) {
        dispatch_sync(queue, ^{
            [bbServer publishBulletin:bulletin destinations:15];
        });
    }
}

#pragma mark - Constructor

__attribute__((constructor)) static void initialize() {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"dev.traurige.liddellpreferences"];

	[preferences registerBool:&pfEnabled default:YES forKey:@"enabled"];
	if (!pfEnabled) {
        return;
    }

    // visibility
    [preferences registerBool:&pfShowIcon default:YES forKey:@"showIcon"];
    [preferences registerBool:&pfShowTitle default:YES forKey:@"showTitle"];
    [preferences registerBool:&pfShowMessage default:YES forKey:@"showMessage"];

    // style
    [preferences registerFloat:&pfHeight default:40 forKey:@"height"];
    [preferences registerFloat:&pfCornerRadius default:8 forKey:@"cornerRadius"];
    [preferences registerFloat:&pfOffset default:0 forKey:@"offset"];
    [preferences registerFloat:&pfScrollRate default:50 forKey:@"scrollRate"];

    // background
    [preferences registerUnsignedInteger:&pfBackgroundColor default:kBackgroundColorTypeNone forKey:@"backgroundColor"];
    [preferences registerObject:&pfCustomBackgroundColor default:@"000000" forKey:@"customBackgroundColor"];
    [preferences registerUnsignedInteger:&pfBlurMode default:kBackgroundBlurTypeAdaptive forKey:@"blurMode"];
    [preferences registerFloat:&pfBlurAmount default:1 forKey:@"blurAmount"];

    // icon
    [preferences registerFloat:&pfIconCornerRadius default:0 forKey:@"iconCornerRadius"];

    // text
    [preferences registerUnsignedInteger:&pfTextColor default:kTextColorTypeBackground forKey:@"textColor"];
    [preferences registerObject:&pfCustomTextColor default:@"FFFFFF" forKey:@"customTextColor"];
    [preferences registerUnsignedInteger:&pfTextContent default:kTextColorContentTypeBoth forKey:@"textContent"];
    [preferences registerUnsignedInteger:&pfTitleFontSize default:15 forKey:@"titleFontSize"];
    [preferences registerUnsignedInteger:&pfContentFontSize default:14 forKey:@"contentFontSize"];

    // border
    [preferences registerUnsignedInteger:&pfBorderWidth default:0 forKey:@"borderWidth"];
    [preferences registerUnsignedInteger:&pfBorderColor default:kBorderColorTypeAdaptive forKey:@"borderColor"];
    [preferences registerObject:&pfCustomBorderColor default:@"FFFFFF" forKey:@"customBorderColor"];

    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellView", (objc_property_attribute_t[]){{"T", "@\"UIView\""}, {"N", ""}, {"V", "_liddellView"}}, 3);
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellBlur", (objc_property_attribute_t[]){{"T", "@\"UIBlurEffect\""}, {"N", ""}, {"V", "_liddellBlur"}}, 3);
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellBlurView", (objc_property_attribute_t[]){{"T", "@\"UIVisualEffectView\""}, {"N", ""}, {"V", "_liddellBlurView"}}, 3);
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellIconView", (objc_property_attribute_t[]){{"T", "@\"UIImageView\""}, {"N", ""}, {"V", "_liddellIconView"}}, 3);
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellTitleLabel", (objc_property_attribute_t[]){{"T", "@\"UILabel\""}, {"N", ""}, {"V", "_liddellTitleLabel"}}, 3);
    class_addProperty(NSClassFromString(@"NCNotificationShortLookView"), "liddellContentLabel", (objc_property_attribute_t[]){{"T", "@\"UILabel\""}, {"N", ""}, {"V", "_liddellContentLabel"}}, 3);

    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellView), (IMP)&liddellView, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellView:), (IMP)&setLiddellView, "v@:@");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellBlur), (IMP)&liddellBlur, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellBlur:), (IMP)&setLiddellBlur, "v@:@");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellBlurView), (IMP)&liddellBlurView, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellBlurView:), (IMP)&setLiddellBlurView, "v@:@");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellIconView), (IMP)&liddellIconView, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellIconView:), (IMP)&setLiddellIconView, "v@:@");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellTitleLabel), (IMP)&liddellTitleLabel, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellTitleLabel:), (IMP)&setLiddellTitleLabel, "v@:@");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(liddellContentLabel), (IMP)&liddellContentLabel, "@@:");
    class_addMethod(NSClassFromString(@"NCNotificationShortLookView"), @selector(setLiddellContentLabel:), (IMP)&setLiddellContentLabel, "v@:@");

    MSHookMessageEx(NSClassFromString(@"NCNotificationShortLookView"), @selector(didMoveToWindow), (IMP)&override_NCNotificationShortLookView_didMoveToWindow, (IMP *)&orig_NCNotificationShortLookView_didMoveToWindow);
    MSHookMessageEx(NSClassFromString(@"NCNotificationShortLookView"), @selector(_setGrabberVisible:), (IMP)&override_NCNotificationShortLookView__setGrabberVisible, (IMP *)&orig_NCNotificationShortLookView__setGrabberVisible);
    MSHookMessageEx(NSClassFromString(@"BBServer"), @selector(initWithQueue:), (IMP)&override_BBServer_initWithQueue, (IMP *)&orig_BBServer_initWithQueue);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)testBanner, (CFStringRef)@"dev.traurige.liddell/TestBanner", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
