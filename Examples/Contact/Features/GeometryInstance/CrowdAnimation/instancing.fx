float4x4 WorldView : 		WORLDVIEW;

//--------------------------------------------------------------------------------------
// Global variables
//--------------------------------------------------------------------------------------

//texture diffuse : TEXTURE_DIFFUSE;

/*sampler2D diffuse_sampler = sampler_state
{
	Texture = <diffuse>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = Wrap;
	AddressV = Wrap;
};*/


bool flipTexture;



// define material structure
struct Material
{ // matches D3DMATERIAL9
  float4 diffuseColor;
  float4 ambientColor;
  float4 specularColor;
  float4 emissiveColor;
  float power;
};

Material material : MATERIAL = {
  float4(1.0f, 1.0f, 1.0f, 1.0f), //diffuse
  float4(0.0f, 0.0f, 0.0f, 0.0f), //ambient
  float4(0.0f, 0.0f, 0.0f, 0.0f), //specular
  float4(0.0f, 0.0f, 0.0f, 0.0f), //Emissive
  0.0
};

struct Light {
float4 diffuseColor;
float4 ambientColor;
float4 specularColor;
float3 position;
float3 direction;
};

Light light : LIGHT = {
  float4(1.0f, 1.0f, 1.0f, 1.0f), //diffuse
  float4(0.0f, 0.0f, 0.0f, 0.0f), //ambient
  float4(0.0f, 0.0f, 0.0f, 0.0f), //specular
  float3(0.0f, 0.0f, 0.0f), //position
  float3(0.0f, 0.0f, -1.0f) //direction
};

texture meshTex:TEXTURE_DIFFUSE;              // Color texture for mesh

//float4x4 g_mWorld;                  // World matrix for object
float4x4 g_mViewProj:ViewProjection;
float4x4 g_mViewInverse:ViewProjectionI;

float4 viewPosition:VIEWPOSITION;

//--------------------------------------------------------------------------------------
// Texture samplers
//--------------------------------------------------------------------------------------
sampler MeshTextureSampler = 
sampler_state
{
    Texture = <meshTex>;
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    AddressU  = WRAP;        
    AddressV  = WRAP;
    AddressW  = WRAP;    
};

//--------------------------------------------------------------------------------------
// Vertex shader output structure
//--------------------------------------------------------------------------------------
struct VS_OUTPUT
{
    float4 Position   : POSITION;   // vertex position 
    float2 TextureUV  : TEXCOORD0;  // vertex texture coords 
    float3 WorldNormal	: TEXCOORD1;
    float3 WorldView	: TEXCOORD2;
    float4 WorldPosition   : TEXCOORD3;   // vertex position 
	float3 dist : TEXCOORD4; // vertex distance to the camera (KB)
    float4 Color		: COLOR;
};

/*
	This shared shader code
*/
VS_OUTPUT SharedVS(		 float4 vPos, 
                         float3 vNormal,
                         float2 vTexCoord0,
                         float4x4 mWorld,  //is transposed World matrix
                         float4 cInstanceColor)
{
    VS_OUTPUT Output;

	// Put object info into world space									
    Output.WorldNormal = normalize(mul(vNormal, (float3x3)mWorld));

	//	    Output.WorldNormal = vNormal;

    
    float4 Po = float4(vPos.xyz,1.0);				// object coordinates
    float3 Pw = mul(Po,mWorld).xyz;					// world coordinates

    Output.WorldView = (0.5*normalize(g_mViewInverse[3].xyz - Pw))+0.5.xxx;	// obj coords
    Output.Position = mul(float4(Pw,1.0),g_mViewProj);			// screen clipspace coords
    Output.WorldPosition = Output.Position;
    Output.Color = cInstanceColor;
	Output.dist = viewPosition.xyz - Pw;
      
    // Just copy the texture coordinate through
    Output.TextureUV = vTexCoord0; 
    return Output;
    
}


//--------------------------------------------------------------------------------------
// This shader computes standard transform and lighting and uses a matrix passed in on 2nd stream
//		to position object
//--------------------------------------------------------------------------------------

VS_OUTPUT InstancedVS( float4 vPos : POSITION, 
                         float3 vNormal : NORMAL,
                         float2 vTexCoord0 : TEXCOORD0,
                         float4 vInstanceMatrix1 : TEXCOORD8,
                         float4 vInstanceMatrix2 : TEXCOORD9,
                         float4 vInstanceMatrix3 : TEXCOORD10,
                         float4 cInstanceColor : COLOR3)
{
    VS_OUTPUT Output;

	// We've encoded the 4x3 world matrix in a 3x4, so do a quick transpose so we can use it in DX
	float4 row1 = float4(vInstanceMatrix1.x,vInstanceMatrix2.x,vInstanceMatrix3.x,0);
	float4 row2 = float4(vInstanceMatrix1.y,vInstanceMatrix2.y,vInstanceMatrix3.y,0);
	float4 row3 = float4(vInstanceMatrix1.z,vInstanceMatrix2.z,vInstanceMatrix3.z,0);
	float4 row4 = float4(vInstanceMatrix1.w,vInstanceMatrix2.w,vInstanceMatrix3.w,1);
	float4x4 mInstanceMatrix = float4x4(row1,row2,row3,row4);
										
	return SharedVS(vPos,vNormal,flipTexture?float2(vTexCoord0.x,1.0-vTexCoord0.y):vTexCoord0,mInstanceMatrix,cInstanceColor);
}

//--------------------------------------------------------------------------------------
// Pixel shader output structure
//--------------------------------------------------------------------------------------

float4 InstancedPS(VS_OUTPUT IN) : COLOR 
{
	float diff = dot(IN.WorldNormal, normalize(IN.dist));
	float spec = pow(max(0, diff), material.power);
	float4 ret = diff*material.diffuseColor + spec*material.specularColor + material.emissiveColor;
	ret.w = 1.0;
	
	return ret;
	
/*	// Calculate the half vector
	float3 halfway = normalize(normalize(light.direction) + normalize(IN.WorldPosition-viewPosition));
	
	// Calculate the diffuse reflection
	float3 diffuse = saturate(dot(IN.WorldNormal, -light.direction)) * material.diffuseColor*light.diffuseColor;
	
	// Calculate the specular reflection
	float3 specular = pow(saturate(dot(IN.WorldNormal, -halfway)), material.power) * saturate(material.specularColor*light.specularColor);
	
	float3 color = saturate((light.ambientColor * material.ambientColor)+diffuse)+specular+material.emissiveColor;
	float alpha =material.diffuseColor.a;

	return  float4(color, 0.5);*/
}

//--------------------------------------------------------------------------------------
// Pixel shader output structure with texture
//--------------------------------------------------------------------------------------

float4 InstancedTexturePS(VS_OUTPUT IN) : COLOR 
{
	float4 tex = tex2D(MeshTextureSampler, IN.TextureUV);
	/*
	if(tex.w < 0.5f) // alpha test 
	{
		clip(-1);
		return float4(0,0,0,0);
	}
*/	

	float diff = max(0.5, dot(normalize(IN.WorldNormal.xyz), normalize(IN.dist)));
	float spec = pow(max(0, diff), material.power);
	float4 ret = diff * tex;// + 0.25*(spec*tex + tex*material.emissiveColor);

	ret.w = 1.0;
	return float4(1,0,0,1);//ret;
}
//--------------------------------------------------------------------------------------
// Renders scene to render target
//--------------------------------------------------------------------------------------
technique RenderSceneInstance
{
    pass P0
    {       
       VertexShader = compile vs_2_0 InstancedVS();
       PixelShader  = compile ps_2_a InstancedPS(); 
    }
}
technique RenderSceneInstanceTexture
{
    pass P0
    {       
				//ALPHATESTENABLE = TRUE;
       VertexShader = compile vs_2_0 InstancedVS();
       PixelShader  = compile ps_2_a InstancedTexturePS(); 
			 //ALPHATESTENABLE = FALSE;
    }
}