//
//  ListMoveAndDelete.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 27/10/2022.
//

import SwiftUI
import UIKit

struct AnimalModel: Identifiable {
    var id = UUID()
    var name: String
}



struct ListMoveAndDelete: View{
    
    //@Binding var item = ItemModel(title: "questionmark.circle", isCompleted: false)
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    private func addListElement() {
        listViewModel.addItem(title: "Hello")
        var itemChange = listViewModel.items[0]
        itemChange.title = "helloeoae"
        listViewModel.updateItem(item: itemChange)
    }
    
    private func delete() {
        listViewModel.deleteItem2()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                //            MyColorList()
                
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.vertical)
                    .opacity(0.4)
                
                
                VStack {
                    
                    GeometryReader { proxy in
                        GridView(listViewModel.items, proxy: proxy) { item in
                            //                    Image("image\(number)")
                            //                    .resizable()
                            //                    .scaledToFit()
                            ListRowView(item: item)
                            
                        }
                        .onTapGesture {
                            listViewModel.deleteItem2()
                        }
                        
                        
                        
                    }
                    
                    Button(action: { addListElement() },label: { Text("Add") } ).padding(20).font(.title)
                    Button(action: { delete() },label: { Text("Delete") } ).padding(20).font(.title)
                }
                
            }
        }
        .navigationTitle("ListMoveAndDelete")
        
    }
}




struct GridView<CellView: View>: UIViewRepresentable, View {
    let cellView: (ItemModel) -> CellView
    let proxy: GeometryProxy
    var items: [ItemModel]
    
    init(_ items: [ItemModel], proxy: GeometryProxy, @ViewBuilder cellView: @escaping (ItemModel) -> CellView) {
        self.proxy = proxy
        self.cellView = cellView
        self.items = items
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        //        layout.minimumLineSpacing = 0
        //        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        //        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        //collectionView.backgroundView = nil // LOOP : Added
        
        collectionView.register(GridCellView.self, forCellWithReuseIdentifier: "CELL")
        
        collectionView.dragDelegate = context.coordinator //to drag cell view
        collectionView.dropDelegate = context.coordinator //to drop cell view
        
        collectionView.dragInteractionEnabled = true
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        //        collectionView.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
        var parent: GridView
        
        init(_ parent: GridView) {
            self.parent = parent
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.items.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! GridCellView
            cell.backgroundColor = .clear
            cell.cellView.rootView = AnyView(parent.cellView(parent.items[indexPath.row]).fixedSize())
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 350, height: 55)
        }
        
        // LOOP : Remove the white background when is moving, added guard for cell and
        func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
            //get the cell dimensions
            guard let cell = collectionView.cellForItem(at: indexPath) else {
                return nil
            }
            let params = UIDragPreviewParameters()
            params.backgroundColor = .clear
            //hide that drop shadow
            //            params.visiblePath = UIBezierPath(rect: cell.frame)
            if #available(iOS 14.0, *) {
                params.shadowPath = UIBezierPath(rect: .zero)
            }
            return params
        }
        
        //Provides the initial set of items (if any) to drag.
        func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            let item = self.parent.items[indexPath.row]
            let itemProvider = NSItemProvider() //Loop Erased a part ov it
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        }
        
        //Tells your delegate that the position of the dragged data over the collection view changed.
        func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        
        //Tells your delegate to incorporate the drop data into the collection view.
        func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
            var destinationIndexPath: IndexPath
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                let row = collectionView.numberOfItems(inSection: 0)
                destinationIndexPath = IndexPath(item: row - 1, section: 0)
            }
            if coordinator.proposal.operation == .move {
                self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            }
        }
        
        private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
            if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    self.parent.items.remove(at: sourceIndexPath.item)
                    self.parent.items.insert(item.dragItem.localObject as! ItemModel, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }, completion: nil)
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
        
    }
}

class GridCellView: UICollectionViewCell {
    
    public var cellView = UIHostingController(rootView: AnyView(EmptyView()))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        contentView.addSubview(cellView.view)
        cellView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            cellView.view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -0),
            cellView.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cellView.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),
        ])
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 25
        
        cellView.view.layer.masksToBounds = true
        cellView.view.backgroundColor = .clear
    }
    
    // LOOP : Remove the translusent cell that stays when moving
    override func dragStateDidChange(_ dragState: UICollectionViewCell.DragState) {
        switch dragState {
        case .none:
            self.layer.opacity = 1
        case .lifting:
            return
        case .dragging:
            self.layer.opacity = 0
        @unknown default:
            return
        }
    }
    
}

struct ListMoveAndDelete_Previews: PreviewProvider {
    static var previews: some View {
        ListMoveAndDelete()
    }
}

