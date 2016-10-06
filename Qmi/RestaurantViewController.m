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

@interface RestaurantViewController () <UITableViewDelegate, UITableViewDataSource, RestaurantDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Restaurant * resturant;
@property (nonatomic) NSArray<Customer *> *queue;


@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = [[NSArray alloc] init];
    
    [self setCurrentUsersRestaurant];
    
    
//    [self createTestData];
    
    
    [self.resturant updateQueue:self.queue withCompletionBlock:^{
    }];
    
    
}


-(void)setCurrentUsersRestaurant{
    User *user = [User currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query whereKey:@"user" equalTo:user];
    NSArray *restaurants = [query findObjects];
    if([restaurants firstObject])
    {
        self.resturant = [restaurants firstObject];
        self.resturant.delegate = self;
    }
    else{
        Restaurant *newRestaurant = [Restaurant objectWithClassName:@"Restaurant"];
        newRestaurant.user = [User currentUser];
        self.resturant = newRestaurant;
        NSLog(@"\n New Restaurant created\n");
        [self.resturant saveInBackground];
    }
    
}


//TESTING
//-(void)createTestData
//{
//    Customer *c1 = [Customer customerWithUser:nil partySize:@"4" andCurentLocation:nil];
//    Customer *c2 = [Customer customerWithUser:nil partySize:@"5" andCurentLocation:nil];
//    Customer *c3 = [Customer customerWithUser:nil partySize:@"8" andCurentLocation:nil];
//    Customer *c4 = [Customer customerWithUser:nil partySize:@"2" andCurentLocation:nil];
//    
//    Restaurant *newRestaurant = [Restaurant objectWithClassName:@"Restaurant"];
//    
//    newRestaurant.user = [User currentUser];
//    self.resturant = newRestaurant;
//    
//    [newRestaurant addCustomer:c1 toQueue:self.queue withCompletionBlock:nil];
//    [newRestaurant addCustomer:c2 toQueue:self.queue withCompletionBlock:nil];
//    [newRestaurant addCustomer:c3 toQueue:self.queue withCompletionBlock:nil];
//    [newRestaurant addCustomer:c4 toQueue:self.queue withCompletionBlock:nil];
//    
//    
//    [newRestaurant saveInBackground];
//    [c1 saveInBackground];
//    [c2 saveInBackground];
//    [c3 saveInBackground];
//    [c4 saveInBackground];
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.queue count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QueueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    
    cell.customerNameLabel.text = [self.queue[indexPath.row].user fetchIfNeeded].name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.resturant removeCustomer:self.queue[indexPath.row] fromQueue:self.queue withCompletionBlock:nil];
//        [self.tableView beginUpdates];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
    }
}


#pragma mark - RestaurantDelegate

-(void)setControllerQueue:(NSArray<Customer *> *)queue
{
    self.queue = queue;
    [self.tableView reloadData];
}

@end
