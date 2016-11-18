//
//  WebService.h
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

+ (NSArray*)getRequestListWithError: (NSError**) error;
+ (NSDictionary*)getRequestDetails: (NSString*) requestID Error: (NSError**) error;
+ (NSString*) getErrorDescriptionRus:(NSError*) error;

@end
