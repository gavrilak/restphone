//
//  BASViewController.m
//  RestrauntSystem
//
//  Created by Sergey on 03.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASTablesController.h"
#import "RCSAuthViewController.h"
#import "BASRoomView.h"
#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "BASOrderViewController.h"
#import "BASMenuController.h"
#import "BASVirtualListController.h"

@interface BASTablesController (){
    
    NSInteger curIndex;
    
}
@property (nonatomic,strong) NSString* curTitle;
@property (nonatomic,strong) UIPageControl* pageControll;
@property (nonatomic,strong) TTScrollSlidingPagesController *slider;
@property (nonatomic,strong) NSArray* rooms;
@property (nonatomic,strong) NSArray* views;

@end

@implementation BASTablesController

- (void)setCurTitle:(NSString *)curTitle{
    _curTitle = curTitle;
    [self customTitle:_curTitle];
}
- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    curIndex = 0;
    [self setupBtnLogout];
    [self setupVirtualListBtn];
    
    [self getRooms];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TheApp;
    app.isOrder = NO;
    if(self.rooms != nil){
        NSDictionary* dict = (NSDictionary*)[_rooms objectAtIndex:curIndex];
        self.curTitle = (NSString*)[dict objectForKey:@"name_room"];
    }
    //[self getRooms];
    if(self.rooms != nil)
        [self getData:curIndex];

}
- (void)UpdateTablesView{
    [self getData:curIndex];
    //[self getRooms];
}
#pragma mark-
#pragma mark TTSlidingPagesDataSource methods

-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return _views.count;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    return [[TTSlidingPage alloc] initWithContentView:(UIView*)[_views objectAtIndex:index]];
}

-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    return nil;
}
-(void)didScrollToViewAtIndex:(NSUInteger)index{
    curIndex = index;
    _pageControll.currentPage = index;
    NSDictionary* dict = (NSDictionary*)[_rooms objectAtIndex:index];
    self.curTitle = (NSString*)[dict objectForKey:@"name_room"];
    
    [self getData:curIndex];
}

#pragma mark  - BASRoomViewDelegate methods
- (void)selectTable:(BASRoomView*)view withIndexRoom:(NSUInteger)indexRoom withIndexTable:(NSInteger)indexTable{
    
    TheApp;
    app.curCoastOrder = 0;
    app.orders = nil;
    NSLog(@"indexRoom: %d",indexRoom);
    NSLog(@"indexTable: %d",indexTable);
    
    UIViewController* controller = nil;
    
    NSDictionary* roomContent = (NSDictionary*)[_rooms objectAtIndex:indexRoom];
    NSArray* tablesContent = (NSArray*)[roomContent objectForKey:@"tables"];
    NSDictionary* table = (NSDictionary*)[tablesContent objectAtIndex:indexTable];
    app.id_table = ((NSNumber*)[table objectForKey:@"id_table"]).integerValue;

    TableState table_status = (TableState) [((NSNumber*)[table objectForKey:@"table_status"])integerValue];
    app.titleInfo = @{@"room":(NSString*)[roomContent objectForKey:@"name_room"],
                      @"table":[NSNumber numberWithInteger:indexTable +1]
                      };
    if(table_status == TableStateFree){
        BASMenuController* obj = [BASMenuController new];
        obj.isOrder = YES;
        app.isOrder = YES;
        app.id_order = -1;
        app.curCoastOrder = 0;
        app.orders = nil;
        app.addOrderList = nil;
        app.addCoastOrder = 0;
        app.curOrderList = nil;
        app.isWaiter = YES;
        controller = obj;
    } else {
        NSNumber* id_employee = nil;
        NSNumber* id_employee1 = nil;
        
        NSDictionary* dt = (NSDictionary*)[table objectForKey:@"employee"];
        if(dt != nil){
            app.isWaiter = YES;
            id_employee = (NSNumber*)[dt objectForKey:@"id_employee"];
            id_employee1 = (NSNumber*)[app.employeeInfo objectForKey:@"id_employee"];
            if([id_employee integerValue] != [id_employee1 integerValue])
                app.isWaiter = NO;
        }
        BASOrderViewController* obj = [BASOrderViewController new];
        obj.contentData = table;
        obj.isTitle = YES;
        obj.titleInfo = app.titleInfo;
        controller = obj;
        app.isOrder = YES;
        NSDictionary* order = (NSDictionary*)[table objectForKey:@"order"];
        app.id_order = [((NSNumber*)[order objectForKey:@"id_order"]) integerValue];
        app.curCoastOrder = ((NSNumber*)[order objectForKey:@"cost"]).integerValue;
        
        NSMutableArray* temp = [NSMutableArray new];
        NSArray* order_items =(NSArray*)[order objectForKey:@"order_items"];
        
        for(NSDictionary* obj in order_items){
            [temp addObject:obj];
        }
        app.curOrderList = [NSArray arrayWithArray:temp];
        
        app.orders = nil;
        app.addOrderList = nil;
        app.addCoastOrder = 0;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark  - Private methods
- (void)getRooms{
 
    BASManager* manager = [BASManager sharedInstance];
    
    [manager getData:[manager formatRequest:@"GETROOMS" withParam:nil] success:^(id responseObject) {
        

        if([responseObject isKindOfClass:[NSDictionary class]]){
                NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
                NSLog(@"Response: %@",param);
                if(param != nil){
                    NSMutableArray* data = [[NSMutableArray alloc]initWithCapacity:param.count];
                    for(NSDictionary* obj in param){
                        [data addObject:obj];
                    }
                    self.rooms = [NSArray arrayWithArray:data];
                    NSDictionary* dict = (NSDictionary*)[_rooms objectAtIndex:0];
                    self.curTitle = (NSString*)[dict objectForKey:@"name_room"];
                    
                    [self prepareViews];
                    
            }
         }
        
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];

}
- (void)getVirtualListData{
    BASManager* manager = [BASManager sharedInstance];
    TheApp;
    NSDictionary* param =@{@"id_employee":[app.employeeInfo  objectForKey:@"id_employee"]
                                           };
    
    [manager getData:[manager formatRequest:@"GETVIRTUALTABLE" withParam:param] success:^(id responseObject) {
        
        NSLog(@"Response: %@",responseObject);
        NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
        
        if(param != nil && param.count > 0){
            
            NSDictionary* dict = (NSDictionary*)[param objectAtIndex:0];
       
            BASVirtualListController* controller = [BASVirtualListController new];
            
            NSArray* contentData = (NSArray*)[dict objectForKey:@"virtualTableElements"];
            dict = @{@"order_items":contentData};
            dict = @{@"order":dict};
            TheApp;
            app.isOrder = NO;
            controller.contentData = dict;

            [self.navigationController pushViewController:controller animated:YES];
                
            
        }
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
    
}
- (void)getData:(NSInteger)index{
    
 
    BASManager* manager = [BASManager sharedInstance];
    
    NSDictionary* room = (NSDictionary*)[_rooms objectAtIndex:index];
    
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           (NSNumber*)[room objectForKey:@"id_room"] ,@"id_room",
                           nil];
    
    [manager getData:[manager formatRequest:@"GETTABLES" withParam:param] success:^(id responseObject) {
  
        if([responseObject isKindOfClass:[NSDictionary class]]){
  
            NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
            NSLog(@"Response: %@",param);

            if(param != nil){
               
                NSDictionary* data= (NSDictionary*)[param objectAtIndex:0];
                BASRoomView* view = (BASRoomView*)[_views objectAtIndex:curIndex];
                view.contentData = [NSDictionary dictionaryWithDictionary:data];
                
                NSMutableArray* tempData = [NSMutableArray new];
                [tempData addObjectsFromArray:self.rooms];
                [tempData replaceObjectAtIndex:curIndex withObject:data];
                self.rooms = [NSArray arrayWithArray:tempData];
                
               
            }
 
        }
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
}
- (void)clearView{
    if(self.views != nil){
        for(BASRoomView* obj in _views){
            [obj removeFromSuperview];
            
        }
    }
    self.views = nil;
    [self.slider.view removeFromSuperview];
    self.slider = nil;
    [self.pageControll removeFromSuperview];
    self.pageControll = nil;
    
}
- (void)prepareViews{

    [self clearView];
    
   
        RoomType type = FIRSTROOM;
        NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:_rooms.count];
       
        for (int i = 0; i < _rooms.count; i++) {
            NSDictionary* obj = (NSDictionary*)[_rooms objectAtIndex:i];
            //NSNumber* st = (NSNumber*)[obj objectForKey:@"availability"];
            NSNumber* id_room = (NSNumber*)[obj objectForKey:@"id_room"];
           // BOOL state = (BOOL)st.integerValue;
            //if(state){
                switch (id_room.integerValue) {
                    case 1:
                        type = FIRSTROOM;
                        break;
                    case 2:
                        type = SECONDROOM;
                        break;
                    case 3:
                        type = THIRDROOM;
                        break;
                    case 4:
                        type = FOURTHROOM;
                        break;
                        
                    default:
                        break;
                }
                BASRoomView* view = [[BASRoomView alloc]initWithFrame:self.viewFrame withContent:(NSDictionary*)[_rooms objectAtIndex:i] withIndex:i withType:type];
                [view createRoom];
                view.delegate = (id)self;
                [temp addObject:view];
            }
       // }
        self.views = [NSArray arrayWithArray:temp];
        
    

    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerInActiveTextColour = [UIColor grayColor];
    self.slider.titleScrollerBottomEdgeColour = [UIColor darkGrayColor];
    self.slider.titleScrollerBottomEdgeHeight = 2;
    self.slider.dataSource = (id)self;
    self.slider.delegate = (id)self;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
    
    self.pageControll = [[UIPageControl alloc] init];
    _pageControll.backgroundColor=[UIColor clearColor];
    _pageControll.currentPage = curIndex;
    _pageControll.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControll.pageIndicatorTintColor = [UIColor grayColor];
    _pageControll.numberOfPages = _views.count;
    [self.view addSubview:_pageControll];
   
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = -70;
    frame.size.height += 15;
    [self.slider.view setFrame:frame];
    _pageControll.frame = CGRectMake(0,self.view.frame.size.height - 100.0, self.view.frame.size.width,40.0);

}
- (void)setupBgImg{
    UIView *bgImg = [[UIView alloc] init];
    [bgImg setBackgroundColor:[UIColor grayColor]];
    CGFloat bgImgTop = 0;
    bgImg.frame = CGRectMake(bgImg.frame.origin.x,
                             bgImgTop,
                             [Settings screenWidth],
                             [Settings screenHeight] - [Settings image:ImageForNavBarBg].size.height - [Settings image:ImageForTabBarBg].size.height);
    self.viewFrame = bgImg.frame;
    [self.view addSubview:bgImg];
}
- (void)setupBtnLogout
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [Settings image:ImageForHallsBtnLogout];
    btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
    [btn setImage:btnImg forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnLogoutPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barBtnItem;
}
- (void)btnLogoutPressed{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Сообщение" message:@"Вы уверены что хотите завершить работу?" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:@"Отмена", nil];
    
    [alertView show];
}
- (void)btnVirtualListPressed{
    
    [self getVirtualListData];
}
- (void)setTime{
    TheApp;
    
    BASManager* manager = [BASManager sharedInstance];
    
    NSString* command = @"SETLEAVINGEMPLOYEE";

    
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                          (NSNumber*)[app.employeeInfo objectForKey:@"id_employee"] ,@"id_employee",
                          nil];
    
    
    [manager getData:[manager formatRequest:command withParam:param] success:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
            NSLog(@"Response: %@",param);
            
        
        }
        
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.cancelButtonIndex == buttonIndex){
        
        [self setTime];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[Settings text:TextForAuthLoginKey]];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[Settings text:TextForAuthPassKey]];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[Settings text:TextForAuthRoleKey]];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"employeeInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        TheApp;
        app.window.rootViewController = (RCSAuthViewController*) app.authController;
    }
}
@end
