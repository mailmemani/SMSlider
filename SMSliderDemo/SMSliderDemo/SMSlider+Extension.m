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

#import "SMSlider+Extension.h"
#import "SMSlider_Extension.h"
#import "SMSliderConstant.h"
#import <math.h>

@implementation SMSlider (Extension)

#pragma mark - CalculateAngle
- (BOOL)calculateRotationAngleWithPoint:(CGPoint)point tracker:(UIView *)trackerView {
	BOOL animated = YES;
	CGRect angleFrame = [[UIScreen mainScreen]bounds];
	if (CGRectGetMaxX(trackerView.frame) >= CGRectGetMaxX(angleFrame)) {
		//Right most corner angle
		if (point.x > 0) {
			angle += kBalloonRotateIncrementValue;
			if (angle > kMaximumAngle) {
				angle = kMaximumAngle;
			}
		}
		else if (point.x < 0) {
			if (CGRectGetMaxX(trackerView.frame) <= CGRectGetMaxX(angleFrame)) {
				angle = kDefaultAngle;
			}
			else if (angle > kDefaultAngle) {
				angle -= kBalloonRotateDecrementValue;
			}
		}
		else {
			if (trackerView == firstTrackerView) {
				angle = (firstTrackerLastAngle == kDefaultLastAngle) ? kMaximumAngle : firstTrackerLastAngle;
			}
			else {
				angle = (secondTrackerLastAngle == kDefaultLastAngle) ? kMaximumAngle : secondTrackerLastAngle;
			}
		}
		[self rotateTopViewWithTrackerView:trackerView];
	}
	else if (CGRectGetMinX(trackerView.frame) <= CGRectGetMinX(angleFrame)) {
		//Left most corner angle
		if (point.x > 0) {
			if (CGRectGetMinX(trackerView.frame) >= CGRectGetMinX(angleFrame)) {
				angle = kDefaultAngle;
			}
			else if (angle < kDefaultAngle) {
				angle += kBalloonRotateIncrementValue;
			}
		}
		else if (point.x < 0) {
			angle -= kBalloonRotateDecrementValue;
			if (angle <= (kMaximumAngle * -1)) {
				angle = (kMaximumAngle * -1);
			}
		}
		else {
			if (trackerView == firstTrackerView) {
				angle = (firstTrackerLastAngle == kDefaultLastAngle) ? (kMaximumAngle * -1) : firstTrackerLastAngle;
			}
			else {
				angle = (secondTrackerLastAngle == kDefaultLastAngle) ? (kMaximumAngle * -1) : secondTrackerLastAngle;
			}
		}
		[self rotateTopViewWithTrackerView:trackerView];
	}
	else {
		//Default angle
		if (angle != kDefaultAngle) {
			angle = kDefaultAngle;
			[self rotateTopViewWithTrackerView:trackerView];
		}
		else {
			animated = NO;
		}
	}
	if (trackerView == secondTrackerView) {
		secondTrackerLastAngle = angle;
	}
	else {
		firstTrackerLastAngle = angle;
	}
	return animated;
}

#pragma mark - Rotation
- (void)rotateTopViewWithTrackerView:(UIView *)tracker {
	UIImageView *trackerBalloonView = (UIImageView *)[tracker viewWithTag:kTrackerBalloonImageTag];
	UILabel *trackerLabel = (UILabel *)[tracker viewWithTag:kTrackerBalloonLabelTag];
	trackerBalloonView.layer.anchorPoint = CGPointMake(0.5, 1.0);
	trackerLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
	float animationTime = 0.3f;
	if (angle == kMaximumAngle || angle == -kMaximumAngle) {
		animationTime = 1.0;
	}
	[UIView animateWithDuration:0.3 animations: ^{
	    if (angle == 0.0) {
	        trackerLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(0.0f));
		}
	    else {
	        trackerLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(angle));
		}
	}];
	[UIView animateWithDuration:animationTime animations: ^{
	    float rotationAngle = DEGREES_TO_RADIANS(angle) * -1.0;
	    trackerBalloonView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, rotationAngle);
	} completion: ^(BOOL finished) {
	}];
}

#pragma mark - Change ThumbImage
- (void)updateThumbImageForSingleTracker {
	UIButton *trackerThumbButton = (UIButton *)[firstTrackerView viewWithTag:kTrackerThumbButtonTag];

	if (trackerThumbButton) {
		if (hideBalloonInOffState && self.enableSliderOff) {
			[trackerThumbButton setImage:[UIImage imageNamed:@"slider_off.png"] forState:UIControlStateNormal];
			[trackerThumbButton setImage:[UIImage imageNamed:@"slider_off.png"] forState:UIControlStateHighlighted];
		}
		else {
			[trackerThumbButton setImage:[UIImage imageNamed:@"slider-button.png"] forState:UIControlStateNormal];
			[trackerThumbButton setImage:[UIImage imageNamed:@"slider-button.png"] forState:UIControlStateHighlighted];
		}
	}
}

@end
