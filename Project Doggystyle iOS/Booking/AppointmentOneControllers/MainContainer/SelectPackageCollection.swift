//
//  SelectServicesCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/20/21.
//


import Foundation
import UIKit
import Firebase

class SelectServicesCollection : UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let selectServicesID = "selectServicesID"
    
    var appointmentOne : AppointmentOne?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = true
        self.alwaysBounceHorizontal = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.separatorStyle = .none
        
        self.register(SelectServicesFeeder.self, forCellReuseIdentifier: self.selectServicesID)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Packageable.allCases.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.dequeueReusableCell(withIdentifier: self.selectServicesID, for: indexPath) as! SelectServicesFeeder
        
        cell.selectServicesCollection = self
        
        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        
        let feeder = Packageable.allCases[indexPath.item].description
        
        let icon = feeder.0
        let label = feeder.1
        let cost = feeder.2
        
        switch icon {
        
        case "shower" :
            
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .shower), for: .normal)
            
            let sizeOfArray = self.appointmentOne?.selectedProfileDataSource.count ?? 0
            
            if self.appointmentOne?.isAllDogsTheSameSize == true && sizeOfArray > 0 {
                
                if self.appointmentOne?.sameDogWeightSelectSize == nil || sizeOfArray <= 0 {
                    cell.costLabel.text = "\(DogGroomingCostable.Default.description)"
                    self.appointmentOne?.mainContainerFP.costForFullPackage = "\(DogGroomingCostable.Default.description)"

                } else {
                    
                    switch self.appointmentOne?.sameDogWeightSelectSize {
                    
                    case "Small":
                        cell.costLabel.text = "\(DogGroomingCostable.Small.description)"
                        self.appointmentOne?.mainContainerFP.costForFullPackage = "\(DogGroomingCostable.Small.description)"
                        
                    case "Medium":
                        cell.costLabel.text = "\(DogGroomingCostable.Medium.description)"
                        self.appointmentOne?.mainContainerFP.costForFullPackage = "\(DogGroomingCostable.Medium.description)"

                    case "Large":
                        cell.costLabel.text = "\(DogGroomingCostable.Large.description)"
                        self.appointmentOne?.mainContainerFP.costForFullPackage = "\(DogGroomingCostable.Large.description)"

                    case "X-Large":
                        cell.costLabel.text = "\(DogGroomingCostable.XLarge.description)"
                        self.appointmentOne?.mainContainerFP.costForFullPackage = "\(DogGroomingCostable.XLarge.description)"

                    default: cell.costLabel.text = "\(DogGroomingCostable.Default.description)"
                        self.appointmentOne?.mainContainerFP.costForFullPackage = "\(DogGroomingCostable.Default.description)"

                    }
                    
                    DispatchQueue.main.async {
                        self.appointmentOne?.mainContainerFP.reloadData()
                    }
                }
                
            } else {
                cell.costLabel.text = "\(DogGroomingCostable.Default.description)"
                self.appointmentOne?.mainContainerFP.costForFullPackage = "\(DogGroomingCostable.Default.description)"
                
                DispatchQueue.main.async {
                    self.appointmentOne?.mainContainerFP.reloadData()
                }
            }
            
        case "bath" :
            
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .bath), for: .normal)
            cell.costLabel.text = cost
            
        default: print("")
            
        }
        
        cell.headerLabel.text = label
        
        return cell
    }
    
    @objc func handleServicesSelection(sender : UIButton) {
        
        if self.appointmentOne?.canSelectMainPackage == true {
            
            let selectedButtonCell = sender.superview as! UITableViewCell
            guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
            
            let feeder = Packageable.allCases[indexPath.item].description
            print("\(feeder.0) : \(feeder.1) : \(feeder.2)")
            
            let packageSelection = feeder.1
            self.appointmentOne?.handlePackageSelection(packageSelection : packageSelection)
            
        } else {
            self.appointmentOne?.handleMainContainerTaps()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class SelectServicesFeeder : UITableViewCell {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
