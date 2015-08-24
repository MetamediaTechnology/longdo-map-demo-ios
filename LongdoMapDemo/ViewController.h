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

@end  

