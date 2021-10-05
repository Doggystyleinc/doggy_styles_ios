//
//  NewDogFoodCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/12/21.
//


import Foundation
import UIKit

class NewDogFoodTableView : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private let newDogFoodID = "newDogFoodID"
    
    var newDogFoodSubview : NewDogFoodSubview?,
        newDogFoodArray : [String] = [String]()
    
    lazy var footer: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = true
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.masksToBounds = true
        cbf.backgroundColor = .clear
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreOrangeColor
        
        let str = String.fontAwesomeIcon(name: .plus) + "   Can't find it? Add it"
        let attributedStr = NSMutableAttributedString(string: str)
        
        let range1 = NSRange(location: 0, length: 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.fontAwesome(ofSize: 18, style: .solid),
                                   range: range1)
        
        let range2 = NSRange(location: 1, length: (str as NSString).length - 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont(name: dsHeaderFont, size: 18)!,
                                   range: range2)
        
        cbf.setAttributedTitle(attributedStr, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleCantFindIt), for: .touchUpInside)
        
        return cbf
        
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = coreWhiteColor
        self.delegate = self
        self.dataSource = self
        self.alpha = 1
        self.isHidden = false
        self.layer.masksToBounds = true
        self.keyboardDismissMode = .interactive
        self.separatorStyle = .none
        self.layer.cornerRadius = 10
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.tableFooterView = self.footer
        self.register(NewDogFoodFeeder.self, forCellReuseIdentifier: self.newDogFoodID)
        
        self.footer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 48.0)
        
    }
    
    @objc func handleCantFindIt() {
        
        guard let text = self.newDogFoodSubview?.breedTextField.text else {
            self.newDogFoodSubview?.breedTextField.layer.borderColor = coreRedColor.cgColor
            return
            
        }
        
        if text.isEmpty {
            self.newDogFoodSubview?.breedTextField.layer.borderColor = coreRedColor.cgColor
        } else {
            self.newDogFoodSubview?.breedTextField.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
            self.newDogFoodSubview?.newDogThree?.fillDogs(breedType: text)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newDogFoodID, for: indexPath) as! NewDogFoodFeeder
        cell.selectionStyle = .none
        
        if self.newDogFoodArray.count != 0 {
            let feeder = self.newDogFoodArray[indexPath.item]
            cell.foodLabel.text = feeder
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newDogFoodArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feeder = self.newDogFoodArray[indexPath.item]
        self.newDogFoodSubview?.newDogThree?.fillDogs(breedType: feeder)
        self.newDogFoodSubview?.centerConstraint?.constant = 0
        self.newDogFoodSubview?.breedTextField.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewDogFoodFeeder : UITableViewCell {
    
    let foodLabel : UILabel = {
        
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.textColor = coreBlackColor
        pl.text = ""
        pl.textAlignment = .left
        pl.font = UIFont(name: rubikRegular, size: 18)
        pl.numberOfLines = 1
        pl.adjustsFontSizeToFitWidth = true
        
        return pl
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor .clear
        self.addViews()
    }
    
    func addViews() {
        
        self.addSubview(self.foodLabel)
        
        self.foodLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        self.foodLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.foodLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.foodLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


