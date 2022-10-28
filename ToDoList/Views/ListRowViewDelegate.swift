//
//  ListRowViewDelegate.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 27/10/2022.
//

import SwiftUI

struct ListRowViewDelegate: View {
    
    @State var scale = 1.0
    
    @Binding var item: ItemModel
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    private let color2: Color = #colorLiteral(red: 0.1442833841, green: 0.5322987437, blue: 0.9596691728, alpha: 1)
    private let color1: Color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    
    @State private var animatingButton = true
    
    @State private var draggingItem: ItemModel?
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }
        
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        //
        let combined = pressGesture.sequenced(before: dragGesture)
        
        HStack {
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.7)
                
                HStack {
                    Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                        .foregroundColor(item.isCompleted ? .green : .red)
                        .onTapGesture(perform: updateCompletion)
                    
                    Spacer()
                    
                    //                    TextField(item.title, text: $item.title)
                    //                        .keyboardType(.default)
                    //                        .multilineTextAlignment(.center)
                    //                        .frame(alignment: .trailing)
                    //                        .animation(Animation.easeInOut(duration: 1), value: scale)
                }
                .padding(.vertical, animatingButton ? 0 : 8)
                .padding(.horizontal, animatingButton ? 0 : 30)
                
            }
            .cornerRadius(25)
            .font(.title2)
            .frame(height: 55)
            .shadow(radius: 7)
            
        }
        .frame(width: animatingButton ? 0 : .infinity)
        .opacity(animatingButton ? 0 : 1)
        .animation(Animation.easeInOut(duration: 1).speed(1))
        .onAppear {
            animatingButton.toggle()
        }
        
//        .scaleEffect(isDragging ? 1.1 : 1)
//        .offset(offset)
//        .gesture(combined)
        
        .onDrag {
            if let index = listViewModel.items.firstIndex(where: { $0.title == item.title }) {
                draggingItem = listViewModel.items[index]
            }
            return .init(object: NSString(string: item.title))
        } preview: {
            RoundedRectangle(cornerRadius: .zero)
                .frame(width: .zero)
        }
    }
    
    func updateCompletion() {
        listViewModel.updateItemComplete(item: item)
    }
}

struct ListRowViewDelegate_Previews: PreviewProvider {
    static var item1 = ItemModel(title: "First item!", isCompleted: false)
    static var item2 = ItemModel(title: "Second Item.", isCompleted: true)
    static var previews: some View {
        Group {
            ListRowViewDelegate(item: .constant(item1))
            ListRowViewDelegate(item: .constant(item2))
        }
        .previewLayout(.sizeThatFits)
    }
}
