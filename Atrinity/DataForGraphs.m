//
//  DataForGraphs.m
//  Atrinity
//
//  Created by Robert Enderson on 16.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import "DataForGraphs.h"

@implementation DataForGraphs

-(instancetype)initWithBlueGraphSign: (NSInteger) blueGraph
                     SecondGraphSign: (NSInteger) secondGraph
                         BottomLabel: (NSString*) botLabel
                       HaveTwoGraphs: (BOOL) isTwo
                       IsSecondGreen: (BOOL) isGreen
{
    self = [super init];
    if(self)
    {
        self.blueGraphValue = blueGraph;
        self.secondGraphValue = secondGraph;
        self.label = botLabel;
        self.isTwoGraphs = isTwo;
        self.isSecondGraphGreen = isGreen;
    }
    return self;
}

@end
