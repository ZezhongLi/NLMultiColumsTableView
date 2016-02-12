//
//  NLTableView.h
//  NLTableView
//
//  Created by Neil-Lee on 15/5/14.
//  Copyright (c) 2015年 Neil-Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - table view cell
@interface NLFirstCell : UITableViewCell

@property (strong, nonatomic) UIView *hinter;
@property (strong, nonatomic) UIImageView *moreIndicator;
@property (strong, nonatomic) UIImageView *checkMark;

+(instancetype)cell;

-(void)setSelected;
-(void)setMoreIndicator;
-(void)setCheckMark;

@end



#pragma mark - IndexPath 类
@interface NLIndexPath : NSObject

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger item;
@property (nonatomic, assign) NSInteger row;

- (instancetype)initWithSection:(NSInteger)section;
- (instancetype)initWithSection:(NSInteger)section item:(NSInteger)item;
- (instancetype)initWithSection:(NSInteger)section item:(NSInteger)item row:(NSInteger)row;
// default item = -1
+ (instancetype)indexPathWithSection:(NSInteger)section;
+ (instancetype)indexPathWithSection:(NSInteger)section item:(NSInteger)item;
+ (instancetype)indexPathWithSection:(NSInteger)section item:(NSInteger)item row:(NSInteger)row;
@end





#pragma mark - data source protocol
@class NLTableView;

@protocol NLTableViewDataSource <NSObject>

@required


//section-->Item-->row
/**
 *  返回 tableView 第section组 有多少行
 */
- (NSInteger)numberOfSectionInTableView:(NLTableView *)tableView;

/**
 *  返回 tableView 第section组 每行title
 */
- (NSString *)titleForSectionAtIndexPath:(NLIndexPath *)indexPath;

@optional

/**
 *  返回 tableView 第section组有多少行，默认为0，
 *  若返回0 则单列表，不为0则说明有二级目录
 */
- (NSInteger)tableView:(NLTableView *)tableView numberOfItemsInSection:(NSInteger)section;

/**
 *  返回 tableView 第section组 每行title
 */
- (NSString *)tableView:(NLTableView *)tableView titleForItemAtIndexPath:(NLIndexPath *)indexPath;

/**
 *  如果>0，说明有三级列表 ，=0 没有
 *  如果都没有可以不实现该协议
 */
- (NSInteger)tableView:(NLTableView *)tableView numberOfRowsInItem:(NSInteger)item section:(NSInteger)section;

/**
 *  第三级的 title
 *  如果都没有可以不实现该协议
 */
- (NSString *)tableView:(NLTableView *)tableView titleForRowAtIndexPath:(NLIndexPath *)indexPath;
@end


#pragma mark - delegate

@protocol NLTableViewDelegate <NSObject>
@optional
/**
 *  点击代理，点击了第column 第row 或者item项，如果 item >=0
 */
- (void)tableView:(NLTableView *)tableView didSelectRowAtIndexPath:(NLIndexPath *)indexPath;
@end


#pragma mark - NLTableView
@interface NLTableView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <NLTableViewDataSource> dataSource;
@property (nonatomic, weak) id <NLTableViewDelegate> delegate;

@property (nonatomic, strong) UIColor *textColor;           // 文字title颜色
@property (nonatomic, strong) UIColor *textSelectedColor;   // 文字title选中颜色
@property (nonatomic, assign) NSInteger fontSize;           // 字体大小
@property (nonatomic, strong) UIColor *cellBgColorFirst;
@property (nonatomic, strong) UIColor *cellBgColorSecond;
@property (nonatomic, strong) NLIndexPath *currentIndexPath;


/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height NLTableView's height
 *
 *  @return NLTableView
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;


// 创建tableView 第一次显示 不会调用点击代理，这个手动调用
- (void)selectDefalutIndexPath:(NLIndexPath *)indexPath;
@end
