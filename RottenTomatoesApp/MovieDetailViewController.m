//
//  MovieDetailViewController.m
//  RottenTomatoesApp
//
//  Created by Anthony Tulai on 2016-02-01.
//  Copyright © 2016 Anthony Tulai. All rights reserved.
//

#import "MovieDetailViewController.h"

@implementation MovieDetailViewController

-(instancetype)initWithMovie:(Movie *)movie {
    self = [super init];
    if (self) {
        _reviewURL = movie.reviewURL;
    }
    return self;
}


-(void)viewDidLoad {
    NSLog(@"I loaded");
    
    //self.allReviews = [NSMutableArray new];
    
    [self createLabels];
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 150, 10, 130, 50)];
    returnButton.titleLabel.textColor = [UIColor blueColor];
    [returnButton setTitle:@"Return" forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnToMainViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnButton];
    
    [self.view addSubview:self.reviewLabel1];
    [self.view addSubview:self.reviewLabel2];
    [self.view addSubview:self.reviewLabel3];


    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.reviewURL];
    NSURLSessionDataTask *gatherReviewDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                //NSLog(@"%@", jsonData);

                
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

-(IBAction)returnToMainViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) createLabels {
    self.reviewLabel1 = [[UILabel alloc]init];
    self.reviewLabel1.backgroundColor = [UIColor whiteColor];
    self.reviewLabel1.textColor = [UIColor blackColor];
    //self.reviewLabel1.
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
@end
