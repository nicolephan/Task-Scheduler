//
//  PreviewView.swift
//  TaskScheduler
//

import SwiftUI

struct PreviewView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var taskManager: TaskManager
    var localSchedule: Schedule // localSchedule received from NewSchedule
    @Binding var scheduleExists: Bool
    var onSave: (Schedule) -> Void
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                    var exceedsEndTime = false
                    
                    for task in localSchedule.Tasks {
                        let taskEndTime = task.startTime.addingTimeInterval(TimeInterval(task.taskDuration * 60))
                        if taskEndTime > localSchedule.endTime {
                            exceedsEndTime = true
                            break
                        }
                    }
                    
                    if exceedsEndTime {
                        alertMessage = "Tasks exceed the schedule's end time. Please adjust or continue anyway."
                        showAlert = true
                    } else {
                        saveSchedule()
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
            .navigationBarBackButtonHidden(true)
            
            Spacer()
            
            CalendarView(isInteractive: false, schedule: localSchedule, taskManager: taskManager) {
                EmptyView()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Not enough time for all tasks"),
                message: Text(alertMessage),
                primaryButton: .default(Text("Continue"), action: {
                    saveSchedule()
                }),
                secondaryButton: .cancel(Text("Back"))
            )
        }
    } // view ends
    
    private func saveSchedule() {
        scheduleExists = true
        taskManager.schedule = localSchedule // Commit changes
        onSave(localSchedule)
    }
}

#Preview {
    PreviewView(taskManager: TaskManager(), localSchedule: Schedule(startTime: Date(), endTime: Date(), Tasks: []), scheduleExists: .constant(false), onSave: {_ in })
}
