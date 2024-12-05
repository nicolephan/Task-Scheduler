//
//  NewTaskView.swift
//  TaskScheduler
//

import SwiftUI

struct NewTaskView: View {
    
    @Binding var task: Task
    @State private var localTask: Task
    
    var deleteTask: (() -> Void)?
        
    init(task: Binding<Task>, deleteTask: (() -> Void)? = nil) {
        self._task = task
        self._localTask = State(initialValue: task.wrappedValue)
        self.deleteTask = deleteTask
    }
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var taskHours: String = ""
    @State private var taskMins: String = ""
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        VStack {
            HStack{     //BUTTONS
                Button(action: {
                    dismiss()
                }) {
                    Image("backButton")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                Text("New Task")
                    .font(.custom("Manrope-ExtraBold", size: 24))
                    .foregroundStyle(.text)
                Spacer()
                
                Button(action: {
                    if validateTask() {
                        saveTask()
                    }
                }){
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40)
                        .foregroundStyle(.blueAccent)
                }
            }   //BUTTONS END
            .padding(20)
            .onAppear {
                let totalDuration = task.taskDuration
                taskHours = String(totalDuration / 60)
                taskMins = String(totalDuration % 60)
            }
            Spacer().frame(maxHeight: 15)
            
            ScrollView{
                TaskForm(task: $localTask, isEditable: true, taskHours: $taskHours, taskMins: $taskMins,
                         onValidationError: {error in
                    alertMessage = error
                    showAlert = true
                }
                )
                .onAppear {
                    let totalDuration = task.taskDuration
                    taskHours = String(totalDuration / 60)
                    taskMins = String(totalDuration % 60)
                }
                .padding(.horizontal, 8)
                
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
            .navigationBarBackButtonHidden(true)
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
    
    private func validateTask() -> Bool {
        let taskForm = TaskForm(
            task: $localTask,
            isEditable: true,
            taskHours: $taskHours,
            taskMins: $taskMins,
            onValidationError: { error in
                alertMessage = error
                showAlert = true
            }
        )
        
        return taskForm.validateTask()
    }
    
    private func saveTask(){
        task.title = localTask.title
        task.exactStart = localTask.exactStart
        task.startTime = localTask.startTime
        task.taskDuration = (Int(taskHours) ?? 0) * 60 + (Int(taskMins) ?? 0)
        task.priority = localTask.priority
        task.description = localTask.description
        
        dismiss()
    }
}

#Preview {
    NewTaskView(task: .constant(Task(
        title: "Sample Task",
        exactStart: false,
        taskDuration: 0,
        priority: 0,
        description: "",
        startTime: Date()
    )))
}
