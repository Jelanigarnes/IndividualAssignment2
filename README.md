# Individual Assignment 2

### Task 1:

- [X] Make the repository is public
- [X] Add unity gitignore
- [X] Create an empty Unity 3D project
- [X] Build the project
- [X] Upload the build as a release to GitHub
 
![Screenshot 2023-03-28 112209](https://user-images.githubusercontent.com/35810049/228287095-4ad6833b-014a-481f-8bc2-c7d180bb76a0.png)


### Task 2:

#### Deferred & Forward Rendering:

Deferred rendering is a rendering technique usually used for complex scenes or with multiple lighting effects within a scene where the geometry buffer pass and shading pass is seperated and the geometry is rendered to multiple render targets or textures, then the shading process on the pipline along with the geometry is combined to create the final image. </br></br>
Forward rendering on the other hand, combines the geometry and shading into one pass and this technique is usually used for simple scenes as rendering multiple objects or lights can cause it to be slow in terms of the processing.

#### Deferred 
![df](https://user-images.githubusercontent.com/35810049/228343257-bf8c78db-e358-441d-aac5-1b35b880095a.png)
</br></br>
A scene with multiple objects and lights on a plane
![dfFlow](https://user-images.githubusercontent.com/35810049/228347567-989b4505-dbd2-4efb-b35f-bf2212f111e7.png)



#### Forward
![fR](https://user-images.githubusercontent.com/35810049/228343347-eaeb6215-cafe-4e8a-a76e-ac0d812ed002.png)
</br></br>
A simple scene with one object and a point light
![fRFlow](https://user-images.githubusercontent.com/35810049/228352612-7660580a-a4f7-457b-9646-40e831b7c5df.png)

### Task 3:
EVEN<br>
#### Release
https://github.com/Jelanigarnes/IndividualAssignment2/releases/tag/FirstBuild
#### Description
The square shape wave effect was implemented by compuinge the sine wave displacement value at the current position and time and then normalizing the wave displacement value to a range of -1 to 1</br></br>
// Compute the sine wave displacement value at the current position and time</br>
   float waveDisplacement = sin((v.vertex.x * _WaveV) + (time * _WaveM));</br></br>

// Normalize the wave displacement value to a range of -1 to 1</br>
   waveDisplacement = waveDisplacement / abs(waveDisplacement) * _WaveZ;</br></br>
   
   ![square](https://user-images.githubusercontent.com/35810049/228365663-ef1d92fc-38a7-4638-b337-e0c093a0f9cd.png)

   
To have the Toon shaded effect I added a _ToonShade property which is used to check if it is set or not. It the value equals to 1 then my color values are mapped to different brightness levels and multiplied by the original color "col.rgb", which gives the effect of clamping the color values.

#### Without Toon
![WOtoon](https://user-images.githubusercontent.com/35810049/228366235-4d46f98e-9c55-4042-94be-7767cc499a86.png)

#### With Toon  - Note: Image looks dark because of the texture being used but could be like a day and night effect
![WToon](https://user-images.githubusercontent.com/35810049/228366256-8cd6f672-c458-4c31-8c52-96f2bbaae733.png)

### Task 4:

The code snippet provided is implementing image downscaling and upscaling for a blurred post processing effect.</br>
First, the width and height of the source texture is calculated and the texture format is defined. An array of temporary RenderTextures to use for the downsampling and upsampling is created using. (RenderTexture[] textures = new RenderTexture[16];). Next the first RenderTexture is created as a scaled-down version of the source texture using the Graphics.Blit function.Then, the current source texture is set to the current destination texture and the box blur is added. The blurred result is stored in the currentDestination RenderTexture and basically in the following step the current source texture is scaled down and blurred until the number of iterations has been reached. Following this the upscaling process is iterated scaling up the current source texture and applying the box blur using:</br>
for (; i < iterations; i++)</br>
    {</br>
        Graphics.Blit(currentSource, currentDestination);</br>
        currentSource = currentDestination;</br>
    }</br>
Then, the textures array is iterated in reverse order and the box blur is applied to each texture along with cleaning up the temporary textures. Finally, the resulting blur is added to the destination texture. "Graphics.Blit(currentSource, destination);"</br>
This code could be used when implementing a bloom effect for possibly a car tail light or headlight depending on the style of the game with emission or more blurriness.

### Task 5:
#### Shadows:
There are 2 shadow effects in the scene was implemented. One of them was implemented through a shader added to the land base/ mud material to give somewhat of a depth depending on the camera angle so it looks like a cliff. This shader was implemented using the script from the lecture. In the vertex function the output struct is declared, then we transform the vertex position to clip space, pass the texture coordinates from the input to the output, transform the normal from object to world space, compute the light intensity based on the do product, multiply the light color with the light intensity, include the shadow coordinates in the output struct and return the output struct.</br>
In the fragment function the color from the main texture using the UV coordinate pass from the vertex shader is declared, ten get the shadow intensity using the shadow attenuation funtion, multiply the object's color by the diffuse light color and the shadow intensity and finally return the final pixel color.</br>
The second shadow was implemented through an update on the water script to receive shadows. The vertex and fragment functions were updated with the following:</br>
 Vertex:</br>
 // Transform the normal from object to world space</br>
  half3 worldNormal = UnityObjectToWorldNormal(v.normal);</br>
                // Compute the light intensity based on the dot product of the world normal and light direction</br>
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));</br>
                // Multiply the light color with the light intensity and store in the output struct</br>
                o.diff = nl * _LightColor0;</br>
                // Include the shadow coordinates in the output struct</br>
                TRANSFER_SHADOW(o)</br>
 Fragment:</br>
 // Get the shadow intensity using the shadow attenuation function</br>
fixed shadow = SHADOW_ATTENUATION(i);</br>

// Multiply the object's color by the diffuse light color and the shadow intensity</br>
col.rgb *= i.diff * shadow;</br>
      ![shadow1](https://user-images.githubusercontent.com/35810049/228585624-5247baf5-0148-4343-9db3-aa06b44f4c48.png)
      
       ![shadow2](https://user-images.githubusercontent.com/35810049/228585576-31410d1c-d3c7-42ca-b82c-482fb14a367d.png)
         


#### Outline:
The outline in the scene was added to the ship where it has a white outline and the shader was updated or modified to take a bump map for the ship's material, This would be more usefull if I had the time to properly model and texture a more appealing ship to add deatail like the wood etc. This shader was implemented by using a custom vertex function which displace the vertex along its normal direction by the outline width property. Then, in the surface function unpack the normal map and convert it to world space, calculate the rim light value based on the difference between the view direction and the surface normal and Set the emission color of the object to be the outline color multiplied by the rim light value. Additionally, in a second pass turn on writing to the depth buffer and in the surface function, set the albedo color of the object to be the color from the main texture and set the normal map of the object to be the one from the bump map.
![outline](https://user-images.githubusercontent.com/35810049/228588890-67b7b8c4-62bc-4c1f-b0d9-3776017e3e88.png)


### Task 6:
The code snippet provided is intended to give a colored shadow effect by blending the main color of the object with a shadow color based on the direction and intensity of the lighting. This effect could be used for example with giving a coloured shadow from a stained glass if there are stained glass in building of a scene or game. For example, a church window with the different color stained glass in different patterns.</br>
In terms of the code, basically the main color, base texture and shadow color properties are declared, the final color of the pixel is calculated by calculating the diffuse lighting, mutiply the albedo color by the light color and diffused lighting attenuation by 0.5, multiply the shadow color and set the alpha value of the output color. Then in the surface function get the color from the texture map and multiply it by the main color and finally set the output albedo and alpha values.</br>
// Calculates the diffuse lighting</br></br>
            fixed diff = max(0, dot(s.Normal, lightDir));</br>
            // Final output color</br>
            half4 c;</br>
            // Albedo color multiplied by light color and diffuse lighting attenuated by 0.5</br>
            c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 0.5);</br>
            // Shadow color multiplied by (1.0 - attenuation)</br>
            c.rgb += _ShadowColor.xyz * (1.0 - atten);</br>

### Task 7:
For this task I implemented a custom bloom effect. This was implemented in out project prior to the lecture implementation and I also modified it for this scene to illuminate or flash brighter. The effect was added to a cube with an anchor icon similar to what is in the scene example provided. This was implemented in the shader by declaring 4 properties which are the texture, bloom threshold, flash speed and flash amplitude. In the surface function I then sample the base texture, calculate the brightness of the pixel, calculate the bloom threshold value,used a sine wave calculation which defines a variable setting its value to the current time multiplied by the flashspeed, calculate the sine of the variable and store the results in the sine variable, then calculate the the flashIntensity as the maximum of 0 and the product of the sine and FlashAmplitude parameters. Following this apply the bloom effect based on the brightness of the pixel, adjust the bloom intensity as needed through the emission and subtract the bloom color from the base color.

![1](https://user-images.githubusercontent.com/35810049/228599576-1b87b197-47db-45dd-a65a-6d27135024f0.png)

![2](https://user-images.githubusercontent.com/35810049/228599597-8e70f53c-0a1b-4d0e-b543-3c02c731de1a.png)


## Project Build

https://github.com/Jelanigarnes/IndividualAssignment2/releases/tag/FinalBuild
