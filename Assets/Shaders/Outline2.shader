Shader "Custom/Outline2"
{
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _Thickness ("Outline Thickness", Range(0,0.1)) = 0.005
    }
 
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100
 
        CGPROGRAM
        #pragma surface surf Lambert
 
        sampler2D _MainTex;
        fixed4 _OutlineColor;
        float _Thickness;
 
        struct Input {
            float2 uv;
        };
 
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv).rgb;
            o.Alpha = tex2D(_MainTex, IN.uv).a;
            float3 outline = 1 - step(_Thickness, min(IN.uv.y, 1.0 - IN.uv.y));
            o.Emission = _OutlineColor.rgb * outline;
        }
        ENDCG
    }
    FallBack "Diffuse"
}