//
//  RequestDetails.h
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import <Foundation/Foundation.h>

//Данные по конкретной заявке

@interface RequestDetails : NSObject

@property (strong, nonatomic) NSString* RequestStatus;
@property (strong, nonatomic) NSString* FullName;
@property (strong, nonatomic) NSString* Description;
@property (strong, nonatomic) NSString* SolutionDescription;
@property (strong, nonatomic) NSString* CreatedAt;
@property (strong, nonatomic) NSString* PlanToFinish;
@property (strong, nonatomic) NSString* ActualFinish;

- (instancetype)initWithDictionary: (NSDictionary*) dict;
- (NSArray*)makeDataForGraph;

@end
