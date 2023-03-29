Shader "Custom/outlineBump"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Bump Map", 2D) = "bump" {}
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _Outline ("Outline Width", Range (.0002,0.1)) = .0005
    }
    SubShader
    {
        ZWrite off
        
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0
        
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _Outline;
        float4 _OutlineColor;
        
        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
        };
        
        void vert (inout appdata_full v){
            v.vertex.xyz += v.normal * _Outline;
        }
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 worldNormal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
            float3 viewNormal = normalize(mul(UNITY_MATRIX_IT_MV, worldNormal));
            float rim = 1.0 - max(0.0, dot(viewNormal, normalize(IN.worldNormal)));
            o.Emission = _OutlineColor.rgb * rim;
        }
        ENDCG
        
        ZWrite on
        
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input{
            float2 uv_MainTex;
            float3 worldNormal;
        };
        
        sampler2D _MainTex;
        sampler2D _BumpMap;
        void surf (Input IN, inout SurfaceOutput o){
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
        }
        ENDCG
    }
    
    FallBack "Diffuse"
}