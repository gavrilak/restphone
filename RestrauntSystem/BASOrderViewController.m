//
//  BASOrderViewController.m
//  RestrauntSystem
//
//  Created by Sergey on 10.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASOrderViewController.h"
#import "BASDishViewController.h"
#import "BASMenuController.h"
#import "BASСalculateViewController.h"
#import "BASModifyView.h"
#import "BASSubCategoryTableViewCell.h"

@interface BASOrderViewController (){
    NSUInteger dishIdx;
}

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSArray* dishesContent;
@property (nonatomic,strong) UIButton* btAdd;
@property (nonatomic,strong) UIButton* btOrder;
@property (nonatomic,strong) UIButton* btCalc;
@property (nonatomic,strong) BASModifyView* modifyView;

@end

@implementation BASOrderViewController


- (id)init
{
    self = [super init];
    if (self) {
      
    }
    return self;
}

- (void)viewDidLoad
{
    TheApp;
    [super viewDidLoad];
    [self setupBackBtn];
    if (app.addOrderList == nil) {
        app.orders = [app loadPreOrderObjects];
        app.addOrderList = [NSArray arrayWithArray:app.orders];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSString* room = (NSString*)[_titleInfo objectForKey:@"room"];
    NSNumber* tableNum = (NSNumber*)[_titleInfo objectForKey:@"table"];
    NSString* title = [NSString stringWithFormat:@"%@ - Стол %ld",room,[tableNum integerValue]];
    [self customTitle:title];
    
    [self prepareView];
    

    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self customTitle:@""];
    [super viewWillDisappear:animated];
}
#pragma mark - Private methods
- (void)prepareView{
 
    TheApp;
        
    
    [self setupLblAmountWithBtnOrder:NO];
    [self.tableView removeFromSuperview];
    self.tableView = nil;
   

    [self setSumWhenTableId:app.curCoastOrder];


    self.tableView = [[UITableView alloc]initWithFrame:self.viewFrame style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.userInteractionEnabled = YES;
    _tableView.bounces = YES;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.delegate = (id)self;
    _tableView.dataSource = (id)self;
    
    NSNumber* status = (NSNumber*)[_contentData objectForKey:@"table_status"];
    if(_isTitle){
        if(([status integerValue] < 2 && app.isWaiter)){
            
            [_tableView setTableFooterView:[self footerView]];
            if(self.btOrder != nil){
                 [_btOrder setEnabled:NO];
                if(app.addOrderList != nil && app.addOrderList.count > 0){
                    [_btOrder setEnabled:YES];
                }
            }
        }
    }
    [self.view addSubview:_tableView];
    [_tableView reloadData];
 

}
- (UIView*)footerView{
    UIView* view= [[UIView alloc]initWithFrame:CGRectMake(0, 0,320.f, 80.f)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    self.btAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btAdd setBackgroundColor:[UIColor clearColor]];
    [_btAdd setBackgroundImage:[UIImage imageNamed:@"button_add"] forState:UIControlStateNormal];
    [_btAdd setFrame:CGRectMake(5.f, view.frame.size.height / 2 - 51.f / 2,100.f, 51.f)];
    [_btAdd addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btAdd];
    
    self.btOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btOrder setBackgroundColor:[UIColor clearColor]];
    [_btOrder setBackgroundImage:[UIImage imageNamed:@"button_zakaz"] forState:UIControlStateNormal];
    [_btOrder setFrame:CGRectMake(110.f, view.frame.size.height / 2 - 51.f / 2,100.f, 51.f)];
    [_btOrder addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btOrder];
    
    self.btCalc = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btCalc setBackgroundColor:[UIColor clearColor]];
    [_btCalc setBackgroundImage:[UIImage imageNamed:@"button_calc"] forState:UIControlStateNormal];
    [_btCalc addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btCalc setFrame:CGRectMake(215.f, view.frame.size.height / 2 - 51.f / 2,100.f, 51.f)];
    [view addSubview:_btCalc];
    
    
    return view;
}

- (void)buttonClicked:(id)sender{
    TheApp;
    if (!app.isModify){
        UIButton* button = (UIButton*)sender;
        UIViewController* controller = nil;
  
        if(button == _btAdd){
            BASMenuController* obj = [BASMenuController new];
            obj.isOrder = YES;
            app.isOrder = YES;
            controller = obj;
        } else if(button == _btOrder){
            [self makeOrder];
            return;
        } else if(button == _btCalc){
            NSDictionary* order = (NSDictionary*)[_contentData objectForKey:@"order"];
            BASCalculateViewController* obj = [BASCalculateViewController new];
            obj.price = [NSString stringWithFormat:@"%d",app.curCoastOrder];
            obj.id_order = (NSNumber*)[order objectForKey:@"id_order"];;
            controller = obj;
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        [[BASManager sharedInstance]showAlertViewWithMess:@"Подтвердите выбор модификаторов!"];
    }
}
- (void)btnBackPressed
{
    TheApp;
    if (app.addOrderList != nil && [app.addOrderList count]>0) {
        NSDictionary *dict =[ NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:app.id_table],@"id_table",
            [NSNumber numberWithInteger:app.id_order],@"id_order",
            app.addOrderList ,@"order_items",
            nil];
        [app.preOrderObjects addObject:dict];
    } else {
        [app deletePreOrderObjects];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)makeOrder{
    TheApp;
    BASManager* manager = [BASManager sharedInstance];
    NSNumber* id_employee = (NSNumber*)[app.employeeInfo objectForKey:@"id_employee"];
    
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          id_employee,@"id_employee",
                          [NSNumber numberWithInteger:app.id_table],@"id_table",
                          [NSNumber numberWithInteger:app.id_order],@"id_order",
                          app.orders,@"order_items",
                          nil];
    
    [manager getData:[manager formatRequest:@"MAKEORDER" withParam:dict] success:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
            NSLog(@"Response: %@",param);
            
            if(param != nil){
            
                NSDictionary* dict = (NSDictionary*)[param objectAtIndex:0];
                NSDictionary* order = (NSDictionary*)[dict objectForKey:@"order"];
                
                app.id_order = ((NSNumber*)[order objectForKey:@"id_order"]).integerValue;
           
                NSMutableArray* temp = [NSMutableArray new];
                NSArray* order_items =(NSArray*)[order objectForKey:@"order_items"];
                
                for(NSDictionary* obj in order_items){
                    [temp addObject:obj];
                }
                app.curOrderList = [NSArray arrayWithArray:temp];
                
                app.orders = nil;
                app.addOrderList = nil;
                app.addCoastOrder = 0;
                if(self.btOrder != nil)
                    [_btOrder setEnabled:NO];
                [_tableView reloadData];
                

            }
        }
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];

}
#pragma mark -
#pragma mark Table view methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    TheApp;
    if (!app.isModify){
        if(app.curOrderList != nil && app.curOrderList.count > 0 && app.addOrderList != nil && app.addOrderList.count > 0 ){
            if([indexPath section] == 0)
                return NO;
            else
                return YES;
        } else{
            if(app.curOrderList != nil && app.curOrderList.count > 0)
                return NO;
            else if(app.addOrderList != nil && app.addOrderList.count > 0)
                return YES;
            }
        return YES;
    }
    else{
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TheApp;
    
    if(app.addOrderList != nil && app.addOrderList.count > 0){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSMutableArray* temp = [[NSMutableArray alloc]initWithArray:app.orders];
            [temp removeObjectAtIndex:[indexPath row]];
            app.orders = [NSArray arrayWithArray:temp];
            app.addOrderList = [NSArray arrayWithArray:app.orders];
            if(self.btOrder != nil){
                 [_btOrder setEnabled:NO];
                if(app.addOrderList != nil && app.addOrderList.count > 0){
                    [_btOrder setEnabled:YES];
                }
            }
            app.curCoastOrder -= app.addCoastOrder;
            [self setSumWhenTableId:app.curCoastOrder];
        }
    }
    [_tableView setEditing:NO animated:YES];
    [_tableView reloadData];
    
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    TheApp;
    if(app.curOrderList != nil && app.curOrderList.count > 0 && app.addOrderList != nil && app.addOrderList.count > 0){
        if(section == 0)
            return @"Текущие";
        else
            return @"Добавленные";
    } else{
        if(app.curOrderList != nil && app.curOrderList.count > 0)
            return @"Текущие";
        else if(app.addOrderList != nil && app.addOrderList.count > 0)
            return @"Добавленные";
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    TheApp;
    if(app.curOrderList != nil && app.curOrderList.count > 0 && app.addOrderList != nil && app.addOrderList.count > 0){
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TheApp;
    if(app.curOrderList != nil && app.curOrderList.count > 0 && app.addOrderList != nil && app.addOrderList.count > 0){
        if(section == 0)
            return app.curOrderList.count;
        else
            return app.addOrderList.count;
    } else {
        if(app.curOrderList != nil && app.curOrderList.count > 0)
            return app.curOrderList.count;
        else if(app.addOrderList != nil && app.addOrderList.count > 0)
            return app.addOrderList.count;

    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TheApp;
    static NSString *CellIdentifier = @"curOrderCell";
    NSDictionary* dict = nil;
    
    BASSubCategoryTableViewCell* cell = [[BASSubCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withContent:dict];
    cell.delegate = (id)self;
     [cell setEditing:YES];
    
    
    if(app.curOrderList != nil && app.curOrderList.count > 0 && app.addOrderList != nil && app.addOrderList.count > 0){
        if(indexPath.section == 0){
            dict = (NSDictionary*)[app.curOrderList objectAtIndex:[indexPath row]];
            cell.modsExist = YES;
        }
        else{
            cell.modsExist = NO;
            dict = (NSDictionary*)[app.addOrderList objectAtIndex:[indexPath row]];
        }
    } else {
        if(app.curOrderList != nil && app.curOrderList.count > 0){
            dict = (NSDictionary*)[app.curOrderList objectAtIndex:[indexPath row]];
            cell.modsExist = YES;
        }
        else if(app.addOrderList != nil && app.addOrderList.count > 0){
            cell.modsExist = NO;
            dict = (NSDictionary*)[app.addOrderList objectAtIndex:[indexPath row]];
        }
        
    }

    cell.isDishCount = NO;
    cell.title = (NSString*)[dict objectForKey:@"name_dish"];
    cell.weight = (NSString*)[dict objectForKey:@"weight"];
    cell.cost = (NSString*)[dict objectForKey:@"price"];
    cell.dishIdx = [indexPath row];
    NSNumber* count_dish = (NSNumber*)[dict objectForKey:@"count_dish"];
    cell.count = [count_dish integerValue];
    if(count_dish == nil)
        cell.count = 0;
    NSNumber* id_status = (NSNumber*)[dict objectForKey:@"status"];
    cell.state = (OrderItemState)[id_status integerValue];

    
    
    NSNumber* max_dish = (NSNumber*)[dict objectForKey:@"max_dish"];
    if(max_dish != nil){
        cell.countDish = [max_dish integerValue];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}
#pragma mark -
#pragma mark Table delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 126.f;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
#pragma mark - BASModifyView  methods
- (void)modificationDish:(NSUInteger)_dishIdx{
  
    TheApp;
    if(app.addOrderList != nil && app.addOrderList.count > 0){

        [_btAdd setEnabled:NO];
        [_btCalc setEnabled:NO];
        [_btOrder setEnabled:NO];
        dishIdx = _dishIdx;
        NSDictionary* dict = (NSDictionary*)[app.addOrderList objectAtIndex:dishIdx];
        NSNumber* count_dish = (NSNumber*)[dict objectForKey:@"count_dish"];
        if([count_dish integerValue] > 0){
            UIImage* image = [UIImage imageNamed:@"cell_modifiers_x3.png"];
            NSArray* mod = (NSArray*)[dict objectForKey:@"mod"];
            if(mod != nil && mod.count > 0){
                self.modifyView = [[BASModifyView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - image.size.width / 2, self.view.frame.size.height / 2 - image.size.height / 2 - 60.f, image.size.width, image.size.height) withContent:mod withDelegate:(id)self];
                _modifyView.title = (NSString*)[dict objectForKey:@"name_dish"];
                [self.view addSubview:_modifyView];
                app.isModify = YES;
                [_tableView setScrollEnabled:NO];
            }
        }
    }

}
#pragma mark - BASModifyView delegate methods
- (void)doneClicked:(BASModifyView*)view withContent:(NSArray*)content{
    TheApp;
    
    [_btAdd setEnabled:YES];
    [_btCalc setEnabled:YES];
    [_btOrder setEnabled:YES];
    [_modifyView removeFromSuperview];
    self.modifyView = nil;
    app.isModify = NO;
    if(content != nil){
        NSMutableArray* temp = [[NSMutableArray alloc]initWithArray:app.addOrderList];
        NSDictionary* dict = (NSDictionary*)[app.addOrderList objectAtIndex:dishIdx];
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [newDict addEntriesFromDictionary:dict];
        [newDict setObject:content forKey:@"mod"];
        [temp replaceObjectAtIndex:dishIdx withObject:newDict];
        
        app.addOrderList = [NSArray arrayWithArray:temp];
        app.orders = [NSArray arrayWithArray:temp];
        [_tableView reloadData];
        
    }

    [_tableView setScrollEnabled:YES];
}
@end
