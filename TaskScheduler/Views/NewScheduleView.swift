//
//  NewScheduleView.swift
//  TaskScheduler
//

import SwiftUI

struct NewScheduleView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var path: NavigationPath
    
    @ObservedObject var taskManager: TaskManager
    
    @State private var localSchedule: Schedule
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State var datepickersize: CGSize = .zero
    @Binding var scheduleExists: Bool
    
    init(taskManager: TaskManager, scheduleExists: Binding<Bool>, path: Binding<NavigationPath>) {
        self.taskManager = taskManager
        self._scheduleExists = scheduleExists
        self._path = path
        
        let scheduleCopy = taskManager.schedule
        var modifiedSchedule = scheduleCopy
        modifiedSchedule.endTime = Calendar.current.date(byAdding: .hour, value: 1, to: modifiedSchedule.startTime) ?? modifiedSchedule.startTime
        let emptyTask = Task(
            title: "",
            exactStart: false,
            taskDuration: 0,
            priority: "Low",
            addBreaks: false,
            breaksEvery: 0,
            breakDuration: 0,
            description: "",
            startTime: modifiedSchedule.startTime
        )
        if modifiedSchedule.Tasks.isEmpty {
            modifiedSchedule.Tasks.append(emptyTask)
        }
        
        self._localSchedule = State(initialValue: modifiedSchedule)
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
                        if validateTimeRange() && validateForm() {
                            taskManager.schedule = localSchedule
                            path.append(localSchedule) // Send schedule to Preview to be finalized
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
                    Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
                                    
                                    Text(formattedTime(localSchedule.startTime))
                                        .overlay {
                                            DatePicker("", selection: $localSchedule.startTime, displayedComponents: .hourAndMinute)
                                                .labelsHidden()
                                                .scaleEffect(1.2)
                                                .colorMultiply(.clear)
                                        }
                                        .font(.custom("Manrope-ExtraBold", size: 28))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } // FROM TIME
                                
                                VStack { // arrow
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 24, height: 19)
                                        .padding(.vertical, -28)
                                        .padding(.trailing, 15)
                                } // arrow
                                
                                VStack { // TO TIME
                                    Text("To")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.custom("Manrope-ExtraBold", size: 18))
                                        .foregroundStyle(Color.white.opacity(0.5))
                                    
                                    Text(formattedTime(localSchedule.endTime))
                                        .overlay {
                                            DatePicker("", selection: $localSchedule.endTime, displayedComponents: .hourAndMinute)
                                                .labelsHidden()
                                                .scaleEffect(1.2)
                                                .colorMultiply(.clear)
                                        }
                                        .font(.custom("Manrope-ExtraBold", size: 28))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } // TO TIME
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
                                    .padding(.vertical, 3)
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
                                    .padding(.top, 5)
                                    
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
    
    private func validateTimeRange() -> Bool {
        if localSchedule.endTime < localSchedule.startTime {
            alertMessage = "Start time cannot be later than the end time. Please adjust the times to continue."
            showAlert = true
            return false
        }
        return true
    }
    
    private func validateForm() -> Bool{
        for(index, task) in localSchedule.Tasks.enumerated(){
            if task.title == "" {
                alertMessage = "Required information for task \(index + 1) is not present"
                showAlert = true
                return false
            }
            if task.taskDuration == 0 || (task.addBreaks && task.breaksEvery == 0) || (task.addBreaks && task.breakDuration == 0){
                alertMessage = "Required information for task \"\(task.title)\" is not present"
                showAlert = true
                return false
            }
        }
        return true
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct NewScheduleView_PreviewWrapper: View {
    @State private var scheduleExists = false
    
    var body: some View {
        NewScheduleView(
            taskManager: TaskManager(),
            scheduleExists: $scheduleExists,
            path: .constant(NavigationPath())
        )
    }
}

#Preview {
    NewScheduleView_PreviewWrapper()
}

