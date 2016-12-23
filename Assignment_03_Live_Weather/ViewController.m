//
//  ViewController.m
//  Assignment_03_Live_Weather
//
//  Created by LILouis on 12/15/16.
//  Copyright © 2016 LILouis. All rights reserved.
//

#import "ViewController.h"
#import "CityCell.h"
#import "addCityPageViewController.h"
#import "cityDetailPageViewController.h"

#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@property NSString *apiURL;
@property NSString *tempUnit;
@property NSMutableArray *cityZipList;
@property (nonatomic, strong) UITableView *cityWeatherTable;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *switchUnitButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _apiURL = @"http://api.openweathermap.org/data/2.5/weather?APPID=c1fc8e4fc47d6d6ba9b87c77d8d657bf&zip=us,";
    _tempUnit = @"&units=imperial"; // &units=imperial or metric
    
    //_cityZipList = [[NSMutableArray alloc] init];
    [self loadUserDefaults];
    if(_cityZipList == NULL) {
        _cityZipList = [[NSMutableArray alloc] init];
    }
    
    if(![_cityZipList containsObject:@"48197"]){
        [_cityZipList addObject:@"48197"];
    }
    if(![_cityZipList containsObject:@"85365"]){
        [_cityZipList addObject:@"85365"];
    }
    if(![_cityZipList containsObject:@"99703"]){
        [_cityZipList addObject:@"99703"];
    }
    [self saveUserDefaults];
    
    _addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addCity)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = _addButton;
    
    _switchUnitButton = [[UIBarButtonItem alloc] initWithTitle:@"F\u00B0" style:UIBarButtonItemStylePlain target:self action:@selector(switchUnit)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = _switchUnitButton;
    
    _cityWeatherTable = [[UITableView alloc] init];
    _cityWeatherTable.dataSource = self;
    _cityWeatherTable.delegate = self;
    _cityWeatherTable.frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
    UINib *nib = [UINib nibWithNibName:@"CityCell" bundle:nil];
    [_cityWeatherTable registerNib:nib forCellReuseIdentifier:@"cityCell"];
    [self.view addSubview:_cityWeatherTable];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadUserDefaults];
    [_cityWeatherTable reloadData];
}

- (void)addCity {
    addCityPageViewController *addPage = [[addCityPageViewController alloc] init];
    [self.navigationController pushViewController:addPage animated:YES];
}

- (void)switchUnit {
    if([_tempUnit isEqual:@"&units=imperial"]) {
        _tempUnit = @"&units=metric";
        _switchUnitButton.title = @"C\u00B0";
    } else {
        _tempUnit = @"&units=imperial";
        _switchUnitButton.title = @"F\u00B0";
    }
    [_cityWeatherTable reloadData];
}

- (void)loadUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _cityZipList = [[defaults arrayForKey:@"cityZipList"] mutableCopy];
    [defaults synchronize];
}

- (void)saveUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_cityZipList forKey:@"cityZipList"];
    [defaults synchronize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cityZipList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    cell.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    cell.zipLabel.text = _cityZipList[indexPath.row];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *targetURL = [[_apiURL stringByAppendingString:_cityZipList[indexPath.row]] stringByAppendingString:_tempUnit];
    
    [request setURL:[NSURL URLWithString:targetURL]];
    
    NSURLSessionDataTask *task = [[self getURLSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        dispatch_async( dispatch_get_main_queue(),
                       ^{
                           NSError *jsonError;
                           NSMutableDictionary *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           
                           cell.cityLabel.text = parsedJSONArray[@"name"];
                           NSMutableDictionary *temp = parsedJSONArray[@"main"];
                           
                           cell.tempLabel.text = [[temp[@"temp"] stringValue]  stringByAppendingString:@"\u00B0"];
                       });
    }];
    
    [task resume];
    

    
    return cell;
}

- ( NSURLSession * )getURLSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken,
                  ^{
                      NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                      session = [NSURLSession sessionWithConfiguration:configuration];
                  } );
    
    return session;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_cityZipList removeObjectAtIndex:indexPath.row];
        [self saveUserDefaults];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *targetURL = [[_apiURL stringByAppendingString:_cityZipList[indexPath.row]] stringByAppendingString:_tempUnit];
    
    [request setURL:[NSURL URLWithString:targetURL]];
    
    NSURLSessionDataTask *task = [[self getURLSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        dispatch_async( dispatch_get_main_queue(),
                       ^{
                           NSError *jsonError;
                           NSMutableDictionary *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           
                           cityDetailPageViewController *detailPage = [[cityDetailPageViewController alloc] init];
                           detailPage.weatherInfo = [parsedJSONArray mutableCopy];
                           [self.navigationController pushViewController:detailPage animated:YES];
                       });
    }];
    
    [task resume];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
