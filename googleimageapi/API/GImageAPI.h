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

@property (nonatomic, readonly) NSString *lastQuery;

- (void)beginFetchingPhotosForQuery:(NSString*)string;

- (void)fetchPhotosForQuery:(NSString*)query onCompletion:(void (^)(NSArray *gimages, NSError *gError))completion;

- (void)fetchNextPageOnCompletion:(void (^)(NSArray *gimages, NSError *gError))completion;

@end

