//
//  ImagePlayerView.h
//  ImagePlayerView
//
//  Created by 陈颜俊 on 14-6-5.
//  Copyright (c) 2014年 Chenyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePlayerViewDelegate;

@interface ImagePlayerView : UIScrollView
@property (nonatomic, assign) id<ImagePlayerViewDelegate> imagePlayerViewDelegate;

- (void)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<ImagePlayerViewDelegate>)delegate;
@end

@protocol ImagePlayerViewDelegate <NSObject>

@optional
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index imageURL:(NSURL *)imageURL;

@end
