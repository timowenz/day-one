//
//  SingleDayOneView.swift
//  DayOne
//
//  Created by Timo Wenz on 17.11.25.
//

import SwiftData
import SwiftUI

struct SingleDayOneView: View {
    var habit: Habit

    @Environment(\.modelContext) private var modelContext
    @State private var completionStates: [Date: Bool] = [:]

    private let weekDates = SingleCalendarView.getWeek()

    private var isTodayCompleted: Bool {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())

        guard let today = weekDates.first(where: { calendar.isDate($0, inSameDayAs: now) }) else {
            return false
        }

        return completionStates[today] == true
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.1))
            .frame(height: 115)
            .overlay(
                HStack {
                    VStack {
                        HStack {
                            Text(habit.icon)
                            Text(habit.name)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                        SingleCalendarView(completionStates: completionStates)
                    }
                    Spacer()

                    RoundedRectangle(cornerRadius: 10)
                        .fill(isTodayCompleted ? Color.green.opacity(0.4) : Color.red.opacity(0.4))
                        .animation(.default, value: isTodayCompleted)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: isTodayCompleted ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        )
                        .onTapGesture {
                            toggleCompletionForToday()
                        }
                }
                .padding()
            )
            .padding(.horizontal, 10)
            .onAppear {
                loadCompletions()
            }
    }

    func loadCompletions() {
        let calendar = Calendar.current

        guard let habitCompletions = habit.completions else { return }

        var states: [Date: Bool] = [:]

        for weekDate in weekDates {
            let normalized = calendar.startOfDay(for: weekDate)

            let hasCompletion = habitCompletions.contains { completion in
                calendar.isDate(completion.date, inSameDayAs: normalized)
            }

            states[weekDate] = hasCompletion
        }

        completionStates = states
    }

    func toggleCompletionForToday() {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())

        guard let today = weekDates.first(where: { calendar.isDate($0, inSameDayAs: now) }) else {
            return
        }

        if let existingCompletion = habit.completions?.first(where: { calendar.isDate($0.date, inSameDayAs: now) }) {
            modelContext.delete(existingCompletion)
            completionStates[today] = false
        } else {
            let newCompletion = HabitCompletion(date: now, habit: habit)
            modelContext.insert(newCompletion)

            if habit.completions == nil {
                habit.completions = []
            }
            habit.completions?.append(newCompletion)

            completionStates[today] = true
        }

        do {
            try modelContext.save()
            print("Saved completion state for today")
        } catch {
            print("Error saving: \(error)")
        }
    }
}
