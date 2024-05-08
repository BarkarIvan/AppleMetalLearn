//
//  PixelFormats.swift
//  AppleMetalLearn
//
//  Created by barkar on 24.04.2024.
//

import MetalKit

struct PixelFormats {
    static var gBufferAlbedoShadow: MTLPixelFormat = .rgba8Unorm_srgb
    static var gbufferNormalRoughtess: MTLPixelFormat = .rgba16Float
    static var gBufferEmissionMetallic: MTLPixelFormat = .rgba8Unorm_srgb
   // static var roughMetallic: MTLPixelFormat = .rgba8Unorm_srgb
    static var gBufferDepth: MTLPixelFormat = .r32Float
    static var depthStencil: MTLPixelFormat = .depth32Float_stencil8
    
}
