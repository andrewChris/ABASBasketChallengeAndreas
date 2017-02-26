//
//  ABASViewBasketViewController.m
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import "ABASViewBasketViewController.h"
#import "ABASCoreDataManager.h"
#import "Basket+CoreDataClass.h"
#import "ABASNetworkManager.h"
#import "ABASBasketCell.h"

@interface ABASViewBasketViewController () <UITableViewDelegate, UITableViewDataSource, ABASBasketCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *basketDatasource;
@property (nonatomic, strong) Basket *localBasket;
@property (nonatomic, strong) NSArray *itemsInBasketArray;

@end

@implementation ABASViewBasketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self setTitle:@"ABAS Basket"];
    
    [self.tableView registerNib:[ABASBasketCell nib] forCellReuseIdentifier:[ABASBasketCell cellReuseIdentifier]];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Load basket items if available
    self.localBasket = [[ABASCoreDataManager sharedInstance] getBasket];
    
    if(self.localBasket == nil)
    {
        [[ABASNetworkManager sharedInstance] createNewBasketWithCompletion:^(BOOL success, NSString *iD, NSString *name) {
            if(success)
            {
                [[ABASCoreDataManager sharedInstance] createBasketWithId:iD withName:name];
                self.localBasket = [[ABASCoreDataManager sharedInstance] getBasket];
                self.itemsInBasketArray = [self.localBasket.contents allObjects];
                 //Sort data by price
                [self sortData];
            }
        }];
    }
    else
    {
        self.itemsInBasketArray = [self.localBasket.contents allObjects];
        //Sort data by price
        [self sortData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sort Data

- (void)sortData
{
    if(self.itemsInBasketArray.count)
    {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray = [self.itemsInBasketArray sortedArrayUsingDescriptors:sortDescriptors];
        
        self.itemsInBasketArray = sortedArray;
        
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.localBasket!=nil)
    {
        return self.itemsInBasketArray.count;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABASBasketCell *basketItemCell = [tableView dequeueReusableCellWithIdentifier:[ABASBasketCell cellReuseIdentifier] forIndexPath:indexPath];
    
    [basketItemCell setDelegate:self];
    
    [basketItemCell setDataModel:[self.itemsInBasketArray objectAtIndex:indexPath.row]];
    
    return basketItemCell;
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

#pragma mark - ABASBasketCellDelegate

- (void)removeItemWithCell:(ABASBasketCell *)cell
{
    NSInteger cellIndex = [self.tableView indexPathForCell:cell].row;
    BasketItem *basketItem = [self.itemsInBasketArray objectAtIndex:cellIndex];
    [self removeItemFromBasket:basketItem];
}

#pragma mark - Remove Item

- (void)removeItemFromBasket:(BasketItem *)basketItem
{
    //API NOT IMPLEMENTED
    
    if(self.localBasket !=nil)
    {
        NSMutableArray *allObjects = [NSMutableArray arrayWithArray:[self.localBasket.contents allObjects]];
        
        if([allObjects containsObject:basketItem])
        {
            [allObjects removeObject:basketItem];
            NSMutableSet *set = [[NSMutableSet alloc]initWithArray:allObjects];
            self.localBasket.contents = set;
            [[ABASCoreDataManager sharedInstance] saveContext];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
