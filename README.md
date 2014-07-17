ImagePlayerView
===============

* To show images in UIScrollView
* Only one line code
* Support Auto Layout
* Need [SDWebImage](https://github.com/rs/SDWebImage) libray to load remote image to UIImageView

##Import
```objective-c
pod 'ImagePlayerView'
```

##Usage
```objective-c
NSArray *imageURLs = @[[NSURL URLWithString:@"http://www.ghzw.cn/wzsq/UploadFiles_9194/201109/20110915154150869.bmp"],
                           [NSURL URLWithString:@"http://sudasuta.com/wp-content/uploads/2013/10/10143181686_375e063f2c_z.jpg"],
                           [NSURL URLWithString:@"http://www.yancheng.gov.cn/ztzl/zgycddhsdgy/xwdt/201109/W020110902584601289616.jpg"],
                           [NSURL URLWithString:@"http://fzone.oushinet.com/bbs/data/attachment/forum/201208/15/074140zsb6ko6hfhzrb40q.jpg"]];
    
[self.imagePlayerView initWithImageURLs:imageURLs placeholder:nil delegate:self];
```

##Show
![image](https://raw.githubusercontent.com/interchen/ImagePlayerView/master/Images/ImagePlayerView-01.png)

##ToDo's
* Add property to show/hide UIPageControl
* Add property to adjust UIPageControl
