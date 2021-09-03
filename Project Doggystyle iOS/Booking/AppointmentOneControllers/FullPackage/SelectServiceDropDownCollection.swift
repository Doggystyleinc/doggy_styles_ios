//
//  SelectServiceDropDownCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/20/21.
//


import Foundation
import UIKit

var globalArrayOfDicts = [[String:String]]()

class ServicesDropDownCollection : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let dropServices = "dropServices"
    
    var appointmentOne : AppointmentOne?
    var arrayOfIndexPaths = [IndexPath]()
    var shouldCellsExpand : Bool = false
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        self.register(ServicesDropDownFeeder.self, forCellWithReuseIdentifier: self.dropServices)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleDataReset), name: NSNotification.Name("HANDLE_CLEAR_OTHER_COLLECTIONS"), object: nil)

    }
    
    @objc func handleDataReset() {
        
        self.arrayOfIndexPaths.removeAll()
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return FullPackageable.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.shouldCellsExpand == true && self.arrayOfIndexPaths.contains(indexPath) {
            
            if let datasource = self.appointmentOne?.selectedProfileDataSource.count {
            
            let height = (CGFloat(datasource) * 40) + 90
            
            return CGSize(width: UIScreen.main.bounds.width - 60, height: height)
            
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 60, height: 40)
        }
            
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 60, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.dropServices, for: indexPath) as! ServicesDropDownFeeder

        cell.servicesDropDownCollection = self
        
        let feeder = FullPackageable.allCases[indexPath.item]
        
        let serviceName = feeder.description.0
        let serviceCost = feeder.description.1

        cell.headerLabelFP.text = "\(serviceName)"
        cell.costLabelFP.text = "\(serviceCost)"

        if self.arrayOfIndexPaths.contains(indexPath) {
            cell.engageShadow(shouldEngage: true)
        } else {
            cell.engageShadow(shouldEngage: false)
        }
        
        switch serviceName {

        case "Dematting" :

            cell.iconImageViewFP.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageViewFP.setTitle(String.fontAwesomeIcon(name: .rulerCombined), for: .normal)
            cell.mainCollectionContainer.typeOfServiceSelection = "dematting"
            
            self.decide(typeOfService: "dematting") { complete in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25) {
                        cell.mainCollectionContainer.reloadData()
                    }
                }
            }

        case "Deshedding" :

            cell.iconImageViewFP.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageViewFP.setTitle(String.fontAwesomeIcon(name: .chair), for: .normal)
            cell.mainCollectionContainer.typeOfServiceSelection = "deshedding"
    
            self.decide(typeOfService: "deshedding") { complete in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25) {
                        cell.mainCollectionContainer.reloadData()
                    }
                }
            }
            
        default: print("default")

        }
        
        DispatchQueue.main.async {
            cell.mainCollectionContainer.reloadData()
        }
        
        return cell
    
    }
    
    func decide(typeOfService: String, completion: @escaping(_ isComplete : Bool)->()) {
        
    globalArrayOfDicts.removeAll()

    if let dataSource = self.appointmentOne?.selectedProfileDataSource {
        
        for i in 0..<dataSource.count {
        
        let feeder = dataSource[i],
            dogsFirstName = feeder.dog_builder_name ?? "Pup",
            dogSize = feeder.dog_builder_size ?? "Medium"
            
            let dogCost = dogServicePriceConfiguration(dogSize: dogSize, service: typeOfService)
            let dic = [dogsFirstName : dogCost]
            
            globalArrayOfDicts.append(dic)
            
        }
        
        completion(true)
    } else {
        completion(true)
    }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    @objc func handleSelection(sender : UIView, mainCollection : SelectFullPackageContainer) {
    
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
       
        if !self.arrayOfIndexPaths.contains(indexPath) {
            
            self.arrayOfIndexPaths.removeAll()
          
            self.arrayOfIndexPaths.append(indexPath)
            
            self.appointmentOne?.shouldExpandMainContainerFP(shouldExpand: false)
            
        } else {
            
            self.arrayOfIndexPaths.removeAll()

        }
        
        let isAllDogsTheSameSize = self.appointmentOne?.isAllDogsTheSameSize ?? false,
             dataSourceCount = self.appointmentOne?.selectedProfileDataSource.count ?? 0
        
        if dataSourceCount > 1 && isAllDogsTheSameSize == false {
            self.shouldCellsExpand = true
        } else {
            self.shouldCellsExpand = false
        }

        UIDevice.vibrateLight()
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.25) {
                self.reloadData()
                self.reloadItems(at: [indexPath])
                self.appointmentOne?.view.layoutIfNeeded()
                self.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ServicesDropDownFeeder : UICollectionViewCell {
    
    var servicesDropDownCollection : ServicesDropDownCollection?
    
    lazy var mainCollectionContainer : SelectFullPackageContainer = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let sfp = SelectFullPackageContainer(frame: .zero, collectionViewLayout: layout)
        sfp.servicesDropDownFeeder = self
        
       return sfp
    }()
    
    lazy var mainContainerFP : UIButton = {

        let cv = UIButton(type : .system)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor .clear
        cv.addTarget(self, action: #selector(self.handleContainerTap(sender:)), for: .touchUpInside)

       return cv

    }()

    let iconImageViewFP : UIButton = {

        let iv = UIButton(type: .system)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = dividerGrey
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = false
        iv.tintColor = coreWhiteColor
        iv.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
        iv.setTitle(String.fontAwesomeIcon(name: .shower), for: .normal)
        iv.backgroundColor = coreOrangeColor

       return iv
    }()

    let headerLabelFP : UILabel = {

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

    let costLabelFP : UILabel = {

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
        
        self.backgroundColor = coreWhiteColor
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor .clear.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowRadius = 9
        self.layer.shouldRasterize = false
        self.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 15
        self.isUserInteractionEnabled = true
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.35
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4
        self.layer.shouldRasterize = false
        
        
        self.layer.shadowColor = coreOrangeColor.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4
        self.layer.shouldRasterize = false
        self.layer.cornerRadius = 15
        self.layer.borderColor = coreOrangeColor.cgColor
        self.layer.borderWidth = 0.5
        
        self.addViews()

    }
    
    func addViews() {
        
        self.addSubview(self.mainContainerFP)

        self.mainContainerFP.addSubview(self.iconImageViewFP)
        self.mainContainerFP.addSubview(self.costLabelFP)
        self.mainContainerFP.addSubview(self.headerLabelFP)
        self.addSubview(self.mainCollectionContainer)

        self.mainContainerFP.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.mainContainerFP.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.mainContainerFP.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.mainContainerFP.heightAnchor.constraint(equalToConstant: 80).isActive = true

        self.iconImageViewFP.leftAnchor.constraint(equalTo: self.mainContainerFP.leftAnchor, constant: 25).isActive = true
        self.iconImageViewFP.topAnchor.constraint(equalTo: self.mainContainerFP.topAnchor, constant: 20).isActive = true
        self.iconImageViewFP.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.iconImageViewFP.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.costLabelFP.rightAnchor.constraint(equalTo: self.mainContainerFP.rightAnchor, constant: -25).isActive = true
        self.costLabelFP.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.costLabelFP.centerYAnchor.constraint(equalTo: self.iconImageViewFP.centerYAnchor).isActive = true
        self.costLabelFP.bottomAnchor.constraint(equalTo: self.mainContainerFP.bottomAnchor, constant: 0).isActive = true

        self.headerLabelFP.leftAnchor.constraint(equalTo: self.iconImageViewFP.rightAnchor, constant: 10).isActive = true
        self.headerLabelFP.rightAnchor.constraint(equalTo: self.costLabelFP.leftAnchor, constant: -10).isActive = true
        self.headerLabelFP.centerYAnchor.constraint(equalTo: self.iconImageViewFP.centerYAnchor).isActive = true
        self.headerLabelFP.bottomAnchor.constraint(equalTo: self.mainContainerFP.bottomAnchor).isActive = true

        self.mainCollectionContainer.topAnchor.constraint(equalTo: self.headerLabelFP.bottomAnchor, constant: 0).isActive = true
        self.mainCollectionContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.mainCollectionContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.mainCollectionContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true

    }
    
    @objc func handleContainerTap(sender : UIButton) {
        self.servicesDropDownCollection?.handleSelection(sender : sender, mainCollection: self.mainCollectionContainer)
    }
    
    func engageShadow(shouldEngage : Bool) {
        
        if shouldEngage {
            self.layer.shadowColor = coreOrangeColor.cgColor
            self.layer.borderColor = coreOrangeColor.cgColor
        } else {
            self.layer.shadowColor = UIColor .clear.cgColor
            self.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







