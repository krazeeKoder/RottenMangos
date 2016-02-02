//
//  Theatre.h
//  RottenTomatoesApp
//
//  Created by Anthony Tulai on 2016-02-02.
//  Copyright © 2016 Anthony Tulai. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
//#import <CoreLocation/CLPlacemark.h>

@interface Theatre : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *address;


@end
