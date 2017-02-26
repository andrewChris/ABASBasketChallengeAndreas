//
//  ABASBasketCell.m
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 26/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import "ABASBasketCell.h"
#import "BasketItem+CoreDataClass.h"
#import "BasketItemType+CoreDataClass.h"
#import "UIColor+ABASColor.h"

@interface ABASBasketCell ()

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *price;
@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UIView *backImage;

@end


@implementation ABASBasketCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backImage.layer.borderWidth = 1.0f;
    self.backImage.layer.borderColor = [UIColor ABASBrandRed].CGColor;
    self.backImage.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.backImage.layer.masksToBounds = NO;
    self.backImage.layer.shadowOffset = CGSizeMake(1, 5);
    self.backImage.layer.shadowRadius = 1;
    self.backImage.layer.shadowOpacity = 0.5;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass([self class]);
}

#pragma mark - Set Data

- (void)setDataModel:(BasketItem *)basketItem
{
    self.name.text = basketItem.type.name;
    self.price.text = [NSString stringWithFormat:@"$%d",basketItem.price];
    
    if([basketItem.id isEqualToString:@"0"])
    {
        self.image.image = [UIImage imageNamed:@"banana"];
    }
    else if([basketItem.id isEqualToString:@"1"])
    {
        self.image.image = [UIImage imageNamed:@"detergent"];
    }
    else if([basketItem.id isEqualToString:@"2"])
    {
        self.image.image = [UIImage imageNamed:@"pasta"];
    }
}

#pragma mark - IBAction

- (IBAction)removeItemPressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(removeItemWithCell:)])
    {
        [self.delegate removeItemWithCell:self];
    }
}

@end
