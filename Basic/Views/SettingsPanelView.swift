//
//  SettingsPanelView.swift
//  
//
//  Created by Aviram Netanel on 6/11/22.
//

import SwiftUI

struct SettingsPanelView: View {
    
    @ObservedObject var viewModel: ImagesTableViewModel
    
    @State private var selectedCategoryIndex : Int = 0

    var body: some View {
        Color.gray.opacity(0.1)
            .overlay(
        VStack{
            
            HStack{
                Text("Category: ").padding(2)
                Spacer()
                Picker("Category", selection: $selectedCategoryIndex, content: {
                    ForEach(0..<Constants.categoriesArray.count, id: \.self, content: { index in
                            Text(Constants.categoriesArray[index])
                        })
                    })
                Spacer()
            }//HStack
            .onChange(of: selectedCategoryIndex){ _ in
                viewModel.category = Constants.categoriesArray[selectedCategoryIndex]
                Task {
                    await viewModel.sendRequestAndReload()
                }
            }
            
            SubjectHStack(viewModel: viewModel)
            
//            SubjectTextfield(subject: $viewModel.subject, title: "Keywords", placeholder: "e.g: blue,sky,clouds (100 characters)")
//                .onChange(of: viewModel.subject , perform: { _ in goButtonEnabled = true})
//
            
            
        }//VStack
        )//overlay
            .frame(height: 120, alignment: .top)
    }//body
        
}

func dono(){
    
}

struct SubjectHStack : View{
    @Environment(\.colorScheme) private var colorScheme

    @ObservedObject var viewModel: ImagesTableViewModel
    
    @State  var subject : String = ""
    private var title : String = "Title"
    private var placeholder : String = ""
    
    @State private var goButtonEnabled : Bool = false
    private var goButtonBGColor: Color {
        return goButtonEnabled ? Color.green.opacity(0.5) : Color.gray.opacity(0.1)
        }
    
    init(viewModel: ImagesTableViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack{
            Button(action: {
                print("GO button pressed!")
                Task {
                    await viewModel.sendRequestAndReload()
                }
                
            }){
                Text("Search\nKeywords") //Button's Label
                    .frame(width: 100, alignment: .center)
                    .padding(2)
                    .font(Font.body.bold())
                    .tint(colorScheme == .dark ? Color.white : Color.black)
                    
            }.background(goButtonBGColor)
                .cornerRadius(15.0)
            .disabled(!goButtonEnabled)
            
            
            TextField(placeholder, text: $subject){
                    goButtonEnabled = !subject.isEmpty
            }.padding(2)
            .border(Color(UIColor.separator), width: 2)
            .cornerRadius(5)
            
            Spacer()
            
            
        }.padding(2)
    }//body
}

struct SettingsPanelView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsPanelView(viewModel: ImagesTableViewModel())
    }
}
