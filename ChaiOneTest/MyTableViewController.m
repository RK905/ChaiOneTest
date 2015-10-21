//
//  TableViewController.m
//  ChaiOneTest
//
//  Created by Rayen Kamta on 10/20/15.
//  Copyright © 2015 Geeksdobyte. All rights reserved.
//

#import "MyTableViewController.h"
#import "AFNetworking.h"
#import "MyCell.h"
#import <QuartzCore/QuartzCore.h>
static NSString * const BaseURLString = @"https://alpha-api.app.net/stream/0/posts/stream/global";
NSDictionary *postDict;
NSMutableArray *itemsCount;
NSMutableArray *avatarUrl;
NSMutableArray *postTitle;
NSMutableArray *postDesc;



@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self startdownload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itemsCount.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    myCell.userName.text = [postTitle objectAtIndex:indexPath.row];
    myCell.postDes.text = [postDesc objectAtIndex:indexPath.row];
    
    
    NSURL *imageURL = [NSURL URLWithString:[avatarUrl objectAtIndex:indexPath.row]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            myCell.avatarImg.image = [UIImage imageWithData:imageData];
            myCell.avatarImg.layer.cornerRadius =myCell.avatarImg.frame.size.width /2;
            myCell.avatarImg.clipsToBounds = true;
            
            
        });
        
        
    });

    
    
    return myCell;
}


-(void)startdownload{
    NSString *string = [NSString stringWithFormat:BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        postDict = (NSDictionary *)responseObject;
        itemsCount =[postDict objectForKey:@"data"];
        NSLog(@"%lu",(unsigned long)itemsCount.count);
        postTitle = [[[postDict objectForKey:@"data"]valueForKey:@"user"]valueForKey:@"username"];
        NSLog(@"%lu",(unsigned long)postTitle.count);
        avatarUrl = [[[[postDict objectForKey:@"data"]valueForKey:@"user"]valueForKey:@"avatar_image"]valueForKey:@"url"];
        NSLog(@"%lu",(unsigned long)avatarUrl.count);
        postDesc = [[postDict objectForKey:@"data"]valueForKey:@"text"];

        
        [self.tableView reloadData];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//     MyCell *myCell = [[MyCell alloc] init];
//    myCell.postDes.text = [postDesc objectAtIndex:indexPath.row];
//    
//    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
//    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
//    // in the UITableViewCell subclass
//    [myCell setNeedsLayout];
//    [myCell layoutIfNeeded];
//    
//    // Get the actual height required for the cell
//    CGFloat height = [myCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    // Add an extra point to the height to account for the cell separator, which is added between the bottom
//    // of the cell's contentView and the bottom of the table view cell.
//    height += 1;
//    
//    return height;
//}

@end
