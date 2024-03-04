//
//  FSCalendarView.swift
//  MyApp
//
//  Created by Admin on 2/3/2024.


import FSCalendar
import SwiftUI

struct FSCalendarView: UIViewRepresentable {
    @Binding var currentMonthAvailability: [String: Int]
    @Binding var nextMonthAvailability: [String: Int]
    @Binding var selectedDate: String?

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        calendar.appearance.headerTitleColor = .blue
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDataSource, FSCalendarDelegate {
        var parent: FSCalendarView
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            return formatter
        }()

        init(_ parent: FSCalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            let dateString = dateFormatter.string(from: date)
            parent.selectedDate = dateString
            print("Selected date:", dateString)
        }

        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let dateString = dateFormatter.string(from: date)
            if let availability = parent.currentMonthAvailability[dateString] {
                return availability
            } else if let availability = parent.nextMonthAvailability[dateString] {
                return availability
            }
            return 0
        }

        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            let dateString = dateFormatter.string(from: date)
            if let availability = parent.currentMonthAvailability[dateString], availability == 1 {
                return true
            } else if let availability = parent.nextMonthAvailability[dateString], availability == 1 {
                return true
            }
            return false
        }

        func minimumDate(for calendar: FSCalendar) -> Date {
            return Date()
        }

        func maximumDate(for calendar: FSCalendar) -> Date {
            return Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        }
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
            let dateString = dateFormatter.string(from: date)
            if parent.currentMonthAvailability[dateString] == 1 || parent.nextMonthAvailability[dateString] == 1 {
                return .orange
            }
            return nil
        }
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            let dateString = dateFormatter.string(from: date)
            if parent.currentMonthAvailability[dateString] == 1 || parent.nextMonthAvailability[dateString] == 1 {
                return .orange
            }
            return nil 
        }


    }
}
