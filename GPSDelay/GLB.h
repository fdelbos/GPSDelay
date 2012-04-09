//
//  GLB.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/5/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListingView.h"
#import "CaptureView.h"
#import "ResultsView.h"

#define alert(msg, title) [[[[UIAlertView alloc]        \
                            initWithTitle:title         \
                            message:msg                 \
                            delegate:nil                \
                            cancelButtonTitle:@"Ok"     \
                            otherButtonTitles:nil] autorelease] show];


@interface GLB : NSObject
{
@private
    UINavigationController *_navBar;
    ListingView *_listing;
    CaptureView *_capture;
    ResultsView *_results;
    NSManagedObjectContext *_mngObjCtx;
}

+(GLB*)get;

-(UIViewController*)getMainView;
-(void)setMngObjCtx:(NSManagedObjectContext *)mngObjCtx;
-(NSManagedObjectContext *)getMngObjCtx;

-(void)pushNew;
-(void)pushResults:(Capture*)capture;

@end
