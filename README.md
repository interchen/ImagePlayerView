ImagePlayerView
===============

* Show a group of images in view
* Support Auto Layout
* UIPageControl, remove option

##Show
![image](https://github.com/interchen/ImagePlayerView/blob/master/ImageViewPlayer.gif)

##Installation with CocoaPods
```objective-c
pod 'ImagePlayerView'
```

##Usage
###init
```objective-c
self.imageURLs = @[[NSURL URLWithString:@"http://sudasuta.com/wp-content/uploads/2013/10/10143181686_375e063f2c_z.jpg"],
                   [NSURL URLWithString:@"http://www.yancheng.gov.cn/ztzl/zgycddhsdgy/xwdt/201109/W020110902584601289616.jpg"],
                   [NSURL URLWithString:@"http://fzone.oushinet.com/bbs/data/attachment/forum/201208/15/074140zsb6ko6hfhzrb40q.jpg"]];
```

###implement delegate to load image
```objective-c
#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.imageURLs.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
//    [imageView setImageWithURL:[self.imageURLs objectAtIndex:index] placeholderImage:nil];
    
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.imageURLs objectAtIndex:index]]];
}
```

###adjust pageControl position
```objective-c
self.imagePlayerView.pageControlPosition = ICPageControlPosition_BottomLeft;
```
    
###hide pageControl or not
```objective-c
self.imagePlayerView.hidePageControl = NO;
```

###adjust edgeInset
```objective-c
self.imagePlayerView.edgeInsets = UIEdgeInsetsMake(10, 20, 30, 40);
```

##Versions
###v0.3.1
[v0.3.1](https://github.com/interchen/ImagePlayerView/tree/0.3.1) dependenced on [SDWebImage](https://github.com/rs/SDWebImage) lib, you don't need to implement delegate to load image
```objective-c
pod 'ImagePlayerView', '~> 0.3.1'
```

###from v0.4 on
remove dependence on [SDWebImage](https://github.com/rs/SDWebImage) lib, you should implement delegate to load image
```objective-c
pod 'ImagePlayerView'
```


