//
//  ImagePlayerView.m
//  ImagePlayerView
//
//  Created by 陈颜俊 on 14-6-5.
//  Copyright (c) 2014年 Chenyanjun. All rights reserved.
//

#import "ImagePlayerView.h"

#define kDefaultScrollInterval  2
#define kCellIdentifier @"ImagePlayerViewCell"


#pragma mark - Category RemoveConstraints
// refer from @marchinram http://stackoverflow.com/questions/24418884/remove-all-constraints-affecting-a-uiview
@interface UIView (RemoveConstraints)
- (void)removeAllConstraints;
@end

@implementation UIView (RemoveConstraints)
- (void)removeAllConstraints
{
    UIView *superview = self.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == self || c.secondItem == self) {
                [superview removeConstraint:c];
            }
        }
        superview = superview.superview;
    }
    
    [self removeConstraints:self.constraints];
}
@end

#pragma mark - ImagePlayerViewCell
@interface ImagePlayerViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ImagePlayerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:self.imageView];
        
        // fill cell
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:kNilOptions metrics:0 views:@{@"imageView": self.imageView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:kNilOptions metrics:0 views:@{@"imageView": self.imageView}]];
    }
    return self;
}
@end

#pragma mark - ImagePlayerView
@interface ImagePlayerView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@end

@implementation ImagePlayerView

#pragma mark - init
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

- (id)initWithDelegate:(id<ImagePlayerViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.imagePlayerViewDelegate = delegate;
        [self _init];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"bounds"];
    
    if (self.autoScrollTimer) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.imagePlayerViewDelegate = nil;
}

- (void)_init
{
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self setupCollectionView];
    [self setupPageControl];
    
    // default settings
    self.scrollInterval = kDefaultScrollInterval;
    self.pageControlPosition = ICPageControlPosition_BottomRight;
    self.edgeInsets = UIEdgeInsetsZero;
    
    [self reloadData];
}

- (void)setupCollectionView {
    if (!self.collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.bounces = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.scrollsToTop = NO;
        
        [self.collectionView registerClass:[ImagePlayerViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self addSubview:self.collectionView];
    }
}

- (void)setupPageControl {
    if (!self.pageControl) {
        self.pageControl = [[UIPageControl alloc] init];
    }
    self.pageControl.userInteractionEnabled = YES;
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.numberOfPages = self.count;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(handleClickPageControl:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pageControl];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"]) {
        [self reloadData];
    }
}

- (void)reloadData
{
    self.count = [self.imagePlayerViewDelegate numberOfItems];
    
    self.pageControl.numberOfPages = self.count;
    
    [self.collectionView reloadData];
}

#pragma mark UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount = self.count;
    if (self.endlessScroll) {
        itemCount += 1;
    }
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImagePlayerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    // check if reused
    BOOL isReused = cell.tag != indexPath.row;
    if ((indexPath.row == 0 || indexPath.row == self.count)) {
        // for endless scroll, the first one is the same as the last one
        // so don't clear image or there will be a short time blank
        isReused = false;
    }
    if (isReused) {
        cell.imageView.image = nil;
    }
    
    cell.tag = indexPath.row;
    
    NSInteger index = indexPath.row;
    if (index == self.count) {
        index = 0;
    }
    [self.imagePlayerViewDelegate imagePlayerView:self loadImageForImageView:cell.imageView index:index];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    if (index == self.count) {
        index = 0;
    }
    
    if (self.imagePlayerViewDelegate && [self.imagePlayerViewDelegate respondsToSelector:@selector(imagePlayerView:didTapAtIndex:)]) {
        [self.imagePlayerViewDelegate imagePlayerView:self didTapAtIndex:index];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

#pragma mark - actions
- (void)handleClickPageControl:(UIPageControl *)sender
{
    [self restartTimer];
    
    if (sender.currentPage >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sender.currentPage inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
}

#pragma mark - auto scroll timer
- (void)setScrollInterval:(NSUInteger)scrollInterval
{
    _scrollInterval = scrollInterval;
    [self restartTimer];
}

- (void)handleScrollTimer:(NSTimer *)timer
{
    if (self.count == 0) {
        return;
    }
    
    NSInteger currentPage = self.pageControl.currentPage;
    NSInteger nextPage = currentPage + 1;
    if (self.endlessScroll
        && nextPage == self.count + 1) {
        nextPage = 0;
    }
    
    if (nextPage >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nextPage inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
}

#pragma mark - scroll delegate
- (void)scrollViewDidEndScrollingAnimation:(UICollectionView *)collectionView
{
    [self didEndScroll:collectionView];
}

- (void)scrollViewDidEndDecelerating:(UICollectionView *)collectionView
{
    [self didEndScroll:collectionView];
}

- (void)didEndScroll:(UICollectionView *)collectionView
{
    // when user scrolls manually, stop timer and start timer again to avoid scrolling to next immediatelly
    if (self.scrollInterval > 0) {
        [self restartTimer];
    }
    
    // update UIPageControl
    NSInteger currentIndex = collectionView.contentOffset.x / collectionView.bounds.size.width;
    if (currentIndex == self.count) {
        // delay 0.1s or there will be a short time blank
        [self performSelector:@selector(scrollToFirstItem) withObject:nil afterDelay:0.1];
        
        currentIndex = 0;
    }
    
    if (self.imagePlayerViewDelegate && [self.imagePlayerViewDelegate respondsToSelector:@selector(imagePlayerView:didScorllIndex:)]) {
        [self.imagePlayerViewDelegate imagePlayerView:self didScorllIndex:currentIndex];
    }
    
    self.pageControl.currentPage = currentIndex;
}

- (void)scrollToFirstItem {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
}

#pragma mark - settings
- (void)restartTimer {
    if (self.autoScrollTimer && self.autoScrollTimer.isValid) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
    
    if (self.scrollInterval > 0) {
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
    }
}

- (void)setPageControlPosition:(ICPageControlPosition)pageControlPosition
{
    NSString *vFormat = nil;
    NSString *hFormat = nil;
    
    switch (pageControlPosition) {
        case ICPageControlPosition_TopLeft: {
            vFormat = @"V:|-0-[pageControl]";
            hFormat = @"H:|-[pageControl]";
            break;
        }
            
        case ICPageControlPosition_TopCenter: {
            vFormat = @"V:|-0-[pageControl]";
            hFormat = @"H:|[pageControl]|";
            break;
        }
            
        case ICPageControlPosition_TopRight: {
            vFormat = @"V:|-0-[pageControl]";
            hFormat = @"H:[pageControl]-|";
            break;
        }
            
        case ICPageControlPosition_BottomLeft: {
            vFormat = @"V:[pageControl]-0-|";
            hFormat = @"H:|-[pageControl]";
            break;
        }
            
        case ICPageControlPosition_BottomCenter: {
            vFormat = @"V:[pageControl]-0-|";
            hFormat = @"H:|[pageControl]|";
            break;
        }
            
        case ICPageControlPosition_BottomRight: {
            vFormat = @"V:[pageControl]-0-|";
            hFormat = @"H:[pageControl]-|";
            break;
        }
            
        default:
            break;
    }
    
    [self.pageControl removeAllConstraints];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:@{@"pageControl": self.pageControl}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:@{@"pageControl": self.pageControl}]];
}

- (void)setHidePageControl:(BOOL)hidePageControl
{
    self.pageControl.hidden = hidePageControl;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    
    [self.collectionView removeAllConstraints];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[collectionView]-bottom-|"
                                                                 options:kNilOptions
                                                                 metrics:@{@"top": @(self.edgeInsets.top),
                                                                           @"bottom": @(self.edgeInsets.bottom)}
                                                                   views:@{@"collectionView": self.collectionView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[collectionView]-right-|"
                                                                 options:kNilOptions
                                                                 metrics:@{@"left": @(self.edgeInsets.left),
                                                                           @"right": @(self.edgeInsets.right)}
                                                                   views:@{@"collectionView": self.collectionView}]];
}

- (void)stopTimer
{
    if (self.autoScrollTimer && self.autoScrollTimer.isValid) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}
@end


