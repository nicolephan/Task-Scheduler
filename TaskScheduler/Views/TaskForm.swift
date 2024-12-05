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
    
    var onValidationError:((String) -> Void)?
    
    var body: some View {
        VStack{
            TextField("Title", text: $task.title)
                .font(.custom("Manrope-ExtraBold", size: 24))
                .foregroundStyle(.text)
                .padding(.horizontal)
                .disabled(!isEditable)
            
            Divider()
                .padding([.leading, .trailing])
            
            Text("Time")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top])
                .font(.custom("Manrope-ExtraBold", size: 18))
                .foregroundStyle(.text)
            
            VStack(spacing: 5) {
                HStack{
                    Text("Set Exact Start Time")
                        .font(.custom("Manrope-Bold", size: 18))
                        .foregroundStyle(.text)
                        .frame(width: 200, alignment: .leading)
                        .padding(.leading, 5)
                    
                    Toggle("", isOn: $task.exactStart)
                        .disabled(!isEditable)
                }
                .padding()
                
                if task.exactStart {
                    HStack{
                        Text("Start Time")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading])
                            .font(.custom("Manrope-Bold", size: 18))
                            .foregroundStyle(.text)
                            .padding(.leading, 5)
                        
                        Text(formattedTime(task.startTime))
                            .overlay {
                                DatePicker("", selection: $task.startTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .disabled(!isEditable)
                                    .colorMultiply(.clear)
                            }
                            .font(.custom("Manrope-ExtraBold", size: 18))
                            .foregroundStyle(.blueAccent)
                            .padding(.horizontal)
                    }
                }
                
                HStack(){
                    HStack {
                        Text("Duration")
                            .font(.custom("Manrope-Bold", size: 18))
                            .foregroundStyle(.text)
                        Text("*")
                            .font(.custom("Manrope-Bold", size: 18))
                            .foregroundColor(.redAccent)
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                    TextField("xx", text: $taskHours)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 60)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: taskHours) {
                            taskHours = taskHours.filter { "0123456789".contains($0) }
                        }
                        .disabled(!isEditable)
                        .font(.custom("Manrope-ExtraBold", size: 18))
                        .foregroundStyle(.blueAccent)
                    Text("h")
                        .font(.custom("Manrope-ExtraBold", size: 18))
                        .foregroundStyle(.blueAccent)
                    
                    
                    TextField("xx", text: $taskMins)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 60)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: taskMins) {
                            taskMins = taskMins.filter { "0123456789".contains($0) }
                        }
                        .disabled(!isEditable)
                        .font(.custom("Manrope-ExtraBold", size: 18))
                        .foregroundStyle(.blueAccent)
                    Text("m")
                        .font(.custom("Manrope-ExtraBold", size: 18))
                        .foregroundStyle(.blueAccent)
                }
                .padding(task.exactStart ? [.all] : [.horizontal, .bottom])
                
            }
            .background(Color(red:240/255, green:244/255, blue:246/255))
            .cornerRadius(20)
            .padding([.leading, .trailing])
            
            if task.exactStart == false { //PRIORITY
                Text("Priority")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal, .top])
                    .font(.custom("Manrope-ExtraBold", size: 18))
                    .foregroundStyle(.text)
                
                HStack {
                    Button(action: {
                        task.priority = 0
                    }){
                        Text("Low")
                            .frame(width: 60, height: 16)
                            .padding()
                            .foregroundColor(task.priority == 0 ? Color.white : .text)
                            .background(task.priority == 0 ? .blueAccent : .card)
                            .cornerRadius(15)
                            .font(.custom("Manrope-Bold", size: 18))
                        
                    }
                    
                    Button(action: {
                        task.priority = 1
                    }){
                        Text("Medium")
                            .frame(width: 80, height: 16)
                            .padding()
                            .foregroundColor(task.priority == 1 ? Color.white : .text)
                            .background(task.priority == 1 ? .orangeAccent : .card)
                            .cornerRadius(15)
                            .font(.custom("Manrope-Bold", size: 18))
                    }
                    
                    Button(action: {
                        task.priority = 2
                    }){
                        Text("High")
                            .frame(width: 60, height: 16)
                            .padding()
                            .foregroundColor(task.priority == 2 ? Color.white : .text)
                            .background(task.priority == 2 ? .redAccent : .card)
                            .cornerRadius(15)
                            .font(.custom("Manrope-Bold", size: 18))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .disabled(!isEditable)
            }
            
            Text("Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing])
                .font(.custom("Manrope-Bold", size: 18))
                .foregroundStyle(.text)
            TextEditor(text: $task.description)
                .padding()
                .scrollContentBackground(.hidden)
                .background(.card)
                .cornerRadius(20)
                .frame(minHeight: 100)
                .padding([.trailing, .leading])
                .font(.custom("Manrope-Medium", size: 16))
                .foregroundStyle(.text)
                .disabled(!isEditable)
            Spacer()
        }
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    func validateTask() -> Bool{
        if task.title == ""{
            onValidationError?("Task title cannot be empty.")
            return false
        }
        
        let taskDuration = (Int(taskHours) ?? 0) * 60 + (Int(taskMins) ?? 0)
        
        if taskDuration == 0{
            onValidationError?("Task duration cannot be zero.")
            return false
        }

        return true
    }
}

struct TaskForm_Previews: PreviewProvider {
    static var previews: some View {
        @State var exampleTask = Task(
            title: "Complete Beta App",
            exactStart: false,
            taskDuration: 95,
            priority: 2,
            description: "Work on the Beta App. Add a new schedule viewing page. Add errors and alerts. Update and add new features to ensure finished product by deadline. blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
            startTime: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
        )
        
        @State var taskHours: String = "1"
        @State var taskMins: String = "35"
        
        TaskForm(
            task: $exampleTask,
            isEditable: true,
            taskHours: $taskHours,
            taskMins: $taskMins
        )
    }
}
