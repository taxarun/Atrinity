//
//  DataForGraphs.h
//  Atrinity
//
//  Created by Robert Enderson on 16.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import <Foundation/Foundation.h>

//Данные, принимаемые графикопостроителем

@interface DataForGraphs : NSObject

@property BOOL isTwoGraphs;
@property BOOL isSecondGraphGreen;
@property NSInteger blueGraphValue;
@property (strong, nonatomic) NSString* label;
@property NSInteger secondGraphValue;

-(instancetype)initWithBlueGraphSign: (NSInteger) blueGraph
                     SecondGraphSign: (NSInteger) secondGraph
                         BottomLabel: (NSString*) botLabel
                       HaveTwoGraphs: (BOOL) isTwo
                       IsSecondGreen: (BOOL) isGreen;

@end
