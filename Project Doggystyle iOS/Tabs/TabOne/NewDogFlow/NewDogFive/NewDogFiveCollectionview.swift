//
//  NewDogFiveCollectionview.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/6/21.
//

import Foundation
import UIKit

class NewDogFiveCollectionview : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let newDogID = "newDogID"
    private let newDogExpandedID = "newDogExpandedID"

    private let keyArray : [String] = ["Size:",
                                       "Breed:",
                                       "Birthday:",
                                       "Frequency:",
                                       "Favorite Treat:",
                                       "Favorite Food:",
                                       "Medical Conditions:",
                                       "",
                                       "Behavioural Concerns:",
                                       ""
                                       ]
    
    
    var valueArray : [String] = ["big time here",
                                   "big time here",
                                   "big time here",
                                   "big time here",
                                   "big time here",
                                   "big time here",
                                   "big time here",
                                   "",
                                   "big time here",
                                   ""
                                   ]
    
    var newDogFive : NewDogFive?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreWhiteColor
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
        
        self.register(NewDogFeeder.self, forCellWithReuseIdentifier: self.newDogID)
        self.register(NewDogExpandedFeeder.self, forCellWithReuseIdentifier: self.newDogExpandedID)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return keyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.item {
       
        case 7,9:
            
            let textFetch = self.newDogFive?.fetchedArray[indexPath.item],
                textToSize = textFetch ?? "",
                size = CGSize(width: UIScreen.main.bounds.width - 70, height: 2000),
                options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

            let estimatedFrame = NSString(string: textToSize).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: dsSubHeaderFont, size: 18)!], context: nil)
            
            let estimatedHeight = estimatedFrame.height
            
            return CGSize(width: UIScreen.main.bounds.width - 70, height: estimatedHeight)
            
        default:
            if let height = self.newDogFive?.containerForSize.frame.size.height {
                return CGSize(width: UIScreen.main.bounds.width - 70, height: height / CGFloat(self.valueArray.count))
            } else {
                return CGSize(width: UIScreen.main.bounds.width - 70, height: 25)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        switch indexPath.item {

        case 7,9:

            let cell = self.dequeueReusableCell(withReuseIdentifier: self.newDogExpandedID, for: indexPath) as! NewDogExpandedFeeder

            cell.newDogFiveExpanded = self

            let feederValue = self.valueArray[indexPath.item]
            cell.leftLabel.text = feederValue

            return cell

        default:

            let cell = self.dequeueReusableCell(withReuseIdentifier: self.newDogID, for: indexPath) as! NewDogFeeder

            cell.newDogFive = self

            let feederKey = self.keyArray[indexPath.item]
            cell.leftLabel.text = feederKey

            let feederValue = self.valueArray[indexPath.item]
            cell.rightLabel.text = feederValue
            
            return cell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewDogFeeder : UICollectionViewCell {
    
    var newDogFive : NewDogFiveCollectionview?
  
    let leftLabel : UILabel = {
        
        let ll = UILabel()
        ll.translatesAutoresizingMaskIntoConstraints = false
        ll.backgroundColor = .clear
        ll.text = ""
        ll.textColor = dividerGrey
        ll.textAlignment = .left
        ll.font = UIFont(name: dsSubHeaderFont, size: 18)
        ll.adjustsFontSizeToFitWidth = true
        ll.numberOfLines = 1
        
       return ll
    }()
    
    let rightLabel : UILabel = {
        
        let ll = UILabel()
        ll.translatesAutoresizingMaskIntoConstraints = false
        ll.backgroundColor = .clear
        ll.text = ""
        ll.textColor = coreBlackColor
        ll.textAlignment = .right
        ll.font = UIFont(name: dsSubHeaderFont, size: 18)
        ll.adjustsFontSizeToFitWidth = false
        ll.clipsToBounds = true
        ll.numberOfLines = 1
        
       return ll
    }()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreWhiteColor
        self.addViews()
        
    }
    
    
    func addViews() {
        
        self.addSubview(self.leftLabel)
        self.addSubview(self.rightLabel)

        self.leftLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 27).isActive = true
        self.leftLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.leftLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.leftLabel.sizeToFit()
        
        self.rightLabel.leftAnchor.constraint(equalTo: self.leftLabel.rightAnchor, constant: 10).isActive = true
        self.rightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.rightLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        self.rightLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -27).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewDogExpandedFeeder : UICollectionViewCell {
    
    var newDogFiveExpanded : NewDogFiveCollectionview?
    
    let leftLabel : UILabel = {
        
        let ll = UILabel()
        ll.translatesAutoresizingMaskIntoConstraints = false
        ll.backgroundColor = coreWhiteColor
        ll.text = ""
        ll.textColor = coreBlackColor
        ll.textAlignment = .left
        ll.font = UIFont(name: rubikMedium, size: 16)
        ll.adjustsFontSizeToFitWidth = false
        ll.numberOfLines = -1
        
       return ll
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreWhiteColor
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.leftLabel)

        self.leftLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.leftLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 27).isActive = true
        self.leftLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -22).isActive = true
        self.leftLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
