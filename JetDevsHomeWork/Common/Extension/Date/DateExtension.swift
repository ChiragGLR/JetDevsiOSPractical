//
//  DateExtension.swift
//  JetDevsHomeWork
//
//  Created by Chirag on 23/2/2024.
//

import Foundation

extension Date {
    func daysSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date, to: self)
        return components.day ?? 0
    }
}
