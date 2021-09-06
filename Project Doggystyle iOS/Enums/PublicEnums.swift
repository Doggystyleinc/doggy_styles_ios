//
//  PublicEnums.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/1/21.
//

import Foundation
import UIKit

public func dogServicePriceConfiguration(dogSize : String, service : String) -> String {
    
    switch dogSize {
    
    case "Small":
        
        switch service {
        
        case "dematting" : return "$108"
        case "deshedding" : return "$256"
        case "bath" : return "$546"
        case "hairCut" : return "$486"
        case "teethCleaning" : return "$214"
        case "nailTrimming" : return "$864"
        case "earCleaning" : return "$987"
        default: return "$119"
        
        }
        
    case "Medium":
        
        switch service {
        
        case "dematting" : return "$548"
        case "deshedding" : return "$435"
        case "bath" : return "$654"
        case "hairCut" : return "$778"
        case "teethCleaning" : return "$989"
        case "nailTrimming" : return "$687"
        case "earCleaning" : return "$465"
        default: return "$119"
        
        }
    
    case "Large":
        
        switch service {
        
        case "dematting" : return "$756"
        case "deshedding" : return "$869"
        case "bath" : return "$078"
        case "hairCut" : return "$986"
        case "teethCleaning" : return "$576"
        case "nailTrimming" : return "$123"
        case "earCleaning" : return "$143"
        default: return "$119"
        
        }
        
    case "X-Large":
        
        switch service {
        
        case "dematting" : return "$567"
        case "deshedding" : return "$678"
        case "bath" : return "$789"
        case "hairCut" : return "$678"
        case "teethCleaning" : return "$567"
        case "nailTrimming" : return "$456"
        case "earCleaning" : return "$345"
        default: return "$119"
        
        }
        
    default: return "nil"
  
    }
}

    public enum Servicable : String, CaseIterable {
        
        case washAndGroom
        case dematting
        case deshedding
        case bath
        case hairCut
        case teethCleaning
        case nailTrimming
        case earCleaning
        
        var description: (String, String, String) {
            
            switch self {
            
            case .washAndGroom: return ("Wash & Groom", "$149", "Our Groomz packages include everything your pup needs to feel oh so clean clean and refreshed. Our goal is to give your doggy the ultimate pampered experience the Doggystyle way. Custom packages also available. Includes: Bath with premium shampoo and conditioner, cut, teeth cleaning, nail trimming, and ear cleaning.")
                
            case .dematting: return ("Dematting", "$30", "Standing by for descriptions.")
                
            case .deshedding: return ("Deshedding", "$20", "Standing by for descriptions.")
                
            case .bath: return ("Bath", "$40", "Standing by for descriptions.")
                
            case .hairCut: return ("Haircut", "$50", "Standing by for descriptions.")
                
            case .teethCleaning: return ("Teeth Cleaning", "$20", "Standing by for descriptions.")
                
            case .nailTrimming: return ("Nail Trimming", "$20", "Standing by for descriptions.")
                
            case .earCleaning: return ("Ear Cleaning", "$20", "Standing by for descriptions.")
                
            }
        }
    }


    public enum Packageable : String, CaseIterable {
        
        case FullPackage
        case CustomPackage
        
        var description: (String, String, String) {
            
            switch self {
            
            case .FullPackage : return ("shower","Full Package","$119+")
            case .CustomPackage : return ("bath","Custom Package","-")
                
            }
        }
    }

    public enum DogGroomingCostable : String {
        
        case Small
        case Medium
        case Large
        case XLarge
        case Default
        
        var description : String {
            
            switch self {
            
            case .Small: return "$119"
            case .Medium: return "$129"
            case .Large: return "$139"
            case .XLarge: return "$149"
            case .Default: return "$119+"
                
            }
        }
    }

    public enum FullPackageable : String, CaseIterable {
        
        case dematting
        case deshedding
        
        var description: (String, String) {
            
            switch self {
            
            case .dematting: return ("Dematting", "$30")
            case .deshedding: return ("Deshedding", "$20")
                
            }
        }
    }

    public enum CustomPackageable : String, CaseIterable {
        
        case bath
        case dematting
        case deshedding
        case hairCut
        case teethCleaning
        case nailTrimming
        case earCleaning
        
        var description: (String, String) {
            
            switch self {
            
            case .bath: return ("Bath*", "$119+")
                
            case .dematting: return ("Dematting", "$30")
                
            case .deshedding: return ("Deshedding", "$20")
                
            case .hairCut: return ("Haircut", "$50")
                
            case .teethCleaning: return ("Teeth Cleaning", "$20")
                
            case .nailTrimming: return ("Nail Trimming", "$20")
                
            case .earCleaning: return ("Ear Cleaning", "$20")
                
            }
        }
    }
