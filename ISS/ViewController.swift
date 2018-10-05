//
//  ViewController.swift
//  ISS
//
//  Created by Michael Lema on 10/5/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    let annotationReuseId = "issID"
    var timer = Timer()
    let annotation = MKPointAnnotation()
    
    lazy var mapView: MKMapView = {
        let mV = MKMapView()
        return mV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        getISSLocation()
        mapView.addAnnotation(annotation)
        
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        scheduleTimer()
    }
    
    //MARK: GET Data
    @objc func getISSLocation() {
        guard let url = URL(string: "http://api.open-notify.org/iss-now.json?callback=") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                
                let decoder = JSONDecoder()
                let iss = try decoder.decode(Iss.self, from: data)
                let latitude = Double(iss.issPosition.latitude) ?? 0
                let longitude = Double(iss.issPosition.longitude) ?? 0
                print(latitude, longitude)
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                DispatchQueue.main.async {
                    self.centerMapOnLocation(location: location)
                }
                
            } catch let error as NSError {
                print("error \(error.localizedDescription)")
            }
            }.resume()
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
        mapView.setRegion(coordinateRegion, animated: true)
        annotation.coordinate = location
    }
    
    func scheduleTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(getISSLocation), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }


}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "ISS")
        annotationView?.backgroundColor = .clear
        annotationView?.canShowCallout = false
        return annotationView
    }
}
