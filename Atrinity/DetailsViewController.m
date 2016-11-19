//
//  DetailsViewController.m
//  Atrinity
//
//  Created by Robert Enderson on 14.11.16.
//  Copyright © 2016 Ермаков Николай. All rights reserved.
//

#import "DetailsViewController.h"
#import "WebService.h"
#import "RequestDetails.h"
#import "DateGraphs.h"
#import "DataForGraphs.h"

@interface DetailsViewController ()
{
    CGFloat keySize;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;

@property (strong, nonatomic) RequestDetails* info;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIView* loading;

@property (strong, nonatomic) IBOutlet UILabel *requestIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *FIOLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITextView *textDescription;
@property (strong, nonatomic) IBOutlet UITextView *textSolution;
@property (strong, nonatomic) IBOutlet UILabel *datesLabel;
@property (strong, nonatomic) IBOutlet UILabel *graphDescription;

- (void)loadResources;
- (void)backgroundErrorMessage: (NSError*) error;
- (void)UIPrepare;
- (id)addViewAfterView: (UIView*) lastView MarginCorrect: (NSLayoutConstraint*) margin InitData: (DataForGraphs*) data;
- (void)addDateGraphicsAfterView: (UIView*) lastView MarginCorrect: (NSLayoutConstraint*) margin;
- (void)scrollToTextView: (UITextView *)textView;

@end

@implementation DetailsViewController

#pragma mark Initializtion logic

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self UIPrepare];
    [self loadResources];
}

- (void)UIPrepare
{
    //Затемнение и индикатор загрузки при загрузке данных
    self.loading = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.loading setBackgroundColor:[UIColor grayColor]];
    [self.loading setAlpha:0.5];
    [self.loading setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
    UIActivityIndicatorView* indicate = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.loading.bounds.size.width, self.loading.bounds.size.height)];
    [indicate setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicate startAnimating];
    [indicate setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
    [self.loading addSubview:indicate];
    //Контейнеры данных
    [self.contentView.layer setCornerRadius:5.0f];
    [self.headerView.layer setCornerRadius:5.0f];
    //Текстовые поля
    [self.textSolution setDelegate:self];
    [self.textSolution.layer setCornerRadius:5.0f];
    [self.textSolution.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.textSolution.layer setBorderWidth:1.5f];
    [self.textDescription setDelegate:self];
    [self.textDescription.layer setCornerRadius:5.0f];
    [self.textDescription.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.textDescription.layer setBorderWidth:1.5f];
}

- (void)loadResources
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
   ^{
       [self.view addSubview:self.loading];
       NSError* error;
       NSDictionary* dict = [WebService getRequestDetails:self.requestID Error:&error];
       self.info = [[RequestDetails alloc] initWithDictionary:dict];
       dispatch_async(dispatch_get_main_queue(),
      ^{
          if (!self.info)
          {
              [self backgroundErrorMessage:error];
          }
          else
          {
              [self.requestIdLabel setText:[NSString stringWithFormat:@"Заявка № %@", self.requestSign]];
              [self.FIOLabel setText:[NSString stringWithFormat:@"Автор:\n%@", self.info.FullName]];
              [self.statusLabel setText:[NSString stringWithFormat:@"Статус заявки:\n%@", self.info.RequestStatus]];
              [self.textDescription setText:self.info.Description];
              [self.textSolution setText:self.info.SolutionDescription];
              [self.datesLabel setText:[NSString stringWithFormat:@"Дата подачи заявки:\n%@\n\nЗапланировано завершить:\n%@\n\nФактически выполнена:\n%@", self.info.CreatedAt, self.info.PlanToFinish, self.info.ActualFinish]];
              [self addDateGraphicsAfterView:self.graphDescription MarginCorrect:self.bottomMargin];
              [self.loading removeFromSuperview];
          }
      });
   });
}

#pragma mark Error messages realisations

- (void)backgroundErrorMessage: (NSError*) error
{
    NSString* text;
    if (error == nil)
    {
        text = @"Данных пока нет. Обновите позднее!";
    }
    else
    {
        text = [WebService getErrorDescriptionRus:error];
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"Вернуться назад"
                                          otherButtonTitles:@"Попробовать еще раз",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self loadResources];
    }
}

#pragma mark Adding graphics logic

- (id)addViewAfterView: (UIView*) lastView MarginCorrect: (NSLayoutConstraint*) margin InitData: (DataForGraphs*) data
{
    //Высоту тут можно ставить любую, эта показалась наиболее удобной
    NSInteger viewHeight = 240;
    DateGraphs *view = [[DateGraphs alloc] initWithData:data];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:view];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[view]-14-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:viewHeight]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastView]-10-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView,view)]];
    //10 - это отступ, тоже можно ставить любой
    margin.constant += (viewHeight + 10);
    return view;
}

- (void)addDateGraphicsAfterView: (UIView*) lastView MarginCorrect: (NSLayoutConstraint*) margin
{
    NSArray* graphData = [self.info makeDataForGraph];
    UIView* latestView = lastView;
    for (DataForGraphs* data in graphData)
    {
        latestView = [self addViewAfterView:latestView MarginCorrect:margin InitData:data];
    }
    //На случай, если не будет выведено ни одного графика
    if (lastView == latestView) [self.graphDescription setText:@"  Нет данных для построения графика"];
}

#pragma mark UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollToTextView:textView];
    NSLog(@"Begin edit");
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self scrollToTextView:textView];
    NSLog(@"Changed®");
}

- (void)scrollToTextView: (UITextView *)textView
{
    CGFloat offset;
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    if (cursorPosition.y == INFINITY) offset = textView.frame.size.height;
    else offset = cursorPosition.y;
    offset += textView.frame.origin.y + self.view.frame.size.height * 0.25;
    [self.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
}

@end
