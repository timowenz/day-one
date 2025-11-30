//
//  AddOrEditHabitView.swift
//  DayOne
//
//  Created by Timo Wenz on 17.11.25.
//

import SwiftUI
import SwiftData

struct AddOrEditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let habitToEdit: Habit? 

    @State private var habitName: String = ""
    @State private var showWarning: Bool = false

    init() {
        self.habitToEdit = nil
    }

    init(habit: Habit) {
        self.habitToEdit = habit
        self._habitName = State(initialValue: habit.name)
        self._icon = State(initialValue: habit.icon)
    }

    @State private var icon = "😀"
    @State private var isPresented = false

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        ZStack {
                            Text(icon)
                                .font(.title3)
                                .padding(.trailing, 5)
                                .onTapGesture {
                                    isPresented.toggle()
                                }

                            if isPresented {
                                EmojiTextFieldView(text: $icon, isPresented: $isPresented)
                                    .frame(width: 0, height: 0)
                                    .opacity(0)
                            }
                        }

                        TextField("", text: $habitName, prompt: Text("Learn").foregroundColor(Color(.lightText)))
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 15)
                            .frame(height: 45)
                            .background(Color(.lightGray))
                            .cornerRadius(.infinity)
                            .onChange(of: habitName) {
                                showWarning = false
                            }
                    }.padding()
                    Text("Note: 24h after the streaks resets!")
                        .foregroundColor(Color(.lightGray))
                    if showWarning {
                        Text("Please enter a habit name!")
                            .foregroundColor(.red)
                            .padding(1)
                    }
                }

                Button {
                    if habitName.isEmpty || habitName == "" {
                        print("Empty string. Returning...")
                        showWarning = true
                        return
                    }

                    if let habit = habitToEdit {
                        habit.name = habitName
                        habit.icon = icon
                    } else {
                        let newHabit = Habit(name: habitName, icon: icon)
                        modelContext.insert(newHabit)
                    }

                    do {
                        try modelContext.save()
                    } catch {
                        print("Error saving: \(error)")
                    }
                    print("Saved")
                    showWarning = false
                    dismiss()
                }
                label: {
                    Text("Save")
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .font(.title3)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .close) {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}
