//
//  ABASBasketCell.h
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 26/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BasketItem;
@class ABASBasketCell;

@protocol ABASBasketCellDelegate <NSObject>

- (void)removeItemWithCell:(ABASBasketCell *)cell;

@end

@interface ABASBasketCell : UITableViewCell

@property (nonatomic, assign) id<ABASBasketCellDelegate> delegate;

+ (UINib *)nib;
+ (NSString *)cellReuseIdentifier;

- (void)setDataModel:(BasketItem *)basketItem;

@end
