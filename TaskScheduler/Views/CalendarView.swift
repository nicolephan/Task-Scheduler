//
//  CalendarView.swift
//  TaskScheduler
//

import SwiftUI

struct CalendarView<Content: View>: View {
    
    let hours = Array(0...23)
    let heightPerHour = 60
    let lineHeight = 2 // Height of calendar lines
    var isInteractive: Bool
    
    @ObservedObject var taskManager: TaskManager
    
    @State private var navigateToViewTask: Bool = false
    
    var customOverlay: () -> Content // Accept any custom content
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView { // Calendar
                ZStack {
                    VStack(spacing: -24.7) {
                        ForEach(hours, id: \.self) { hour in
                            HStack() {
                                Spacer()
                                
                                Text("\(formattedHour(hour))") // Time labels on the left
                                    .frame(width: 60, alignment: .leading)
                                    .font(.custom("Manrope-ExtraBold", size: 18))
                                    .foregroundColor(.text)
                                    .opacity(0.7)
                                
                                Rectangle() // Calendar lines
                                    .fill(.text)
                                    .frame(height: CGFloat(lineHeight))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .opacity(0.1)
                            }
                            .padding(.bottom, 60)
                        }
                    }
                    .padding()
                    
                    let positions = calculateDynamicPositions(tasks: taskManager.schedule.Tasks)
                    
                    ForEach(taskManager.schedule.Tasks, id: \.self) {
                        task in
                        
                        if let yOffset = positions[task] {
                            placeTask(task: task, yOffset: yOffset)
                        }
                    }

//                    HStack { // TODO: Example task block
//                        Spacer()
//                            .frame(width: 60)
//                            .padding()
//                        ZStack(alignment: .leading) {
//                            Button(action: {
//                                navigateToViewTask = true
//                            }) {
//                                RoundedRectangle(cornerRadius: 16)
//                                    .fill(Color(UIColor(red: 192/255, green: 80/255, blue: 127/255, alpha: 1)))
//                                    .frame(height: CGFloat(heightPerHour)) // height will change
//                                    .offset(x: -10, y: 30) // y will change. y = -690 for 12 AM, y = 690 for 11 PM
//                            }
//                            .navigationDestination(isPresented: $navigateToViewTask) {
//                                ViewTaskView(task: Task(
//                                    title: "Fold Laundry",
//                                    exactStart: false,
//                                    taskDuration: 60,
//                                    priority: "Low",
//                                    addBreaks: false,
//                                    breaksEvery: 0,
//                                    breakDuration: 0,
//                                    description: "",
//                                    startTime: Date.now
//                                ))
//                            }
//                            
//                            VStack(alignment: .leading) {
//                                Text("Fold Laundry")
//                                    .frame(alignment: .leading)
//                                    .font(.custom("Manrope-Bold", size: 16))
//                                    .foregroundColor(.white)
//                                
//                                HStack {
//                                    Image(systemName: "clock")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .foregroundStyle(.white)
//                                        .opacity(0.7)
//                                        .frame(width: 13)
//                                    Text("12:00PM-1:00PM")
//                                        .frame(alignment: .leading)
//                                        .font(.custom("Manrope-Bold", size: 13))
//                                        .foregroundColor(.white)
//                                        .opacity(0.7)
//                                }
//                                .padding(.vertical, -12)
//                            }
//                            .padding(.top, 50)
//                            .padding(.horizontal, 10)
//                        }
//                    } // TODO: Example task block
                    
                    customOverlay() // Inject red marker in HomeView
                }
            }
            .onAppear {
                // Scroll to 7 AM when the view first appears
                scrollProxy.scrollTo(7, anchor: .top)
            }
        }
        .padding(.leading, -5)
    } // view ends
    
    func formattedHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // 'h a' formats as 12-hour time (1 PM, 2 AM, etc.)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        let date = Calendar.current.date(from: dateComponents)!
        
        return formatter.string(from: date)
    }
    
    func placeTask(task: Task, yOffset: CGFloat) -> some View {
        let isShortTask = task.taskDuration < 55
        let isTinyTask = task.taskDuration < 35
        
        return HStack {
            Spacer()
                .frame(width: 60)
                .padding()

            if isInteractive {
                Button(action: {
                    navigateToViewTask = true
                }) {
                    taskView(task: task, isTinyTask: isTinyTask, isShortTask: isShortTask)
                }
//                .offset(x: -10, y: calculatePosition(for: task.startTime) - 690) // y will change. y = -690 for 12 AM, y = 690 for 11 PM
                .offset(x: -10, y: yOffset)
                .navigationDestination(isPresented: $navigateToViewTask) {
                    ViewTaskView(task: Task(
                        title: task.title,
                        exactStart: task.exactStart,
                        taskDuration: task.taskDuration,
                        priority: task.priority,
                        addBreaks: task.addBreaks,
                        breaksEvery: task.breaksEvery,
                        breakDuration: task.breakDuration,
                        description: task.description,
                        startTime: task.startTime
                    ))
                }
            } else {
                taskView(task: task, isTinyTask: isTinyTask, isShortTask: isShortTask)
//                    .offset(x: -10, y: calculatePosition(for: task.startTime) - 690) // y will change. y = -690 for 12 AM, y = 690 for 11 PM
                    .offset(x: -10, y: yOffset)
            }
        }
        
        
    }
    
    func taskView(task: Task, isTinyTask: Bool, isShortTask: Bool) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: min(CGFloat(task.taskDuration) / 4, 16))
                .fill(Color(UIColor(red: 192/255, green: 80/255, blue: 127/255, alpha: 1)))
                .frame(height: CGFloat(task.taskDuration)) // height will change
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .frame(alignment: .leading)
                    .font(.custom("Manrope-Bold", size: isTinyTask ? CGFloat(task.taskDuration) / 2.5 : 16))
                    .foregroundColor(.white)
                
                if !isShortTask {
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.white)
                            .opacity(0.7)
                            .frame(width: 13)
                        Text("\(formattedTimeRange(for: task))")
                            .frame(alignment: .leading)
                            .font(.custom("Manrope-Bold", size: 14))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .padding(.vertical, -12)
                }
                
            }
            .padding(.horizontal, 15)
            .padding(.top, isTinyTask ? CGFloat(task.taskDuration / 5) : 7)
        }
    }
    
    func calculatePosition(for date: Date) -> CGFloat {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        let totalMinutes = (hour * 60) + minute
        
        return CGFloat(totalMinutes)
    }
    
    func calculateDynamicPositions(tasks: [Task]) -> [Task: CGFloat] {
        var positions: [Task: CGFloat] = [:]
        var occupiedSlots: [(start: CGFloat, end: CGFloat)] = []

        // Sort tasks: exactStart first, then by priority
        let sortedTasks = tasks.sorted { task1, task2 in
            if task1.exactStart != task2.exactStart {
                return task1.exactStart // Exact-start tasks come first
            }
            if task1.exactStart && task2.exactStart {
                return task1.startTime < task2.startTime // Sort exact-start by startTime
            }
            return task1.priority > task2.priority // Non-exact-start sorted by priority
        }

        print(sortedTasks.map { $0.title }) // Debug: Check task order
        
        // Assign Y-positions
        for task in sortedTasks {
            if task.exactStart {
                let exactPosition = calculatePosition(for: task.startTime) - 690
                positions[task] = exactPosition

                let endPosition = exactPosition + CGFloat(task.taskDuration)
                occupiedSlots.append((start: exactPosition, end: endPosition))
            } else {
                var currentYOffset: CGFloat = calculatePosition(for: taskManager.schedule.startTime) - 690 // Tracks the next available Y position
                let taskDuration = CGFloat(task.taskDuration)
                
                while true {
                    // Check if currentYOffset overlaps with any occupied slot
                    let overlaps = occupiedSlots.contains { slot in
                        (currentYOffset < slot.end && currentYOffset + taskDuration > slot.start)
                    }
                    
                    if !overlaps {
                        // Found a spot where the task can fit
                        positions[task] = currentYOffset
                        occupiedSlots.append((start: currentYOffset, end: currentYOffset + taskDuration))
                        break
                    }
                    
                    // Move to the next available position
                    currentYOffset += 5 // Increment by 5-minute blocks
                }
            }
        }

        return positions
    }

    
    func calculatePositionForPriority (priority: Int) -> CGFloat {
        return 0
    }
    
    func formattedTimeRange(for task: Task) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let start = formatter.string(from: task.startTime)
        let end = formatter.string(from: task.startTime.addingTimeInterval(TimeInterval(task.taskDuration * 60)))
        return "\(start) - \(end)"
    }
}

#Preview {
    CalendarView(isInteractive: false, taskManager: TaskManager()) {
        EmptyView()
    }
}
