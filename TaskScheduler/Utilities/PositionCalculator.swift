//
//  PositionCalculator.swift
//  TaskScheduler
//

import Foundation
import SwiftUI

struct PositionCalculator {
    
    static let baseOffset: CGFloat = -690
    
    static func calculateDynamicPositions(tasks: [Task], startTime: Date) -> (positions: [UUID: CGFloat], updatedTasks: [Task]) {
        var positions: [UUID: CGFloat] = [:]
        var occupiedSlots: [(start: CGFloat, end: CGFloat)] = []
        var localTasks = tasks // Local mutable copy

        // Sort tasks: exactStart first, then by priority
        let sortedTasks = localTasks.sorted { task1, task2 in
            if task1.exactStart != task2.exactStart {
                return task1.exactStart
            }
            if task1.exactStart && task2.exactStart {
                return task1.startTime < task2.startTime
            }
            return task1.priority > task2.priority
        }

//        print(sortedTasks.map { $0.title }) // TODO: Debug: Check task order
        
        // Assign Y-positions
        for task in sortedTasks {
            if task.exactStart {
                let exactPosition = calculatePosition(for: task.startTime) + baseOffset + calculateDurationAdjustment(for: task.taskDuration)
                positions[task.id] = exactPosition

                let endPosition = exactPosition + CGFloat(task.taskDuration)
                occupiedSlots.append((start: exactPosition, end: endPosition))
            } else {
                var currentYOffset: CGFloat = calculatePosition(for: startTime) + baseOffset // Tracks the next available Y position
                let taskDuration = CGFloat(task.taskDuration)
                
                while true {
                    // Check if currentYOffset overlaps with any occupied slot
                    let overlaps = occupiedSlots.contains { slot in
                        (currentYOffset < slot.end && currentYOffset + taskDuration > slot.start)
                    }
                    
                    if !overlaps {
                        let adjustedYOffset = currentYOffset + calculateDurationAdjustment(for: task.taskDuration)
                        
                        // Found a spot where the task can fit
                        positions[task.id] = adjustedYOffset
                        
                        // Update task start time
                        let newStartTime = calculateDate(for: currentYOffset, taskDuration: task.taskDuration)
                        if let taskIndex = localTasks.firstIndex(of: task) {
                            localTasks[taskIndex].startTime = newStartTime
                        }
                        
                        occupiedSlots.append((start: currentYOffset, end: currentYOffset + taskDuration))
                        break
                    }
                    
                    currentYOffset += 5 // Increment by 5-minute blocks
                }
            }
        }

        return (positions, localTasks)
    }
    
    static func calculatePosition(for date: Date) -> CGFloat {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        let totalMinutes = (hour * 60) + minute
        
        return CGFloat(totalMinutes)
    }
    
    static func calculateDate(for position: CGFloat, taskDuration: Int) -> Date {
        let totalMinutes = Int(position - baseOffset)
        let newDate = Calendar.current.date(byAdding: .minute, value: totalMinutes, to: Calendar.current.startOfDay(for: Date())) ?? Calendar.current.startOfDay(for: Date())
        return newDate
    }
    
    static func calculateDurationAdjustment(for taskDuration: Int) -> CGFloat {
        let adjustmentFactor: CGFloat = 15.0
        let durationAdjustment = CGFloat(taskDuration - 60) / 30.0 * adjustmentFactor

        return durationAdjustment
    }
}
