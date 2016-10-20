//
//  ViewController.h
//  GRWeatherApp
//
//  Created by Student P_07 on 19/10/16.
//  Copyright © 2016 Rane Gunjan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#define KWeatherAPIKey "ec7b702f57bc6748652d1c02abc145c7"
#import "customTableViewCell.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate>

{
    
    CLLocationManager *myLocation;
    
    NSString *latitude;
    
    NSString *longitude;
    
    NSArray *list;
    
    
}



- (IBAction)startDetectingAction:(id)sender;



@property (strong, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentConditionLabel;
@property (strong, nonatomic) IBOutlet UILabel *CityLabel;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UITableView *forecastTableView;
@property (strong, nonatomic) IBOutlet UIButton *startDetectingAction;

@end

