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
    
    init(){}
    
    init(name: String){
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else{
            fatalError("Model /(name) not found")
        }
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .defaultLayout, bufferAllocator: allocator)
        
        asset.loadTextures()
        var mtkMeshes: [MTKMesh] = []
        let mdlMeshes = asset.childObjects(of: MDLMesh.self) as? [MDLMesh] ?? []
        _ = mdlMeshes.map 
        {
            mdlMesh in mdlMesh.addTangentBasis(forTextureCoordinateAttributeNamed: MDLVertexAttributeTextureCoordinate, normalAttributeNamed: MDLVertexAttributeNormal, tangentAttributeNamed: MDLVertexAttributeTangent)
            mtkMeshes.append(try! MTKMesh(mesh: mdlMesh, device: Renderer.device))
            
        }
        meshes = zip(mdlMeshes, mtkMeshes).map { Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }
        self.name = name
    }
}

//TODO: TEMP
extension Model{
    func setTexture(name: String, type: TextureIndex){
        if let texture = TextureController.loadTexture(name: name){
            switch type{
            case TextureIndex.color:
                meshes[0].submeshes[0].textures.baseColor = texture
            default: break
            }
        }
    }
}


