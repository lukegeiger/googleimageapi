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

/*
 Comment
 */
@property (nonatomic, retain) NSString * query;

/*
 Comment
 */
@property (nonatomic, retain) NSDate * lastSearchDate;

/*
 Comment
 */
@property (nonatomic, retain) NSNumber * count;


/*
 Comment
 @param
 @return
 */
+(Search*)searchForQuery:(NSString*)query inContext:(NSManagedObjectContext*)context;

@end
