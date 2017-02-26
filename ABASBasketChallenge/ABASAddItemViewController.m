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

@interface ABASAddItemViewController ()

@property (nonatomic, strong) UIButton *trolleyButton;

@end

@implementation ABASAddItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"ABAS Basket"];
    
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
    
    [[ABASNetworkManager sharedInstance] getBasketData];
}

#pragma mark - Navigation Actions 

- (void)trolleyPressed
{
    NSLog(@"trolley pressed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
