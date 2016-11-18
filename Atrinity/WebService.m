//
//  WebService.m
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import "WebService.h"

static NSString* kGetListParams = @"ApiKey=e8e6a311d54985a067ece5a008da280a&Login=d_blinov&Password=Passw0rd&ObjectCode=300&Action=GET_LIST&Fields[FilterID]=3CD0E650-4B81-E511-A39A-1CC1DEAD694D";
static NSString* kGetDetailParams = @"ApiKey=e8e6a311d54985a067ece5a008da280a&Login=d_blinov&Password=Passw0rd&ObjectCode=300&Action=GET_INFO&Fields[RequestID]=%@";

static NSString* kURL = @"http://mobile.atrinity.ru/api/service";

@interface WebService ()

+ (id)getdataFromServiceWithParams:(NSString*) params Error: (NSError**) error;

@end

@implementation WebService

#pragma mark - Public methods

+ (NSArray*)getRequestListWithError: (NSError**) error
{
    NSArray* jsonArray = [WebService getdataFromServiceWithParams:kGetListParams Error:error];
    if (!jsonArray) return nil;
    if (jsonArray.count == 0) return nil;
    return jsonArray;
}

+ (NSDictionary*)getRequestDetails: (NSString*) requestID Error: (NSError**) error
{
    NSString* params = [NSString stringWithFormat:kGetDetailParams, requestID];
    NSDictionary* details = [WebService getdataFromServiceWithParams:params Error:error];
    return details;
    
}

//NSLog оставил на случае возникновения ошибок, можно быстро посмотреть код и добавить его в список
+ (NSString*) getErrorDescriptionRus:(NSError*) error
{
    NSString* result;
    switch (error.code)
    {
        case -1001:
            result = @"Время ожидания ответа истекло.";
            break;
        case -1003:
            result = @"Сервер не может быть найден, позможны проблемы с интернет соединением.";
            break;
        case -1005:
            result = @"Соединение с сервером прервалось.";
            break;
        case -1009:
            result = @"Устройство находится в режиме оффлайн. Попробуйте обновить список позднее.";
            break;
        default:
            result = @"Произошла непредвиденная ошибка.";
            NSLog(@"%@", error);
            NSLog(@"%ld", (long)error.code);
            break;
    }
    return result;
}

#pragma mark - Private methods

+ (id)getdataFromServiceWithParams:(NSString*) params Error: (NSError**) error
{
    NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: kURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    if (responseData == nil) return nil;
    return [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: error];
}

@end
