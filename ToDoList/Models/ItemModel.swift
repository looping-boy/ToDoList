//
//  ItemModel.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 24/10/2022.
//

import Foundation

struct ItemModel: Identifiable, Equatable, Codable {
    let id: String
    var title: String = ""
    var isCompleted: Bool
    var beinMoved: Bool = false
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
    
    func updateItem() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: isCompleted)
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted)
    }
}
