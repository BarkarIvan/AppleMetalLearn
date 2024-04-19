//
//  DepthStencilStates.swift
//  AppleMetalLearn
//
//  Created by barkar on 19.04.2024.
//

import Metal

struct DepthStencilStates{
    
    let device: MTLDevice
    lazy var shadowGenerationState = makeDepthStencilState(label: "Shadow Depth Stage")
    {
        descriptor in
        descriptor.isDepthWriteEnabled = true
        descriptor.depthCompareFunction = .lessEqual
    }
    
    lazy var gBuffergeneration = makeDepthStencilState(label: "GBuffer Depth Stage")
    {
        descriptor in
        var stencilStateDescriptor: MTLStencilDescriptor?
         //if light stencil cull
        stencilStateDescriptor = MTLStencilDescriptor()
        stencilStateDescriptor?.depthStencilPassOperation = .replace
        //
        
        descriptor.isDepthWriteEnabled = true
        descriptor.depthCompareFunction = .less
        descriptor.frontFaceStencil = stencilStateDescriptor
        descriptor.backFaceStencil = stencilStateDescriptor
    }
    
    
    
    
    
    
    init (device: MTLDevice)
    {
        self.device = device
    }
    
    func makeDepthStencilState(label: String,
                               block: (MTLDepthStencilDescriptor)->Void) -> MTLDepthStencilState
    {
            let descriptor = MTLDepthStencilDescriptor()
        block(descriptor)
        descriptor.label = label
        
        if let depthStencilState = device.makeDepthStencilState(descriptor: descriptor)
        {
            return depthStencilState
        }else{
            fatalError("Failed to create depth stencil state")
        }
        
    }
}
