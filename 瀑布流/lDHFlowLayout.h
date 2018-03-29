//
//  lDHFlowLayout.h
//  瀑布流
//
//  Created by lidonghan on 2018/3/29.
//  Copyright © 2018年 lidonghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class lDHFlowLayout;
@protocol lDHFlowLayoutDelegate
@required
- (CGFloat)lDHFlowLayout:(lDHFlowLayout*)lDHFlowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;
@optional
- (NSInteger)columnCountInlDHFlowLayout:(lDHFlowLayout*)lDHFlowLayout;
- (CGFloat)columnMarginInlDHFlowLayout:(lDHFlowLayout*)lDHFlowLayout;
- (CGFloat)rowMarginInlDHFlowLayout:(lDHFlowLayout*)lDHFlowLayout;
- (UIEdgeInsets)edgeInsetsInlDHFlowLayout:(lDHFlowLayout*)lDHFlowLayout;
@end
@interface lDHFlowLayout : UICollectionViewLayout
@property (nonatomic,weak) id<lDHFlowLayoutDelegate> delegate;

@end
