//
//  OpenCVEffectEnum.swift
//  StampMaker
//
//  Created by 蔵田 剛 on 2023/02/20.
//

import Foundation

public enum EffectMode {
  case original
  case color
  case threshold
  case blur
  case clip
  case transparent
}

public enum ColorEffect: Int32 {
  case noEffect = 0
  case RGB2BGR = 4
  case grayscale = 7
  case RGB2HSV = 41
  case RGB2Lab = 45
  case RGB2YCrCb = 37
  case RGB2Luv = 51
  case RGB2HLS = 53

  var title: String {
    switch self {
    case .noEffect:
      return "original"
    case .grayscale:
      return "Grayscale"
    case .RGB2BGR:
      return "RGB => BGR"
    case .RGB2HSV:
      return "RGB => HSV"
    case .RGB2YCrCb:
      return "RGB => YCrCb"
    case .RGB2Lab:
      return "RGB => Lab"
    case .RGB2Luv:
      return "RGB => Luv"
    case .RGB2HLS:
      return "RGB => HLS"
    }
  }
}

public enum ThresholdEffect: Int32 {
  case noEffect = -1
  case binary = 0
  case binary_Inv = 1
  case trunc = 2
  case toZero = 3
  case toZero_Inv = 4
  case mask = 7
  case otsu = 8
  case triangle = 16

  var title: String {
    switch self {
    case .noEffect:
      return "original"
    case .binary:
      return "binary"
    case .binary_Inv:
      return "binary_inv"
    case .trunc:
      return "trunc"
    case .toZero:
      return "toZero"
    case .toZero_Inv:
      return "toZero_inv"
    case .mask:
      return "mask"
    case .otsu:
      return "otsu"
    case .triangle:
      return "triangle"

    }
  }
}

public enum BlurEffect: Int32 {
  case noEffect = 1
  case blurSoft = 77
  case blurMiddle = 125
  case blurHard = 345
  
  var title: String {
    switch self {
    case .noEffect:
      return "original"
    case .blurSoft:
      return "soft"
    case .blurMiddle:
      return "middle"
    case .blurHard:
      return "Hard"
    }
  }
}

public enum ClipEffect: Int32 {
  case noEffect = 0
  case rectangle
  case oval
  case circle
  
  var title: String {
    switch self {
    case .noEffect:
      return "original"
    case .rectangle:
      return "rectangle"
    case .oval:
      return "oval"
    case .circle:
      return "circle"
    }
  }
}
