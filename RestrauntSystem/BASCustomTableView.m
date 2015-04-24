//
//  BASCustomTableView.m
//  RestrauntSystem
//
//  Created by Sergey on 06.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASCustomTableView.h"
#import "BASCategoryTableViewCell.h"
#import "BASSubCategoryTableViewCell.h"
#import "BASNoticeTableViewCell.h"
#import "BASOrdersHistoryTableViewCell.h"


@interface BASCustomTableView()


@property (nonatomic,strong)NSArray* contentData;
@property (nonatomic, assign)id <RCSDishCellItemDelegate> delegateDish;


@end

@implementation BASCustomTableView



- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withContent:(NSArray*) content withType:(TableType)type withDelegate:(id <RCSDishCellItemDelegate>) delegate{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.contentData = [NSArray arrayWithArray:content];
        self.typeTable = type;
        self.delegateDish = delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setBackgroundView: nil];
        self.dataSource = (id)self;
        
    }
    return self;
}
#pragma mark -
#pragma mark Public methods

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contentData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary* obj = (NSDictionary*)[_contentData objectAtIndex:[indexPath row]];
    
    return [self cellClass:obj withIndex:(NSInteger)[indexPath row]];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark Private methods

- (CGFloat)hightCell:(TableType)type{
   
    switch (type) {
        case CATEGORYTABLE:
            return 70.f;
            break;
        case SUBCATEGORYTABLE:
             return 126.f;
            break;
        case NOTICETABLE:
             return 44.f;
            break;
        case ORDERSLIST:
            return 75.f;
            break;
        default:
            break;
    }
    
    return 0;
}
- (UITableViewCell*)cellClass:(NSDictionary*)obj withIndex:(NSInteger)index{
  
    static NSString *CellIdentifier = @"CustomCell";
    UITableViewCell* Cell = nil;
    
    switch (_typeTable) {
        case CATEGORYTABLE:{
            //BASCategoryTableViewCell* cell = (BASCategoryTableViewCell*)[self dequeueReusableCellWithIdentifier:CellIdentifier];
            //if (cell == nil) {
                BASCategoryTableViewCell* cell = [[BASCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withContent:obj];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
           // }
            Cell = cell;
        }
            break;
        case SUBCATEGORYTABLE:{
            ///BASSubCategoryTableViewCell* cell = (BASSubCategoryTableViewCell*)[self dequeueReusableCellWithIdentifier:CellIdentifier];
           // if (cell == nil) {
                BASSubCategoryTableViewCell* cell = [[BASSubCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withContent:obj];
                cell.delegate = _delegateDish;
                cell.title = (NSString*)[obj objectForKey:@"name_dish"];
                NSLog(@"name_dish: %@", cell.title);
                cell.weight = [NSString stringWithFormat:@"%@ %@", [obj objectForKey:@"weight"], [obj objectForKey:@"unit_weight"]] ;
                cell.cost = [NSString stringWithFormat:@"%@ %@",[obj objectForKey:@"price"], [obj objectForKey:@"unit_price"]] ;
                cell.dishIdx = index;
                NSNumber* count_dish = (NSNumber*)[obj objectForKey:@"count_dish"];
                cell.count = [count_dish integerValue];
                if(count_dish == nil)
                    cell.count = 0;
                NSNumber* id_status = (NSNumber*)[obj objectForKey:@"status"];
                cell.state = (OrderItemState)[id_status integerValue];
            
                cell.isDishCount = YES;
                NSNumber* max_dish = (NSNumber*)[obj objectForKey:@"max_dish"];
                if(max_dish != nil){
                    cell.countDish = [max_dish integerValue];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
           // }
            Cell = cell;
        }
            break;
        case NOTICETABLE:{
           // BASNoticeTableViewCell* cell = (BASNoticeTableViewCell*)[self dequeueReusableCellWithIdentifier:CellIdentifier];
           // if (cell == nil) {
                BASNoticeTableViewCell *cell = [[BASNoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withContent:obj];
                cell.separatorEnabled = YES;
                if(_contentData.count > 1){
                    if(index == 0){
                        [cell setTopCornerRadius];
                    } else if(index == _contentData.count -1){
                        [cell setBottomCornerRadius];
                    }
                } else{
                    [cell setCornerRadius];
                }

                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
           // }
            Cell = cell;
        }
            break;
        case ORDERSLIST:{

            OrdersHistoryType type = CURRENTTYPE;
           
            NSDictionary* dict = (NSDictionary*)[obj objectForKey:@"order"];
            NSNumber* status = (NSNumber*)[dict objectForKey:@"status"];
            if([status integerValue] == 2)
                type = ALLTYPE;
            
            BASOrdersHistoryTableViewCell *cell = [[BASOrdersHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withContent:dict withType:type];
  
                
            NSNumber* cost = (NSNumber*)[dict objectForKey:@"cost"];
            [cell.textView setText:[NSString stringWithFormat:@"%d грн",[cost integerValue]]];

            NSNumber* number_table = (NSNumber*)[dict objectForKey:@"number_table"];
            [cell.numberView setText:[NSString stringWithFormat:@"%d",[number_table integerValue]]];
            
            NSString* time = (NSString*)[dict objectForKey:@"finish_time"];
            if(type == ALLTYPE && time != nil){
                NSArray* sort = [time componentsSeparatedByString:@" "];
                time = [NSString stringWithFormat:@"%@",[sort objectAtIndex:1]];
                sort = [time componentsSeparatedByString:@":"];
                cell.timeView.text = [NSString stringWithFormat:@"%@:%@",[sort objectAtIndex:0],[sort objectAtIndex:1]];
            }
            
            
            cell.status = [status integerValue];
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            Cell = cell;
        }
            break;
        default:
            break;
    }
    
    return Cell;
}



@end
