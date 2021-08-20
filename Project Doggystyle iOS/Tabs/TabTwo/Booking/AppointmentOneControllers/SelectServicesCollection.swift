//
//  SelectServicesCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/20/21.
//


import Foundation
import UIKit
import Firebase

public enum Packageable : String, CaseIterable {
    
    case FullPackage
    case CustomPackage
    
    var description: (String, String, String) {
        
        switch self {
        
        case .FullPackage : return ("shower","Full Package","$149")
        case .CustomPackage : return ("bath","Custom Package","-")
        
        }
    }
}

class SelectServicesCollection : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let selectServicesID = "selectServicesID"
    
    var appointmentOne : AppointmentOne?
    
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
        self.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        self.register(SelectServicesFeeder.self, forCellWithReuseIdentifier: self.selectServicesID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return Packageable.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.selectServicesID, for: indexPath) as! SelectServicesFeeder
        
        cell.selectServicesCollection = self
        
        let feeder = Packageable.allCases[indexPath.item].description
        
        let icon = feeder.0
        let label = feeder.1
        let cost = feeder.2
        
        switch icon {
        
        case "shower" :
            print("Setting shower")
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .shower), for: .normal)
        case "bath" :
            print("Setting bath")
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .bath), for: .normal)
        default: print("")
        }
        
        cell.headerLabel.text = label
        cell.costLabel.text = cost

        return cell
    }
    
    @objc func handleServicesSelection(sender : UIButton) {
        
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        
        let feeder = Packageable.allCases[indexPath.item].description
        print("\(feeder.0) : \(feeder.1) : \(feeder.2)")
        
        let packageSelection = feeder.1
        self.appointmentOne?.handlePackageSelection(packageSelection : packageSelection)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SelectServicesFeeder : UICollectionViewCell {
    
    var selectServicesCollection : SelectServicesCollection?
    
    lazy var mainContainer : UIButton = {
        
        let cv = UIButton(type : .system)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cv.layer.shadowOpacity = 0.05
        cv.layer.shadowOffset = CGSize(width: 2, height: 3)
        cv.layer.shadowRadius = 9
        cv.layer.shouldRasterize = false
        cv.layer.cornerRadius = 15
        cv.addTarget(self, action: #selector(self.handlePackageSelection(sender:)), for: .touchUpInside)
        
       return cv
    }()
    
    let iconImageView : UIButton = {
        
        let iv = UIButton(type: .system)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = dividerGrey
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = false
        iv.tintColor = coreBlackColor

       return iv
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = ""
        hl.font = UIFont(name: rubikMedium, size: 18)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false

        return hl
    }()
    
    let costLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = ""
        hl.font = UIFont(name: rubikRegular, size: 16)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false

        return hl
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.mainContainer)
        self.addSubview(self.iconImageView)
        self.addSubview(self.costLabel)
        self.addSubview(self.headerLabel)

        self.mainContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.mainContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.mainContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.mainContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        self.iconImageView.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 25).isActive = true
        self.iconImageView.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 20).isActive = true
        self.iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.costLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -25).isActive = true
        self.costLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.costLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor).isActive = true
        self.costLabel.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: 0).isActive = true
        
        self.headerLabel.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 10).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.costLabel.leftAnchor, constant: -10).isActive = true
        self.headerLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor).isActive = true
        self.headerLabel.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor).isActive = true
        
    }
    
    @objc func handlePackageSelection(sender : UIButton) {
        
        self.selectServicesCollection?.handleServicesSelection(sender : sender)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
