//
//  Capture.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/7/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Capture : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * start;

@end
