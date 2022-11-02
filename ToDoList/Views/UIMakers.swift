//
//  UIMakers.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 28/10/2022.
//

import SwiftUI
import UIKit

struct MyColorList: UIViewControllerRepresentable {
    typealias UIViewControllerType = CollectionColorList
    
    func makeUIViewController(context: Context) -> CollectionColorList {
        let vc = CollectionColorList()
        // Do some configurations here if needed.
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CollectionColorList, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}

struct MyImageList: UIViewControllerRepresentable {
    typealias UIViewControllerType = ImageCollection
    
    @StateObject var imageViewModel: ImageViewModel = ImageViewModel()
    @Binding var isCallingFunc: Bool//    var vc = ImageCollection
    
    func makeUIViewController(context: Context) -> ImageCollection {
        let vc = ImageCollection(imageViewModel: imageViewModel)
        // Do some configurations here if needed.
        return vc
    }
    
    //    func delete() {
    //        vc.delete()
    //    }
    
    func updateUIViewController(_ uiViewController: ImageCollection, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
        if isCallingFunc {
            //                    uiViewController.doSomething()
            isCallingFunc = false
        }
    }
    
   
    
    
}

struct MyImageListSwiftUI: View {
    @EnvironmentObject var imageViewModel: ImageViewModel
    
    var myImage = MyImageList(imageViewModel: ImageViewModel(), isCallingFunc: .constant(true))
    var body: some View {
        
        VStack {
            myImage
            Button(action: {delete()} , label: {Text("Delete").padding(20).font(.largeTitle)})
        }.environmentObject(imageViewModel)
    }
    
        func delete() {
            imageViewModel.deleteItem2()
        }
}


class Global: ObservableObject
{
    static let shared = Global()

    @Published var datas = [
        CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: #imageLiteral(resourceName: "image8")),
        CustomData(title: "Subscribe to maxcodes boiiii!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image7")),
        CustomData(title: "StoreKit Course!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image1")),
        CustomData(title: "Collection Views!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image3")),
        CustomData(title: "MapKit!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "image4")),
    ]
}






struct ToDoListMaker: View {

    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
                .opacity(0.4)
            MyTodoListCollectionHelper()
        }
        
        
    }

}


struct MyTodoListCollectionHelper : UIViewControllerRepresentable {
    typealias UIViewControllerType = TodoListCollection
    
    func makeUIViewController(context: Context) -> TodoListCollection {
        let vc = TodoListCollection()
        // Do some configurations here if needed.
        return vc
    }
    
    func updateUIViewController(_ uiViewController: TodoListCollection, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
