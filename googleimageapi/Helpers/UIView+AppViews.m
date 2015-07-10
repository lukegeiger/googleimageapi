//
//  UIView+AppViews.m
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import "UIView+AppViews.h"

@implementation UIView (AppViews)

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Frame

- (CGFloat) height {
    return self.frame.size.height;
}

- (CGFloat) width {
    return self.frame.size.width;
}

- (CGFloat) x {
    return self.frame.origin.x;
}

- (CGFloat) y {
    return self.frame.origin.y;
}

- (CGFloat) bottomY {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat) endX {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat) centerY {
    return self.center.y;
}

- (CGFloat) centerX {
    return self.center.x;
}

- (CGPoint) origin{
    return self.frame.origin;
}

- (CGSize) size{
    return self.frame.size;
}

- (void) setHeight:(CGFloat) newHeight {
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

- (void) setWidth:(CGFloat) newWidth {
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

- (void) setX:(CGFloat) newX {
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

- (void) setY:(CGFloat) newY {
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

- (void) setBottomY:(CGFloat)newBottomY {
    CGRect frame = self.frame;
    frame.origin.y = newBottomY - frame.size.height;
    self.frame = frame;
}

- (void) setEndX:(CGFloat)newEndX {
    CGRect frame = self.frame;
    frame.origin.x = newEndX - frame.size.width;
    self.frame = frame;
}

- (void) setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
}

- (void) setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

@end
