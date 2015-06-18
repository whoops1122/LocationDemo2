//
//  ActionItem.h
//  LocationDemo2
//
//  Created by Stanley Wu on 5/26/15.
//  Copyright (c) 2015 Stanley Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ActionItem : NSObject

@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *from_latitude;
@property (nonatomic, copy) NSString *from_longitude;
@property (nonatomic, copy) NSString *to_latitude;
@property (nonatomic, copy) NSString *to_longitude;
@property (nonatomic, copy) NSString *travel_mode;
@property (nonatomic, copy) NSString *html_instruction;
@property (nonatomic, copy) NSString *polyline;

@property (nonatomic, copy) NSString *transit_begin;
@property (nonatomic, copy) NSString *transit_end;
@property (nonatomic, copy) NSString *transit_stops;
@property (nonatomic, copy) NSString *transit_next;
@property (nonatomic, copy) NSString *transit_line;

-(id)initActionItem:(NSString*)in_distance
                 :(NSString*)in_duration
                 :(NSString*)in_from_lat
                 :(NSString*)in_from_long
                 :(NSString*)in_to_lat
                 :(NSString*)in_to_long
                 :(NSString*)in_travel_mode
                 :(NSString*)in_html_instruction
                 :(NSString*)in_polyline
                 :(NSString*)in_transit_begin
                 :(NSString*)in_transit_end
                 :(NSString*)in_transit_stops
                 :(NSString*)in_transit_next
                 :(NSString*)in_transit_line;
@end
