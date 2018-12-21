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

/*!
 @enum LMEventType
 
 @discussion The LMEventType enum defines constants that
 can be used to specify the type of event on the map.
 */
typedef NS_ENUM(NSInteger, LMEventType) {
    CAR_BREAKDOWN = 1,
    CONSTRUCTION = 2,
    ACCIDENT = 3,
    RAIN = 5,
    FLOOD = 6,
    CROWD = 7,
    INFORMATION = 8,
    CHECKPOINT = 9,
    TRAFFIC_JAM = 10,
    MISC = 11,
    WARNING = 12,
    EVENT = 13,
    SALE = 14,
    FIRE = 15
};

@interface LMPinAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *poiid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIImage *icon;
@property (nonatomic, strong) NSObject *userData;

@end

@interface LMTagAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *poiid;
@property (strong, nonatomic) UIImage *icon;
@property (nonatomic, assign) NSInteger zoom;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@interface LMEventAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *stop;
@property (strong, nonatomic) NSString *contributor;
@property (nonatomic, assign) LMEventType type;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@interface LMCameraAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *cameraId;
@property (strong, nonatomic) NSString *cameraTitle;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSDate *lastUpdate;
@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *sponsorText;
@property (strong, nonatomic) NSURL *url;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
