//
//  GLB.m
//  GPSDelay
//
//  Created by Frederic Delbos on 4/5/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import "GLB.h"

@implementation GLB

static GLB *_instance = nil;

+(GLB*) get
{
    @synchronized([GLB class])
	{
		if (!_instance)
			[[self alloc] init];
		return _instance;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([GLB class])
	{
		NSAssert(_instance == nil, @"Attempted to allocate a second instance of a singleton.");
		_instance = [super alloc];
		return _instance;
	}
	return nil;
}

-(id)init
{
	self = [super init];
	if (self != nil)
    {
        _listing = [[ListingView alloc] init];
        _capture = [[CaptureView alloc] initWithNibName:@"CaptureView" bundle:nil];
        _results = [[ResultsView alloc] initWithNibName:@"ResultsView" bundle:nil];
        _navBar = [[UINavigationController alloc] init];
        [_navBar pushViewController:_listing animated:YES];
    }
	return self;
}

-(UIViewController*)getMainView
{
    return  _navBar;
}

-(void)setMngObjCtx:(NSManagedObjectContext *)mngObjCtx;
{
    _mngObjCtx = mngObjCtx;
}

-(NSManagedObjectContext *)getMngObjCtx;
{
    return _mngObjCtx;
}

-(void)pushNew
{
    [_navBar pushViewController:_capture animated:YES];
}

-(void)pushResults:(Capture*)capture
{
    _results.capture = capture;
    [_navBar pushViewController:_results animated:YES];
}

@end
