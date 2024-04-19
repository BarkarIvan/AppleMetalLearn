//
//  RenderDestination.swift
//  AppleMetalLearn
//
//  Created by barkar on 19.04.2024.
//

import MetalKit

protocol RenderDestination{
    var colorPixelFormat: MTLPixelFormat {get set}
    var depthStencilPixelFormat: MTLPixelFormat {get set}
    
}

extension MTKView: RenderDestination{}
