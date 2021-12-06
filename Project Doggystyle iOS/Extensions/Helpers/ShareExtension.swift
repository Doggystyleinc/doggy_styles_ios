//
//  ShareExtension.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/19/21.
//

import Foundation
import Firebase
import AudioToolbox

class ShareFunctionHelper : NSObject {
    
    static func handleShareSheet(passedImage : UIImage?, passedURLString : String, passedView : UIView, completion : @escaping(_ passingView : UIActivityViewController)->()) {
     
        var videoActivityItem : NSURL?
        
        var activityViewController : UIActivityViewController?
        
        var imageActivityItem : UIImage?

        //MARK: - CHECK FOR AN IMAGE AND IF NONE, ITS A REFERRAL
        if passedImage == nil {
        
        if let url = NSURL(string: passedURLString) {
            
            videoActivityItem = url
            
            activityViewController = UIActivityViewController(
                activityItems: [videoActivityItem as Any], applicationActivities: nil)
          
            activityViewController?.popoverPresentationController?.sourceView = (passedView)
            
            activityViewController?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            activityViewController?.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            activityViewController?.excludedActivityTypes = [
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]
            
            if let activity = activityViewController {
                completion(activity)
            }
        }
        
        } else {
            
            //MARK: - USER IS SHARING AN IMAGE HERE
            guard let imageToShare = passedImage else {return}
                        
            imageActivityItem = imageToShare
            
            activityViewController = UIActivityViewController(
            activityItems: [imageActivityItem as Any], applicationActivities: nil)
            
            // This lines is for the popover you need to show in iPad
            activityViewController?.popoverPresentationController?.sourceView = (passedView)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            activityViewController?.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Anything you want to exclude
            activityViewController?.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]
            
            if let activity = activityViewController {
                completion(activity)
            }
        }
    }
}
