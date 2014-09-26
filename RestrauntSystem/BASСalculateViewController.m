//
//  BASСalculateViewController.m
//  RestrauntSystem
//
//  Created by Sergey on 17.07.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASСalculateViewController.h"
#import "BASCalculateView.h"

@interface BASCalculateViewController ()

@property (nonatomic,strong)BASCalculateView* calcView;
@end

@implementation BASCalculateViewController

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
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self customTitle:@"Рассчет"];
    
    [self prepareView];

}
- (void)viewWillDisappear:(BOOL)animated{
    [self customTitle:@""];
    [super viewWillDisappear:animated];
}
#pragma mark - Private methods
- (void)prepareView{
    
       CGRect rect = [[UIScreen mainScreen]bounds];
        self.calcView = [[BASCalculateView alloc]initWithFrame:rect];
        _calcView.price = _price;
        _calcView.delegate = self;
        [self.view addSubview:_calcView];
        
   
}
#pragma mark - BASCalculateViewDelegate methods
- (void)doneClicked:(BASCalculateView*)view{

    BASManager* manager = [BASManager sharedInstance];
    
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           _id_order ,@"id_order",
                           nil];
    
    [manager getData:[manager formatRequest:@"CALCULATEORDER" withParam:param] success:^(id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [manager showAlertViewWithMess:ERROR_MESSAGE];
    }];

}


@end
