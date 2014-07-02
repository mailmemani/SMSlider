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

/*

   1) Control minimum height should be 50.0f if you are going to use
   kSliderWithTracker,
   kSliderWithDoubleColorAndTracker types slider.

   2) If you want to change the height of the slider then change the bottom
   defined values.
   No need any code changes.

 */

#import "SMSlider.h"
#import <QuartzCore/QuartzCore.h>
#import "SMSlider+Extension.h"
#import "SMSlider_Extension.h"
#import "SMSliderConstant.h"

@implementation SMSlider
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.frame = frame;
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  CGRect controlFrame = self.frame;
  if (controlFrame.origin.x > kControlXOrigin) {
    kBalloonRotateDecrementValue = 0.70f;
    kBalloonRotateIncrementValue = 0.70f;
  } else {
    kBalloonRotateDecrementValue = 1.75f;
    kBalloonRotateIncrementValue = 1.75f;
  }
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
   // Drawing code
   }
 */

#pragma mark - Entry Point
- (void)updateSliderWithType:(SMSliderType)SMSType
      FirstMinimumTrackValue:(float)firstTrackValue
     SecondMinimumTrackValue:(float)secondTrackValue
        FirstTrackerPosition:(float)firstTrackerPosition
       SecondTrackerPosition:(float)secondTrackerPosition {
  if (self.maximumValue <= 0) {
    self.maximumValue = kDefaulMaximumValue;
  }
  if (self.sliderOff && self.enableSliderOff) {
    firstTrackerPosition = self.maximumValue;
  }
  [self removeSubViews];

  delegateQueue =
      dispatch_queue_create("com.smslider.delegate", DISPATCH_QUEUE_SERIAL);

  // Set slider type and first image view value and second imageview value.
  sliderType = SMSType;
  if (sliderType == kSliderWithDoubleTracker) {
    if (firstTrackerPosition > secondTrackerPosition) {
      firstTrackerPosition = secondTrackerPosition;
    }
  }

  if (firstTrackerPosition > self.maximumValue) {
    firstTrackerPosition = self.maximumValue;
  }
  if (secondTrackerPosition > self.maximumValue) {
    secondTrackerPosition = self.maximumValue;
  }
  if (self.minimumDifferenceBetweenSlider >= self.maximumValue) {
    self.minimumDifferenceBetweenSlider = 0;
  }
  doubleColorWithTrackerMinimumValue = firstTrackValue;
  // If the minimum value greater than zero then reduce all the values from the
  // minimum tracker value
  firstTrackValue = firstTrackValue - self.minimumValue;

  firstTrackerPosition = firstTrackerPosition - self.minimumValue;
  secondTrackerPosition = secondTrackerPosition - self.minimumValue;
  self.maximumValue = self.maximumValue - self.minimumValue;

  firstMinimumTrackerValue = firstTrackValue;
  secondMinimumTrackerValue = secondTrackValue;
  firstTrackerValue = firstTrackerPosition;
  secondTrackerValue = secondTrackerPosition;
  firstTrackerInitialValue = firstTrackerPosition;
  secondTrackerInitialValue = secondTrackerPosition;
  sliderPreviousValue = firstTrackerPosition;
  // Set the images for tracker imageviews.
  [self trackerImageSetUp];

  // Initiate the image views and views.
  [self initViews];

  if (self.isSliderOffEnabled) {
    CGRect sliderFrame = backgroundView.frame;
    sliderFrame.size.width = sliderFrame.size.width - kOffViewWidth;
    backgroundView.frame = sliderFrame;
    backgroundViewMaxX = sliderFrame.size.width + sliderFrame.origin.x;
  }

  // Add the background imageview as subview of backgroudn UIView.
  sliderBackgroundImageView.image = self.sliderBackgroundImage;
  if (!self.isSliderOverLimitEnabled) {
    // We need to add background view first and add other sub view if its not
    // overlimit enabled.
    // Else we need to add the background view on top off the all subviews.
    [backgroundView addSubview:sliderBackgroundImageView];
  }

  [self drawMinimumTrackersWithFirstTrackerValue:firstTrackValue
                              secondTrackerValue:secondTrackValue];
  if (self.isSliderOverLimitEnabled) {
    [self updateFirstMinimumTracerImage];
  }

  if (self.isSliderOffEnabled) {
    CGRect sliderFrame = backgroundView.frame;
    offView = [[UIView alloc]
        initWithFrame:CGRectMake(sliderFrame.size.width + kOffViewSpace,
                                 sliderFrame.origin.y, kOffViewWidth,
                                 sliderFrame.size.height)];
    offView.layer.cornerRadius = kSliderCornerRadius;
    offView.backgroundColor =
        [UIColor colorWithPatternImage:self.sliderBackgroundImage];
    [self addSubview:offView];
  }
}

#pragma mark - Minimum Track
- (void)drawMinimumTrackersWithFirstTrackerValue:(float)firstTrackValue
                              secondTrackerValue:(float)secondTrackValue {
  firstMinimumTrackWidth = 0.0f;
  secondMinimumTrackWidth = 0.0f;

  if (sliderType != kSliderWithDoubleTracker) {
    // Calculation for first minimum tracker imageview width.
    CGRect firstImageViewRect = backgroundView.bounds;
    firstMinimumTrackWidth = (shouldDivideTheTrackValue)
                                 ? (firstTrackValue / numberOfUnit)
                                 : (firstTrackValue * numberOfUnit);
    firstImageViewRect.size.width =
        (self.shouldAnimate) ? 0.0f : firstMinimumTrackWidth;

    // Create the first minimum track imageview and add as subview of the
    // background view.
    firstMinimumTrackImageView =
        [[UIImageView alloc] initWithFrame:firstImageViewRect];

    [firstMinimumTrackImageView setImage:self.firstMinimumTrackImage];
    [backgroundView addSubview:firstMinimumTrackImageView];

    // Calculation for second minimum tracker imageview width.
    CGRect secondImageViewRect = firstImageViewRect;
    secondImageViewRect.origin.x =
        (self.shouldAnimate) ? firstMinimumTrackWidth
                             : CGRectGetMaxX(firstMinimumTrackImageView.frame);
    secondMinimumTrackWidth = (shouldDivideTheTrackValue)
                                  ? (secondTrackValue / numberOfUnit)
                                  : (secondTrackValue * numberOfUnit);
    secondImageViewRect.size.width =
        (self.shouldAnimate) ? 0.0f : secondMinimumTrackWidth;

    // Create the second minimum track imageview and add as subview of the
    // background view.
    secondMinimumTrackImageView =
        [[UIImageView alloc] initWithFrame:secondImageViewRect];
    [secondMinimumTrackImageView setImage:self.secondMinimumTrackImage];
    [backgroundView addSubview:secondMinimumTrackImageView];

    // Add or update the width and Origin X of the Maximum tracker view.
    [self addOrUpdateTrackerRightView];
  } else {
    [self doubleTrackerViewUpdate];
  }
  if (self.isSliderOverLimitEnabled) {
    CGRect sliderBackgroundRect = sliderBackgroundImageView.frame;
    if (sliderType == kSliderWithTracker) {
      sliderBackgroundRect.origin.x =
          CGRectGetMaxX(firstMinimumTrackImageView.frame);
    } else {
      sliderBackgroundRect.origin.x =
          CGRectGetMaxX(secondMinimumTrackImageView.frame);
    }
    sliderBackgroundImageView.frame = sliderBackgroundRect;
    [backgroundView addSubview:sliderBackgroundImageView];
  }

  [self addSubview:backgroundView];

  if (firstTrackerView) {
    [self addSubview:firstTrackerView];
  }

  if (secondTrackerView) {
    [self addSubview:secondTrackerView];
  }

  // Track filling animation
  [self trackViewAnimationWithFirstTrackWidth:firstMinimumTrackWidth
                             secondTrackWidth:secondMinimumTrackWidth];
}

#pragma mark - Animation
- (void)trackViewAnimationWithFirstTrackWidth:(float)firstMinimumViewTrackWidth
                             secondTrackWidth:
                                 (float)secondMinimumViewTrackWidth {
  if (self.shouldAnimate && sliderType != kSliderWithDoubleTracker) {
    if (firstMinimumTrackImageView) {
      CGRect firstMinimumTrackRect = firstMinimumTrackImageView.frame;
      firstMinimumTrackRect.size.width = firstMinimumViewTrackWidth;
      [UIView animateWithDuration:0.30
          delay:0.2
          options:UIViewAnimationOptionCurveEaseInOut
          animations:^{
              firstMinimumTrackImageView.frame = firstMinimumTrackRect;
          }
          completion:^(BOOL finished) {
              if (secondMinimumTrackImageView) {
                CGRect secondMinimumTrackRect =
                    secondMinimumTrackImageView.frame;
                secondMinimumTrackRect.size.width = secondMinimumViewTrackWidth;
                [UIView animateWithDuration:0.20
                    delay:0.0
                    options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        secondMinimumTrackImageView.frame =
                            secondMinimumTrackRect;
                    }
                    completion:^(BOOL finished) {}];
              }
          }];
    }
  }
}

#pragma mark - Image Setup
- (void)trackerImageSetUp {
  // Based on the slider type enable/disable the trackerView and double/Single
  // minimum tracker imageview on the slider.
  if (sliderType == kSliderWithOutTracker) {
    if (!self.firstMinimumTrackImage) {
      self.firstMinimumTrackImage =
          [[UIImage imageNamed:@"slider-line-blue.png"]
              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }

    if (!self.sliderBackgroundImage) {
      self.sliderBackgroundImage = [[UIImage imageNamed:@"slider-line-grey.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }

    self.secondMinimumTrackImage = nil;
  } else if (sliderType == kSliderWithDoubleColor) {
    if (!self.firstMinimumTrackImage) {
      self.firstMinimumTrackImage = [[UIImage imageNamed:@"green.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }

    if (!self.secondMinimumTrackImage) {
      self.secondMinimumTrackImage =
          [[UIImage imageNamed:@"slider-line-blue.png"]
              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }

    if (!self.sliderBackgroundImage) {
      self.sliderBackgroundImage = [[UIImage imageNamed:@"slider-line-grey.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }
  } else if (sliderType == kSliderWithDoubleColorAndTracker) {
    if (!self.firstMinimumTrackImage) {
      self.firstMinimumTrackImage = [[UIImage imageNamed:@"green.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }

    if (self.secondMinimumTrackImage == nil) {
      self.secondMinimumTrackImage =
          [[UIImage imageNamed:@"slider-line-blue.png"]
              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }

    if (!self.sliderBackgroundImage) {
      self.sliderBackgroundImage = [[UIImage imageNamed:@"slider-line-grey.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }
  } else if (sliderType == kSliderWithTracker ||
             sliderType == kSliderWithTrackerAndRightView) {
    if (!self.firstMinimumTrackImage) {
      self.firstMinimumTrackImage =
          [[UIImage imageNamed:@"slider-line-blue.png"]
              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }

    if (!self.sliderBackgroundImage) {
      self.sliderBackgroundImage = [[UIImage imageNamed:@"slider-line-grey.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }

    secondMinimumTrackerValue = 0;
    self.secondMinimumTrackImage = nil;
  } else if (sliderType == kSliderWithDoubleTracker) {
    if (!self.firstMinimumTrackImage) {
      self.firstMinimumTrackImage =
          [[UIImage imageNamed:@"slider-line-blue.png"]
              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }

    if (!self.sliderBackgroundImage) {
      self.sliderBackgroundImage = [[UIImage imageNamed:@"slider-line-grey.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
    }
    secondMinimumTrackerValue = 0;
    self.secondMinimumTrackImage = nil;
  }
}

#pragma mark - Init
- (void)initViews {
  self.backgroundColor = [UIColor clearColor];

  CGRect controlRect = self.bounds;
  controlRect.size.height = kSliderHeight;
  controlRect.origin.x = kBackgroundViewXOrigin;
  controlRect.size.width =
      (controlRect.size.width - (kBackgroundViewXOrigin * 2));
  controlRect.origin.y = (self.bounds.size.height / 2) - (kSliderHeight / 2);

  // Add backgroudn view on the center of the control.
  backgroundView = [[UIView alloc] initWithFrame:controlRect];

  // Rounder corner
  backgroundView.layer.cornerRadius = kSliderCornerRadius;
  backgroundView.clipsToBounds = YES;
  [self calculateCurrentValue];

  sliderBackgroundImageView =
      [[UIImageView alloc] initWithFrame:backgroundView.bounds];
  if (sliderType == kSliderWithTracker ||
      sliderType == kSliderWithDoubleColorAndTracker ||
      sliderType == kSliderWithDoubleTracker ||
      sliderType == kSliderWithTrackerAndRightView) {
    // If slider type is double minimum tracker with Tracker button or slider
    // with track button then we have to add the tracker view.
    firstTrackerView = [[UIView alloc]
        initWithFrame:CGRectMake(
                          (firstTrackerValue - (kTrackerWidth / 2)),
                          (CGRectGetMidY(controlRect) - (kTrackerHeight / 2)),
                          kTrackerWidth, kTrackerHeight)];

    firstTrackerView.backgroundColor = [UIColor clearColor];
    firstTrackerLastAngle = kDefaultLastAngle;

    [self trackerThumbButtonWithView:firstTrackerView];
    if (sliderType == kSliderWithDoubleTracker) {
      secondTrackerLastAngle = kDefaultLastAngle;
      secondTrackerView = [[UIView alloc]
          initWithFrame:CGRectMake(
                            (secondTrackerValue - (kTrackerWidth / 2)),
                            (CGRectGetMidY(controlRect) - (kTrackerHeight / 2)),
                            kTrackerWidth, kTrackerHeight)];
      secondTrackerView.backgroundColor = [UIColor clearColor];
      [self trackerThumbButtonWithView:secondTrackerView];
    }
    if (firstTrackerInitialValue == self.maximumValue && self.enableSliderOff &&
        !self.sliderOff) {
      CGRect firstTrackerViewRect = firstTrackerView.frame;
      firstTrackerViewRect.origin.x -= kOffViewWidth;
      firstTrackerView.frame = firstTrackerViewRect;
    } else if (self.sliderOff && self.enableSliderOff) {
      hideBalloonInOffState = YES;
      [self updateThumbImageForSingleTracker];
    }
  }
}

#pragma mark - Current Value
- (void)calculateCurrentValue {
  // Getting the maximum width of the slider.
  CGFloat backgroudWidth = backgroundView.frame.size.width;
  numberOfUnit = 1;

  if (self.maximumValue < backgroudWidth) {
    /* If slider maximum value is less than the slider width.
       then we have to multiply the numberOfMaxValue (howmany number of maximum
       value available within the slider width)
       with the first minimum tracker value and second minimum tracker value.
     */
    shouldDivideTheTrackValue = NO;
    numberOfUnit = backgroudWidth / self.maximumValue;
    trackerStartValue = (self.minimumValue * numberOfUnit);
    doubleSliderMinimumSpace =
        self.minimumDifferenceBetweenSlider * numberOfUnit;
  } else if (self.maximumValue > backgroudWidth) {
    /* If slider maximum value is greater than the slider width.
       then we have to divide the first minimum tracker value and second minimum
       tracker value with the numberOfMaxValue.
     */
    shouldDivideTheTrackValue = YES;
    numberOfUnit = self.maximumValue / backgroudWidth;
    trackerStartValue = (self.minimumValue / numberOfUnit);
    doubleSliderMinimumSpace =
        self.minimumDifferenceBetweenSlider / numberOfUnit;
  }

  if (trackerStartValue < 0) {
    trackerStartValue = 0;
  }

  if (currentValue > self.maximumValue) {
    currentValue = self.maximumValue;
  }
  if (firstTrackerValue > self.maximumValue && self.minimumValue == 0) {
    firstTrackerValue = self.maximumValue;
  }
  if (secondTrackerValue > self.maximumValue) {
    secondTrackerValue = self.maximumValue;
    return;
  }

  // Calcuate the tracker current value based on the slider width and slider
  // maximum values.
  currentValue = (shouldDivideTheTrackValue) ? (currentValue / numberOfUnit)
                                             : (currentValue * numberOfUnit);

  // Calcuate the first tracker current value based on the slider width and
  // slider maximum values.
  firstTrackerValue = (shouldDivideTheTrackValue)
                          ? (firstTrackerValue / numberOfUnit)
                          : (firstTrackerValue * numberOfUnit);
  firstTrackerValue += kBackgroundViewXOrigin;
  // Calcuate the second tracker current value based on the slider width and
  // slider maximum values.
  secondTrackerValue = (shouldDivideTheTrackValue)
                           ? (secondTrackerValue / numberOfUnit)
                           : (secondTrackerValue * numberOfUnit);

  maximumTrackerValue = backgroundView.bounds.size.width - (kTrackerWidth / 2) +
                        kBackgroundViewXOrigin;
  minimumTrackerValue = ((kTrackerWidth / 2) * -1) + kBackgroundViewXOrigin;
  if (sliderType == kSliderWithDoubleColorAndTracker &&
      self.shouldEnableFirstTrackerValueAsMinimum) {
    doubleColorWithTrackerMinimumPosition =
        firstMinimumTrackWidth + kTrackerWidth;
  }
}

#pragma mark - Tracker (Thump)
- (void)trackerThumbButtonWithView:(UIView *)tracker {
  if (self.sliderRangeDifference) {
    self.sliderRangeDifference =
        (self.sliderRangeDifference > self.maximumValue)
            ? 0
            : self.sliderRangeDifference;
    // If slider range difference is not equal 0 then we have to move the slider
    // as per the given slider range.
    trackerRange = self.maximumValue / self.sliderRangeDifference;
    trackerWidthRange = backgroundView.frame.size.width / trackerRange;
  }

  // Create the tracker Thumb button and as subview of the tracker view.
  UIButton *trackerThumbButton = [UIButton buttonWithType:UIButtonTypeCustom];
  CGRect trackerRect =
      CGRectMake(((kTrackerWidth / 2) - (kTrackerButtonWidth / 2)),
                 kTrackerHeight / 2, kTrackerButtonWidth, kTrackerButtonHeight);

  [trackerThumbButton setFrame:trackerRect];
  [trackerThumbButton setImage:[UIImage imageNamed:@"slider-button.png"]
                      forState:UIControlStateNormal];
  [trackerThumbButton setImage:[UIImage imageNamed:@"slider-button.png"]
                      forState:UIControlStateHighlighted];

  [trackerThumbButton addTarget:self
                         action:@selector(showTrackerTopViewWithView:)
               forControlEvents:UIControlEventTouchDown];
  [trackerThumbButton addTarget:self
                         action:@selector(hideTrackerTopViewWithView:)
               forControlEvents:UIControlEventTouchUpInside];
  [trackerThumbButton setTag:kTrackerThumbButtonTag];
  if (sliderType == kSliderWithDoubleTracker) {
    [trackerThumbButton
        setTitle:(tracker == firstTrackerView) ? kFirstTrackerThumbTitle
                                               : kSecondTrackerThumTitle
        forState:UIControlStateNormal];
  }
  [trackerThumbButton setTitleColor:[UIColor blackColor]
                           forState:UIControlStateNormal];
  trackerThumbButton.titleLabel.font = [UIFont systemFontOfSize:8.0f];
  trackerThumbButton.userInteractionEnabled = YES;
  [tracker addSubview:trackerThumbButton];

  // Add the pan reconginzer to identify the left and right swiping of the
  // tracker view.
  UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(handleSliderMove:)];
  [tracker addGestureRecognizer:gesture];
}

#pragma mark - Right Tracker View
- (void)addOrUpdateTrackerRightView {
  if (sliderType == kSliderWithTrackerAndRightView) {
    // Calculate the origin X and width of the right tracker view.
    CGRect controlRect = self.bounds;
    float rightTrackerXOrigin = (CGRectGetMaxX(firstTrackerView.frame) -
                                 (kTrackerWidth / 2) - kBackgroundViewXOrigin);
    float rightTrackerWidth = controlRect.size.width - rightTrackerXOrigin;
    if (!trackerRightView) {
      // Create the right traker view and add as subview of background view.
      trackerRightView = [[UIView alloc]
          initWithFrame:CGRectMake(rightTrackerXOrigin, controlRect.origin.y,
                                   rightTrackerWidth, kSliderHeight)];
      trackerRightView.backgroundColor = [UIColor blackColor];
      trackerRightView.alpha = 0.4;
      [backgroundView addSubview:trackerRightView];
    } else {
      // While move the tracker view we need update the right tracker view width
      // and Origin X.
      CGRect rightViewFrame = trackerRightView.frame;
      rightViewFrame.origin.x = rightTrackerXOrigin;
      rightViewFrame.size.width = rightTrackerWidth;
      trackerRightView.frame = rightViewFrame;
    }
    [backgroundView bringSubviewToFront:trackerRightView];
  }
}

#pragma mark - Show Balloon
- (void)showTrackerTopViewWithView:(id)trackerButton {
  UIView *tracker;
  if ([trackerButton isKindOfClass:[UIButton class]]) {
    UIButton *trackerThumb = (UIButton *)trackerButton;
    tracker = trackerThumb.superview;
  } else {
    tracker = (UIView *)trackerButton;
  }

  if ([tracker.subviews count] > 1) {
    return;
  }
  // Create balloon imageview and label and add as subview of tracker view with
  // animation.
  UIImageView *balloonImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(
                        ((kTrackerWidth / 2) - (kTrackerTopImageWidth / 2)),
                        kTrackerHeight / 2 - kTrackerTopImageHeight / 2,
                        kTrackerTopImageWidth, kTrackerTopImageHeight)];
  [balloonImageView setTag:kTrackerBalloonImageTag];
  UILabel *balloonLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, kTrackerTopImageHeight / 2 -
                                      kCurrentValueLabelHeight / 2,
                               kTrackerTopImageWidth,
                               kCurrentValueLabelHeight)];
  float trackerValue = 0.0f;
  if (currentValue != kSliderOffValue) {
    trackerValue = [self getTrackerCurrentValueWithView:tracker];
  } else {
    trackerValue = currentValue;
  }

  if (self.enableSliderOff && trackerValue == kSliderOffValue) {
    balloonLabel.text = kBalloonOffValue;
  } else if (self.displayInDecimalFormat) {
    balloonLabel.text = [NSString stringWithFormat:@"%.1f", trackerValue];
  } else {
    balloonLabel.text = [NSString stringWithFormat:@"%.f", trackerValue];
  }
  balloonLabel.textAlignment = NSTextAlignmentCenter;
  [balloonLabel setTag:kTrackerBalloonLabelTag];
  // balloonLabel.font = [UIFont getTelenorFontFamily:Telenor_Light forSize:14];
  balloonLabel.textColor = [UIColor whiteColor];
  balloonLabel.backgroundColor = [UIColor clearColor];
  [balloonImageView addSubview:balloonLabel];

  if (trackerValue < firstMinimumTrackerValue && self.enableSliderOverLimit &&
      trackerValue != kSliderOffValue) {
    balloonImageView.image =
        [UIImage imageNamed:@"slider_bubble_overlimit.png"];
  } else {
    balloonImageView.image = [UIImage imageNamed:@"slider_bubble.png"];
  }
  [tracker addSubview:balloonImageView];

  BOOL animated =
      [self calculateRotationAngleWithPoint:CGPointMake(0, 0) tracker:tracker];

  CGAffineTransform tranform =
      (!animated) ? CGAffineTransformIdentity : balloonImageView.transform;
  [balloonImageView layer].anchorPoint = kBalloonAnchorPoint;

  balloonImageView.transform =
      CGAffineTransformScale(tranform, kMinimumScale, kMinimumScale);
  [UIView animateWithDuration:0.3
      animations:^{
          balloonImageView.transform =
              CGAffineTransformScale(tranform, kMaximumScale, kMaximumScale);
      }
      completion:^(BOOL finished) {
          [balloonImageView layer].anchorPoint = kBalloonAnchorPoint;
          [UIView animateWithDuration:0.1
                           animations:^{
                               balloonImageView.transform =
                                   CGAffineTransformScale(
                                       tranform, kNormalScale, kNormalScale);
                           }];
      }];
}

#pragma mark - Hide Balloon
- (void)hideTrackerTopViewWithView:(id)trackerButton {
  UIView *tracker;
  if ([trackerButton isKindOfClass:[UIButton class]]) {
    UIButton *trackerThumb = (UIButton *)trackerButton;
    tracker = trackerThumb.superview;
  } else {
    tracker = (UIView *)trackerButton;
  }

  UIImageView *balloonImageView =
      (UIImageView *)[tracker viewWithTag:kTrackerBalloonImageTag];
  UILabel *balloonLabel =
      (UILabel *)[tracker viewWithTag:kTrackerBalloonLabelTag];

  balloonImageView.layer.anchorPoint = kBalloonAnchorPoint;
  [UIView animateWithDuration:0.25
      animations:^{
          balloonImageView.transform = CGAffineTransformScale(
              CGAffineTransformIdentity, kMinimumScale, kMinimumScale);
      }
      completion:^(BOOL finished) {
          [balloonLabel removeFromSuperview];
          [balloonImageView removeFromSuperview];
      }];

  float currentTrackerValue = [self getTrackerCurrentValueWithView:tracker];
  float oldValue = 0.0f;
  if (tracker == firstTrackerView) {
    oldValue = firstTrackerInitialValue + self.minimumValue;
  } else if (tracker == secondTrackerView) {
    oldValue = secondTrackerInitialValue + self.minimumValue;
  }

  if (self.delegate && currentTrackerValue != oldValue) {
    dispatch_async(delegateQueue, ^{
        if (sliderType == kSliderWithDoubleTracker) {
          if ([self.delegate
                  respondsToSelector:
                      @selector(slider:
                          didThumbThouchEndWithFirstTrackerValue:
                                              secondTrackerValue:)]) {
            float firstTrackerCurrentValue =
                [self getTrackerCurrentValueWithView:firstTrackerView];
            float secondTrackerCurrentValue =
                [self getTrackerCurrentValueWithView:secondTrackerView];
            [self.delegate slider:self
                didThumbThouchEndWithFirstTrackerValue:firstTrackerCurrentValue
                                    secondTrackerValue:
                                        secondTrackerCurrentValue];
          }
        } else {
          if ([self.delegate
                  respondsToSelector:@selector(slider:
                                         didThumbThouchEndWithValue:)]) {
            [self.delegate slider:self
                didThumbThouchEndWithValue:currentTrackerValue];
          }
        }
    });
  }
}

#pragma mark - Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  if (touch.view == firstTrackerView || touch.view == secondTrackerView) {
    [self showTrackerTopViewWithView:touch.view];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // Touch end we have to hide the balloon imageview.
  UITouch *touch = [touches anyObject];
  if (touch.view == firstTrackerView || touch.view == secondTrackerView) {
    [self hideTrackerTopViewWithView:touch.view];
  }
}

#pragma mark - Pan Recognizer
- (void)handleSliderMove:(UIPanGestureRecognizer *)gesture {
  // Get the user tragging length based on that change frame of the tracker
  // view.
  CGPoint point = [gesture translationInView:self];
  CGRect trackerFrame = gesture.view.frame;
  if (self.sliderRangeDifference) {
    float directionBasedTrackerWidthRange =
        (point.x > 0) ? trackerWidthRange : (trackerWidthRange * -1);
    if ((point.x < directionBasedTrackerWidthRange &&
         directionBasedTrackerWidthRange > 0) ||
        (point.x > directionBasedTrackerWidthRange &&
         directionBasedTrackerWidthRange < 0)) {
      // No need to update the tracker view frame.
    } else {
      // Reset the gesture translation value. Otherwise view translation points
      // keep on increasing.
      // If translation poing keep on increasing or decreasing then we can't
      // calculate the tragging the tracker view frame.
      [gesture setTranslation:CGPointZero inView:self];
      trackerFrame.origin.x += directionBasedTrackerWidthRange;
    }
  } else {
    trackerFrame.origin.x += point.x;
  }

  if (!self.sliderRangeDifference) {
    // Reset the gesture translation value. Otherwise view translation points
    // keep on increasing.
    // If translation poing keep on increasing or decreasing then we can't
    // calculate the tragging the tracker view frame.
    [gesture setTranslation:CGPointZero inView:self];
  }

  sliderPreviousValue = currentValue;
  [self calculateRotationAngleWithPoint:point tracker:gesture.view];

  hideBalloonInOffState = NO;

  if (CGRectGetMidX(firstTrackerView.frame) >= backgroundViewMaxX &&
      self.isSliderOffEnabled && trackerFrame.origin.x >= maximumTrackerValue) {
    // If we need the slider off corner then we need check the firsttracker
    // reaches the offView minimum X origin. If it reaches the we have to set
    // some different current value (kSliderOffValue).
    trackerFrame.origin.x = maximumTrackerValue;
    currentValue = kSliderOffValue;
    hideBalloonInOffState = YES;
  } else if (trackerFrame.origin.x <= minimumTrackerValue) {
    trackerFrame.origin.x = minimumTrackerValue;
    currentValue = self.minimumValue;
  } else if (trackerFrame.origin.x >= maximumTrackerValue) {
    trackerFrame.origin.x = maximumTrackerValue;
    currentValue = self.maximumValue + self.minimumValue;
  } else if (trackerFrame.origin.x <= doubleColorWithTrackerMinimumPosition &&
             self.shouldEnableFirstTrackerValueAsMinimum) {
    trackerFrame.origin.x = doubleColorWithTrackerMinimumPosition;
    currentValue = doubleColorWithTrackerMinimumValue;
  } else {
    currentValue = [self getTrackerCurrentValueWithView:gesture.view];
  }

  firstTrackerMoved = YES;

  if (sliderType == kSliderWithDoubleTracker) {
    if (gesture.view == firstTrackerView) {
      CGFloat secondTrackerPosition =
          (CGRectGetMaxX(secondTrackerView.frame) - (kTrackerWidth / 2));
      secondTrackerPosition -= doubleSliderMinimumSpace;
      if ((trackerFrame.origin.x + kTrackerWidth / 2) >=
          secondTrackerPosition) {
        trackerFrame.origin.x =
            secondTrackerView.frame.origin.x - doubleSliderMinimumSpace;
      }
      firstTrackerValue = currentValue;
    }
    if (gesture.view == secondTrackerView) {
      secondTrackerMoved = YES;
      CGFloat firstTrackerPosition =
          (CGRectGetMaxX(firstTrackerView.frame) - (kTrackerWidth / 2));
      firstTrackerPosition += doubleSliderMinimumSpace;

      if ((trackerFrame.origin.x + kTrackerWidth / 2) <= firstTrackerPosition) {
        trackerFrame.origin.x =
            firstTrackerView.frame.origin.x + doubleSliderMinimumSpace;
      }
      secondTrackerValue = currentValue;
    }
  }
  [self adjustMinimumTracker];
  gesture.view.frame = trackerFrame;

  UILabel *balloonLabel =
      (UILabel *)[gesture.view viewWithTag:kTrackerBalloonLabelTag];
  if (self.enableSliderOff && hideBalloonInOffState) {
    balloonLabel.text = kBalloonOffValue;
  } else if (self.displayInDecimalFormat) {
    balloonLabel.text = [NSString stringWithFormat:@"%.1f", currentValue];
  } else {
    balloonLabel.text = [NSString stringWithFormat:@"%.f", currentValue];
  }
  [self doubleTrackerViewUpdate];

  // Based on the tracker view current position we have to update the right
  // tracker view size and origins
  [self addOrUpdateTrackerRightView];

  if (sliderPreviousValue != currentValue) {
    // if slider current value not equal to previous value then update the
    // delegate class methods.
    [self sliderValueChanged];
  }
  if (gesture.state == UIGestureRecognizerStateEnded) {
    [self sliderValueChanged];
    [self hideTrackerTopViewWithView:gesture.view];
  }

  if (gesture.state == UIGestureRecognizerStateBegan) {
    [self showTrackerTopViewWithView:gesture.view];
  }
}

#pragma mark - Adjust the Minimum Tracker Width
- (void)adjustMinimumTracker {
  if (sliderType == kSliderWithDoubleColorAndTracker) {
    if (secondMinimumTrackImageView && firstMinimumTrackImageView) {
      float trackerCurrentLocation =
          CGRectGetMidX(firstTrackerView.frame) - kBackgroundViewXOrigin;
      CGRect secondMinimumTrackerRect = secondMinimumTrackImageView.frame;
      UIImageView *balloonImageView =
          (UIImageView *)[firstTrackerView viewWithTag:kTrackerBalloonImageTag];

      if (trackerCurrentLocation <= firstMinimumTrackWidth &&
          self.isSliderOverLimitEnabled) {
        // This will override the first minimum tracker view with the background
        // view.
        firstMinimumTrackImageView.image =
            [[UIImage imageNamed:@"slider-line-overlimit.png"]
                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
        balloonImageView.image =
            [UIImage imageNamed:@"slider_bubble_overlimit.png"];
        self.isOverLimit = YES;
      } else if (trackerCurrentLocation <= firstMinimumTrackWidth) {
        float trackerCurrentLocation =
            CGRectGetMidX(firstTrackerView.frame) - kBackgroundViewXOrigin;
        CGRect firstMinimumTrackerRect = firstMinimumTrackImageView.frame;
        firstMinimumTrackerRect.size.width = trackerCurrentLocation;
        firstMinimumTrackImageView.frame = firstMinimumTrackerRect;
        CGRect secondMinimumTrackerRect = firstMinimumTrackImageView.frame;
        secondMinimumTrackerRect.size.width = 0.0f;
        secondMinimumTrackImageView.frame = secondMinimumTrackerRect;
        balloonImageView.image = [UIImage imageNamed:@"slider_bubble.png"];
        firstMinimumTrackImageView.image = [self.firstMinimumTrackImage
            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
        self.isOverLimit = NO;
      } else {
        CGRect firstMinimumTrackerRect = firstMinimumTrackImageView.frame;
        firstMinimumTrackerRect.size.width = firstMinimumTrackWidth;
        firstMinimumTrackImageView.frame = firstMinimumTrackerRect;
        balloonImageView.image = [UIImage imageNamed:@"slider_bubble.png"];
        firstMinimumTrackImageView.image = [self.firstMinimumTrackImage
            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
        self.isOverLimit = NO;
      }

      // Update Backgroud view frame;
      CGRect sliderBackgroundRect = sliderBackgroundImageView.frame;
      sliderBackgroundRect.origin.x = trackerCurrentLocation;
      sliderBackgroundImageView.frame = sliderBackgroundRect;

      if (trackerCurrentLocation >= firstMinimumTrackWidth) {
        CGFloat secondTrackerWidth =
            (trackerCurrentLocation > firstMinimumTrackWidth)
                ? (trackerCurrentLocation - firstMinimumTrackWidth)
                : (trackerCurrentLocation + firstMinimumTrackWidth);
        secondMinimumTrackerRect.origin.x = firstMinimumTrackWidth;
        secondMinimumTrackerRect.size.width = secondTrackerWidth;
        secondMinimumTrackImageView.frame = secondMinimumTrackerRect;
      }
    }
  }
  if (sliderType == kSliderWithTracker && firstMinimumTrackImageView) {
    [self bringSubviewToFront:sliderBackgroundImageView];

    float trackerCurrentLocation =
        CGRectGetMidX(firstTrackerView.frame) - kBackgroundViewXOrigin;
    UIImageView *balloonImageView =
        (UIImageView *)[firstTrackerView viewWithTag:kTrackerBalloonImageTag];
    if (trackerCurrentLocation <= firstMinimumTrackWidth &&
        self.isSliderOverLimitEnabled) {
      // This will override the first minimum tracker view with the background
      // view.
      firstMinimumTrackImageView.image =
          [[UIImage imageNamed:@"slider-line-overlimit.png"]
              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
      balloonImageView.image =
          [UIImage imageNamed:@"slider_bubble_overlimit.png"];
      self.isOverLimit = YES;
    } else {
      CGRect firstMinimumTrackerRect = firstMinimumTrackImageView.frame;
      firstMinimumTrackerRect.size.width = trackerCurrentLocation;
      firstMinimumTrackImageView.frame = firstMinimumTrackerRect;
      firstMinimumTrackImageView.image = [self.firstMinimumTrackImage
          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];
      balloonImageView.image = [UIImage imageNamed:@"slider_bubble.png"];
      self.isOverLimit = NO;
    }
    // Update Backgroud view frame;
    CGRect sliderBackgroundRect = sliderBackgroundImageView.frame;
    sliderBackgroundRect.origin.x = trackerCurrentLocation;
    sliderBackgroundImageView.frame = sliderBackgroundRect;
  }
}

#pragma mark - Double Tracker update
- (void)doubleTrackerViewUpdate {
  if (sliderType == kSliderWithDoubleTracker) {
    CGRect firstImageViewRect = backgroundView.bounds;
    float firstTrackerCurrentPosition = CGRectGetMaxX(firstTrackerView.frame) -
                                        kTrackerWidth / 2 -
                                        kBackgroundViewXOrigin;
    float secondTrackerCurrentPosition =
        CGRectGetMaxX(secondTrackerView.frame) - kTrackerWidth / 2 -
        kBackgroundViewXOrigin;
    firstImageViewRect.origin.x = firstTrackerCurrentPosition;
    firstImageViewRect.size.width =
        secondTrackerCurrentPosition - firstTrackerCurrentPosition;

    if (!firstMinimumTrackImageView) {
      // Create the first minimum track imageview and add as subview of the
      // background view.
      firstMinimumTrackImageView =
          [[UIImageView alloc] initWithFrame:firstImageViewRect];
      [firstMinimumTrackImageView setImage:self.firstMinimumTrackImage];
      [backgroundView addSubview:firstMinimumTrackImageView];
    } else {
      firstMinimumTrackImageView.frame = firstImageViewRect;
    }
  }
}

#pragma mark - Calculate Current Value
- (float)getTrackerCurrentValueWithView:(UIView *)tracker {
  if (self.isSliderOffEnabled &&
      CGRectGetMidX(firstTrackerView.frame) >= backgroundViewMaxX &&
      tracker.frame.origin.x >= maximumTrackerValue) {
    return kSliderOffValue;
  }

  if (tracker == firstTrackerView && !firstTrackerMoved) {
    return firstTrackerInitialValue + self.minimumValue;
  } else if (tracker == secondTrackerView && !secondTrackerMoved) {
    return secondTrackerInitialValue + self.minimumValue;
  }

  float trackerValue = 0;
  float trackerCurrentPosition =
      (CGRectGetMaxX(tracker.frame) - (kTrackerWidth / 2)) -
      kBackgroundViewXOrigin;

  // Calculate the slider current value based on the slider width and the slider
  // maixmum values.
  if (shouldDivideTheTrackValue) {
    trackerValue = (trackerCurrentPosition * numberOfUnit);
  } else {
    trackerValue = (trackerCurrentPosition / numberOfUnit);
  }
  trackerValue = trackerValue + self.minimumValue;
  if (!self.displayInDecimalFormat) {
    trackerValue = nearbyintf(trackerValue);
  }

  return trackerValue;
}

#pragma mark - Delegate
- (void)sliderValueChanged {
  [self updateThumbImageForSingleTracker];
  dispatch_async(delegateQueue, ^{
      if (self.delegate) {
        if (sliderType == kSliderWithDoubleTracker) {
          // For range slider we are calling the different protocol mehtods.
          if ([self.delegate
                  respondsToSelector:@selector(slider:
                                         rangeChangedWithStartValue:
                                                           endValue:)]) {
            firstTrackerValue =
                [self getTrackerCurrentValueWithView:firstTrackerView];
            secondTrackerValue =
                [self getTrackerCurrentValueWithView:secondTrackerView];
            [self.delegate slider:self
                rangeChangedWithStartValue:firstTrackerValue
                                  endValue:secondTrackerValue];
          }
        } else {
          if ([self.delegate
                  respondsToSelector:@selector(slider:
                                         valueChangedWithNewValue:
                                                         oldValue:)]) {
            [self.delegate slider:self
                valueChangedWithNewValue:currentValue
                                oldValue:sliderPreviousValue];
          }
        }
      }
  });
}

#pragma mark - CurrentProgressValue
- (float)currentProgressValue {
  return [self getTrackerCurrentValueWithView:firstTrackerView];
}

#pragma mark - Remove Subviews
- (void)removeSubViews {
  NSArray *subviews = [self subviews];
  if ([subviews count]) {
    self.maximumValue = self.maximumValue + self.minimumValue;
    for (UIView *subview in subviews) {
      [subview removeFromSuperview];
    }
  }
}

#pragma mark -

- (SMSliderType)currentSliderType {
  return sliderType;
}

#pragma mark - Overlimit image
- (void)updateFirstMinimumTracerImage {
  if (sliderType == kSliderWithTracker ||
      sliderType == kSliderWithDoubleColorAndTracker) {
    float currentSliderValue =
        [self getTrackerCurrentValueWithView:firstTrackerView];
    if (currentSliderValue < firstMinimumTrackerValue &&
        self.enableSliderOverLimit && !self.isSliderOff) {
      firstMinimumTrackImageView.image =
          [[UIImage imageNamed:@"slider-line-overlimit.png"]
              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1.0, 0, 0)];

      float trackerCurrentLocation =
          CGRectGetMidX(firstTrackerView.frame) - kBackgroundViewXOrigin;
      // Update Backgroud view frame;
      CGRect sliderBackgroundRect = sliderBackgroundImageView.frame;
      sliderBackgroundRect.origin.x = trackerCurrentLocation;
      sliderBackgroundImageView.frame = sliderBackgroundRect;
      self.isOverLimit = YES;
    } else {
      self.isOverLimit = NO;
    }
  }
}

@end
