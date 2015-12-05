#import <Preferences/Preferences.h>
#import <SettingsKit/SKListControllerProtocol.h>
#import <SettingsKit/SKTintedListController.h>

@interface OneUpPreferencesController: SKTintedListController<SKListControllerProtocol>
@end

@implementation OneUpPreferencesController

/*
 Want a tint color?
 -(UIColor*) tintColor { return [UIColor orangeColor]; }
 -(BOOL) tintNavigationTitleText { return NO; }
 */


- (NSString *) headerText { return @"OneUp"; }
- (NSString *) customTitle { return @"OneUp"; }

- (NSArray *) customSpecifiers {
  return @[
          @{
            @"cell": @"PSGroupCell",
            @"label": @"OneUpPrefs Settings"
          },
          @{
            @"cell": @"PSSwitchCell",
            @"default": @YES,
            @"defaults": @"com.jake0oo0.oneupprefs",
            @"key": @"enabled",
            @"label": @"Enabled",
            @"PostNotification": @"OneUpPrefs/reloadSettings",
            @"cellClass": @"SKTintedSwitchCell"
          }
        ];
}
@end
