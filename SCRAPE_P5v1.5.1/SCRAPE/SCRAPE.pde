/**
 * Project SCRAPE for P5 v1.5.1
 * SCReen Adjusted Panoramic Effect
 * <https://github.com/c-flynn/SCRAPE/>
 *
 * None of this would have been possible without the following: 
 *   The multi-talented Most Pixels Ever (MPE) - https://github.com/shiffman/Most-Pixels-Ever/
 *   The superlative Obsessive Camera Direction (OCD) - http://gdsstudios.com/processing/libraries/ocd/
 *   The joyous proCONTROLL - http://creativecomputing.cc/p5libs/procontroll/
 *   The eye-popping 'stereo' - https://github.com/CreativeCodingLab/stereo/
 *   The playful Arduino - http://www.arduino.cc/
 *   The pure joy that is Processing - http://processing.org/
 *
 */
import processing.opengl.*; 
import mpe.client.*;
import damkjer.ocd.*;

// Stereographic library imports
import javax.media.opengl.*;
import stereo.*;
Stereo stereo = null;

// OCD camera reference variable
Camera camSelected;

// MPE client reference variable
TCPClient client;
// Stays false until all clients have connected
boolean start = false;

// SCRAPE configuration variables
Properties props;
String wall;
String controller;
String controllerName;
String nunchuck;
String activeStereo;
char wallChar;

// Declare vertical field of view variables.
float fov;
float fov2;
// Declare aspect ratio variable.
float aspRatio;
// Define near clip for camera
float nrClip = 0.01;
// Define far clip for camera
float frClip = 2000;

// Variable for camera rotations
float rotVar = 0.03;
// Variable for linear camera movements
float linVar = 2.5;
// Variable for camera rolls - calculated by converting rotVar degrees to radians
float rolVar = 1.71887339;
// Variable for test scene box rotation
float angle = 0.0;
// Variable for directional commands
String dir = "";

// Variables for joypad movements
float joyMove = 0.0;
float x;
float y;


//--------------------------------------
 void setup() {
  // Read SCRAPE configurations file 
  try {
    props = new Properties();
    // SketchPath() is used so that the INI file is local to the sketch
    props.load(new FileInputStream(sketchPath("mpe.ini")));
    // Get property values, remove semicolons if present and switch to lowercase(Except ControllerName)
    wall = props.getProperty("wall").replaceAll(";$", "").toLowerCase();
    controller = props.getProperty("controller").replaceAll(";$", "").toLowerCase();
    controllerName = props.getProperty("controllerName").replaceAll(";$", "");
    nunchuck = props.getProperty("nunchuck").replaceAll(";$", "").toLowerCase();
    activeStereo = props.getProperty("activeStereo").replaceAll(";$", "").toLowerCase();
  }
  catch(IOException e) {
    println("couldn't read config file...");
  }
   
  // Make a new MPE Client using an INI file
  client = new TCPClient(sketchPath("mpe.ini"), this);
  
  // Determine aspect ratio based on screen size settings in mpe.ini
  aspRatio = (float)client.getLWidth() / (float)client.getLHeight();
  println("Aspect ratio is: " + aspRatio);

  // Determine vertical field of view = 2 atan(0.5 height / focallength) - see http://paulbourke.net/miscellaneous/lens/  for clear explanation
  fov = 2*atan(((float)client.getMHeight()/2)/((float)client.getMWidth()/2));
  // Vertical fov for floor and ceiling screens will be the difference between PI and fov
  fov2 = PI - fov;
  println("Vertical fov is: " + fov + " OR " + fov2 + " for floor & ceiling screens");
  
  // Use active stereo for MPE client if set in config file
  if(activeStereo.equals("on")){
    size(client.getLWidth(), client.getLHeight(), "stereo.ActiveStereoView");
    // Stereographic configs
    float eyeSep = 3.1f;
    if(wall.equals("bottom") || wall.equals("top")){
      stereo = new Stereo(this, eyeSep, fov2, nrClip, frClip, Stereo.StereoType.ACTIVE);
    } else {
      stereo = new Stereo(this, eyeSep, fov, nrClip, frClip, Stereo.StereoType.ACTIVE);
    }
    println("Active stereo is set to 'on'");
  }
  else{
    size(client.getLWidth(), client.getLHeight(), OPENGL);
    println("Active stereo is set to 'off'");
  }
  
  // No impact on P5v1.5.1 with OpenGL. smooth() useable in P5v2 e.g. smooth(n) where n = 2, 4, 8 etc.
  smooth();
   
  // OCD Camera Objects created with specific parameters - http://gdsstudios.com/processing/libraries/ocd/
  if(wall.equals("left")){
    camSelected = new Camera(this, 0, 0, client.getLWidth()/2, -1, 0, client.getLWidth()/2, 0, 1, 0, fov, aspRatio, nrClip, frClip);
  }
  else if(wall.equals("front")){
    camSelected = new Camera(this, 0, 0, client.getLWidth()/2, 0, 0, 0, 0, 1, 0, fov, aspRatio, nrClip, frClip);
  }
  else if(wall.equals("right")){
    camSelected = new Camera(this, 0, 0, client.getLWidth()/2, 1, 0, client.getLWidth()/2, 0, 1, 0, fov, aspRatio, nrClip, frClip);
  }
  else if(wall.equals("bottom")){
    camSelected = new Camera(this, 0, 0, client.getLWidth()/2, 0, 1, client.getLWidth()/2, 0, 0, 1, fov2, aspRatio, nrClip, frClip);
  }
  else if(wall.equals("top")){
    camSelected = new Camera(this, 0, 0, client.getLWidth()/2, 0, -1, client.getLWidth()/2, 0, 0, -1, fov2, aspRatio, nrClip, frClip);
  }
  else if(wall.equals("stern")){
    camSelected = new Camera(this, 0, 0, client.getLWidth()/2, 0, 0, client.getLWidth(), 0, 1, 0, fov, aspRatio, nrClip, frClip);
  }
  else{
    throw new IllegalArgumentException('\n' + "Camera name not correctly specified" + '\n' + "Use one of the following in config file: left, right, front, back, top & bottom" + '\n');
  }
  println("You are currently displaying the " + wall + " screen");
  
  // Set this clients screen char variable for use in switch statements later  
  wallChar = wall.charAt(0);
  
  // Random seed set for MPE. Must be identical for all clients
  randomSeed(1);
  
  // Call arduino and nunchuck controller function if activated in config file 
  if(nunchuck.equals("on")){
    println("Nunchuck is set to 'on'");
    nunchuckoo();
  }
  else{
    println("Nunchuck is set to 'off'");
  }

  // Call joypad controller function if activated in config file
  if(controller.equals("on")){
    println("Controller is set to 'on'");
    joypad();
  }
  else{
    println("Controller is set to 'off'");
  }  
  
  // IMPORTANT, YOU MUST START THE CLIENT!
  client.start();
}

//--------------------------------------
 // Keep the motor running... draw() needs to be added in auto mode, even if it is empty to keep things rolling
 void draw() {
   
 }
//--------------------------------------
 
 // Triggered by the client whenever a new frame should be rendered
 // All synchronized drawing should be done here when in auto mode
 void frameEvent(TCPClient c) {
  
  // Call OCD camera feed for selected camera 
  camSelected.feed();

  // Call caveScene or caveSceneStereo function depending on config setting
  if(activeStereo.equals("on")){
    caveSceneStereo();
  }
  else{  
    caveScene();
  }  
 }
