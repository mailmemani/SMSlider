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

#import "SMSlider.h"

@interface SMSlider () {
  UIImageView *firstMinimumTrackImageView;
  UIImageView *secondMinimumTrackImageView;
  UIImageView *sliderBackgroundImageView;
  CGFloat numberOfUnit;

  UIView *backgroundView;
  UIView *firstTrackerView;
  UIView *secondTrackerView;
  UIView *trackerRightView;
  UIView *offView;

  SMSliderType sliderType;

  BOOL shouldDivideTheTrackValue;
  BOOL firstTrackerMoved;
  BOOL secondTrackerMoved;
  BOOL hideBalloonInOffState;

  float firstMinimumTrackerValue;
  float secondMinimumTrackerValue;
  float firstTrackerValue;
  float secondTrackerValue;

  float firstTrackerInitialValue;
  float secondTrackerInitialValue;
  float currentValue;
  float trackerStartValue;
  float doubleSliderMinimumSpace;
  float sliderPreviousValue;
  float firstMinimumTrackWidth;
  float secondMinimumTrackWidth;
  float doubleColorWithTrackerMinimumValue;
  float maximumTrackerValue;
  float minimumTrackerValue;
  float doubleColorWithTrackerMinimumPosition;
  float angle;
  float firstTrackerLastAngle;
  float secondTrackerLastAngle;
  float backgroundViewMaxX;

  // Slider Range Difference
  float trackerRange;
  float trackerWidthRange;

  CGAffineTransform balloonTransform;

  dispatch_queue_t delegateQueue;
}

@end
