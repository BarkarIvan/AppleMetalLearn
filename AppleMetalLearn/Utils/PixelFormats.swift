//
//  PixelFormats.swift
//  AppleMetalLearn
//
//  Created by barkar on 24.04.2024.
//

import MetalKit

struct PixelFormats {
    static var albedo: MTLPixelFormat = .rgba8Unorm_srgb
    static var normal: MTLPixelFormat = .rgba16Float
    static var emission: MTLPixelFormat = .rgba8Unorm_srgb
    static var roughMetallic: MTLPixelFormat = .rgba8Unorm_srgb
    static var depth: MTLPixelFormat = .r32Float
    //static var stencil: MTLPixelFormat = .depth32Float_stencil8
    
}
