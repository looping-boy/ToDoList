//
//  ListView.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 24/10/2022.
//

import SwiftUI
import UniformTypeIdentifiers

struct Item: Identifiable, Equatable{
    let id: Int
}

struct DragDelegate<ItemModel: Equatable>: DropDelegate {
    @Binding var current: ItemModel?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
    
}

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var isToggle: Bool = false
    
    @State private var dragging: ItemModel?
    
    private let color1: Color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    private let color2: Color = #colorLiteral(red: 0.09218419343, green: 0.483716011, blue: 0.9512770772, alpha: 1)
    
    @State private var animatingButton = false
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
                .opacity(0.4)
            
            VStack {
                
                List {
                    
                        ForEach($listViewModel.items) { $item in
                            ListRowView(item: $item)
                                .onTapGesture {
                                    withAnimation(.linear) {
                                        listViewModel.updateItem(item: item)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .onDrag {
                                    self.dragging = item
                                    return NSItemProvider(object: NSString())
                                }
                                .onDrop(of: [UTType.text], delegate: DragDelegate(current: $dragging)
                                )
                                .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 25, style: .circular))
                            
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: {_, _  in })
                        .listRowBackground(Color.clear)
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ value in
                            if value.translation.width < 0 {
                                print("swip")
                            }
                        }))
                    
                    
                    
                    
//                    Button {
//                        withAnimation(.easeInOut(duration: 1)) {
//                            //                        item.animatingButton.toggle()
//                        }
//                    } label : {
//
//                    }
                    
                    ZStack {
                        
                        Circle()
                            .foregroundColor(.white)
                            .frame(width:55,
                                   height: 55
                            )
                            .opacity(0.1)
                            .shadow(radius: 7)
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:
                                    55,
                                   height: 55)
                            .foregroundColor(color2)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .background(animatingButton ? Color.red : Color.yellow)
                    .onTapGesture(perform: addItem)
                    .onAppear {
                        animatingButton.toggle()
                    }
                    .animation(Animation.easeInOut(duration: 1).delay(2).speed(1).repeatCount(1, autoreverses: true))
                    //.opacity(animatingButton ? 1 : 0)
                    
                    
                    
                    
                    
                }
                .environment(\.editMode, Binding.constant(EditMode.inactive))
                .deleteDisabled(true)
                .background(Color.clear)
                .listStyle(PlainListStyle())
                
                
                
                
                
                
                
                
                
                
                
            }
            .navigationTitle("Todo List📝")
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    NavigationLink("Add", destination: AddView())
            )
            
        }
        
    }
    
    func deleteItem() {
        print("Swip")
    }
    
    func addItem() {
        listViewModel.addItem(title: "vhhc")
        animatingButton.toggle()
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView().environmentObject(ListViewModel())
        }
    }
}


