//
//  NewTaskView.swift
//  TaskScheduler
//

import SwiftUI

struct NewTaskView: View {
    
    @State private var taskName: String = ""
    @State private var durationHours: String = ""
    @State private var durationMins: String = ""
    @State private var desc: String = ""
    @State private var selectedPriority: String = "Low"
    
    @State private var isExactTime: Bool = false
    @State private var isBreaks: Bool = false
    
    @State private var startTime = Date()
    
    var body: some View {
        
        HStack{     //BUTTONS
            Button(action: {
                
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
                
            }){
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 40)
            }
        }   //BUTTONS END
        .padding(20)
        Spacer().frame(maxHeight: 15)
        
        TextField("Title", text: $taskName)
            .font(.system(size: 25))
            .padding()
        
        Divider()
            .padding([.leading, .trailing])
        
        Text("Time")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])
        VStack{
            HStack{
                Text("Set Exact Start Time")
                Toggle("", isOn: $isExactTime)
            }
            .padding()
            
            if isExactTime == true{
                HStack{
                    Text("Start Time")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading])
                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(.trailing)
                }
            }
            
            HStack{
                Text("Duration")
                //ADD DURATION
                Spacer()
            }
            .padding([.bottom, .leading, .trailing])
            
        }
        .background(Color(red:240/255, green:244/255, blue:246/255))
        .cornerRadius(20)
        .padding([.leading, .trailing])

        if isExactTime == false { //PRIORITY
            Text("Priority")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            HStack{
                Button(action: {
                    selectedPriority = "Low"
                }){
                    Text("Low")
                        .padding()
                        .foregroundColor(selectedPriority == "Low" ? Color.white : Color.black)
                        .background(selectedPriority == "Low" ? Color.blue : Color.gray.opacity(0.5))
                        .cornerRadius(15)
                }
                Button(action: {
                    selectedPriority = "Medium"
                }){
                    Text("Medium")
                        .padding()
                        .foregroundColor(selectedPriority == "Medium" ? Color.white : Color.black)
                        .background(selectedPriority == "Medium" ? Color.yellow : Color.gray.opacity(0.5))
                        .cornerRadius(15)
                }
                Button(action: {
                    selectedPriority = "High"
                }){
                    Text("High")
                        .padding()
                        .foregroundColor(selectedPriority == "High" ? Color.white : Color.black)
                        .background(selectedPriority == "High" ? Color.red : Color.gray.opacity(0.5))
                        .cornerRadius(15)
                }
            }
        }
        
        Text("Breaks")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .leading, .trailing])
        VStack{
            HStack{
                Text("Breaks")
                Toggle("", isOn: $isBreaks)
            }
            .padding([.leading, .trailing])
            
            if isBreaks == true{
                Text("Breaks Every")
                Text("Duration")
            }
        }
        .padding()
        .background(Color(red:240/255, green:244/255, blue:246/255))
        .cornerRadius(20)
        .padding([.trailing, .leading])
        
        Text("Description")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .leading, .trailing])
        TextEditor(text: $desc)
            .padding()
            .background(Color(red:240/255, green:244/255, blue:246/255))
            .cornerRadius(20)
            .padding([.trailing, .leading])
        
        
        Spacer()
    }
}

#Preview {
    NewTaskView()
}
