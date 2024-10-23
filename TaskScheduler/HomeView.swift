//
//  HomeView.swift
//  TaskScheduler
//

import SwiftUI

struct HomeView: View {
    
    @State private var showingOptions: Bool = false
    @State private var navigateToNewSchedule: Bool = false
    @State private var scheduleExists: Bool = false
    @State private var navigateToViewSchedule: Bool = false
    @State private var navigateToNewTask: Bool = false
    @State private var redMarkerOffset: Int = -720 // 12 AM offset is y = -720. 11 PM offset is y = 660.
    
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
    
    let hours = Array(0...23)
    let heightPerHour = 60
    let lineHeight = 2 // Height of calendar lines
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { scrollProxy in
                    HStack { // Title
                        Text("Sept 26, 2024") // TODO: Fix date
                            .font(.title)
                            .padding(25)
                            .bold()
                        Spacer()
                    }
                    
                    ScrollView { // Calendar
                        ZStack {
                            VStack(spacing: -20.3) {
                                ForEach(hours, id: \.self) { hour in
                                    HStack() {
                                        Spacer()
                                        
                                        Text("\(formattedHour(hour))") // Time labels on the left
                                            .frame(width: 60, alignment: .leading)
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
                            
                            
                            HStack { // TODO: Example task block
                                Spacer()
                                    .frame(width: 60)
                                    .padding()
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.blue)
                                    .frame(height: CGFloat(heightPerHour)) // height will change
                                    .offset(x: -10, y: 30) // y will change. y = -690 for 12 AM, y = 690 for 11 PM
                            }
                            
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
                    }
                    .onAppear {
                        // Scroll to 7 AM (which is hour 7) when the view first appears
                        scrollProxy.scrollTo(7, anchor: .top)
                    }
                }
                .padding(.leading, -5)
                
                VStack { // Plus button
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            if scheduleExists {
                                navigateToNewSchedule = false
                                showingOptions = true
                            } else {
                                navigateToNewSchedule = true
                            }
                        }) {
                            Image("plusCircle")
                                .resizable()
                                .frame(maxWidth: 64, maxHeight: 64)
                                .aspectRatio(contentMode: .fill)
                                .foregroundStyle(Color("blueAccent"))
                                .shadow(radius: CGFloat(4))
                        }
                        .navigationDestination(isPresented: $navigateToNewSchedule) {
                            NewScheduleView(scheduleExists: $scheduleExists)
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
    
    func formattedHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // 'h a' formats as 12-hour time (1 PM, 2 AM, etc.)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        let date = Calendar.current.date(from: dateComponents)!
        
        return formatter.string(from: date)
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
