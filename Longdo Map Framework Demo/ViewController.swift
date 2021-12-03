//
//  ViewController.swift
//  Longdo Map Test
//
//  Created by กมลภพ จารุจิตต์ on 3/12/2564 BE.
//

import UIKit
import LongdoMapFramework
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var map: LongdoMap!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
}

