//
//  cityDetailPageViewController.m
//  Assignment_03_Live_Weather
//
//  Created by LILouis on 12/17/16.
//  Copyright © 2016 LILouis. All rights reserved.
//

//
//  addCityPageViewController.m
//  Assignment_03_Live_Weather
//
//  Created by LILouis on 12/17/16.
//  Copyright © 2016 LILouis. All rights reserved.
//


#import "cityDetailPageViewController.h"

#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface cityDetailPageViewController ()

@property (strong, nonatomic) UILabel *cityNameLabel;
@property (strong, nonatomic) UILabel *currentTempLabel;
@property (strong, nonatomic) UILabel *currentLowTempLabel;
@property (strong, nonatomic) UILabel *currentHighTempLabel;
@property (strong, nonatomic) UILabel *currentWeatherLabel;
@property (strong, nonatomic) UILabel *currentWeatherLogoLabel;

@end

@implementation cityDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    _cityNameLabel.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2 + 40);
    _cityNameLabel.textAlignment = NSTextAlignmentCenter;
    _cityNameLabel.textColor = [UIColor whiteColor];
    _cityNameLabel.backgroundColor = [UIColor clearColor];
    [_cityNameLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.view addSubview:_cityNameLabel];
    
    _currentWeatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    _currentWeatherLabel.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2 - 40);
    _currentWeatherLabel.textAlignment = NSTextAlignmentCenter;
    _currentWeatherLabel.textColor = [UIColor whiteColor];
    _currentWeatherLabel.backgroundColor = [UIColor clearColor];
    [_currentWeatherLabel setFont:[UIFont boldSystemFontOfSize:32.0]];
    [self.view addSubview:_currentWeatherLabel];

    _currentTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth / 3 + 100, 150)];
    _currentTempLabel.center = CGPointMake(ScreenWidth / 2 - 60, ScreenHeight / 2 + 150);
    _currentTempLabel.textAlignment = NSTextAlignmentRight;
    _currentTempLabel.textColor = [UIColor whiteColor];
    _currentTempLabel.backgroundColor = [UIColor clearColor];
    [_currentTempLabel setFont:[UIFont boldSystemFontOfSize:72.0]];
    [self.view addSubview:_currentTempLabel];
    
    _currentHighTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _currentHighTempLabel.center = CGPointMake(ScreenWidth * 4 / 6 + 50, ScreenHeight / 2 + 120);
    _currentHighTempLabel.textAlignment = NSTextAlignmentCenter;
    _currentHighTempLabel.textColor = [UIColor whiteColor];
    _currentHighTempLabel.backgroundColor = [UIColor clearColor];
    [_currentHighTempLabel setFont:[UIFont boldSystemFontOfSize:32.0]];
    [self.view addSubview:_currentHighTempLabel];
    
    _currentLowTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _currentLowTempLabel.center = CGPointMake(ScreenWidth * 4 / 6 + 50, ScreenHeight / 2 + 180);
    _currentLowTempLabel.textAlignment = NSTextAlignmentCenter;
    _currentLowTempLabel.textColor = [UIColor whiteColor];
    _currentLowTempLabel.backgroundColor = [UIColor clearColor];
    [_currentLowTempLabel setFont:[UIFont boldSystemFontOfSize:32.0]];
    [self.view addSubview:_currentLowTempLabel];
    
    UIFont *font = [UIFont fontWithName:@"CLIMACONS_FONT" size:72];
    _currentWeatherLogoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    _currentWeatherLogoLabel.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2 - 100);
    _currentWeatherLogoLabel.textAlignment = NSTextAlignmentCenter;
    _currentWeatherLogoLabel.textColor = [UIColor whiteColor];
    _currentWeatherLogoLabel.backgroundColor = [UIColor clearColor];
    [_currentWeatherLogoLabel setFont:font];
    _currentWeatherLogoLabel.text = [NSString stringWithFormat:@"%c", 'A'];
    [self.view addSubview:_currentWeatherLogoLabel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *weatherArray = _weatherInfo[@"weather"];
    NSMutableDictionary *mainWeather = weatherArray[0];
    NSMutableDictionary *tempInfo = _weatherInfo[@"main"];
    //NSString *currentTempString = [[NSString stringWithFormat:@"%.02f", tempInfo[@"temp"]] stringByAppendingString:@"\u00B0"];
    
    _cityNameLabel.text = _weatherInfo[@"name"];
    _currentWeatherLabel.text = mainWeather[@"main"];
    _currentTempLabel.text = [[tempInfo[@"temp"] stringValue] stringByAppendingString:@"\u00B0"];
    _currentHighTempLabel.text = [[tempInfo[@"temp_max"] stringValue] stringByAppendingString:@"\u00B0"];
    _currentLowTempLabel.text = [[tempInfo[@"temp_min"] stringValue] stringByAppendingString:@"\u00B0"];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
