//
//  Task.swift
//  TaskScheduler
//

import Foundation

struct Task: Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var exactStart: Bool
    var taskDuration: Int // in minutes
    var priority: Int // 0 = low, 1 = med, or 2 = high
    var addBreaks: Bool
    var breaksEvery: Int // minutes
    var breakDuration: Int // minutes
    var description: String
    var startTime: Date
}
