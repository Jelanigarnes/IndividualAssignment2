Shader "Custom/water"
{
     Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _DisplacementMap("DisplacementMap",2D)="black"{}
        _DisplacementStrength("Displacement Strength", Range(0.0,1.0))=0.5
        _WaveV("V", Range(0.1,10.0))=1.0
        _WaveM("M", Range(0.1,10.0))=1.0
        _WaveZ("Z", Range(0.0,1.0))=0.1
        _ToonShade ("Toon Shading", Range(0,1)) = 1
    }
    SubShader
    {
        
    Pass{
            CGPROGRAM

                      
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct Input
            {
                float2 uv_MainTex;
                float2 uv_DisplacementMap;
            };

            struct appdata{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

             struct v2f
            {
                float2 uv :TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                fixed4 diff : COLOR0;
                SHADOW_COORDS(1)
            };

            sampler2D _MainTex;
            sampler2D _DisplacementMap;
            float4 _MainTex_ST;
            float4 _DisplacementMap_ST;
            float _DisplacementStrength;
            float _WaveV;
            float _WaveM;
            float _WaveZ;
            float _ToonShade;

        v2f vert(appdata v)
        {
            v2f o;
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);                
            UNITY_TRANSFER_FOG(o,o.vertex);
            half3 worldNormal = UnityObjectToWorldNormal(v.normal);
            half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
           o.diff = nl * _LightColor0;
           TRANSFER_SHADOW(o)
            // Retrieve the displacement value from the texture
            float displacement = tex2Dlod(_DisplacementMap,float4(o.uv,0,0)).r;
            
            //Time 
            float time = _Time.y;

            //Wave Calculation: Sin(x*v + m) * z
            //float waveDisplacement = sin((v.vertex.x * _WaveV) + (time * _WaveM)) * _WaveZ;

            // Compute the sine wave displacement value at the current position and time
            float waveDisplacement = sin((v.vertex.x * _WaveV) + (time * _WaveM));

            // Normalize the wave displacement value to a range of -1 to 1
            waveDisplacement = waveDisplacement / abs(waveDisplacement) * _WaveZ;

            // Add the wave displacement to the vertex position
            v.vertex.xyz += v.normal * waveDisplacement;
            // Apply additional displacement based on the normalized wave displacement value
            float4 temp = float4(v.vertex.x,v.vertex.y,v.vertex.z,1.0);                
            temp.xyz += waveDisplacement * v.normal * _DisplacementStrength;

            // Convert the final vertex position to clip space and return it
            o.vertex = UnityObjectToClipPos(temp);
            return o;

        }

        fixed4 frag(v2f i):SV_Target
        {                
                fixed4 col=tex2D(_MainTex,i.uv); // Sample the main texture using the texture coordinates passed from the vertex shader, and assign it to a fixed4 color value
                UNITY_APPLY_FOG(i.fogCoord,col)
                fixed shadow = SHADOW_ATTENUATION(i);
                col.rgb *= i.diff * shadow;
                // If the ToonShade property is set to 1, perform additional computations to create a cel-shaded look
                if (_ToonShade == 1) {
                    col.rgb = (step(0.75, col.r) + step(0.5, col.r) + step(0.25, col.r)) * col.rgb;
                }
                return col;
        }
        ENDCG
    }
    }
    FallBack "Diffuse"
    
}