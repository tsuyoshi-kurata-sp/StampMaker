//
//  ContentView.swift
//  StampMaker
//
//  Created by 蔵田 剛 on 2023/02/03.
//

import SwiftUI

struct ContentView: View {

  var body: some View {
    
    TabView {
      StampEditView()
        .tabItem {        
          Text("Make")
        }

      StampListView()
        .tabItem {
          Text("List")
        }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

