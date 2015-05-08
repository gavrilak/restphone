//
//  BASStopListController.m
//  RestrauntSystem
//
//  Created by Sergey on 20.08.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASStopListController.h"


@interface BASStopListController ()

@property (nonatomic,strong) NSArray* notAvaibleData;
@property (nonatomic,strong) NSArray* criticalCountData;
@property (nonatomic,strong) UITableView* tableView;

@end

@implementation BASStopListController

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
    [self setupBackBtn];
    [self customTitle:@"Стоп - лист"];
    [self prepareView];
    [self getData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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
    self.tableView = [[UITableView alloc]initWithFrame:self.viewFrame style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.userInteractionEnabled = YES;
    _tableView.bounces = YES;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.delegate = (id)self;
    _tableView.dataSource = (id)self;

    [self.view addSubview:_tableView];
    
}
- (void)getData{
    
    
    BASManager* manager = [BASManager sharedInstance];
    
    [manager getData:[manager formatRequest:@"GETSTOPLIST" withParam:nil] success:^(id responseObject) {
    
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
            NSLog(@"Response: %@",param);
            if(param != nil){
                self.notAvaibleData = [ NSArray arrayWithArray:[[param objectAtIndex:0] objectForKey:@"not_available"]];
                self.criticalCountData = [ NSArray arrayWithArray:[[param objectAtIndex:0] objectForKey:@"critical_count"]];
                [_tableView reloadData];
            }
 
        }
        
        
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
}
#pragma mark -
#pragma mark Table view methods

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch ( section) {
        case 0:
            return @"Критичечкий остаток";
        case 1:
            return @"Недоступные блюда";
    }
    
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberSections = 2;
  /*  if ([_criticalCountData count] > 0 ) {
        numberSections++;
    }
    if ([_notAvaibleData count] > 0 ) {
        numberSections++;
    }*/
    return numberSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch ( section) {
        case 0:
            return [_criticalCountData  count];
        case 1:
            return [_notAvaibleData  count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"stopListCell";

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSArray* dishes ;
    switch (indexPath.section) {
        case 0:
            dishes = _criticalCountData;
            break;
        case 1:
            dishes = _notAvaibleData;
            break;
    }

    NSDictionary* dishe = (NSDictionary*)[dishes objectAtIndex:[indexPath row]];
    [cell.textLabel setText:(NSString*)[dishe objectForKey:@"name_dish"]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ - %@ %@",[dishe objectForKey:@"weight"], [dishe objectForKey:@"unit_weight"],[dishe objectForKey:@"price"] , [dishe objectForKey:@"unit_price"] ]];
    [cell.contentView setBackgroundColor:[UIColor lightGrayColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}
#pragma mark -
#pragma mark Table delegate methods


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}



-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.f;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
}


@end
