//
//  DetailCalendarView.swift
//  DayOne
//
//  Created by Timo Wenz on 25.11.25.
//

import SwiftData
import SwiftUI

struct DetailCalendarView: View {
    @Bindable var habit: Habit
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var currentMonth: Date = .init()
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text(habit.icon)
                        .font(.system(size: 40))
                    Text(habit.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading, 15)
                
                HStack {
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(isViewingCurrentMonth ? .secondary : Color.blue)
                    .disabled(isViewingCurrentMonth)
                                    
                    VStack {
                        Text(monthYearString(from: currentMonth))
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(minWidth: 180)
                        
                        Button("Today") {
                            withAnimation {
                                currentMonth = Date()
                            }
                        }
                    }
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 10) {
                    HStack {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(Array(daysInCurrentMonth().enumerated()), id: \.offset) { _, date in
                            if let date = date {
                                dayCell(for: date)
                            } else {
                                Text("")
                                    .frame(height: 40)
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.1))
                )
                .padding(.horizontal)
                
                statsView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var isViewingCurrentMonth: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularity: .month)
    }
    
    private func dayCell(for date: Date) -> some View {
        let isCompleted = isHabitCompleted(on: date)
        let isToday = calendar.isDateInToday(date)
            
        let isFuture = calendar.compare(date, to: Date(), toGranularity: .day) == .orderedDescending
            
        return Button {
            toggleCompletion(on: date)
        } label: {
            VStack {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 16, weight: isToday ? .bold : .regular))
                    .foregroundStyle(isCompleted ? .white : (isToday ? .primary : .primary))
            }
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .fill(backgroundColor(isCompleted: isCompleted, isToday: isToday))
            )
            .overlay(
                Circle()
                    .stroke(isToday ? Color.clear : Color.clear, lineWidth: 2)
            )
            .opacity(isFuture ? 0.3 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(isFuture)
    }
    
    private var statsView: some View {
        VStack(spacing: 10) {
            Text("Statistics")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                statItem(title: "Total", value: "\(habit.completions?.count ?? 0)")
                statItem(title: "This Month", value: "\(completionsInCurrentMonth())")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private func statItem(title: String, value: String) -> some View {
        VStack {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cornerRadius(10)
    }
    
    private func backgroundColor(isCompleted: Bool, isToday: Bool) -> Color {
        if isCompleted {
            return Color.green.opacity(0.4)
        }
        return Color.clear
    }
    
    private func isHabitCompleted(on date: Date) -> Bool {
        guard let completions = habit.completions else { return false }
        return completions.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func completionsInCurrentMonth() -> Int {
        guard let completions = habit.completions else { return 0 }
        return completions.filter { calendar.isDate($0.date, equalTo: currentMonth, toGranularity: .month) }.count
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            withAnimation {
                currentMonth = newMonth
            }
        }
    }
    
    private func daysInCurrentMonth() -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))
        else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        
        let offset = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [Date?] = Array(repeating: nil, count: offset)
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func toggleCompletion(on date: Date) {
        if calendar.compare(date, to: Date(), toGranularity: .day) == .orderedDescending {
            return
        }
            
        if let existingCompletion = habit.completions?.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            modelContext.delete(existingCompletion)
            if let index = habit.completions?.firstIndex(of: existingCompletion) {
                habit.completions?.remove(at: index)
            }
        } else {
            let newCompletion = HabitCompletion(date: date, habit: habit)
            modelContext.insert(newCompletion)
                
            if habit.completions == nil {
                habit.completions = []
            }
            habit.completions?.append(newCompletion)
        }
            
        do {
            try modelContext.save()
        } catch {
            print("Error saving detail toggle: \(error)")
        }
    }
}
