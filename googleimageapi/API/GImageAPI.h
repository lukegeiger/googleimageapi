//
//  GImageAPI.h
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GImageAPI : NSObject

/**
 Singleton instance.
 */
+ (GImageAPI*)sharedAPI;


/*
 Fetches Photos.
*/
- (void)fetchPhotosForQuery:(NSString*)query shouldPage:(BOOL)shouldPage onCompletion:(void (^)(NSArray *gimages, NSError *gError))completion;


/*
 Resets the current page of the photo API
*/
- (void)reset;

@end

