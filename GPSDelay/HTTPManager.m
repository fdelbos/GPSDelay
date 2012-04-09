//
//  HTTPManager.m
//  GPSDelay
//
//  Created by Frederic Delbos on 4/7/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import "HTTPManager.h"
#import "HTTPSample.h"
#import "GLB.h"

@implementation HTTPManager

@synthesize delegate;


-(void)capture
{
    if (!_started)
        return;
    _begin = [NSDate date];
    [_begin retain];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_service]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:HTTP_TIMEOUT];
    _connection = [[NSURLConnection alloc] initWithRequest:request 
                                                  delegate:self];
    
    if (_connection)
        _data = [[NSMutableData data] retain];
    else
        [self requestFinished:FALSE];
}



-(void)cycle
{
    if (!_started)
        return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval 
                                              target:self 
                                            selector:@selector(capture) 
                                            userInfo:nil 
                                             repeats:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection release];
    [_data release];
    [self requestFinished:FALSE];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection release];
    [_data release];
    [self requestFinished:TRUE];
}

-(void)requestFinished:(BOOL)success
{
    NSLog(@"connection finished: %i", success);
    _connection = nil;
    if (_capture)
    {
        HTTPSample *s = (HTTPSample *)[NSEntityDescription insertNewObjectForEntityForName:@"HTTPSample" 
                                                                    inManagedObjectContext:[[GLB get]getMngObjCtx]];
        s.begin = _begin;
        [_begin release];
        s.end = [NSDate date];
        s.success = [NSNumber numberWithBool:success];
        NSLog(@"success : %@", s.success);
        s.capture = _capture;
    }
    if([self.delegate conformsToProtocol:@protocol(HTTPManagerDelegate)])
		[self.delegate HTTPCaptureUpdate:success];
    [self cycle];
}

-(void)startCapture:(Capture*)capture service:(NSString*)service interval:(float)interval
{
    _interval = interval;
    _capture = capture;
    _service = service;
    _started = YES;
    [self capture];
}

-(void)stopCapture;
{
    _started = NO;
    if (_connection)
    {
        [_connection cancel];
        [_data release];
    }
    if (_timer && [_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
