//
//  NewScheduleView.swift
//  TaskScheduler
//

import SwiftUI

struct NewScheduleView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var fromTime = Date()
    @State private var toTime = Date()
    @State private var tasks: [Task] = [Task(title: "", exactStart: false, taskDuration: 0, priority: "Low", addBreaks: false, breaksEvery: 0, breakDuration: 0, description: "", startTime: Date())]
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State var datepickersize: CGSize = .zero
    @Binding var scheduleExists: Bool
    
    var body: some View {
        NavigationView{
            VStack{
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
                    Button(action: {
                        if validateForm() {
                            scheduleExists = true
                            dismiss()
                        }
                    }){
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 40)
                    }
                }   //BUTTONS END
                .padding(20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Task"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Text("New Schedule")
                    .font(.largeTitle)
                
                VStack{
                    Text("Time range")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                    
                    
                    
                    HStack{
                        VStack{ // FROM TIME
                            Text("From")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            GeometryReader { geo in
                                DatePicker("", selection: $fromTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .scaleEffect(x: geo.size.width / datepickersize.width, y: geo.size.width / datepickersize.width, anchor: .topLeading)
                                    .onChange(of: fromTime) {
                                        if fromTime > toTime {
                                            toTime = fromTime
                                        }
                                    }
                            }
                        }
                        
                        Image(systemName: "arrow.right")
                        
                        VStack{ // TO TIME
                            Text("To")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            GeometryReader { geo in
                                DatePicker("", selection: $toTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .scaleEffect(x: geo.size.width / datepickersize.width, y: geo.size.width / datepickersize.width, anchor: .topLeading)
                                    .onChange(of: toTime) {
                                        if toTime < fromTime {
                                            fromTime = toTime
                                        }
                                    }
                            }
                        }
                    }
                    .padding(30)
                    .foregroundColor(.white)
                    .background(Color(red: 95/255, green: 149/255, blue: 231/255))
                    .cornerRadius(20)
                    .frame(height: 150)
                    
                    
                    Text("Tasks")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .padding()
                    VStack{
                        
                        ForEach(tasks.indices, id:\.self){index in
                            HStack{
                                TextField("", text: $tasks[index].title)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(height: 40)
                                
                                NavigationLink(destination: NewTaskView(task: $tasks[index])) {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.leading, 10)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(5)
                        }
                        
                        HStack{
                            Button(action: {
                                let newTask = Task(title: "", exactStart: false, taskDuration: 0, priority: "Low", addBreaks: false, breaksEvery: 0, breakDuration: 0, description: "", startTime: Date())

                                tasks.append(newTask)
                            }) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .background(Color(red: 68/255, green: 115/255, blue: 207/255))
                                    .cornerRadius(10)
                            }
                            .padding(.top)
                            
                            Spacer()
                                .frame(width: 40)
                        }
                        
                    }
                    .padding(30)
                    .background(Color(red: 95/255, green: 149/255, blue: 231/255))
                    .cornerRadius(20)
                    
                }
                .padding()
                
                // INVISIBLE DATEPICKER FOR RESIZE
                DatePicker("", selection: $fromTime, displayedComponents: .hourAndMinute)
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
    
    private func validateForm() -> Bool{
        for(index, task) in tasks.enumerated(){
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
}

#Preview {
    NewScheduleView(scheduleExists: .constant(false))
}
