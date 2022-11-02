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
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width, height: 55)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.items.count
    }
    
    // Added by looping :
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SpecialCellView
        
        let delay = 0 + Double(indexPath.row) * 0.1
        cell.alpha = 0
        UIView.animate(withDuration: 2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: ({
            cell.alpha = 1
        }), completion: nil)
        
        
        cell.delegate = self
        cell.data = self.listViewModel.items[indexPath.item]
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listViewModel.items.remove(at: indexPath.row)
        collectionView.reloadData()
    }
}

struct ContentView : View {
    var textToDisplay : String
    var body: some View {
        HStack {
//            Text("He")
            ListRowView(item: ItemModel(title: textToDisplay, isCompleted: true)).padding(.horizontal, 20)
            
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
    
    public var cellView = UIHostingController(rootView: ContentView(textToDisplay: "helo"))
    
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
        cellView.view.clipsToBounds = true
        
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
