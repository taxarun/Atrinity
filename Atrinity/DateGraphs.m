//
//  DateGraphs.m
//  Atrinity
//
//  Created by Robert Enderson on 16.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import "DateGraphs.h"

#define NORM_COLOR(COLOR) COLOR / 255.0

@interface DateGraphs ()
{
    BOOL isTwo;
    BOOL isSecondSmaller;
    CGFloat smallCoef;
}

@property (strong, nonatomic) UIView* mainView;
@property (strong, nonatomic) UILabel* redGraph;
@property (strong, nonatomic) UILabel* blueGraph;
@property (strong, nonatomic) UILabel* whatCompare;

- (void)loadResources;

@end

@implementation DateGraphs

- (void)loadResources
{
    isTwo = YES;
    isSecondSmaller = YES;
    smallCoef = 0;
    //Подложка
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.mainView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
    [self.mainView.layer setCornerRadius:5.0f];
    [self.mainView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.mainView.layer setBorderWidth:1.5f];
    [self addSubview:self.mainView];
    //Синий график
    self.blueGraph = [[UILabel alloc] init];
    [self.blueGraph setBackgroundColor:[UIColor colorWithRed:NORM_COLOR(90)
                                                       green:NORM_COLOR(153)
                                                        blue:NORM_COLOR(255)
                                                       alpha:NORM_COLOR(255)]];
    [self.blueGraph.layer setCornerRadius:5.0f];
    [self.blueGraph.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.blueGraph.layer setBorderWidth:1.5f];
    self.blueGraph.layer.masksToBounds = YES;
    //Число на графике
    [self.blueGraph setText:@"2"];
    [self.blueGraph setTextAlignment:NSTextAlignmentCenter];
    [self.blueGraph setTextColor:[UIColor whiteColor]];
    [self.mainView addSubview:self.blueGraph];
    //Красный график
    self.redGraph = [[UILabel alloc] init];
    [self.redGraph setBackgroundColor:[UIColor colorWithRed:NORM_COLOR(255)
                                                      green:NORM_COLOR(77)
                                                       blue:NORM_COLOR(71)
                                                      alpha:NORM_COLOR(255)]];
    [self.redGraph.layer setCornerRadius:5.0f];
    [self.redGraph.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.redGraph.layer setBorderWidth:1.5f];
    self.redGraph.layer.masksToBounds = YES;
    //Число на графике
    [self.redGraph setText:@"2"];
    [self.redGraph setTextAlignment:NSTextAlignmentCenter];
    [self.redGraph setTextColor:[UIColor whiteColor]];
    [self.mainView addSubview:self.redGraph];
    //Подпись
    self.whatCompare = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-0.2*self.bounds.size.height, self.bounds.size.width, self.bounds.size.height*0.2)];
    [self.whatCompare setText:@"Пример"];
    [self.whatCompare setTextAlignment:NSTextAlignmentCenter];
    [self.whatCompare setTextColor:[UIColor blackColor]];
    [self.mainView addSubview:self.whatCompare];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self loadResources];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)inCoder
{
    if(self = [super initWithCoder:inCoder])
    {
        [self loadResources];
    }
    
    return self;
}

- (id)initWithData: (DataForGraphs*) data
{
    self = [self init];
    if (self)
    {
        isTwo = data.isTwoGraphs;
        [self.blueGraph setText:[NSString stringWithFormat:@"%ld",(long)data.blueGraphValue]];
        [self.whatCompare setText:data.label];
        //Проверка на количество рисуемых графиков
        if (isTwo)
        {
            if (data.secondGraphValue != 0)
            {
                [self.redGraph setText:[NSString stringWithFormat:@"%ld",(long)data.secondGraphValue]];
                if (data.isSecondGraphGreen)
                {
                    [self.redGraph setBackgroundColor:[UIColor colorWithRed:NORM_COLOR(0)
                                                                      green:NORM_COLOR(193)
                                                                       blue:NORM_COLOR(93)
                                                                      alpha:NORM_COLOR(255)]];
                }
                //Вычисление, какой график будет меньше
                if (data.blueGraphValue > data.secondGraphValue)
                {
                    isSecondSmaller = YES;
                    if (data.blueGraphValue == 0)
                        smallCoef = 0;
                    else
                        smallCoef = ((float)data.secondGraphValue / (float)data.blueGraphValue);
                }
                else
                {
                    isSecondSmaller = NO;
                    smallCoef = ((float)data.blueGraphValue / (float)data.secondGraphValue);
                }
            }
            else
            {
                isTwo = NO;
            }
        }
    }
    return self;
}

- (void)layoutSubviews
{
    //Логика отрисовки двух графиков
    if (isTwo)
    {
        CGFloat height = self.bounds.size.height * 0.6 * smallCoef;
        CGFloat margin = (self.bounds.size.height * 0.6 * (1-smallCoef)) + self.bounds.size.height * 0.1;
        if (isSecondSmaller)
        {
            self.blueGraph.frame = CGRectMake(self.bounds.size.width*0.2, self.bounds.size.height*0.1, self.bounds.size.width*0.2, self.bounds.size.height*0.6);
            self.redGraph.frame = CGRectMake(self.bounds.size.width*0.6, margin, self.bounds.size.width*0.2, height);
        }
        else
        {
            self.blueGraph.frame = CGRectMake(self.bounds.size.width*0.2, margin, self.bounds.size.width*0.2, height);
            self.redGraph.frame = CGRectMake(self.bounds.size.width*0.6, self.bounds.size.height*0.1, self.bounds.size.width*0.2, self.bounds.size.height*0.6);
        }
    }
    //Одного
    else
    {
        self.blueGraph.frame = CGRectMake(self.bounds.size.width*0.4, self.bounds.size.height*0.1, self.bounds.size.width*0.2, self.bounds.size.height*0.6);
    }
    //Подпись рисуется в любом случае
    self.whatCompare.frame = CGRectMake(0, self.bounds.size.height-0.2*self.bounds.size.height, self.bounds.size.width, self.bounds.size.height*0.2);
}

@end
