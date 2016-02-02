//
//  MovieDetailViewController.m
//  RottenTomatoesApp
//
//  Created by Anthony Tulai on 2016-02-01.
//  Copyright © 2016 Anthony Tulai. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "MovieDetailViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "Theatre.h"


@interface MovieDetailViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;
@property (assign, nonatomic) BOOL initialLocationSet;
@property (strong, nonatomic) NSString *userLocationPostalCode;
@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) NSString *theatreLocationURL;
@property (strong, nonatomic) NSMutableArray *theatres;


@end

@implementation MovieDetailViewController

-(instancetype)initWithMovie:(Movie *)movie {
    self = [super init];
    if (self) {
        _reviewURL = movie.reviewURL;
        _movieTitle = [movie.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    return self;
}


-(void)viewDidLoad {
    NSLog(@"I loaded");
    

    
    
    self.theatres = [[NSMutableArray alloc] init];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.initialLocationSet = NO;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        // Make the actual request. This will FAIL if you are missing the NSLocationWhenInUseUsageDescription key from the Info.plist
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self createLabels];
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 150, 10, 130, 50)];
    returnButton.titleLabel.textColor = [UIColor blueColor];
    [returnButton setTitle:@"Return" forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnToMainViewController:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 75, 150, 50)];
    mapButton.titleLabel.textColor = [UIColor blueColor];
    [mapButton setTitle:@"Map" forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(viewMap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:returnButton];
    [self.view addSubview:mapButton];
    
    [self.view addSubview:self.reviewLabel1];
    [self.view addSubview:self.reviewLabel2];
    [self.view addSubview:self.reviewLabel3];

    [self getReviewData];



}
-(void) closeMap: (id) sender {
    [self.mapView removeFromSuperview];
}

-(void) getReviewData {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.reviewURL];
    NSURLSessionDataTask *gatherReviewDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Inside dispatch async");
                    int i = 0;
                    
                    for (NSDictionary *reviewDictionary in jsonData[@"reviews"]) {
                        switch (i) {
                            case 0:
                                self.reviewLabel1.text = reviewDictionary[@"quote"];
                                self.reviewLabel1.text = [self.reviewLabel1.text stringByAppendingString:reviewDictionary[@"links"][@"review"]];
                                break;
                            case 1:
                                self.reviewLabel2.text = reviewDictionary[@"quote"];
                                self.reviewLabel2.text = [self.reviewLabel2.text stringByAppendingString:reviewDictionary[@"links"][@"review"]];
                                
                                break;
                            case 2:
                                self.reviewLabel3.text = reviewDictionary[@"quote"];
                                self.reviewLabel3.text = [self.reviewLabel3.text stringByAppendingString:reviewDictionary[@"links"][@"review"]];
                                break;
                            default:
                                break;
                                
                        }
                        i++;
                    }
                    
                    CGSize label1Size = [self.reviewLabel1 sizeThatFits:CGSizeMake(300, 500)];
                    self.reviewLabel1.frame = CGRectMake(self. view.frame.size.width/2 - 150, 100, 300, label1Size.height);
                    CGSize label2Size = [self.reviewLabel2 sizeThatFits:CGSizeMake(300, 500)];
                    self.reviewLabel2.frame = CGRectMake(self. view.frame.size.width/2 - 150, 120 + label1Size.height, 300, label2Size.height);
                    CGSize label3Size = [self.reviewLabel3 sizeThatFits:CGSizeMake(300, 500)];
                    self.reviewLabel3.frame = CGRectMake(self. view.frame.size.width/2 - 150, 140 + label1Size.height + label2Size.height, 300, label3Size.height);
                });
                NSLog(@"After dispatch async");
            }
            
        }
    }];
    [gatherReviewDataTask resume];

    
}

-(void) getTheaterLocationData {
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.theatreLocationURL = [@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=" stringByAppendingString:self.userLocationPostalCode];
    self.theatreLocationURL = [self.theatreLocationURL stringByAppendingString:@"&movie="];
    self.theatreLocationURL = [self.theatreLocationURL stringByAppendingString:self.movieTitle];
    NSLog(@"%@",self.theatreLocationURL);
    NSURL *theatreDataURL = [NSURL URLWithString:self.theatreLocationURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:theatreDataURL];

    NSURLSessionDataTask *gatherTheatreLocationDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                //NSLog(@"%@", jsonData);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Inside dispatch async");
                    for (NSDictionary *theatreDictionary in jsonData[@"theatres"]) {
                        Theatre *newTheatre = [[Theatre alloc] init];
                        newTheatre.name = theatreDictionary[@"name"];
                        newTheatre.address = theatreDictionary[@"address"];
                        NSString *latString = theatreDictionary [@"lat"];
                        CLLocationDegrees lat = [latString doubleValue];
                        NSString *lngString = theatreDictionary [@"lng"];
                        CLLocationDegrees lng = [lngString doubleValue];
                        newTheatre.coordinate = CLLocationCoordinate2DMake(lat, lng);
                        
                        NSLog(@"%@ %@ %@ %@", newTheatre.name, newTheatre.address, latString, lngString);
                        [self.theatres addObject:newTheatre];
                    }
                    
                    [self.mapView addAnnotations:self.theatres];
                });
                NSLog(@"After dispatch async");
            }
            
        }
    }];
    [gatherTheatreLocationDataTask resume];
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization changed");
    
    // If the user's allowed us to use their location, we can start getting location updates
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}
-(void)returnToMainViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewMap:(id)sender {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        // Make the actual request. This will FAIL if you are missing the NSLocationWhenInUseUsageDescription key from the Info.plist
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = YES;
    UIToolbar *mapToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    UIBarButtonItem *mapReturnButton = [[UIBarButtonItem alloc] initWithTitle:@"return" style:UIBarButtonItemStylePlain target:self action:@selector(closeMap:)];
    NSArray *mapButtonItem = [[NSArray alloc] initWithObjects:mapReturnButton, nil];
    [mapToolBar setItems:mapButtonItem];
    [self.mapView addSubview:mapToolBar];
    [self getTheaterLocationData];
    //[self.mapView addAnnotation:(nonnull id<MKAnnotation>)]
    
}



- (void) createLabels {
    self.reviewLabel1 = [[UILabel alloc]init];
    self.reviewLabel1.backgroundColor = [UIColor whiteColor];
    self.reviewLabel1.textColor = [UIColor blackColor];
    self.reviewLabel1.numberOfLines = 0;
    
    self.reviewLabel2 = [[UILabel alloc]init];
    self.reviewLabel2.backgroundColor = [UIColor whiteColor];
    self.reviewLabel2.textColor = [UIColor blackColor];
    self.reviewLabel2.numberOfLines = 0;
    
    self.reviewLabel3 = [[UILabel alloc]init];
    self.reviewLabel3.backgroundColor = [UIColor whiteColor];
    self.reviewLabel3.textColor = [UIColor blackColor];
    self.reviewLabel3.numberOfLines = 0;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // Get the last object from the list of locations we get back
    CLLocation *userLocation = [locations lastObject];

    if (!self.initialLocationSet) {
        self.initialLocationSet = YES;
        CLLocationCoordinate2D userCoordinate = userLocation.coordinate;
        MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, MKCoordinateSpanMake(0.01, 0.01));

        [self.mapView setRegion:userRegion animated:YES];
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        
        [geoCoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                // The Placemark will have information about the location, like the coordinates, postal code, etc.
                CLPlacemark *placemark = [placemarks lastObject];
               // NSLog(@"%@", placemark);
                [geoCoder reverseGeocodeLocation:placemark.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                    [self reverseGeocodeLocation:placemark.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                        
                    }];
                }];
            }
        }];
    }
    //NSLog(@"%@", locations);
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler {
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    if (reverseGeocoder) {
        [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark* placemark = [placemarks firstObject];
            if (placemark) {
                self.userLocationPostalCode = [placemark.addressDictionary objectForKey:@"ZIP"];
                self.userLocationPostalCode = [self.userLocationPostalCode stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            }
        }];
    }else{
        MKReverseGeocoder* rev = [[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
        rev.delegate = self; //using delegate
        [rev start];
        //[rev release]; release when appropriate
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (annotation == mapView.userLocation) {
        return nil;
    }

  
    NSLog(@"Called pin annotation");
    MKPinAnnotationView *pav = (MKPinAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier:@"TheatrePin"];
    if (pav == nil) {
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TheatrePin"];
    }
    pav.pinTintColor = [UIColor greenColor];
    
    return pav;
}

@end
