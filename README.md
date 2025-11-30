# DayOne

A simple and elegant habit tracking app for iOS built with SwiftUI and SwiftData.

## Features

- **Create Habits**: Add new habits with custom names and emoji icons
- **Track Completions**: Mark habits as complete each day
- **Calendar View**: View your habit completion history in a calendar format
- **Edit & Delete**: Easily manage your habits with swipe actions

## Requirements

- iOS 17.0+
- Xcode 15.0+

## Tech Stack

- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Apple's native persistence framework

## Project Structure

```
DayOne/
├── DayOneApp.swift          # App entry point
├── models/
│   ├── HabitModel.swift     # Habit data model
│   └── HabitCompletionModel.swift  # Completion tracking model
└── views/
    ├── ContentView.swift    # Main content view
    ├── HomeView.swift       # Home screen with habit list
    ├── AddOrEditHabitView.swift  # Create/edit habits
    ├── DetailCalendarView.swift  # Calendar detail view
    ├── SingleCalendarView.swift  # Single calendar component
    ├── SingleDayOneView.swift    # Individual habit row
    ├── EmojiTextFieldView.swift  # Emoji picker input
    └── SettingsView.swift   # App settings
```

## Getting Started

1. Clone the repository
2. Open `DayOne.xcodeproj` in Xcode
3. Build and run on a simulator or device

## Author

Created by Timo Wenz
