//
//  Task.swift
//  TaskScheduler
//

import Foundation

struct Task: Hashable {
    var title: String
    var exactStart: Bool
    var taskDuration: Int // in minutes
    var priority: String
    var addBreaks: Bool
    var breaksEvery: Int // minutes
    var breakDuration: Int // minutes
    var description: String
    var startTime: Date
}
