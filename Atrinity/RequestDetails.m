//
//  RequestDetails.m
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import "RequestDetails.h"
#import "DataForGraphs.h"

#define NO_DATA 0

static NSString* DateNames[5] =
{
    @"Года",
    @"Месяцы",
    @"Дни",
    @"Часы",
    @"Минуты"
};

enum Date
{
    YEAR,
    MONTH,
    DAY,
    HOUR,
    MINUTE
};

@interface RequestDetails ()

- (NSInteger*)getParsedDataFromNSdate: (NSDate*) date;
- (NSString*)safeGetValue: (NSString*) value;

@end

@implementation RequestDetails

- (NSString*)safeGetValue: (NSString*) value
{
    if(![value isKindOfClass:[NSString class]] || !value) return @"Нет данных";
    else return value;
    
}

- (instancetype)initWithDictionary: (NSDictionary*) dict
{
    if (!dict) return nil;
    self = [super init];
    if (self)
    {
        NSDictionary* requestDict = [dict objectForKey:@"Request"];
        NSDictionary* userInfoDict = [dict objectForKey:@"UserInfo"];
        
        self.RequestStatus = [self safeGetValue:[requestDict objectForKey:@"StatusText"]];
        self.FullName = [self safeGetValue:[userInfoDict objectForKey:@"FullName"]];
        self.Description = [self safeGetValue:[requestDict objectForKey:@"Description"]];
        self.SolutionDescription = [self safeGetValue:[requestDict objectForKey:@"SolutionDescription"]];
        self.CreatedAt = [self safeGetValue:[requestDict objectForKey:@"CreatedAt"]];
        self.PlanToFinish = [self safeGetValue:[requestDict objectForKey:@"SLARecoveryTime"]];
        self.ActualFinish = [self safeGetValue:[requestDict objectForKey:@"ActualRecoveryTime"]];
        //Можно раскоментировать и ставить разные даты, чтобы посмотреть
        //работу графикапостроителя в режиме двух графиков
        //(по каким-то причинам в присылаемых данных в разделе
        //SLARecoveryTime всегда прочерк)
//        self.PlanToFinish = @"10.06.2016 14:34";
    }
    return self;
}

- (NSInteger*)getParsedDataFromNSdate: (NSDate*) date
{
    NSDateFormatter *parser = [[NSDateFormatter alloc] init];
    [parser setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSInteger* parsed = (NSInteger*)calloc(5, sizeof(NSInteger));
    [parser setDateFormat:@"yyyy"];
    parsed[YEAR] = [[parser stringFromDate:date] intValue];
    parsed[YEAR] -= 1970;
    [parser setDateFormat:@"MM"];
    parsed[MONTH] = [[parser stringFromDate:date] intValue];
    parsed[MONTH]--;
    [parser setDateFormat:@"dd"];
    parsed[DAY] = [[parser stringFromDate:date] intValue];
    parsed[DAY]--;
    [parser setDateFormat:@"HH"];
    parsed[HOUR] = [[parser stringFromDate:date] intValue];
    [parser setDateFormat:@"mm"];
    parsed[MINUTE] = [[parser stringFromDate:date] intValue];
    return parsed;
}

- (NSArray*)makeDataForGraph
{
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:5];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSDate *reqDate = [dateFormat dateFromString:self.CreatedAt];
    if(!reqDate) return nil;
    NSDate *planDate = [dateFormat dateFromString:self.PlanToFinish];
    NSDate *actualDate = [dateFormat dateFromString:self.ActualFinish];
    if(!planDate && !actualDate) return nil;
    BOOL isGreen;
    //Если только одна дата завершения
    if(!planDate || !actualDate)
    {
        BOOL isTwo = NO;
        isGreen = NO;
        NSDate* until;
        if(planDate) until = planDate;
        else until = actualDate;
        NSTimeInterval diff = [until timeIntervalSinceDate:reqDate];
        NSDate* res = [[NSDate alloc] initWithTimeIntervalSince1970:diff];
        NSInteger* dates = [self getParsedDataFromNSdate:res];
        for (int i = 0; i < 5; i++)
        {
            if(dates[i] != 0)
            {
                [result addObject:[[DataForGraphs alloc] initWithBlueGraphSign:dates[i]
                                                               SecondGraphSign:NO_DATA
                                                                   BottomLabel:DateNames[i]
                                                                 HaveTwoGraphs:isTwo
                                                                 IsSecondGreen:isGreen]];
            }
        }
        free(dates);
    }
    //Если несколько
    else
    {
        BOOL isTwo = YES;
        NSTimeInterval diff = [planDate timeIntervalSinceDate:reqDate];
        if (diff < 0)
        {
            diff *= -1;
        }
        NSDate* planned = [[NSDate alloc] initWithTimeIntervalSince1970:diff];
        diff = [actualDate timeIntervalSinceDate:planDate];
        if (diff < 0)
        {
            isGreen = NO;
            diff *= -1;
        }
        else isGreen = YES;
        NSDate* overhead = [[NSDate alloc] initWithTimeIntervalSince1970:diff];
        NSInteger* dates1 = [self getParsedDataFromNSdate:planned];
        NSInteger* dates2 = [self getParsedDataFromNSdate:overhead];
        for (int i = 0; i < 5; i++)
        {
            if(dates1[i] != 0)
            {
                [result addObject:[[DataForGraphs alloc] initWithBlueGraphSign:dates1[i]
                                                               SecondGraphSign:dates2[i]
                                                                   BottomLabel:DateNames[i]
                                                                 HaveTwoGraphs:isTwo
                                                                 IsSecondGreen:isGreen]];
            }
        }
        free(dates1);
        free(dates2);
    }
    return result;
}

@end
