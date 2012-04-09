//
//  LocationManager.m
//  GPSDelay
//
//  Created by Frederic Delbos on 4/7/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import "LocationManager.h"
#import "GLB.h"
#import "GPSSample.h"

@implementation LocationManager

@synthesize delegate;

- (id)init
{
	self = [super init];    
	if(self != nil)
    {
		_locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		_locationManager.delegate = self;
        _capture = nil;
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (_capture)
    {
        GPSSample *s = (GPSSample *)[NSEntityDescription insertNewObjectForEntityForName:@"GPSSample" inManagedObjectContext:[[GLB get]getMngObjCtx]];
        s.time = [NSDate date];
        s.old_latitude = [NSNumber numberWithDouble:oldLocation.coordinate.latitude];
        s.old_longitude = [NSNumber numberWithDouble:oldLocation.coordinate.longitude];
        s.new_latitude = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
        s.new_longitude = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
        s.success = [NSNumber numberWithBool:TRUE];
        s.capture = _capture;
        
    }
	if([self.delegate conformsToProtocol:@protocol(LocationManagerDelegate)])
		[self.delegate locationCaptureUpdate:TRUE];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_capture)
    {
        GPSSample *s = (GPSSample *)[NSEntityDescription insertNewObjectForEntityForName:@"GPSSample" 
                                                                  inManagedObjectContext:[[GLB get]getMngObjCtx]];
        s.time = [NSDate date];
        s.success = [NSNumber numberWithBool:FALSE];
    }
	if([self.delegate conformsToProtocol:@protocol(LocationManagerDelegate)])
		[self.delegate locationCaptureUpdate:FALSE];
}

-(void)startCapture:(Capture*)capture
{
    _capture = capture;
    [_locationManager startUpdatingLocation];
}

-(void)stopCapture
{
    [_locationManager stopUpdatingLocation];
    _capture = nil;
}

- (void)dealloc
{
	[_locationManager release];
    _capture = nil;
    delegate = nil;
	[super dealloc];
}

@end
