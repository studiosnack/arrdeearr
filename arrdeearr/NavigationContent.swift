//
//  NavigationContent.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 7/21/24.
//

import SwiftUI

struct NavigationContent: View {
  @Binding var document: ArrdeearrDocument;

  var body: some View {
    
//    let selectedCategoryRow = Binding(get: {
//      document.store.application.selectedCategoryRow
//    }, set: {
//      rowId in document.store.application.selectedCategoryRow = rowId
//    })
    let selectedCategoryRow = document.store.application.selectedCategoryRow
    let selectedCategory = document.store.categories.categoryFor(id: selectedCategoryRow!)

    let availableItems = selectedCategoryRow != nil ? document.store.items.itemsWithCategory(id: selectedCategoryRow!) : []
    
    if (availableItems.count == 0) {
      return AnyView(
        VStack {
          Text("would show items for \(selectedCategory?.name ?? "missing category")")
          Spacer()
        }
        
      )
    }
    
    
    return AnyView(
      List(availableItems, id: \.id) { item in
        let itemName = item.propertyWith(label: "Name") ?? "missing name"
        Text("\(itemName)")
      }
    )
  }
}

