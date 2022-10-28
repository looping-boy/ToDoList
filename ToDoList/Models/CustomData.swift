//
//  CustomData.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 28/10/2022.
//

import Foundation
import SwiftUI

class CustomData : Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var url: String
    var backgroundImage: UIImage
    
    init(id: String = UUID().uuidString, title: String, url: String, backgroundImage: UIImage) {
        self.id = id
        self.title = title
        self.url = url
        self.backgroundImage = backgroundImage
    }
    
//    func updateItem() -> ItemModel {
//        return CustomData(id: id, title: title, isCompleted: isCompleted)
//    }
//    
//    func updateCompletion() -> ItemModel {
//        return ItemModel(id: id, title: title, isCompleted: !isCompleted)
//    }
}
