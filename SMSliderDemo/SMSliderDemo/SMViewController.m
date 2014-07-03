/*
 Copyright (c) 2014 Subramanian

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "SMViewController.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.slider.minimumValue = 0.0f;
  self.slider.maximumValue = 500.0f;

  self.slider.firstMinimumTrackImage =
      [[UIImage imageNamed:@"slider-line-blue.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
  self.slider.secondMinimumTrackImage =
      [[UIImage imageNamed:@"slider-line-grey.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
  self.slider.sliderBackgroundImage =
      [UIImage imageNamed:@"notifications-bg.png"];
  //    self.slider.shouldEnableFirstTrackerValueAsMinimum = NO;
  //    self.slider.displayInDecimalFormat = YES;
  // self.slider.sliderOff = YES;
  // self.slider.enableSliderOff = NO;
  // self.slider.enableSliderOverLimit = YES;
  //    self.slider.shouldEnableFirstTrackerValueAsMinimum = YES;
  //    self.slider.sliderRangeDifference = 50;
  self.slider.minimumValue = 0.0f;
  self.slider.maximumValue = 500.0f;
  [self.slider updateSliderWithType:kSliderWithTrackerAndRightView
             FirstMinimumTrackValue:150.0f
            SecondMinimumTrackValue:0.0f
               FirstTrackerPosition:150.0f
              SecondTrackerPosition:200.0f];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
