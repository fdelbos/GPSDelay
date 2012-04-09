//
//  CaptureView.m
//  GPSDelay
//
//  Created by Frederic Delbos on 4/5/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import "CaptureView.h"
#import "GLB.h"
#import "MBProgressHUD.h"

@implementation CaptureView

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
    self.title = @"New Capture";
    
    _state = WaitingToBegin;
    _name.delegate = self;
    _service.delegate = self;
    [_button addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [_frequency addTarget:self action:@selector(frequencyChanged:) forControlEvents:UIControlEventValueChanged];
    [_http addTarget:self action:@selector(httpChange) forControlEvents:UIControlEventValueChanged];
    [self frequencyChanged:_frequency];
    _locationManager = [[LocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager retain];
    _httpManager = [[HTTPManager alloc] init];
    _httpManager.delegate = self;
    [_httpManager retain];
    
    _inputElems = [[NSArray alloc] initWithObjects:
                   _name, _service, _frequency, _gps, _http, nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resetCapture];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopCapture];
}

- (void)viewDidUnload
{
    [_inputElems release];
    _inputElems = nil;
    [_name release];
    _name = nil;
    [_service release];
    _service = nil;
    [_frequency release];
    _frequency = nil;
    [_button release];
    _button = nil;
    [_samplingFreq release];
    _samplingFreq = nil;
    [_gps release];
    _gps = nil;
    [_http release];
    _http = nil;
    [_httpTotal release];
    _httpTotal = nil;
    [_gpsTotal release];
    _gpsTotal = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [_inputElems release];
    [_name release];
    [_service release];
    [_frequency release];
    [_button release];
    [_samplingFreq release];
    [_gps release];
    [_http release];
    [_httpTotal release];
    [_gpsTotal release];
    [_locationManager release];
    [_httpManager release];
    [super dealloc];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - User Interactions

-(void)enableInputElems:(BOOL)state
{
    for (UIControl *v in _inputElems)
        [v setEnabled:state];
}

-(void)resetCapture
{
    _state = WaitingToBegin;
    [_button setTitle:@"Start" forState:UIControlStateNormal];
    [self enableInputElems:YES];
    [_name setText:@""];
    [_service setText:@"http://"];
    _httpSamples = 0;
    _locationSamples = 0;
    _capture = nil;
    [_http setOn:YES animated:FALSE];
    [_gps setOn:YES animated:FALSE];
    [_gpsTotal setText:@"0"];
    [_httpTotal setText:@"0"];
}

-(void)saveState
{
    NSError *error = nil;
    if (![[GLB get].getMngObjCtx save:&error])
        return alert(@"Can't save new capture, check your memory.", @"Error!");
}

-(void)newCapture
{
    _capture = (Capture *)[NSEntityDescription insertNewObjectForEntityForName:@"Capture" inManagedObjectContext:[[GLB get]getMngObjCtx]];
    _capture.name = trim_str(_name.text);
    _capture.start = [NSDate date];
    [self saveState];
}

-(BOOL)startCapture
{
    if (!_gps.on && !_http.on)
    {
        alert(@"Please select at least gps or http for a capture.", @"Error!");
        return FALSE;
    }
    if (_gps.on)
        [_locationManager startCapture:_capture];
    if (_http.on)
    {
        if (!trim_str(_name.text).length)
        {
            alert(@"Please set a valid name for your capture.", @"Error!");
            return FALSE;
        }
        if (!trim_str(_service.text).length)
        {
            alert(@"Please set a valid http url service for your capture.", @"Error!");
            return FALSE;
        }
        [_httpManager startCapture:_capture service:_service.text interval:_samplingInterval];
    }
    return TRUE;
}

-(void)stopCapture
{
    if (_gps.on)
        [_locationManager stopCapture];
    if (_http.on)
        [_httpManager stopCapture];
    [self saveState];
}

-(void)start
{
    switch(_state)
    {
        case WaitingToBegin:
            if (_capture == nil)
                [self newCapture];
            if([self startCapture])
            {
                [_button setTitle:@"Pause" forState:UIControlStateNormal];
                [self enableInputElems:NO];
                _state = Started;
            }
            break;
            
        case Started:
            _state = Paused;
            [self stopCapture];
            [_button setTitle:@"Resume" forState:UIControlStateNormal];
            break;
            
        case Paused:
            _state = Started;
            [self startCapture];
            [_button setTitle:@"Pause" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

-(void)httpChange
{
    if (!_http.on)
    {
        [_service setEnabled:FALSE];
        [_frequency setEnabled:FALSE];
    }
    else
    {
        [_service setEnabled:TRUE];
        [_frequency setEnabled:TRUE];
    }
}

-(void)frequencyChanged:(UISlider*)slider
{
    _samplingInterval = slider.value * 20 * slider.value;
    _samplingFreq.text = [NSString stringWithFormat:@"%f s", _samplingInterval];
}

#pragma mark - LoacationManager delegate Implementation

-(void)locationCaptureUpdate:(BOOL)success
{
    _locationSamples++;
    [_gpsTotal setText:[NSString stringWithFormat:@"%i", _locationSamples]];
}

#pragma mark - HTTPManager delegate Implementation

-(void)HTTPCaptureUpdate:(BOOL)success
{
    _httpSamples++;
    [_httpTotal setText:[NSString stringWithFormat:@"%i", _httpSamples]];
}

@end
