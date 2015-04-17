//
//  CMPopTipView.h
//
//  Created by Chris Miles on 18/07/10.
//  Copyright (c) Chris Miles 2010-2011.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/** \brief	Display a speech bubble-like popup on screen, pointing at the
			designated view or button.
 
	A UIView subclass drawn using core graphics. Pops up (optionally animated)
	a speech bubble-like view on screen, a rounded rectangle with a gradiant
	fill containing a specified text message, drawn with a pointer dynamically
	positioned to point at the center of the designated button or view.
 
 Example 1 - point at a UIBarButtonItem in a nav bar:
 
	- (void)showPopTipView {
		NSString *message = @"Start by adding a waterway to your favourites.";
		CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:message];
		popTipView.delegate = self;
		[popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
		
		self.myPopTipView = popTipView;
		[popTipView release];
	}

	- (void)dismissPopTipView {
		[self.myPopTipView dismissAnimated:NO];
		self.myPopTipView = nil;
	}

 
	#pragma mark CMPopTipViewDelegate methods
	- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
		// User can tap CMPopTipView to dismiss it
		self.myPopTipView = nil;
	}

 Example 2 - pointing at a UIButton:

	- (IBAction)buttonAction:(id)sender {
		// Toggle popTipView when a standard UIButton is pressed
		if (nil == self.roundRectButtonPopTipView) {
			self.roundRectButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:@"My message"] autorelease];
			self.roundRectButtonPopTipView.delegate = self;

			UIButton *button = (UIButton *)sender;
			[self.roundRectButtonPopTipView presentPointingAtView:button inView:self.view animated:YES];
		}
		else {
			// Dismiss
			[self.roundRectButtonPopTipView dismissAnimated:YES];
			self.roundRectButtonPopTipView = nil;
		}	
	}

	#pragma mark CMPopTipViewDelegate methods
	- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
		// User can tap CMPopTipView to dismiss it
		self.roundRectButtonPopTipView = nil;
	}
 
 */

#import <UIKit/UIKit.h>

typedef enum {
	PointDirectionUp = 0,
	PointDirectionDown,
    PointDirectionAuto
} PointDirection;

typedef enum {
    CMPopTipAnimationSlide = 0,
    CMPopTipAnimationPop
} CMPopTipAnimation;


@protocol CMPopTipViewDelegate;


@interface CMPopTipView : UIView {
	UIColor					*backgroundColor;
	__unsafe_unretained id<CMPopTipViewDelegate>	delegate;
	NSString				*message;
	id						targetObject;
	UIColor					*textColor;
	UIFont					*textFont;
    CMPopTipAnimation       animation;

	@private
	CGSize					bubbleSize;
	CGFloat					cornerRadius;
	BOOL					highlight;
	CGFloat					sidePadding;
	CGFloat					topMargin;
	PointDirection			_pointDirection;
	CGFloat					pointerSize;
	CGPoint					targetPoint;
    
    BOOL                    _needBubblePath;
    BOOL                    _withoutBubble;
}

@property (nonatomic, retain)			UIColor					*backgroundColor;
@property (nonatomic, assign)		id<CMPopTipViewDelegate>	delegate;
@property (nonatomic, assign)			BOOL					disableTapToDismiss;
@property (nonatomic, retain)			NSString				*message;
@property (nonatomic, retain)           UIView	                *customView;
@property (nonatomic, retain, readonly)	id						targetObject;
@property (nonatomic, retain)			UIColor					*textColor;
@property (nonatomic, retain)			UIFont					*textFont;
@property (nonatomic, assign)			NSTextAlignment			textAlignment;
@property (nonatomic, assign)           CMPopTipAnimation       animation;
@property (nonatomic, assign)           CGFloat                 maxWidth;
@property (nonatomic, assign)           BOOL                    isPopup;
@property (nonatomic, assign)           CGFloat                 pointerSize;
@property (nonatomic, assign)           CGFloat                 cornerRadius;
@property (nonatomic, assign)           BOOL         noAdjustCustomViewFrame;
@property (nonatomic, assign)           BOOL         clickSpaceToDismiss;
@property (nonatomic, retain)           UITapGestureRecognizer  *tapGesture;

@property (retain, nonatomic) UIView *maskView;


/* Contents can be either a message or a UIView */
- (id)initWithMessage:(NSString *)messageToShow;
- (id)initWithMessage:(NSString *)messageToShow needBubblePath:(BOOL)needBubblePath;
- (id)initWithMessageWithoutBubble:(NSString *)messageToShow;

- (id)initWithCustomView:(UIView *)aView;
- (id)initWithCustomView:(UIView *)aView needBubblePath:(BOOL)needBubblePath;
- (id)initWithCustomView:(UIView *)aView
             pointerSize:(CGFloat)pointerSize;

- (id)initWithCustomViewWithoutBubble:(UIView *)aView;

- (void)presentPointingAtView:(UIView *)targetView 
                       inView:(UIView *)containerView
                     animated:(BOOL)animated;

- (void)presentPointingAtView:(UIView *)targetView 
                       inView:(UIView *)containerView
                    aboveView:(UIView *)aboveView
                     animated:(BOOL)animated;

- (void)presentPointingAtView:(UIView *)targetView
                       inView:(UIView *)containerView 
                     animated:(BOOL)animated
               pointDirection:(PointDirection)pointDirection;

- (void)presentPointingAtView:(UIView *)targetView
                       inView:(UIView *)containerView 
                    aboveView:(UIView *)aboveView
                     animated:(BOOL)animated
               pointDirection:(PointDirection)pointDirection;


- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem
                              animated:(BOOL)animated;

- (void)dismissAnimated:(BOOL)animated;

- (PointDirection) getPointDirection;

@end


@protocol CMPopTipViewDelegate <NSObject>

@optional
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView;
- (void)popTipViewWasDismissedByCallingDismissAnimatedMethod:(CMPopTipView *)popTipView;

@end