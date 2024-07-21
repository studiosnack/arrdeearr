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

  let selectedCategoryRow = Binding(get: {
    document.store.application.selectedCategoryRow
  }, set: {
    rowId in document.store.application.selectedCategoryRow = rowId
  })

  let availableItems = selectedCategoryRow.wrappedValue != nil ? document.store.items.itemsWithCategory(id: selectedCategoryRow.wrappedValue!) : []

  return availableItems.count > 0 ? List(availableItems, id: \.id) { item in
      let itemName = item.propertyWith(label: "Name") ?? "missing name"
      Text("\(itemName)")
    } : nil
  }
}

