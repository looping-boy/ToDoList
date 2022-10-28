//
//  InspectorSidebarToolbarTop.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 27/10/2022.
//

import SwiftUI

struct InspectorSidebarToolbarTop: View {
    
    private struct InspectorDockIcon: Identifiable, Equatable {
        let imageName: String
        let title: String
        var id: Int
    }
    
    @EnvironmentObject var listViewModel: ListViewModel
    @State var targeted: Bool = true
    @State private var icons = [
        InspectorDockIcon(imageName: "doc", title: "File Inspector", id: 0),
        InspectorDockIcon(imageName: "clock", title: "History Inspector", id: 1),
        InspectorDockIcon(imageName: "questionmark.circle", title: "Quick Help Inspector", id: 2)
    ]
    
    @State private var hasChangedLocation: Bool = false
    @State private var draggingItem: ItemModel?
    @State private var drugItemLocation: CGPoint?
    
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
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
                .opacity(0.4)
            
            VStack {
                
                Circle()
                    .fill(.red)
                    .frame(width: 64, height: 64)
                    .scaleEffect(isDragging ? 1.5 : 1)
                    .offset(offset)
                    .gesture(combined)
                
                VStack(spacing: 40) {
                    ForEach($listViewModel.items) { $item in
                        
                        ListRowViewDelegate(item: $item)
                        //                            makeListRowView(system: item.title, id: item.id)
                        //
                        //
                        //
                        //makeInspectorIcon(systemImage: icon.imageName, title: icon.title, id: icon.id)
                        //                                .opacity(draggingItem?.title == item.title &&
                        //                                         hasChangedLocation &&
                        //                                         drugItemLocation != nil ? 0.0: 1.0)
                            .onDrop(of: [.utf8PlainText],
                                    delegate: InspectorSidebarDockIconDelegate(item: item,
                                                                               current: $draggingItem,
                                                                               icons: $listViewModel.items,
                                                                               hasChangedLocation: $hasChangedLocation,
                                                                               drugItemLocation: $drugItemLocation))
                        //                                .scaleEffect(isDragging ? 1.5 : 1)
                        //                                .offset(offset)
                        //                                .gesture(combined)
                        
                    }
                    .onDelete(perform: listViewModel.deleteItem)
                    .onMove(perform: {_, _  in })
                    .listRowBackground(Color.clear)
                    //                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ value in
                    //                            if value.translation.width < 0 {
                    //                                print("swip")
                    //                            }
                    //                        }))
                    
                    
                }
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .top) {
                    Divider()
                }
                .overlay(alignment: .bottom) {
                    Divider()
                }
                .animation(.default, value: icons)
            }
            .frame(height: .infinity, alignment: .center)
            .frame(maxWidth: .infinity)
        }
    }
        
        func makeListRowView(system: String, id: String) -> some View {
          
            
            Button {
            } label: {
                Image(systemName: system)
                    .resizable()
                    .scaledToFit()
                    .help(system)
                    .frame(width: 100, alignment: .center)
                    .onDrag {
                        if let index = listViewModel.items.firstIndex(where: { $0.title == system }) {
                            draggingItem = listViewModel.items[index]
                        }
                        return .init(object: NSString(string: system))
                    } preview: {
                        RoundedRectangle(cornerRadius: .zero)
                            .frame(width: .zero)
                    }
//                    .scaleEffect(isDragging ? 1.5 : 1)
//                    .offset(offset)
//                    .gesture(combined)
            }
            .buttonStyle(.plain)
            
            
        }
        
        
        //    func makeInspectorIcon(systemImage: String, title: String, id: Int) -> some View {
        //        Button {
        //        } label: {
        //            Image(systemName: systemImage)
        //                .resizable()
        //                .scaledToFit()
        //                .help(title)
        //                .frame(width: 100, alignment: .center)
        //                .onDrag {
        //                    if let index = icons.firstIndex(where: { $0.imageName == systemImage }) {
        //                        draggingItem = icons[index]
        //                    }
        //                    return .init(object: NSString(string: systemImage))
        //                } preview: {
        //                    RoundedRectangle(cornerRadius: .zero)
        //                        .frame(width: .zero)
        //                }
        //        }
        //        .buttonStyle(.plain)
        //    }
        
        private struct InspectorSidebarDockIconDelegate: DropDelegate {
            let item: ItemModel
            @Binding var current: ItemModel?
            @Binding var icons: [ItemModel]
            @Binding var hasChangedLocation: Bool
            @Binding var drugItemLocation: CGPoint?
            
            func dropEntered(info: DropInfo) {
                if current == nil {
                    current = item
                    drugItemLocation = info.location
                }
                
                guard item != current, let current = current,
                      let from = icons.firstIndex(of: current),
                      let toIndex = icons.firstIndex(of: item) else { return }
                
                hasChangedLocation = true
                drugItemLocation = info.location
                
                if icons[toIndex] != current {
                    icons.move(fromOffsets: IndexSet(integer: from), toOffset: toIndex > from ? toIndex + 1 : toIndex)
                }
            }
            
            func dropExited(info: DropInfo) {
                drugItemLocation = nil
            }
            
            func dropUpdated(info: DropInfo) -> DropProposal? {
                DropProposal(operation: .move)
            }
            
            func performDrop(info: DropInfo) -> Bool {
                            hasChangedLocation = false
                            drugItemLocation = nil
                current = nil
                return true
            }
        }
    }
    
    
    
    
//    struct InspectorSidebarToolbarTop_Previews: PreviewProvider {
//        static var previews: some View {
//            InspectorSidebarToolbarTop().environmentObject(ListViewModel())
//        }
//    }
