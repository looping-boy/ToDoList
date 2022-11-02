//
//  ListRowView.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 24/10/2022.
//

import SwiftUI

struct ListRowView: View {
    
    @State var width: CGFloat = 50
    @State var horizontal: CGFloat = 0
    @State var gradient: CGFloat = 0
    @State var opacity: CGFloat = 0
    
    var item: ItemModel
    var row: Double
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    private let color2: Color = #colorLiteral(red: 0.1442833841, green: 0.5322987437, blue: 0.9596691728, alpha: 1)
    private let color1: Color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    
    @State private var animatingButton = false
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.7)
                    
                    HStack {
                        
                        Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                            .foregroundColor(item.isCompleted ? .green : .red)
                        //                        .onTapGesture(perform: updateCompletion)
                            .frame(maxWidth: 28, alignment: .leading)
                        
                        Text(item.title)
                            .keyboardType(.default)
                        //                        .multilineTextAlignment(.leading)
                        //                        .frame(alignment: .leading)
                            .frame(maxWidth: width, alignment: .leading)
                        //                    Spacer()
                            .mask(
                                LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: gradient, y: 0))
                            )
                        
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, horizontal)
                    
                }
                .cornerRadius(25)
                .font(.title2)
                .frame(height: 50)
            }
            .frame(width: width)
            .opacity(opacity)
            .onAppear {
                let animation1 = Animation.easeInOut(duration: 1).speed(4).delay(row * 0.05)
                let animation2 = Animation.easeInOut(duration: 1).speed(28).delay(row * 0.05)
                let animation3 = Animation.easeInOut(duration: 1).speed(2).delay(row * 0.05)
                
                withAnimation(animation1) {
                    width = .infinity
                    horizontal = 20
                }
                
                withAnimation(animation2) {
                    gradient = 2
                }
                
                withAnimation(animation3) {
                    opacity = 1
                }
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .leading
          )
        
    }
    
    func updateCompletion() {
        listViewModel.updateItemComplete(item: item)
    }
}


struct ListRowView_Previews: PreviewProvider {
    
    static var item1 = ItemModel(title: "First item!", isCompleted: false)
    static var item2 = ItemModel(title: "Second Guillaume Loti", isCompleted: true)
    
    static var previews: some View {
        Group {
//            ListRowView(item: .constant(item1))
            ListRowView(item: item2, row: 1)
        }
    }
}
