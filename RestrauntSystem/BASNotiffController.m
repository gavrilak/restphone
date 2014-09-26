//
//  BASNotiffController.m
//  RestrauntSystem
//
//  Created by Sergey on 04.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASNotiffController.h"
#import "BASTabbarViewController.h"
#import "BASNoticeTableViewCell.h"
#import "BASCustomTableView.h"
#import "BASSwitchView.h"

@interface BASNotiffController ()

@property (nonatomic,strong) NSArray *contentData;
@property (nonatomic,strong) NSArray *currentData;
@property (nonatomic,strong) BASCustomTableView* tableView;
@property (nonatomic,strong) BASSwitchView* switchView;

@end

@implementation BASNotiffController

- (id)init
{
    self = [super init];
    if (self) {
        NSMutableArray *temp = [NSMutableArray new];
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"А ну быстро работать",@"title",
                              [NSNumber numberWithInt:NoticeStateUnfulfilled],@"state",
                              [NSNumber numberWithInt:NoticeTypeAdmin],@"type",
                              nil];
        
        [temp addObject:dict];
        
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                @"Это просто пипец",@"title",
                [NSNumber numberWithInt:NoticeStateUnfulfilled],@"state",
                [NSNumber numberWithInt:NoticeTypeKitchen],@"type",
                nil];
        
        [temp addObject:dict];
        
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                @"Бухают сегодня круто",@"title",
                [NSNumber numberWithInt:NoticeStateUnfulfilled],@"state",
                [NSNumber numberWithInt:NoticeTypeBar],@"type",
                nil];
        
        [temp addObject:dict];
        
        
        self.contentData = [NSArray arrayWithArray:temp];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.switchType = CURRENTSWITCH;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self customTitle:[Settings text:TextForTabBarItemNotices]];

    
    [self getData];

}
-(void)viewWillDisappear:(BOOL)animated{
    [self customTitle:@""];
  
    [super viewWillDisappear:animated];
}
- (void)updateNotifyData{
    TheApp;
    
    BASManager* manager = [BASManager sharedInstance];
    
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [app.employeeInfo objectForKey:@"id_employee"] ,@"id_employee",
                           nil];
    
    
    [manager getData:[manager formatRequest:[Settings text:TextForApiFuncGetNotifies] withParam:param] success:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            
            NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
            NSLog(@"Response: %@",param);
            
            if(param != nil){
                self.currentData = [app sortContent:param withType:CURRENTSWITCH];
                self.contentData = [app sortContent:param withType:ALLSWITCH];
                if(_currentData.count > 0){
                    self.switchType = CURRENTSWITCH;
                    [self prepareView];
                }
            }
            
            
        }
        
        
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];

}
#pragma mark - Private methods
- (void)prepareClicked:(NSDictionary*)obj{
  
    BASManager* manager = [BASManager sharedInstance];
    NSDictionary* dict = @{
                           @"id_order": (NSNumber*)[obj objectForKey:@"id_order"],
                           @"id_dish_order": (NSNumber*)[obj objectForKey:@"id_dish_order"],
                           };
    
    [manager getData:[manager formatRequest:@"SETDISHDELIVERED" withParam:dict] success:^(NSDictionary* responseObject) {
        
        
        NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
        NSLog(@"Response: %@",param);
   
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
}

- (void)getData{
    
    TheApp;
    
    BASManager* manager = [BASManager sharedInstance];
  
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                          [app.employeeInfo objectForKey:@"id_employee"] ,@"id_employee",
                           nil];
    
    
    [manager getData:[manager formatRequest:[Settings text:TextForApiFuncGetNotifies] withParam:param] success:^(id responseObject) {

        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            
            NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
            NSLog(@"Response: %@",param);
            
            if(param != nil){
                self.currentData = [app sortContent:param withType:CURRENTSWITCH];
                self.contentData = [app sortContent:param withType:ALLSWITCH];
               
                [self prepareView];
            }
            
            
        }
        
        
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
}
- (void)setReadNotify:(NSDictionary*)obj{
    
    TheApp;
    
    BASManager* manager = [BASManager sharedInstance];
    NSNumber* id_notify = (NSNumber*)[obj objectForKey:@"id_message"];
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [app.employeeInfo objectForKey:@"id_employee"] ,@"id_employee",
                           id_notify ,@"id_message",
                           nil];
    
    
    [manager getData:[manager formatRequest:@"SETREADNOTIFY" withParam:param] success:^(id responseObject) {
   
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            
            NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
            NSLog(@"Response: %@",param);
            
            if(param != nil){
                self.currentData = [app sortContent:param withType:CURRENTSWITCH];
                self.contentData = [app sortContent:param withType:ALLSWITCH];
                [self prepareView];
                 NSNumber* message_type = (NSNumber*)[obj objectForKey:@"message_type"];
                if([message_type integerValue] == 1){
                    [self prepareClicked:(NSDictionary*)[obj objectForKey:@"order"]];
                }
                
            }
            
            
        }
        
        
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
}

- (void)prepareView{
    
        
        [self.switchView removeFromSuperview];
        self.switchView = nil;
        
        self.switchView = [[BASSwitchView alloc]initWithFrame:self.viewFrame withType:_switchType withViewType:YES];
        _switchView.delegate = (id<BASSwitchViewDelegate>)self;
        [self.view addSubview:_switchView];
        
        [self createTableView:_switchType];
  
}

- (void)createTableView:(SwitchType)type{
    
    self.switchType = type;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    
    NSArray* data = _currentData;
    if(type == ALLSWITCH)
        data = _contentData;
    
    CGRect frame = _switchView.frame;
    frame.origin.y += 40.f;
    frame.size.height -= 60.f;
    
    self.tableView = [[BASCustomTableView alloc]initWithFrame:frame style:UITableViewStylePlain withContent:data withType:NOTICETABLE withDelegate:nil];
    _tableView.delegate = (id)self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:_tableView];

}

#pragma mark - Table delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat hight = [_tableView hightCell:_tableView.typeTable];

    return hight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TheApp;
    
    BASNoticeTableViewCell* cell = (BASNoticeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if(app.noticeCnt > 0 && cell.noticeState == NoticeStateUnfulfilled){
       
        app.noticeCnt--;

        NSDictionary* obj = (NSDictionary*)[_currentData objectAtIndex:[indexPath row]];
        [self setReadNotify:obj];

    }
    
}
#pragma mark - BASSwitchView delegate methods
- (void)swithClicked:(BASSwitchView*)view withType:(SwitchType)type{
    self.switchType = type;
    [self getData];
}
@end
