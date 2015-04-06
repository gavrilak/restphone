//
//  BASAppDelegate.m
//  RestrauntSystem
//
//  Created by Sergey on 03.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//


#import "BASAppDelegate.h"
#import "RCSAuthViewController.h"
#import "BASTabbarViewController.h"
#import <AVFoundation/AVFoundation.h>

#define CIRCLETIME 15.f
#define VIBRCOUNT 5

@interface BASAppDelegate()

@property(nonatomic, strong)  AVAudioPlayer *player;
@property (nonatomic,strong)  AVAudioPlayer* playerNotice;
@property(nonatomic,assign)   int vibrateCount;
@property (nonatomic, retain) NSTimer * vibrateTimer;

@end

@implementation BASAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.noticeCnt = 0;
    self.isNotice = YES;
    self.employeeInfo = nil;
    self.isOrder = NO;
    self.curCoastOrder = 0;
    self.isWaiter = YES;
    self.isBackground = NO;
    self.isShowMessage = NO;
    self.curOrderList = nil;
    self.addOrderList = nil;
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotification)
    {
        NSLog(@"Notification Body: %@",localNotification.alertBody);
        NSLog(@"%@", localNotification.userInfo);
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    application.applicationIconBadgeNumber = 0;
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self customizeNavBarAppearance];
    self.authController = [[RCSAuthViewController alloc]init];
    self.window.rootViewController = _authController;
    [self.window makeKeyAndVisible];

    return YES;
}
#pragma mark - Public methods
- (NSArray*)sortContent:(NSArray*)source withType:(SwitchType)type{
    
    NSMutableArray* data = [NSMutableArray new];
    NSInteger status = type;
    
    for(NSDictionary* obj in source){
        NSNumber* message_status = (NSNumber*)[obj objectForKey:@"message_status"];
        if([message_status intValue] == status){
            [data addObject:obj];
        }
    }
    
    
    return  [NSArray arrayWithArray:data];
}

- (void)startbackgroundTask{
    [self playBlankMp3];
    [self performSelectorInBackground:@selector(backgroundTask) withObject:nil];
}
- (void)setNoticeCnt:(NSUInteger)noticeCnt
{
    _noticeCnt = noticeCnt;
    
    
    if (_tabBarController != nil && [_tabBarController respondsToSelector:@selector(showNoticesCount:)] && _noticeCnt > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:noticeCnt];
            
        });
        [_tabBarController showNoticesCount:noticeCnt];
    } else {
        [_tabBarController clearNoticesCount];
    }
    
    
}
- (BOOL) is4InchScreen{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        return YES;
    }
    return NO;
}

#pragma mark - Private methods
-(void)vibratePhone {
    
    _vibrateCount ++;
    
    if(_vibrateCount <= VIBRCOUNT)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    else
        [_vibrateTimer invalidate];
        
   
}
- (void) playSound {
    
    NSString *name = [[NSString alloc] initWithFormat:@"alarm4"];
    NSString *source = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    if (self.playerNotice) {
        [self.playerNotice stop];
        self.playerNotice = nil;
    }
    self.playerNotice=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath: source] error:NULL];
    self.playerNotice.numberOfLoops = 0;
    [self.playerNotice play];
    
    self.vibrateCount = 0;
    self.vibrateTimer = nil;
    self.vibrateTimer = [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(vibratePhone) userInfo:nil repeats:YES];

}
- (void)playBlankMp3
{
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    NSString *audioFileName = [[Settings text:TextForBlankAudioFileName] stringByDeletingPathExtension];
    NSString *audioFileExt = [[Settings text:TextForBlankAudioFileName] pathExtension];
    NSURL *audioFileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:audioFileName ofType:audioFileExt]];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileUrl error:&error];
    if (error) {
        ALog(@"%@", error);
        
        return;
    }
    
    self.player.numberOfLoops = -1;
    [self.player play];
}

- (void)showLocalNotification
{
    UIApplication* app = [UIApplication sharedApplication];
    
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    if (alarm)
    {
        alarm.fireDate = [NSDate date];
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
        alarm.soundName = @"alarm4.mp3";
        alarm.alertBody = self.noticeMessage;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [app scheduleLocalNotification:alarm];
        });
    }
}

- (void)backgroundTask {

    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [self.employeeInfo objectForKey:@"id_employee"] ,@"id_employee",
                           nil];
    
    while (YES) {
  
        [[BASManager sharedInstance] getData:[[BASManager sharedInstance] formatRequest:[Settings text:TextForApiFuncGetUnreadNoticeCnt] withParam:param] success:^(NSDictionary* responseObject) {
            

            if([responseObject isKindOfClass:[NSDictionary class]]){
                
                NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
                NSLog(@"Response: %@",param);
                NSDictionary* dict = (NSDictionary*)[param objectAtIndex:0];
                if(dict != nil){
                    NSInteger result = [((NSNumber*)[dict objectForKey:@"count"]) intValue];
                    dict = (NSDictionary*)[dict objectForKey:@"message"];
                    self.noticeMessage = (NSString*)[dict objectForKey:@"message"];
                    if (result > self.noticeCnt) {
                        self.isNotice = YES;
   
                        if(!self.isBackground){
                            [self setNoticeCnt:result];
                            [self playSound];
                        } else {
                            [self showLocalNotification];
                        }
                        if(_tabBarController.selectedIndex == 3){
                            for (UIViewController *v in self.tabBarController.viewControllers)
                            {
                                UIViewController *vc = v;
                                
                                if ([v isKindOfClass:[UINavigationController class]]){
                                    vc = [[((UINavigationController*)v) viewControllers]objectAtIndex:0];
                                    if ([vc isKindOfClass:[BASNotiffController class]]){
                                        [((BASNotiffController*)vc) updateNotifyData];
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    

                    self.noticeCnt = result;
                }
            }
            if(_tabBarController.selectedIndex == 0){
                for (UIViewController *v in self.tabBarController.viewControllers)
                {
                    UIViewController *vc = v;
                    
                    if ([v isKindOfClass:[UINavigationController class]]){
                        vc = [[((UINavigationController*)v) viewControllers]objectAtIndex:0];
                        if ([vc isKindOfClass:[BASTablesController class]]){
                            [((BASTablesController*)vc) UpdateTablesView];
                            break;
                        }
                    }
                }
            }
        } failure:^(NSString *error) {
            
        }];
   
        [NSThread sleepForTimeInterval:CIRCLETIME];
    }
}

- (void)customizeNavBarAppearance
{
    
    
    [[UINavigationBar appearance] setBackgroundImage:[Settings image:ImageForNavBarBg] forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [Settings color:ColorForNavBarTitleShadow];
    shadow.shadowOffset = [Settings offset:OffsetForNavBarTitleShadow];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[Settings color:ColorForNavBarTitle],
                                                           NSShadowAttributeName:shadow,
                                                           }];
}

#pragma mark - App delegate methods

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.isBackground = YES;

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if(self.isBackground){
        for (UIViewController *v in self.tabBarController.viewControllers)
        {
            UIViewController *vc = v;
            
            if ([v isKindOfClass:[UINavigationController class]]){
                vc = [[((UINavigationController*)v) viewControllers]objectAtIndex:0];
                if ([vc isKindOfClass:[BASNotiffController class]]){
                    ((BASNotiffController*)vc).switchType = CURRENTSWITCH;
                    break;
                }
            }
        }
        [_tabBarController setSelectedIndex:3];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)applicatio
{
   
    self.isBackground = NO;
    
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
