
Pod::Spec.new do |s|

  s.name         = "ImagePlayerView"
  s.version      = "2.0.3"
  s.summary      = "Show a group of images in view"
  s.description  = 'Show a group of images in view, only few code to support. Support UIPageControl, auto scroll.'
  
  s.homepage     = "https://github.com/interchen/ImagePlayerView"
  s.screenshots  = "https://github.com/interchen/ImagePlayerView/blob/master/endless.gif"

  s.license      = 'MIT'

  s.author             = { "Chen Yanjun" => "inter.chen@gmail.com" }
  s.social_media_url   = "https://twitter.com/azhunchen"

  s.ios.deployment_target  = '6.0'

  s.source       = { :git => "https://github.com/interchen/ImagePlayerView.git", :tag => s.version }
  s.source_files  = 'ImagePlayerView/*.{h,m}'
 
  s.requires_arc = true
  
end
