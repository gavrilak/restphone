//
//  BASCategoryViewController.m
//  RestrauntSystem
//
//  Created by Sergey on 09.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASCategoryViewController.h"
#import "BASCustomTableView.h"
#import "BASDishViewController.h"
#import "BASOrderViewController.h"
#import "BASModifyView.h"

@interface BASCategoryViewController (){
    NSUInteger dishIdx;
    NSUInteger curdishIdx;
    
}

@property (nonatomic,strong)BASCustomTableView* tableView;
@property (nonatomic,strong) NSArray* dishesContent;
@property (nonatomic,strong) BASModifyView* modifyView;
@property (nonatomic,strong) NSMutableArray* orders;
@end

@implementation BASCategoryViewController

- (void)setIsOrder:(BOOL)isOrder{
    _isOrder = isOrder;
    
    if(_isOrder){
        [self setupLblAmountWithBtnOrder:YES];
    }
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
    TheApp;
    [super viewDidLoad];
    
    app.isModify = NO;
    curdishIdx = -1;
    [self setupBackBtn];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self customTitle:(NSString*)[_contentData objectForKey:[Settings text:TextForApiKeyTitle]]];

    TheApp;
    [self setSumWhenTableId:app.curCoastOrder];

    [self getData];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self customTitle:@""];
    [self enabledMakeOrder:YES];
    [super viewWillDisappear:animated];
}


#pragma mark  - Private methods

- (NSInteger)checkPresent:(NSInteger)id_dish{

    if(_orders.count >0){
        for(int i = 0; i < _orders.count; i++){
            if(![[_orders objectAtIndex:i] isKindOfClass:[NSNull class]]){
                NSDictionary* obj = (NSDictionary*)[_orders objectAtIndex:i];
                NSNumber* ID = (NSNumber*)[obj objectForKey:@"id_dish"];
                if([ID integerValue] == id_dish)
                    return (NSInteger)i;
            }
        }
    }

    return  -1;
}
- (void)btnOrderPressed{
    TheApp;
    
    
    if(_orders != nil)
        if(!app.isModify)
            [self makeOrder];
        else
           [[BASManager sharedInstance]showAlertViewWithMess:@"Подтвердите выбор модификаторов!"];
    else
        [[BASManager sharedInstance]showAlertViewWithMess:@"Выберите блюдо!"];
}
- (void)prepareView{

        [_tableView removeFromSuperview];
        self.tableView = nil;
        self.tableView = [[BASCustomTableView alloc]initWithFrame:self.viewFrame style:UITableViewStylePlain withContent:_dishesContent withType:SUBCATEGORYTABLE withDelegate:(id <RCSDishCellItemDelegate>)self];
        _tableView.delegate = (id)self;
        [_tableView setContentOffset:CGPointMake(0, 0)];
        [self.view addSubview:_tableView];
   
}
- (void)getData{
    TheApp;
    
    BASManager* manager = [BASManager sharedInstance];
 
    NSLog(@"%d",[[_contentData objectForKey:[Settings text:TextForApiKeyId]]integerValue]);
    NSDictionary* dict = @{
                           @"id_category": (NSNumber*)[_contentData objectForKey:[Settings text:TextForApiKeyId]],
                           };

    
    [manager getData:[manager formatRequest:[Settings text:TextForApiFuncMenuForDishes] withParam:dict] success:^(id responseObject) {

        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSArray* param = (NSArray*)[responseObject objectForKey:@"param"];
            NSLog(@"Response: %@",param);
            
            if(param != nil){
                
                NSMutableArray* data = [NSMutableArray new];
                
                
                for (int i = 0; i < param.count; i++) {
                    NSDictionary* dict = nil;
                    NSDictionary* obj = (NSDictionary*)[param objectAtIndex:i];
                    NSNumber* availability = (NSNumber*)[obj objectForKey:@"availability"];
                    if([availability intValue] > 0){
                        NSNumber* max_dish = (NSNumber*)[obj objectForKey:@"max_dish"];
                        if(max_dish != nil){
                         dict = @{
                                    @"id_dish": (NSNumber*)[obj objectForKey:@"id_dish"],
                                    @"name_dish": (NSNumber*)[obj objectForKey:@"name_dish"],
                                    @"price": (NSNumber*)[obj objectForKey:@"price"],
                                    @"unit_price":(NSString*) [obj objectForKey:@"unit_price"],
                                    @"weight": (NSNumber*)[obj objectForKey:@"weight"],
                                    @"unit_weight":(NSString*) [obj objectForKey:@"unit_weight"],
                                    @"description": (NSString*) [obj objectForKey:@"description"],
                                    @"descr_link": (NSString*) [obj objectForKey:@"descr_link"],
                                    @"time_prepare":  (NSString*) [obj objectForKey:@"time_prepare"],
                                    @"unit_time": (NSString*) [obj objectForKey:@"unit_time"],
                                    @"availability": (NSNumber*)[obj objectForKey:@"availability"],
                                    @"max_dish": (NSNumber*)[obj objectForKey:@"max_dish"],
                                    @"global_mod": (NSArray*)[obj objectForKey:@"global_modificators"],
                                    @"local_mod": (NSArray*)[obj objectForKey:@"local_modificators"],
                                };
                        } else {
                            dict = @{
                                     @"id_dish": (NSNumber*)[obj objectForKey:@"id_dish"],
                                     @"name_dish": (NSNumber*)[obj objectForKey:@"name_dish"],
                                     @"price": (NSNumber*)[obj objectForKey:@"price"],
                                     @"unit_price":(NSString*) [obj objectForKey:@"unit_price"],
                                     @"weight": (NSNumber*)[obj objectForKey:@"weight"],
                                     @"unit_weight":(NSString*) [obj objectForKey:@"unit_weight"],
                                     @"description": (NSString*) [obj objectForKey:@"description"],
                                     @"descr_link": (NSString*) [obj objectForKey:@"descr_link"],
                                     @"time_prepare":  (NSString*) [obj objectForKey:@"time_prepare"],
                                     @"unit_time": (NSString*) [obj objectForKey:@"unit_time"],
                                     @"availability": (NSNumber*)[obj objectForKey:@"availability"],
                                     @"count_dish": (NSNumber*)[obj objectForKey:@"count_dish"],
                                     @"global_mod": (NSArray*)[obj objectForKey:@"global_modificators"],
                                     @"local_mod": (NSArray*)[obj objectForKey:@"local_modificators"],

                                     };
                        }
       
                        [data addObject:dict];
                    }
                 }
                self.dishesContent = [NSArray arrayWithArray:data];
                [self enabledMakeOrder:YES];
                self.orders = nil;
                self.orders = [[NSMutableArray alloc]initWithCapacity:_dishesContent.count];
                for (int i = 0; i < _dishesContent.count; i++) {
                    [_orders addObject:[NSNull null]];
                }
                [self prepareView];
            }
        }
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];
}

- (void)makeOrder{
    
    [_modifyView removeFromSuperview];
    self.modifyView = nil;

    
    TheApp;
    [self enabledMakeOrder:NO];
    NSMutableArray* tempOrders = [NSMutableArray new];
    for(int i = 0; i < _orders.count; i++){
        if(![[_orders objectAtIndex:i]isKindOfClass:[NSNull class]]){
            [tempOrders addObject:[_orders objectAtIndex:i]];
        }
    }
    NSMutableArray* temp = [[NSMutableArray alloc]initWithArray:app.orders];
    [temp addObjectsFromArray:tempOrders];
    app.addOrderList = [NSArray arrayWithArray:temp];
    app.orders = [NSArray arrayWithArray:temp];
    [_orders removeAllObjects];
    [self getData];
    //[self.navigationController popViewControllerAnimated:YES];
}
 

#pragma mark - Table delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableView hightCell:_tableView.typeTable];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TheApp;
    if(!app.isOrder && !app.isModify){
        BASDishViewController* controller = [BASDishViewController new];
        controller.contentData = (NSDictionary*)[_dishesContent objectAtIndex:[indexPath row]];
    
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

#pragma mark - CategoryCell delegate methods

- (void)plusOneDish:(NSUInteger)_dishIdx success:(SuccessBlock)success{
    TheApp;
    if(_isOrder && !app.isModify){

        NSDictionary* obj = (NSDictionary*)[_dishesContent objectAtIndex:_dishIdx];
        
        NSNumber* availability = (NSNumber*)[obj objectForKey:@"availability"];
        
        if([availability integerValue] != 0){
            
            NSNumber* price = (NSNumber*)[obj objectForKey:@"price"];
            NSNumber* id_dish = (NSNumber*)[obj objectForKey:@"id_dish"];

            NSInteger index = [self checkPresent:[id_dish integerValue]];
            
            if(index != -1){
                NSDictionary* obj = (NSDictionary*)[_orders objectAtIndex:index];
                NSNumber* counts = (NSNumber*)[obj objectForKey:@"count_dish"];
                NSInteger count = [counts integerValue];
                count++;
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                [newDict addEntriesFromDictionary:obj];
                [newDict setObject:[NSNumber numberWithInteger:count] forKey:@"count_dish"];
                [_orders replaceObjectAtIndex:index withObject:newDict];
              
            } else {
                NSMutableDictionary* dish = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      id_dish,@"id_dish",
                                      [NSNumber numberWithInt:1],@"count_dish",
                                      (NSString*)[obj objectForKey:@"name_dish"],@"name_dish",
                                      (NSString*)[obj objectForKey:@"price"],@"price",
                                      (NSString*)[obj objectForKey:@"unit_price"],@"unit_price",
                                      (NSString*)[obj objectForKey:@"weight"],@"weight",
                                      (NSString*)[obj objectForKey:@"unit_weight"],@"unit_weight",
                                      (NSArray*) [obj objectForKey:@"local_mod"],@"local_mod",
                                      (NSArray*) [obj objectForKey:@"global_mod"],@"global_mod",
                                      nil];

                [_orders replaceObjectAtIndex:_dishIdx withObject:dish];
   
            }
            app.addCoastOrder += [price integerValue];
            app.curCoastOrder += [price integerValue];
            [self setSumWhenTableId:app.curCoastOrder];
            success();
       } else {
           [[BASManager sharedInstance]showAlertViewWithMess:@"Данное блюдо недоступно!"];
       }
    }
}
- (void)minusOneDish:(NSUInteger)_dishIdx success:(SuccessBlock)success{
    TheApp;
    if(_isOrder && !app.isModify){
        NSDictionary* dict = (NSDictionary*)[_dishesContent objectAtIndex:_dishIdx];

        NSNumber* price = (NSNumber*)[dict objectForKey:@"price"];
        NSNumber* id_dish = (NSNumber*)[dict objectForKey:@"id_dish"];
        NSInteger index = [self checkPresent:[id_dish integerValue]];
       
        NSDictionary* obj = (NSDictionary*)[_orders objectAtIndex:index];
        NSNumber* counts = (NSNumber*)[obj objectForKey:@"count_dish"];
        NSInteger count = [counts integerValue];
        count--;

        if(count > 0){
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:obj];
            [newDict setObject:[NSNumber numberWithInteger:count] forKey:@"count_dish"];
            [_orders replaceObjectAtIndex:index withObject:newDict];

        } else {
            [_orders replaceObjectAtIndex:index withObject:[NSNull null]];

        }

        app.curCoastOrder -= [price integerValue];
        [self setSumWhenTableId:app.curCoastOrder];
        success();
       
    }
}
#pragma mark - BASModifyView  methods
- (void)modificationDish:(NSUInteger)_dishIdx tag:(NSUInteger)tag{
    TheApp;
    dishIdx = _dishIdx;

    if(_orders != nil && _orders.count > 0){

        if(![[_orders objectAtIndex:dishIdx] isKindOfClass:[NSNull class]]){
            NSDictionary* dict = (NSDictionary*)[_orders objectAtIndex:dishIdx];
            NSNumber* count_dish = (NSNumber*)[dict objectForKey:@"count_dish"];
            NSArray* mod;
            if (tag == 1) {
                mod = (NSArray*)[dict objectForKey:@"local_mod"];
            } else {
                mod = (NSArray*)[dict objectForKey:@"global_mod"];
            }
            if([count_dish integerValue] > 0){
                UIImage* image = [UIImage imageNamed:@"cell_modifiers_x3.png"];
                if(mod != nil && mod.count > 0 && !app.isModify){
                    self.modifyView = [[BASModifyView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - image.size.width / 2, self.view.frame.size.height / 2 - image.size.height / 2 - 60.f, image.size.width, image.size.height) withContent:mod withDelegate:(id)self];
                    _modifyView.title = (NSString*)[dict objectForKey:@"name_dish"];
                    _modifyView.tag = tag;
                    [self.view addSubview:_modifyView];
                    app.isModify = YES;
                    [_tableView setScrollEnabled:NO];
                }
            }
        }
    }
}
#pragma mark - BASModifyView delegate methods
- (void)doneClicked:(BASModifyView*)view withContent:(NSArray*)content{
    TheApp;

    [_modifyView removeFromSuperview];
    self.modifyView = nil;
    
    if(content != nil){
        NSDictionary* dict = (NSDictionary*)[_orders objectAtIndex:dishIdx];
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [newDict addEntriesFromDictionary:dict];
        if(view.tag == 1) {
            [newDict setObject:content forKey:@"local_mod"];
        } else {
            [newDict setObject:content forKey:@"global_mod"];
        }
        [_orders replaceObjectAtIndex:dishIdx withObject:newDict];

    }
    
    app.isModify = NO;
    [_tableView setScrollEnabled:YES];
}

@end
