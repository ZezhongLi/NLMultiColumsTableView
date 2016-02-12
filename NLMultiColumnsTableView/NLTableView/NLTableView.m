//
//  NLTableView.m
//  NLTableView
//
//  Created by Neil-Lee on 15/5/14.
//  Copyright (c) 2015年 Neil-Lee. All rights reserved.
//


#import "NLTableView.h"

#define NLColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kTableViewCellHeight 43
#define kFontSize 14
#define kTextColor NLColor(136, 136, 136)
#define kTextSelectColor NLColor(250, 114, 60)
#define kCellSelectedBgColorFirst NLColor(247,247,247)
#define kCellSelectedBgColorSecond NLColor(239,239,239)

#define kScreenSize [[UIScreen mainScreen]bounds].size
#define kItemTableOriginX (kScreenSize.width * 7 / 16)
#define kItemTableX (kScreenSize.width * 114 / 320)
#define kItemTableW (([[UIScreen mainScreen]bounds].size.width)*180/320)

#define kRowTableX ((208.0/320.0)*([[UIScreen mainScreen]bounds].size.width))
#define kRowTableW (([[UIScreen mainScreen]bounds].size.width) * 112 / 320)


#pragma mark - table view cell implements
@interface NLFirstCell ()

@end

@implementation NLFirstCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    static NSString * const cellID = @"NLFirstCell";
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID]) {
        
//        self.frame = CGRectMake(0, 0, kScreenSize.width, 44);
        
        _hinter = [[UIView alloc]initWithFrame:CGRectMake(2, 1, 2, 42)];
        _hinter.backgroundColor = [UIColor orangeColor];
        [self addSubview:_hinter];
        
        _moreIndicator = [[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width - 20, 16, 8, 12)];
        [_moreIndicator setImage:[UIImage imageNamed:@"photo_icon_right"]];
        [self addSubview:_moreIndicator];
        
        
        
        _checkMark = [[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width - 25, 16, 14, 12)];
        [_checkMark setImage:[UIImage imageNamed:@"photo_gou"]];
        [self addSubview:_checkMark];
    }
    return self;
}

+(instancetype)cell {
    return [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

-(void)setMoreIndicator {
    _moreIndicator.hidden = NO;
    _checkMark.hidden = YES;
}

-(void)setCheckMark {
    [self setSelected];
    _moreIndicator.hidden = YES;
    _checkMark.hidden = NO;
}

-(void)setSelected {
    self.textLabel.textColor = kTextSelectColor;
    _hinter.hidden = NO;
}

-(void)setUnselected {
    self.textLabel.textColor = kTextColor;
    _hinter.hidden = YES;
    _checkMark.hidden = YES;
}

@end



#pragma mark - NLIndexPath implements
@implementation NLIndexPath

- (instancetype)initWithSection:(NSInteger)section {
    if (self = [super init]) {
        _section = section;
        _item = -1;
        _row = -1;
    }
    return self;
}

- (instancetype)initWithSection:(NSInteger)section item:(NSInteger)item {
    if (self = [self initWithSection:section]) {
        _section = section;
        _item = item;
        _row = -1;
    }
    return self;
}

- (instancetype)initWithSection:(NSInteger)section item:(NSInteger)item row:(NSInteger)row {
    if (self = [self init]) {
        _section = section;
        _item = item;
        _row = row;
    }
    return self;
}

+ (instancetype)indexPathWithSection:(NSInteger)section {
    return [[self alloc]initWithSection:section];
	
}

+ (instancetype)indexPathWithSection:(NSInteger)section item:(NSInteger)item {
    return [[self alloc]initWithSection:section item:item];
}

+ (instancetype)indexPathWithSection:(NSInteger)section item:(NSInteger)item row:(NSInteger)row {
	return [[self alloc]initWithSection:section item:item row:row];
}

@end




#pragma mark - NLTableView实现
@interface NLTableView ()
{
    //标记方法是否实现的旗帜
    struct {
        unsigned int numberOfSectionInTableView:1;
        unsigned int titleForSectionAtIndexPath:1;
        unsigned int numberOfItemsInSection :1;
        unsigned int titleForItemAtIndexPath :1;
        unsigned int numberOfRowsInItem :1;
        unsigned int titleForRowAtIndexPath :1;
    }_dataSourceFlags;
}

@property (assign,nonatomic) BOOL  isShowItemTable;
@property (assign,nonatomic) BOOL  isShowRowTable;

@property (strong,nonatomic) UITableView * sectionTableView;
@property (strong,nonatomic) UITableView * itemTableView;
@property (strong,nonatomic) UITableView * rowTableView;
@end



@implementation NLTableView



- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)]) {
        //初始化属性
        _textColor = kTextColor;
        _textSelectedColor = kTextSelectColor;
        _fontSize = kFontSize;
        _cellBgColorFirst = kCellSelectedBgColorFirst;
        _cellBgColorSecond = kCellSelectedBgColorSecond;
        
        _isShowItemTable = NO;
        _isShowRowTable = NO;
        
        _currentIndexPath = [NLIndexPath indexPathWithSection:0 ];
        
        _sectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height) style:UITableViewStylePlain];
        _sectionTableView.dataSource = self;
        _sectionTableView.delegate = self;
        _sectionTableView.backgroundColor = [UIColor whiteColor];
        _sectionTableView.tableFooterView = [[UIView alloc]init];
        _sectionTableView.separatorInset = UIEdgeInsetsZero;
        
        _sectionTableView.estimatedRowHeight = 44;
//        _sectionTableView.rowHeight = UITableViewAutomaticDimension;
        [self addSubview:_sectionTableView];

        _itemTableView = [[UITableView alloc]initWithFrame:CGRectMake(screenSize.width, origin.y, kItemTableW, height) style:UITableViewStylePlain];
        _itemTableView.backgroundColor = kCellSelectedBgColorFirst;
        _itemTableView.tableFooterView = [[UIView alloc]init];
        _itemTableView.separatorInset = UIEdgeInsetsZero;
        _itemTableView.estimatedRowHeight = 44;
        _itemTableView.rowHeight = UITableViewAutomaticDimension;
        
        _rowTableView = [[UITableView alloc]initWithFrame:CGRectMake(screenSize.width, origin.y, kRowTableW, height) style:UITableViewStylePlain];
        _rowTableView.backgroundColor = kCellSelectedBgColorSecond;
        _rowTableView.tableFooterView = [[UIView alloc]init];
        _rowTableView.separatorInset = UIEdgeInsetsZero;
        _rowTableView.estimatedRowHeight = 44;
        _rowTableView.rowHeight = UITableViewAutomaticDimension;
        
    }
    return self;
}

#pragma mark 设置数据源
- (void)setDataSource:(id<NLTableViewDataSource>)dataSource{
    _dataSource = dataSource;
    _dataSourceFlags.numberOfSectionInTableView = [dataSource respondsToSelector:@selector(numberOfSectionInTableView:)];
    _dataSourceFlags.titleForSectionAtIndexPath = [dataSource respondsToSelector:@selector(titleForSectionAtIndexPath:)];
    
    _dataSourceFlags.numberOfItemsInSection = [dataSource respondsToSelector:@selector(tableView:numberOfItemsInSection:)];
    
    _dataSourceFlags.titleForItemAtIndexPath = [dataSource respondsToSelector:@selector(tableView:titleForItemAtIndexPath:)];
    
    _dataSourceFlags.numberOfRowsInItem = [dataSource respondsToSelector:@selector(tableView:numberOfRowsInItem:section:)];
    _dataSourceFlags.titleForRowAtIndexPath = [dataSource respondsToSelector:@selector(tableView:titleForRowAtIndexPath:)];

}

- (void)setDelegate:(id<NLTableViewDelegate>)delegate{
    _delegate = delegate;
}


#pragma mark 设置默认情况下得选择状态
- (void)selectDefalutIndexPath:(NLIndexPath *)indexPath {
	
}

#pragma mark - tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _sectionTableView) {//第一个tableview
        if (_dataSourceFlags.numberOfSectionInTableView && _dataSourceFlags.titleForSectionAtIndexPath) {
            
            return [self.dataSource numberOfSectionInTableView:self];
        }
        else{
//            NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
            return 0;
        }
    }else if (tableView == _itemTableView) {//第二级
        
        if (_dataSourceFlags.numberOfItemsInSection && _dataSourceFlags.titleForItemAtIndexPath) {
            return [_dataSource tableView:self numberOfItemsInSection:_currentIndexPath.section];
        }else{
//            NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
            return 0;
        }
        
    }else {//第三级
        if (_dataSourceFlags.numberOfRowsInItem && _dataSourceFlags.titleForRowAtIndexPath) {
            return [_dataSource tableView:self numberOfRowsInItem:_currentIndexPath.item section:_currentIndexPath.section];
        }else{
//            NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
            return 0;
        }
    }

}

- (UITableViewCell *)setCellForSectionTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NLFirstCell *cell = [NLFirstCell cell];
    
    cell.textLabel.text = [_dataSource titleForSectionAtIndexPath:[NLIndexPath indexPathWithSection:indexPath.row]];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = kTextColor;
    
    //当前被选中
    if (indexPath.row == _currentIndexPath.section) {
        cell.backgroundColor = kCellSelectedBgColorFirst;
        
        [cell setSelected];
        
        if (_dataSourceFlags.numberOfItemsInSection) {
            //如果有下一级
            if ([_dataSource tableView:self numberOfItemsInSection:indexPath.row] > 0) {
                //如果有下一级，且下一级有更多
                [cell setMoreIndicator];
            }else{
                //如果有下一级 且下一级没有更多
                [cell setCheckMark];
            }
        }else{
            //如果没有下一级
            [cell setCheckMark];
        }
    }else{//不被选中
        
        [cell setUnselected];
        //有下一级
        if (_dataSourceFlags.numberOfItemsInSection) {
            if ([_dataSource tableView:self numberOfItemsInSection:indexPath.row]>0) {
                //下一级有更多
                [cell setMoreIndicator];
            }else{
                //下一级没有更多
                cell.moreIndicator.hidden = YES;
            }
        }else{//没有下一级
            cell.moreIndicator.hidden = YES;
        }
    }
    return cell;
}


- (UITableViewCell *)setCellForItemTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    NLFirstCell *cell = [NLFirstCell cell];
    CGRect cellFrame = cell.frame;
    cellFrame.size.width = (180.0/320.0)*kScreenSize.width;
    cell.frame = cellFrame;
    cell.textLabel.text = [_dataSource tableView:self titleForItemAtIndexPath:[NLIndexPath indexPathWithSection:_currentIndexPath.section item:indexPath.row]];
    
    cell.backgroundColor = kCellSelectedBgColorFirst;
    cell.textLabel.textColor = kTextColor;
    
    
    //当前被选中
    if (indexPath.row == _currentIndexPath.item) {
        cell.backgroundColor = kCellSelectedBgColorSecond;
        
        [cell setSelected];
        
        if (_dataSourceFlags.numberOfRowsInItem) {
            //如果有下一级
            if ([_dataSource tableView:self numberOfRowsInItem:indexPath.row section:_currentIndexPath.section] > 0) {
                //如果有下一级，且下一级有更多
                [cell setMoreIndicator];
            }else{
                //如果有下一级 且下一级没有更多
                [cell setCheckMark];
            }
        }else{
            //如果没有下一级
            [cell setCheckMark];
        }
    }else{//不被选中
        
        [cell setUnselected];
        //有下一级
        if (_dataSourceFlags.numberOfRowsInItem) {
            if ([_dataSource tableView:self numberOfRowsInItem:indexPath.row section:_currentIndexPath.section] > 0) {
                //下一级有更多
                [cell setMoreIndicator];
            }else{
                //下一级没有更多
                cell.moreIndicator.hidden = YES;
            }
        }else{//没有下一级
            cell.moreIndicator.hidden = YES;
        }
    }
    return cell;

}


- (UITableViewCell *)setCellForRowTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    NLFirstCell *cell = [NLFirstCell cell];
    cell.textLabel.text = [_dataSource tableView:self titleForRowAtIndexPath:[NLIndexPath indexPathWithSection:_currentIndexPath.section item:_currentIndexPath.item row:indexPath.row]];
    
    cell.backgroundColor = kCellSelectedBgColorSecond;
    cell.moreIndicator.hidden = YES;
    cell.checkMark.hidden = YES;
    //当前被选中
    if (indexPath.row == _currentIndexPath.row) {
        
        cell.hinter.hidden = NO;
        cell.textLabel.textColor = kTextSelectColor;
        
    }else{
        cell.hinter.hidden = YES;
        cell.textLabel.textColor = kTextColor;
        
    }
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _sectionTableView) {
        return [self setCellForSectionTableView:tableView indexPath:indexPath];
    }else if (tableView == _itemTableView){
        return [self setCellForItemTableView:tableView indexPath:indexPath];
    }else{
        return [self setCellForRowTableView:tableView indexPath:indexPath];
    }
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _sectionTableView) {//第一个tableview
        _currentIndexPath.section = indexPath.row;
        [_sectionTableView reloadData];
        
        //处理section table 点击
        [self dealSectionTableClick];
        
    }else if (tableView == _itemTableView) {//第二级
        _currentIndexPath.item = indexPath.row;
        [_itemTableView reloadData];
        
        //处理item table 点击
        [self dealItemTableClick];

        
    }else {//第三级
        _currentIndexPath.row = indexPath.row;
        [_rowTableView reloadData];
        //处理 row table 点击
    
    }
    
    [_delegate tableView:self didSelectRowAtIndexPath:_currentIndexPath];

}

- (void)dealItemTableClick{
    
    _currentIndexPath.row = -1;
    if (!_isShowRowTable) {
        //row table 不显示的情况下
        
        
        if (_dataSourceFlags.numberOfRowsInItem && [_dataSource tableView:self numberOfRowsInItem:_currentIndexPath.item section:_currentIndexPath.section] > 0 ) {
            //有更多，显示row table
            [self addSubview:_rowTableView];
            _rowTableView.dataSource = self;
            _rowTableView.delegate = self;
            [_rowTableView reloadData];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect itemFrame = _itemTableView.frame;
                itemFrame.origin.x = kItemTableX;
                _itemTableView.frame = itemFrame;
                
                
                CGRect rowFrame = _rowTableView.frame;
                rowFrame.origin.x = kRowTableX;
                _rowTableView.frame = rowFrame;
                
            } completion:^(BOOL finished) {
                _isShowRowTable = YES;
            }];
            
        }else{
            //没有更多,不做操作
        }
        
        
    }else{
        //row table 显示的情况下
        if (_dataSourceFlags.numberOfRowsInItem && [_dataSource tableView:self numberOfRowsInItem:_currentIndexPath.item section:_currentIndexPath.section] > 0 ) {
            //有更多 reload rew table
            [_rowTableView reloadData];
        }else{
            //没有更多,缩后item table 缩回row table
            [UIView animateWithDuration:0.3 animations:^{
                CGRect itemFrame = _itemTableView.frame;
                itemFrame.origin.x = kItemTableOriginX;
                _itemTableView.frame = itemFrame;
                
                
                CGRect rowFrame = _rowTableView.frame;
                rowFrame.origin.x = kScreenSize.width;
                _rowTableView.frame = rowFrame;
                
                
            }completion:^(BOOL finished) {
                _isShowItemTable = YES;
                _isShowRowTable = NO;
                [_rowTableView removeFromSuperview];
            }];
        }
    }
  
}


-(void)dealSectionTableClick{

    
    if (_dataSourceFlags.numberOfItemsInSection && [_dataSource tableView:self numberOfItemsInSection:_currentIndexPath.section] > 0) {
        
        if (!_isShowItemTable) {
            //有更多，且item table 没显示 则显示item table reload
            [self addSubview:_itemTableView];
            
            _itemTableView.dataSource = self;
            _itemTableView.delegate =self;
            [_itemTableView reloadData];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect itemFrame =  _itemTableView.frame;
                itemFrame.origin.x = kItemTableOriginX;
                _itemTableView.frame = itemFrame;
                _isShowItemTable = YES;
            }];
 
        }else{
            
            if (!_isShowRowTable) {
                //有更多，且item table 有显示 row table 没有显示 reload item table
                _currentIndexPath.item = -1;
                [_itemTableView reloadData];
            }else{
                //有更多，且item table 有显示 row table 有显示，则缩后item table，缩回row table ,item table 被选-1
                [_itemTableView reloadData];
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect itemFrame = _itemTableView.frame;
                    itemFrame.origin.x = kItemTableOriginX;
                    _itemTableView.frame = itemFrame;
                    _currentIndexPath.item = -1;
                    
                    
                    CGRect rowFrame = _rowTableView.frame;
                    rowFrame.origin.x = kScreenSize.width;
                    _rowTableView.frame = rowFrame;
                    
                    _currentIndexPath.row = -1;

                }completion:^(BOOL finished) {
                    _isShowItemTable = YES;
                     _isShowRowTable = NO;
                    [_rowTableView removeFromSuperview];
                }];
            }
   
        }
        
        
    }else{
        //没有更多，则单纯显示对勾 缩回另外两个
        [UIView animateWithDuration:0.3 animations:^{
            //缩回
            CGRect itemFrame =  _itemTableView.frame;
            itemFrame.origin.x = kScreenSize.width;
            _itemTableView.frame = itemFrame;
            
            
            CGRect rowFrame =  _rowTableView.frame;
            rowFrame.origin.x = kScreenSize.width;
            _rowTableView.frame = rowFrame;
            
            
            _currentIndexPath.item = -1;
            _currentIndexPath.row = -1;
        } completion:^(BOOL finished) {
            _isShowItemTable = NO;
            _isShowRowTable = NO;
            [_itemTableView removeFromSuperview];
            [_rowTableView removeFromSuperview];
        }];
    }
    
    

}



@end
