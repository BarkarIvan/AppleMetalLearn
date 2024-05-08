
import MetalKit
enum DepthStensilPipelineStates
{
    
    //COMMON
    static func buildCommonDepthStencilState() -> MTLDepthStencilState?{
        let deescriptor = MTLDepthStencilDescriptor()
        deescriptor.depthCompareFunction = .less
        deescriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: deescriptor)
    }
    
    //GBUFFER
    static func buildGBufferDepthStencilState() -> MTLDepthStencilState?{
        let deescriptor = MTLDepthStencilDescriptor()
        
        let stencilDescriptor = MTLStencilDescriptor()
        stencilDescriptor.depthStencilPassOperation = .replace
        
        deescriptor.frontFaceStencil = stencilDescriptor
        deescriptor.backFaceStencil = stencilDescriptor
        deescriptor.depthCompareFunction = .less
        deescriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: deescriptor)
    }
    
    //DIRECTIONAL LIGHT
    static func buildDirectionalLightDepthStencilState() -> MTLDepthStencilState?{
        let deescriptor = MTLDepthStencilDescriptor()
        
        let stencilDescriptor = MTLStencilDescriptor()
        stencilDescriptor.stencilCompareFunction = .equal
        stencilDescriptor.readMask = 0xFF
        stencilDescriptor.writeMask = 0x0
       
        deescriptor.frontFaceStencil = stencilDescriptor
        deescriptor.backFaceStencil = stencilDescriptor
        return Renderer.device.makeDepthStencilState(descriptor: deescriptor)
    }
    
    //LIGHT MASK
    static func buildLightMaskDepthStencilState() -> MTLDepthStencilState?{
        let stencilStateDescriptor = MTLStencilDescriptor()
        stencilStateDescriptor.depthFailureOperation = .incrementClamp
        
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.backFaceStencil = stencilStateDescriptor
        descriptor.frontFaceStencil = stencilStateDescriptor
       
        return Renderer.device.makeDepthStencilState(descriptor: descriptor)
    }
    
    
    //POINT LIGHT
    static func buildPointLightsDepthStencilState() -> MTLDepthStencilState?
    {
        let stencilStateDeescriptor = MTLStencilDescriptor()
        stencilStateDeescriptor.stencilCompareFunction = .less
        stencilStateDeescriptor.writeMask = 0x0
        stencilStateDeescriptor.readMask = 0xFF
        
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.frontFaceStencil = stencilStateDeescriptor
        descriptor.backFaceStencil = stencilStateDeescriptor
        return Renderer.device.makeDepthStencilState(descriptor: descriptor)
    }
}
