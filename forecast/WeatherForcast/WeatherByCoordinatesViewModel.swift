//
//  WeatherByCoordinatesViewModel.swift
//  forecast
//
//  Created by Umoru Joseph on 14/01/2020.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//
import Entities

public class WeatherByCoordinatesViewModel {
    let weatherData: CurrentWeatherByCoordinates
    
    public init(weatherData: CurrentWeatherByCoordinates) {
      self.weatherData = weatherData
    }
    
    public var address: String {
        var cityName = "region not specified"
        var countryName = "region not specified"
        
        if let currentCity = weatherData.name {
            cityName = currentCity
        }
        
        if let countryCode = weatherData.sys?.country {
            let current = Locale(identifier: "en_US")
            countryName = current.localizedString(forRegionCode: countryCode) ?? "country"
        }
        
        return cityName + " / " + countryName
    }
    
    public var dateTime: String {
        var startDate = "not available"
        if let unnix = weatherData.dt {
            let date = Date(timeIntervalSince1970: TimeInterval(unnix))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "HH:mm dd MMMM " //Specify your format that you want
            startDate = dateFormatter.string(from: date)
        }
        
        return startDate
    }
    
    public var mainTemperature: String {
        var tempDeg = "°C"
        if let tempData = weatherData.main?.temp {
            tempDeg = String(tempData) + "°C"
        }
        return tempDeg
    }
    
    public var weatherIconUrl: String {
        var defaultString = ""
        if let iconFileName = weatherData.weather?.first?.icon {
            defaultString = "https://openweathermap.org/img/wn/" + iconFileName + "@2x.png"
        }
        return defaultString
    }
    
    public var weatherIconFileName: String {
        var defaultString = ""
        if let iconFileName = weatherData.weather?.first?.icon {
            defaultString = iconFileName
        }
        return defaultString
    }
    
    public var weatherDescription: String {
        var defaultString = "_"
        if let weatherDescription = weatherData.weather?.first?.weatherDescription {
            defaultString = weatherDescription
        }
        return defaultString
    }
    
    public var weatherArrayTempFeel: String {
        var defaultValue = "°C"
        if let tempFeel = weatherData.main?.temp {
            defaultValue = String(tempFeel) + "°C"
        }
        return defaultValue
    }
    
    public var weatherArrayTempMax: String {
        var defaultValue = "°C"
        if let tempFeel = weatherData.main?.tempMax {
            defaultValue = String(tempFeel) + "°C"
        }
        return defaultValue
    }
    
    public var weatherArrayTempMin: String {
        var defaultValue = "°C"
        if let tempFeel = weatherData.main?.tempMin {
            defaultValue = String(tempFeel) + "°C"
        }
        return defaultValue
    }
    
    public var weatherArrayWindSpeed: String {
        var defaultValue = "m/s"
        if let tempFeel = weatherData.wind?.speed {
            defaultValue = String(tempFeel) + "m/s"
        }
        return defaultValue
    }
    
    public var weatherArrayAtmosphericPressure: String {
        var defaultValue = "hPa"
        if let tempFeel = weatherData.main?.pressure {
            defaultValue = String(tempFeel) + "hPa"
        }
        return defaultValue
    }
    
    public var weatherArrayAtmosphericHumidity: String {
        var defaultValue = "%"
        if let tempFeel = weatherData.main?.humidity {
            defaultValue = String(tempFeel) + "%"
        }
        return defaultValue
    }
}
