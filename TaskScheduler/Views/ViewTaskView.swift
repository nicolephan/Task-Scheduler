//
//  ViewTaskView.swift
//  TaskScheduler
//

import SwiftUI

struct ViewTaskView: View {

    @State private var isEditable = false
    @State private var editedTask: Task
    @State private var showAlert = false
    @State private var alertMessage = ""

    var task: Task {
        didSet {
            self.editedTask = task
        }
    }
    
    init(task: Task) {
        self.task = task
        self._editedTask = State(initialValue: task)
    }
    
    var taskHour: String{
        let hours = task.taskDuration / 60
        return String(hours)
    }
    var taskMin: String{
        let min = task.taskDuration % 60
        return String(min)
    }
    var breakHour: String{
        let hours = task.breakDuration / 60
        return String(hours)
    }
    var breakMin: String{
        let min = task.breakDuration % 60
        return String(min)
    }
    var BreaksEveryHour: String{
        let hours = task.breaksEvery / 60
        return String(hours)
    }
    var BreaksEveryMin: String{
        let min = task.breaksEvery % 60
        return String(min)
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack{     //BUTTONS
                Button(action: {
                    if isEditable{
                        isEditable.toggle()
                    } else {
                        dismiss()
                    }
                }) {
                    Image("backButton")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                let action = isEditable ? "Edit" : "View"
                Text("\(action) Task")
                    .font(.custom("Manrope-ExtraBold", size: 24))
                    .foregroundStyle(.text)
                Spacer()
                
                Button(action: {
                    if isEditable{
                        if validateTask(){
                            isEditable.toggle()
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
            }   //BUTTONS END
            .padding([.horizontal, .bottom], 20)
            Spacer().frame(maxHeight: 15)
            
            ScrollView{
                TaskForm(
                    task: $editedTask,
                    isEditable: isEditable,
                    taskHours: .constant(taskHour),
                    taskMins: .constant(taskMin),
                    breakDurationHours: .constant(breakHour),
                    breakDurationMins: .constant(breakMin),
                    breakFrequencyHours: .constant(BreaksEveryHour),
                    breakFrequencyMins: .constant(BreaksEveryMin)
                )
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                self.editedTask = task
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func validateTask() -> Bool{
        let taskForm = TaskForm(
            task: $editedTask,
            isEditable: isEditable,
            taskHours: .constant(taskHour),
            taskMins: .constant(taskMin),
            breakDurationHours: .constant(breakHour),
            breakDurationMins: .constant(breakMin),
            breakFrequencyHours: .constant(BreaksEveryHour),
            breakFrequencyMins: .constant(BreaksEveryMin),
            onValidationError: { message in
                alertMessage = message
                showAlert = true
            }
        )
        return taskForm.validateTask()
    }
}

#Preview {
    
    let exampleTask = Task(
            title: "Complete Beta App",
            exactStart: false,
            taskDuration: 95,
            priority: "High",
            addBreaks: true,
            breaksEvery: 20,
            breakDuration: 10,
            description: "Work on the Beta App. Add a new schedule viewing page. Add errors and alerts. Update and add new features to ensure finished product by deadline. blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
            startTime: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
        )
    
    ViewTaskView(task: exampleTask)
}