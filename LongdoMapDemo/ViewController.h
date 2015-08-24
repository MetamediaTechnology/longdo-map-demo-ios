//
//  ViewController.h
//  LongdoMapDemo
//
//  Created by Spicydog Proxy on 13-08-2015.
//  Copyright (c) 2015 MetaMedia Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMapView.h"

@interface ViewController : UIViewController <MMMapViewDelegate> {
  
  IBOutlet MMMapView *_mapView;
  
}


- (IBAction)showNormalLayer:(id)sender;

- (IBAction)showTrafficLayer:(id)sender;

- (IBAction)showSatelliteLayer:(id)sender;


- (IBAction)toggleTagHospital:(id)sender;

- (IBAction)toggleTagGasStation:(id)sender;

- (IBAction)toggleTagBank:(id)sender;

@end  

