//
//  ViewController.m
//  RottenTomatoesApp
//
//  Created by Anthony Tulai on 2016-02-01.
//  Copyright © 2016 Anthony Tulai. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "MovieCollectionView.h"
#import "MovieCollectionViewCell.h"
#import "MovieDetailViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *movies;
@property (assign, nonatomic) int movieCount;
@property (strong, nonatomic) UICollectionView *movieCollectionView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    

    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=xe4xau69pxaah5tmuryvrw75&page_limit=50";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *gatherMovieDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         
             
         if (!error) {
             NSError *jsonParsingError;
             NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
             if (!jsonParsingError) {
                 //NSLog(@"%@", jsonData);
                 NSString *movieCountString = jsonData[@"total"];
                 self.movieCount = [movieCountString intValue];
                 NSMutableArray *movieList = [NSMutableArray array];
                 for (NSDictionary *movieDictionary in jsonData[@"movies"]) {
                     Movie *movie = [[Movie alloc] init];
                     movie.title = movieDictionary[@"title"];
                     movie.imageUrl = [NSURL URLWithString:movieDictionary[@"posters"][@"thumbnail"]];
                     NSString *reviewsLink = [movieDictionary[@"links"][@"reviews"] stringByAppendingString:@"?apikey=xe4xau69pxaah5tmuryvrw75"];
                     movie.reviewURL = [NSURL URLWithString:[@"http:" stringByAppendingString:reviewsLink]];
                     movie.imageData = [[NSData alloc] initWithContentsOfURL: movie.imageUrl];
                     [movieList addObject:movie];
                 }
                 
                 self.movies = movieList;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"Inside dispatch async");
                     for (Movie *movie in self.movies) {
                         NSLog(@"%@", movie.title);
                     }
                     NSLog(@"%i",self.movieCount);
                     [self.movieCollectionView reloadData];
                     //[self.tableView reloadData];
                 });
                 NSLog(@"After dispatch async");
             }
             
         }
     }];
    [gatherMovieDataTask resume];
}


-(void) setupCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 2 - 30, self.view.frame.size.height / 3);
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
    flowLayout.sectionInset = UIEdgeInsetsMake(20,20,20,20);
    
    self.movieCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    
    [self.movieCollectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"MovieCell"];
    [self.movieCollectionView setDataSource:self];
    [self.movieCollectionView setDelegate:self];
    self.movieCollectionView.backgroundColor = [UIColor blueColor];
    self.movieCollectionView.userInteractionEnabled = YES;
    [self.view addSubview:self.movieCollectionView];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    if (!currentCell) {
        currentCell = [[MovieCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    }
    currentCell.backgroundColor = [UIColor redColor];
    Movie *currentMovie = self.movies[indexPath.row];

    
    currentCell.movieImageView.image = [UIImage imageWithData: currentMovie.imageData];

    return currentCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieDetailViewController *movieDetailViewController = [[MovieDetailViewController alloc]initWithMovie:self.movies[indexPath.row]];
    
    [self presentViewController:movieDetailViewController animated:NO completion:nil];
    
    
}

@end
