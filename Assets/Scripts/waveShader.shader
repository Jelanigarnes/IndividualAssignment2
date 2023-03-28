Shader "Custom/waveShader" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Distortion ("Distortion", Range(0,1)) = 0.1
        _WaveLength ("Wave Length", Range(0.1,10)) = 1
        _Speed ("Speed", Range(-2,2)) = 0.5
        _SpeedY ("Speed Y", Range(-2,2)) = 0.5 // new property for controlling vertical movement
        _ToonShade ("Toon Shading", Range(0,1)) = 1
    }

    SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Distortion;
            float _WaveLength;
            float _Speed;
            float _SpeedY; // new variable for controlling vertical movement
            float _ToonShade;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                float2 uv = i.uv;
                uv.x += _Time.y * _Speed;
                float wave = cos(uv.y * _WaveLength + _Time.y * _SpeedY) * _Distortion; // modified to use cos function and new SpeedY property
                float4 tex = tex2D(_MainTex, uv + float2(wave, 0));
                float4 col = tex * _Color;

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
