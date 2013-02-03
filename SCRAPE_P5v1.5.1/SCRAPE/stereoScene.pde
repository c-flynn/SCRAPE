// Basic stereographic test scene to help configure CAVE environment using stereo library
 void caveSceneStereo(){
   
  // Clear the screen----------------------------------------------     
  background(0);
  lights();
  // --------------------------------------------------------------

  // Stereo action
  ActiveStereoView pgl = (ActiveStereoView) g;
  GL gl = pgl.beginGL();{   
    if(wall.equals("bottom") || wall.equals("top")){
      stereo.start(gl, 
        0f, 0f, 0f,
        0f, 0f, 1f,
        0f, -1f, 0f);
    }else {
      stereo.start(gl, 
        0f, 0f, 0f,
        0f, 0f, -1f,
        0f, 1f, 0f);
    }

    stereo.right(gl); // right eye rendering
    pushMatrix();
    render(gl);
    
    stereo.left(gl);  // left eye rendering
    popMatrix();
    render(gl);

    // Only needed for anaglyph
    //stereo.end(gl);
  }
  pgl.endGL();
 }

 // Render scene for individual eye
 void render(GL gl){  
  // scale() used to mirror image as openGL uses a different cartesian co-ordinate system from P5
  pushMatrix();
    scale(1,-1,1);
    
    // CAVE scene begin-------------------------------------------
      noStroke();
      fill(150);
      
      // Ground plane params
      translate(0,200,0);
      box(800,0,1000);
      
      // Box params
      fill(204);
      translate(0,-100,0);
      rotateY(angle);
      box(80);
      
      // Sphere params  
      translate(400,-150,0);
      stroke(153);
      sphere(200);
        
      // Controls speed of rotation  
      angle += 0.01f;
    // CAVE scene end--------------------------------------------
  
  popMatrix();
  
  //Call scene navigation function that acts on received broadcast messages
  navActions();

  // Check for any joypad movements
  joypadAction();
 }
