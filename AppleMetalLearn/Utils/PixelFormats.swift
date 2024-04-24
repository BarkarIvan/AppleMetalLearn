//
//  PixelFormats.swift
//  AppleMetalLearn
//
//  Created by barkar on 24.04.2024.
//

import MetalKit

struct PixelFormats {
    static var albedo: MTLPixelFormat = .bgra8Unorm_srgb
    static var normal: MTLPixelFormat = .rgba8Snorm
    static var roughMetallic: MTLPixelFormat = .rg8Unorm
    static var depth: MTLPixelFormat = .depth32Float
}
