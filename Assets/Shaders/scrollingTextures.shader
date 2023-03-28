Shader "Custom/scrollingTextures"
{
    Properties
    {   
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FoamTex ("Foam", 2D) = "white" {}
        _ScrollX ("Scroll X", Range(-5,5)) = 1
        _ScrollY ("Scroll Y", Range(-5,5)) = 1
        
    }
    SubShader
    {

        CGPROGRAM
       
        #pragma surface surf Lambert

       

        sampler2D _MainTex;
        sampler2D _FoamTex;
       
        float _ScrollX;
        float _ScrollY;

        struct Input
        {
            float2 uv_MainTex;
            
        };



        void surf (Input IN, inout SurfaceOutput o)
        {
            _ScrollX *= _Time;
            _ScrollY *= _Time;
            //Water
            //float2 newuv = IN.uv_MainTex + float2(_ScrollX, _ScrollY);
            
            //Scrolling Texture
            float3 water = (tex2D(_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY))).rgb;
            float3 foam =  (tex2D(_FoamTex, IN.uv_MainTex + float2(_ScrollX/2.0, _ScrollY/2.0))).rgb;
            //o.Albedo = tex2D (_MainTex, newuv);
           //float ramp = tex2D(_Ramp, float2(col.r, 0.5)).r;

          
            o.Albedo = (water + foam)/2.0;
          
        } 
        ENDCG
    }
    FallBack "Diffuse"
}
