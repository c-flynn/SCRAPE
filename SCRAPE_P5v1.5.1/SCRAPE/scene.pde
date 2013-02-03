// Basic test scene to help configure CAVE environment
 void caveScene(){
  // Clear the screen     
  background(0);
  lights();  
    
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
  angle += 0.02;
  
  // Call scene navigation function that acts on received broadcast messages
  navActions();

  // Check for any joypad movements
  joypadAction();
 }
