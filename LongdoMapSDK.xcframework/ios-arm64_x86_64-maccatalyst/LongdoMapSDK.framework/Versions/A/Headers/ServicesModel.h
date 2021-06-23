//
//  ServicesModel.h
//  LongdoMapSDK
//
//  Created by กมลภพ จารุจิตต์ on 4/8/2562 BE.
//  Copyright © 2562 Metamedia Technology. All rights reserved.
//

@import MapKit;
@import CoreLocation;
#import <Foundation/Foundation.h>

/*!
 @enum LMRouteMode
 
 @discussion The LMRouteMode enum defines thinking method to route.
 */
typedef NS_ENUM(NSInteger, LMRouteMode) {
    AVOID_TRAFFIC,
    BEST_TIME,
    MINIMUM_DISTANCE
};

/*!
 @enum LMRouteTurn
 
 @discussion The LMRouteTurn enum defines turn instruction in routing result.
 */
typedef NS_ENUM(NSInteger, LMRouteTurn) {
    TURN_LEFT,
    TURN_RIGHT,
    TURN_SLIGHT_LEFT,
    TURN_SLIGHT_RIGHT,
    GO_STRAIGHT,
    ENTER_TOLLWAY,
    UNKNOWN
};

@interface LMIcon : NSObject

/// Icon image.
@property (nonatomic, strong) UIImage *image;
/// Icon offset.
@property (nonatomic, assign) CGPoint offset;
/// Icon alpha value between 0.0 - 1.0.
@property (nonatomic, assign) CGFloat alpha;

- (id)initWithImage:(UIImage *)image;

@end

@interface LMSuggestOptions : NSObject

/// Offset of the first result returned.
@property (nonatomic, assign) NSInteger offset;
/// Number of results returned.
@property (nonatomic, assign) NSInteger limit;

@end

@interface LMSearchOptions : NSObject

/// Center of results.
@property (nonatomic, assign) CLLocationCoordinate2D location;
/// Span with unit in degrees, meters or kilometers e.g. "2deg", "300m", "1km".
@property (nonatomic, strong) NSString *span;
/// Offset of the first result returned.
@property (nonatomic, assign) NSInteger offset;
/// Number of results returned.
@property (nonatomic, assign) NSInteger limit;

@end

@interface LMTagOptions : NSObject

/// Range of zoom level which a tag is visible.
@property (nonatomic, assign) NSRange visibleRange;
/// Customized tag icon.
@property (nonatomic, strong) LMIcon *icon;

@end

@interface LMRouteOptions : NSObject

/// Thinking method to route.
@property (nonatomic, assign) LMRouteMode mode;
/// Flag to identify whether the result includes tollway path.
@property (nonatomic, assign) BOOL allowedTollway;
/// Flag to identify whether the result includes ferry path.
@property (nonatomic, assign) BOOL allowedFerry;

@end

@interface LMRouteGuide : NSObject

/// Road name.
@property (nonatomic, strong) NSString *name;
/// Turn instruction.
@property (nonatomic, assign) LMRouteTurn turn;
/// Distance in meters for specified step.
@property (nonatomic, assign) NSInteger distance;
/// Estimated time of arrival in seconds for specified step.
@property (nonatomic, assign) NSInteger interval;
/// Path for specified step.
@property (nonatomic, strong) MKPolyline *path;

@end

@interface LMRouteResult : NSObject

/// Distance from starting point to nearest road in meters.
@property (nonatomic, assign) double fDistance;
/// Distance from nearest road to destination in meters.
@property (nonatomic, assign) double tDistance;
/// List of roads.
@property (nonatomic, strong) NSArray<LMRouteGuide *> *guide;
/// Overall distance in meters.
@property (nonatomic, assign) NSInteger distance;
/// Overall estimated time of arrival in seconds.
@property (nonatomic, assign) NSInteger interval;

@end

@interface LMAQIData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *unit;

@end

@interface LMAQIInfo : NSObject

- (id)initWithData:(NSDictionary *)data;

@property (nonatomic, strong) LMAQIData *pm10;
@property (nonatomic, strong) LMAQIData *pm25;
@property (nonatomic, strong) LMAQIData *so2;
@property (nonatomic, strong) LMAQIData *co;
@property (nonatomic, strong) LMAQIData *no2;
@property (nonatomic, strong) LMAQIData *o3;

@end
