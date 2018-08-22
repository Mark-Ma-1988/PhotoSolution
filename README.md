# PhotoSolution
<img src="https://github.com/Mark-Ma-1988/PhotoSolution/blob/master/screenshots/image.png" alt="PhotoSolution"/>

[![Version](https://img.shields.io/cocoapods/v/ImagePicker.svg?style=flat)](http://cocoadocs.org/docsets/ImagePicker)
[![License](https://img.shields.io/cocoapods/l/ImagePicker.svg?style=flat)](http://cocoadocs.org/docsets/ImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/ImagePicker.svg?style=flat)](http://cocoadocs.org/docsets/ImagePicker)
![Swift](https://img.shields.io/badge/%20in-swift%204.0-orange.svg)

## Features
- Take photo
- Pick multiple images (you can set maximum amount) from the local photo library
- Support both Objective-C and Swift
- Browse all the albums
- View, expend and edit an image in its original size
- Compress images
- Comtomize some UI properties, like color and title.

## Installation

**PhotoSolution** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
```
and then add:

```ruby
pod 'PhotoSolution'
```

## Related Permissions (Your need to add them in Info.plist)
- Privacy - Photo Library Usage Description
- Privacy - Photo Library Additions Usage Description
- Privacy - Camera Usage Description

## Basic Usage

### Objective-C

```objective-c
//import it
@import PhotoSolution;

//define delegate
@interface YourViewController () <PhotoSolutionDelegate>

//initilize
PhotoSolution* photoSolution = [[PhotoSolution alloc] init];
photoSolution.delegate = self;

//take photo
[self presentViewController: [photoSolution getCamera] animated:YES completion:nil];

//pick photos from local
[self presentViewController: [photoSolution getPhotoPickerWithMaxPhotos:9] animated:YES completion:nil];

//implement delegate method
-(void)returnImages:(NSArray *)images{
   // deal with the return images
}

-(void)pickerCancel{
   // when user cancel picking photo
}
```

###  Swift
```swift
//import it
import PhotoSolution

//initilize
let photoSolution = PhotoSolution()
photoSolution.delegate = self

//take photo
self.present(photoSolution.getCamera(), animated: true, completion: nil)

//pick photos from local
let remainPhotos = 9
self.present(photoSolution.getPhotoPicker(maxPhotos: remainPhotos), animated: true, completion: nil)

//implement delegate method
extension YourViewController: PhotoSolutionDelegate{
func returnImages(_ images: [UIImage]) {
   // deal with the return images
}

func pickerCancel() {
    // when user cancel
}
}
```

## Customization

### Objective-C
```objective-c
photoSolution.customization.markerColor = [UIColor colorWithRed:0.14 green:0.72 blue:0.30 alpha:1.0];
photoSolution.customization.navigationBarBackgroundColor = UIColor.darkGrayColor;
photoSolution.customization.navigationBarTextColor = UIColor.whiteColor;
photoSolution.customization.titleForAlbum = @"Album";
photoSolution.customization.alertTextForPhotoAccess = @"Your App Would Like to Access Your Photos";
photoSolution.customization.settingButtonTextForPhotoAccess = @"Setting";
photoSolution.customization.cancelButtonTextForPhotoAccess = @"Cancel";
photoSolution.customization.alertTextForCameraAccess = @"Your App Would Like to Access Your Photos";
photoSolution.customization.settingButtonTextForCameraAccess = @"Setting";
photoSolution.customization.cancelButtonTextForCameraAccess = @"Cancel";
photoSolution.customization.returnImageSize = ReturnImageSizeCompressed;
photoSolution.customization.statusBarColor = StatusBarColorWhite;
```

###  Swift
```swift
photoSolution.customization.markerColor = UIColor(red:0.14, green:0.72, blue:0.30, alpha:1.0)
photoSolution.customization.navigationBarBackgroundColor = UIColor.darkGray
photoSolution.customization.navigationBarTextColor = UIColor.white
photoSolution.customization.titleForAlbum = "Album"
photoSolution.customization.alertTextForPhotoAccess = "Your App Would Like to Access Your Photos"
photoSolution.customization.settingButtonTextForPhotoAccess = "Setting"
photoSolution.customization.cancelButtonTextForPhotoAccess = "Cancel"
photoSolution.customization.alertTextForCameraAccess = "Your App Would Like to Access Your Photos"
photoSolution.customization.settingButtonTextForCameraAccess = "Setting"
photoSolution.customization.cancelButtonTextForCameraAccess = "Cancel"
photoSolution.customization.returnImageSize = .compressed
photoSolution.customization.statusBarColor = .white
```


## Author

[Mark Ma](https://www.linkedin.com/in/xingchen-mark-ma-72a74678/), solution architect focused on mobile application, including server side backend ( restful API, database, AWS deployment ) and client side app ( iOS && Android ).

## License
MIT

