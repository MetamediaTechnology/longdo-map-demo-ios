//
//  ViewController.swift
//  LongdoMapSDKTest
//
//  Created by กมลภพ จารุจิตต์ on 22/9/59.
//  Copyright © พ.ศ. 2559 Metamedia Technology. All rights reserved.
//

import UIKit
import LongdoMapSDK

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, LongdoSearchDelegate, UISearchBarDelegate {
    
    //MARK:- Initial
    let APIKEY = "16a3c9373e8911c2e4736d92431f7113"
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var map: LongdoMapView?
    @IBOutlet weak var loader: UIActivityIndicatorView?
    var eventTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        map?.setKey(APIKEY)
        map?.language = LongdoLanguage.THAI
        map?.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(13.756674, 100.501853), (map?.coordinateSpan(withZoomLevel: 7))!), animated: false)
        map?.addLongdoOverlay(LongdoMode.POI)
        map?.showsUserLocation = true
        map?.showsScale = true
        map?.searchDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Action
    @IBAction func zoomIn() {
        map?.setZoomLevel((map?.getZoomLevel())! + 1)
    }
    
    @IBAction func zoomOut() {
        map?.setZoomLevel((map?.getZoomLevel())! - 1)
    }
    
    @IBAction func setNormalMap() {
        eventTimer?.invalidate()
        map?.removeOverlays((map?.overlays)!)
        map?.addLongdoOverlay(LongdoMode.POI)
    }
    
    @IBAction func setTrafficMap() {
        map?.removeOverlays((map?.overlays)!)
        map?.addLongdoOverlay(LongdoMode.GRAY)
        eventTimer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(ViewController.getEvent), userInfo: nil, repeats: true)
        map?.addLongdoOverlay(LongdoMode.TRAFFIC)
    }
    
    @IBAction func setSatelliteMap() {
        eventTimer?.invalidate()
        map?.removeOverlays((map?.overlays)!)
        map?.addLongdoOverlay(LongdoMode.THAICHOTE)
        map?.addLongdoOverlay(LongdoMode.POI_TRANSPARENT)
    }
    
    @IBAction func setOpenStreetMap() {
        eventTimer?.invalidate()
        map?.removeOverlays((map?.overlays)!)
        map?.addCustomOverlay(withURL: "https://c.tile.openstreetmap.org/{z}/{x}/{y}.png")
    }
    
    @IBAction func showShop() {
        map?.removeAllTags()
        map?.showTags(["shop"])
    }
    
    @IBAction func showBank() {
        map?.removeAllTags()
        map?.showTags(["bank"])
    }
    
    @IBAction func showHotel() {
        map?.removeAllTags()
        map?.showTags(["hotel"])
    }
    
    @IBAction func clearTag() {
        map?.removeAllTags()
    }
    
    func getEvent() {
        map?.removeLongdoOverlay(LongdoMode.TRAFFIC)
        map?.addLongdoOverlay(LongdoMode.TRAFFIC)
    }
    
    //MARK:- Map Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            return nil
        }
        else if annotation is PinAnnotation {
            annView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            (annView as! MKPinAnnotationView).pinTintColor = UIColor.cyan
            annView.layer.zPosition = CGFloat(750) - CGFloat((annotation as! PinAnnotation).coordinate.latitude)
            (annView as! MKPinAnnotationView).animatesDrop = true
        }
        else if annotation is TagAnnotation {
            annView.image = (annotation as! TagAnnotation).icon
        }
        else {
            annView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            (annView as! MKPinAnnotationView).pinTintColor = UIColor.red
            (annView as! MKPinAnnotationView).animatesDrop = true
            annView.layer.zPosition = 999
            annView.canShowCallout = true
        }
        return annView;
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is LongdoTileOverlay {
            return LongdoTileOverlayRenderer(tileOverlay: overlay as! LongdoTileOverlay)
        }
//        if overlay is MKCircle {
//            let circle = MKCircleRenderer(overlay: overlay)
//            circle.strokeColor = UIColor.red
//            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
//            circle.lineWidth = 1
//            return circle
//        }
        return MKPolylineRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.isHidden {
            return
        }
        let activePin = MKPointAnnotation()
//        let circle = MKCircle(center: (view.annotation?.coordinate)!, radius: 100000)
//        map?.add(circle)
        if view.annotation is PinAnnotation {
            let pin = view.annotation as! PinAnnotation
            activePin.title = pin.name
            activePin.subtitle = pin.address
            print(pin.poiid)
        }
        else if view.annotation is TagAnnotation {
            let pin = view.annotation as! TagAnnotation
            activePin.title = pin.name
            print(pin.poiid)
        }
        else {
            return
        }
        activePin.coordinate = (view.annotation?.coordinate)!
        for annotation in (map?.annotations)! {
            if annotation is MKPointAnnotation {
                map?.removeAnnotation(annotation)
                break
            }
        }
        map?.addAnnotation(activePin)
        map?.selectAnnotation(activePin, animated: true)
    }
    
    //MARK:- Search Delegate
    func searchData(_ poi: [PinAnnotation]!) {
        map?.addAnnotations(poi)
        loader?.stopAnimating()
    }
    
    func suggestData(_ keyword: [String]!) {
        print(keyword)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        map?.search(withKeyword: searchBar.text)
        loader?.startAnimating()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        else {
            searchBar.setShowsCancelButton(false, animated: true)
            map?.suggest(withKeyword: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        for annotation in (map?.annotations)! {
            if annotation is PinAnnotation {
                map?.removeAnnotation(annotation)
            }
        }
    }
}

