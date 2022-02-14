//
//  ViewController.swift
//  Longdo Map Test
//
//  Created by กมลภพ จารุจิตต์ on 3/12/2564 BE.
//

import UIKit
import LongdoMapFramework
import CoreLocation

class ViewController: UIViewController, LongdoDelegate {
    @IBOutlet weak var map: LongdoMap!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    let loc = [ "lon": 100.5, "lat": 13.7 ]
    var home: LongdoMap.LDObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        map.apiKey = "09eb29d30683b77b24ce7d26d96f70a1"
        map.options.layer = map.ldstatic("Layers", with: "NORMAL")
        map.options.location = CLLocationCoordinate2D(latitude: 15, longitude: 102)
        map.options.zoomRange = 7...18
        map.options.zoom = 10
        map.render()
        home = map.ldobject("Marker", with: [loc, ["detail": "Home"]])
    }
    
    @IBAction func setLocationClick() {
        map.location(CLLocationCoordinate2DMake(Double(latitudeTextField.text ?? "0") ?? 0, Double(longitudeTextField.text ?? "0") ?? 0))
    }
    
    @IBAction func getLocationClick() {
        if let location = map.location() {
            latitudeTextField.text = String(format: "%.6f", location.latitude)
            longitudeTextField.text = String(format: "%.6f", location.longitude)
        }
    }
    
    @IBAction func onPressTest1() {
        if let arg = home {
            let _ = map.call(method: "Overlays.add", args: [arg])
            let _ = map.objectCall(ldobject: arg, method: "pop", args: [true])
        }
        let _ = map.call(method: "location", args: [loc])
    }
    
    @IBAction func onPressTest2() {
        let zoom = map.call(method: "zoom", args: nil) as? Int
        if let location = map.call(method: "location", args: nil) as? Dictionary<String, NSNumber> {
            print("lon: \(location["lon"] ?? 0.0), lat: \(location["lat"] ?? 0.0), zoom: \(zoom ?? 0)")
        }
    }
    
    func recieve(on event: LongdoBind, with data: Any?) {
        if event == .ready {
            let _ = map.call(method: "Overlays.load", args: [map.ldobject("OverlaysObject", with: ["A00146852", "LONGDO"])])
        }
        else if event == .overlayClick {
            if data as? LongdoMap.LDObject == home {
                print("At Home")
            }
            let result = map.call(method: "Overlays.list", args: nil)
            print(result ?? "")
        }
    }
}

