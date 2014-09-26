//
//  BASMenuController.m
//  RestrauntSystem
//
//  Created by Sergey on 04.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASMenuController.h"
#import "BASCustomTableView.h"
#import "BASCategoryViewController.h"
#import "BASStopListController.h"
#import "BASOrderViewController.h"

@interface BASMenuController ()

@property (nonatomic,strong) NSArray* contentData;
@property (nonatomic,strong) BASCustomTableView* tableView;

@end

@implementation BASMenuController

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
   
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TheApp;
    if(app.isOrder)
        [self setupBackBtn];
    [self setupStopListBtn];
    [self customTitle:[Settings text:TextForTabBarItemMenu]];
    [self getData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self customTitle:@""];
    
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Private methods
- (void)prepareView{
    
        [_tableView removeFromSuperview];
        _tableView = nil;
        self.tableView = [[BASCustomTableView alloc]initWithFrame:self.viewFrame style:UITableViewStylePlain withContent:_contentData withType:CATEGORYTABLE withDelegate:nil];
        _tableView.delegate = (id)self;
        [_tableView setContentOffset:CGPointMake(0, 0)];
        [self.view addSubview:_tableView];
    
}
- (void)getData{
    
 
    BASManager* manager = [BASManager sharedInstance];

    [manager getData:[manager formatRequest:[Settings text:TextForApiFuncMenuItemFormat] withParam:nil] success:^(id responseObject) {
  
        if([responseObject isKindOfClass:[NSDictionary class]]){
    
            NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
             NSLog(@"Response: %@",param);
            if(param != nil){
                
                
                NSMutableArray* data = [[NSMutableArray alloc]initWithCapacity:param.count];
                
                for (NSDictionary* obj in param) {
                 
                    NSString* catName = (NSString*)[obj objectForKey:@"name_category"];
   
                    NSDictionary* dict = @{
                                           [Settings text:TextForApiKeyId]: (NSNumber*)[obj objectForKey:@"id_category"],
                                           [Settings text:TextForApiKeyTableState]: (NSNumber*)[obj objectForKey:@"load"],
                                           [Settings text:TextForApiKeyImage]: [Settings menuCatImgForId:catName],
                                           [Settings text:TextForApiKeyTitle]: [Settings menuCatTitleForId:catName],
                                           @"modificators":(NSArray*)[obj objectForKey:@"modificators"],
                                           };
                    
                    [data addObject:dict];
                    
                }
                self.contentData = [NSArray arrayWithArray:data];
                
                [self prepareView];
            }
  
        }
        
        
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
}
#pragma mark -
#pragma mark Table delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableView hightCell:_tableView.typeTable];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BASCategoryViewController* controller = [[BASCategoryViewController alloc]init];
    controller.contentData = (NSDictionary*)[_contentData objectAtIndex:[indexPath row]];
    controller.isOrder = _isOrder;
    
   
    [self.navigationController pushViewController:controller animated:YES];
    
}
#pragma mark - Action methods
- (void)btnStopListPressed{
    BASStopListController* controller = [BASStopListController new];
    
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)btnBackPressed
{
    BOOL key = NO;
    TheApp;
    NSArray* controllers = self.navigationController.viewControllers;
    for(UIViewController* obj in controllers){
        if([obj isKindOfClass:[BASOrderViewController class]]){
            key = YES;
        }
    }
    if(app.orders != nil && !key){
        BASOrderViewController* controller = [BASOrderViewController new];
        controller.isTitle = YES;
        controller.titleInfo = app.titleInfo;
        app.isOrder = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else
        [self.navigationController popViewControllerAnimated:YES];
}
@end
