//
//  LDHShopCell.h
//  瀑布流
//
//  Created by lidonghan on 2018/3/29.
//  Copyright © 2018年 lidonghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDHShopModel;
@interface LDHShopCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong) LDHShopModel *shop;
@end
