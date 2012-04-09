//
//  ResultsView.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/8/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Capture.h"

@interface ResultsView : UIViewController <MFMailComposeViewControllerDelegate>
{
@private
 
    IBOutlet UILabel *_name;
    IBOutlet UILabel *_startDate;
    IBOutlet UILabel *_gpsSamples;
    IBOutlet UILabel *_gpsErrors;
    IBOutlet UILabel *_httpSamples;
    IBOutlet UILabel *_httpErrors;
    
    NSArray *_gps;
    NSArray *_http;
}

@property (nonatomic, assign) Capture *capture;

-(void)mailResults;
-(void)loadData;

@end
