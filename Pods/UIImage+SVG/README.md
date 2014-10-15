UIImage+SVG [![Build Status](https://travis-ci.org/Label305/UIImage-SVG.svg?branch=master)](https://travis-ci.org/Label305/UIImage-SVG)
===========

SVG images for iOS. Category on UIKit's UIImage to display SVG files.

CocoaPods
---------

Add the following lines to your Podfile:

```ruby
pod 'UIImage+SVG', '~> 0.1'
```

Features
---------
* Image Cache
* Fill Color's

Usage
---------

```objective-c
#import <UIImage+SVG/UIImage+SVG.h>
```

```objective-c
UIImage* image = [UIImage imageWithSVGNamed:@"Happyface"
                                 targetSize:CGSizeMake(200, 200)
                                  fillColor:[UIColor blueColor]];
```

License
---------
Copyright 2014 Label305 B.V.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.