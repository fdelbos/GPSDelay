//
//  HTTPSample.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/8/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture;

@interface HTTPSample : NSManagedObject

@property (nonatomic, retain) NSDate * begin;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSNumber * success;
@property (nonatomic, retain) Capture *capture;

@end
