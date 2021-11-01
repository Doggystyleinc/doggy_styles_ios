//
//  YourReferralContainer.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/22/21.
//


import Foundation
import UIKit

class YourReferralCollectionView : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let yourReferralID = "yourReferralID"
    private let footerID = "footerID"

    var yourReferralContainer : YourReferralContainer?
    
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
        self.alpha = 0
        
        self.register(YourReferralFeeder.self, forCellWithReuseIdentifier: self.yourReferralID)
        self.register(ReferralPendingInvitesFeeder.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.footerID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 87)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerID, for: indexPath) as! ReferralPendingInvitesFeeder
            return footerView
        
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.yourReferralContainer?.pendingUsersMonetaryValueModel.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 87)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.yourReferralID, for: indexPath) as! YourReferralFeeder
        
        cell.yourReferralCollectionView = self
        cell.contentView.isUserInteractionEnabled = false
        
        if let model = self.yourReferralContainer?.pendingUsersMonetaryValueModel {

            if model.count > 0 {

            let feeder = model[indexPath.item]
            let recipient_family_name = feeder.recipient_family_name ?? "Private"
            let recipient_given_name = feeder.recipient_given_name ?? ""
            let timeStamp = feeder.time_stamp ?? 0.0
            
            cell.fireTimerCounter(passedTimeStamp: timeStamp)
            cell.nameLabel.text = "\(recipient_given_name) \(recipient_family_name)"

        }
            
        }
        
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

class YourReferralFeeder : UICollectionViewCell {
    
    var timer : Timer?
    
    var yourReferralCollectionView : YourReferralCollectionView?
    
    var containerView : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.isUserInteractionEnabled = false
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cv.layer.shadowOpacity = 0.1
        cv.layer.shadowOffset = CGSize(width: 2, height: 3)
        cv.layer.shadowRadius = 8
        cv.layer.shouldRasterize = false
        cv.layer.cornerRadius = 15
        
       return cv
    }()
    
    let nameLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Charlie Arcodia"
        thl.font = UIFont(name: rubikBold, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    let costLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .right
        thl.text = "+ $5.00"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    
    func addViews() {
        
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.nameLabel)
        self.containerView.addSubview(self.costLabel)

        self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.costLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24).isActive = true
        self.costLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 0).isActive = true
        self.costLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.costLabel.sizeToFit()
        
        self.nameLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.costLabel.leftAnchor, constant: -20).isActive = true
        self.nameLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 0).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func fireTimerCounter(passedTimeStamp : Double) {
            
            let passedDate = Date(timeIntervalSince1970: passedTimeStamp)
            let diffComponents = Calendar.current.dateComponents([.day], from: Date(), to: passedDate)

            if let hours = diffComponents.day {
                
                let safeHours = abs(hours)
                
                if safeHours > 1 {
                    
                    self.containerView.backgroundColor = coreBackgroundWhite
                    self.costLabel.text = "Expired"
                    self.nameLabel.textColor = coreBlackColor.withAlphaComponent(0.5)
                    self.costLabel.textColor = coreBlackColor.withAlphaComponent(0.5)

                } else {
                    
                    self.containerView.backgroundColor = coreWhiteColor
                    self.costLabel.text = "+ $5.00"
                    self.nameLabel.textColor = coreBlackColor
                    self.costLabel.textColor = coreBlackColor
                    
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReferralPendingInvitesFeeder : UICollectionViewCell {
    
    var containerView : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.isUserInteractionEnabled = false
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cv.layer.shadowOpacity = 0.1
        cv.layer.shadowOffset = CGSize(width: 2, height: 3)
        cv.layer.shadowRadius = 8
        cv.layer.shouldRasterize = false
        cv.layer.cornerRadius = 15
        
       return cv
    }()
    
    let descriptionLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Referrals expire after 30 days"
        thl.font = UIFont(name: rubikRegular, size: 12)
        thl.numberOfLines = 2
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = dsFlatBlack.withAlphaComponent(0.5)
        return thl
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.containerView)
        self.addSubview(self.descriptionLabel)

        self.containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5).isActive = true
        self.containerView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 30).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -30).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
