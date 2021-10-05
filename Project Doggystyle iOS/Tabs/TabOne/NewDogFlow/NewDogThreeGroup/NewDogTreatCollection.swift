//
//  NewDogTreatCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/12/21.
//

import Foundation
import UIKit

class NewDogTreatTableView : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private let newDogTreatID = "newDogTreatID"
    
    var newDogTreatSubview : NewDogTreatSubview?,
        newDogTreatArray : [String] = [String]()
    
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
        self.register(NewDogTreatFeeder.self, forCellReuseIdentifier: self.newDogTreatID)
        
        self.footer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 48.0)
        
    }
    
    @objc func handleCantFindIt() {
        
       guard let text = self.newDogTreatSubview?.breedTextField.text else {
             self.newDogTreatSubview?.breedTextField.layer.borderColor = coreRedColor.cgColor
        return
        
       }
       
        if text.isEmpty {
            self.newDogTreatSubview?.breedTextField.layer.borderColor = coreRedColor.cgColor
        } else {
            self.newDogTreatSubview?.breedTextField.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
            self.newDogTreatSubview?.newDogThree?.fillBreed(breedType: text)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newDogTreatID, for: indexPath) as! NewDogTreatFeeder
        cell.selectionStyle = .none
        
        if self.newDogTreatArray.count != 0 {
            let feeder = self.newDogTreatArray[indexPath.item]
            cell.treatLabel.text = feeder
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newDogTreatArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feeder = self.newDogTreatArray[indexPath.item]
        self.newDogTreatSubview?.newDogThree?.fillBreed(breedType: feeder)
        self.newDogTreatSubview?.centerConstraint?.constant = 0
        self.newDogTreatSubview?.breedTextField.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewDogTreatFeeder : UITableViewCell {
    
    let treatLabel : UILabel = {
        
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
        
        self.addSubview(self.treatLabel)
        
        self.treatLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        self.treatLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.treatLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.treatLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


