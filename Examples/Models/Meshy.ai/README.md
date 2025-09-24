# VRML.github.io
3D Models generated with https://www.meshy.ai/

OBJ MTL File tweaked for normal map import for BSContact with ShaderGenerator (DX11 /DX9)

MTL File:
map_Kd Image_0.001.jpg
map_Albedo chinese_dragon_with_b_1113143456_refine_albedo.jpg
map_Metallic chinese_dragon_with_b_1113143456_refine_metallic.jpg
map_Normal chinese_dragon_with_b_1113143456_refine_normal.jpg
map_Roughness chinese_dragon_with_b_1113143456_refine_roughness.jpg

After Import:

	MultiTexture {
			type [
				"DIFFUSE","ALBEDO","METALLIC","NORMAL",	"ROUGHNESS"]
			texture [
				ImageTexture {url "Image_0.001.jpg"}
				
				ImageTexture {url "chinese_dragon_with_b_1113143456_refine_albedo.jpg"}
				
				ImageTexture {url "chinese_dragon_with_b_1113143456_refine_metallic.jpg"}
				
				ImageTexture {url "chinese_dragon_with_b_1113143456_refine_normal.jpg"}
				
				ImageTexture {url "chinese_dragon_with_b_1113143456_refine_roughness.jpg"}
			]
		}
		


Currently map_Normal is implemented in shader generator

