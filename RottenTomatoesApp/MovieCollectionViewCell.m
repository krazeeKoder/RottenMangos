//
//  MovieCollectionViewCell.m
//  RottenTomatoesApp
//
//  Created by Anthony Tulai on 2016-02-01.
//  Copyright © 2016 Anthony Tulai. All rights reserved.
//

#import "MovieCollectionViewCell.h"

@implementation MovieCollectionViewCell

-(void)setMovie:(Movie *)movie{
    _movie = movie;
    _movieImageView.image = [UIImage imageWithData:movie.imageData];
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.movieImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.movieImageView];        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.movieImageView.frame = self.contentView.bounds;
}

@end
