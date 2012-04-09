//
//  CaptureView.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/5/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capture.h"
#import "LocationManager.h"
#import "HTTPManager.h"

#define trim_str( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]


typedef enum
{
    WaitingToBegin,
    Started,
    Paused
} CaptureState;

@interface CaptureView : UIViewController <UITextFieldDelegate, LocationManagerDelegate, HTTPManagerDelegate>
{
@private
    IBOutlet UITextField *_name;
    IBOutlet UISwitch *_http;
    IBOutlet UITextField *_service;
    IBOutlet UISlider *_frequency;
    IBOutlet UISwitch *_gps;
    IBOutlet UIButton *_button;
    IBOutlet UILabel *_samplingFreq;
    IBOutlet UILabel *_httpTotal;
    IBOutlet UILabel *_gpsTotal;
    
    CaptureState _state;
    float _samplingInterval;
    Capture *_capture;
    NSArray *_inputElems;
    LocationManager *_locationManager;
    HTTPManager *_httpManager;
    int _httpSamples;
    int _locationSamples;
}


-(void)frequencyChanged:(UISlider*)slider;
-(void)start;
-(void)resetCapture;
-(BOOL)startCapture;
-(void)stopCapture;


@end
