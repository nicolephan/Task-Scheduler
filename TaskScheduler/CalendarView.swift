//
//  CalendarView.swift
//  TaskScheduler
//

import SwiftUI

struct CalendarView<Content: View>: View {
    
    let hours = Array(0...23)
    let heightPerHour = 60
    let lineHeight = 2 // Height of calendar lines
    
    var customOverlay: () -> Content // Accept any custom content
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView { // Calendar
                ZStack {
                    VStack(spacing: -24.7) {
                        ForEach(hours, id: \.self) { hour in
                            HStack() {
                                Spacer()
                                
                                Text("\(formattedHour(hour))") // Time labels on the left
                                    .frame(width: 60, alignment: .leading)
                                    .font(.custom("Manrope-ExtraBold", size: 18))
                                    .foregroundColor(.text)
                                    .opacity(0.7)
                                
                                Rectangle() // Calendar lines
                                    .fill(.text)
                                    .frame(height: CGFloat(lineHeight))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .opacity(0.1)
                            }
                            .padding(.bottom, 60)
                        }
                    }
                    .padding()
                    
                    
                    HStack { // TODO: Example task block
                        Spacer()
                            .frame(width: 60)
                            .padding()
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.blue)
                            .frame(height: CGFloat(heightPerHour)) // height will change
                            .offset(x: -10, y: 30) // y will change. y = -690 for 12 AM, y = 690 for 11 PM
                    }
                    
                    customOverlay() // Inject red marker in HomeView
                }
            }
            .onAppear {
                // Scroll to 7 AM when the view first appears
                scrollProxy.scrollTo(7, anchor: .top)
            }
        }
        .padding(.leading, -5)
    } // view ends
    
    func formattedHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // 'h a' formats as 12-hour time (1 PM, 2 AM, etc.)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        let date = Calendar.current.date(from: dateComponents)!
        
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView {
        EmptyView()
    }
}
