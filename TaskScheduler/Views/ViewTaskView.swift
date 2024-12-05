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
    
    var deleteTask: (() -> Void)?

    var task: Task {
        didSet {
            self.editedTask = task
        }
    }
    
    init(task: Task, deleteTask: (() -> Void)? = nil) {
        self.task = task
        self._editedTask = State(initialValue: task)
        self.deleteTask = deleteTask
    }
    
    var taskHour: String{
        let hours = task.taskDuration / 60
        return String(hours)
    }
    var taskMin: String{
        let min = task.taskDuration % 60
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
                    taskMins: .constant(taskMin)
                )
                Spacer()
                
                if isEditable {
                    Button(action: {
                        showAlert = true
                    }) {
                        Text("Delete Task")
                            .font(.system(size: 18)).bold()
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.redAccent)
                            .cornerRadius(15)
                    }
                    .padding()
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                self.editedTask = task
            }
            .alert(isPresented: $showAlert) {
                if alertMessage.isEmpty{
                    return Alert(
                        title: Text("Delete Task"),
                        message: Text("Are you sure you want to delete this task?"),
                        primaryButton: .destructive(Text("Delete")) {
                            deleteTask?()
                            dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                } else {
                    return Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    private func validateTask() -> Bool{
        let taskForm = TaskForm(
            task: $editedTask,
            isEditable: isEditable,
            taskHours: .constant(taskHour),
            taskMins: .constant(taskMin),
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
            priority: 2,
            description: "Work on the Beta App. Add a new schedule viewing page. Add errors and alerts. Update and add new features to ensure finished product by deadline. blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
            startTime: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
        )
    
    ViewTaskView(task: exampleTask)
}
