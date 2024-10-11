//
//  NewScheduleView.swift
//  TaskScheduler
//

import SwiftUI

struct NewScheduleView: View {
    
    @State private var fromTime = Date()
    @State private var toTime = Date()
    @State private var tasks: [String] = [""]
    
    @State var datepickersize: CGSize = .zero
    
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
            Button(action: {
                
            }){
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 40)
            }
        }   //BUTTONS END
        .padding(20)
        
        
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
                    }
                }
                
                Image(systemName: "arrow.right")
                    
                VStack{ // TO TIME
                    Text("To")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    GeometryReader { geo in
                        DatePicker("", selection: $fromTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .scaleEffect(x: geo.size.width / datepickersize.width, y: geo.size.width / datepickersize.width, anchor: .topLeading)
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
                        TextField("", text: $tasks[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            
                        }){
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.leading, 10)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(5)
                }
                
                
                Button(action: {
                    tasks.append("")
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                .frame(width: 250, height: 50)
                .background(Color(red: 68/255, green: 115/255, blue: 207/255))
                .cornerRadius(10)
                .padding(.top)
                
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

#Preview {
    NewScheduleView()
}
