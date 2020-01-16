
//
//  FindLocationRouter.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import MapKit
import API
import Entities

final class FindLocationRouter {
    let api: ForecastClient
    let viewController: FindLocationViewController
    
    init(api apiClient: ForecastClient, viewController: FindLocationViewController) {
        self.api = apiClient
        self.viewController = viewController
    }
}

extension FindLocationRouter: FindLocationInteractorAction {
    func locationSelected(at coordinate: CLLocationCoordinate2D) {
        let latitude = coordinate.latitude.description
        let longitude = coordinate.longitude.description
        
        //api request to get weather data
        api.perform(CurrentWeatherByCoordinates.getCurrent(lat: latitude, lon: longitude)) { (result) in
            
            // check for error upon gettin response
            if let error = result.error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.viewController.showErrorPopUp(message: "An error occurred please try again later")
                }
                return
            }
            
            // check for empty or uninitialized CurrentWeatherByCoordinates object upon gettin response
            if let jsonData = result.value {
                // make call to protocol
                DispatchQueue.main.async {
                    self.viewController.showForcastView(jsonData: jsonData)
                }
            } else {
                // make call to failure
                DispatchQueue.main.async {
                    self.viewController.showErrorPopUp(message: "Failed to return data from API request")
                }
            }
        }

    }
}
