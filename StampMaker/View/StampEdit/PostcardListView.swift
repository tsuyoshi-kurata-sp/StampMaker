//
//  PostcardListView.swift
//  StampMaker
//
//  Created by 蔵田 剛 on 2023/02/20.
//

import Foundation
import SwiftUI

struct Postcard: Identifiable {
  let id = UUID()
  let name: String
  let image: UIImage?
}

struct PostcardListView: View {
  @Environment(\.presentationMode) var presentation
  @Binding var postcardImage: UIImage?

  private var postcards = [
    Postcard(name: "light yellow", image: UIImage(named: "lightYellow") ?? nil),
    Postcard(name: "Tabi", image: UIImage(named: "tabi") ?? nil),
    Postcard(name: "Koko", image: UIImage(named: "koko") ?? nil),
    Postcard(name: "blank", image: nil)
  ]

  init(postcardImage: Binding<UIImage?>) {
      self._postcardImage = postcardImage
  }

  var body: some View {
      List {
        ForEach(0 ..< postcards.count, id: \.self) { index in
          PostcardItemView(postcard: postcards[index])
            .onTapGesture {
              postcardImage = postcards[index].image
              self.presentation.wrappedValue.dismiss()
            }
        }
      }
    }
}

struct PostcardItemView: View {
    var postcard: Postcard

    var body: some View {
      HStack {
        if let image = postcard.image {
          Image(uiImage: image)
            .resizable()
            .frame(width: 140, height: 203.25)
            .scaledToFit()
        } else {
          Rectangle()
            .stroke(Color.green, lineWidth: 1)
            .frame(width: 140, height: 203.25)
            
        }

        Spacer()
        Text(postcard.name)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

    }
}
