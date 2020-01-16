//
//  WeatherForcastViewController.swift
//  forecast
//
//  Created by Joseph Umoru on 14/01/2020.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import UIKit
import Entities
import Client
import AVFoundation
import AVKit

class WeatherForcastViewController: UIViewController {
    var currentWeatherForcast: CurrentWeatherByCoordinates?
    var weatherDetailArray = [WeatherDetails]()
    
    public weak var videoPlayer: AVQueuePlayer?
    public weak var videoPlayerLayer: AVPlayerLayer?
    var playerLooper: NSObject?
    var queuePlayer: AVQueuePlayer?
    
    lazy var firstContainerView: UIView = {
        let firstview = UIView()
        firstview.translatesAutoresizingMaskIntoConstraints = false
        firstview.backgroundColor = UIColor.black
        firstview.layer.masksToBounds = false
        firstview.layer.cornerRadius =  5
        firstview.layer.shadowOpacity = 0.5
        firstview.layer.shadowRadius = 3.0
        firstview.layer.shadowColor = UIColor.black.cgColor
        firstview.layer.shadowRadius = 5
        return firstview
    }()
    
    lazy var closeViewButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "closeIcon")
        imageView.setImageColor(color: UIColor.white)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exitThisView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let currentLocationAddressLabel: UILabel = {
        let fnhp = UILabel()
        fnhp.translatesAutoresizingMaskIntoConstraints = false
        fnhp.font = UIFont(name: "OpenSans-Bold", size: 15)
        fnhp.textColor = UIColor.white
        fnhp.textAlignment = .center
        return fnhp
    }()
    
    let currentLocationDateTimeLabel: UILabel = {
        let fnhp = UILabel()
        fnhp.translatesAutoresizingMaskIntoConstraints = false
        fnhp.font = UIFont(name: "OpenSans-SemiBold", size: 11)
        fnhp.textColor = UIColor.white
        fnhp.textAlignment = .center
        return fnhp
    }()
    
    lazy var videoPlayerContainerView: UIView = {
        let secondview = UIView()
        secondview.translatesAutoresizingMaskIntoConstraints = false
        secondview.backgroundColor = UIColor.clear
        return secondview
    }()
    
    let currentLocationWeatherTemperatureLabel: UILabel = {
        let fnhp = UILabel()
        fnhp.translatesAutoresizingMaskIntoConstraints = false
        fnhp.font = UIFont(name: "OpenSans-SemiBold", size: 30)
        fnhp.textColor = UIColor.white
        fnhp.textAlignment = .left
        return fnhp
    }()
    
    let currentLocationWeatherDescriptionLabel: UILabel = {
        let fnhp = UILabel()
        fnhp.translatesAutoresizingMaskIntoConstraints = false
        fnhp.font = UIFont(name: "OpenSans-SemiBold", size: 15)
        fnhp.textColor = UIColor.white
        fnhp.textAlignment = .left
        return fnhp
    }()
    
    
    lazy var currentLocationWeatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let collectView: UIView = {
        let cview = UIView()
        cview.translatesAutoresizingMaskIntoConstraints = false
        cview.backgroundColor = UIColor.clear
        return cview
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        cv.register(WeatherDetailCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.addSubview(firstContainerView)
        collectionView.dataSource = self
        collectionView.delegate = self
        setupUIElements()
    }
    
    
    private func setupUIElements(){
        // position UI elements with contraints
        var topDistance: CGFloat = 20
        if UIDevice.current.hasNotch {
            topDistance = 60
        }
        
        firstContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: topDistance).isActive = true
        firstContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        firstContainerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        firstContainerView.addSubview(videoPlayerContainerView)
        firstContainerView.addSubview(closeViewButton)
        firstContainerView.addSubview(currentLocationAddressLabel)
        firstContainerView.addSubview(currentLocationDateTimeLabel)
        firstContainerView.addSubview(currentLocationWeatherTemperatureLabel)
        firstContainerView.addSubview(currentLocationWeatherDescriptionLabel)
        firstContainerView.addSubview(currentLocationWeatherIcon)
        firstContainerView.addSubview(collectView)
        
        
        videoPlayerContainerView.topAnchor.constraint(equalTo: firstContainerView.topAnchor, constant: 50).isActive = true
        videoPlayerContainerView.centerXAnchor.constraint(equalTo: firstContainerView.centerXAnchor).isActive = true
        videoPlayerContainerView.widthAnchor.constraint(equalTo: firstContainerView.widthAnchor, constant: -10).isActive = true
        videoPlayerContainerView.heightAnchor.constraint(equalTo: firstContainerView.heightAnchor, multiplier: 0.4).isActive = true
        
        closeViewButton.topAnchor.constraint(equalTo: firstContainerView.topAnchor, constant: 10).isActive = true
        closeViewButton.rightAnchor.constraint(equalTo: firstContainerView.rightAnchor, constant: -5).isActive = true
        closeViewButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        closeViewButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        currentLocationAddressLabel.topAnchor.constraint(equalTo: closeViewButton.bottomAnchor, constant: 2).isActive = true
        currentLocationAddressLabel.centerXAnchor.constraint(equalTo: firstContainerView.centerXAnchor).isActive = true
        currentLocationAddressLabel.widthAnchor.constraint(equalTo: firstContainerView.widthAnchor, constant: -10).isActive = true
        currentLocationAddressLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentLocationDateTimeLabel.topAnchor.constraint(equalTo: currentLocationAddressLabel.bottomAnchor, constant: 2).isActive = true
        currentLocationDateTimeLabel.centerXAnchor.constraint(equalTo: firstContainerView.centerXAnchor).isActive = true
        currentLocationDateTimeLabel.widthAnchor.constraint(equalTo: firstContainerView.widthAnchor, constant: -10).isActive = true
        currentLocationDateTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        currentLocationWeatherTemperatureLabel.topAnchor.constraint(equalTo: currentLocationDateTimeLabel.bottomAnchor, constant: 20).isActive = true
        currentLocationWeatherTemperatureLabel.leftAnchor.constraint(equalTo: firstContainerView.leftAnchor, constant: 5).isActive = true
        currentLocationWeatherTemperatureLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        currentLocationWeatherTemperatureLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        currentLocationWeatherIcon.topAnchor.constraint(equalTo: currentLocationDateTimeLabel.bottomAnchor, constant: 20).isActive = true
        currentLocationWeatherIcon.rightAnchor.constraint(equalTo: firstContainerView.rightAnchor, constant: -5).isActive = true
        currentLocationWeatherIcon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        currentLocationWeatherIcon.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        currentLocationWeatherDescriptionLabel.topAnchor.constraint(equalTo: currentLocationWeatherTemperatureLabel.bottomAnchor, constant: 2).isActive = true
        currentLocationWeatherDescriptionLabel.rightAnchor.constraint(equalTo: firstContainerView.rightAnchor, constant: 5).isActive = true
        currentLocationWeatherDescriptionLabel.widthAnchor.constraint(equalTo: firstContainerView.widthAnchor, multiplier: 1).isActive = true
        currentLocationWeatherDescriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectView.topAnchor.constraint(equalTo: currentLocationWeatherDescriptionLabel.bottomAnchor, constant: 15).isActive = true
        collectView.centerXAnchor.constraint(equalTo: firstContainerView.centerXAnchor).isActive = true
        collectView.widthAnchor.constraint(equalTo: firstContainerView.widthAnchor, multiplier: 1, constant: -24).isActive = true
        collectView.bottomAnchor.constraint(equalTo: firstContainerView.bottomAnchor, constant: -5).isActive = true
        
        collectView.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: collectView.topAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: collectView.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: collectView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: collectView.heightAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.intitializeView()
        self.setGradientBackground()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.videoPlayer?.replaceCurrentItem(with: nil)
    }
    
    private func intitializeView(){
        // intialize UI elements with values from view model
        if let jsonData = self.currentWeatherForcast {
            let weatherViewModel = WeatherByCoordinatesViewModel(weatherData: jsonData)
            let fileName = self.playVideoBasedFileName(fileName: weatherViewModel.weatherIconFileName)
            self.initializeVideoPlayerWithVideo(fileName: fileName, fileType: "mov")
            self.currentLocationAddressLabel.text = weatherViewModel.address
            self.currentLocationDateTimeLabel.text = weatherViewModel.dateTime
            self.currentLocationWeatherTemperatureLabel.text = weatherViewModel.mainTemperature
            self.currentLocationWeatherIcon.loadImagesUsingCacheWithUrlString(urlString: weatherViewModel.weatherIconUrl)
            self.currentLocationWeatherDescriptionLabel.text = weatherViewModel.weatherDescription
            
            let tempFeelsValue = WeatherDetails()
            tempFeelsValue.weatherIcon = UIImage(named: "temperaturesensitive")
            tempFeelsValue.weatherTitle = "Temp feels"
            tempFeelsValue.weatherValue = weatherViewModel.weatherArrayTempFeel
            
            let tempMaxValue = WeatherDetails()
            tempMaxValue.weatherIcon = UIImage(named: "thermometerup")
            tempMaxValue.weatherTitle = "Temp Max"
            tempMaxValue.weatherValue = weatherViewModel.weatherArrayTempMax
            
            let tempMinValue = WeatherDetails()
            tempMinValue.weatherIcon = UIImage(named: "thermometerdown")
            tempMinValue.weatherTitle = "Temp Min"
            tempMinValue.weatherValue = weatherViewModel.weatherArrayTempMin
            
            let windSpeedValue = WeatherDetails()
            windSpeedValue.weatherIcon = UIImage(named: "windsock")
            windSpeedValue.weatherTitle = "Wind speed"
            windSpeedValue.weatherValue = weatherViewModel.weatherArrayWindSpeed
            
            let pressureValue = WeatherDetails()
            pressureValue.weatherIcon = UIImage(named: "atmosphericpressure")
            pressureValue.weatherTitle = "Pressure"
            pressureValue.weatherValue = weatherViewModel.weatherArrayAtmosphericPressure
            
            let humidityValue = WeatherDetails()
            humidityValue.weatherIcon = UIImage(named: "hygrometer")
            humidityValue.weatherTitle = "Humidity"
            humidityValue.weatherValue = weatherViewModel.weatherArrayAtmosphericHumidity
            
            weatherDetailArray.append(tempFeelsValue)
            weatherDetailArray.append(tempMaxValue)
            weatherDetailArray.append(tempMinValue)
            weatherDetailArray.append(windSpeedValue)
            weatherDetailArray.append(pressureValue)
            weatherDetailArray.append(humidityValue)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    
    func playVideoBasedFileName(fileName: String) -> String {
        // get video file based on weather condition
        switch fileName {
        case "01d":
            return "SUN"
        case "01n":
            return "MOON"
        case "02d":
            return "SUN_CLOUD_LIGHT"
        case "02n":
            return "MOON_CLOUD_LIGHT"
        case "03d":
            return "CLOUD"
        case "03n":
            return "CLOUD"
        case "04d":
            return "CLOUD"
        case "04n":
            return "CLOUD"
        case "09d":
            return "RAIN"
        case "09n":
            return "RAIN"
        case "10d":
            return "SUN_RAIN"
        case "10n":
            return "MOON_RAIN"
        case "11d":
            return "STORM"
        case "11n":
            return "STORM"
        case "13d":
            return "SNOW"
        case "13n":
            return "SNOW"
        case "50d":
            return "CLOUD"
        case "50n":
            return "CLOUD"
        default:
            return "CLOUD"
        }
    }
    
    func initializeVideoPlayerWithVideo(fileName: String, fileType: String) {
        // play video files
        let videoString:String? = Bundle.main.path(forResource: fileName, ofType: fileType)
        guard let unwrappedVideoPath = videoString else {return}
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        let playerItem = AVPlayerItem(url: videoUrl as URL)
        videoPlayer = AVQueuePlayer(items: [playerItem])
        playerLooper = AVPlayerLooper(player: videoPlayer!, templateItem: playerItem)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayerLayer!.frame = CGRect(x: 0, y: 0, width: videoPlayerContainerView.bounds.width, height: videoPlayerContainerView.bounds.height)
        videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPlayerContainerView.layer.addSublayer(videoPlayerLayer!)
        videoPlayer?.isMuted = true
        videoPlayer?.play()
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.frame = self.firstContainerView.bounds
        gradientLayer.cornerRadius = 5

        self.firstContainerView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @objc private func exitThisView(){
        self.dismiss(animated: true) {
            self.videoPlayer?.removeAllItems()
        }
    }

}

extension WeatherForcastViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDetailArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! WeatherDetailCollectionViewCell
        cell.weatherConditionTitleLabel.text = self.weatherDetailArray[indexPath.row].weatherTitle
        cell.thumbnailImageView.image = self.weatherDetailArray[indexPath.row].weatherIcon
        cell.weatherConditionValueLabel.text = self.weatherDetailArray[indexPath.row].weatherValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectView.frame.width, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
