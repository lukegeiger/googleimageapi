//
//  GImage.h
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GImage : NSObject

/*
 Comment
*/
@property (nonatomic, readonly) NSString *imageTitle;

/*
 Comment
 */
@property (nonatomic, readonly) NSString *content;

/*
 Comment
 */
@property (nonatomic, readonly) NSString *imageId;

/*
 Comment
 */
@property (nonatomic, readonly) CGSize size;

/*
 Comment
 */
@property (nonatomic, readonly) NSURL* url;

/*
 Comment
 */
@property (nonatomic, readonly) NSURL* thumbURL;

/*
 Comment
 */
@property (nonatomic, assign) CGSize thumbSize;

/*
 Comment
 @param
 @return
 */
+(GImage*)gImageFromDict:(NSDictionary*)dict;

@end
