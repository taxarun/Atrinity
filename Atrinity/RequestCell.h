//
//  RequestCell.h
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestPreview.h"

@interface RequestCell : UITableViewCell

- (void)setDataFromModel: (RequestPreview*) data;

@end
