//
//  HomeView.swift
//  TaskScheduler
//

import SwiftUI

struct HomeView: View {
    
    @State private var showingOptions: Bool = false
    @State private var scheduleExists: Bool = false
    @State private var navigateToViewSchedule: Bool = false
    @State private var navigateToNewTask: Bool = false
    @State private var redMarkerOffset: Int = -720 // 12 AM offset is y = -720. 11 PM offset is y = 660.
    
    @State private var currentSchedule: Schedule?
    @State private var task = Task(
        title: "",
        exactStart: false,
        taskDuration: 0,
        priority: "Low",
        addBreaks: false,
        breaksEvery: 0,
        breakDuration: 0,
        description: "",
        startTime: Date()
    )
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack {
                    HStack {
                        Text("Sept 26, 2024") // TODO: Fix date
                            .font(.custom("Manrope-ExtraBold", size: 32))
                            .foregroundStyle(.text)
                            .padding(25)
                        
                        Spacer()
                    }
                    
                    CalendarView {
                        redMarkerView()
                    }
                }
                
                VStack { // Plus button
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            if scheduleExists {
                                showingOptions = true
                            } else {
                                path.append("newSchedule")
                            }
                        }) {
                            Image("plusCircle")
                                .resizable()
                                .frame(maxWidth: 64, maxHeight: 64)
                                .aspectRatio(contentMode: .fill)
                                .foregroundStyle(Color("blueAccent"))
                                .shadow(radius: CGFloat(4))
                        }
                        .navigationDestination(for: String.self) {
                            destination in
                            
                            if destination == "newSchedule" {
                                NewScheduleView(
                                    schedule: currentSchedule ?? Schedule(startTime: Date(), endTime: Date(), Tasks: []),
                                    scheduleExists: $scheduleExists,
                                    onSave: { newSchedule in
                                        currentSchedule = newSchedule
                                        path.append("preview")
                                    }
                                )
                            } else if destination == "preview" {
                                PreviewView(onConfirm: {
                                    path.removeLast(path.count) // Return Home
                                })
                            }
                        }
                        .confirmationDialog("Select Choice", isPresented: $showingOptions, titleVisibility: .visible) {
                            
                            Button("View Schedule") {
                                navigateToViewSchedule = true
                            }
                            .navigationDestination(isPresented: $navigateToViewSchedule) {
                                // ViewScheduleView() TODO: Uncomment once implemented
                            }
                            
                            Button("New Task") {
                                navigateToNewTask = true
                            }
                            .navigationDestination(isPresented: $navigateToNewTask) {
                                NewTaskView(task: $task)
                            }
                        }
                    }
                    .padding(.bottom, 70)
                    .padding(.trailing, 30)
                }
            }
        }
    } // view ends
    
    func redMarkerView() -> some View {
        TimelineView(.animation(minimumInterval: 1.0)) { timeline in
            let date = timeline.date
            let pos = calculatePosition(for: date)
            
            HStack(spacing: 0) {
                Spacer()
                Circle()
                    .fill(.redAccent)
                    .frame(width: 14)
                
                Rectangle()
                    .fill(.redAccent)
                    .frame(width: 300, height: 2)
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
