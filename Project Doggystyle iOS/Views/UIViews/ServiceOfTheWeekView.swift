//
//  ServiceOfTheWeekView.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/16/21.
//

import UIKit

class ServiceOfTheWeekView: UIView {
    var package: Package!
    
    private let container: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let image = UIImage(named: "DS Image Placeholder 01")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: Constants.weeklyServiceIcon)
        imageView.height(20)
        imageView.width(20)
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.poppinsBold(size: 18)
        label.textColor = .dsTextColor
        label.text = package.name
        return label
    }()
    
    private lazy var briefDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.poppinsRegular(size: 15)
        label.textColor = .dsTextColor
        label.text = package.briefDescription
        label.numberOfLines = 0
        return label
    }()
    
    init(package: Package) {
        super.init(frame: .zero)
        self.clipsToBounds = true
        self.package = package
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(container)
        container.edgesToSuperview()
        
        self.container.addSubview(backgroundImage)
        backgroundImage.edgesToSuperview()
        
        self.container.addSubview(iconImageView)
        iconImageView.top(to: self, offset: 26)
        iconImageView.left(to: self, offset: 26)
        
        self.container.addSubview(title)
        title.leftToRight(of: iconImageView, offset: 10)
        title.centerY(to: iconImageView)
        
        self.container.addSubview(briefDescription)
        briefDescription.topToBottom(of: iconImageView, offset: 12)
        briefDescription.left(to: iconImageView)
        briefDescription.right(to: self, offset: -25)
    }
}
