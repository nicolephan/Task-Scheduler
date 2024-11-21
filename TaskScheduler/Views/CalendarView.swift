//
//  CalendarView.swift
//  TaskScheduler
//

import SwiftUI

struct CalendarView<Content: View>: View {
    
    let hours = Array(0...23)
    let heightPerHour = 60
    let lineHeight = 2 // Height of calendar lines
//    let schedule: Schedule
    
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
                    
                    ForEach(taskManager.schedule.Tasks, id: \.self) {
                        task in
                        placeTask(task: task)
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
    
    func placeTask(task: Task) -> some View {
        HStack {
            Spacer()
                .frame(width: 60)
                .padding()
            ZStack(alignment: .leading) {
                Button(action: {
                    navigateToViewTask = true
                }) {
                    RoundedRectangle(cornerRadius: CGFloat(16 * task.taskDuration / heightPerHour))
                        .fill(Color(UIColor(red: 192/255, green: 80/255, blue: 127/255, alpha: 1)))
                        .frame(height: CGFloat(task.taskDuration)) // height will change
                        .offset(x: -10, y: calculatePosition(for: task.startTime) - 690) // y will change. y = -690 for 12 AM, y = 690 for 11 PM
                }
//                .navigationDestination(isPresented: $navigateToViewTask) {
//                    ViewTaskView(task: Task(
//                        title: "Fold Laundry",
//                        exactStart: false,
//                        taskDuration: 60,
//                        priority: "Low",
//                        addBreaks: false,
//                        breaksEvery: 0,
//                        breakDuration: 0,
//                        description: "",
//                        startTime: Date.now
//                    ))
//                }
                
                VStack(alignment: .leading) {
                    Text(task.title)
                        .frame(alignment: .leading)
                        .font(.custom("Manrope-Bold", size: 16))
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.white)
                            .opacity(0.7)
                            .frame(width: 13)
                        Text("12:00PM-1:00PM")
                            .frame(alignment: .leading)
                            .font(.custom("Manrope-Bold", size: 13))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .padding(.vertical, -12)
                }
                .padding(.top, 50)
                .padding(.horizontal, 10)
            }
        }
    }
    
    func calculatePosition(for date: Date) -> CGFloat {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        let totalMinutes = (hour * 60) + minute
        
        return CGFloat(totalMinutes)
    }
}

#Preview {
    CalendarView(taskManager: TaskManager()) {
        EmptyView()
    }
}
