//
//  ABASAddItemCell.h
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABASAddItemCell;
@class BasketItem;

@protocol ABASAddItemCellDelegate <NSObject>

- (void)itemAddedWithCell:(ABASAddItemCell *)cell;

@end

@interface ABASAddItemCell : UITableViewCell

@property (nonatomic, assign) id<ABASAddItemCellDelegate> delegate;

+ (UINib *)nib;
+ (NSString *)cellReuseIdentifier;

- (void)setDataModel:(BasketItem *)basketItem;

@end
