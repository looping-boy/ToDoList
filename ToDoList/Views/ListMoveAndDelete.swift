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

struct MyColorList: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController()
        // Do some configurations here if needed.
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
    
}

struct ListMoveAndDelete: View{
    
    //@Binding var item = ItemModel(title: "questionmark.circle", isCompleted: false)
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    var numbers = [1, 2]
    var body: some View {
        
        ZStack {
            
//            MyColorList()
            
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
                .opacity(0.4)
                        
            GeometryReader { proxy in
                GridView(self.numbers, proxy: proxy) { number in
                    //                    Image("image\(number)")
                    //                    .resizable()
                    //                    .scaledToFit()
                    ListRowView(item: $listViewModel.items[number])
                       
                }
        
            }
            
        }
    }
}




struct GridView<CellView: View>: UIViewRepresentable {
    let cellView: (Int) -> CellView
    let proxy: GeometryProxy
    var numbers: [Int]
    
    init(_ numbers: [Int], proxy: GeometryProxy, @ViewBuilder cellView: @escaping (Int) -> CellView) {
        self.proxy = proxy
        self.cellView = cellView
        self.numbers = numbers
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        //collectionView.backgroundView = nil // LOOP : Added
        
        collectionView.register(GridCellView.self, forCellWithReuseIdentifier: "CELL")
        
        collectionView.dragDelegate = context.coordinator //to drag cell view
        collectionView.dropDelegate = context.coordinator //to drop cell view
    
        collectionView.dragInteractionEnabled = true
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
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
            return parent.numbers.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! GridCellView
            cell.backgroundColor = .clear
            cell.cellView.rootView = AnyView(parent.cellView(parent.numbers[indexPath.row]).fixedSize())
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (parent.proxy.frame(in: .global).width), height: ((parent.proxy.frame(in: .global).width - 8) / 5))
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
            let item = self.parent.numbers[indexPath.row]
            let itemProvider = NSItemProvider(object: String(item) as NSString)
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
                    self.parent.numbers.remove(at: sourceIndexPath.item)
                    self.parent.numbers.insert(item.dragItem.localObject as! Int, at: destinationIndexPath.item)
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
            cellView.view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            cellView.view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            cellView.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cellView.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
        cellView.view.layer.masksToBounds = true
        cellView.view.backgroundColor = .clear
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("hello")
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print("hello")
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        return true
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

