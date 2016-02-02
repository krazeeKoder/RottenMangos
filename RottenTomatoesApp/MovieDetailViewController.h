//
//  MovieDetailViewController.h
//  RottenTomatoesApp
//
//  Created by Anthony Tulai on 2016-02-01.
//  Copyright © 2016 Anthony Tulai. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"

@interface MovieDetailViewController : ViewController

@property (strong, nonatomic) UILabel *reviewLabel1;
@property (strong, nonatomic) UILabel *reviewLabel2;
@property (strong, nonatomic) UILabel *reviewLabel3;
@property (strong, nonatomic) NSURL *reviewURL;
//@property (strong, nonatomic) NSMutableArray *allReviews;


-(instancetype)initWithMovie:(Movie *)movie;


@end
