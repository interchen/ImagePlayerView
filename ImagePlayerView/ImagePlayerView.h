//
//  ImagePlayerView.h
//  ImagePlayerView
//
//  Created by 陈颜俊 on 14-6-5.
//  Copyright (c) 2014年 Chenyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ICPageControlPosition) {
    ICPageControlPosition_TopLeft,
    ICPageControlPosition_TopCenter,
    ICPageControlPosition_TopRight,
    ICPageControlPosition_BottomLeft,
    ICPageControlPosition_BottomCenter,
    ICPageControlPosition_BottomRight
};

@protocol ImagePlayerViewDelegate;

@interface ImagePlayerView : UIView
@property (nonatomic, assign) id<ImagePlayerViewDelegate> imagePlayerViewDelegate;
@property (nonatomic, assign) BOOL autoScroll;  // Default is YES, set NO to turn off autoScroll
@property (nonatomic, assign) NSUInteger scrollInterval;    // scroll interval, unit: second, Default is 2 seconds
@property (nonatomic, assign) ICPageControlPosition pageControlPosition;

/**
 *  Init image player
 *
 *  @param imageURLs   NSURL array, image path
 *  @param placeholder placeholder image
 *  @param delegate    delegate
 */
- (void)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<ImagePlayerViewDelegate>)delegate;

/**
 *  Init image player
 *
 *  @param imageURLs   NSURL array, image path
 *  @param placeholder placeholder image
 *  @param delegate    delegate
 *  @param edgeInsets  scroll view edgeInsets
 */
- (void)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<ImagePlayerViewDelegate>)delegate edgeInsets:(UIEdgeInsets)edgeInsets;
@end

@protocol ImagePlayerViewDelegate <NSObject>

@optional
/**
 *  Tap ImageView action
 *
 *  @param imagePlayerView ImagePlayerView object
 *  @param index           index of imageview
 *  @param imageURL        image url
 */
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index imageURL:(NSURL *)imageURL;

@end
