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

#import <UIKit/UIKit.h>

@class SMSlider;

typedef enum {
  kSliderWithOutTracker = 0, // This slider look like progress view with single
                             // color (blue).  Required value :
                             // FirstMinimumTrackValue
  kSliderWithDoubleColor, // This slider look like progress view with double
                          // color(green and blue).  Required value :
                          // FirstMinimumTrackValue , SecondMinimumTrackValue
  kSliderWithTracker, // This is normal slider. Required value :
                      // FirstMinimumTrackValue , FirstTrackerPosition
  kSliderWithDoubleColorAndTracker, /*This slider has double color(green and
                                       blue) and Thumb button.
                                       Required value : FirstMinimumTrackValue
                                       ,SecondMinimumTrackValue,FirstTrackerPosition*/
  kSliderWithDoubleTracker, /*This slider has tow Thumb buttons. This slider we
                               can use for get the range values.*/
  kSliderWithTrackerAndRightView
} SMSliderType;

typedef enum {
  kTrackerThumbButtonTag = 100,
  kTrackerBalloonImageTag,
  kTrackerBalloonLabelTag
} TrackerSubViewsTag;

@protocol SMSliderDelegate <NSObject>

@optional

// When user drag the Thumb button this method will trigger (If it is
// implemented) with the current slider thumb value.
- (void)slider:(SMSlider *)SMSlider
    valueChangedWithNewValue:(float)currentValue
                    oldValue:(float)oldValue;

// This  method we can use only the Range type of sliders. This will give the
// starting and ending values.
- (void)slider:(SMSlider *)SMSlider
    rangeChangedWithStartValue:(float)startValue
                      endValue:(float)endValue;

// When user press out the tracker button then this deleate method will trigger
// with the current values.
- (void)slider:(SMSlider *)SMSlider
    didThumbThouchEndWithValue:(float)currentValue;

// Double Tracker Delegate  - When user press out the any one of the tracker
// button then this deleate method will trigger with the current values.
- (void)slider:(SMSlider *)SMSlider
    didThumbThouchEndWithFirstTrackerValue:(float)firstTrackerValue
                        secondTrackerValue:(float)secondTrackerValue;

@end

@interface SMSlider : UIControl

@property(nonatomic, assign)
    float maximumValue; // Default maximum value is 100;
@property(nonatomic, assign) float minimumValue; // Default maximum value is 0;
@property(nonatomic, assign) float minimumDifferenceBetweenSlider;
@property(nonatomic, assign) float currentProgressValue;
@property(nonatomic, assign) float
sliderRangeDifference; // Don't set this value while using slider off feature.
@property(nonatomic, strong) UIImage *firstMinimumTrackImage;
@property(nonatomic, strong) UIImage *secondMinimumTrackImage;
@property(nonatomic, strong) UIImage *sliderBackgroundImage;
@property(nonatomic, strong) UIImage *firstMinimumTrackImageForOverLimit;
@property(nonatomic, strong) UIImage *balloonImageForOverLimit;

@property(nonatomic, assign) BOOL shouldAnimate; // Default value is NO
@property(nonatomic, assign) BOOL displayInDecimalFormat;
@property(nonatomic, assign) BOOL shouldEnableFirstTrackerValueAsMinimum;
@property(nonatomic, assign) BOOL hideBaloon;
@property(nonatomic, assign, getter=isSliderOffEnabled) BOOL enableSliderOff;
@property(nonatomic, assign, getter=isSliderOff) BOOL sliderOff;
@property(nonatomic, assign, getter=isSliderOverLimitEnabled)
    BOOL enableSliderOverLimit; // This feature is only enable for one type of
                                // slider (kSliderWithTracker)
@property(nonatomic, assign) BOOL isOverLimit;

@property(nonatomic, weak) id<SMSliderDelegate> delegate;

// Parameter values are required based on the slider types. Please refer the
// SMSSliderType.
- (void)updateSliderWithType:(SMSliderType)SMSType
      FirstMinimumTrackValue:(float)firstTrackValue
     SecondMinimumTrackValue:(float)secondTrackValue
        FirstTrackerPosition:(float)firstTrackerPosition
       SecondTrackerPosition:(float)secondTrackerPosition;

- (SMSliderType)currentSliderType;

@end
