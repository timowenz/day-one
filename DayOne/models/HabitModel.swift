//
//  HabitModel.swift
//  DayOne
//
//  Created by Timo Wenz on 08.11.25.
//

import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var icon: String = "😀"
    var createdDate: Date

    @Relationship(deleteRule: .cascade, inverse: \HabitCompletion.habit)
    var completions: [HabitCompletion]?

    init(name: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.createdDate = Date()
        self.completions = []
    }
}
