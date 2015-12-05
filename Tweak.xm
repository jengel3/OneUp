#import "SBHeaders.h"

int count = 0;
NSString *oneUpFile = @"/Library/Application Support/OneUp/OneUp.mp3";
NSMutableArray *bulletins = [[NSMutableArray alloc] init];


%group sbHooks
%hook SBBulletinBannerController
- (void)observer:(id)observer addBulletin:(BBBulletin*)bulletin forFeed:(unsigned int)feed playLightsAndSirens:(BOOL)lightsAndSirens withReply:(id)reply {
  if (bulletin && bulletin.bulletinID) {
    count++;
    if (count == 5) {
      count = 0;
      bulletin.sound = [%c(BBSound) alertSoundWithSystemSoundPath:oneUpFile];
    }
  }
  %orig;
}
%end

%end

%ctor {
  %init(sbHooks);
}