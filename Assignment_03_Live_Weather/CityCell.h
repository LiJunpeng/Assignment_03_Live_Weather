//
//  CityCell.h
//  Assignment_03_Live_Weather
//
//  Created by LILouis on 12/15/16.
//  Copyright © 2016 LILouis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CityCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *label;
//@property (weak, nonatomic) IBOutlet UIImageView *levelImgView;

@property (weak, nonatomic) IBOutlet UILabel *zipLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;


@end
