#import <Preferences/Preferences.h>
#import <SettingsKit/SKListControllerProtocol.h>
#import <SettingsKit/SKTintedListController.h>
#import <SettingsKit/SKPersonCell.h>
#import <SettingsKit/SKSharedHelper.h>

#define valuesPath @"/User/Library/Preferences/com.jake0oo0.oneup.plist"

@interface OneUpPreferencesController: SKTintedListController <SKListControllerProtocol>
- (void)openPayPal:(id)sender;
@end

@interface DeveloperCell : SKPersonCell
@end

@interface DesignerCell : SKPersonCell
@end

@interface DevelopersListCell : SKTintedListController <SKListControllerProtocol>
@end

@implementation DeveloperCell
- (NSString *)personDescription { return @"Lead Developer"; }
- (NSString *)name { return @"Jake0oo0"; }
- (NSString *)twitterHandle { return @"itsjake88"; }
- (NSString *)imageName { return @"Jake@2x.png"; }
@end

@implementation DesignerCell
- (NSString *)personDescription { return @"Lead Designer"; }
- (NSString *)name { return @"AOkhtenberg"; }
- (NSString *)twitterHandle { return @"AOkhtenberg"; }
- (NSString *)imageName { return @"AOkhtenberg@2x.png"; }
@end

@implementation DevelopersListCell
- (BOOL)showHeartImage {
  return NO;
}

- (void)openJakeTwitter {
  [SKSharedHelper openTwitter:@"itsjake88"];
}

- (void)openAOkTwitter {
  [SKSharedHelper openTwitter:@"AOkhtenberg"];
}

- (NSArray *)customSpecifiers {
  return @[
    @{
      @"cell": @"PSLinkCell",
      @"cellClass": @"DeveloperCell",
      @"height": @100,
      @"action": @"openJakeTwitter"
    },
    @{
      @"cell": @"PSLinkCell",
      @"cellClass": @"DesignerCell",
      @"height": @100,
      @"action": @"openAOkTwitter"
    }
  ];
}
@end

@implementation OneUpPreferencesController
// - (UIColor *)tintColor { 
//   return [UIColor colorWithRed:0.19 green:0.56 blue:0.84 alpha:1.0]; // instagram color
// }
- (BOOL)tintNavigationTitleText { 
  return YES; 
}

- (NSString *)shareMessage {
    return @"I'm using #OneUp by @itsjake88 to play special notification sounds!";
}

- (NSString *)headerText { 
  return @"OneUp"; 
}

- (NSString *)headerSubText {
  return @"OneUp Notifications";
}

- (NSString *)customTitle { 
  return @"OneUp"; 
}
- (NSArray *)customSpecifiers {
  return @[
    @{
      @"cell": @"PSGroupCell",
      @"label": @"OneUp Settings"
    },
    @{
      @"cell": @"PSSwitchCell",
      @"default": @YES,
      @"defaults": @"com.jake0oo0.oneupprefs",
      @"key": @"enabled",
      @"label": @"Enabled",
      @"PostNotification": @"com.jake0oo0.oneup/settingsChanged",
      @"cellClass": @"SKTintedSwitchCell"
    },
    @{
      @"cell": @"PSEditTextCell",
      @"placeholder": @"100",
      @"defaults": @"com.jake0oo0.oneupprefs",
      @"key": @"activate_every",
      @"label": @"Activation Count",
      @"PostNotification": @"com.jake0oo0.oneup/settingsChanged",
      @"isNumeric": @YES,
      @"keyboard": @"{'numbers'}"
    },
    @{
      @"cell": @"PSGroupCell",
      @"label": @"Developers"
    },
    @{
      @"cell": @"PSLinkCell",
      @"cellClass": @"SKTintedCell",
      @"detail": @"DevelopersListCell",
      @"label": @"Developers"
    },
    @{
      @"cell": @"PSButtonCell",
      @"action": @"openPayPal:",
      @"label": @"Donate",
      @"icon": @"PayPal.png"
    },
  ];

}

- (void)openPayPal:(id)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/itsjake"]];
}

// http://iphonedevwiki.net/index.php/PreferenceBundles
- (id)readPreferenceValue:(PSSpecifier *)specifier {
  NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:valuesPath];
  if (!settings[specifier.properties[@"key"]]) {
    return specifier.properties[@"default"];
  }
  return settings[specifier.properties[@"key"]];
}
 
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
  [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:valuesPath]];
  [defaults setObject:value forKey:specifier.properties[@"key"]];
  [defaults writeToFile:valuesPath atomically:NO];
  CFStringRef toPost = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
  if (toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}
// end
@end
