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

#ifndef SMSliderDemo_SMSliderConstant_h
#define SMSliderDemo_SMSliderConstant_h

#define kDefaulMaximumValue 100.0f
#define kSliderHeight 5.0f
#define kTrackerHeight (kSliderHeight * 18.0)
#define kTrackerWidth (kSliderHeight * 20.0)
#define kTrackerButtonWidth (kTrackerWidth / 3)
#define kTrackerButtonHeight (kTrackerHeight / 2.2)
#define kTrackerTopImageWidth ((kTrackerWidth / 2) * 1.3)
#define kTrackerTopImageHeight ((kTrackerHeight / 2) * 1.5)
#define kSliderCornerRadius 3.0f
#define kMinimumScale 0.001f
#define kNormalScale 1.0f
#define kMaximumScale 1.1f
#define kBalloonAnchorPoint CGPointMake(0.5, 1.0)
#define kCurrentValueLabelHeight 20.0f
#define kFirstTrackerThumbTitle @"1"
#define kSecondTrackerThumTitle @"2"
#define kBackgroundViewXOrigin                                                 \
  8.0f // Minimum origin of the background view should be greater than 7
#define kSliderOffValue -1
#define kOffViewWidth 5
#define kOffViewSpace 10
#define kControlXOrigin 10

// Angle Rotation
#define kDefaultLastAngle ((self.maximumValue + kDefaultAngle) * kMaximumAngle)
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define kMaximumAngle ((kBalloonRotateIncrementValue * 10) * 2)
#define kDefaultAngle 0.0f

static NSString *kBalloonOffValue = @"AV";
float kBalloonRotateIncrementValue;
float kBalloonRotateDecrementValue;

#endif
