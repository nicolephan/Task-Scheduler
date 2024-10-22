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
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                Text("New Task")
                    .font(.title2).bold()
                Spacer()
                
                Button(action: {
                    saveTask()
                }){
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40)
                }
            }   //BUTTONS END
            .padding(20)
            Spacer().frame(maxHeight: 15)
            
            TaskForm(task: $localTask, isEditable: true, taskHours: $taskHours, taskMins: $taskMins, breakDurationHours: $breakDurationHours, breakDurationMins: $breakDurationMins, breakFrequencyHours: $breakFrequencyHours, breakFrequencyMins: $breakFrequencyMins)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveTask(){
        task.title = localTask.title
                task.exactStart = localTask.exactStart
                task.startTime = localTask.startTime
        task.taskDuration = (Int(taskHours) ?? 0) * 60 + (Int(taskMins) ?? 0)
        if task.addBreaks{
            task.breakDuration = (Int(breakDurationHours) ?? 0) * 60 + (Int(breakDurationMins) ?? 0)
            task.breaksEvery = (Int(breakFrequencyHours) ?? 0) * 60 + (Int(breakFrequencyMins) ?? 0)
        }
        task.priority = localTask.priority
                task.addBreaks = localTask.addBreaks
                task.description = localTask.description
        
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
