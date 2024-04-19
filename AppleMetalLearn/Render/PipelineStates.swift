//
//  PipelineStates.swift
//  AppleMetalLearn
//
//  Created by barkar on 14.04.2024.
//
import MetalKit

struct PipelineStates{
    
    let device: MTLDevice
    let library: MTLLibrary
    let singlePass: Bool
    let colorPixelFormat: MTLPixelFormat
    let depthStencilPixelFormat: MTLPixelFormat
    
 //   let vertexDescriptors = VertexDescriptors()
    
    
    //STATES
    lazy var shadowGenerationState = makeRenderPipelineState(label: "Shadow Stage")
    {
        descriptor in
        descriptor.vertexFunction = library.makeFunction(name: "shadow_vertex")
        descriptor.depthAttachmentPixelFormat = .depth32Float
    }
    
    lazy var gBufferGeneration = makeRenderPipelineState(label: "GBuffer Stage")
    {
        descriptor in
        descriptor.vertexFunction = library.makeFunction(name: "gbuffer_vertex")
        descriptor.fragmentFunction = library.makeFunction(name: "gbuffer_fragment")
        descriptor.vertexDescriptor = .defaultLayout
        descriptor.depthAttachmentPixelFormat = depthStencilPixelFormat
        descriptor.stencilAttachmentPixelFormat = depthStencilPixelFormat
        
        if GBufferTextures.isAttachedInFinalPass
        {
            descriptor.colorAttachments[RenderTargetIndex.lighting.rawValue]?.pixelFormat = colorPixelFormat
        }
        
        setRendeTargetPixelFormats(descriptor: descriptor)
    }
    
    
    //another passes
    ///
    
    
    
    
    
    init(device: MTLDevice, renderDestination: RenderDestination, singlePass: Bool)
    {
        self.device = device
        guard let library = device.makeDefaultLibrary()
        else
        {
            fatalError("Failed to ceate library")
        }
        
        self.library = library
        self.singlePass = singlePass
        
        colorPixelFormat = renderDestination.colorPixelFormat
        depthStencilPixelFormat = renderDestination.depthStencilPixelFormat
    }
    

    func makeRenderPipelineState(label: String, block: (MTLRenderPipelineDescriptor)->Void) -> MTLRenderPipelineState
    {
        let descriptor = MTLRenderPipelineDescriptor()
        block(descriptor)
        
        descriptor.label = label
        do {
            return try device.makeRenderPipelineState(descriptor: descriptor)
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    func setRendeTargetPixelFormats(descriptor: MTLRenderPipelineDescriptor){
        
        descriptor.colorAttachments[RenderTargetIndex.albedoMetallic.rawValue]?.pixelFormat = GBufferTextures.albedoMettalicPixelFormat
        
        descriptor.colorAttachments[RenderTargetIndex.nomalRoughtnessShadow.rawValue]?.pixelFormat = GBufferTextures.normlRoughnessShadowPixelFormat
        
        descriptor.colorAttachments[RenderTargetIndex.depth.rawValue]?.pixelFormat = GBufferTextures.depthPixelFormat
    }
    
}

    

