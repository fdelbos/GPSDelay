//
//  ListingView.h
//  GPSDelay
//
//  Created by Frederic Delbos on 4/5/12.
//  Copyright (c) 2012 Frederic Delbos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingView : UITableViewController <NSFetchedResultsControllerDelegate>
{
@private
    NSFetchedResultsController *_fetchedResultsController;
    NSDateFormatter *_df;
}

@property(nonatomic, retain) NSMutableArray *listing;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
