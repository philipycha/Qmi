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
#import "ViewUpdateDelegate.h"
#import "AppDelegate.h"

@interface RestaurantViewController () <UITableViewDelegate, UITableViewDataSource, RestaurantDelegate, ViewUpdateDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Restaurant * resturant;
@property (nonatomic) NSArray<Customer *> *queue;


@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = [[NSArray alloc] init];
    
    //set view update delegate to self
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    
    
//    [self createTestData];
    
    [self setCurrentUsersRestaurant];
    [self.resturant updateQueue];
    
    self.title = self.resturant.name;
    
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
        newRestaurant.name = newRestaurant.user.name;
        
        self.resturant = newRestaurant;
        NSLog(@"\n New Restaurant created\n");
        [self.resturant saveInBackground];
    }
}


//TESTING FN
-(void)createTestData
{
    Restaurant *newRestaurant = [Restaurant objectWithClassName:@"Restaurant"];
    newRestaurant.user = [User currentUser];
    newRestaurant.name = newRestaurant.user.name;
    
    for(int i = 0; i < 6; i+=1)
    {
        Customer *newCustomer = [Customer customerWithUser:nil partySize:[NSString stringWithFormat:@"%d",(i+1)] andDistance:@"5 min"];
        newCustomer.queueNum = i;
        newCustomer.name = [NSString stringWithFormat:@"Customer Number %d", i];
        [newRestaurant addCustomer:newCustomer];
        [newCustomer saveInBackground];
    }
    
    self.resturant = newRestaurant;
    
    [newRestaurant saveInBackground];
}
//END TESTING FN


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.queue count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QueueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    
    cell.customerNameLabel.text = [self.queue[indexPath.row] fetchIfNeeded].name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.resturant removeCustomer:self.queue[indexPath.row]];

    }
}


#pragma mark - RestaurantDelegate

-(void)setControllerQueue:(NSArray<Customer *> *)queue
{
    self.queue = queue;
    [self.tableView reloadData];
}


#pragma mark - ViewUpdateDelegate

-(void)updateUsersView{
    [self.resturant updateQueue];
}

@end
