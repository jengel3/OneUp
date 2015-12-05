@interface BBSound : NSObject
+ (id)alertSoundWithSystemSoundID:(unsigned long)arg1;
+ (id)alertSoundWithSystemSoundPath:(id)arg1;
@end

@interface BBBulletin : NSObject
@property (nonatomic, retain) BBSound *sound;
@property (nonatomic, copy) NSString *accountIdentifier;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, retain) NSDictionary *context;
@property (nonatomic, copy) NSString *section;
@property (nonatomic, copy) NSString *bulletinID;
- (BBSound*)sound;
- (id)message;
@end

@interface SBBulletinBannerController
- (void)observer:(id)observer addBulletin:(BBBulletin*)bulletin forFeed:(unsigned int)feed;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned int)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(id)arg5;
@end