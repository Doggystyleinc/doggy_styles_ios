//
//  SearchLocationTableview.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/22/21.
//

import Foundation
import UIKit

class PlacesDictionary : NSObject {
    
    var locationName : String?,
        placeName : String?
    
    init(json : [String : Any]) {
        self.locationName = json["locationName"] as? String ?? ""
        self.placeName = json["placeName"] as? String ?? ""
    }
}

class SearchResultsTableView : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private let tableId = "tableId"
    var placesArray = [String](),
        arrayOfDicts = [PlacesDictionary](),
        locationFinder : LocationFinder?
    
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
        self.register(FilterResultsFeeder.self, forCellReuseIdentifier: tableId)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableId, for: indexPath) as! FilterResultsFeeder
        cell.selectionStyle = .none
        
        if !self.arrayOfDicts.isEmpty {
            
            let feeder = self.arrayOfDicts[indexPath.item]
            cell.placeLabel.text = feeder.locationName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfDicts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !self.arrayOfDicts.isEmpty {
            
            guard let locationName = self.arrayOfDicts[indexPath.item].locationName else {return}
            guard let placeName = self.arrayOfDicts[indexPath.item].placeName else {return}
            
            userOnboardingStruct.chosen_grooming_location_name = locationName

            self.locationFinder?.handleLocationSelection(passedPlaceID: placeName, passedLocationAddress: locationName)
           
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
