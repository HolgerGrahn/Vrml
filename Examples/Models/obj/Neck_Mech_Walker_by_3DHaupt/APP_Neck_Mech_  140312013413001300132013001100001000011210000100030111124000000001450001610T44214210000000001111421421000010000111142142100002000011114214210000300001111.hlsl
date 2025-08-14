//hlsl:5_0 BSContact Shader Generator: FVF=0x140312 numLights=1 numTextures=4 lightingEnable=1 specularEnable=1 doubleSidedEnable=0 fogEnable=0 vertexLighting=0 pixelLighting=1 vertexColor=0 numTextureCoord=1
// Texture enable & type colorType: [0] = 1 t=3  [1] = 1 t=3  [2] = 1 t=3  [3] = 1 t=3 
cbuffer ModelViewProjectionConstantBuffer {
float4x4 World			: WORLD;
float4x4 View			: VIEW;
float4x4 Projection		: PROJECTION;
float4x4 WorldView		: WORLDVIEW;
float4x4 WorldViewProjection	: WORLDVIEWPROJECTION;
float4x4 WorldViewInverseTranspose	: worldViewInverseTranspose;
};
struct Material
{
	float4 diffuseColor;
	float4 ambientColor;
	float4 specularColor;
	float4 emissiveColor;
	float power;
};
cbuffer MaterialConstantBuffer {
Material material  : MATERIAL;
};
struct Light
{
	float4 ambientColor;
	float4 diffuseColor;
	float4 specularColor;
	float4 positionView;
	float4 directionView;
	float4 attenuation;
	float4 spot;
};
cbuffer LightsConstantBuffer {
Light light[1] 	: LIGHT;
};
float4 AmbientLightColor         	: ambientLightColor;
float3 LambertLighting(float3 lightNormal,float3 surfaceNormal,float3 lightColor)
{
	float diffuseAmount = saturate(dot(lightNormal, surfaceNormal));
	float3 diffuse = diffuseAmount * lightColor;
	return diffuse;
}
float3 SpecularContribution(float3 toEye,float3 lightNormal,float3 surfaceNormal,float materialSpecularPower,float lightSpecularIntensity,float3 lightColor)
{
	float3 vHalf = normalize(lightNormal + toEye);
	float specularAmount = saturate(dot(surfaceNormal, vHalf));
	specularAmount = pow(specularAmount, max(materialSpecularPower,0.0001f)) * lightSpecularIntensity;
	float3 specular = lightColor * specularAmount;
	return specular;
}
float DistanceAttenuation(float distance,float4 attenuation)
{
	if (distance >= attenuation.w)  {  return 0.f; }
	else { return 1.f/(attenuation.x + attenuation.y*distance + attenuation.z*distance*distance);  }
}
void LightDirectionalSpecular(inout float3 diffuse, inout float3 specular, in float3 lightDirection, in float3 eyeVector, in float3 normal, in float materialPower,int lightIndex){
	const float fAtten = 1.f;
	diffuse += fAtten*LambertLighting(lightDirection, normal, light[lightIndex].diffuseColor.rgb);
	specular += fAtten*SpecularContribution(eyeVector, lightDirection, normal, materialPower, 1.0f, light[lightIndex].specularColor.rgb);
}


Texture2D   texture0; // BUMP
SamplerState samp_texture0;

Texture2D   texture1; // DIFFUSE
SamplerState samp_texture1;

Texture2D   texture2; // SPECULAR
SamplerState samp_texture2;

Texture2D   texture3; // REFLECTION
SamplerState samp_texture3;

struct VSIn
{
	float3 Position		: POSITION;
	float3 Normal		: NORMAL;
	float2 Texture0 	: TEXCOORD0;
	float3 Tangent  	: TEXCOORD1;
	float3 Binormal 	: TEXCOORD2;
};

struct VSOut
{
	float4 Position		: SV_POSITION;
	float3 Normal		: TEXCOORD4;
	float3 EyeVector	: TEXCOORD5;
	float2 Texture0		: TEXCOORD0;
	float3 Texture1		: TEXCOORD1;
	float3 Texture2		: TEXCOORD2;
	float2 Texture3		: TEXCOORD3;
	float3 Tangent  	: TANGENT;
	float3 Binormal 	: BINORMAL;
};

struct PSIn
{
	float4 sv_position		: SV_POSITION;
	float3 Normal 		: TEXCOORD4;
	float3 EyeVector	: TEXCOORD5;
	float2 Texture0		: TEXCOORD0;
	float3 Texture1		: TEXCOORD1;
	float3 Texture2		: TEXCOORD2;
	float2 Texture3		: TEXCOORD3;
	float3 Tangent  	: TANGENT;
	float3 Binormal 	: BINORMAL;
};

VSOut VS(VSIn input)
{
	VSOut output = (VSOut)0.0;
	output.Position = mul(float4(input.Position,1.0),WorldViewProjection);
	float3 positionView = mul(float4(input.Position,1.0),WorldView).xyz;
	float3 eyeVector = normalize(-positionView);
	float3 normal = normalize(mul(input.Normal,(float3x3)WorldViewInverseTranspose));
	output.Tangent = normalize(mul(input.Tangent,(float3x3)WorldViewInverseTranspose));
	output.Binormal = normalize(mul(input.Binormal,(float3x3)WorldViewInverseTranspose));
	output.Texture0	 = input.Texture0;
	output.Normal = normal;
	output.EyeVector = eyeVector;
	return output;
}
float4 PS(in PSIn input) : SV_TARGET
{
	float4 color;
	float3 normal = normalize(input.Normal);
	float3 eyeVector = normalize(input.EyeVector);
	float4 NormalColor=texture0.Sample(samp_texture0,input.Texture0.xy);
	float3 normalMap = 2.0f * NormalColor.xyz - 1.0f;
	normal = normalize((normalMap.x * input.Tangent) + (normalMap.y * input.Binormal) + (normalMap.z * input.Normal));
	float4 materialDiffuse = material.diffuseColor;
	float3 diffuse  = 0.0f;
	float3 specular = 0.0f;
	float4 textureColor1=texture1.Sample(samp_texture1,input.Texture0.xy);
	materialDiffuse *= textureColor1;
	float4 Albedo = 1.f;
	float4 AO = 1.f;
	float4 Metallic = 1.f;
	float4 Roughness = 1.f;
	{
	float3 lightDirection = -light[0].directionView.xyz;
	float fAtten = 1.f;
	diffuse.rgb+=fAtten*(material.ambientColor.rgb*light[0].ambientColor.rgb);
	diffuse+=fAtten*LambertLighting(lightDirection,normal,light[0].diffuseColor.rgb);
	specular+=fAtten*SpecularContribution(eyeVector,lightDirection,normal,material.power, 1.0f, light[0].specularColor.rgb);
	}
	diffuse.rgb=saturate(diffuse)*materialDiffuse.rgb;
	diffuse.rgb+=material.ambientColor.rgb * AmbientLightColor.rgb;
	diffuse.rgb+=material.emissiveColor.rgb;
	specular.rgb=saturate(specular.rgb)*material.specularColor.rgb;
	specular.rgb *= texture2.Sample(samp_texture2,input.Texture0.xy).rgb; /// xxxxxxxx
	color=float4(diffuse+specular,materialDiffuse.a);
	
	// reflection 
	
	float3 envCoord = reflect(-eyeVector,normal);
	float4 environmentColor=texture3.Sample(samp_texture3,envCoord.xy);
	color.rgb+=environmentColor.rgb;
	return color;
}
