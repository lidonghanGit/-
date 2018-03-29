//
//  ViewController.m
//  瀑布流
//
//  Created by lidonghan on 2018/3/29.
//  Copyright © 2018年 lidonghan. All rights reserved.
//

#import "ViewController.h"
#import "LDHShopModel.h"
#import "LDHShopCell.h"
#import  <MJRefresh.h>
#import  <MJExtension.h>
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,lDHFlowLayoutDelegate>
@property (nonatomic,strong) UICollectionView *collection_View;
@property (nonatomic,strong) NSMutableArray  *cellArray;
@end

static NSString * const cellID = @"cell";

@implementation ViewController

- (NSMutableArray *)cellArray {
    if(!_cellArray){
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self layOutUI];
   
    [self upRefresh];

}

- (void)upRefresh{

   self.collection_View.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collection_View.mj_header beginRefreshing];
    
    self.collection_View.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collection_View.mj_footer.hidden = YES;
}
- (void)loadNewShops{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *array = [LDHShopModel mj_objectArrayWithFilename:@"1.plist"];
        
        [self.cellArray removeAllObjects];
        
        [self.cellArray addObjectsFromArray:array];
        
        [self.collection_View reloadData];
        
        [self.collection_View.mj_header endRefreshing];
    });
 
}

- (void)loadMoreShops{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        NSArray *array = [LDHShopModel mj_objectArrayWithFilename:@"1.plist"];
        
        [self.cellArray addObjectsFromArray:array];
        
        [self.collection_View reloadData];
        
        [self.collection_View.mj_footer endRefreshing];  
    });
    
}

- (void)layOutUI{
    
    lDHFlowLayout *LDHFlow = [[lDHFlowLayout alloc] init];
    
    LDHFlow.delegate = self;
    
    _collection_View = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:LDHFlow];
    
    _collection_View.backgroundColor = [UIColor whiteColor];
    
    _collection_View.delegate = self;
    
    _collection_View.dataSource = self;
    
    [self.view addSubview:_collection_View];
    
    //注册 cell
    [_collection_View registerNib:[UINib nibWithNibName:NSStringFromClass([LDHShopCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collection_View.mj_footer.hidden = self.cellArray.count == 0;
    return self.cellArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LDHShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
   
    cell.shop = self.cellArray[indexPath.item];
    
    return cell;
}

#pragma lDHFlowLayoutDelegate
- (CGFloat)lDHFlowLayout:(lDHFlowLayout *)lDHFlowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth{
    
    LDHShopModel *model = self.cellArray[index];
    
    return itemWidth * model.h/model.w;
    
}
- (NSInteger)columnCountInlDHFlowLayout:(lDHFlowLayout *)lDHFlowLayout{
    return 4;
}
//- (CGFloat)rowMarginInlDHFlowLayout:(lDHFlowLayout *)lDHFlowLayout{
//
//    return 30;
//}
//
//- (CGFloat)columnMarginInlDHFlowLayout:(lDHFlowLayout *)lDHFlowLayout{
//
//    return 40;
//}
//- (UIEdgeInsets)edgeInsetsInlDHFlowLayout:(lDHFlowLayout *)lDHFlowLayout{
//
//    return UIEdgeInsetsMake(150, 20, 10, 30);
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
