//
//  MTSubscription.h
//  cTiVo
//
//  Created by Hugh Mackworth on 1/4/13.
//  Copyright (c) 2013 Scott Buchanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTTiVoShow.h"
#import "MTFormat.h"

@interface MTSubscription : NSObject {
    
}


@property (nonatomic, strong) NSString *seriesTitle;
@property (nonatomic, strong) NSDate *lastRecordedTime;

@property (nonatomic, strong) NSNumber *addToiTunes;
@property (nonatomic, strong) NSNumber *skipCommercials, *includeSuggestions, *markCommercials;
@property (nonatomic, strong) MTFormat *encodeFormat;
@property (nonatomic, strong) NSNumber *genTextMetaData,
									   *genXMLMetaData,
									   *includeAPMMetaData,
									   *exportSubtitles;

@property (readonly) BOOL canSimulEncode;
@property (readonly) BOOL shouldSimulEncode;
@property (readonly) BOOL canAddToiTunes;
@property (readonly) BOOL shouldAddToiTunes;
@property (readonly) BOOL canSkipCommercials;
@property (readonly) BOOL canMarkCommercials;
@property (readonly) BOOL shouldSkipCommercials;

@end

@interface NSMutableArray (MTSubscriptionList)

-(void) checkSubscriptionsAll;
-(NSArray *) addSubscriptions:(NSArray *) shows; //returns new subs
-(NSArray *) addSubscriptionsDL: (NSArray *) downloads;
-(void) deleteSubscriptions:(NSArray *) subscriptions;
-(void) updateSubscriptionWithDate: (NSNotification *) notification;
-(BOOL) isSubscribed:(MTTiVoShow *) tivoShow;
-(void) saveSubscriptions;
-(void) loadSubscriptions;

@end
