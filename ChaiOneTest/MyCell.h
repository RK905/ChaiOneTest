//
//  MyCell.h
//  ChaiOneTest
//
//  Created by Rayen Kamta on 10/21/15.
//  Copyright © 2015 Geeksdobyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *postDes;
@end
