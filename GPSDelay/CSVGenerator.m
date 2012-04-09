//
//  CSVGenerator.m
//  GPSDelay
//
//  Created by Frederic Delbos on 4/8/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import "CSVGenerator.h"
#import "HTTPSample.h"
#import "GPSSample.h"

// attention les yeux...
@implementation CSVGenerator
/*
+(NSString*)saveData:(NSData*)data toFile:(NSString*)file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:file];
    [data writeToFile:appFile atomically:NO];
    return [NSString stringWithFormat:@"%@/%@", documentsDirectory, file];
}*/

+(NSData*)generateGPS:(NSArray*)samples
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    NSMutableData *data = [[NSMutableData alloc] init];
    char *header = "id; success; time; old latitude; old longitude; new latitude; new longitude\n";
    char buff[1024];
    [data appendBytes:header length:strlen(header)];
    for (int i = 0; i < [samples count]; i++)
    {
        GPSSample *s = (GPSSample*)[samples objectAtIndex:i];
        snprintf(buff, 1024, "%i; %i; ", i, s.success.intValue);
        [data appendBytes:buff length:strlen(buff)];
        NSString *date = [NSString stringWithFormat:@"%@; ", [df stringFromDate:s.time]];
        [data appendData:[date dataUsingEncoding:NSUTF8StringEncoding]];
        snprintf(buff, 1024, "%f; %f; %f; %f\n", 
                 s.old_latitude.doubleValue, s.old_longitude.doubleValue,
                 s.new_latitude.doubleValue, s.new_longitude.doubleValue);
        [data appendBytes:buff length:strlen(buff)];
    }
    [df release];
    return data;
}

+(NSData*)generateHTTP:(NSArray*)samples
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    NSMutableData *data = [[NSMutableData alloc] init];
    char *header = "id; success; begin; end\n";
    char buff[1024];
    [data appendBytes:header length:strlen(header)];
    for (int i = 0; i < [samples count]; i++)
    {
        HTTPSample *s = (HTTPSample*)[samples objectAtIndex:i];
        snprintf(buff, 1024, "%i; %i; ", i, s.success.intValue);
        [data appendBytes:buff length:strlen(buff)];
        NSString *date = [NSString stringWithFormat:@"%@; %@\n", [df stringFromDate:s.begin], [df stringFromDate:s.end]];
        [data appendData:[date dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [df release];
    return data;
}

@end
