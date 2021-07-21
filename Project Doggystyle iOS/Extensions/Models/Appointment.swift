//
//  Appointment.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/16/21.
//

import Foundation

struct Appointment {
    let stylist: String
    let date: String
    let time: String
    let cycle: Int
    
    static let exampleAppointment = Appointment(stylist: "Jessica", date: "Mon, Jun 21 2021", time: "3:30 PM", cycle: 8)
}
