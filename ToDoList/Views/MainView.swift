//
//  MainView.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 24/10/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
                    ListView()
                
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView() {
            MainView()
        }
        
    }
}

struct BackgroundColorStyle: ViewModifier {

    func body(content: Content) -> some View {
        return content
            .background(Color.orange)
    }
}
