//
//  CurrentWeatherByCoordinates.swift
//  Entities
//
//  Created by Joseph Umoru on 14/01/2020.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import Foundation

public struct CurrentWeatherByCoordinates: Codable {
    public let coord: Coord?
    public let weather: [Weather]?
    public let base: String?
    public let main: Main?
    public let wind: Wind?
    public let clouds: Clouds?
    public let dt: Int?
    public let sys: Sys?
    public let id: Int?
    public let name: String?
    public let cod: Int?
}

// MARK: - Clouds
public struct Clouds: Codable {
    public let all: Int?
}

// MARK: - Coord
public struct Coord: Codable {
    public let lon, lat: Double?
}

// MARK: - Main
public struct Main: Codable {
    public let temp, pressure: Double?
    public let humidity: Int?
    public let tempMin, tempMax, seaLevel, grndLevel: Double?

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
public struct Sys: Codable {
    public let message: Double?
    public let country: String?
    public let sunrise, sunset: Int?
}

// MARK: - Weather
public struct Weather: Codable {
    public let id: Int?
    public let main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
public struct Wind: Codable {
    public let speed: Double?
    public let deg: Int?
}
