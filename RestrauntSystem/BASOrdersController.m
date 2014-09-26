//
//  BASOrdersController.m
//  RestrauntSystem
//
//  Created by Sergey on 04.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASOrdersController.h"
#import "BASSwitchView.h"
#import "BASCustomTableView.h"
#import "BASOrderViewController.h"

@interface BASOrdersController ()

@property (nonatomic,strong) NSArray *contentData;
@property (nonatomic,strong) NSArray *currentData;
@property (nonatomic,strong) BASCustomTableView* tableView;
@property (nonatomic,strong) BASSwitchView* switchView;
@property (nonatomic,assign) SwitchType switchType;

@end

@implementation BASOrdersController

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
    [self prepareView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self customTitle:[Settings text:TextForTabBarItemOrders]];

    [self getData];

}
-(void)viewWillDisappear:(BOOL)animated{
   
    [self customTitle:@""];
    
    [super viewWillDisappear:animated];
}
#pragma mark - Private methods
- (void)getData{
    
    TheApp;
    
    BASManager* manager = [BASManager sharedInstance];
    
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [app.employeeInfo objectForKey:@"id_employee"] ,@"id_employee",
                           nil];
    
    [manager getData:[manager formatRequest:@"GETORDERS" withParam:param] success:^(id responseObject) {
        
        NSLog(@"Response: %@",responseObject);
        NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
        
        if(param != nil){
            self.contentData = [NSArray arrayWithArray:param];
            self.currentData = [NSArray arrayWithArray:[self sortContent:param]];
            [self prepareView];
        }
        
        
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
}
- (void)prepareView{
    
        [self.switchView removeFromSuperview];
        self.switchView = nil;
        self.switchView = [[BASSwitchView alloc]initWithFrame:self.viewFrame withType:_switchType withViewType:NO];
        _switchView.delegate = (id<BASSwitchViewDelegate>)self;
        [self.view addSubview:_switchView];
  
        [self createTableView:_switchType];
}

- (void)createTableView:(SwitchType)type{
    
    self.switchType = type;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    
    NSArray* data = [NSArray arrayWithArray:_currentData];
    if(type == ALLSWITCH)
        data = [NSArray arrayWithArray:_contentData];
    
    UIImage* image = [UIImage imageNamed:@"bg_inactive.png"];
    CGRect frame = CGRectMake(_switchView.frame.origin.x + _switchView.frame.size.width / 2 - image.size.width / 2 + 4.f, 40.f, image.size.width - 8.f, _switchView.frame.size.height - 60.f);
    
    self.tableView = [[BASCustomTableView alloc]initWithFrame:frame style:UITableViewStylePlain withContent:data withType:ORDERSLIST withDelegate:nil];

    _tableView.delegate = (id)self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 10.f)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableHeaderView:headerView];
    [_tableView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:_tableView];
    
}
#pragma mark - BASSwitchView delegate methods
- (void)swithClicked:(BASSwitchView*)view withType:(SwitchType)type{
    [self createTableView:type];
}
#pragma mark -
#pragma mark Table delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableView hightCell:_tableView.typeTable];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TheApp;
    BASOrderViewController* obj = [BASOrderViewController new];
    obj.contentData = [_contentData objectAtIndex:[indexPath row]];
    if(_switchType == CURRENTSWITCH){
        obj.contentData = [_currentData objectAtIndex:[indexPath row]];
    }

     NSDictionary * titleInfo = @{@"room":(NSString*)[obj.contentData objectForKey:@"name_room"],
                      @"table":(NSNumber*)[obj.contentData objectForKey:@"number_table"]
                      };
    obj.titleInfo = titleInfo;
    obj.isTitle = NO;
    app.isOrder = YES;
    NSDictionary* order = (NSDictionary*)[obj.contentData objectForKey:@"order"];
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
    
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (NSArray*)sortContent:(NSArray*)source{
    
    NSMutableArray* data = [NSMutableArray new];
    NSInteger index = 2;
    
    for(NSDictionary* obj in source){
        NSDictionary* dict = (NSDictionary*)[obj objectForKey:@"order"];
        NSNumber* status = (NSNumber*)[dict objectForKey:@"status"];
        if([status intValue] != index){
            [data addObject:obj];
        }
    }
    
    
    return  [NSArray arrayWithArray:data];
}
@end
