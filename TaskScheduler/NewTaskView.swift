//
//  NewTaskView.swift
//  TaskScheduler
//

import SwiftUI

struct NewTaskView: View {
    
    @State private var tasks: [Task] = []
    
    @State private var newTask = Task(
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
            
            TaskForm(task: $newTask, isEditable: true, taskHours: $taskHours, taskMins: $taskMins, breakDurationHours: $breakDurationHours, breakDurationMins: $breakDurationMins, breakFrequencyHours: $breakFrequencyHours, breakFrequencyMins: $breakFrequencyMins)
        }
    }
    
    private func saveTask(){
        let taskDuration = (Int(taskHours) ?? 0) * 60 + (Int(taskMins) ?? 0)
        
        if newTask.addBreaks{
            newTask.breakDuration = (Int(breakDurationHours) ?? 0) * 60 + (Int(breakDurationMins) ?? 0)
            newTask.breaksEvery = (Int(breakFrequencyHours) ?? 0) * 60 + (Int(breakFrequencyMins) ?? 0)
        }
        
        let newTaskEntry = Task(
            title: newTask.title,
            exactStart: newTask.exactStart,
            taskDuration: taskDuration,
            priority: newTask.priority,
            addBreaks: newTask.addBreaks,
            breaksEvery: newTask.breaksEvery,
            breakDuration: newTask.breakDuration,
            description: newTask.description,
            startTime: newTask.startTime
        )
        tasks.append(newTaskEntry)
    }
}

#Preview {
    NewTaskView()
}
