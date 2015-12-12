#import "SBHeaders.h"

#define prefsLoc @"/var/mobile/Library/Preferences/com.jake0oo0.oneup.plist"

int count = 0;
NSString *oneUpFile = @"/Library/Application Support/OneUp/OneUp.mp3";
int frequency = 100;
int lives = 0;
BOOL enabled = YES;
BOOL firstLoad = YES;

static void writeCount() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsLoc];
  [prefs setValue:[NSNumber numberWithInt:count] forKey:@"saved_count"];
  [prefs setValue:[NSNumber numberWithInt:lives] forKey:@"oneup_count"];
  [prefs writeToFile:prefsLoc atomically:YES];
}

%group sbHooks
%hook SBBulletinBannerController
- (void)observer:(id)observer addBulletin:(BBBulletin*)bulletin forFeed:(unsigned int)feed playLightsAndSirens:(BOOL)lightsAndSirens withReply:(id)reply {
  if (bulletin && bulletin.bulletinID && enabled) {
    count++;
    if (count >= frequency) {
      if (count == frequency) {
        bulletin.sound = [%c(BBSound) alertSoundWithSystemSoundPath:oneUpFile];
        lives++;
      }
      count = 0;
      writeCount(); // write count reset
    }
    if ((count % 5) == 0) {
      writeCount(); // write count every 5
    }
  }
  %orig;
}
%end

%end

static void loadPrefs() {
  BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:prefsLoc];

  if (exists) {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsLoc];
    if (prefs) {
      enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
      frequency = [prefs objectForKey:@"frequency"] ? [[prefs objectForKey:@"frequency"] intValue] : 100;
      lives = [prefs objectForKey:@"oneup_count"] ? [[prefs objectForKey:@"oneup_count"] intValue] : 0;
      if (firstLoad) {
        count = [prefs objectForKey:@"saved_count"] ? [[prefs objectForKey:@"saved_count"] intValue] : 0;
        firstLoad = NO;
      }
    }
  }
}

static void handlePrefsChange(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  loadPrefs();
}

%ctor {
  @autoreleasepool {
    loadPrefs();
    CFNotificationCenterAddObserver(
      CFNotificationCenterGetDarwinNotifyCenter(), 
      NULL,
      &handlePrefsChange,
      (CFStringRef)@"com.jake0oo0.oneup/prefsChange",
      NULL, 
      CFNotificationSuspensionBehaviorCoalesce);

    %init(sbHooks);
  }
}