//
//  Annotation.h
//  LongdoMap
//
//  Created by กมลภพ จารุจิตต์ on 29/10/58.
//  Copyright © พ.ศ. 2558 Metamedia Technology. All rights reserved.
//

@import MapKit;
@import CoreLocation;
#import <Foundation/Foundation.h>

@interface PinAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *poiid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *icon;

@end

@interface TagAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *poiid;
@property (strong, nonatomic) UIImage *icon;
@property (nonatomic, assign) NSInteger zoom;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
