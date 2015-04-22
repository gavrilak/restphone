//
//  BASTabbarViewController.m
//  RestrauntSystem
//
//  Created by Sergey on 03.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASTabbarViewController.h"
#import "CustomBadge.h"


@interface BASTabbarViewController ()


@property (nonatomic, strong)CustomBadge *customBadge;
@end

@implementation BASTabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        if(ISIOS7)
            self.tabBar.translucent = YES;
        
        [self setupTabBarAppearance];
        self.delegate = self;
        
        //[self targetMethod];
       /* [NSTimer scheduledTimerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(targetMethod)
                                       userInfo:nil
                                        repeats:NO];*/

       
    }
    return self;
}
- (void) targetMethod{

    BASManager* manager = [BASManager sharedInstance];
    typedef void(^Success)(UserType userType);
    typedef void(^Failure)(NSString *error);
    Success success = nil;
    Failure failure = nil;
    
    success = ^(UserType userType){
        
    };
    
    
    failure = ^(NSString *error){
        [manager showAlertViewWithMess:error];
    };

    NSMutableArray* tempMod = [NSMutableArray new];
    NSMutableArray* tempDish = [NSMutableArray new];
    
    NSDictionary* mod = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt:1],@"id_modificator",
                           nil];
    [tempMod addObject:mod];
    [tempMod addObject:mod];
    
    NSDictionary* dish = [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithInt:2],@"id_dish",
           [NSNumber numberWithInt:5],@"count_dish",
                          tempMod,@"mod",
           nil];
    
    [tempDish addObject:dish];
    [tempDish addObject:dish];
    [tempDish addObject:dish];
    [tempDish addObject:dish];
    
   
    
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt:1],@"id_employee",
                           [NSNumber numberWithInt:1],@"id_table",
                           [NSNumber numberWithInt:-1],@"id_order",
                           tempDish,@"order_items",
                           nil];
    
    NSDictionary* dict = @{
                           @"id_category": [NSNumber numberWithInt:1],
                           };
    
    [manager getData:[manager formatRequest:[Settings text:TextForApiFuncMenuCats] withParam:dict] success:^(NSDictionary* responseObject) {
        
        id param = (id)[responseObject objectForKey:@"param"];
        
        NSLog(@"Response order: %@",param);
        
        
    } failure:^(NSString *error) {
        failure(error);
    }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#pragma mark - Public methods
- (void)clearNoticesCount{
    TheApp;
    app.isNotice = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nil];
        [[self.view viewWithTag:111] removeFromSuperview];

        //[[self.tabBar.items objectAtIndex:TabBarItemNotices] setBadgeValue:nil];
    });
}
- (void)showNoticesCount:(NSUInteger)noticesCnt
{
    [self.customBadge removeFromSuperview];
    self.customBadge = nil;
    self.customBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d",noticesCnt]
                                          withStringColor:[UIColor whiteColor]
                                           withInsetColor:[UIColor redColor]
                                           withBadgeFrame:YES
                                      withBadgeFrameColor:[UIColor whiteColor]
                                                withScale:1.0
                                              withShining:YES];
    _customBadge.tag = 111;
    CGRect frame = self.tabBar.frame;
    [_customBadge setFrame:CGRectMake(frame.size.width -_customBadge.frame.size.width - 5.f, frame.origin.y - _customBadge.frame.size.height / 2 - 3.f, _customBadge.frame.size.width, _customBadge.frame.size.height)];
    [self.view addSubview:_customBadge];
    //dispatch_async(dispatch_get_main_queue(), ^{
        //[[self.tabBar.items objectAtIndex:TabBarItemNotices] setBadgeValue:[NSString stringWithFormat:@"%lu", (unsigned long)noticesCnt]];
   // });
   
}
#pragma mark - Private methods

- (void)setupTabBarAppearance
{
    [[UITabBar appearance] setBackgroundImage:[Settings image:ImageForTabBarBg]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [Settings color:ColorForTabBarItemTitle]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:142.0/255.0 green:215.0/255.0 blue:249.0/255.0 alpha:1.0]} forState:UIControlStateSelected];
   
    self.tablesController = [[BASTablesController alloc]init];
    UINavigationController* tbNav = [[UINavigationController alloc]initWithRootViewController:_tablesController];
    
    self.menuController = [[BASMenuController alloc]init];
    _menuController.isOrder = NO;
    UINavigationController* mnNav = [[UINavigationController alloc]initWithRootViewController:_menuController];
    
    self.ordersController = [[BASOrdersController alloc]init];
    UINavigationController* ordNav = [[UINavigationController alloc]initWithRootViewController:_ordersController];
    
    self.notificationsController = [[BASNotiffController alloc]init];
    UINavigationController* ntNav = [[UINavigationController alloc]initWithRootViewController:_notificationsController];
    
    
    
    self.viewControllers = [NSArray arrayWithObjects:
                            tbNav,
                            mnNav,
                            ordNav,
                            ntNav,
                            nil];
    
    
    
    NSArray* tabs = self.viewControllers;
    
    
    UIViewController *tab1 = [tabs objectAtIndex:0];
    UIViewController *tab2 = [tabs objectAtIndex:1];
    UIViewController *tab3 = [tabs objectAtIndex:2];
    UIViewController *tab4 = [tabs objectAtIndex:3];
    
    [tab1 setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [tab1.tabBarItem setTitle:[Settings text:TextForTabBarItemTables]];
    [tab1.tabBarItem setImage:[[Settings image:ImageForTabBarItemTables] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab1.tabBarItem setSelectedImage:[[Settings image:ImageForTabBarItemTables] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //[tab1.tabBarItem setImageInsets:UIEdgeInsetsMake(-5,0,5,0)];
    
    
    [tab2 setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [tab2.tabBarItem setTitle:[Settings text:TextForTabBarItemMenu]];
    [tab2.tabBarItem setImage:[[Settings image:ImageForTabBarItemMenu] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab2.tabBarItem setSelectedImage:[[Settings image:ImageForTabBarItemMenu] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab2.tabBarItem setImageInsets:UIEdgeInsetsMake(-2,0,2,0)];
    
    [tab3 setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [tab3.tabBarItem setTitle:[Settings text:TextForTabBarItemOrders]];
    [tab3.tabBarItem setImage:[[Settings image:ImageForTabBarItemOrders] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab3.tabBarItem setSelectedImage:[[Settings image:ImageForTabBarItemOrders] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab3.tabBarItem setImageInsets:UIEdgeInsetsMake(-2,0,2,0)];
    
    [tab4 setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [tab4.tabBarItem setTitle:[Settings text:TextForTabBarItemNotices]];
    [tab4.tabBarItem setImage:[[Settings image:ImageForTabBarItemNotices] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab4.tabBarItem setSelectedImage:[[Settings image:ImageForTabBarItemNotices] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab4.tabBarItem setImageInsets:UIEdgeInsetsMake(-2,0,2,0)];
  
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    TheApp;
    if ( app.isModify == YES) {
        return NO;
    } else {
        NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
        app.isOrder = YES;
        if(index == 1){
            app.isOrder = NO;
            /*for (UINavigationController* obj in tabBarController.viewControllers) {
             UIViewController* controller = [[obj viewControllers]objectAtIndex:0];
             if([controller isKindOfClass:[BASMenuController class]]){
                    ((BASMenuController*)controller).isOrder = NO;
             }
             }*/
        
        }
    return YES;
    }
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

}
@end
