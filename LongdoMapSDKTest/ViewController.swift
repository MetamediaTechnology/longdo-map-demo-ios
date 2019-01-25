//
//  ViewController.swift
//  LongdoMapSDKTest
//
//  Created by กมลภพ จารุจิตต์ on 22/9/59.
//  Copyright © พ.ศ. 2559 Metamedia Technology. All rights reserved.
//

import UIKit
import LongdoMapSDK

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, LMSearchDelegate, UISearchBarDelegate {
    
    //MARK:- Initial
    let APIKEY = "16a3c9373e8911c2e4736d92431f7113"
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var map: LongdoMapView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var eventTimer: Timer? = nil
    var currentMode: LMMode = .NORMAL
    var isRevert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        map.setKey(APIKEY)
        map.language = LMLanguage.THAI
        map.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(13.756674, 100.501853), (map.coordinateSpan(withZoomLevel: 7))), animated: false)
        map.addLMOverlay(LMMode.NORMAL)
        map.showsUserLocation = true
        map.showsScale = true
        map.searchDelegate = self
        map.userTrackingMode = MKUserTrackingMode.followWithHeading
        map.userAnnotationType = .LONGDO_PIN
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Action
    @IBAction func zoomIn() {
        map.setZoomLevel(map.getZoomLevel() + 1)
    }
    
    @IBAction func zoomOut() {
        map.setZoomLevel(map.getZoomLevel() - 1)
    }
    
    @IBAction func setNormalMap() {
        eventTimer?.invalidate()
        map.removeOverlays(map.overlays)
        map.removeCameras()
        map.removeEvents()
        map.addLMOverlay(LMMode.NORMAL)
        currentMode = .NORMAL
//        map.addLMOverlay(LMMode.OFFLINE)
    }
    
    @IBAction func setTrafficMap() {
        map.removeOverlays(map.overlays)
        map.addLMOverlay(LMMode.GRAY)
        eventTimer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(ViewController.getEvent), userInfo: nil, repeats: true)
        map.addLMOverlay(LMMode.TRAFFIC)
        currentMode = .TRAFFIC
        map.showEvents()
        map.showCameras()
    }
    
    @IBAction func setSatelliteMap() {
        eventTimer?.invalidate()
        map.removeOverlays(map.overlays)
        map.removeCameras()
        map.removeEvents()
        map.addLMOverlay(LMMode.THAICHOTE)
        map.addLMOverlay(LMMode.POI_TRANSPARENT)
        currentMode = .THAICHOTE
    }
    
    @IBAction func setOpenStreetMap() {
        eventTimer?.invalidate()
        map.removeOverlays(map.overlays)
        map.removeCameras()
        map.removeEvents()
        map.addCustomOverlay(withURL: "https://c.tile.openstreetmap.org/{z}/{x}/{y}.png", andFormat: .WMS, withReferer: "")
        currentMode = .CUSTOM
    }
    
    @IBAction func showShop() {
        map.removeAllTags()
        map.showTags(["shop"])
    }
    
    @IBAction func showBank() {
        map.removeAllTags()
        map.showTags(["bank"])
    }
    
    @IBAction func showHotel() {
        map.removeAllTags()
        map.showTags(["hotel"])
    }
    
    @IBAction func clearTag() {
        map.removeAllTags()
    }
    
    @objc func getEvent() {
        map.removeLMOverlay(LMMode.TRAFFIC)
        map.addLMOverlay(LMMode.TRAFFIC)
    }
    
    //MARK:- Map Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annView = map.mapView(mapView, viewFor: annotation)
        //Developer customize here
        if annotation is LMPinAnnotation {
            let ann = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            ann.pinTintColor = UIColor.purple
            return ann
        }
        //Developer customize here
        return annView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayRenderer = map.mapView(mapView, rendererFor: overlay)
        //Developer customize here
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            circle.lineWidth = 1
            return circle
        }
        //Developer customize here
        return overlayRenderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.isHidden {
            return
        }
        let activePin = MKPointAnnotation()
//        let circle = MKCircle(center: (view.annotation?.coordinate)!, radius: 100000)
//        map.add(circle)
        if view.annotation is LMPinAnnotation {
            let pin = view.annotation as! LMPinAnnotation
            activePin.title = pin.name
            activePin.subtitle = pin.address
            print(pin.poiid)
        }
        else if view.annotation is LMTagAnnotation {
            let pin = view.annotation as! LMTagAnnotation
            activePin.title = pin.name
            print(pin.poiid)
        }
        else if view.annotation is LMEventAnnotation {
            let pin = view.annotation as! LMEventAnnotation
            activePin.title = pin.eventTitle
            print(pin.eventDescription)
        }
        else if view.annotation is LMCameraAnnotation {
            let pin = view.annotation as! LMCameraAnnotation
            activePin.title = pin.cameraTitle
            print(pin.url)
        }
        else {
            return
        }
        activePin.coordinate = (view.annotation?.coordinate)!
        for annotation in map.annotations {
            if annotation is MKPointAnnotation {
                map.removeAnnotation(annotation)
                break
            }
        }
        map.addAnnotation(activePin)
        map.selectAnnotation(activePin, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if mapView.camera.heading >= 90 && mapView.camera.heading < 270 {
            isRevert = true
        }
        else {
            isRevert = false
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        map.mapView(mapView, regionDidChangeAnimated: animated) //in beta!!
        if currentMode == .NORMAL {
            if !isRevert && mapView.camera.heading >= 90 && mapView.camera.heading < 270 {
                map.removeOverlays(map.overlays)
                map.addLMOverlay(LMMode.NORMALR)
                isRevert = true
            }
            else if isRevert && (mapView.camera.heading < 90 || mapView.camera.heading >= 270) {
                map.removeOverlays(map.overlays)
                map.addLMOverlay(LMMode.NORMAL)
                isRevert = false
            }
        }
    }
    //MARK:- Search Delegate
    func searchData(_ poi: [LMPinAnnotation]!) {
        map.addAnnotations(poi)
        loader.stopAnimating()
    }
    
    func suggestData(_ keyword: [String]!) {
        print(keyword)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        map.search(withKeyword: searchBar.text, andCoordinate: map.centerCoordinate)
        loader.startAnimating()
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
            map.suggest(withKeyword: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        for annotation in map.annotations {
            if annotation is LMPinAnnotation {
                map.removeAnnotation(annotation)
            }
        }
    }
}

