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
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
//                ListView()
//                InspectorSidebarToolbarTop()
                ListMoveAndDelete()
            }
            .environmentObject(listViewModel)
        }
    }
}

