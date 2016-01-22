//
//  ViewController.m
//  BonsExample
//
//  Created by Kvana Mac Pro 2 on 1/22/16.
//  Copyright © 2016 Kvana Mac Pro 2. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    UISegmentedControl *segmentController;
    UITableView *tableView;
    NSMutableArray *bonsArray;
    NSMutableArray *mainBonsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    segmentController=[[UISegmentedControl alloc]initWithItems:@[@"ALL",@"WON",@"LOSE"]];
    segmentController.frame=CGRectMake(20, 20, self.view.frame.size.width-40, 50);
    [segmentController addTarget:self action:@selector(filterSelected:) forControlEvents:UIControlEventValueChanged];
    segmentController.selectedSegmentIndex=0;
    [self.view addSubview:segmentController];
    
    bonsArray=[[NSMutableArray alloc]init];
    mainBonsArray=[[NSMutableArray alloc]init];
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(20, segmentController.frame.origin.y+segmentController.frame.size.height+20, self.view.frame.size.width-40, self.view.frame.size.height-(segmentController.frame.origin.y+segmentController.frame.size.height+20+20))];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor redColor];
    [self.view addSubview:tableView];
    
   
    [self getDataFromServer];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bonsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"BONSCELL";
    UITableViewCell *cell=[tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    PFObject *currrentObject=[bonsArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[currrentObject valueForKey:@"geoAddress"];
    return cell;
    
    
}
-(void)filterSelected:(UISegmentedControl*)segemtView{
    [bonsArray removeAllObjects];
    [tableView reloadData];
    [self getDataFromServer];
//    NSInteger selectedIndex=segemtView.selectedSegmentIndex;
//    if (selectedIndex==0) {
//        [bonsArray removeAllObjects];
//        [bonsArray addObjectsFromArray:mainBonsArray];
//        [tableView reloadData];
//    }else if (selectedIndex==1){
//        [bonsArray removeAllObjects];
//        for(PFObject *object in mainBonsArray){
//            if ([[object valueForKey:@"hasWon"] boolValue]) {
//                [bonsArray addObject:object];
//            }
//        }
//        [tableView reloadData];
//    }else if (selectedIndex==2){
//        [bonsArray removeAllObjects];
//        for(PFObject *object in mainBonsArray){
//            if (![[object valueForKey:@"hasWon"] boolValue]) {
//                [bonsArray addObject:object];
//            }
//        }
//        [tableView reloadData];
//    }
}
-(void)getDataFromServer{
    PFQuery *query=[PFQuery queryWithClassName:@"bons"];
    if (segmentController.selectedSegmentIndex==1) {
        [query whereKey:@"hasWon" equalTo:[NSNumber numberWithBool:YES]];
    }
    if (segmentController.selectedSegmentIndex==1) {
        [query whereKey:@"hasWon" equalTo:[NSNumber numberWithBool:NO]];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [mainBonsArray removeAllObjects];
        [mainBonsArray addObjectsFromArray:objects];
        [bonsArray removeAllObjects];
        [bonsArray addObjectsFromArray:objects];
        [tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
