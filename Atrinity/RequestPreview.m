//
//  RequestPreview.m
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import "RequestPreview.h"

@implementation RequestPreview

- (instancetype)initWithDictionary: (NSDictionary*) dict
{
    if (!dict) return nil;
    self = [super init];
    if (self)
    {
        self.Number    = [dict objectForKey:@"RequestNumber"];
        self.Name      = [dict objectForKey:@"Name"];
        self.Date      = [dict objectForKey:@"CreatedAt"];
        self.RequestID = [dict objectForKey:@"RequestID"];
    }
    return self;
}

+ (NSArray*)convertToModelArray: (NSArray*) data
{
    if (!data) return nil;
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:data.count];
    for (NSDictionary* request in data)
    {
        [result addObject:[[RequestPreview alloc] initWithDictionary:request]];
    }
    return result;
}

@end
