//
//  AddView.swift
//  ToDoList
//
//  Created by Guillaume Lotis on 24/10/2022.
//

import SwiftUI

struct AddView: View {
        
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var textFieldText: String = ""

    private let color: Color = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    
    var body: some View {
        ScrollView {
            VStack {
                TextField(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/, text: $textFieldText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(color)
                    .cornerRadius(15)
                
                Button(action: saveButtonPressed, label: {
                    Text("Save".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(15)
                })
            }
            .padding(14)
        }
        .navigationTitle("Add an Item 🖋")
    }
    
    func saveButtonPressed() {
        listViewModel.addItem(title: textFieldText)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView().environmentObject(ListViewModel())
        }
    }
}

extension Color: _ExpressibleByColorLiteral {
    public init(_colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        self = Color(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }
}
