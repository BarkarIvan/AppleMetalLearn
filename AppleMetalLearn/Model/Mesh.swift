//
//  Mesh.swift
//  AppleMetalLearn
//
//  Created by barkar on 10.04.2024.
//

import MetalKit

struct Mesh{
    var vertexBuffers: [MTLBuffer]
    var submeshes: [Submesh]
}


extension Mesh {
    init(mdlMesh: MDLMesh, mtkMesh: MTKMesh) {
        
        //OPTIMIZE LAYOUT
      var vertexBuffers: [MTLBuffer] = []
      for mtkMeshBuffer in mtkMesh.vertexBuffers {
        vertexBuffers.append(mtkMeshBuffer.buffer)
      }
      self.vertexBuffers = vertexBuffers
      submeshes = zip(mdlMesh.submeshes!, mtkMesh.submeshes).map { mesh in
        Submesh(mdlSubmesh: mesh.0 as! MDLSubmesh, mtkSubmesh: mesh.1)
      }
    }
  }

