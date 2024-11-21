float4x4 wvpMatrix : WorldViewProjection;
float4x4 WorldView : 		WORLDVIEW;
float4x4 World : 	WORLD;
float4 viewPosition:        VIEWPOSITION;

texture diffuse : TEXTURE_DIFFUSE;
uniform float time;

uniform bool isOver;
uniform bool isPushed;

sampler2D diffuse_sampler = sampler_state
{
	Texture = <diffuse>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = Wrap;
	AddressV = Wrap;
};

sampler2D blurX = sampler_state
{
	Texture = <diffuse>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = Wrap;
	AddressV = Wrap;
};


sampler2D blurY = sampler_state
{
	Texture = <diffuse>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = Wrap;
	AddressV = Wrap;
};




// -----------------------------------------------------------------------------


struct VS_INPUT { 
  float4 Position : POSITION;
  float4 UV		  : TEXCOORD0;
  
} IN;



struct VS_OUTPUT {
	float4 pPos  : POSITION;  // pixels position for pixel shader
	float4 UV	 : TEXCOORD0;
} vs_out;


VS_OUTPUT VS (VS_INPUT IN)
{
	vs_out.pPos = mul(IN.Position, wvpMatrix);
	vs_out.UV = IN.UV;
	return vs_out;
}



float4 PS(VS_OUTPUT vs): COLOR
{	
	//float color = tex2D(diffuse_sampler, vs.UV);
	
	// check the gradien:
	float4 gradX, gradY;
	
	float2 dir = normalize(vs.UV - float2(0.5f, 0.5f));
	
	float3x3 R = {cos(time), -sin(time), 0, sin(time), cos(time), 0, 0, 0, 1};
	dir = normalize(mul(dir,R));
	
	//float2 newTC = float2(0.5, 0.5) + dir*length(vs.UV-float2(0.5f, 0.5f));
	
	float dist = length(vs.UV - float2(0.5f, 0.5f));
	
	float4 accum = float4(0,0,0,0);
	
	float amp = 2*cos(time+dir.x*dir.y);
	
	for (int i=0; i < 10; ++i)
	{
		//float2 currTexC = newTC - i*(amp/128)*dir;
		float2 currTexC = vs.UV - i*(amp/128)*dir;
		gradX = tex2D(diffuse_sampler, currTexC + i*float2(1.0f/128,0)) - tex2D(diffuse_sampler, currTexC - float2(1.0f/128,0));
		gradY = tex2D(diffuse_sampler, currTexC + i*float2(0,1.0f/128)) - tex2D(diffuse_sampler, currTexC - float2(0,1.0f/128));
		float len = length(gradX.xyz+gradY.xyz);
		float4 color = tex2D(diffuse_sampler, currTexC);
		accum += float4(1,0,0,color.w)*len;
	}
	float4 color = tex2D(diffuse_sampler, vs.UV + float2(1.0f/128,0));

	return 0.1*accum + color;
}



	
technique test
{
    pass P0
    {
		VertexShader = compile vs_2_0 VS();
		PixelShader  = compile ps_2_a PS();
    }  
}




















