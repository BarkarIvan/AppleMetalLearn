//
//  Model.swift
//  AppleMetalLearn
//
//  Created by barkar on 10.04.2024.
//

import MetalKit
class Model: Transformable{
    
    var transform =  Transform()
    var meshes: [Mesh] = []
    var name: String = "Untitled"
    var tiling: UInt32 = 1
    var materials: [Material] = []
    
    init(){}
    
    
    init(name: String, mdlMesh: MDLMesh, mtkMesh: MTKMesh){
        
        self.meshes = [Mesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh)]
        self.name = name
        
    }
    
    init(name: String, materials: [Material]){
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else{
            fatalError("Model /(name) not found")
        }
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: nil, bufferAllocator: allocator)
        
        
        let mdlVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(VertexDescriptors().basic)
        guard let attributes = mdlVertexDescriptor.attributes as? [MDLVertexAttribute] else {
            fatalError("Bad vertex descriptor")
        }
        attributes[VertexAttribute.position.rawValue].name = MDLVertexAttributePosition
        attributes[VertexAttribute.texcoord.rawValue].name = MDLVertexAttributeTextureCoordinate
        attributes[VertexAttribute.normal.rawValue].name = MDLVertexAttributeNormal
        attributes[VertexAttribute.tangent.rawValue].name = MDLVertexAttributeTangent
        
        
        var mtkMeshes: [MTKMesh] = []
        let mdlMeshes = asset.childObjects(of: MDLMesh.self) as? [MDLMesh] ?? []
        _ = mdlMeshes.map
        {
            mdlMesh in
            mdlMesh.addOrthTanBasis(forTextureCoordinateAttributeNamed: MDLVertexAttributeTextureCoordinate,
                                        normalAttributeNamed: MDLVertexAttributeNormal,
                                        tangentAttributeNamed: MDLVertexAttributeTangent)
            
           mdlMesh.vertexDescriptor = mdlVertexDescriptor

           mtkMeshes.append(try! MTKMesh(mesh: mdlMesh, device: Renderer.device))
        }
        
        meshes = zip(mdlMeshes, mtkMeshes).map { Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }
        self.materials = materials
        self.name = name
    }
    

    func render ( encoder: MTLRenderCommandEncoder, uniforms vertex: Uniforms, params fragment: Params, needMaterial: Bool = true){
        
        var uniforms = vertex
        var params = fragment
        params.tiling = tiling
        
        uniforms.modelMatrix = transform.modelMatrix
        uniforms.normalMatrix = transform.modelMatrix.upperLeft
        
        encoder.pushDebugGroup("Set vertex and fragment bytes")
        //exclude
        encoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: BufferIndex.uniforms.rawValue)
        encoder.setFragmentBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: BufferIndex.uniforms.rawValue)
        encoder.popDebugGroup()
        
        for mesh in meshes {
            for(index, vertexBuffer) in mesh.vertexBuffers.enumerated(){
                encoder.setVertexBuffer(vertexBuffer, offset: 0, index: index)
            }
            
            for (index,submeshe) in mesh.submeshes.enumerated() {
                
                if needMaterial{
                    let material = materials[index % materials.count]
                    var materialProps = material.properties
                    encoder.setFragmentBytes(&materialProps, length: MemoryLayout<MaterialProperties>.stride, index: BufferIndex.material.rawValue)
                    
                    
                    //TODO: refactor
                    encoder.setFragmentTexture(material.baseColorTexture, index: TextureIndex.color.rawValue)
                    
                    encoder.setFragmentTexture(material.normalXYRoughMetallic, index: TextureIndex.additional.rawValue)
                    
                    encoder.setFragmentTexture(material.emissionTexture, index: TextureIndex.emission.rawValue)
                }
                
                encoder.drawIndexedPrimitives(type: .triangle, indexCount: submeshe.indexCount,
                                              indexType: submeshe.indexType, 
                                              indexBuffer: submeshe.indexBuffer,
                                              indexBufferOffset: submeshe.indexBufferOffset)
            }
        }
    }
}


