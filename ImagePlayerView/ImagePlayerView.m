//
//  ImagePlayerView.m
//  ImagePlayerView
//
//  Created by 陈颜俊 on 14-6-5.
//  Copyright (c) 2014年 Chenyanjun. All rights reserved.
//

#import "ImagePlayerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kStartTag   1000

@interface ImagePlayerView() <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *imageURLs;
@end

@implementation ImagePlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    // init
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.directionalLockEnabled = YES;
    
    self.delegate = self;
}

- (void)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<ImagePlayerViewDelegate>)delegate
{
    self.imageURLs = imageURLs;
    self.imagePlayerViewDelegate = delegate;
    
    if (imageURLs.count == 0) {
        return;
    }
    
    CGFloat startX = self.bounds.origin.x;
    
    for (int i = 0; i < imageURLs.count; i++) {
        startX = i * self.frame.size.width;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, 0, self.frame.size.width, self.frame.size.height)];
        imageView.tag = kStartTag + i;
        imageView.userInteractionEnabled = YES;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        
        NSURL *url = [imageURLs objectAtIndex:i];
        [imageView setImageWithURL:url placeholderImage:placeholder];
        
        [self addSubview:imageView];
    }
    
    // constraint
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *imageViewNames = [NSMutableArray array];
    for (int i = kStartTag; i < kStartTag + imageURLs.count; i++) {
        NSString *imageViewName = [NSString stringWithFormat:@"imageView%d", i - kStartTag];
        [imageViewNames addObject:imageViewName];
        
        UIImageView *imageView = (UIImageView *)[self viewWithTag:i];
        [viewsDictionary setObject:imageView forKey:imageViewName];
    }
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[%@]-0-|", [imageViewNames objectAtIndex:0]]
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    NSMutableString *hConstraintString = [NSMutableString string];
    [hConstraintString appendString:@"H:|-0"];
    for (NSString *imageViewName in imageViewNames) {
        [hConstraintString appendFormat:@"-[%@]-0", imageViewName];
    }
    [hConstraintString appendString:@"-|"];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hConstraintString
                                                                 options:NSLayoutFormatAlignAllTop
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    self.contentSize = CGSizeMake(self.frame.size.width * imageURLs.count, self.frame.size.height);
    self.contentInset = UIEdgeInsetsZero;
}

- (void)handleTapGesture:(UIGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    NSInteger index = imageView.tag - kStartTag;
    
    if (self.imagePlayerViewDelegate && [self.imagePlayerViewDelegate respondsToSelector:@selector(imagePlayerView:didTapAtIndex:imageURL:)]) {
        [self.imagePlayerViewDelegate imagePlayerView:self didTapAtIndex:index imageURL:[self.imageURLs objectAtIndex:index]];
    }
}

#pragma mark - delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // disable v direction scroll
    if (scrollView.contentOffset.y > 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}

@end