//
//  DetailsViewController.h
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSString* requestID;
@property (strong, nonatomic) NSString* requestSign;

@end
