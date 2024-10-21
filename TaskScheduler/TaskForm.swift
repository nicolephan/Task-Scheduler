//
//  TaskForm.swift
//  TaskScheduler
//

import SwiftUI

struct TaskForm: View {
    
    @Binding var task: Task
    var isEditable: Bool
    @Binding var taskHours: String
    @Binding var taskMins: String
    @Binding var breakDurationHours: String
    @Binding var breakDurationMins: String
    @Binding var breakFrequencyHours: String
    @Binding var breakFrequencyMins: String
    
    var body: some View {
        VStack{
            TextField("Title", text: $task.title)
                .font(.system(size: 25))
                .padding()
                .disabled(!isEditable)
            
            Divider()
                .padding([.leading, .trailing])
            
            Text("Time")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top])
            VStack{
                HStack{
                    Text("Set Exact Start Time")
                    Toggle("", isOn: $task.exactStart)
                        .disabled(!isEditable)
                }
                .padding()
                
                if task.exactStart{
                    HStack{
                        Text("Start Time")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading])
                        DatePicker("", selection: $task.startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .padding(.trailing)
                            .disabled(!isEditable)
                    }
                }
                
                HStack{
                    Text("Duration")
                    Spacer()
                    TextField("xx", text: $taskHours)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 60)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: taskHours) {
                            taskHours = taskHours.filter { "0123456789".contains($0) }
                        }
                        .disabled(!isEditable)
                    Text("h")
                    
                    TextField("xx", text: $taskMins)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 60)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: taskMins) {
                            taskMins = taskMins.filter { "0123456789".contains($0) }
                        }
                        .disabled(!isEditable)
                    Text("m")
                }
                .padding([.bottom, .leading, .trailing])
                
            }
            .background(Color(red:240/255, green:244/255, blue:246/255))
            .cornerRadius(20)
            .padding([.leading, .trailing])
            
            if task.exactStart == false { //PRIORITY
                Text("Priority")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                HStack{
                    Button(action: {
                        task.priority = "Low"
                    }){
                        Text("Low")
                            .padding()
                            .foregroundColor(task.priority == "Low" ? Color.white : Color.black)
                            .background(task.priority == "Low" ? Color.blue : Color.gray.opacity(0.5))
                            .cornerRadius(15)
                    }
                    Button(action: {
                        task.priority = "Medium"
                    }){
                        Text("Medium")
                            .padding()
                            .foregroundColor(task.priority == "Medium" ? Color.white : Color.black)
                            .background(task.priority == "Medium" ? Color.yellow : Color.gray.opacity(0.5))
                            .cornerRadius(15)
                    }
                    Button(action: {
                        task.priority = "High"
                    }){
                        Text("High")
                            .padding()
                            .foregroundColor(task.priority == "High" ? Color.white : Color.black)
                            .background(task.priority == "High" ? Color.red : Color.gray.opacity(0.5))
                            .cornerRadius(15)
                    }
                }
                .disabled(!isEditable)
            }
            
            Text("Breaks")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing])
            VStack{
                HStack{
                    Text("Breaks")
                    Toggle("", isOn: $task.addBreaks)
                        .disabled(!isEditable)
                }
                .padding([.leading, .trailing])
                
                if task.addBreaks{
                    HStack {
                        Text("Breaks Every")
                        Spacer()
                        TextField("xx", text: $breakFrequencyHours)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: 60)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: breakFrequencyHours) {
                                breakFrequencyHours = breakFrequencyHours.filter { "0123456789".contains($0) }
                            }
                            .disabled(!isEditable)
                        Text("h")
                        
                        TextField("xx", text: $breakFrequencyMins)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: 60)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: breakFrequencyMins) {
                                breakFrequencyMins = breakFrequencyMins.filter { "0123456789".contains($0) }
                            }
                            .disabled(!isEditable)
                        Text("m")
                    }
                    HStack {
                        Text("Duration")
                        Spacer()
                        TextField("xx", text: $breakDurationHours)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: 60)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: breakDurationHours) {
                                breakDurationHours = breakDurationHours.filter { "0123456789".contains($0) }
                            }
                            .disabled(!isEditable)
                        Text("h")
                        
                        TextField("xx", text: $breakDurationMins)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: 60)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: breakDurationMins) {
                                breakDurationMins = breakDurationMins.filter { "0123456789".contains($0) }
                            }
                            .disabled(!isEditable)
                        Text("m")
                    }
                    
                }
            }
            .padding()
            .background(Color(red:240/255, green:244/255, blue:246/255))
            .cornerRadius(20)
            .padding([.trailing, .leading])
            
            Text("Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing])
            TextEditor(text: $task.description)
                .padding()
                .background(Color(red:240/255, green:244/255, blue:246/255))
                .cornerRadius(20)
                .frame(minHeight: 100)
                .padding([.trailing, .leading])
                .disabled(!isEditable)
            Spacer()
        }
    }
}

struct TaskForm_Previews: PreviewProvider {
    static var previews: some View {
        @State var exampleTask = Task(
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
        
        @State var taskHours: String = "1"
        @State var taskMins: String = "35"
        @State var breakDurationHours: String = "0"
        @State var breakDurationMins: String = "10"
        @State var breakFrequencyHours: String = "0"
        @State var breakFrequencyMins: String = "20"
        
        TaskForm(
            task: $exampleTask,
            isEditable: true,
            taskHours: $taskHours,
            taskMins: $taskMins,
            breakDurationHours: $breakDurationHours,
            breakDurationMins: $breakDurationMins,
            breakFrequencyHours: $breakFrequencyHours,
            breakFrequencyMins: $breakFrequencyMins
        )
    }
}
