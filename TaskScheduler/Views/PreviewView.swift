//
//  PreviewView.swift
//  TaskScheduler
//

import SwiftUI

struct PreviewView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var schedule: Schedule
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
                    // TODO: Add task to calendar
                    
                    scheduleExists = true
                    onSave(schedule)
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
            
            CalendarView {
                EmptyView()
            }
        }
    }
}

#Preview {
    PreviewView(schedule: Schedule(startTime: Date(), endTime: Date(), Tasks: []), scheduleExists: .constant(false), onSave: {_ in })
}
