//
//  customTableViewCell.h
//  GRWeatherApp
//
//  Created by Student P_07 on 19/10/16.
//  Copyright © 2016 Rane Gunjan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailyMinTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailyMaxTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailyHumidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailySunrisesLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailySunsetsLabel;

@property (strong, nonatomic) IBOutlet UILabel *dailyPressureLabel;
@end
