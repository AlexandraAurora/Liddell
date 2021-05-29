#import "Liddell.h"

%group Liddell

%hook NCNotificationShortLookView

%property(nonatomic, retain)UIView* liddellView;
%property(nonatomic, retain)UIBlurEffect* liddellBlur;
%property(nonatomic, retain)UIVisualEffectView* liddellBlurView;
%property(nonatomic, retain)UIImageView* liddellIconView;
%property(nonatomic, retain)UILabel* liddellTitleLabel;
%property(nonatomic, retain)UILabel* liddellContentLabel;

- (void)didMoveToWindow { // add Liddell

    %orig;

    if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) return;
    if (![[[self _viewControllerForAncestor] delegate] isKindOfClass:%c(SBNotificationBannerDestination)]) return; // check if the notification is a banner

    // remove the original notification
    for (UIView* subview in [self subviews]) {
        if (subview == [self liddellView]) continue;
        [subview removeFromSuperview];
    }


    // liddell view
    if (![self liddellView]) {
        self.liddellView = [UIView new];
        [[self liddellView] setClipsToBounds:YES];
        [[[self liddellView] layer] setCornerRadius:[cornerRadiusValue doubleValue]];
        if ([backgroundColorValue intValue] == 1) [[self liddellView] setBackgroundColor:[[libKitten backgroundColor:[[self icons] objectAtIndex:0]] colorWithAlphaComponent:1]];
        else if ([backgroundColorValue intValue] == 2) [[self liddellView] setBackgroundColor:[GcColorPickerUtils colorWithHex:customBackgroundColorValue]];
        if ([borderWidthValue intValue] != 0) {
            [[[self liddellView] layer] setBorderWidth:[borderWidthValue intValue]];
            if ([borderColorValue intValue] == 0) [[[self liddellView] layer] setBorderColor:[[[libKitten primaryColor:[[self icons] objectAtIndex:0]] colorWithAlphaComponent:1] CGColor]];
            else if ([borderColorValue intValue] == 1) [[[self liddellView] layer] setBorderColor:[[GcColorPickerUtils colorWithHex:customBorderColorValue] CGColor]];
        }
        [self addSubview:[self liddellView]];

        [[self liddellView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.liddellView.topAnchor constraintEqualToAnchor:self.topAnchor constant:[offsetValue doubleValue]],
            [self.liddellView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.liddellView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.liddellView.heightAnchor constraintEqualToConstant:[heightValue doubleValue]],
        ]];
    }


    // blur
    if ([blurModeValue intValue] != 0 && ![self liddellBlurView]) {
		if ([blurModeValue intValue] == 1) self.liddellBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        if ([blurModeValue intValue] == 2) self.liddellBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        else if ([blurModeValue intValue] == 3) self.liddellBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		self.liddellBlurView = [[UIVisualEffectView alloc] initWithEffect:[self liddellBlur]];
        [[self liddellBlurView] setAlpha:[blurAmountValue doubleValue]];
		[[self liddellView] addSubview:[self liddellBlurView]];

        [[self liddellBlurView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.liddellBlurView.topAnchor constraintEqualToAnchor:self.liddellView.topAnchor],
            [self.liddellBlurView.leadingAnchor constraintEqualToAnchor:self.liddellView.leadingAnchor],
            [self.liddellBlurView.trailingAnchor constraintEqualToAnchor:self.liddellView.trailingAnchor],
            [self.liddellBlurView.bottomAnchor constraintEqualToAnchor:self.liddellView.bottomAnchor],
        ]];
    }
    

    // icon
    if (showIconSwitch && ![self liddellIconView]) {
        self.liddellIconView = [UIImageView new];
        [[self liddellIconView] setImage:[[self icons] objectAtIndex:0]];
        [[self liddellIconView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self liddellIconView] setClipsToBounds:YES];
        [[[self liddellIconView] layer] setCornerRadius:[iconCornerRadiusValue doubleValue]];
        [[self liddellView] addSubview:[self liddellIconView]];

        [[self liddellIconView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.liddellIconView.leadingAnchor constraintEqualToAnchor:self.liddellView.leadingAnchor constant:8],
            [self.liddellIconView.centerYAnchor constraintEqualToAnchor:self.liddellView.centerYAnchor],
            [self.liddellIconView.heightAnchor constraintEqualToConstant:[heightValue doubleValue] - 13],
            [self.liddellIconView.widthAnchor constraintEqualToConstant:[heightValue doubleValue] - 13],
        ]];
    }


    // app name
    if (showTitleSwitch && ![self liddellTitleLabel]) {
        self.liddellTitleLabel = [UILabel new];
        [[self liddellTitleLabel] setText:[[self title] capitalizedString]];
        [[self liddellTitleLabel] setFont:[UIFont boldSystemFontOfSize:[titleFontSizeValue intValue]]];
        if ([textContentValue intValue] == 0 || [textContentValue intValue] == 2) {
            if ([textColorValue intValue] == 0) {
                if ([backgroundColorValue intValue] == 0) {
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
            } else if ([textColorValue intValue] == 1) {
                [[self liddellTitleLabel] setTextColor:[libKitten secondaryColor:[[self icons] objectAtIndex:0]]];
            } else if ([textColorValue intValue] == 2) {
                [[self liddellTitleLabel] setTextColor:[GcColorPickerUtils colorWithHex:customTextColorValue]];
            }
        }
        [[self liddellView] addSubview:[self liddellTitleLabel]];

        [[self liddellTitleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (showIconSwitch && [self liddellIconView]) {
            [NSLayoutConstraint activateConstraints:@[
                [self.liddellTitleLabel.leadingAnchor constraintEqualToAnchor:self.liddellIconView.trailingAnchor constant:8],
                [self.liddellTitleLabel.centerYAnchor constraintEqualToAnchor:self.liddellView.centerYAnchor],
            ]];
        } else {
            [NSLayoutConstraint activateConstraints:@[
                [self.liddellTitleLabel.leadingAnchor constraintEqualToAnchor:self.liddellView.leadingAnchor constant:8],
                [self.liddellTitleLabel.centerYAnchor constraintEqualToAnchor:self.liddellView.centerYAnchor],
            ]];
        }
    }

    [[self liddellTitleLabel] layoutIfNeeded]; // this fixes a bug which causes the app name to disappear on long notification messages


    // notification title and message
    if (showMessageSwitch && ![self liddellContentLabel]) {
        self.liddellContentLabel = [UILabel new];
        if ([self primaryText] && [self secondaryText]) [[self liddellContentLabel] setText:[NSString stringWithFormat:@"%@: %@", [self primaryText], [self secondaryText]]];
        else [[self liddellContentLabel] setText:[[self secondaryText] stringByReplacingOccurrencesOfString:@"\n" withString:@": "]];
        [[self liddellContentLabel] setFont:[UIFont systemFontOfSize:[contentFontSizeValue intValue]]];
        if ([textContentValue intValue] == 1 || [textContentValue intValue] == 2) {
            if ([textColorValue intValue] == 0) {
                if ([backgroundColorValue intValue] == 0) {
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
            } else if ([textColorValue intValue] == 1) {
                [[self liddellContentLabel] setTextColor:[libKitten secondaryColor:[[self icons] objectAtIndex:0]]];
            } else if ([textColorValue intValue] == 2) {
                [[self liddellContentLabel] setTextColor:[GcColorPickerUtils colorWithHex:customTextColorValue]];
            }
        }
        [[self liddellContentLabel] setMarqueeEnabled:YES];
        [[self liddellContentLabel] setMarqueeRunning:YES];
        [[self liddellView] addSubview:[self liddellContentLabel]];

        [[self liddellContentLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        if ((showIconSwitch && showTitleSwitch) || (!showIconSwitch && showTitleSwitch)) {
            [NSLayoutConstraint activateConstraints:@[
                [self.liddellContentLabel.leadingAnchor constraintEqualToAnchor:self.liddellTitleLabel.trailingAnchor constant:8],
                [self.liddellContentLabel.trailingAnchor constraintEqualToAnchor:self.liddellView.trailingAnchor constant:-8],
                [self.liddellContentLabel.centerYAnchor constraintEqualToAnchor:self.liddellView.centerYAnchor],
            ]];
        } else if (showIconSwitch && !showTitleSwitch) {
            [NSLayoutConstraint activateConstraints:@[
                [self.liddellContentLabel.leadingAnchor constraintEqualToAnchor:self.liddellIconView.trailingAnchor constant:8],
                [self.liddellContentLabel.trailingAnchor constraintEqualToAnchor:self.liddellView.trailingAnchor constant:-8],
                [self.liddellContentLabel.centerYAnchor constraintEqualToAnchor:self.liddellView.centerYAnchor],
            ]];
        } else if (!(showIconSwitch && [self liddellIconView]) && !(showTitleSwitch && [self liddellTitleLabel])) {
            [NSLayoutConstraint activateConstraints:@[
                [self.liddellContentLabel.leadingAnchor constraintEqualToAnchor:self.liddellView.leadingAnchor constant:8],
                [self.liddellContentLabel.trailingAnchor constraintEqualToAnchor:self.liddellView.trailingAnchor constant:-8],
                [self.liddellContentLabel.centerYAnchor constraintEqualToAnchor:self.liddellView.centerYAnchor],
            ]];
        }
    }

}

- (void)_setGrabberVisible:(BOOL)arg1 {

    %orig(NO);

}

%end

%end

%ctor {
    
    preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.liddellpreferences"];

	[preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

    // visibility
    [preferences registerBool:&showIconSwitch default:YES forKey:@"showIcon"];
    [preferences registerBool:&showTitleSwitch default:YES forKey:@"showTitle"];
    [preferences registerBool:&showMessageSwitch default:YES forKey:@"showMessage"];

    // style
    [preferences registerObject:&heightValue default:@"40" forKey:@"height"];
    [preferences registerObject:&cornerRadiusValue default:@"8" forKey:@"cornerRadius"];
    [preferences registerObject:&offsetValue default:@"0" forKey:@"offset"];

    // background
    [preferences registerObject:&backgroundColorValue default:@"0" forKey:@"backgroundColor"];
    if ([backgroundColorValue intValue] == 2) [preferences registerObject:&customBackgroundColorValue default:@"000000" forKey:@"customBackgroundColor"];
    [preferences registerObject:&blurModeValue default:@"3" forKey:@"blurMode"];
    if ([blurModeValue intValue] != 0) [preferences registerObject:&blurAmountValue default:@"1" forKey:@"blurAmount"];

    // icon
    [preferences registerObject:&iconCornerRadiusValue default:@"0" forKey:@"iconCornerRadius"];
    
    // text
    [preferences registerObject:&textColorValue default:@"0" forKey:@"textColor"];
    if ([textColorValue intValue] != 0) [preferences registerObject:&customTextColorValue default:@"FFFFFF" forKey:@"customTextColor"];
    [preferences registerObject:&textContentValue default:@"2" forKey:@"textContent"];
    [preferences registerObject:&titleFontSizeValue default:@"15" forKey:@"titleFontSize"];
    [preferences registerObject:&contentFontSizeValue default:@"14" forKey:@"contentFontSize"];

    // border
    [preferences registerObject:&borderWidthValue default:@"0" forKey:@"borderWidth"];
    if ([borderWidthValue intValue] != 0) {
        [preferences registerObject:&borderColorValue default:@"0" forKey:@"borderColor"];
        if ([borderColorValue intValue] != 0) [preferences registerObject:&customBorderColorValue default:@"FFFFFF" forKey:@"customBorderColor"];
    }
    
    %init(Liddell);

}