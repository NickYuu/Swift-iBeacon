//
//  ViewController.swift
//  HelloMyIBeacon
//
//  Created by YU on 2016/12/14.
//  Copyright © 2016年 YU. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var iBeacon1: UILabel!
    @IBOutlet weak var iBeacon2: UILabel!
    @IBOutlet weak var iBeacon3: UILabel!
    
    let locationManager = CLLocationManager()
    var beaconRegion1: CLBeaconRegion!
    var beaconRegion2: CLBeaconRegion!
    var beaconRegion3: CLBeaconRegion!
    
    @IBAction func detectEnableValueChanged(_ sender: UISwitch) {
        
        sender.isOn ? star() : stop()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        setupBeaconRegion()
        
    }
    
}


// MARK:- iBeacon
extension ViewController {
    
    fileprivate func star() {
        for region in [beaconRegion1, beaconRegion2, beaconRegion3] {
            locationManager.startMonitoring(for: region!)
        }
    }
    
    fileprivate func stop() {
        for region in [beaconRegion1, beaconRegion2, beaconRegion3] {
            locationManager.stopMonitoring(for: region!)
            locationManager.stopRangingBeacons(in: region!)
        }
    }
    
    fileprivate func setupBeaconRegion() {
        
        guard
            let beacon1UUID = UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935"),
            let beacon2UUID = UUID(uuidString: "88878BDA-8864-6520-FF88-722EAA059938"),
            let beacon3UUID = UUID(uuidString: "64278BDA-B644-4520-8F0C-720EAF059935")
            else { return }
        
        beaconRegion1 = CLBeaconRegion(proximityUUID: beacon1UUID, identifier: "beacon1")
        beaconRegion1?.notifyOnEntry = true
        beaconRegion1?.notifyOnExit = true
        
        beaconRegion2 = CLBeaconRegion(proximityUUID: beacon2UUID, identifier: "beacon2")
        beaconRegion2?.notifyOnEntry = true
        beaconRegion2?.notifyOnExit = true
        
        beaconRegion3 = CLBeaconRegion(proximityUUID: beacon3UUID, identifier: "beacon3")
        beaconRegion3?.notifyOnEntry = true
        beaconRegion3?.notifyOnExit = true
    }
    
}

// MARK:- CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
        locationManager.requestState(for: region)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        let isInside = state == .inside
        let insideMsg = "User is inside the region\(region.identifier)"
        let outsideMsg = "User is outside the region\(region.identifier)"
        let msg = isInside ? insideMsg : outsideMsg
        
        if isInside {
            locationManager.startRangingBeacons(in: region as! CLBeaconRegion)
        } else {
            locationManager.stopRangingBeacons(in: region as! CLBeaconRegion)
        }
        
        showLocalNotification(msg)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        _ = beacons.map {
            var proximityStr = ""
            switch $0.proximity {
            case .unknown:
                proximityStr = "Unknown"
            case .far:
                proximityStr = "Far"
            case .near:
                proximityStr = "Near"
            case .immediate:
                proximityStr = "Immediate"
                
            }
            let info = "\(region.identifier), RSSI: \($0.rssi),\(proximityStr),\(Float($0.accuracy))"
            
            switch region.identifier{
            case beaconRegion1.identifier:
                iBeacon1.text = info
            case beaconRegion2.identifier:
                iBeacon2.text = info
            case beaconRegion3.identifier:
                iBeacon3.text = info
            default:break
            }
        }
    }
    
}

// MARK:- LocalNotification
extension ViewController {
    
    fileprivate func showLocalNotification(_ message:String) {
        let noti = UILocalNotification()
        noti.fireDate = Date(timeIntervalSinceNow: 1.0)
        noti.alertBody = message
        UIApplication.shared.scheduleLocalNotification(noti)
    }
    
}


