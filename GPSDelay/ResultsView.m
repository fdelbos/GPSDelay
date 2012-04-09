//
//  ResultsView.m
//  GPSDelay
//
//  Created by Frederic Delbos on 4/8/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import "ResultsView.h"
#import "GLB.h"
#import "GPSSample.h"
#import "HTTPSample.h"
#import "MBProgressHUD.h"
#import "CSVGenerator.h"

@implementation ResultsView

@synthesize capture;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Results";
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                                                                         target:self
                                                                         action:@selector(mailResults)];          
    self.navigationItem.rightBarButtonItem = add;
}

-(void)mailResults
{
    if (![MFMailComposeViewController canSendMail])
        return alert(@"Your device is not configured to send emails.", @"Error!");
    
    NSData *gpsData = [CSVGenerator generateGPS:_gps];
    NSData *httpData = [CSVGenerator generateHTTP:_http];
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:[NSString stringWithFormat:@"GPSDelay - results for capture: %@", capture.name]];
    NSString *emailBody = [NSString stringWithFormat:@"Please find attached the sample data for the capture: %@.\n\nBest Regards.", capture.name];
    [mailer setMessageBody:emailBody isHTML:NO];
    [mailer addAttachmentData:gpsData mimeType:@"text/csv" fileName:@"gps.csv"];
    [mailer addAttachmentData:httpData mimeType:@"text/csv" fileName:@"http.csv"];
    [self presentModalViewController:mailer animated:YES];
    [mailer release];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

-(NSArray *)fetch:(NSString*)tableName;
{
    NSManagedObjectContext *moc = [[GLB get] getMngObjCtx];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:tableName 
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"capture == %@", capture];
    [request setPredicate:predicate];
    
    if (tableName == @"HTTSample")
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"begin" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [sortDescriptor release];
    }
    if (tableName == @"GPSSample")
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [sortDescriptor release];
    }
    NSError *error = nil;
    NSArray *res = [moc executeFetchRequest:request error:&error];
    if (res == nil)
        NSLog(@"error :%@", error.localizedDescription);
    return res;
}

-(void)loadData
{
    [_name setText:capture.name];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyy MMM dd, HH:mm"];
    [_startDate setText:[NSString stringWithFormat:@"%@", [df stringFromDate:capture.start]]];
    [df release];

    if (_gps)
    {
        [_gps release];
        _gps = nil;
    }
    if (_http)
    {
        [_http release];
        _http = nil;
    }
    _http = [self fetch:@"HTTPSample"];
    [_http retain];
    [_httpSamples setText:[NSString stringWithFormat:@"%i", [_http count]]];
    _gps = [self fetch:@"GPSSample"];
    [_gps retain];
    [_gpsSamples setText:[NSString stringWithFormat:@"%i", [_gps count]]];
    int errors = 0;
    for(int i = 0; i < [_gps count]; i++)
    {
        GPSSample *s = (GPSSample*)[_gps objectAtIndex:i];
        if (s.success.intValue == 0)
            errors++;
    }
    [_gpsErrors setText:[NSString stringWithFormat:@"%i", errors]];
    errors = 0;
    for(int i = 0; i < [_http count]; i++)
    {
        HTTPSample *s = (HTTPSample*)[_http objectAtIndex:i];
        if (s.success.intValue == 0)
            errors++;
    }
    [_httpErrors setText:[NSString stringWithFormat:@"%i", errors]];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading Data";
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)viewDidUnload
{
    [_name release];
    _name = nil;
    [_startDate release];
    _startDate = nil;
    [_gpsSamples release];
    _gpsSamples = nil;
    [_gpsErrors release];
    _gpsErrors = nil;
    [_httpSamples release];
    _httpSamples = nil;
    [_httpErrors release];
    _httpErrors = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_name release];
    [_startDate release];
    [_gpsSamples release];
    [_gpsErrors release];
    [_httpSamples release];
    [_httpErrors release];
    capture = nil;
    [super dealloc];
}
@end
