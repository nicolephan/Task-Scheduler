//
//  PreviewView.swift
//  TaskScheduler
//
//  Created by Vanessa Huynh on 10/23/24.
//

import SwiftUI

struct PreviewView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                
                dismiss()
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

#Preview {
    PreviewView()
}
