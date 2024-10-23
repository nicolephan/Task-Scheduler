//
//  NewTaskView.swift
//  TaskScheduler
//

import SwiftUI

struct NewTaskView: View {
    
    @Binding var task: Task
    @State private var localTask: Task
        
    init(task: Binding<Task>) {
        self._task = task
        self._localTask = State(initialValue: task.wrappedValue)
    }
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var taskHours: String = ""
    @State private var taskMins: String = ""
    @State private var breakDurationHours: String = ""
    @State private var breakDurationMins: String = ""
    @State private var breakFrequencyHours: String = ""
    @State private var breakFrequencyMins: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView{
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
               
               if task.addBreaks {
                   breakDurationHours = String(task.breakDuration / 60)
                   breakDurationMins = String(task.breakDuration % 60)
                   breakFrequencyHours = String(task.breaksEvery / 60)
                   breakFrequencyMins = String(task.breaksEvery % 60)
               }
           }
            Spacer().frame(maxHeight: 15)
            
            TaskForm(task: $localTask, isEditable: true, taskHours: $taskHours, taskMins: $taskMins, breakDurationHours: $breakDurationHours, breakDurationMins: $breakDurationMins, breakFrequencyHours: $breakFrequencyHours, breakFrequencyMins: $breakFrequencyMins,
                onValidationError: {error in
                    alertMessage = error
                    showAlert = true
                }
            )
            .onAppear {
               let totalDuration = task.taskDuration
               taskHours = String(totalDuration / 60)
               taskMins = String(totalDuration % 60)
               
               if task.addBreaks {
                   breakDurationHours = String(task.breakDuration / 60)
                   breakDurationMins = String(task.breakDuration % 60)
                   breakFrequencyHours = String(task.breaksEvery / 60)
                   breakFrequencyMins = String(task.breaksEvery % 60)
               }
           }
            .padding(.horizontal, 8)
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateTask() -> Bool {
        let taskForm = TaskForm(
            task: $localTask,
            isEditable: true,
            taskHours: $taskHours,
            taskMins: $taskMins,
            breakDurationHours: $breakDurationHours,
            breakDurationMins: $breakDurationMins,
            breakFrequencyHours: $breakFrequencyHours,
            breakFrequencyMins: $breakFrequencyMins,
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
        task.addBreaks = localTask.addBreaks
        task.priority = localTask.priority
        task.description = localTask.description
        
        if task.addBreaks{
            task.breakDuration = (Int(breakDurationHours) ?? 0) * 60 + (Int(breakDurationMins) ?? 0)
            task.breaksEvery = (Int(breakFrequencyHours) ?? 0) * 60 + (Int(breakFrequencyMins) ?? 0)
        }
        
        dismiss()
    }
}

#Preview {
    NewTaskView(task: .constant(Task(
        title: "Sample Task",
        exactStart: false,
        taskDuration: 0,
        priority: "Low",
        addBreaks: false,
        breaksEvery: 0,
        breakDuration: 0,
        description: "",
        startTime: Date()
    )))
}
