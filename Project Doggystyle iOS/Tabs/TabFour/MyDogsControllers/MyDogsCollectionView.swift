//
//  MyDogsCollectionView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/13/21.
//

import Foundation
import UIKit

class MyDogsCollectionView : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let addDogsCollecctionID = "addDogsCollecctionID"
    
    var myDogsCollectionContainer : MyDogsCollectionContainer?
    
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
        
        self.register(MyDogsCollectionFeeder.self, forCellWithReuseIdentifier: self.addDogsCollecctionID)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 157)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.addDogsCollecctionID, for: indexPath) as! MyDogsCollectionFeeder
        
        cell.myDogsCollectionView = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func handleEditButton(sender : UIButton) {
        
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        
        print(indexPath)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyDogsCollectionFeeder : UICollectionViewCell {
    
    var myDogsCollectionView : MyDogsCollectionView?
    
    let containerView : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.isUserInteractionEnabled = true
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cv.layer.shadowOpacity = 0.05
        cv.layer.shadowOffset = CGSize(width: 2, height: 3)
        cv.layer.shadowRadius = 9
        cv.layer.shouldRasterize = false
        cv.layer.cornerRadius = 15
        
      return cv
    }()
    
    let profileImageView : UIImageView = {
        
        let pv = UIImageView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = coreLightGrayColor
        pv.contentMode = .scaleAspectFill
        pv.isUserInteractionEnabled = true
        pv.layer.masksToBounds = true
        pv.clipsToBounds = true
        return pv
    }()
    
    let dogNameLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Rex"
        nl.font = UIFont(name: dsSubHeaderFont, size: 20)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = 1
        
        return nl
    }()
    
    let breedLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Golden Retriever"
        nl.font = UIFont(name: rubikRegular, size: 13)
        nl.textColor = coreOrangeColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = 1
        
        return nl
    }()
    
    lazy var pencilIcon : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        cbf.setTitleColor(coreOrangeColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleEditProfilePencil(sender:)), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.containerView)
        self.addSubview(self.profileImageView)
        self.addSubview(self.dogNameLabel)
        self.addSubview(self.breedLabel)
        self.addSubview(self.pencilIcon)

        self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.profileImageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 0).isActive = true
        self.profileImageView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 17).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 105).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 105).isActive = true
        self.profileImageView.layer.cornerRadius = 105/2
        
        self.dogNameLabel.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor, constant: -12).isActive = true
        self.dogNameLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 20).isActive = true
        self.dogNameLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -30).isActive = true
        self.dogNameLabel.sizeToFit()
        
        self.breedLabel.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor, constant: 12).isActive = true
        self.breedLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 20).isActive = true
        self.breedLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -30).isActive = true
        self.breedLabel.sizeToFit()
        
        self.pencilIcon.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 18).isActive = true
        self.pencilIcon.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -18).isActive = true
        self.pencilIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pencilIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    @objc func handleEditProfilePencil(sender : UIButton) {
        
        self.myDogsCollectionView?.handleEditButton(sender : sender)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
