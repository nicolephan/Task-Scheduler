//
//  NewScheduleView.swift
//  TaskScheduler
//

import SwiftUI

struct NewScheduleView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var localSchedule: Schedule
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State var datepickersize: CGSize = .zero
    @Binding var scheduleExists: Bool
    var onSave: (Schedule) -> Void
    
    init(schedule: Schedule, scheduleExists: Binding<Bool>, onSave: @escaping (Schedule) -> Void) {
        var modifiedSchedule = schedule
        let emptyTask = Task(
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
        modifiedSchedule.Tasks.append(emptyTask)
        self._localSchedule = State(initialValue: modifiedSchedule)
        self.onSave = onSave
        self._scheduleExists = scheduleExists
    }
    
    var body: some View {
        NavigationView{
            
            VStack{
                HStack{     //BUTTONS
                    Button(action: {
                        dismiss()
                    }) {
                        Image("backButton")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 40)
                            .foregroundColor(.backButtonBG)
                        
                        
                    }
                    Spacer()
                    Button(action: {
                        if validateForm() {
                            scheduleExists = true
                            onSave(localSchedule)
                            dismiss()
                        }
                    }){
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 40)
                            .foregroundStyle(.blueAccent)
                    }
                }   //BUTTONS END
                .padding(.horizontal, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Task"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Text("New Schedule")
                    .font(.custom("Manrope-ExtraBold", size: 32))
                    .foregroundStyle(.text)
                
                ZStack(alignment: .bottom) {
                    Image("sky-boy")
                        .clipped()
                        .padding(.bottom, -60)
                    
                    ScrollView{
                        VStack{
                            Text("Time range")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.custom("Manrope-ExtraBold", size: 18))
                                .foregroundStyle(.text)
                            
                            
                            HStack {
                                VStack { // FROM TIME
                                    Text("From")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.custom("Manrope-ExtraBold", size: 18))
                                        .foregroundStyle(Color.white.opacity(0.5))
                                        .padding(.bottom, -15)
                                        .padding(.horizontal, 15)
                                    
                                    GeometryReader { geo in
                                        DatePicker("", selection: $localSchedule.startTime, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .colorScheme(.dark)
                                            .blendMode(.lighten)
                                            .scaleEffect(x: geo.size.width / datepickersize.width, y: geo.size.width / datepickersize.width, anchor: .topLeading)
                                            .onChange(of: localSchedule.startTime) {
                                                if localSchedule.startTime > localSchedule.endTime {
                                                    localSchedule.endTime = localSchedule.startTime
                                                }
                                            }
                                            .accentColor(.yellow)
                                    }
                                }
                                
                                VStack {
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 24, height: 19)
                                        .padding(.vertical, -32)
                                }
                                
                                VStack { // TO TIME
                                    Text("To")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.custom("Manrope-ExtraBold", size: 18))
                                        .foregroundStyle(Color.white.opacity(0.5))
                                        .padding(.horizontal)
                                        .padding(.bottom, -15)
                                    
                                    GeometryReader { geo in
                                        DatePicker("", selection: $localSchedule.endTime, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .colorScheme(.dark)
                                            .blendMode(.lighten)
                                            .scaleEffect(x: geo.size.width / datepickersize.width, y: geo.size.width / datepickersize.width, anchor: .topLeading)
                                            .onChange(of: localSchedule.endTime) {
                                                if localSchedule.endTime < localSchedule.startTime {
                                                    localSchedule.startTime = localSchedule.endTime
                                                }
                                            }
                                            .accentColor(.yellow)
                                    }
                                }
                            }
                            .padding(30)
                            .foregroundColor(.white)
                            .background(.blueAccent)
                            .cornerRadius(20)
                            .frame(height: 125)
                            .shadow(radius: 4, x: 0, y: 4)
                            
                            Text("Tasks")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.custom("Manrope-ExtraBold", size: 18))
                                .foregroundStyle(.text)
                                .padding(.top)
                            
                            VStack {
                                
                                ForEach(localSchedule.Tasks.indices, id:\.self){index in
                                    HStack{
                                        TextField("", text: $localSchedule.Tasks[index].title)
                                            .padding(10)
                                            .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white))
                                            .frame(height: 44)
                                            .foregroundStyle(.text)
                                        
                                        NavigationLink(destination: NewTaskView(task: $localSchedule.Tasks[index])) {
                                            Image("pencil")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .padding(.leading, 10)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                
                                HStack{
                                    Button(action: {
                                        let newTask = Task(title: "", exactStart: false, taskDuration: 0, priority: "Low", addBreaks: false, breaksEvery: 0, breakDuration: 0, description: "", startTime: Date())
                                        
                                        localSchedule.Tasks.append(newTask)
                                    }) {
                                        Image("plus")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, minHeight: 44)
                                            .background(Color(red: 68/255, green: 115/255, blue: 207/255))
                                            .cornerRadius(10)
                                    }
                                    .padding(.top, 10)
                                    
                                    Spacer()
                                        .frame(width: 40)
                                }
                                
                            }
                            .padding(30)
                            .background(Color(red: 95/255, green: 149/255, blue: 231/255))
                            .cornerRadius(20)
                            .shadow(radius: 4, x: 0, y: 4)
                        }
                        .padding()
                        
                        // INVISIBLE DATEPICKER FOR RESIZE
                        DatePicker("", selection: $localSchedule.startTime, displayedComponents: .hourAndMinute)
                            .background(
                                GeometryReader { geo in
                                    Color.clear.onAppear{
                                        datepickersize = geo.size
                                    }
                                }
                            )
                            .allowsHitTesting(false)
                            .fixedSize()
                            .opacity(0)
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func validateForm() -> Bool{
        for(index, task) in localSchedule.Tasks.enumerated(){
            if task.title == "" {
                alertMessage = "Mandatory Information for task \(index + 1) is not present"
                showAlert = true
                return false
            }
            if task.taskDuration == 0 || (task.addBreaks && task.breaksEvery == 0) || (task.addBreaks && task.breakDuration == 0){
                alertMessage = "Mandatory Information for task \"\(task.title)\" is not present"
                showAlert = true
                return false
            }
        }
        return true
    }
}

struct NewScheduleView_PreviewWrapper: View {
    @State private var scheduleExists = false
    
    var body: some View {
        NewScheduleView(
            schedule: Schedule(startTime: Date(), endTime: Date(), Tasks: []),
            scheduleExists: $scheduleExists,
            onSave: { _ in }
        )
    }
}

#Preview {
    NewScheduleView_PreviewWrapper()
}

