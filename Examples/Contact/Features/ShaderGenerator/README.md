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
or automatically for texthre mode "NORMAL" "BUMP" 
		
		
generated shaders can be written to file , see Shader Generator.wrl

Sphere_Normalmap_Brick-PackagedShader.wrl - shaders for DX9 (FX) and DX11 (hlsl) has been exported to a PackagedShader node 


models/angusface.wrl	- serveral lights on smooth surfaces good for lighting per pixel

models/football/football.wrl  - Bump & Reflection
MultiTexture   {
	type ["DIFFUSE","BUMP" "REFLECTION"]
			texture [
				ImageTexture {url "football_tex_lowpoly.png"}
				ImageTexture {url "football_NM.png"}
				ImageTexture {url "../../../textures/cubemaps/NV-Metal-ADXT1.dds"}
			]
	}		
	
in addition the X3D Version 4.0 Material has been implemented which supports adding a modulation texture 
for each material paramenter, i.e. ambientTexture emissiveTexture specularTexture shininessTexture and normalTexture.
X3D Material node is used for X3D 4.0 files, in this case also material.diffuseColor is modulated with Appearance.texture / Material.diffuseTexture.
for RGB/RGBA textures.
In VRML97 diffuseColor was ignored in this case in the lighting model.
