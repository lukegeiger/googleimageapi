//
//  GImageAPI.m
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

//Header
#import "GImageAPI.h"
//Models
#import "GImage.h"
//Networking
#import "AFNetworking.h"

@interface GImageAPI ()
@property (nonatomic, strong) NSString *lastQuery;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation GImageAPI

+(GImageAPI *)sharedAPI{
    
    static dispatch_once_t pred;
    static GImageAPI *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[GImageAPI alloc] init];
        shared.currentPage = 0;
    });
    return shared;
}

- (void)fetchPhotosForQuery:(NSString*)query shouldPage:(BOOL)shouldPage onCompletion:(void (^)(NSArray *gimages, NSError *gError))completion{

    self.lastQuery = query;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [self paramDictForSearchTerm:query start:[NSNumber numberWithInteger:self.currentPage]];
    [manager GET:[self rootAPIString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *fullResponse = (NSDictionary*)responseObject;
        
        if ([[fullResponse objectForKey:@"responseStatus"]intValue] == 200) {
            
            NSDictionary *responseData = [fullResponse objectForKey:@"responseData"];
            NSDictionary *cursor = [responseData objectForKey:@"cursor"];
            NSArray *cursorPages = [cursor objectForKey:@"pages"];
            NSDictionary *pageResults = [responseData objectForKey:@"results"];
            NSMutableArray *parsedImages = [NSMutableArray new];
            
            for (NSDictionary *dict in pageResults) {
                GImage *gimage = [GImage gImageFromDict:dict];
                [parsedImages addObject:gimage];
            }
            
            if (shouldPage) {
                for (int i = 1; i< cursorPages.count; i++) {
                    self.currentPage += 4;
                    [self fetchPhotosForQuery:self.lastQuery shouldPage:NO onCompletion:^(NSArray*gimages,NSError*error){
                        completion (gimages,nil);
                    }];
                }
            }
            else{
                completion (parsedImages,nil);
            }
            
        }
        else{
            NSError*error = [[NSError alloc]init];
            completion(nil,error);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil,error);
    }];

}


- (void)reset{
    self.currentPage = 0;
}

#pragma mark - Networking

-(NSDictionary*)paramDictForSearchTerm:(NSString*)searchTerm start:(NSNumber*)start{
    
    NSDictionary *params = @{@"q":searchTerm,
                             @"v":@"1.0",
                             @"safe":@"active",
                             @"start":[NSNumber numberWithInteger:self.currentPage]
                             };
    return params;
}


#pragma mark - GoogleImageAPI

-(NSString*)rootAPIString{
    return @"https://ajax.googleapis.com/ajax/services/search/images";
}

@end
