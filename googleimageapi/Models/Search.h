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
 The search text.
 */
@property (nonatomic, retain) NSString * query;

/*
 The last time this search was searched.
 */
@property (nonatomic, retain) NSDate * lastSearchDate;

/*
 Returns a newley created search, or an existing search if the query paramter matches a previous query
*/
+(Search*)searchForQuery:(NSString*)query inContext:(NSManagedObjectContext*)context;

@end
