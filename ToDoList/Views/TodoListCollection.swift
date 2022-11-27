//
//  TodoListCollection.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 31/10/2022.
//

import SwiftUI
import UIKit
import SwipeCellKit

class TodoListCollection: UIViewController, UICollectionViewDelegate, SwipeCollectionViewCellDelegate {
    
    let global = Global.shared
    
    let listViewModel = ListViewModel.shared
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SpecialCellView.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        //        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        //        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        //        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        //        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        //        collectionView.heightAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
//    private var cellCount = 0
//
//    func addCells(count: Int) {
//        guard count > 0 else { return }
//
//        var alreadyAdded = 0
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] t in
//            guard let self = self else {
//                t.invalidate()
//                return
//            }
//
//            self.cellCount += 1
//
//            let indexPath = IndexPath(row: self.cellCount - 1, section: 0)
//            self.collectionView.insertItems(at: [indexPath])
//
//            alreadyAdded += 1
//            if alreadyAdded == count {
//                t.invalidate()
//            }
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        addCells(count: 3)
//    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "note")
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
}

extension TodoListCollection: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
        return CGSize(width: width, height: 55)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.items.count
    }
    
    // Added by looping :
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SpecialCellView
        
        cell.delegate = self
        cell.data = self.listViewModel.items[indexPath.item]
        cell.delay = Double(indexPath.row) + 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = listViewModel.items.remove(at: sourceIndexPath.row)
        listViewModel.items.insert(item, at: destinationIndexPath.row)
    }
    
    // Looping on click delete
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        listViewModel.items.remove(at: indexPath.row)
//        collectionView.reloadData()
//    }
    
}

struct ContentView : View {
    var textToDisplay : String
    var delay : Double
    @Binding var picked: String
    var body: some View {
        HStack {
//            Text("He")
            ListRowViewEdit(item: ItemModel(title: textToDisplay, isCompleted: true), row: delay, picked: $picked).padding(.horizontal, 20)
            
        }
    }
}

class SpecialCellView: SwipeCollectionViewCell {
    
    var data: ItemModel? {
        didSet {
            guard let data = data else { return }
            cellView.rootView.textToDisplay = data.title
        }
    }
    
    var delay: Double? {
        didSet {
            guard let delay = delay else { return }
            cellView.rootView.delay = delay
        }
    }
    
    public var cellView = UIHostingController(rootView: ContentView(textToDisplay: "hello", delay: 1, picked: .constant("hello")))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(cellView.view)
        
        cellView.view.translatesAutoresizingMaskIntoConstraints = false
        
//        cellView.view.contentMode = .scaleAspectFill
        cellView.view.clipsToBounds = false
        cellView.view.layer.cornerRadius = 12
        cellView.view.layer.masksToBounds = false
        cellView.view.layer.backgroundColor = UIColor.clear.cgColor
//        cellView.view.backgroundColor = .clear
        
        cellView.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellView.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cellView.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        for view in subviews {
//                view.removeFromSuperview()
//            }
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
