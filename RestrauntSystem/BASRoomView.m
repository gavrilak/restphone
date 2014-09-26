//
//  BASRoomView.m
//  RestrauntSystem
//
//  Created by Sergey on 06.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASRoomView.h"
#import "BASTableView.h"

#define MAXTABLES 12
#define TABLERECT CGRectMake(0, 0, 96.f, 96.f)


@interface BASRoomView(){
   
}
@property (nonatomic,assign)RoomType type;
@property (nonatomic,strong)NSArray* tables;
@property (nonatomic,strong)UIView* roomView;
@property(nonatomic ,strong) UIScrollView* scrollView;
@end

@implementation BASRoomView


@synthesize delegate = _delegate;
@synthesize contentData = _contentData;
@synthesize indexRoom = _indexRoom;

- (void)setContentData:(NSDictionary *)contentData{
    _contentData = nil;
    _contentData = contentData;
    
    if(self.roomView != nil){
        [self clearRoom];
        [self createRoom];
    }
}
- (id)initWithFrame:(CGRect)frame withContent:(NSDictionary*)contentData withIndex:(NSInteger)index withType:(RoomType)typeRoom
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = typeRoom;
        self.tables = nil;
        self.indexRoom = index;
        self.contentData = [NSDictionary dictionaryWithDictionary:contentData];

        [self setBackground];
        self.scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.scrollEnabled=YES;
        _scrollView.userInteractionEnabled=YES;
        [_scrollView setFrame:self.frame];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_scrollView];
        
    }
    return self;
}

#pragma mark - Public methods
- (void)createRoom{
    if(_contentData != nil){
        self.roomView = [self initRoom];
        [_scrollView addSubview:_roomView];
    }
}
#pragma mark - Private methods
- (void)clearRoom{
    [self.roomView removeFromSuperview];
    self.roomView = nil;
    self.tables = nil;
    
}
- (void)setBackground{
    [self setBackgroundColor:[UIColor clearColor]];
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[Settings image:ImageForControllerViewBg]];
    CGFloat bgImgTop = 0;
    bgImg.frame = CGRectMake(bgImg.frame.origin.x,
                             bgImgTop,
                             [Settings screenWidth],
                             [Settings screenHeight] - [Settings image:ImageForNavBarBg].size.height - [Settings image:ImageForTabBarBg].size.height);
    
    [self addSubview:bgImg];
}


- (UIView*)initRoom{
    
    UIView* contentView = [[UIView alloc]initWithFrame:self.frame];
    [contentView setBackgroundColor:[UIColor clearColor]];
    
    CGRect rect = TABLERECT;
    
    CGFloat posX = 16.f;
    CGFloat posY = 20.f;
    
    if(_contentData != nil){
        NSInteger tablesCount = [((NSNumber*)[_contentData objectForKey:@"tables_count"]) integerValue];
        NSMutableArray* tbls = [NSMutableArray new];

        if(_type ==  FIRSTROOM){

            for (int i = 0; i < tablesCount; i++) {

                if(i % 3 == 0 && i > 0){
                    posX = 16.f;
                    posY += rect.size.height;
                }
                BASTableView *obj = [[BASTableView alloc]initWithFrame:TABLERECT];
                [obj setFrame:CGRectMake(posX, posY, rect.size.width, rect.size.height)];
                obj.delegate = (id<BASTableViewDelegate>)self;
                obj.indexTable = i;
                obj.num_table = i+1;
                obj.indexRoom = _indexRoom;
                obj.tableState = TableStateFree;
                if(i < tablesCount){
                    NSArray* tables = (NSArray*)[_contentData objectForKey:@"tables"];
                    NSDictionary* dict = (NSDictionary*)[tables objectAtIndex:i];
                    NSNumber* tablStatus = (NSNumber*)[dict objectForKey:@"table_status"];
                    obj.tableState = (TableState)[tablStatus integerValue];
                    if(obj.tableState != TableStateFree){
                        NSDictionary* employee = (NSDictionary*)[dict objectForKey:@"employee"];
                        obj.waiterName = (NSString*)[employee objectForKey:@"surname"];
                    }
                }
                
                [contentView addSubview:obj];

                posX += rect.size.width;
                
                [tbls addObject:contentView];
                
            }
            UIImage* img = [Settings image:ImageForHallsBar];
             
             CGFloat centerX = (rect.size.width * 2) + rect.size.width / 2 + 16.f;
             CGFloat centerY = posY + rect.size.height;
             posX = centerX - img.size.width / 2;
             posY = centerY - 95.f;
             
             UIImageView* barImageView = [[UIImageView alloc]initWithImage:img];
             [barImageView setFrame:CGRectMake(posX, posY, img.size.width, img.size.height)];
             [self addSubview:barImageView];
             
             
             img = [Settings image:ImageForHallsDoor];
             UIImageView* doorImageView = [[UIImageView alloc]initWithImage:img];
             [doorImageView setFrame:CGRectMake(40.f, self.frame.size.height - img.size.height, img.size.width, img.size.height)];
             [self addSubview:doorImageView];
        } else if(_type ==  SECONDROOM){
            
            for (int i = 0; i < tablesCount; i++) {
                
                if(i == 5 || i == 8){
                    posX = 16.f;
                    posY += rect.size.height;
                }
                BASTableView *obj = [[BASTableView alloc]initWithFrame:TABLERECT];
                [obj setFrame:CGRectMake(posX, posY, rect.size.width, rect.size.height)];
                obj.delegate = (id<BASTableViewDelegate>)self;
                obj.indexTable = i;
                obj.num_table = i+1;
                obj.indexRoom = _indexRoom;
                obj.tableState = TableStateFree;
                if(i < tablesCount){
                    NSArray* tables = (NSArray*)[_contentData objectForKey:@"tables"];
                    NSDictionary* dict = (NSDictionary*)[tables objectAtIndex:i];
                    NSNumber* tablStatus = (NSNumber*)[dict objectForKey:@"table_status"];
                    obj.tableState = (TableState)[tablStatus integerValue];
                    if(obj.tableState != TableStateFree){
                        NSDictionary* employee = (NSDictionary*)[dict objectForKey:@"employee"];
                        obj.waiterName = (NSString*)[employee objectForKey:@"surname"];
                    }
                }
                
                [contentView addSubview:obj];
                
                if(i == 0){
                    posX += 2*rect.size.width;
                }
                else if(i == 1){
                    posX = 16.f;
                    posY += rect.size.height;
                }
                else
                    posX += rect.size.width;
                [tbls addObject:contentView];
                
            }
  
            UIImage* img = [UIImage imageNamed:@"door_vert.png"];
            UIImageView* doorImageView = [[UIImageView alloc]initWithImage:img];
            
            [doorImageView setFrame:CGRectMake(self.frame.size.width - img.size.width, self.frame.size.height - img.size.height - 10.f, img.size.width, img.size.height)];

            
            [self addSubview:doorImageView];
        } else if(_type ==  THIRDROOM){
            NSInteger j = -1;
            BOOL key = YES;
            for (int i = 0; i < tablesCount; i++) {
                
                if(i % 3 == 0 && i > 0 && key){
                    posX = 16.f;
                    posY += rect.size.height;
                }
                if(i == 13){
                    key = NO;
                    posX = 16.f;
                    posY += rect.size.height;
                    j++;
                }
                if(i > 13){
                    j++;
                }
                if(j % 3 == 0  && !key && j > 0){
                    posX = 16.f;
                    posY += rect.size.height;
                }
                BASTableView *obj = [[BASTableView alloc]initWithFrame:TABLERECT];
                [obj setFrame:CGRectMake(posX, posY, rect.size.width, rect.size.height)];
                obj.delegate = (id<BASTableViewDelegate>)self;
                obj.indexTable = i;
                obj.num_table = i+1;
                obj.indexRoom = _indexRoom;
                obj.tableState = TableStateFree;
                if(i < tablesCount){
                    NSArray* tables = (NSArray*)[_contentData objectForKey:@"tables"];
                    NSDictionary* dict = (NSDictionary*)[tables objectAtIndex:i];
                    NSNumber* tablStatus = (NSNumber*)[dict objectForKey:@"table_status"];
                    obj.tableState = (TableState)[tablStatus integerValue];
                    if(obj.tableState != TableStateFree){
                        NSDictionary* employee = (NSDictionary*)[dict objectForKey:@"employee"];
                        obj.waiterName = (NSString*)[employee objectForKey:@"surname"];
                    }
                }
                
                [contentView addSubview:obj];
                
      
                posX += rect.size.width;
                [tbls addObject:contentView];
                
            }
            
            UIImage* img = [UIImage imageNamed:@"door_vert.png"];
            UIImageView* doorImageView = [[UIImageView alloc]initWithImage:img];
            
            [doorImageView setFrame:CGRectMake(self.frame.size.width  - img.size.width, self.frame.size.height / 2 - img.size.height / 2, img.size.width, img.size.height)];
            
            
            [self addSubview:doorImageView];
            [_scrollView setContentSize:CGSizeMake(self.frame.size.width,  posY + 130.f)];
        } else if(_type ==  FOURTHROOM){
            NSInteger j = -1;
            BOOL key = YES;
            for (int i = 0; i < tablesCount; i++) {
       
                if(i == 2){
                    posX = 16.f;
                    posY += rect.size.height;
                }
                if(i == 4){
                    key = NO;
                    posX = 16.f;
                    posY += rect.size.height;
                    j++;
                }
                if(i > 4){
                    j++;
                }
                if(j % 3 == 0  && !key && j > 0){
                    posX = 16.f;
                    posY += rect.size.height;
                }
    
                BASTableView *obj = [[BASTableView alloc]initWithFrame:TABLERECT];
                [obj setFrame:CGRectMake(posX, posY, rect.size.width, rect.size.height)];
                obj.delegate = (id<BASTableViewDelegate>)self;
                obj.indexTable = i;
                obj.num_table = i+1;
                obj.indexRoom = _indexRoom;
                obj.tableState = TableStateFree;
                if(i < tablesCount){
                    NSArray* tables = (NSArray*)[_contentData objectForKey:@"tables"];
                    NSDictionary* dict = (NSDictionary*)[tables objectAtIndex:i];
                    NSNumber* tablStatus = (NSNumber*)[dict objectForKey:@"table_status"];
                    obj.tableState = (TableState)[tablStatus integerValue];
                    if(obj.tableState != TableStateFree){
                        NSDictionary* employee = (NSDictionary*)[dict objectForKey:@"employee"];
                        obj.waiterName = (NSString*)[employee objectForKey:@"surname"];
                    }
                }
                
                [contentView addSubview:obj];
        
                posX += rect.size.width;
                [tbls addObject:contentView];
                
            }
            
            UIImage* img = [Settings image:ImageForHallsDoor];
            UIImageView* doorImageView = [[UIImageView alloc]initWithImage:img];
            [doorImageView setFrame:CGRectMake(self.frame.size.width - img.size.width - 10.f, self.frame.size.height - img.size.height, img.size.width, img.size.height)];
            [self addSubview:doorImageView];
            
            
            [self addSubview:doorImageView];
            [_scrollView setContentSize:CGSizeMake(self.frame.size.width,  posY + 130.f)];
        }



        
        
        self.tables = [NSArray arrayWithArray:tbls];
    }
    

    return  (BASRoomView*)contentView;
}
#pragma mark - BASTableViewDelegate methods
- (void)onClicked:(BASTableView*)view withIndexRoom:(NSInteger)indexRoom withIndexTable:(NSInteger)indexTable{
    if([_delegate respondsToSelector:@selector(selectTable:withIndexRoom:withIndexTable:)]){
        [_delegate selectTable:self withIndexRoom:indexRoom withIndexTable:indexTable];
    }
}

@end
