//
//  lDHFlowLayout.m
//  瀑布流
//
//  Created by lidonghan on 2018/3/29.
//  Copyright © 2018年 lidonghan. All rights reserved.
//

#import "lDHFlowLayout.h"

//默认列的间隔
static const CGFloat LDHDefaultColumnMargin = 10;
//默认行的间隔
static const CGFloat LDHDefaultRowMargin = 10;
//默认列数
static const NSInteger LDHDefaultCount = 3;
//默认四边距
static const UIEdgeInsets LDHInsets = {10,10,10,10};


@interface lDHFlowLayout()

/**
 存储cell的对应属性
 */
@property (nonatomic,strong) NSMutableArray  *attrsArray;
//存储所有列的高度
@property (nonatomic,strong) NSMutableArray  *columnHeights;

/**
 内容高度
 */
@property (nonatomic,assign) CGFloat  contentHeight;
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end

@implementation lDHFlowLayout
#pragma 常用数据处理
- (CGFloat)rowMargin{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(rowMarginInlDHFlowLayout:)]) {
        return [self.delegate rowMarginInlDHFlowLayout:self];
    }else{
        return LDHDefaultRowMargin;
    }
}
- (CGFloat)columnMargin{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(columnMarginInlDHFlowLayout:)]) {
        return [self.delegate columnMarginInlDHFlowLayout:self];
    }else{
        return LDHDefaultColumnMargin;
    }
}
- (NSInteger)columnCount{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(columnCountInlDHFlowLayout:)]) {
        return [self.delegate columnCountInlDHFlowLayout:self];
    }else{
        return LDHDefaultCount;
    }
}
- (UIEdgeInsets)edgeInsets{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(edgeInsetsInlDHFlowLayout:)]) {
        return [self.delegate edgeInsetsInlDHFlowLayout:self];
    }else{
        return LDHInsets;
    }
}
#pragma 懒加载
- (NSMutableArray *)attrsArray {
    if(!_attrsArray){
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeights {
    if(!_columnHeights){
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}


/**
 初始化属性
 */
- (void)prepareLayout{
    
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    
    for (NSInteger i=0; i<self.columnCount; i++) {
       
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    
    }
    
    //清除之前所有布局
    [self.attrsArray removeAllObjects];
    
    //开始创建每一个cell的布局
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i=0; i<count; i++) {
        //创建位置
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        //开始创建index 对应的布局
        UICollectionViewLayoutAttributes *atts = [self layoutAttributesForItemAtIndexPath:index];
        [self.attrsArray addObject:atts];
    }
    
}

/**
 返回每一个cell对应的属性
 */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrsArray;
}

/**
 

返回cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //创建布局
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGFloat collectionviewW = self.collectionView.frame.size.width;
    
    CGFloat w = (collectionviewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1)*self.columnMargin)/self.columnCount;
    
    CGFloat h = [self.delegate lDHFlowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    //每次新建cell 在列高最短的列后面添加
    
    NSInteger destColumn = 0;//默认最短列在第0列
    
    CGFloat minColumnH = [self.columnHeights[0] doubleValue];//第0列的高度
    
    for (NSInteger i = 1; i<self.columnCount; i++) {
        
        CGFloat columnH = [self.columnHeights[i] doubleValue];
        
        if (minColumnH > columnH) {
           
            minColumnH = columnH;
            
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    
    CGFloat y = minColumnH;
    if (y != self.edgeInsets.top) {
        
        y += self.rowMargin;
    }
    
    attrs.frame = CGRectMake(x,y,w,h);
    
    //跟新最短列的高度
    
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
 
    CGFloat columnheight = [self.columnHeights[destColumn] doubleValue];
    
    if (self.contentHeight < columnheight) {
        self.contentHeight  = columnheight;
    }
    return attrs;
}

/**
 
返回collectionView 内容大小
 */
- (CGSize)collectionViewContentSize{
    
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
    
}
@end
