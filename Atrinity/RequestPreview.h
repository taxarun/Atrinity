//
//  RequestPreview.h
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import <Foundation/Foundation.h>

//Данные для предпросмотра заявки

@interface RequestPreview : NSObject

@property (strong, nonatomic) NSString* Number;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSString* Date;

@property (strong, nonatomic) NSString* RequestID;

- (instancetype)initWithDictionary: (NSDictionary*) dict;
+ (NSArray*)convertToModelArray: (NSArray*) data;

@end
