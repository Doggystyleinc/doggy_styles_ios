//
//  AppointmentThreeCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/23/21.
//

import Foundation
import UIKit



enum AppointmentThreeable : String, CaseIterable {
    
    case ValetPickupAndDropOff
    case OwnerDropOffAndPickUp
    case ValetPickupOwnerDropOff
    case OwnerDropOffValetDropOff
    
    var value : String {
        
        switch self {
        
        case .ValetPickupAndDropOff : return "Valet pick up and drop off"
        case .OwnerDropOffAndPickUp : return "Owner drop off and pick up"
        case .ValetPickupOwnerDropOff : return "Valet pick up, Owner pick up"
        case .OwnerDropOffValetDropOff : return "Owner drop off, Valet drop off"
        
        }
    }
}

class AppointmentThreeCollectionview : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let appointmentThreeCollectionID = "appointmentThreeCollectionID"
    
    var appointmentThree : AppointmentThree?
    
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
        
        self.register(AppointmentThreeFeeder.self, forCellWithReuseIdentifier: self.appointmentThreeCollectionID)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return AppointmentThreeable.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.appointmentThreeCollectionID, for: indexPath) as! AppointmentThreeFeeder
        
        cell.appointmentThreeCollectionview = self
        
        let feeder = AppointmentThreeable.allCases[indexPath.item].value
        
        cell.selectionDescription.text = feeder
        
        if self.indexpathArray.contains(indexPath) {
            
            cell.circleView.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
            cell.circleView.setTitle(String.fontAwesomeIcon(name: .checkCircle), for: .normal)
            cell.circleView.setTitleColor(coreOrangeColor, for: .normal)
            cell.selectionContainerOne.layer.shadowRadius = 4
            cell.selectionContainerOne.layer.borderColor = coreOrangeColor.cgColor
            
        } else {
            
            cell.circleView.setTitle("", for: .normal)
            cell.circleView.setTitleColor(.clear, for: .normal)
            cell.circleView.backgroundColor = coreWhiteColor
            cell.selectionContainerOne.layer.shadowRadius = 0
            cell.selectionContainerOne.layer.borderColor = UIColor .clear.cgColor

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    var indexpathArray : [IndexPath] = [IndexPath]()
    
    @objc func handleSelection(sender : UIButton) {
        
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        
        let feeder = AppointmentThreeable.allCases[indexPath.item].value
        self.appointmentThree?.appointmentThreeContainer.resignation()

        UIDevice.vibrateLight()
        
        switch feeder {
        
        case "Valet pick up and drop off" :
            self.handleValetPickUpAndDropOff(indexpath: indexPath, passedString: feeder)
        case "Owner drop off and pick up" :
            self.handleOwnerDropOffAndPickUp(indexpath: indexPath, passedString: feeder)
        case "Valet pick up, Owner pick up" :
            self.handleValetPickupOwnerPickUp(indexpath: indexPath, passedString: feeder)
        case "Owner drop off, Valet drop off" :
            self.handleOwnerDropOffValetDropOff(indexpath: indexPath, passedString: feeder)
        default: print("hit the default")

        }
    }
    
    func handleValetPickUpAndDropOff(indexpath : IndexPath, passedString : String) {
        self.showValetDropDown(shouldShowDropdown: true, indexpath: indexpath, passedString: passedString)
    }
    
    func handleOwnerDropOffAndPickUp(indexpath : IndexPath, passedString : String) {
        self.showValetDropDown(shouldShowDropdown: false, indexpath: indexpath, passedString: passedString)
        
    }
    
    func handleValetPickupOwnerPickUp(indexpath : IndexPath, passedString : String) {
        self.showValetDropDown(shouldShowDropdown: true, indexpath: indexpath, passedString: passedString)
    }
    
    func handleOwnerDropOffValetDropOff(indexpath : IndexPath, passedString : String) {
        self.showValetDropDown(shouldShowDropdown: true, indexpath: indexpath, passedString: passedString)
    }
    
    func showValetDropDown(shouldShowDropdown : Bool, indexpath : IndexPath, passedString : String) {
        
        if shouldShowDropdown == false {
            
            self.appointmentThree?.appointmentThreeContainer.isHidden = true
            self.appointmentThree?.appointmentThreeCollectionview.isHidden = false
            self.appointmentThree?.appointmentThreeContainer.resignation()
            if self.indexpathArray.contains(indexpath) {
                self.indexpathArray.removeAll()
                self.appointmentThree?.showNextButton(shouldShow: false)

            } else {
                self.indexpathArray.append(indexpath)
                self.appointmentThree?.showNextButton(shouldShow: true)

            }
        } else {
            
            self.appointmentThree?.appointmentThreeContainer.isHidden = false
            self.appointmentThree?.appointmentThreeCollectionview.isHidden = true

            self.indexpathArray.removeAll()
            self.appointmentThree?.showNextButton(shouldShow: false)
            self.appointmentThree?.appointmentThreeContainer.fillText(passedText: passedString)

        }
        
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AppointmentThreeFeeder : UICollectionViewCell {
    
    var appointmentThreeCollectionview : AppointmentThreeCollectionview?
    
    let circleView : UIButton = {
        
        let co = UIButton(type: .system)
        co.translatesAutoresizingMaskIntoConstraints = false
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        co.layer.borderWidth = 4
        co.layer.borderColor = circleGrey.cgColor
        co.layer.cornerRadius = 29/2
        co.isUserInteractionEnabled = false
        co.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
        co.setTitle(String.fontAwesomeIcon(name: .checkCircle), for: .normal)
        co.setTitleColor(coreOrangeColor, for: .normal)
        co.backgroundColor = coreOrangeColor

        return co
    }()
    
    let selectionDescription : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = ""
        nl.font = UIFont(name: rubikMedium, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        nl.isUserInteractionEnabled = false
        
       return nl
    }()
    
    lazy var selectionContainerOne : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = false
        co.layer.cornerRadius = 15
        co.isUserInteractionEnabled = false
        
        co.layer.borderWidth = 0.5
        co.layer.borderColor = coreOrangeColor.cgColor
        co.layer.shadowColor = coreOrangeColor.cgColor
        co.layer.shadowOpacity = 0.3
        co.layer.shadowOffset = CGSize(width: 0, height: 0)
        co.layer.shadowRadius = 4
        co.layer.shouldRasterize = false

       return co
    }()
    
    lazy var selectionCover : UIButton = {
        
        let co = UIButton(type : .system)
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        co.addTarget(self, action: #selector(self.handleSelection(sender:)), for: .touchUpInside)
        
       return co
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.selectionCover)
        self.addSubview(self.selectionContainerOne)
        self.selectionContainerOne.addSubview(self.circleView)
        self.selectionContainerOne.addSubview(self.selectionDescription)
        
        self.selectionCover.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        self.selectionCover.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.selectionCover.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.selectionCover.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        
        self.selectionContainerOne.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        self.selectionContainerOne.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.selectionContainerOne.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.selectionContainerOne.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        
        self.circleView.centerYAnchor.constraint(equalTo: self.selectionContainerOne.centerYAnchor, constant: 0).isActive = true
        self.circleView.leftAnchor.constraint(equalTo: self.selectionContainerOne.leftAnchor, constant: 17).isActive = true
        self.circleView.heightAnchor.constraint(equalToConstant: 29).isActive = true
        self.circleView.widthAnchor.constraint(equalToConstant: 29).isActive = true

        self.selectionDescription.leftAnchor.constraint(equalTo: self.circleView.rightAnchor, constant: 10).isActive = true
        self.selectionDescription.rightAnchor.constraint(equalTo: self.selectionContainerOne.rightAnchor, constant: -30).isActive = true
        self.selectionDescription.topAnchor.constraint(equalTo: self.selectionContainerOne.topAnchor, constant: 0).isActive = true
        self.selectionDescription.bottomAnchor.constraint(equalTo: self.selectionContainerOne.bottomAnchor, constant: 0).isActive = true
        
    }
    
    @objc func handleSelection(sender : UIButton) {
        self.appointmentThreeCollectionview?.handleSelection(sender : sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

