//
//  CalendarView.swift
//  TaskScheduler
//

import SwiftUI

struct CalendarView<Content: View>: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    let hours = Array(0...23)
    let heightPerHour = 60
    let lineHeight = 2
    var isInteractive: Bool
    var schedule: Schedule
    
    @ObservedObject var taskManager: TaskManager
    
    @State private var navigateToViewTask: Bool = false
    @State private var positions: [UUID: CGFloat] = [:]
    @State private var updatedTasks: [Task] = []
    @State private var hasInitialized: Bool = false
    @State private var taskToNavigateTo: Task?
    
    private let taskColors: [Color] = [
        Color(UIColor(red: 83/255, green: 139/255, blue: 220/225, alpha: 1)), // blue
        Color(UIColor(red: 255/255, green: 145/255, blue: 153/225, alpha: 1)), // pink
        Color(UIColor(red: 0/255, green: 186/255, blue: 136/225, alpha: 1)), // green
        Color(UIColor(red: 192/255, green: 80/255, blue: 127/255, alpha: 1)) // red-pink
    ]
    
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
                    
                    ForEach(updatedTasks.indices, id: \.self) { index in
                        let task = updatedTasks[index]
                        if let yOffset = positions[task.id] {
                            let taskColor = taskColors[index % taskColors.count]
                            placeTask(task: task, yOffset: yOffset, taskColor: taskColor)
                        } else {
                            Text("Task \(task.title) has no position.")
                        }
                    }
             
                    customOverlay() // Inject red marker in HomeView
                }
            }
            .onAppear {
                if !hasInitialized {
                    recalculatePositions()
                    hasInitialized = true
                }
                
                // Scroll to x hrs before current time when the view first appears
                let currentHour = Calendar.current.component(.hour, from: Date())
                let targetHour: Int
                
                if verticalSizeClass == .compact {
                    targetHour = max(0, currentHour - 2)
                } else {
                    targetHour = max(0, currentHour - 5)
                }
                
                scrollProxy.scrollTo(targetHour, anchor: .top)
            }
            .onChange(of: schedule.Tasks) {
                recalculatePositions()
            }
        }
        .padding(.leading, -5)
    } // view ends
    
    func recalculatePositions() {
        let (calculatedPositions, calculatedTasks) = PositionCalculator.calculateDynamicPositions(tasks: schedule.Tasks, startTime: schedule.startTime)
        positions = calculatedPositions
        updatedTasks = calculatedTasks
    }
    
    func formattedHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // 'h a' formats as 12-hour time (1 PM, 2 AM, etc.)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        let date = Calendar.current.date(from: dateComponents)!
        
        return formatter.string(from: date)
    }
    
    func placeTask(task: Task, yOffset: CGFloat, taskColor: Color) -> some View {
        let isShortTask = task.taskDuration < 55
        let isTinyTask = task.taskDuration < 35
        
        return HStack {
            Spacer()
                .frame(width: 60)
                .padding()
            
            NavigationLink(value: task) {
                taskView(task: task, isTinyTask: isTinyTask, isShortTask: isShortTask, taskColor: taskColor)
            }
            .offset(x: -10, y: yOffset)
            .background(
                NavigationLink(value: task, label: { EmptyView() })
                    .hidden()
            )
        }
    }
    
    func taskView(task: Task, isTinyTask: Bool, isShortTask: Bool, taskColor: Color) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: min(CGFloat(task.taskDuration) / 4, 16))
                .fill(taskColor)
                .frame(height: CGFloat(task.taskDuration))
            
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
    
    func formattedTimeRange(for task: Task) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let start = formatter.string(from: task.startTime)
        let end = formatter.string(from: task.startTime.addingTimeInterval(TimeInterval(task.taskDuration * 60)))
        return "\(start) - \(end)"
    }
}

//#Preview {
//    CalendarView(isInteractive: false, schedule: Schedule(), taskManager: TaskManager()) {
//        EmptyView()
//    }
//}
