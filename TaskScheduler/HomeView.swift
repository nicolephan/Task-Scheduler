//
//  HomeView.swift
//  TaskScheduler
//

import SwiftUI

struct HomeView: View {
    
    let hours = Array(0...23)
    
    var body: some View {
        ZStack {
            ScrollViewReader { scrollProxy in
                HStack { // Title
                    Text("Sept 26, 2024")
                        .font(.title)
                        .padding(25)
                        .bold()
                    Spacer()
                }
                
                ScrollView { // Calendar
                    VStack(alignment: .leading) {
                        ForEach(hours, id: \.self) { hour in
                            HStack {
                                Spacer()
                                
                                Text("\(formattedHour(hour))") // Time labels on the left
                                    .frame(width: 60, alignment: .leading)
                                    .foregroundColor(.gray)
                                
                                Rectangle() // Empty hour blocks
                                    .fill(Color.clear)
                                    .frame(height: 60)
                                
                                HStack { // Calendar lines
                                    Spacer()
                                    VStack {
                                        Divider()
                                            .background(Color.gray)
                                            .aspectRatio(contentMode: .fill)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                    // Scroll to 7 AM (which is hour 7) when the view first appears
                    scrollProxy.scrollTo(7, anchor: .top)
                }
            }
            
            VStack { // Plus button
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image("plusCircle")
                            .resizable()
                            .frame(maxWidth: 64, maxHeight: 64)
                            .aspectRatio(contentMode: .fill)
                            .foregroundStyle(Color("accent"))
                            .shadow(radius: CGFloat(4))
                    }
                }
                .padding(.bottom, 70)
                .padding(.trailing, 30)
            }
        }
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
    HomeView()
}
