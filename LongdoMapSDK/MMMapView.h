//
//  MMMapView.h
//
//  Created 9/21/12.
//  Copyright (c) 2013 Metamedia Technology Co., Ltd. All rights reserved.
//

typedef struct {
  double latitude;
  double longitude;
} MMLocation;
static MMLocation MMLocationMake(double latitude, double longitude);

typedef struct {
  MMLocation location;
  int zoom;
} MMMapState;
static MMMapState MMMapStateMake(MMLocation location, int zoom);


// Classes
@class MMLayer;
@class MMMarker;
@class MMScaleBar;

#import <UIKit/UIKit.h>
#import "MMMapViewDelegate.h"


// Longdo Map SDK config

// Initial latitude longitude and zoom
#define DEFAULT_LAT 13.722439
#define DEFAULT_LON 100.529451
#define DEFAULT_ZOOM 14

// Initial zoom range
#define DEFAULT_MIN_ZOOM 4
#define DEFAULT_MAX_ZOOM 18

// Map tile display
#define DRAW_OVERLAY_TILE_ONLY_WHEN_BASE_IS_READY YES
#define FADE_IN_BASE_LAYER YES

// Tag icon size
#define TAG_EXTRA_SIZE 0

// Map status code
#define STATUS_INITIALIZING 0
#define STATUS_CORRECT_API_KEY 1
#define STATUS_MAP_READY 2
#define STATUS_INCORRECT_API_KEY -1
#define STATUS_UNABLE_TO_CHECK_API_KEY -2

// Base layer names
#define LAYER_NAME_BASE @"BASE"
#define LAYER_NAME_GISTDA_SPOT5 @"GISTDA_SPOT5"
#define LAYER_NAME_GRAY @"GRAY"
#define LAYER_NAME_GRAY_EN @"GRAY_EN"
#define LAYER_NAME_HYDRO @"HYDRO"
#define LAYER_NAME_MAPQUEST @"MAPQUEST"
#define LAYER_NAME_NORMAL @"NORMAL"
#define LAYER_NAME_NORMAL_EN @"NORMAL_EN"
#define LAYER_NAME_OPENCYCLE @"OPENCYCLE"
#define LAYER_NAME_OSM @"OSM"
#define LAYER_NAME_POI @"POI"
#define LAYER_NAME_POI_EN @"POI_EN"
#define LAYER_NAME_POLITICAL @"POLITICAL"
#define LAYER_NAME_POLITICAL_EN @"POLITICAL_EN"
#define LAYER_NAME_POLITICAL_NOLABEL @"POLITICAL_NOLABEL"
#define LAYER_NAME_TERRAIN @"TERRAIN"
#define LAYER_NAME_THAICHOTE @"THAICHOTE"

// Overlay layer names
#define LAYER_NAME_GOOGLE_ROAD @"GOOGLE_ROAD"
#define LAYER_NAME_GOOGLE_ROAD_EN @"GOOGLE_ROAD_EN"
#define LAYER_NAME_POI_TRANSPARENT @"POI_TRANSPARENT"
#define LAYER_NAME_POI_TRANSPARENT_EN @"POI_TRANSPARENT_EN"
#define LAYER_NAME_TRAFFIC @"TRAFFIC"

// Layer types
#define LAYER_TYPE_CUSTOM 0
#define LAYER_TYPE_LONGDO 1
#define LAYER_TYPE_TMS 2
#define LAYER_TYPE_WMS 3
#define LAYER_TYPE_WMTS 4

// Projections
#define PROJECTION_EPSG4326 @"EPSG:3857"
#define PROJECTION_EPSG3857 @"EPSG:4326"

//################
//# Class MapView
//################

@interface MMMapView : UIView

@property(retain) id<MMMapViewDelegate> mapViewDelegate;

//#
//# Initialization
//#

/**
 Initializes a `MMMapView` object with Longdo Map API Key.
 @param accessKey Longdo Map API Key.
 @return MMMapView object.
 */
- (MMMapView *)initMapWithKey:(NSString *)accessKey;

/**
 Initializes a `MMMapView` object "without" API Key.
 @return MMMapView object.
 @warning layer name from SDK will not work, you must use custom map server.
 */
- (MMMapView *)initMap; // without key, you need your own map server

/**
 Close the map to release memory.
 */
- (void)closeMap;

//#
//# Map parameters
//#

/**
 Set max zoom level for the map.
 @param zoom new map max zoom level [1-20].
 */
- (void)setMaxZoom:(int)zoom;

/**
 Set min zoom level for the map.
 @param zoom new map min zoom level [1-20].
 */
- (void)setMinZoom:(int)zoom;

/**
 Set map background color of the mapin no tile area.
 @param color Color of map background.
 */
- (void)setMapBackgroundColor:(UIColor *)color;

//#
//# Gesture control
//#

/**
 Enable or disable pan to move action on map
 @param isEnable enable or disable.
 */
- (void)enablePan:(bool)isEnable;

/**
 Enable or disable pinch to zoom action on map
 @param isEnable enable or disable.
 */
- (void)enablePinch:(bool)isEnable;

/**
 Enable or disable tilt action on map
 @param isEnable enable or disable.
 */
- (void)enableTilt:(bool)isEnable;

/**
 Enable or disable rotate action on map
 @param isEnable enable or disable.
 */
- (void)enableRotate:(bool)isEnable;

/**
 Enable or disable conter pinching zooming on map, if enable pinch zoom will keep map current center only zoom change.
 @param isEnable enable or disable.
 */
- (void)enableCenterZooming:(bool)isEnable;

/**
 Enable or disable center red mark at the center of the map
 @param isEnable enable or disable.
 */
- (void)enableCrossMark:(bool)isEnable;

//#
//# Location Control
//#

/**
 Get map current location.
 @return map current location.
 */
- (MMLocation)location;

/**
 Set map current location without animation.
 @param location the new location of the map.
 */
- (void)setLocation:(MMLocation)location;

/**
 Set map current location with animation control.
 @param location the new location of the map.
 @param isAnimate move map with animation or not.
 */
- (void)setLocation:(MMLocation)location withAnimation:(bool)isAnimate;

//#
//# Zoom Control
//#

/**
 Get map current zoom.
 @return map current zoom.
 */
- (int)zoom;

/**
 Zoom in for one level with animation
 */
- (void)zoomIn;

/**
 Zoom zoom for one level with animation
 */
- (void)zoomOut;

/**
 Set map zoom without animation.
 @param zoom the new zoom of the map.
 */
- (void)setZoom:(int)zoom; // Without animation

/**
 Set map zoom with animation control.
 @param zoom the new zoom of the map.
 @param isAnimate zoom map with animation or not.
 */
- (void)setZoom:(int)zoom withAnimation:(bool)isAnimate;

/**
 Get map current zoom in fine scale.
 @return map current fine zoom.
 */
- (float)fineZoom;

/**
 Set map fine zoom without animation.
 @param fineZoom the new fine zoom of the map.
 */
- (void)setFineZoom:(float)fineZoom;

//#
//# Boundary
//#

/**
 Get map boundary for zoom at a specific location.
 @return regtangular of `MMLocation`
 */
- (CGRect)locationBoundaryForZoom:(int)zoom
                         atCenter:(MMLocation)location;

/**
 Set map boundary for a regtangular of `MMLocation`.
 @param boundary a regtangular of `MMLocation`
 */
- (void)setMapBoundaryFor:(CGRect)boundary;

/**
 Set map boundary between location1 and location2.
 @param location1 location at top left.
 @param location2 location at buttom right.
 @param extraZoom set zoom more or less than the zoom.
 */
- (void)setBoundaryBetween:(MMLocation)location1
                       and:(MMLocation)location2
             withExtraZoom:(int)extraZoom;

/**
 Set map boundary between location1 and location2, with fixed center.
 @param location1 location at top left.
 @param location2 location at buttom right.
 @param center location that will be set for the center of the map.
 @param extraZoom set zoom more or less than computed zoom.
 */
- (void)setBoundaryBetween:(MMLocation)location1
                       and:(MMLocation)location2
                withCenter:(MMLocation)center
              andExtraZoom:(int)extraZoom; // deprecate

//#
//# Marker
//#

/**
 Get all markers that are showing on the map.
 @return array of `MMMarker *`.
 */
- (NSArray *)markers;

/**
 Add a marker to the map.
 @param marker the marker to be added.
 */
- (void)addMarker:(MMMarker *)marker;

/**
 Remove a marker from the map.
 @param marker the marker to be removed.
 */
- (void)removeMarker:(MMMarker *)marker;

/**
 Remove marker(s) by marker's name.
 @param name the name of marker(s) to be removed.
 */
- (void)removeMarkerByName:(NSString *)name;

/**
 Remove all markers from the map.
 */
- (void)removeAllMarkers;

//#
//# Longdo Tags
//#

/**
 Show longdo tags on the map.
 @param array of `MMLongdoTag *`.
 */
- (void)showLongdoTags:(NSArray *)longdoTags;

/**
 Remove longdo tags from the map.
 */
- (void)hideLongdoTags;

//#
//# Map Layers
//#

/**
 Get layer from Longdo Map server.
 @param name see LAYER_NAME_ constraints.
 @return layer to use for the map.
 */
- (MMLayer *)layerName:(NSString *)name;

/**
 Get current base layer.
 @return current base layer.
 */
- (MMLayer *)baseLayer;

/**
 Get current overlay layers.
 @return array of current overlay layers, (MMLayer *).
 */
- (NSArray *)overlayLayers;

/**
 Set base layer for map view.
 @param layer map layer to set as base layer.
 */
- (void)setBaseLayer:(MMLayer *)layer;
/**
 Add overlay layer to map view.
 @param layer overlay layer to be added.
 */
- (void)addOverlayLayer:(MMLayer *)layer;

/**
 Remove overlay layer from map view.
 @param layer overlay layer to be removed.
 */
- (void)removeOverlayLayer:(MMLayer *)layer;

/**
 Remove all overlay layers from map view.
 */
- (void)removeAllOverlayLayers;


/**
 Get map scale bar.
 @return map scale bar object to process directly.
 */
- (MMScaleBar *)scaleBar;

/**
 Get current map view width.
 @return view width.
 */
- (float)width;

/**
 Get current map view height.
 @return view height.
 */
- (float)height;

/**
 Display map debug on UILabel *.
 @param label to display map debug.
 */
- (void)setDebugLabel:(UILabel *)label;

@end

//###############
//# Class Marker
//###############
@interface MMMarker : NSObject

/**
 Create a new marker from UIImage.
 @param image the image to use with marker.
 @param location the location to set marker on the map view.
 @return marker a new marker.
 @warning marker must be created on the main thread.
 */
+ (MMMarker *)markerWithImage:(UIImage *)image andLocation:(MMLocation)location;

/**
 Create a new marker from a URL of image.
 @param url the URL of the image to use with marker.
 @param location the location to set marker on the map view.
 @return marker a new marker.
 @warning marker must be created on the main thread, use this function may cause lag during marker download at the first time.
 */
+ (MMMarker *)markerWithImageUrl:(NSString *)url andLocation:(MMLocation)location;

/**
 Get marker name.
 @return marker name.
 */
- (NSString *)name;

/**
 Get marker image.
 @return marker image.
 */
- (UIImage *)image;

/**
 Get marker location.
 @return marker location.
 */
- (MMLocation)location;

/**
 Get marker offset.
 @return marker offset.
 */
- (CGPoint)offset;

/**
 Get marker weight.
 @return marker weight.
 */
- (int)weight;

/**
 Get marker data.
 @return marker data.
 */
- (NSDictionary *)data;

/**
 Get marker min zoom.
 @return marker min zoom.
 */
- (int)minZoom;

/**
 Get marker max zoom.
 @return marker max zoom.
 */
- (int)maxZoom;

/**
 Get is marker clickable.
 @return is marker clickable.
 */
- (bool)isClickable;

/**
 Get is marker persistent. Persistent markers will not be removed via remove all markers function.
 @return is marker persistent.
 */
- (bool)isPersistent;

/**
 Set marker name.
 @param name marker name.
 */
- (MMMarker *)setName:(NSString *)name;

/**
 Set marker image.
 @param image marker image.
 */
- (MMMarker *)setImage:(UIImage *)image;

/**
 Set marker location.
 @param location marker location.
 */
- (MMMarker *)setLocation:(MMLocation)location;

/**
 Set marker offset.
 Marker offset scale in marker width and height ratio.
 (0.0f, 0.0f) is the center of the marker.
 x will shift marker to the right.
 y will shift marker down.
 @param location marker offset.
 */
- (MMMarker *)setOffset:(CGPoint)offset;

/**
 Set marker weight.
 @param weight marker weight.
 */
- (MMMarker *)setWeight:(int)weight;

/**
 Set marker data.
 Developer can add a NSDictionary object to the marker to save some data.
 @param data marker data.
 */
- (MMMarker *)setData:(NSDictionary *)data;

/**
 Set marker min zoom. The marker will not show map current zoom is less than min zoom.
 @param minZoom marker min zoom.
 */
- (MMMarker *)setMinZoom:(int)minZoom;

/**
 Set marker max zoom. The marker will not show map current zoom is more than min zoom.
 @param minZoom marker max zoom.
 */
- (MMMarker *)setMaxZoom:(int)maxZoom;

/**
 Set marker clickable.
 If marker is clickable, when user click, it will call delegate function `clickOnMarker`.
 @param isClickable is marker clickable.
 */
- (MMMarker *)setIsClickable:(bool)isClickable;

/**
 Set marker persistent.
 If a marker is persistent, it will not be removed by `removeAllMarkers`.
 @param isPersistent is marker persistent.
 */
- (MMMarker *)setIsPersistent:(bool)isPersistent;

/**
 Set marker effect fade in.
 When marker is created, it will fade in from alpha 0.f.
 @param isEnable marker will fade in.
 */
- (MMMarker *)effectFadeIn:(bool)isEnable;

/**
 Set marker fade in duration.
 @param second marker fade in duration.
 */
- (MMMarker *)effectFadeInWithDuration:(float)second;

/**
 Set marker effect drop.
 When marker is created, it will drop from some top distance.
 @param isEnable marker will drop.
 */
- (MMMarker *)effectDrop:(bool)isEnable;

/**
 Set marker drop duration.
 @param second marker drop duration.
 */
- (MMMarker *)effectDropDuration:(float)second;

/**
 Set marker effect scale up.
 When marker is created, it will scale up from small size.
 @param isEnable marker will scale up.
 */
- (MMMarker *)effectScaleUp:(bool)isEnable;

/**
 Set marker scale up duration.
 @param second marker scale up duration.
 */
- (MMMarker *)effectScaleUpDuration:(float)second;

@end

//####################
//# Class Longdo Tags
//####################
@interface MMLongdoTag : NSObject

/**
 Name of longdo tag to show on longdo map. e.g. hospital, hotel, temple, etc.
 */
@property(retain) NSString *name;

/**
 Min zoom of longdo tag to show on longdo map.
 */
@property int minZoom;

/**
 Max zoom of longdo tag to show on longdo map.
 */
@property int maxZoom;

/**
 Create a new longdo tag with name.
 @param name the name of longdo tag to show on longdo map. e.g. hospital, hotel, temple, etc.
 @return longdo tag object.
 */
+ (MMLongdoTag *)tagWithName:(NSString *)name;

@end

//##################
//# Class Scale Bar
//##################
@interface MMScaleBar : NSObject

/**
 Show map scale bar.
 */
- (void)show;

/**
 Hide map scale bar.
 */
- (void)hide;

/**
 Set map scale bar alpha.
 @param alpha new scale bar alpha value (0.0f - 1.0f).
 */
- (void)setAlpha:(float)alpha;

/**
 Set map scale bar alpha with animation.
 @param alpha new scale bar alpha value (0.0f - 1.0f).
 @param second animation duration.
 */
- (void)animateScaleBarAlphaTo:(float)alpha
         withAnimationDuration:(float)second;
/**
 Set map scale bar color.
 @param red new scale bar red color (0.0f - 1.0f).
 @param green new scale bar green color (0.0f - 1.0f).
 @param blue new scale bar blue color (0.0f - 1.0f).
 */
- (void)setColorRed:(float)red green:(float)green blue:(float)blue;

/**
 Set map scale bar margin.
 @param x scale bar margin in x axis
 @param x scale bar margin in y axis
 */
- (void)setMarginX:(int)x andY:(int)y;

/**
 Set map scale bar upside down.
 @param isInvert will scale bar upside down.
 */
- (void)setUpSideDown:(bool)isInvert;

/**
 Set map scale bar right to left.
 @param isInvert will scale bar scale from right to left.
 */
- (void)setRightToLeft:(bool)isInvert;

@end

//###############
//# Class Layer
//###############
@interface MMLayer : NSObject

/**
 Name of layer
 */
@property(retain) NSString *name;

/**
 URL of layer
 */
@property(retain) NSString *url;

/**
 API Key to request layer
 */
@property(retain) NSString *key;

/**
 Formate of tile URL
 */
@property(retain) NSString *format;

/**
 SRS for tile calculation, see JROJECTION_*
 */
@property(retain) NSString *srs;

/**
 Type of layer, see LAYER_TYPE_*
 */
@property int type;

/**
 Opacity of tile of this layer.
 */
@property float opacity;

/**
 Weight of this layer, higher weight will draw under the lighter weight.
 */
@property int weight;

/**
 Min zoom of this layer to display.
 */
@property int minZoom;

/**
 Max zoom of this layer to display.
 */
@property int maxZoom;

/**
 Maximum tile age of the layer.
 */
@property int maxAge;

@property(retain) NSString *transparent;
@property(retain) NSString *styles;
@property(retain) NSString *extraQuery;
@property int refresh;

/**
 Create a new custom layer.
 @param url the url of new layer
 @param type the type of new layer, see LAYER_TYPE_*
 @return new layer
 */
+ (MMLayer *)layerWithUrl:(NSString *)url andType:(int)type;

@end

// Advanced parameters
// Please do not change if you do not need extra adjectments.
// This might cause unexpected use experiences.

// Zoom and move interval, smaller is faster.
#define ZOOM_PERIOD 15
#define MOVE_PERIOD 15

// Thread pool size, larger means concurrency but may cause too much overhead.
#define TILE_CACHE_POOL_SIZE 4
#define TILE_DOWNLOAD_POOL_SIZE 4
#define TAG_POOL_SIZE 2

// Tile load margins, larger means more tiles on screen,
// user will see less tile loading but use exponentially more CPU, memory, storage, and network.
#define OUT_SCREEN_TILE_MARGIN 0
#define OUT_SCREEN_TILE_REMOVE_MARGIN 0


// Utility functions
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

static MMLocation MMLocationMake(double latitude, double longitude) {
  MMLocation l; l.latitude = latitude; l.longitude = longitude; return l;
}

static MMMapState MMMapStateMake(MMLocation location, int zoom) {
  MMMapState s; s.location = location; s.zoom = zoom; return s;
}

#pragma clang diagnostic pop
