//
//  PipelineStates.swift
//  AppleMetalLearn
//
//  Created by barkar on 14.04.2024.
//

import MetalKit

enum PipelineStates{
    
    
    static func createPipelineState(descriptor: MTLRenderPipelineDescriptor) -> MTLRenderPipelineState
    {
        let pipelineState: MTLRenderPipelineState
        do {
            pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: descriptor)
        }catch{
            fatalError(error.localizedDescription)
        }
        
        return pipelineState
        
    }
    
    static func createGBufferPipelineState(vertexFunctionName: String, fragmentFunctionName: String) -> MTLRenderPipelineState{
        let vertexFunction = Renderer.library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = Renderer.library?.makeFunction(name: fragmentFunctionName)
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        
        
        //RENDER TARGET PIXEL FORMAT
        pipelineDescriptor.colorAttachments[0].pixelFormat = .invalid
        
        pipelineDescriptor.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].pixelFormat = PixelFormats.albedo
        pipelineDescriptor.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].pixelFormat = PixelFormats.normal
        pipelineDescriptor.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].pixelFormat = PixelFormats.roughMetallic
        pipelineDescriptor.colorAttachments[RenderTargetIndex.depth.rawValue].pixelFormat = .r32Float

        //ATTACHMENT PIXEL FORMATS
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        pipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        
        //VERTEX DESCRIPTOR
        pipelineDescriptor.vertexDescriptor = VertexDescriptors().basic
        return createPipelineState(descriptor: pipelineDescriptor)
    }
    
    static func createeDirectionalLightPipelineState(vertexFunctionName: String, fragmentFunctionName: String, colorPixelFormat: MTLPixelFormat) -> MTLRenderPipelineState
    {
        let vertexFunction = Renderer.library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = Renderer.library?.makeFunction(name: fragmentFunctionName)
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat =  colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        pipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        return createPipelineState(descriptor: pipelineDescriptor)
    }
    
    static func createShadowPipelineState() -> MTLRenderPipelineState{
        let vertexFunction = Renderer.library?.makeFunction(name: "vertex_depth")
          let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .invalid
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = VertexDescriptors().depthOnly
        return createPipelineState(descriptor: pipelineDescriptor)
    }
    
}

    

