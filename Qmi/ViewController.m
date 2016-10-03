//
//  ViewController.m
//  Qmi
//
//  Created by Philip Ha on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "ViewController.h"
#import "Resturant.h"
#import "QueueViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Resturant * resturant;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.resturant.queue count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QueueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.customerNameLabel.text = [self.resturant.queue[indexPath.row] name];
    
    return cell;
}

@end
