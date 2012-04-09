//
//  HTTPManager.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/7/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Capture.h"

#define HTTP_TIMEOUT 30.0

@protocol HTTPManagerDelegate 
@required
-(void)HTTPCaptureUpdate:(BOOL)success;
@end

@interface HTTPManager : NSObject <NSURLConnectionDelegate>
{
@private
    float _interval;
    NSString* _service;
    Capture *_capture;
    BOOL _started;
    NSTimer *_timer;
    NSDate *_begin;
    
    NSURLConnection *_connection;
    NSMutableData *_data;
}

@property (nonatomic, assign) id delegate;

-(void)startCapture:(Capture*)capture service:(NSString*)service interval:(float)interval;
-(void)stopCapture;
-(void)requestFinished:(BOOL)success;

@end
