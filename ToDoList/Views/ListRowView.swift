//
//  ListRowView.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 24/10/2022.
//

import SwiftUI

struct ListRowView: View {
    
    @Binding var item: ItemModel
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    private let color2: Color = #colorLiteral(red: 0.1442833841, green: 0.5322987437, blue: 0.9596691728, alpha: 1)
    private let color1: Color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    
    @State private var animatingButton = false
    
    var body: some View {
        
        HStack {
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.7)
                
                HStack {
                    Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                        .foregroundColor(item.isCompleted ? .green : .red)
                        .onTapGesture(perform: updateCompletion)
                    
                    Spacer()
                    
                    TextField(item.title, text: $item.title)
                        .keyboardType(.default)
                        .multilineTextAlignment(.center)
                        .frame(alignment: .trailing)
                    
                }
                .padding(.vertical, animatingButton ? 0 : 8)
                .padding(.horizontal, animatingButton ? 0 : 30)
                
            }
            .cornerRadius(25)
            .font(.title2)
            .frame(height: 55)
            
        }
        .frame(width: 350)
    }

    func updateCompletion() {
        listViewModel.updateItemComplete(item: item)
    }
}


struct ListRowView_Previews: PreviewProvider {
    
    static var item1 = ItemModel(title: "First item!", isCompleted: false)
    static var item2 = ItemModel(title: "Second Item.", isCompleted: true)
    
    static var previews: some View {
        Group {
            ListRowView(item: .constant(item1))
            ListRowView(item: .constant(item2))
        }
        .previewLayout(.sizeThatFits)
    }
}
