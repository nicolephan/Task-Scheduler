//
//  ViewScheduleView.swift
//  TaskScheduler
//

import SwiftUI

struct ViewScheduleView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    @Binding var path: NavigationPath
    
    @State private var localSchedule: Schedule
    @State private var isEditable = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State var datepickersize: CGSize = .zero
    @Binding var scheduleExists: Bool
    var onSave: (Schedule) -> Void
    
    init(schedule: Schedule, scheduleExists: Binding<Bool>, onSave: @escaping (Schedule) -> Void, path: Binding<NavigationPath>) {
        self._localSchedule = State(initialValue: schedule)
        self.onSave = onSave
        self._scheduleExists = scheduleExists
        self._path = path
    }
    
    var body: some View {
            VStack{
                HStack{     //BUTTONS
                    Button(action: {
                        if isEditable{
                            isEditable = false
                        } else {
                            dismiss()
                        }
                    }) {
                        Image("backButton")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 40)
                            .foregroundColor(.backButtonBG)
                    }
                    Spacer()
                    Button(action: {
                        if isEditable{
                            if validateTimeRange() && validateForm() {
                                path.append(localSchedule)
                            } else {
                                showAlert = true
                            }
                        } else {
                            isEditable.toggle()
                        }
                    }){
                        if isEditable {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40)
                                .foregroundStyle(.blueAccent)
                        } else {
                            Image("editButton")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40)
                                .foregroundStyle(.blueAccent)
                        }

                    }
                }
                .padding(.horizontal, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                let action = isEditable ? "Edit" : "View"
                Text("\(action) Schedule")
                    .font(.custom("Manrope-ExtraBold", size: 32))
                    .foregroundStyle(.text)
                    .padding(.top, -20)
                
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
                                            if isEditable {
                                                DatePicker("", selection: $localSchedule.startTime, displayedComponents: .hourAndMinute)
                                                    .labelsHidden()
                                                    .scaleEffect(1.2)
                                                    .colorMultiply(.clear)
                                            } else {
                                                EmptyView()
                                            }
                                        }
                                        .font(.custom("Manrope-ExtraBold", size: 28))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                VStack {
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 24, height: 19)
                                        .padding(.vertical, -28)
                                        .padding(.trailing, 15)
                                }
                                
                                VStack { // TO TIME
                                    Text("To")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.custom("Manrope-ExtraBold", size: 18))
                                        .foregroundStyle(Color.white.opacity(0.5))
                                    
                                    Text(formattedTime(localSchedule.endTime))
                                        .overlay {
                                            if isEditable {
                                                DatePicker("", selection: $localSchedule.endTime, displayedComponents: .hourAndMinute)
                                                    .labelsHidden()
                                                    .scaleEffect(1.2)
                                                    .colorMultiply(.clear)
                                            } else {
                                                EmptyView()
                                            }
                                        }
                                        .font(.custom("Manrope-ExtraBold", size: 28))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
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
                            
                            if localSchedule.Tasks.isEmpty {
                                VStack {
                                    if isEditable {
                                        HStack {
                                            Button(action: {
                                                let newTask = Task(title: "", exactStart: false, taskDuration: 0, priority: 0, addBreaks: false, breaksEvery: 0, breakDuration: 0, description: "", startTime: Date())
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
                                    } else {
                                        Text("No tasks scheduled")
                                            .font(.custom("Manrope-Bold", size: 18))
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity, minHeight: 44)
                                    }
                                }
                                .padding(30)
                                .background(Color(red: 95/255, green: 149/255, blue: 231/255))
                                .cornerRadius(20)
                                .shadow(radius: 4, x: 0, y: 4)
                            } else {
                                VStack {
                                    ForEach(localSchedule.Tasks.indices, id:\.self){index in
                                        HStack{
                                            TextField("", text: $localSchedule.Tasks[index].title)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 8)
                                                .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.white))
                                                .frame(height: 44)
                                                .foregroundStyle(.text)
                                                .font(.custom("Manrope-Bold", size: 18))
                                                .disabled(!isEditable)
                                            if isEditable{
                                                NavigationLink(
                                                    destination: NewTaskView(
                                                        task: $localSchedule.Tasks[index],
                                                        deleteTask: {
                                                            localSchedule.Tasks.remove(at: index)
                                                        }
                                                    )
                                                ) {
                                                    Image("pencil")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                        .padding(.leading, 10)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                        .padding(.vertical, 3)
                                    }
                                    
                                    if isEditable {
                                        Button(action: {
                                            let newTask = Task(title: "", exactStart: false, taskDuration: 0, priority: 0, addBreaks: false, breaksEvery: 0, breakDuration: 0, description: "", startTime: Date())
                                            
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
                                        .padding(.top, 15)
                                    }
                                }
                                .padding(30)
                                .background(Color(red: 95/255, green: 149/255, blue: 231/255))
                                .cornerRadius(20)
                                .shadow(radius: 4, x: 0, y: 4)
                                
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
                        .padding()
                    }
                }
            }
            .padding(.top, (verticalSizeClass == .compact) ? 100 : 0)
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
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct ViewScheduleView_PreviewWrapper: View {
    @State private var scheduleExists = true
    
    var body: some View {
        let sampleTasks = [
            Task(title: "Task 1", exactStart: false, taskDuration: 60, priority: 1, addBreaks: false, breaksEvery: 0, breakDuration: 0, description: "Description for Task 1", startTime: Date()),
            Task(title: "Task 2", exactStart: false, taskDuration: 30, priority: 2, addBreaks: true, breaksEvery: 15, breakDuration: 5, description: "Description for Task 2", startTime: Date()),
            Task(title: "Task 3", exactStart: false, taskDuration: 90, priority: 0, addBreaks: false, breaksEvery: 0, breakDuration: 0, description: "Description for Task 3", startTime: Date())
        ]
        let sampleSchedule = Schedule(startTime: Date(), endTime: Date().addingTimeInterval(3600), Tasks: sampleTasks)

        ViewScheduleView(
            schedule: sampleSchedule,
            scheduleExists: $scheduleExists,
            onSave: { _ in },
            path: .constant(NavigationPath())
        )
    }
}

#Preview {
    ViewScheduleView_PreviewWrapper()
}
