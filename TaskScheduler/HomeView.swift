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
    
    let hours = Array(0...23)
    let heightPerHour = 60
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { scrollProxy in
                    HStack { // Title
                        Text("Sept 26, 2024") // TODO: Fix date
                            .font(.custom("Manrope-ExtraBold", size: 32))
                            .foregroundStyle(.text)
                            .padding(25)

                        Spacer()
                    }
                    
                    ScrollView { // Calendar
                        ZStack {
                            VStack(spacing: 0) {
                                ForEach(hours, id: \.self) { hour in
                                    HStack() {
                                        Spacer()
                                        
                                        Text("\(formattedHour(hour))") // Time labels on the left
                                            .frame(width: 60, alignment: .leading)
                                            .font(.custom("Manrope-ExtraBold", size: 18))
                                            .foregroundColor(.text)
                                            .opacity(0.7)
                                        
                                        Rectangle() // Calendar lines
                                            .background(.text)
                                            .frame(height: 2)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .opacity(0.1)
                                    }
                                    .padding(.vertical, 18)
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
                                    .offset(x: -10, y: 0) // y will change
                            }
                            
                            HStack(spacing: 0) { // Red marker
                                Spacer()
                                Circle()
                                    .fill(.redAccent)
                                    .frame(width: 14)
                                
                                Rectangle()
                                    .fill(.redAccent)
                                    .frame(width: 300, height: 2)
                            }
                            .padding()
                            .offset(y: CGFloat(0)) // TODO: Fix
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
                            NewScheduleView(schedule: currentSchedule ?? Schedule(startTime: Date(), endTime: Date(), Tasks: []), scheduleExists: $scheduleExists) { newSchedule in
                                currentSchedule = newSchedule
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
    
    func formattedHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // 'h a' formats as 12-hour time (1 PM, 2 AM, etc.)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        let date = Calendar.current.date(from: dateComponents)!
        
        return formatter.string(from: date)
    }
    
    func calculatePosition() -> CGFloat {
        let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

//        print(CGFloat(hour * heightPerHour + minute))
        return CGFloat(hour * heightPerHour + minute)
    }
}
    
    

#Preview {
    HomeView()
}
