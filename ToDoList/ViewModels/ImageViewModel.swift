//
//  ImageViewModel.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 28/10/2022.
//

import Foundation

class ImageViewModel : ObservableObject {
    
    @Published var items: [CustomData] = [] 
    
    let ITEMS_KEY: String = "image_list"
    
    init() {
        getItems()
    }
    
    init(title: String) {
        
    }
    
    func getItems() {
        
//        let newItems = [
//            ItemModel(title: "doc", isCompleted: false),
//            ItemModel(title: "clock", isCompleted: true),
//            ItemModel(title: "questionmark.circle", isCompleted: false),
//        ]
//
//        self.items = newItems
        
        let datas = [
            CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: #imageLiteral(resourceName: "image8")),
            CustomData(title: "Subscribe to maxcodes boiiii!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image7")),
            CustomData(title: "StoreKit Course!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image1")),
            CustomData(title: "Collection Views!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image3")),
            CustomData(title: "MapKit!gd", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image4")),
            CustomData(title: "MapKit!dgfd", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image4")),
            CustomData(title: "MapKit!dfgffg", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image4")),
            CustomData(title: "MapKit!dfgfdgdfg", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image4")),
            CustomData(title: "MapKit!dfgfdgf", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image4")),
        ]
        
        self.items = datas
        
//        guard
//            let data = UserDefaults.standard.data(forKey: ITEMS_KEY),
//            let savedItems = try? JSONDecoder().decode([CustomData].self, from: data)
//        else { return }
//
//        self.items = savedItems
        
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
        let newItem =  CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: #imageLiteral(resourceName: "image2"))
        items.append(newItem)
    }
    
//    func saveItems() {
//        if let encodedData = try? JSONEncoder().encode(items) {
//            UserDefaults.standard.set(encodedData, forKey: ITEMS_KEY)
//        }
//    }
    

}
