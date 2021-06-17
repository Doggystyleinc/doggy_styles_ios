//
//  Pet.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/16/21.
//

import Foundation

struct Pet {
    let name: String
    let imageURL: String
    
    static let petOne = Pet(name: "Rex", imageURL: "https://firebasestorage.googleapis.com/v0/b/project-doggystyle-dev.appspot.com/o/profileImages%2FPet%20Profile%20Placeholder%2001.png?alt=media&token=3ba26c66-82a1-4e85-9439-c47cc17b56e0")
    static let petTwo = Pet(name: "Dart", imageURL: "https://firebasestorage.googleapis.com/v0/b/project-doggystyle-dev.appspot.com/o/profileImages%2FPet%20Profile%20Placeholder%2002.png?alt=media&token=cfa8e238-3b1c-49fc-909f-399b9cd92308")
}
