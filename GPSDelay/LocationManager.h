//
//  LocationManager.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/7/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Capture.h"

@protocol LocationManagerDelegate
@required
-(void)locationCaptureUpdate:(BOOL)success;
@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
@private
    CLLocationManager *_locationManager;
    Capture *_capture;
}

@property (nonatomic, assign) id delegate;

-(void)startCapture:(Capture*)capture;
-(void)stopCapture;

@end
