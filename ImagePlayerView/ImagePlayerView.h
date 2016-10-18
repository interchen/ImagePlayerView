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
@property (nonatomic, weak) id<ImagePlayerViewDelegate> imagePlayerViewDelegate;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSUInteger scrollInterval;    // scroll interval, unit: second, default is 2 seconds. set 0 to close auto scroll feature
@property (nonatomic, assign) ICPageControlPosition pageControlPosition;    // pageControl position, defautl is bottomright
@property (nonatomic, assign) BOOL hidePageControl; // hide pageControl, default is NO
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) BOOL endlessScroll; // endless scroll, default is NO

/**
 *  Reload everything
 */
- (void)reloadData;

/**
 *  Stop timer before your view controller is poped
 */
- (void)stopTimer;

@end

#pragma mark - ImagePlayerViewDelegate
@protocol ImagePlayerViewDelegate <NSObject>

@required
/**
 *  Number of items
 *
 *  @return Number of items
 */
- (NSInteger)numberOfItems;

/**
 *  Init imageview
 *
 *  @param imagePlayerView ImagePlayerView object
 *  @param imageView       UIImageView object
 *  @param index           index of imageview
 */
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index;

@optional

/**
 *  Tap ImageView action
 *
 *  @param imagePlayerView ImagePlayerView object
 *  @param index           index of imageview
 */
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index;

/**
 *  Scroll ImageView action
 *  @param imagePlayerView ImagePlayerView object
 *  @param index           current index
 **/
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didScorllIndex:(NSInteger)index;

@end
