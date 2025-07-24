# basic BSContact Shader Generator Examples

Shader generator detects the type of textures, and creates corresponding HLSL code, in this case reflection


BumpReflect.wrl - Mesh with Tangent and Binormal, bump + reflecton map

MultiTexture   {
			texture	[
				 DEF normalMap ImageTexture { url "../textures/FieldstoneBumpDOT3.jpg" }

				 DEF cubeMap ImageTexture { url [ "../textures/Default_reflection.dds" ]}

			]
			type ["NORMAL", "REFLECTION"]

		}
		
Tangent and Binormal information per mesh vertex is created by
		TextureCoordGen	{ mode "TANGENT" parameter [ 0 2 ] }
		
		
generated shaders can be written to file , see Shader Generator.wrl

Sphere_Normalmap_Brick-PackagedShader.wrl - shaders for DX9 (FX) and DX11 (hlsl) has been exported to a PackagedShader node 