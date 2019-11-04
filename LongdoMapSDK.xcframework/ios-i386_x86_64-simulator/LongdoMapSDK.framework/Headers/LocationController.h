//
//  LocationController.h
//  LongdoMapSDK
//
//  Created by กมลภพ จารุจิตต์ on 24/1/2562 BE.
//  Copyright © 2562 Metamedia Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@protocol LocationControllerDelegate

- (void)locationControllerDidUpdateLocation:(CLLocation *)location;
- (void)locationControllerDidUpdateHeading:(CLHeading *)newHeading;
- (void)locationControllerDidFailWithError:(NSError *)error;

@end

@interface LocationController : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (weak, nonatomic) id delegate;

+ (LocationController *)sharedController;

@end
