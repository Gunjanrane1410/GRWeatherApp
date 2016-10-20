//
//  ViewController.m
//  GRWeatherApp
//
//  Created by Student P_07 on 19/10/16.
//  Copyright © 2016 Rane Gunjan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startLocating{
    
    self.latitudeLabel.text = @"";
    self.longitudeLabel.text = @"";
    myLocation = [[CLLocationManager alloc]init];
    
    myLocation.delegate = self;
    
    [myLocation setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [myLocation requestWhenInUseAuthorization];
    
    [myLocation startUpdatingLocation];
    
    
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    self.latitudeLabel.text = @"";
    self.longitudeLabel.text = @"";
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"Latitude:%0.2f",currentLocation.coordinate.latitude);
    NSLog(@"Longitude:%0.2f",currentLocation.coordinate.longitude);
    
    
    latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    if (currentLocation != nil) {
        [myLocation stopUpdatingLocation];
        
    }
    
    [self getCurrentWeatherDataWithLatitude:latitude longitude:longitude APIKey:@KWeatherAPIKey];
    // [self getForcastWeatherDataWithLatitude:latitude longitude:longitude APIKey:@KWeatherAPIKey];
    
    [self getForecastWeatherDataWithLatitude:latitude longitude:longitude APIKey:@KWeatherAPIKey];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.localizedDescription);
    
}



////////////////////////////////////////////////////////////////////////////////////





-(void)getCurrentWeatherDataWithLatitude:(NSString *) latitude
                               longitude:(NSString *) longitude
                                  APIKey:(NSString *)key {
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=%@&units=metric",latitude,longitude,key];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
            NSLog(@"error:%@",error.localizedDescription);
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        //start json parsing
                        
                        
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            //alert
                        }
                        else{
                            
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:NO];
                            
                        }
                    }
                    else {
                        //alert
                    }
                }
                else {
                    //alert
                }
            }
            else {
                //alert
            }
        }
    }];
    
    [task resume];
    
}



-(void)getForecastWeatherDataWithLatitude:(NSString *) latitude
                                longitude:(NSString *) longitude
                                   APIKey:(NSString *)key {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=7&mode=json&appid=%@&units=metric",latitude,longitude,key];
    
    
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
            NSLog(@"error:%@",error.localizedDescription);
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        //start json parsing
                        
                        
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            //alert
                        }
                        else{
                            [self performSelectorOnMainThread:@selector(updateUIForForcast:) withObject:jsonDictionary waitUntilDone:NO];
                            
                        }
                    }
                    else {
                        //alert
                    }
                }
                else {
                    //alert
                }
            }
            else {
                //alert
            }
        }
    }];
    
    [task resume];
    
}

-(void)updateUIForForcast:(NSDictionary *)resultDictionary {
    
    list = [resultDictionary valueForKey:@"list"];
    
    
    [self.forecastTableView reloadData];

}


-(void)updateUI:(NSDictionary *)currentResultDictionary {
    
    NSLog(@"%@",currentResultDictionary);
    
    
    
    NSString *temperature = [NSString stringWithFormat:@"%@",[currentResultDictionary valueForKeyPath:@"main.temp"]];
    
    NSLog(@"\n\nTEMPERATURE BEFORE : %@",temperature);
    
    int temp = temperature.intValue;
    
    temperature = [NSString stringWithFormat:@"%d °C",temp];
    
    
    NSLog(@"\n\nTEMPERATURE AFTER: %@",temperature);
    
    NSArray *weather = [currentResultDictionary valueForKey:@"weather"];
    
    NSLog(@"%@",weather);
    
    NSDictionary *weatherDictionary = weather.firstObject;
    
    
    
    
    NSString *condition = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
    NSLog(@"%@",condition);
    
    
    NSString *city = [NSString stringWithFormat:@"%@",[currentResultDictionary valueForKey:@"name"]];
    
    
    self.CityLabel.text = city;
    self.currentConditionLabel.text = condition.capitalizedString;
    self.currentTemperatureLabel.text = temperature;
    
    

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return list.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    customTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weather_cell"];
    
    
    NSDictionary *dailyDictionary = [list objectAtIndex:indexPath.row];
    
    
    NSString *unix = [dailyDictionary valueForKey:@"dt"];
    
    
    NSLog(@"%d",unix.intValue);
    
    
    
    double unixTimeStamp = unix.intValue;
    
    NSTimeInterval _interval  =   unixTimeStamp;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:_interval];
    
    //NSDateFormatter *formatterDate= [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterDay= [[NSDateFormatter alloc] init];
    
    //NSDateFormatter *formatterHours= [[NSDateFormatter alloc] init];
    
    
   // [formatterDate setLocale:[NSLocale currentLocale]];
    [formatterDay setLocale:[NSLocale currentLocale]];
    
    //[formatterHours setLocale:[NSLocale currentLocale]];
    
    
   // [formatterDate setDateFormat:@"MMMM dd yyyy"];
    
    [formatterDay setDateFormat:@"EEEE"];
    
    //[formatterHours setDateFormat:@"HH:mm:ss"];
    
    
    //NSString *dateString = [formatterDate stringFromDate:date];
    NSString *dayString = [formatterDay stringFromDate:date];
   // NSString *hoursString = [formatterHours stringFromDate:date];
    
    
   // NSLog(@"%@",dateString);
    NSLog(@"%@",dayString);
   // NSLog(@"%@",hoursString);

    
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//    
//    cell.textLabel.text = day;
//    cell.detailTextLabel.text = [[[tempDic valueForKey:@"max"] stringByAppendingString:@" "]stringByAppendingString:[tempDic valueForKey:@"min"]];
//    
//    

    
    NSLog(@"%@",dailyDictionary);
    
    
    
    
    
    cell.dayLabel.text = [NSString stringWithFormat:@"%@",dayString];

    
    cell.dailyMinTempLabel.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"temp.min"]];
    
    cell.dailyMaxTempLabel.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"temp.max"]];

    cell.dailyPressureLabel.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKey:@"pressure"]];
    
    
    cell.dailyHumidityLabel.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKey:@"humidity"]];
    
    cell.dailySunrisesLabel.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"temp.morn"]];
    
    cell.dailySunsetsLabel.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"temp.night"]];
    
    
    
    return  cell;
}





- (IBAction)startDetectingAction:(id)sender {
    
    
    [self startLocating];

}
@end
