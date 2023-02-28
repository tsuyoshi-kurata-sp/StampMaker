//
//  PhotoPicker.swift
//
//
//  Created by 蔵田 剛 on 2022/07/21.
//

//import Extensions
import Foundation
import PhotosUI
import SwiftUI

// MARK: - PhotoPicker

struct PhotoPicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentation
  @Binding var imageWithFormat: ImageWithFormat

  func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.selectionLimit = 1
    configuration.preferredAssetRepresentationMode = .current

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_: PHPickerViewController, context _: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: PhotoPicker

    init(_ parent: PhotoPicker) {
      self.parent = parent
    }

    func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      parent.presentation.wrappedValue.dismiss()

      guard let provider = results.first?.itemProvider else {
        return
      }

      let typeIdentifier = UTType.image.identifier
      if provider.hasItemConformingToTypeIdentifier(typeIdentifier) {
        provider.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, error in
          if error == nil {
            if data != nil, let image = UIImage(data: data!) {
              DispatchQueue.main.async {
                self.parent.imageWithFormat = ImageWithFormat(image: image, imageFormat: ImageFormat.getFormat(from: data!))
              }
            }
          }
        }
      }
    }
  }
}

// MARK: - ImageFormat

public enum ImageFormat: String {
  case png
  case jpg
  case gif
  case bmp
  case tiff
  case webp
  case heic
  case unknown
}

extension ImageFormat {
  static func getFormat(from data: Data) -> ImageFormat {
    debugPrint(data[0 ... 11].map { String(format: "%02X", $0) })
    switch data[0] {
    case 0x89:
      return .png
    case 0xFF:
      return .jpg
    case 0x47:
      return .gif
    case 0x42:
      return .bmp
    // Apple ProRAW (.DNG)もTIFFと同じHeader情報をもつ
    case 0x4D,
         0x49:
      return .tiff

    case 0x52 where data.count >= 12:
      if let dataString = String(data: data[0 ... 11], encoding: .ascii),
         dataString.hasPrefix("RIFF"),
         dataString.hasSuffix("WEBP")
      {
        return .webp
      }

    case 0x00 where data.count >= 12:
      if let dataString = String(data: data[8 ... 11], encoding: .ascii),
         Set(["heic", "heix", "hevc", "hevx"]).contains(dataString)
      {
        return .heic
      }

    default:
      break
    }
    return .unknown
  }
}
