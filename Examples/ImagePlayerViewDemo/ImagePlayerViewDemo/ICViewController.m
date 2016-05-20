//
//  ICViewController.m
//  ImagePlayerViewDemo
//
//  Created by 陈颜俊 on 14-6-6.
//  Copyright (c) 2014年 Chenyanjun. All rights reserved.
//

#import "ICViewController.h"

@interface ICViewController () <ImagePlayerViewDelegate>
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation ICViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _imageCache = [NSCache new];
    
    self.imageURLs = @[[NSURL URLWithString:@"http://sudasuta.com/wp-content/uploads/2013/10/10143181686_375e063f2c_z.jpg"],
                       [NSURL URLWithString:@"http://img01.taopic.com/150920/240455-1509200H31810.jpg"],
                       [NSURL URLWithString:@"http://img.taopic.com/uploads/allimg/110906/1382-110Z611025585.jpg"]];

    self.imagePlayerView.imagePlayerViewDelegate = self;
    
    // set auto scroll interval to x seconds
    self.imagePlayerView.scrollInterval = 3.0f;
    
    // adjust pageControl position
    self.imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    
    // hide pageControl or not
    self.imagePlayerView.hidePageControl = NO;
    
    // endless scroll
    self.imagePlayerView.endlessScroll = YES;
    
    self.imagePlayerView.autoScroll = YES;
    
    // adjust edgeInset
    self.imagePlayerView.edgeInsets = UIEdgeInsetsMake(10, 20, 30, 40);
    
    [self.imagePlayerView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.imageURLs.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
//    [imageView setImageWithURL:[self.imageURLs objectAtIndex:index] placeholderImage:nil];
    
    NSURL *imageURL = [self.imageURLs objectAtIndex:index];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *image = [self.imageCache objectForKey:imageURL.absoluteString];
        if (!image) {
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            [self.imageCache setObject:image forKey:imageURL.absoluteString];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            imageView.image = image;
        });
    });
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
}
@end
