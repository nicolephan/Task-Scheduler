//
//  Task.swift
//  TaskScheduler
//

import Foundation

struct Task {
    var title: String
    var exactStart: Bool
    var taskDuration: Int // in minutes
    var priority: String
    var addBreaks: Bool
    var breaksEvery: Int // minutes
    var breakDuration: Int // minutes
    var description: String
}