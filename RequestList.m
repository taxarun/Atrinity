//
//  RequestList.m
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import "RequestList.h"
#import "WebService.h"
#import "RequestCell.h"
#import "RequestPreview.h"
#import "DetailsViewController.h"

@interface RequestList ()

@property (strong, nonatomic) NSArray* cellData;
@property (strong, nonatomic) UILabel* messageLabel;

- (void)backgroundErrorMessage: (NSError*) error;
- (void) tableUpdate;

@end

@implementation RequestList

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self
                            action:@selector(tableUpdate)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self tableUpdate];
    self.clearsSelectionOnViewWillAppear = YES;
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.backgroundView = self.messageLabel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestCell *cell = (RequestCell*)[tableView dequeueReusableCellWithIdentifier:@"Request" forIndexPath:indexPath];
    RequestPreview* data = [self.cellData objectAtIndex:indexPath.row];
    [cell setDataFromModel:data];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailsViewController* controller = [segue destinationViewController];
    NSIndexPath *cellID = [self.tableView indexPathForSelectedRow];
    RequestPreview* data = (RequestPreview*)[self.cellData objectAtIndex:cellID.row];
    controller.requestID = data.RequestID;
    controller.requestSign = data.Number;
}

#pragma mark - Private methods

- (void)backgroundErrorMessage: (NSError*) error
{
    if (error == nil)
    {
        self.messageLabel.text = @"Данных пока нет. Обновите позднее!";
    }
    else
    {
        [self.messageLabel setText:[WebService getErrorDescriptionRus:error]];
    }
    self.messageLabel.textColor = [UIColor blackColor];
    self.messageLabel.numberOfLines = 7;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.messageLabel sizeToFit];
}

-(void) tableUpdate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        NSError* err = nil;
        self.cellData = [RequestPreview convertToModelArray:[WebService getRequestListWithError:&err]];
        NSLog(@"Data count: %lu",(unsigned long)self.cellData.count);
        dispatch_async(dispatch_get_main_queue(),
        ^{
            if (!self.cellData)
                [self backgroundErrorMessage:err];
            else
                [self.messageLabel setText:@""];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
}

@end
