//
//  GPSSample.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/8/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture;

@interface GPSSample : NSManagedObject

@property (nonatomic, retain) NSNumber * new_latitude;
@property (nonatomic, retain) NSNumber * new_longitude;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * success;
@property (nonatomic, retain) NSNumber * old_latitude;
@property (nonatomic, retain) NSNumber * old_longitude;
@property (nonatomic, retain) Capture *capture;

@end
