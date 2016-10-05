//
//  ViewController.m
//  Qmi
//
//  Created by Philip Ha on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "RestaurantViewController.h"
#import "Restaurant.h"
#import "Customer.h"
#import "QueueViewCell.h"

@interface RestaurantViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Restaurant * resturant;
@property (nonatomic) NSArray<Customer *> *queue;


@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.resturant updateQueue:self.queue withCompletionBlock:^{
        [self.tableView reloadData];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.queue count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QueueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.customerNameLabel.text = self.queue[indexPath.row].user.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.resturant removeCustomer:self.queue[indexPath.row] fromQueue:self.queue withCompletionBlock:nil];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}


@end
