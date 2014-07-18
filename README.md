ImagePlayerView
===============

* Show a group of images in view
* Support Auto Layout
* UIPageControl, remove option

##Installation with CocoaPods
```objective-c
pod 'ImagePlayerView'
```

##Usage
###init
```objective-c
self.imageURLs = @[[NSURL URLWithString:@"http://www.ghzw.cn/wzsq/UploadFiles_9194/201109/20110915154150869.bmp"],
                   [NSURL URLWithString:@"http://sudasuta.com/wp-content/uploads/2013/10/10143181686_375e063f2c_z.jpg"],
                   [NSURL URLWithString:@"http://www.yancheng.gov.cn/ztzl/zgycddhsdgy/xwdt/201109/W020110902584601289616.jpg"],
                   [NSURL URLWithString:@"http://fzone.oushinet.com/bbs/data/attachment/forum/201208/15/074140zsb6ko6hfhzrb40q.jpg"]];
    
[self.imagePlayerView initWithCount:self.imageURLs.count delegate:self];
```

###implement delegate to load image
```objective-c
#pragma mark - ImagePlayerViewDelegate
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

##Show
![image](https://raw.githubusercontent.com/interchen/ImagePlayerView/master/Images/ImagePlayerView-01.png)

