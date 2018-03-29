//
//  LDHShopCell.m
//  瀑布流
//
//  Created by lidonghan on 2018/3/29.
//  Copyright © 2018年 lidonghan. All rights reserved.
//

#import "LDHShopCell.h"
#import "LDHShopModel.h"
#import <UIImageView+WebCache.h>
@implementation LDHShopCell

- (void)setShop:(LDHShopModel *)shop{
    
    _shop = shop;
    
    self.priceLabel.text = shop.price;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading.png"]];
}

@end
