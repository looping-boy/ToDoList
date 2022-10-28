//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 21/10/2022.
//

import SwiftUI

@main
struct ToDoListApp: App {
    
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    @StateObject var imageViewModel: ImageViewModel = ImageViewModel()
    @State private var willMoveToNextScreen = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {

                VStack(spacing: 20.0) {
                    NavigationLink(destination: ListMoveAndDelete(), label: {Text("ListMoveAndDelete 🤓")})
                    NavigationLink("ListView SwiftUI 👾") { ListView() }
                    NavigationLink(destination: InspectorSidebarToolbarTop(), label: {Text("InspectorSidebar 🤢")})
                    NavigationLink(destination: MyColorList(), label: {Text("MyColorList 🏳️‍🌈")})
                    NavigationLink(destination: MyImageListSwiftUI(), label: {Text("ImageCollection 🌄")})
                }
                .font(.largeTitle)
                
            }
            .environmentObject(listViewModel)
            .environmentObject(imageViewModel)
            .navigationTitle("App")
        }
    }
}

