//
//  addCityPageViewController.m
//  Assignment_03_Live_Weather
//
//  Created by LILouis on 12/17/16.
//  Copyright © 2016 LILouis. All rights reserved.
//


#import "addCityPageViewController.h"

@interface addCityPageViewController ()

@property NSString *apiURL;
@property NSString *tempUnit;
@property NSMutableArray *cityZipList;
@property (nonatomic, strong) UITextField *zipTextView;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation addCityPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.view setBackgroundColor:[UIColor grayColor]];
    [self loadUserDefaults];
    
    _apiURL = @"http://api.openweathermap.org/data/2.5/weather?APPID=c1fc8e4fc47d6d6ba9b87c77d8d657bf&zip=us,";
    
    _zipTextView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 240, 60)];
    _zipTextView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2 + 10, 100);
    [_zipTextView setFont:[UIFont systemFontOfSize:28]];
    [_zipTextView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_zipTextView];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton addTarget:self
               action:@selector(addButtonPushed)
     forControlEvents:UIControlEventTouchUpInside];
    [_addButton setTitle:@"Add Zip Code" forState:UIControlStateNormal];
    _addButton.frame = CGRectMake(0, 0, 120, 40);
    _addButton.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, 160);
    [self.view addSubview:_addButton];
}

- (void)saveUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_cityZipList forKey:@"cityZipList"];
    [defaults synchronize];
}

- (void)loadUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _cityZipList = [[defaults arrayForKey:@"cityZipList"] mutableCopy];
    [defaults synchronize];
}

- (void) addCityZip:(NSString *) newZip{
    [_cityZipList addObject:newZip];
    [self saveUserDefaults];
}

- (void) addButtonPushed {
    
    NSString *inputString = [_zipTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([inputString rangeOfCharacterFromSet:notDigits].location == NSNotFound && ![inputString isEqual:@""] && [inputString length] == 5) // contains only 5 numbers
    {
        if(![_cityZipList containsObject:_zipTextView.text]) {
            NSLog(@"1");
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSString *zipCode = _zipTextView.text;
            NSString *targetURL = [_apiURL stringByAppendingString:zipCode];
            [request setURL:[NSURL URLWithString:targetURL]];
            
            NSURLSessionDataTask *task = [[self getURLSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                dispatch_async( dispatch_get_main_queue(),
                               ^{
                                   NSError *jsonError;
                                   NSMutableDictionary *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                                   
                                   NSString *respondCode = parsedJSONArray[@"cod"];
                                   if([respondCode isEqual:@"200"]) {
                                       [_zipTextView setText:@"Zip Code not Found"];
                                   } else {
                                       [self addCityZip:_zipTextView.text];
                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                   }
                               });
            }];
            
            [task resume];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        _zipTextView.text = @"Invalide Zip Code";
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
