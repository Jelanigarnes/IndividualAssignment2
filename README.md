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







