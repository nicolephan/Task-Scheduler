//
//  TaskManager.swift
//  TaskScheduler
//

import Foundation

class TaskManager: ObservableObject {
    @Published var schedule = Schedule(startTime: Date(), endTime: Date().addingTimeInterval(3600), Tasks: [])
}
