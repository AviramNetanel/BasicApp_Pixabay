//
//  FiltersPanelView.swift
//  
//
//  Created by Aviram Netanel on 6/11/22.
//

import SwiftUI

struct FiltersPanelView: View {
    
    @ObservedObject var parentVM: ImagesTableViewModel

    @StateObject var viewModel = FiltersPanelViewModel.shared

    @State private var selectedCategoryIndex : Int = 0
    @State private var isExpanded: Bool = false

    var body: some View {
        Color.gray.opacity(0.1).overlay(
            VStack{
                FiltersButton(isExpanded: $isExpanded)
                if isExpanded{
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
                                await self.parentVM.sendRequestAndReload()
                            }
                        }
                    
                    SubjectHStack(viewModel: viewModel, parentVM: parentVM)
                        
                   
                    }//else
                }//VStack
            )//overlay
            .frame(height: getPanelHeight(isExpanded: isExpanded), alignment: .top)
    }//body
}

func getPanelHeight(isExpanded: Bool) -> CGFloat?{
    if isExpanded{
        return 120
    }else{
        return 30
    }
}

struct FiltersButton : View{
    @Binding var isExpanded: Bool
    var body: some View {
        Button(action: { isExpanded.toggle()}){
            Text("Filters") //Button's Label
                .frame(width: 100, alignment: .center)
                .padding(2)
                .font(Font.body.bold())
        }
    }
}

struct SubjectHStack : View{
    @Environment(\.colorScheme) private var colorScheme

    @ObservedObject var viewModel: FiltersPanelViewModel
    @ObservedObject var parentVM : ImagesTableViewModel
    
    @State  var subject : String = ""
     var title : String = "Title"
     var placeholder : String = ""
    
    @State  var goButtonEnabled : Bool = false
    
    private var goButtonBGColor: Color {
        return goButtonEnabled ? Color.green.opacity(0.5) : Color.gray.opacity(0.1)
        }
    
    var body: some View {
        
            HStack{
                Button(action: {
                    print("Search button pressed!")
                    Task {
                        viewModel.subject = subject
                        await self.parentVM.sendRequestAndReload()
                    }
                    
                }){
                    Text("Search") //Button's Label
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

struct FiltersPanelView_Previews: PreviewProvider {
    
    static var previews: some View {
        FiltersPanelView(parentVM: ImagesTableViewModel())
//        FiltersPanelView(viewModel: ImagesTableViewModel())
    }
}
