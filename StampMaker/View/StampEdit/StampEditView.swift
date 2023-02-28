//
//  StampEditView.swift
//  StampMaker
//
//  Created by 蔵田 剛 on 2023/02/06.
//

import Foundation
import SwiftUI

public struct ImageWithFormat: Equatable {
  var image: UIImage?
  var imageFormat: ImageFormat = .unknown
}

struct StampEditView: View {

  @State private var showActionSheet = false
  @State private var showCameraRoll = false
  @State private var showCameraView = false
  @State private var showPostcardList = false
  @State private var showDesignView = false
  
  @State private var imageWithFormat: ImageWithFormat = .init()
  @State private var processedImage: UIImage = .init()
  @State var postcardImage: UIImage?

  @State var effectMode: EffectMode = .original
  @State var colorEffect: ColorEffect = .noEffect
  @State var blurEffect: BlurEffect = .noEffect
  @State var thresholdEffect: ThresholdEffect = .noEffect
  @State var clipEffect: ClipEffect = .noEffect
  @State var isTransparent: Bool = false

  
  let screenW = UIScreen.main.bounds.width - 4
  let screenH = (UIScreen.main.bounds.width - 4) * 1.4518

  var body: some View {
    VStack {
      HStack {
        Button(action: {
//          effectMode = .original
//          colorEffect = .noEffect
//          blurEffect = .noEffect
//          thresholdEffect = .noEffect
          isTransparent = false
          showActionSheet = true
        }) {
          Image(systemName: "square.and.pencil")
        }
        Button(action: {
         showPostcardList = true
        }) {
          Text("PREVIEW")
        }
      }

      ZStack {
        if let postcardImage = postcardImage {
          Image(uiImage: postcardImage)
            .resizable()
            .frame(width: self.screenW, height: screenH)
            .scaledToFill()
            .contentShape(Rectangle())
        } else {
          Rectangle()
            .stroke(Color.gray, lineWidth: 1)
            .frame(width: self.screenW, height: screenH)
        }

        let rect = self.showDesignView ? CGSize(width: 160, height: 160) : CGSize(width: 320, height: 320)
        let offsetY = self.showDesignView ? 160.0 : 0.0
        if imageWithFormat.image == nil {
          Rectangle()
            .stroke(Color.gray, lineWidth: 1)
            .frame(width: rect.width, height: rect.height, alignment: .top)
        } else {
            let image = processingImage(
              originalImage: imageWithFormat.image!,
              mode: effectMode,
              colorEffect: colorEffect,
              blurEffect: blurEffect,
              thresholdEffect: thresholdEffect,
              clipEffect: clipEffect,
              isTransparent: isTransparent
            )
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .frame(width: rect.width, height: rect.height, alignment: .center)
              .offset(x: 0, y: offsetY)
//            .clipped()
        }
      }

      HStack {
        Menu {
          Group {
            Button(action: {
              self.colorEffect = .noEffect
            }) {
              Text(ColorEffect.noEffect.title)
            }
            Button(action: {
              self.colorEffect = .grayscale
            }) {
              Text(ColorEffect.grayscale.title)
            }
            Button(action: {
              self.colorEffect = .RGB2Luv
            }) {
              Text(ColorEffect.RGB2Luv.title)
            }
            Button(action: {
              self.colorEffect = .RGB2BGR
            }) {
              Text(ColorEffect.RGB2BGR.title)
            }
            Button(action: {
              self.colorEffect = .RGB2YCrCb
            }) {
              Text(ColorEffect.RGB2YCrCb.title)
            }
            Button(action: {
              self.colorEffect = .RGB2Lab
            }) {
              Text(ColorEffect.RGB2Lab.title)
            }
            Button(action: {
              self.colorEffect = .RGB2HSV
            }) {
              Text(ColorEffect.RGB2HSV.title)
            }
            Button(action: {
              self.colorEffect = .RGB2HLS
            }) {
              Text(ColorEffect.RGB2HLS.title)
            }
          }
        } label: {
          Text("ColorFilter")
        }
        .onTapGesture {
          self.effectMode = .color
        }

        Menu {
          Group {
            Button(action: {
              self.thresholdEffect = .noEffect
            }) {
              Text(ThresholdEffect.noEffect.title)
            }
            Button(action: {
              self.thresholdEffect = .binary
            }) {
              Text(ThresholdEffect.binary.title)
            }
            Button(action: {
              self.thresholdEffect = .binary_Inv
            }) {
              Text(ThresholdEffect.binary_Inv.title)
            }
            Button(action: {
              self.thresholdEffect = .trunc
            }) {
              Text(ThresholdEffect.trunc.title)
            }
            Button(action: {
              self.thresholdEffect = .toZero
            }) {
              Text(ThresholdEffect.toZero.title)
            }
            Button(action: {
              self.thresholdEffect = .toZero_Inv
            }) {
              Text(ThresholdEffect.toZero_Inv.title)
            }
            Button(action: {
              self.thresholdEffect = .mask
            }) {
              Text(ThresholdEffect.mask.title)
            }
            Button(action: {
              self.thresholdEffect = .otsu
            }) {
              Text(ThresholdEffect.otsu.title)
            }
            Button(action: {
              self.thresholdEffect = .triangle
            }) {
              Text(ThresholdEffect.triangle.title)
            }
          }
        } label: {
          Text("Threshold")
        }
        .onTapGesture {
          self.effectMode = .threshold
        }

        Menu {
          Group {
            Button(action: {
              self.blurEffect = .noEffect
            }) {
              Text(BlurEffect.noEffect.title)
            }
            Button(action: {
              self.blurEffect = .blurSoft
            }) {
              Text(BlurEffect.blurSoft.title)
            }
            Button(action: {
              self.blurEffect = .blurMiddle
            }) {
              Text(BlurEffect.blurMiddle.title)
            }
            Button(action: {
              self.blurEffect = .blurHard
            }) {
              Text(BlurEffect.blurHard.title)
            }
          }
        } label: {
          Text("Blur")
        }
        .onTapGesture {
          self.effectMode = .blur
        }

        Menu {
          Group {
            Button(action: {
              self.clipEffect = .noEffect
            }) {
              Text(ClipEffect.noEffect.title)
            }
            Button(action: {
              self.clipEffect = .rectangle
            }) {
              Text(ClipEffect.rectangle.title)
            }
            Button(action: {
              self.clipEffect = .oval
            }) {
              Text(ClipEffect.oval.title)
            }
            Button(action: {
              self.clipEffect = .circle
            }) {
              Text(ClipEffect.circle.title)
            }
          }
        } label: {
          Text("Clip")
        }
        .onTapGesture {
          self.effectMode = .clip
        }

        Spacer()

        Button(action: {
          isTransparent.toggle()
          self.effectMode = isTransparent ? .transparent : .original
        }){
//          Text(isTransparent ? "transparent ON" : "transparent OFF")
          Text("transparent")
        }
      }
    }
    .padding()
    .actionSheet(isPresented: $showActionSheet) {
      ActionSheet(
          title: Text("スタンプを作ろう！"),
          message: nil,
          buttons: [
           .default(Text(/*@START_MENU_TOKEN@*/"カメラを起動する"/*@END_MENU_TOKEN@*/)) {
             showCameraView = true
           },
           .default(Text(/*@START_MENU_TOKEN@*/"カメラロールから写真を選ぶ"/*@END_MENU_TOKEN@*/)) {
             showCameraRoll = true
           },
           .cancel(Text("Cancel")) {
             showActionSheet = false
           }
          ]
      )
    }
    .fullScreenCover(isPresented: $showPostcardList) {
      PostcardListView(postcardImage: $postcardImage)
    }
    .fullScreenCover(isPresented: $showCameraView) {
      CameraView()
    }
    .fullScreenCover(isPresented: $showCameraRoll) {
      PhotoPicker(imageWithFormat: $imageWithFormat)
    }
  }
}

private func processingImage(
  originalImage: UIImage,
  mode: EffectMode,
  colorEffect: ColorEffect,
  blurEffect: BlurEffect,
  thresholdEffect: ThresholdEffect,
  clipEffect: ClipEffect,
  isTransparent: Bool
) -> UIImage {

  var afterImage: UIImage

  switch mode {
  case .original:
    afterImage = originalImage
  case .color:
    afterImage = OpenCV.convertColor(originalImage, code: colorEffect.rawValue)
  case .threshold:
    afterImage = OpenCV.threshold(originalImage, code: thresholdEffect.rawValue)
  case .blur:
    afterImage = OpenCV.medianBlur(originalImage, blurSize: blurEffect.rawValue)
  case .clip:
    switch clipEffect {
    case .noEffect:
      afterImage = originalImage
    case .rectangle:
      afterImage = OpenCV.clipRect(originalImage, size: CGSizeZero)
    case .oval:
      afterImage = OpenCV.clipRect(originalImage, size: CGSizeZero)
    case .circle:
      afterImage = OpenCV.clipCircle(originalImage, size: CGSizeZero)
    }
  case .transparent:
    afterImage = OpenCV.transparent(originalImage, transparentColor: 255)
  }
  return afterImage
}

struct CameraView: View {
  var body: some View {
    Text("カメラ")
  }
}
