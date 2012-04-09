//
//  CSVGenerator.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/8/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVGenerator : NSObject

+(NSData*)generateGPS:(NSArray*)samples;
+(NSData*)generateHTTP:(NSArray*)samples;

@end
