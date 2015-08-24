//
//  MMMapViewDelegate.h
//
//  Created 9/24/12.
//  Copyright (c) 2013 Metamedia Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMapView.h"

@class MMMapView;
@class MMMarker;

@protocol MMMapViewDelegate

@required

// Map Status
- (void)mapView:(MMMapView *)mapView mapStatus:(int)status;
- (void)mapView:(MMMapView *)mapView mapState:(MMMapState)mapState;

// Click
- (void)mapView:(MMMapView *)mapView clickOnMarker:(MMMarker *)marker;
- (void)mapView:(MMMapView *)mapView clickOnLongdoTag:(NSDictionary *)data;
- (void)mapView:(MMMapView *)mapView clickedAtLocation:(MMLocation)location;

// Long Click
- (void)mapView:(MMMapView *)mapView
    longClickStartAtLocation:(MMLocation)location;
- (void)mapView:(MMMapView *)mapView
    longClickFinishAtLocation:(MMLocation)location;

// Zooming
- (void)mapView:(MMMapView *)mapView startZoomFrom:(int)zoom;
- (void)mapView:(MMMapView *)mapView finishZoomTo:(int)zoom;

// Moving
- (void)mapView:(MMMapView *)mapView startMovingFrom:(MMLocation)location;
- (void)mapView:(MMMapView *)mapView finishMovingTo:(MMLocation)location;

// User Action
- (void)onUserPanning:(MMMapView *)mapView;
- (void)onUserZooming:(MMMapView *)mapView;

@end
