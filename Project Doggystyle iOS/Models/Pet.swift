//
//  Pet.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/16/21.
//

import Foundation

struct Pet: Equatable {
    let name: String
    let imageURL: String
}

//MARK: - Example Pets
extension Pet {
    static let allPets = Pet(name: "All", imageURL: "https://firebasestorage.googleapis.com/v0/b/project-doggystyle-dev.appspot.com/o/misc%2FAll%20Pets%20Icon.png?alt=media&token=309e27e0-c0d7-4bfd-a520-26fb90a1190c")
    static let petOne = Pet(name: "Rex", imageURL: "https://firebasestorage.googleapis.com/v0/b/project-doggystyle-dev.appspot.com/o/profileImages%2FPet%20Profile%20Placeholder%2001.png?alt=media&token=3ba26c66-82a1-4e85-9439-c47cc17b56e0")
    static let petTwo = Pet(name: "Dart", imageURL: "https://firebasestorage.googleapis.com/v0/b/project-doggystyle-dev.appspot.com/o/profileImages%2FPet%20Profile%20Placeholder%2002.png?alt=media&token=cfa8e238-3b1c-49fc-909f-399b9cd92308")
    static let petThree = Pet(name: "Chino", imageURL: "https://firebasestorage.googleapis.com/v0/b/project-doggystyle-dev.appspot.com/o/profileImages%2FChino.webp?alt=media&token=863d485c-9baf-4e5c-a25a-671da91b3fa9")
    static let petFour = Pet(name: "Skip", imageURL: "https://firebasestorage.googleapis.com/v0/b/project-doggystyle-dev.appspot.com/o/profileImages%2FSkip.webp?alt=media&token=02712f7a-4998-4892-a379-75d793829928")
}
