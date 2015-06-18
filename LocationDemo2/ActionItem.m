//
//  ActionItem.m
//  LocationDemo2
//
//  Created by Stanley Wu on 5/26/15.
//  Copyright (c) 2015 Stanley Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionItem.h"

@implementation ActionItem

-(id) initActionItem:(NSString *)in_distance
                    :(NSString *)in_duration
                    :(NSString* )in_from_lat
                    :(NSString* )in_from_long
                    :(NSString* )in_to_lat
                    :(NSString* )in_to_long
                    :(NSString *)in_travel_mode
                    :(NSString *)in_html_instruction
                    :(NSString *)in_polyline
                    :(NSString*)in_transit_begin
                    :(NSString*)in_transit_end
                    :(NSString*)in_transit_stops
                    :(NSString*)in_transit_next
                    :(NSString*)in_transit_line

{
    self = [super init];
    if(self)
    {
        self.distance = in_distance;
        self.duration = in_duration;
        self.from_latitude = in_from_lat;
        self.from_longitude = in_from_long;
        self.to_latitude = in_to_lat;
        self.to_longitude = in_to_long;
        self.travel_mode = in_travel_mode;
        self.html_instruction = in_html_instruction;
        self.polyline = in_polyline;
        self.transit_begin = in_transit_begin;
        self.transit_end = in_transit_end;
        self.transit_stops = in_transit_stops;
        self.transit_next = in_transit_next;
        self.transit_line = in_transit_line;
    }
    return self;
}

@end