//
//  WeatherByCoordinates.swift
//  API
//
//  Created by Joseph Umoru on 14/01/2020.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
// api.openweathermap.org/data/2.5/weather

import Entities
import Client
// api.openweathermap.org/data/2.5/weather
extension CurrentWeatherByCoordinates {
    public static func getCurrent(lat: String, lon: String) -> Request<CurrentWeatherByCoordinates, APIError> {
        return Request(
            url: URL(string: "weather")!,
            method: .get,
            parameters: [QueryParameters([URLQueryItem(name: "lat", value: lat), URLQueryItem(name: "lon", value: lon)])],
            resource: decodeResource(CurrentWeatherByCoordinates.self),
            error: APIError.init,
            needsAuthorization: true
        )
    }
}
