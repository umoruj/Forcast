//
//  WeatherDetailCollectionViewCell.swift
//  forecast
//
//  Created by Joseph Umoru on 14/01/2020.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import UIKit

class WeatherDetailCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let weatherConditionTitleLabel: UILabel = {
        let fnhp = UILabel()
        fnhp.translatesAutoresizingMaskIntoConstraints = false
        fnhp.font = UIFont(name: "OpenSans-SemiBold", size: 11)
        fnhp.textColor = UIColor.white
        fnhp.textAlignment = .left
        return fnhp
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let weatherConditionValueLabel: UILabel = {
        let fnhp = UILabel()
        fnhp.translatesAutoresizingMaskIntoConstraints = false
        fnhp.font = UIFont(name: "OpenSans-SemiBold", size: 11)
        fnhp.textColor = UIColor.white
        fnhp.textAlignment = .right
        return fnhp
    }()
    
    let seperatorView: UIView = {
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor.clear
        return sv
    }()
    
    let spacerView: UIView = {
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor.clear
        return sv
    }()
    
    func setupViews(){
        addSubview(weatherConditionTitleLabel)
        addSubview(thumbnailImageView)
        addSubview(weatherConditionValueLabel)
        addSubview(seperatorView)
        addSubview(spacerView)
        
        addContraintsWithFormat(format: "H:|-5-[v0(100)]-30-[v1(40)]-5-[v2]-5-[v3(80)]-5-|", views: weatherConditionTitleLabel, thumbnailImageView, spacerView, weatherConditionValueLabel)
        addContraintsWithFormat(format: "V:|[v0]-5-[v1(1)]|", views: weatherConditionTitleLabel,seperatorView)
        addContraintsWithFormat(format: "V:|-5-[v0]-5-[v1(1)]|", views: thumbnailImageView,seperatorView)
        addContraintsWithFormat(format: "V:|-5-[v0]-5-[v1(1)]|", views: spacerView,seperatorView)
        addContraintsWithFormat(format: "V:|-5-[v0]-5-[v1(1)]|", views: weatherConditionValueLabel,seperatorView)
        addContraintsWithFormat(format: "H:|[v0]|", views: seperatorView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
