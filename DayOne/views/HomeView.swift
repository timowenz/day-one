//
//  HomeView.swift
//  DayOne
//
//  Created by Timo Wenz on 17.11.25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @State var shouldPresentSheet = false
    @State private var habitToDelete: Habit?
    @State private var showDeleteConfirmation = false

    @State private var habitToEdit: Habit?
    @State private var showEditSheet = false

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdDate) var habits: [Habit]

    func deleteHabit(_ habit: Habit) {
        modelContext.delete(habit)

        do {
            try modelContext.save()
            print("Habit deleted successfully")
        } catch {
            print("Error deleting habit: \(error)")
        }

        habitToDelete = nil
    }

    var body: some View {
        NavigationStack {
            VStack {
                if habits.isEmpty {
                    Text("No habits currently here.\nTry add a new habit!")
                        .multilineTextAlignment(.center)
                }

                if !habits.isEmpty {
                    List {
                        ForEach(habits, id: \.id) { habit in
                            SingleDayOneView(habit: habit)
                                .background(
                                    NavigationLink("", destination: DetailCalendarView(habit: habit))
                                        .opacity(0)
                                )
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        habitToEdit = habit
                                        showEditSheet = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        habitToDelete = habit
                                        showDeleteConfirmation = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .animation(.none, value: habits.count)
                    .alert("Delete Habit", isPresented: $showDeleteConfirmation, presenting: habitToDelete) { habit in
                        Button("Delete", role: .destructive) {
                            withAnimation {
                                deleteHabit(habit)
                            }
                        }
                        Button("Cancel", role: .cancel) {
                            habitToDelete = nil
                        }
                    } message: { habit in
                        Text("Are you sure you want to delete '\(habit.name)'? This action cannot be undone.")
                    }
                    .sheet(item: $habitToEdit) { habit in
                        AddOrEditHabitView(habit: habit)
                            .presentationDetents([.fraction(0.335)])
                    }

                    Spacer()
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        shouldPresentSheet = true
                    }) {
                        Image(systemName: "plus")
                    }

                    .sheet(isPresented: $shouldPresentSheet) {
                        print("Sheet dismissed!")
                    } content: {
                        AddOrEditHabitView()
                            .presentationDetents([.fraction(0.335)])
                    }
                }
            }
        }
    }
}
