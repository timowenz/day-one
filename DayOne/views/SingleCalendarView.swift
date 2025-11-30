//
//  SingleCalendarView.swift
//  DayOne
//
//  Created by Timo Wenz on 17.11.25.
//

import SwiftData
import SwiftUI

struct SingleCalendarView: View {
    let calendar = Calendar.current
    let completionStates: [Date: Bool]

    var body: some View {
        let dates = SingleCalendarView.getWeek()

        VStack {
            HStack {
                ForEach(dates, id: \.self) { day in
                    VStack {
                        Text(getDayShort(date: day))
                        Text("\(getDayNumber(date: day))")
                            .frame(width: 35, height: 35)
                            .foregroundColor(completionStates[day] == true ? Color.white : .primary)
                            .animation(.easeInOut, value: completionStates[day])
                            .background(
                                completionStates[day] == true ?
                                    Circle()
                                    .fill(Color.green.opacity(0.4))

                                    :
                                    nil
                            )
                    }
                    .frame(width: 35, height: 50)
                }
            }
        }
    }

    func getMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }

    func getDayShort(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }

    func getDayNumber(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        return components.day ?? 0
    }

    static func getWeek() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (0 ..< 7).compactMap { daysBack in
            calendar.date(byAdding: .day, value: -(6 - daysBack), to: today)
        }
    }
}
