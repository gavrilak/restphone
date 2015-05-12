//
//  BASVirtualListController.m
//  RestrauntSystem
//
//  Created by Sergey on 25.09.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASVirtualListController.h"
#import "BASCustomTableView.h"

@interface BASVirtualListController ()

@property (nonatomic,strong) BASCustomTableView* tableView;
@property (nonatomic,strong) NSArray* dishesContent;


@end

@implementation BASVirtualListController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self customTitle:@"Виртуальный стол"];
    [self setupBackBtn];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_all.png"]]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self prepareView];
}


- (void)prepareView{
    
    if(self.contentData != nil){
        
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        CGRect frame = [[UIScreen mainScreen]bounds];
        
        NSDictionary* order = (NSDictionary*)[_contentData objectForKey:@"order"];
        
        self.dishesContent = nil;
        self.dishesContent = [NSArray arrayWithArray:(NSArray*)[order objectForKey:@"order_items"]];
       


        self.tableView = [[BASCustomTableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain withContent:_dishesContent withType:SUBCATEGORYTABLE withDelegate:nil];
        
        _tableView.delegate = (id)self;
        
        
        [self.view addSubview:_tableView];
    }
    
}

#pragma mark -
#pragma mark Table delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableView hightCell:_tableView.typeTable];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
