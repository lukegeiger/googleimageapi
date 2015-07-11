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
@property (nonatomic, assign) BOOL isPaging;
@property (nonatomic, strong) NSMutableArray *searchImages;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation GImageAPI

+(GImageAPI *)sharedAPI{
    
    static dispatch_once_t pred;
    static GImageAPI *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[GImageAPI alloc] init];
        shared.currentPage = 0;
        shared.searchImages = [NSMutableArray new];
    });
    return shared;
}

- (void)fetchPhotosForQuery:(NSString*)query onCompletion:(void (^)(NSArray *gimages, NSError *gError))completion{

    self.lastQuery = query;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [self paramDictForSearchTerm:query start:[NSNumber numberWithInteger:self.currentPage]];
    NSLog(@"%@",params);
    
    [manager GET:[self rootAPIString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *fullResponse = (NSDictionary*)responseObject;
        
        if ([[fullResponse objectForKey:@"responseStatus"]intValue] == 200) {
            
            NSDictionary *responseData = [fullResponse objectForKey:@"responseData"];
            NSDictionary *cursor = [responseData objectForKey:@"cursor"];
            NSDictionary *pages = [cursor objectForKey:@"pages"];
            NSDictionary *pageResults = [responseData objectForKey:@"results"];
            
            for (NSDictionary *dict in pageResults) {
                GImage *gimage = [GImage gImageFromDict:dict];
                [self.searchImages addObject:gimage];
            }
            
            if (self.isPaging == false) {
                self.isPaging = true;
                for (NSDictionary *dict in pages) {
                    NSNumber *start = [dict objectForKey:@"start"];
                    NSLog(@"start %@:",start);
                    
                    self.currentPage = start.integerValue;
                    
                    [self fetchPhotosForQuery:self.lastQuery onCompletion:^(NSArray*gimages,NSError*error){
                        [self.searchImages addObjectsFromArray:gimages];
                    }];
                }
            }
            
            completion(self.searchImages,nil);

        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil,error);
    }];
}


- (void)beginFetchingPhotosForQuery:(NSString*)string{
    [self fetchPhotosForQuery:string onCompletion:nil];
}

- (void)fetchNextPageOnCompletion:(void (^)(NSArray *gimages, NSError *gError))completion{

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
