//
//  HomeView.swift
//  TaskScheduler
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    @State private var scheduleExists: Bool = false
    @State private var navigateToViewSchedule: Bool = false
    @State private var redMarkerOffset: Int = -720 // 12 AM offset is y = -720. 11 PM offset is y = 660.
    
    @State private var path = NavigationPath()
    
    @StateObject var taskManager = TaskManager()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack {
                    HStack {
                        Text(formattedCurrentDate())
                            .font(.custom("Manrope-ExtraBold", size: 32))
                            .foregroundStyle(.text)
                            .padding(25)
                        
                        Spacer()
                    }
                    
                    CalendarView(isInteractive: true, schedule: taskManager.schedule, taskManager: taskManager) {
                        redMarkerView()
                    }
                }
                
                VStack { // Plus button
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            if scheduleExists {
                                path.append("viewSchedule")
                            } else {
                                path.append("newSchedule")
                            }
                        }) {
                            if scheduleExists{
                                Image("editButton")
                                    .resizable()
                                    .frame(maxWidth: 64, maxHeight: 64)
                                    .aspectRatio(contentMode: .fill)
                                    .shadow(radius: CGFloat(4))
                            } else {
                                Image("plusCircle")
                                    .resizable()
                                    .frame(maxWidth: 64, maxHeight: 64)
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundStyle(Color("blueAccent"))
                                    .shadow(radius: CGFloat(4))
                            }
                        }
                        .navigationDestination(for: String.self) {
                            destination in
                            
                            if destination == "newSchedule" {
                                NewScheduleView(
                                    taskManager: taskManager,
                                    scheduleExists: $scheduleExists,
                                    path: $path
                                )
                            }
                            else if destination == "viewSchedule" {
                                ViewScheduleView(
                                    schedule: taskManager.schedule,
                                    scheduleExists: $scheduleExists,
                                    onSave: { updatedSchedule in
                                        taskManager.schedule = updatedSchedule
                                        path.removeLast(path.count)
                                    },
                                    path: $path
                                )
                            }
                        }
                        .navigationDestination(for: Schedule.self) { // Send schedule to Preview to be finalized
                            localSchedule in
                            
                            PreviewView(
                                taskManager: taskManager,
                                localSchedule: localSchedule,
                                scheduleExists: $scheduleExists,
                                onSave: { finalizedSchedule in
                                    taskManager.schedule = finalizedSchedule
                                    path.removeLast(path.count) // Return Home
                                }
                            )
                        }
                        .navigationDestination(for: Task.self) { task in
                            ViewTaskView(task: task)
                        }
                    }
                    .padding(.bottom, 70)
                    .padding(.trailing, 30)
                }
            }
        }
    } // view ends
    
    func formattedCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d"
        return formatter.string(from: Date())
    }
    
    func redMarkerView() -> some View {
        TimelineView(.animation(minimumInterval: 1.0)) { timeline in
            let date = timeline.date
            let pos = calculatePosition(for: date)
            
            HStack(spacing: 0) {
                Spacer()
                Circle()
                    .fill(.redAccent)
                    .frame(width: 14)
                
                if verticalSizeClass == .regular {
                    Rectangle()
                        .fill(.redAccent)
                        .frame(width: 300, height: 2)
                } else {
                    Rectangle()
                        .fill(.redAccent)
                        .frame(width: 650, height: 2)
                }
            }
            .padding()
            .offset(y: pos)
        }
    }
    
    func calculatePosition(for date: Date) -> CGFloat {
        let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        let totalMinutes = (hour * 60) + minute
        
        return CGFloat(totalMinutes + redMarkerOffset)
    }
}

#Preview {
    HomeView()
}
