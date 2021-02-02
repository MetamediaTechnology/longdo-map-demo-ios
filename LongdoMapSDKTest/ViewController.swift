//
//  ViewController.swift
//  LongdoMapSDKTest
//
//  Created by กมลภพ จารุจิตต์ on 22/9/59.
//  Copyright © พ.ศ. 2559 Metamedia Technology. All rights reserved.
//

import UIKit
import LongdoMapSDK

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, LMAQIDataDelegate {
    
    //MARK:- Initial
    let APIKEY = "16a3c9373e8911c2e4736d92431f7113"
    let locationManager = CLLocationManager()
    let customSourceLayer = "https://c.tile.openstreetmap.org/{z}/{x}/{y}.png"
    
    @IBOutlet weak var map: LongdoMapView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var currentMode: LMMode = .NORMAL
    var isRevert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        map.aqiDelegate = self
        map.setKey(APIKEY) //Don't need if use Longdo Box
//        map.boxDomain = URL(string: "https://yourdomain.com")
        map.language = .THAI
        map.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2DMake(13.756674, 100.501853), span: (map.coordinateSpan(withZoomLevel: 7))), animated: false)
        map.add(LMLayer(mode: .BLANK))
        map.add(LMLayer(mode: .NORMAL))
        map.showsUserLocation = true
        map.showsScale = true
        map.showsAQI = true
        map.userTrackingMode = .followWithHeading
        map.userAnnotationType = .LONGDO_PIN
        map.userLocationImage = UIImage(named: "ic_current_location")
        map.userLocationArrow = UIImage(named: "heading")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        map.updateCrosshair()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.map.updateCrosshair()
        })
    }
    
    //MARK:- Action
    @IBAction func zoomIn() {
        map.userTrackingMode = .none
        map.zoomLevel += 1
    }
    
    @IBAction func zoomOut() {
        map.userTrackingMode = .none
        map.zoomLevel -= 1
    }
    
    @IBAction func setNormalMap() {
        removePreviousLayer()
        if map.camera.heading >= 90 && map.camera.heading < 270 {
            map.add(LMLayer(mode: .NORMALR))
            isRevert = true
        }
        else {
            map.add(LMLayer(mode: .NORMAL))
            isRevert = false
        }
        currentMode = .NORMAL
        showMapItem()
//        map.addLMOverlay(LMMode.OFFLINE)
    }
    
    @IBAction func setTrafficMap() {
        removePreviousLayer()
        map.add(LMLayer(mode: .GRAY))
        map.add(LMLayer(mode: .TRAFFIC))
        currentMode = .TRAFFIC
        showMapItem()
    }
    
    @IBAction func setSatelliteMap() {
        removePreviousLayer()
        map.add(LMLayer(mode: .THAICHOTE))
        map.add(LMLayer(mode: .POI_TRANSPARENT))
        currentMode = .THAICHOTE
        showMapItem()
    }
    
    @IBAction func setOpenStreetMap() {
        removePreviousLayer()
        let layer = LMLayer(mode: .CUSTOM)
        layer?.sourceLayer = customSourceLayer
        layer?.tileFormat = .WMS
        map.add(layer)
        currentMode = .CUSTOM
        showMapItem()
    }
    
    @IBAction func showShop() {
        let options = LMTagOptions()
        options.visibleRange = NSRange(location: 10, length: 10)
        options.icon = LMIcon(image: UIImage(named: "icon_shop"))
        options.icon.alpha = 1
        options.icon.offset = CGPoint(x: 0, y: -0.5)
        map.showTags(["shop"], with: options)
    }
    
    @IBAction func showBank() {
        map.showTags(["bank"])
    }
    
    @IBAction func showHotel() {
        map.showTags(["hotel"])
    }
    
    @IBAction func clearTag() {
        map.removeAllTags()
    }
    
    @IBAction func toggleLanguage() {
        if map.language == .THAI {
            map.language = .ENGLISH
        }
        else {
            map.language = .THAI
        }
    }
    
    func removePreviousLayer() {
        switch currentMode {
        case .NORMAL:
            map.removeLMOverlay(.NORMAL)
            map.removeLMOverlay(.NORMALR)
        case .TRAFFIC:
            map.removeLMOverlay(.GRAY)
            map.removeLMOverlay(.TRAFFIC)
            break
        case .THAICHOTE:
            map.removeLMOverlay(.THAICHOTE)
            map.removeLMOverlay(.POI_TRANSPARENT)
            break
        case .CUSTOM:
            map.removeSourceLayer(customSourceLayer)
            break
        default:
            break
        }
    }
    
    func showMapItem() {
        map.showsCameras = currentMode == .TRAFFIC
        map.showsEvents = currentMode == .TRAFFIC
        map.showsAQI = currentMode == .NORMAL
    }
    
    //MARK:- Map Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annView = map.mapView(mapView, viewFor: annotation)
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
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
            lineView.lineWidth = 3
            return lineView
        }
        //Developer customize here
        return overlayRenderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.isHidden {
            return
        }
        map.mapView(mapView, didSelect: view)
        let activePin = MKPointAnnotation()
//        let circle = MKCircle(center: (view.annotation?.coordinate)!, radius: 100000)
//        map.add(circle)
        if view.annotation is LMPinAnnotation {
            let pin = view.annotation as! LMPinAnnotation
            activePin.title = pin.name
            activePin.subtitle = pin.address
            print(pin.poiid ?? "")
            let options = LMRouteOptions()
            options.mode = .MINIMUM_DISTANCE
            options.allowedFerry = false
            options.allowedTollway = false
            var start = map.centerCoordinate
            if map.userLocation.coordinate.latitude != 0 && map.userLocation.coordinate.longitude != 0 {
                start = map.userLocation.coordinate
            }
            map.route(from: start, to: pin.coordinate, with: options, result: {route, error in
                DispatchQueue.main.async {
                    for overlay in self.map.overlays {
                        if overlay is MKPolyline {
                            self.map.removeOverlay(overlay)
                        }
                    }
                    for guide in route?.guide ?? [] {
                        self.map.addOverlay(guide.path)
                    }
                }
            })

        }
        else if view.annotation is LMTagAnnotation {
            let pin = view.annotation as! LMTagAnnotation
            activePin.title = pin.name
            print(pin.poiid ?? "")
        }
        else if view.annotation is LMEventAnnotation {
            let pin = view.annotation as! LMEventAnnotation
            activePin.title = pin.eventTitle
            print(pin.eventDescription ?? "")
        }
        else if view.annotation is LMCameraAnnotation {
            let pin = view.annotation as! LMCameraAnnotation
            activePin.title = pin.cameraTitle
            print(pin.url ?? "")
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
        map.mapView(mapView, regionDidChangeAnimated: animated)
        if currentMode == .NORMAL {
            if !isRevert && mapView.camera.heading >= 90 && mapView.camera.heading < 270 {
                map.removeLMOverlay(.NORMAL)
                map.add(LMLayer(mode: .NORMALR))
                isRevert = true
            }
            else if isRevert && (mapView.camera.heading < 90 || mapView.camera.heading >= 270) {
                map.removeLMOverlay(.NORMALR)
                map.add(LMLayer(mode: .NORMAL))
                isRevert = false
            }
        }
    }
    
    func aqiData(_ data: LMAQIInfo!) {
        print(data ?? "")
    }
    
    //MARK:- Search Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let options = LMSearchOptions()
        options.location = map.centerCoordinate
        options.span = "100km"
        options.limit = 20
        map.searchKeyword(searchBar.text, with: options, result: { poi, error in
            if let pin = poi {
                DispatchQueue.main.async {
                    self.map.addAnnotations(pin)
                    var maxLat = 0.0
                    var maxLon = 0.0
                    for i in pin {
                        if fabs(self.map.centerCoordinate.latitude - i.coordinate.latitude) > maxLat {
                            maxLat = fabs(self.map.centerCoordinate.latitude - i.coordinate.latitude)
                        }
                        if fabs(self.map.centerCoordinate.longitude - i.coordinate.longitude) > maxLon {
                            maxLon = fabs(self.map.centerCoordinate.longitude - i.coordinate.longitude)
                        }
                        self.map.addAnnotation(i)
                    }
                    self.map.userTrackingMode = .none
                    self.map.setRegion(MKCoordinateRegion(center: self.map.centerCoordinate, span: MKCoordinateSpan(latitudeDelta: min(maxLat * 2, 179), longitudeDelta: min(maxLon * 2, 359))), animated: true)
                    self.loader.stopAnimating()
                }
            }
        })

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
            let options = LMSuggestOptions()
            options.limit = 20
            map.suggestKeyword(searchText, with: options, result: { keyword, error in
                print(keyword ?? [])
            })

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

