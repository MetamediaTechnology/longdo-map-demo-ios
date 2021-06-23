//
//  Annotation.h
//  LongdoMap
//
//  Created by กมลภพ จารุจิตต์ on 29/10/58.
//  Copyright © พ.ศ. 2558 Metamedia Technology. All rights reserved.
//

@import MapKit;
@import CoreLocation;
#import "ServicesModel.h"
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
    FIRE = 15,
    COMPLAINT = 16,
    DIVERSION = 18,
    ROADCLOSED = 19
};

/*!
 @enum LMCameraFormat
 
 @discussion The LMCameraFormat enum defines constants that
 can be used to specify the format of camera on the map.
 */
typedef NS_ENUM(NSInteger, LMCameraFormat) {
    GIF,
    MJPEG,
    M3U8
};

/*!
 @enum LMAQISource
 
 @discussion The LMAQISource enum defines source of air quality data.
 */
typedef NS_ENUM(NSInteger, LMAQISource) {
    AQICN = 1,
    AIR4THAI
};

@interface LMPinAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *poiid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIImage *icon; /*deprecated*/
@property (nonatomic, strong) NSObject *userData;
@property (nonatomic, strong) NSString *type;

@end

@interface LMTagAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *poiid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger minZoom;
@property (nonatomic, strong) LMIcon *customIcon;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@interface LMEventAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) UIImage *icon; /*deprecated*/
@property (strong, nonatomic) NSString *iconName;
@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *stop;
@property (strong, nonatomic) NSString *contributor;
@property (nonatomic, assign) NSInteger severity;
@property (nonatomic, assign) NSInteger showlevel;
@property (nonatomic, assign) LMEventType type;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSArray<NSURL *> *imageURLs;

@end

@interface LMCameraAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *cameraId;
@property (strong, nonatomic) NSString *cameraTitle;
@property (strong, nonatomic) UIImage *icon; /*deprecated*/
@property (strong, nonatomic) NSDate *lastUpdate;
@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *sponsorText;
@property (strong, nonatomic) NSURL *sponsorImageURL;
@property (strong, nonatomic) NSURL *url;
@property (nonatomic, assign) LMCameraFormat format;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@interface LMAQIAnnotation : NSObject <MKAnnotation>

- (id)initWithData:(NSDictionary *)data;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSString *aqiValue;
@property (nonatomic, strong) NSString *aqiId;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) NSString *statusText;
@property (nonatomic, strong) NSURL *iconStatus;
@property (nonatomic, strong) NSURL *iconMarker;
@property (nonatomic, assign) NSInteger minZoom;
@property (nonatomic, assign) LMAQISource source;
@property (nonatomic, strong) LMAQIInfo *info;

@end

@interface LMUserAnnotation : UIView

@property (strong, nonatomic) UIImageView *heading;
@property (strong, nonatomic) UIImageView *pin;

@end
