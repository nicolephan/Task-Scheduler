//
//  Schedule.swift
//  TaskScheduler
//

import Foundation

struct Schedule: Hashable {
    var startTime: Date
    var endTime: Date
    var Tasks: [Task]
}
