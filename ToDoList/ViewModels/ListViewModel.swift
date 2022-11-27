//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 25/10/2022.
//

import Foundation

class ListViewModel : ObservableObject {
    
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    
    static let shared = ListViewModel()
    
    let ITEMS_KEY: String = "items_list"
    
    init() {
        getItems()
    }
    
    func getItems() {
        
        let newItems = [
            ItemModel(title: "Guillaume Lotis", isCompleted: false),
            ItemModel(title: "Emilie Lotis", isCompleted: true),
            ItemModel(title: "Jules Antoine Guy Lotis", isCompleted: false),
            ItemModel(title: "Catherine Olléon", isCompleted: false),
            ItemModel(title: "Gilles Blanc", isCompleted: false),
            ItemModel(title: "Stanford Lelandais", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
            ItemModel(title: "Nolwenn Guillemot", isCompleted: false),
        ]

        self.items = newItems
        
        guard
            let data = UserDefaults.standard.data(forKey: ITEMS_KEY),
            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
        else { return }
        
        self.items = savedItems
        
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func deleteItem2() {
        items.remove(at: 0)
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(title: String) {
        let newItem = ItemModel(title: title, isCompleted: false)
        items.append(newItem)
    }
    
    func updateItem(item: ItemModel) {
        
//        if let index = items.firstIndex { (existingItem) in
//            return existingItem.id == item.id
//        } {
//            // run
//        }
        
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateItem()
        }
    }
    
    func updateItemComplete(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: ITEMS_KEY)
        }
    }
    
    
    
}
