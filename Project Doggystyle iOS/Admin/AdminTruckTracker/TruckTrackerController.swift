//
//  TruckTrackerController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 12/10/21.
//

import Foundation
import UIKit
import Firebase


class TruckTracker : UIViewController {
    
    let databaseRef = Database.database().reference()
    
    var truckModelArray = [TruckTrackerModel](),
        secondLimiter : Int = 0,
        timer : Timer?,
        updateInterval : Int = 5
    
    lazy var truckTrackerMapView : TruckTrackerMapSubview = {
        
        let mv = TruckTrackerMapSubview(frame: .zero)
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.backgroundColor = .red
        mv.truckTracker = self
        return mv
        
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.backgroundColor = .clear
        ai.color = coreBlackColor
        ai.layer.masksToBounds = true
        
       return ai
    }()
    
    let updatingLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "updating"
        thl.font = UIFont(name: dsHeaderFont, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreBlackColor
        thl.isHidden = true
        return thl
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        self.addViews()
        self.fireUpEngine()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleIntervals), userInfo: nil, repeats: true)

    }
    
    func addViews() {
        
        self.view.addSubview(self.truckTrackerMapView)
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.updatingLabel)

        self.truckTrackerMapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.truckTrackerMapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.truckTrackerMapView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.truckTrackerMapView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        self.activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.activityIndicator.layer.cornerRadius = 20
        
        self.updatingLabel.topAnchor.constraint(equalTo: self.activityIndicator.bottomAnchor, constant: 3).isActive = true
        self.updatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.updatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.updatingLabel.sizeToFit()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        //MARK: - CLEAN UP
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func fireUpEngine() {
        
        print("ENGINE UPDATING")
        self.activityIndicator.startAnimating()
        self.updatingLabel.isHidden = false

        self.runDataEngine { isComplete in
            self.render()
        }
    }
    
    //MARK: - POPULATES THE TRUCKS LOCATION ON THE MAP AS WELL AS CLIENTS
    func runDataEngine(completion : @escaping (_ isComplete : Bool)->()) {
        
        let ref = self.databaseRef.child("client_groomer_location_broadcaster")
        
        ref.observeSingleEvent(of: .value) { snapTrcukLoop  in
            
            self.truckModelArray.removeAll()
            
            for child in snapTrcukLoop.children.allObjects as! [DataSnapshot] {
                
                let JSON = child.value as? [String : Any] ?? [:]
                
                let post = TruckTrackerModel(JSON: JSON)
                self.truckModelArray.append(post)
                
            }
            
            completion(true)
        }
    }
    
    @objc func handleIntervals() {
        
        print("COUNTING FOR REFRESH")
        
        self.secondLimiter += 1
        
        if self.secondLimiter >= self.updateInterval {
            self.secondLimiter = 0
            print("clear to run")
            self.fireUpEngine()
        }
    }
    
    func render() {
        
        if self.truckModelArray.count == 0 {return}
        
        guard let truckImage = UIImage(named: "map_van_image")?.withRenderingMode(.alwaysOriginal) else {return}
        guard let clientImage = UIImage(named: "Owner Profile Placeholder")?.withRenderingMode(.alwaysOriginal) else {return}
        
        var usersName : String = ""

        for i in self.truckModelArray {
            
            let isGroomer = i.is_groomer ?? false
            
            let latitude = i.latitude ?? 0.0
            let longitude = i.longitude ?? 0.0
            let firstName = i.user_first_name ?? "nil"
            let lastName = i.user_last_name ?? "nil"
            let users_profile_image_url = i.users_profile_image_url ?? "nil"
            
            if isGroomer {
                if firstName == "nil" {
                    usersName = "Stylist"
                } else {
                    usersName = "\(firstName) \(lastName)"
                }
            } else {
                if firstName == "nil" {
                    usersName = "Client"
                } else {
                    usersName = "\(firstName) \(lastName)"
                }
            }
            
            //MARK: - IS A GROOMER SO SHOW THE VAN
            if isGroomer {
                self.truckTrackerMapView.addCustomMarker(latitude: latitude, longitude: longitude, image: truckImage, header: usersName)
            } else {
                //MARK: - IS NOT A GROOMER SO SHOW THE CLIENT IMAGE OR DEFAULT IF THEY DO NOT HAVE ONE
                if users_profile_image_url == "nil" {
                    self.truckTrackerMapView.addCustomMarker(latitude: latitude, longitude: longitude, image: clientImage, header: usersName)
                } else {
                    
                    let imageView = UIImageView()
                    imageView.loadImageGeneralUse(users_profile_image_url) { complete in
                        guard let image = imageView.image else {return}
                        self.truckTrackerMapView.addCustomMarker(latitude: latitude, longitude: longitude, image: image, header: usersName)
                    }
                }
            }
        }
        
        //MARK: - ENGINE UPDATE COMPLETE
        self.perform(#selector(self.hideAnimator), with: nil, afterDelay: 2.0)
    }
    
    @objc func hideAnimator() {
        self.activityIndicator.stopAnimating()
        self.updatingLabel.isHidden = true
    }
}


