
import Metal

struct VertexDescriptors
{
    let depthOnly: MTLVertexDescriptor = {
        let descriptor = MTLVertexDescriptor()
        //position
        let position = descriptor.attributes[VertexAttribute.position.rawValue]
        position?.format = .float3
        position?.bufferIndex = BufferIndex.meshPositions.rawValue
        descriptor.layouts[BufferIndex.meshPositions.rawValue].stride = 4 * 3
        return descriptor
    }()
    
    let basic: MTLVertexDescriptor = {
        let descriptor =  MTLVertexDescriptor()
        //position
        let position = descriptor.attributes[VertexAttribute.position.rawValue]
        position?.format = .float3
        position?.bufferIndex = BufferIndex.meshPositions.rawValue
        descriptor.layouts[BufferIndex.meshPositions.rawValue].stride = 4 * 3
      
        //texcoord
        let texcoord = descriptor.attributes[VertexAttribute.texcoord.rawValue]
        texcoord?.format = .float2
        texcoord?.bufferIndex = BufferIndex.meshGenerics.rawValue
        //normals
        let normals = descriptor.attributes[VertexAttribute.normal.rawValue]
        normals?.format = .half3
        normals?.offset = 4 * 2
        normals?.bufferIndex = BufferIndex.meshGenerics.rawValue
        //tangents
        let tangents = descriptor.attributes[VertexAttribute.tangent.rawValue]
        tangents?.format = .half4
        tangents?.offset = (4 * 2) + (2 * 3)
        tangents?.bufferIndex = BufferIndex.meshGenerics.rawValue
        
        descriptor.layouts[BufferIndex.meshGenerics.rawValue].stride = (4 * 2) + (2 * 3) + (2 * 4) 
        
        return descriptor
    }()
}
