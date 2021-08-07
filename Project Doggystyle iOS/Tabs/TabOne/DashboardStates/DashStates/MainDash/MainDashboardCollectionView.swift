//
//  MainDashboardCollectionView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/1/21.
//


import Foundation
import UIKit

class MainDashboardCollectionView : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let mainCollectionID = "mainCollectionID"
    
    var dashMainView : DashMainView?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = true
        self.alwaysBounceHorizontal = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
        
        self.register(MainCollectionFeeder.self, forCellWithReuseIdentifier: self.mainCollectionID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 173)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.mainCollectionID, for: indexPath) as! MainCollectionFeeder
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MainCollectionFeeder : UICollectionViewCell {
    
    let container : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 20
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cv.layer.shadowOpacity = 0.05
        cv.layer.shadowOffset = CGSize(width: 2, height: 3)
        cv.layer.shadowRadius = 9
        cv.layer.shouldRasterize = false
        
       return cv
    }()
    
    let dogOneImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = false
        vi.backgroundColor = coreOrangeColor.withAlphaComponent(0.1)
        vi.layer.masksToBounds = true

       return vi
    }()
    
    let dogTwoImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = false
        vi.backgroundColor = coreOrangeColor.withAlphaComponent(0.1)
        vi.layer.masksToBounds = true
        
       return vi
    }()
    
    let dateLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Tue, Dec 3 2021"
        hl.font = UIFont(name: dsSubHeaderFont, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreBlackColor

        return hl
    }()
    
    let timeLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "12:30 PM"
        hl.font = UIFont(name: dsSubHeaderFont, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .right
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let recurringLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Recurring - 8 weeks"
        hl.font = UIFont(name: rubikRegular, size: 16)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = dividerGrey

        return hl
    }()
    
    lazy var editButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
      
        return cbf
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.container)
        self.addSubview(self.dogOneImage)
        self.addSubview(self.dogTwoImage)
        
        self.addSubview(self.dateLabel)
        self.addSubview(self.timeLabel)
        self.addSubview(self.recurringLabel)
        
        self.addSubview(self.editButton)


        self.container.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.dogOneImage.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 21).isActive = true
        self.dogOneImage.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 28).isActive = true
        self.dogOneImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.dogOneImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.dogOneImage.layer.cornerRadius = 25
        
        self.dogTwoImage.centerYAnchor.constraint(equalTo: self.dogOneImage.centerYAnchor).isActive = true
        self.dogTwoImage.leftAnchor.constraint(equalTo: self.dogOneImage.rightAnchor, constant: 20).isActive = true
        self.dogTwoImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.dogTwoImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.dogTwoImage.layer.cornerRadius = 25
        
        self.editButton.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -25).isActive = true
        self.editButton.centerYAnchor.constraint(equalTo: self.dogTwoImage.centerYAnchor, constant: 0).isActive = true
        self.editButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.editButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.dateLabel.topAnchor.constraint(equalTo: self.dogOneImage.bottomAnchor, constant: 16).isActive = true
        self.dateLabel.leftAnchor.constraint(equalTo: self.dogOneImage.leftAnchor, constant: 0).isActive = true
        self.dateLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5).isActive = true
        self.dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.timeLabel.topAnchor.constraint(equalTo: self.dogOneImage.bottomAnchor, constant: 16).isActive = true
        self.timeLabel.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -30).isActive = true
        self.timeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5).isActive = true
        self.timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.recurringLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 5).isActive = true
        self.recurringLabel.leftAnchor.constraint(equalTo: self.dogOneImage.leftAnchor, constant: 0).isActive = true
        self.recurringLabel.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -10).isActive = true
        self.recurringLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
