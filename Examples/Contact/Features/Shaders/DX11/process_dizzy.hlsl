
// dizzy (rotation) postprocess shader 


// assume image bound to sampler 0

Texture2D inputTexture: register(s0);
SamplerState samp_inputTexture : register(s0);


// transformations
float4x4 WorldViewProj : 	WORLDVIEWPROJECTION;


struct VS_OUTPUT
{
    float4 Pos  : SV_POSITION;
    float2 Tex  : TEXCOORD0;
};

VS_OUTPUT VS(
    float4 Pos  : POSITION, 
    float2 Tex  : TEXCOORD0
    )
{
    VS_OUTPUT Out = (VS_OUTPUT)0;
  	Out.Pos  = mul(Pos, WorldViewProj);    // position (projected)
    Out.Tex  = Tex;  

    return Out;
}



float time=0;
static const float sampleDist = 1.0f/512.0f;  // distance one pixel in u/v

static const float rings = 2;
static const float speed = 1;
static const float exponent=0.5;

static const float2 center = { 0.5, 0.5 };
static const float2 scale =  { 2, 2 };


float4 PS(
	float4 Pos : SV_POSITION,
	float2 texCoord: TEXCOORD0) : SV_TARGET 
{

	texCoord = scale* (texCoord-center);
	
	float radius = length(texCoord);
	
   	float ang = atan2(texCoord.x, texCoord.y);
   	float rad = pow(dot(texCoord, texCoord), exponent);
   	
   	ang = ang + rings * sin(time*6.28) * rad + speed * time;
   	
   	float2 newTexCoord = float2(0.5 * (1 + radius*sin(ang)),0.5 * (1 + radius*cos(ang)));
   	

	float4 img = inputTexture.Sample(samp_inputTexture, newTexCoord);
	return img;

}



