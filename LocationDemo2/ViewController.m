//
//  ViewController.m
//  LocationDemo2
//
//  Created by Stanley Wu on 5/25/15.
//  Copyright (c) 2015 Stanley Wu. All rights reserved.
//

#import "ActionItem.h"
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController {
    CLLocationManager *locationManager;
    NSMutableArray *action_list;
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    [NSTimer scheduledTimerWithTimeInterval:10.0f
                                     target:self
                                   selector:@selector(updateMethod:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)updateMethod:(NSTimer *)theTimer {
    /*CLLocationDegrees from_latitude = locationManager.location.coordinate.latitude;
    CLLocationDegrees from_longitude = locationManager.location.coordinate.longitude;
    CLLocationDegrees to_latitude = 40.748651;
    CLLocationDegrees to_longitude = -73.985653;*/
    
    //40.748651, -73.985653
    //25.029310, 121.622004 my house
    //25.034010, 121.564809 taipei 101
    
    //-----test code
    CLLocationDegrees from_latitude = 25.029310;
    CLLocationDegrees from_longitude = 121.622004;
    CLLocationDegrees to_latitude = 25.034010;
    CLLocationDegrees to_longitude = 121.564809;
    //-----
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:(from_latitude+to_latitude)/2
                                                            longitude:(from_longitude+to_longitude)/2
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(from_latitude, from_longitude);
    //destination -- empire state building
    GMSMarker *destination_marker = [[GMSMarker alloc] init];
    destination_marker.position = CLLocationCoordinate2DMake(to_latitude, to_longitude);
    destination_marker.title = @"Destination Location";
    destination_marker.map = mapView_;
    
    [self GetDirection:marker destionation:destination_marker];
    [self DrawMarkerAndPolyLine];
    
    
    
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    NSLog(@"didUpdateToLocation: %@", theLocation);
    [self.view setNeedsDisplay];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) GetDirection:(GMSMarker *)from destionation:(GMSMarker *)to {

    NSMutableArray *actionList = [[NSMutableArray alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@?origin=%f,%f&destination=%f,%f&sensor=true&mode=transit&key=%@",
                           @"https://maps.googleapis.com/maps/api/directions/json",
                           from.position.latitude,
                           from.position.longitude,
                           to.position.latitude,
                           to.position.longitude,
                           @"AIzaSyCWbkf2K_ZfqWag9bss3AbZc_VRSUC72F0"];
    NSURL *directionsURL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:directionsURL];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             
             NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSArray *routes = [result objectForKey:@"routes"];
             NSDictionary *firstRoute = [routes objectAtIndex:0];
             NSDictionary *leg = [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
             NSArray *steps = [leg objectForKey:@"steps"];
             
             for (NSDictionary *step in steps)
             {
                 NSDictionary *distance = [step objectForKey:@"distance"];
                 NSDictionary *duration = [step objectForKey:@"duration"];
                 NSDictionary *start = [step objectForKey:@"start_location"];
                 NSDictionary *end = [step objectForKey:@"end_location"];
                 NSDictionary *polyline = [step objectForKey:@"polyline"];
                 
           
                 ActionItem *a = [[ActionItem alloc] init];
                 a.distance = [distance objectForKey:@"text"];
                 a.duration = [duration objectForKey:@"text"];
                 a.from_latitude = [start objectForKey:@"lat"];
                 a.from_longitude = [start objectForKey:@"lng"];
                 a.to_latitude = [end objectForKey:@"lat"];
                 a.to_longitude = [end objectForKey:@"lng"];
                 a.travel_mode = [step objectForKey:@"travel_mode"];
                 a.html_instruction = [step objectForKey:@"html_instructions"];
                 a.polyline = [polyline objectForKey:@"points"];
                 
                 if( [a.travel_mode caseInsensitiveCompare:@"TRANSIT"] == NSOrderedSame ) {
                     NSDictionary *transinfo = [step objectForKey:@"transit_details"];
                     NSDictionary *transinfo_depart_stop = [transinfo objectForKey:@"departure_stop"];
                     NSDictionary *transinfo_depart_time = [transinfo objectForKey:@"departure_time"];
                     NSDictionary *transinfo_arrival_stop = [transinfo objectForKey:@"arrival_stop"];
                     NSDictionary *transinfo_line = [transinfo objectForKey:@"line"];
                     
                     a.transit_begin = [transinfo_depart_stop objectForKey:@"name"];
                     a.transit_end = [transinfo_arrival_stop objectForKey:@"name"];
                     a.transit_next = [transinfo_depart_time objectForKey:@"text"];
                     a.transit_stops = [transinfo objectForKey:@"num_stops"];
                     a.transit_line = [transinfo_line objectForKey:@"short_name"];
                 }
                 
                 [actionList addObject:a];
            }
            action_list = [actionList mutableCopy];
         }
     }];
}

-(void) DrawMarkerAndPolyLine
{
    for(ActionItem *a in action_list)
    {
        GMSPath *path = [GMSPath pathFromEncodedPath:a.polyline];
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeColor = [self randomColor];
        polyline.strokeWidth = 5.f;
        polyline.map = mapView_;
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        NSString *instruction = [NSString stringWithFormat:@"%@", a.html_instruction];
        if( [a.travel_mode caseInsensitiveCompare:@"TRANSIT"] == NSOrderedSame ) {
            instruction = [NSString stringWithFormat:@"Take Transit %@\rFrom %@ To %@ For %@ stops\rNext %@"
                                     , a.transit_line, a.transit_begin, a.transit_end, a.transit_stops, a.transit_next];
        }
        
        marker.position = CLLocationCoordinate2DMake([a.from_latitude doubleValue], [a.from_longitude doubleValue]);
        marker.title = a.travel_mode;
        marker.snippet = instruction;
        marker.map = mapView_;
    }
}

-(UIColor *)randomColor
{
    CGFloat red = arc4random() % 255 / 255.0;
    CGFloat green = arc4random() % 255 / 255.0;
    CGFloat blue = arc4random() % 255 / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return color;
}
@end