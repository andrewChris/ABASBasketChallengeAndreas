//
//  ABASAddItemViewController.m
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import "ABASAddItemViewController.h"
#import "UIColor+ABASColor.h"
#import "ABASNetworkManager.h"
#import "ABASViewBasketViewController.h"
#import "ABASCoreDataManager.h"
#import "ABASAddItemCell.h"
#import "Basket+CoreDataClass.h"
#import "BasketItem+CoreDataClass.h"

static NSString * const VIEW_BASKET_SEGUE = @"viewBasketController";

@interface ABASAddItemViewController () <UITableViewDelegate, UITableViewDataSource, ABASAddItemCellDelegate>

@property (nonatomic, strong) UIButton *trolleyButton;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *itemsDatasource;
@property (nonatomic, strong) Basket *localBasket;

@end

@implementation ABASAddItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Add Item"];
    
    [self.tableView registerNib:[ABASAddItemCell nib] forCellReuseIdentifier:[ABASAddItemCell cellReuseIdentifier]];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.barStyle        = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor    = [UIColor ABASBrandRed];
    self.navigationController.navigationBar.tintColor       = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent     = NO;
    
    self.trolleyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.trolleyButton setFrame:CGRectMake(0, 0, 35, 35)];
    [self.trolleyButton setImage:[UIImage imageNamed:@"trolley"] forState:UIControlStateNormal];
    [self.trolleyButton addTarget:self action:@selector(trolleyPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.trolleyButton];
    
    //Load available items to buy
    self.itemsDatasource = [[ABASCoreDataManager sharedInstance] getBasketItems];
    
    //Load basket items if available
    self.localBasket = [[ABASCoreDataManager sharedInstance] getBasket];
    
    if(self.localBasket == nil)
    {
        [[ABASNetworkManager sharedInstance] createNewBasketWithCompletion:^(BOOL success, NSString *iD, NSString *name) {
            if(success)
            {
                [[ABASCoreDataManager sharedInstance] createBasketWithId:iD withName:name];
                self.localBasket = [[ABASCoreDataManager sharedInstance] getBasket];
            }
        }];
    }
}

#pragma mark - Navigation Actions 

- (void)trolleyPressed
{
    NSLog(@"trolley pressed");
    [self performSegueWithIdentifier:VIEW_BASKET_SEGUE sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsDatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABASAddItemCell *addItemCell = [tableView dequeueReusableCellWithIdentifier:[ABASAddItemCell cellReuseIdentifier] forIndexPath:indexPath];
    
    [addItemCell setDataModel:[self.itemsDatasource objectAtIndex:indexPath.row]];
    [addItemCell setDelegate:self];
    
    return addItemCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ABASAddItemCellDelegate Delegate 

- (void)itemAddedWithCell:(ABASAddItemCell *)cell
{
    NSInteger cellIndex = [self.tableView indexPathForCell:cell].row;
    BasketItem *basketItem = [self.itemsDatasource objectAtIndex:cellIndex];
    [self addItemToBasket:basketItem];
}

#pragma mark - Add to basket 

- (void)addItemToBasket:(BasketItem *)itemToAdd
{
    //API NOT IMPLEMENTED FOR BASKET ITEMS OR TYPES, METHODS ARE AVAILABLE IN ABASNETWORKMANAGER
    
    if(self.localBasket !=nil)
    {
        NSMutableArray *allObjects = [NSMutableArray arrayWithArray:[self.localBasket.contents allObjects]];
        
        if(![allObjects containsObject:itemToAdd])
        {
            [allObjects addObject:itemToAdd];
            NSMutableSet *set = [[NSMutableSet alloc]initWithArray:allObjects];
            self.localBasket.contents = set;
            [[ABASCoreDataManager sharedInstance] saveContext];
            [self performSegueWithIdentifier:VIEW_BASKET_SEGUE sender:nil];
        }
    }
}


@end
