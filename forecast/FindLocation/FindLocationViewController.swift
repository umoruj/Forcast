//
//  FindLocationViewController.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import UIKit
import MapKit
import Entities

protocol FindLocationViewControllerOutput: class {
    func viewIsReady()
    func locationSelected(at coordinate: CLLocationCoordinate2D)
}

final class FindLocationViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    private lazy var mapView: MKMapView = MKMapView(frame: .zero)
    
    var output: FindLocationViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(findLocation(_:)))
        mapView.addGestureRecognizer(gesture)
        
        output.viewIsReady()
    }
    
    @objc
    private func findLocation(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        // Convert the tapped point to a CLLocationCoordinate2D
        let locationCoordinate = mapView.convert(point, toCoordinateFrom: mapView)
        output.locationSelected(at: locationCoordinate)
    }
    
     public func showForcastView( jsonData: CurrentWeatherByCoordinates) {
        // show forcast detail page modally
        let weatherView = WeatherForcastViewController()
        weatherView.currentWeatherForcast = jsonData
        weatherView.modalPresentationStyle = .overCurrentContext
        self.present(weatherView, animated: true, completion: nil)
    }
    
    public func showErrorPopUp(message: String) {
        // show action sheet error messag
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension FindLocationViewController: FindLocationPresenterOutput {
    
}
