//
//  Search.m
//  
//
//  Created by Luke Geiger on 7/10/15.
//
//

#import "Search.h"


@implementation Search

@dynamic query;
@dynamic lastSearchDate;

+(Search*)searchForQuery:(NSString*)query inContext:(NSManagedObjectContext*)context{
    
    Search *search;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Search"];
    NSArray *all = [context executeFetchRequest:fetchRequest error:nil];
    
    if (all.count) {
        for (Search *foundSearch in all) {
            if ([foundSearch.query isEqualToString:query]) {
                search = foundSearch;
            }
        }
    }
    
    if (!search){
        search = [NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:context];
        search.query = query;
    }
    
    search.lastSearchDate = [NSDate date];

    return search;
}


@end
