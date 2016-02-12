//
//  ViewController.m
//  NLTableView
//
//  Created by Neil-Lee on 15/5/14.
//  Copyright (c) 2015年 Neil-Lee. All rights reserved.
//

#import "ViewController.h"
#import "NLTableView.h"

@interface ViewController () <NLTableViewDataSource,NLTableViewDelegate>
@property (strong,nonatomic) NSArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    NLTableView *view = [[NLTableView alloc]initWithOrigin:CGPointMake(0, 0) andHeight:500];
    view.dataSource = self;
    view.delegate = self;
    [self.view addSubview:view];
}

- (void)prepareData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"allspace.txt" ofType:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    self.dataArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
 
}

//section-->Item-->row
/**
 *  返回 tableView 第section组 有多少行
 */
- (NSInteger)numberOfSectionInTableView:(NLTableView *)tableView{

    return  self.dataArray.count;
}

/**
 *  返回 tableView 第section组 每行title
 */
- (NSString *)titleForSectionAtIndexPath:(NLIndexPath *)indexPath{
    NSArray *array  = self.dataArray;
    
    NSDictionary *dict = array[indexPath.section];
    NSString *string = dict[@"name"];
    
    return string;
}

/**
 *  返回 tableView 第section组有多少行，默认为0，
 *  若返回0 则单列表，不为0则说明有二级目录
 */
- (NSInteger)tableView:(NLTableView *)tableView numberOfItemsInSection:(NSInteger)section{
    NSArray *array  = self.dataArray;
    
    NSDictionary *dict = array[section];
    
    NSArray *catesArray = dict[@"cates"];
    
    return catesArray.count;
}

/**
 *  返回 tableView 第section组 每行title
 */
- (NSString *)tableView:(NLTableView *)tableView titleForItemAtIndexPath:(NLIndexPath *)indexPath{
    NSArray *array  = self.dataArray;
    
    NSDictionary *dict = array[indexPath.section];
    
    NSArray *catesArray = dict[@"cates"];
    
    NSDictionary *titleDict = catesArray[indexPath.item];
    
    return titleDict[@"name"];

}

/**
 *  如果>0，说明有三级列表 ，=0 没有
 *  如果都没有可以不实现该协议
 */
- (NSInteger)tableView:(NLTableView *)tableView numberOfRowsInItem:(NSInteger)item section:(NSInteger)section{
    NSArray *array  = self.dataArray;
    
    NSDictionary *dict = array[section];
    
    NSArray *catesArray = dict[@"cates"];
    
    NSDictionary *rowDict = catesArray[item];
    
    NSArray *rowArray = rowDict[@"cates"];
    
    return rowArray.count;

}

/**
 *  第三级的 title
 *  如果都没有可以不实现该协议
 */
- (NSString *)tableView:(NLTableView *)tableView titleForRowAtIndexPath:(NLIndexPath *)indexPath{
    NSArray *array  = self.dataArray;
    
    NSDictionary *dict = array[indexPath.section];
    
    NSArray *catesArray = dict[@"cates"];
    
    NSDictionary *rowDict = catesArray[indexPath.item];
    
    NSArray *rowArray = rowDict[@"cates"];
    
    NSDictionary *row = rowArray[indexPath.row];
    
    return row[@"name"];
}

- (void)tableView:(NLTableView *)tableView didSelectRowAtIndexPath:(NLIndexPath *)indexPath{
    NSLog(@"selected section: %d  item: %d   row: %d",indexPath.section,indexPath.item,indexPath.row);

}

@end
