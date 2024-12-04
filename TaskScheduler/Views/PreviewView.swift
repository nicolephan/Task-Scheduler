//
//  PreviewView.swift
//  TaskScheduler
//

import SwiftUI

struct PreviewView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var taskManager: TaskManager
    var tempSchedule: Schedule
    @Binding var scheduleExists: Bool
    var onSave: (Schedule) -> Void
    
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
                Text("Preview")
                    .font(.custom("Manrope-ExtraBold", size: 24))
                    .foregroundStyle(.text)
                Spacer()
                
                Button(action: {
                    scheduleExists = true
                    taskManager.schedule = tempSchedule // Commit changes
                    onSave(tempSchedule)
                }){
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40)
                        .foregroundStyle(.blueAccent)
                }
            }   //BUTTONS END
            .padding(20)
            .navigationBarBackButtonHidden(true)
            
            Spacer()
            
            CalendarView(isInteractive: false, tasks: tempSchedule.Tasks, taskManager: taskManager) {
                EmptyView()
            }
        }
    }
}

//#Preview {
//    PreviewView(taskManager: TaskManager(), scheduleExists: .constant(false), onSave: {_ in })
//}
