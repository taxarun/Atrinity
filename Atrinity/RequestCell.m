//
//  RequestCell.m
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import "RequestCell.h"

#define NORM_COLOR(COLOR) COLOR / 255.0

@interface RequestCell ()

@property (strong, nonatomic) IBOutlet UILabel *ReqNum;
@property (strong, nonatomic) IBOutlet UILabel *Description;
@property (strong, nonatomic) IBOutlet UILabel *Date;

@end

@implementation RequestCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

//Настройка внешнего вида ячейки
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setBackgroundColor:[UIColor colorWithRed:NORM_COLOR(225)
                                             green:NORM_COLOR(231)
                                              blue:NORM_COLOR(233)
                                             alpha:NORM_COLOR(255)]];
    self.layer.masksToBounds = YES;
    [self.layer setCornerRadius:5.0f];
}

//Отступы для ячейки от краев экрана и других ячеек
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 6;
    frame.size.height -= 12;
    frame.origin.x += 8;
    frame.size.width -= 16;
    [super setFrame:frame];
}

//Обертываем полученные данные понятными подписями
- (void)setDataFromModel: (RequestPreview*) data
{
    [self.ReqNum setText:[NSString stringWithFormat:@"Заявка № %@:", data.Number]];
    [self.Description setText:data.Name];
    [self.Date setText:[NSString stringWithFormat:@"Создана: %@", data.Date]];
}

@end
