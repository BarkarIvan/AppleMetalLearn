//
//  DepthSteencilStates.swift
//  AppleMetalLearn
//
//  Created by barkar on 30.04.2024.
//

import Metal
enum DepthStencilStates
{
    
    static func createShadowDepthStencilState() -> MTLDepthStencilState
    {
        let depthStecilDescriptor = MTLDepthStencilDescriptor()
        depthStecilDescriptor.isDepthWriteEnabled = true
        depthStecilDescriptor.depthCompareFunction = .lessEqual
        return createDepthStencilState(label: "Shadow depth state", descriptor: depthStecilDescriptor)
    }
    
    static func crateGbufferDepthStencilState() -> MTLDepthStencilState
    {
        let stecilStateDescriptor =  MTLStencilDescriptor()
        stecilStateDescriptor.depthStencilPassOperation = .keep //???
       
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.isDepthWriteEnabled = true
        descriptor.depthCompareFunction = .less
        descriptor.frontFaceStencil = stecilStateDescriptor
        descriptor.backFaceStencil = stecilStateDescriptor
        return createDepthStencilState(label: "Gbuffer depth stencil state", descriptor: descriptor)
    }
    
   // static func createeDirecctionLightDepthStencilState() -> //MTLDepthStencilState
   // {
        //let stencil
   // }
    
    static func buildDepthStencilState() -> MTLDepthStencilState?{
        let deescriptor = MTLDepthStencilDescriptor()
        deescriptor.depthCompareFunction = .less
        deescriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: deescriptor)
    }
    
    static func createDepthStencilState (label: String, descriptor: MTLDepthStencilDescriptor) -> MTLDepthStencilState
    {
        descriptor.label = label
        
        if let depthStencilState = Renderer.device.makeDepthStencilState(descriptor: descriptor){
            return depthStencilState
        }else{
            fatalError("Failed create depth stencil state")
        }
    }
    
    
}
