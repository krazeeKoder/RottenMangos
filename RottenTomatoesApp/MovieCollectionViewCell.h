//
//  MovieCollectionViewCell.h
//  RottenTomatoesApp
//
//  Created by Anthony Tulai on 2016-02-01.
//  Copyright © 2016 Anthony Tulai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) UIImageView *movieImageView;

@end
