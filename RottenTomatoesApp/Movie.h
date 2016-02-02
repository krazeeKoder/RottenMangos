//
//  MovieRepo.h
//  RottenTomatoesApp
//
//  Created by Anthony Tulai on 2016-02-01.
//  Copyright © 2016 Anthony Tulai. All rights reserved.
//

#import "ViewController.h"

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSURL *reviewURL;

@end
