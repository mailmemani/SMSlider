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

@interface SMSlider (Extension)

/**
 * @brief This method will rotate the balloon image based on the where its
 * appearing
 * @param point point values of the balloon.
 * @param trackerView pass the tracker view which is going to rotate.
 * @return BOOL
 */

- (BOOL)calculateRotationAngleWithPoint:(CGPoint)point
                                tracker:(UIView *)trackerView;

/**
 * @brief This method will update the first tracker thumb image based on the
 * current tracker position
 * @param -
 * @return void
 */
- (void)updateThumbImageForSingleTracker;

@end
