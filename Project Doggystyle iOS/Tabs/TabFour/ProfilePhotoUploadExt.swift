//
//  ProfilePhotoUploadExt.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/2/21.
//


import Foundation
import UIKit
import AVFoundation
import MobileCoreServices
import Photos

extension ProfileController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func checkForGalleryAuth() {
        
        UIDevice.vibrateLight()
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        
        case .authorized:
            self.openGallery()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.openGallery()
                }
            })
            
        case .restricted:
            self.handleCustomPopUpAlert(title: "PERMISSIONS", message: "Please allow Photo Library Permissions in the Settings application.", passedButtons: [Statics.OK])
        case .denied:
            self.handleCustomPopUpAlert(title: "PERMISSIONS", message: "Please allow Photo Library Permissions in the Settings application.", passedButtons: [Statics.OK])
        default :
            self.handleCustomPopUpAlert(title: "PERMISSIONS", message: "Please allow Photo Library Permissions in the Settings application.", passedButtons: [Statics.OK])
        }
    }
    
    func openCameraOptions() {
        
        DispatchQueue.main.async {
            
            let ip = UIImagePickerController()
            ip.sourceType = .camera
            ip.mediaTypes = [kUTTypeImage as String]
            ip.allowsEditing = true
            ip.delegate = self
            
            if let topViewController = UIApplication.getTopMostViewController() {
                topViewController.present(ip, animated: true) {
                    
                }
            }
        }
    }
    
    func openGallery() {
        
        DispatchQueue.main.async {
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            
            if let topViewController = UIApplication.getTopMostViewController() {
                topViewController.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            print("Dismissed the image picker or camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            
            let mediaType = info[.mediaType] as! CFString
            
            switch mediaType {
            
            case kUTTypeImage :
                
                if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    
                    self.activityInvoke(shouldStart: true)
                    self.profileImageView.image = editedImage
                    self.homeController?.uploadProfileImage(imageToUpload: editedImage) { complete in
                        self.fetchJSON()
                        self.activityInvoke(shouldStart: false)
                        UIDevice.vibrateLight()
                    }
                    
                } else if let originalImage = info[.originalImage] as? UIImage  {
                    self.activityInvoke(shouldStart: true)
                    self.profileImageView.image = originalImage
                    self.homeController?.uploadProfileImage(imageToUpload: originalImage) { complete in
                        self.fetchJSON()
                        self.activityInvoke(shouldStart: false)
                        UIDevice.vibrateLight()
                    }
                    
                } else {
                    print("Failed grabbing the photo")
                }
                
            default : print("SHOULD NOT HIT FOR THE CAMERA PICKER")
                
            }
        }
    }
    
    func activityInvoke(shouldStart : Bool) {
        
        if shouldStart {
            UIView.animate(withDuration: 0.35) {
                self.profileImageView.alpha = 0.25
            } completion: { complete in
                self.activityIndicator.startAnimating()
            }
        } else {
            UIView.animate(withDuration: 0.35) {
                self.profileImageView.alpha = 1.0
            } completion: { complete in
                self.activityIndicator.stopAnimating()
            }
        }
    }
}







