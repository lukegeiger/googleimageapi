//
//  Search.h
//  
//
//  Created by Luke Geiger on 7/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Search : NSManagedObject

@property (nonatomic, retain) NSString * query;
@property (nonatomic, retain) NSDate * lastSearchDate;
@property (nonatomic, retain) NSNumber * count;

+(Search*)searchForQuery:(NSString*)query inContext:(NSManagedObjectContext*)context;

@end
