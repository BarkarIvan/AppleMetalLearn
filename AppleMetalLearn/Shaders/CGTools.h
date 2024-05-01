//
//  CGTools.h
//  AppleMetalLearn
//
//  Created by barkar on 30.04.2024.
//

#ifndef CGTools_h
#define CGTools_h
#import "ShaderTypes.h"


half3 reconstruct_normal(half2 vec);

half2 safeNormalize(half2 vec);

half3 safeNormalize(half3 vec);

#endif /* CGTools_h */
