// Access control devices using proCONTROLL
import procontroll.*; 
import java.io.*; 

ControllIO controll; 
ControllDevice device; 
ControllStick stick; 
ControllButton button;

 void joypad(){
  controll = ControllIO.getInstance(this); 
    
  // Check what devices are connected and get name of desired device then printout
  // Check number and name of sliders, buttons and sticks then printout
  controll.printDevices();
  for(int i = 0; i < controll.getNumberOfDevices(); i++){
    ControllDevice device = controll.getDevice(i);
    println(device.getName()+" has:");
    println(" " + device.getNumberOfSliders() + " sliders");
    println(" " + device.getNumberOfButtons() + " buttons");
    println(" " + device.getNumberOfSticks() + " sticks");
    device.printSliders();
    device.printButtons();
    device.printSticks();
  }
    
  // Select device and assign parameters
  try {
    device = controll.getDevice(controllerName);
    // The numbers in brackets for getstick and getButton below determine which sticks and buttons to use
    // Check in P5 output window on startup to determine correct numbers to use for specific controllers
    stick = device.getStick(1); 
    stick.setTolerance(0.8f); 
    button = device.getButton(2);
    joypadAction();
  } catch(IndexOutOfBoundsException e){
      println(e);
      println("NOTICE: Ensure that your stick, button and slider settings are correct for your controller. If unsure, check under <<<available proCONTROL devices >>> in the log text above" + '\n');
  } catch(RuntimeException e){
      println(e);
      println("NOTICE: Ensure that your controller is connected and that you named it correctly. If unsure, check that the name specified matches exactly one of the names listed under <<<available proCONTROL devices >>> in the log text above" + '\n');   
  }
 }
  
 // Controller actions broadcasted if controller (such as joypad or joystick) connected and specified.
 // If unsure, connect controller to the Master node, run sketch in P5 IDE and note messages in output window.
 void joypadAction(){
  if(device != null){ 
    x = stick.getX();
    y = stick.getY();
    // Broadcast basic joypad movements
    if(joyMove > y){
      dir = "UP";
      client.broadcast(dir);
    }
    else if(joyMove < y){
      dir = "DOWN";
      client.broadcast(dir);
    }
    else if(joyMove > x){
      dir = "LEFT";
      client.broadcast(dir);
    }
    else if(joyMove < x){
       dir = "RIGHT";
       client.broadcast(dir);
    }
    // Resets camera position.  TODO: add smooth transition
    else if(button.pressed()){
      dir = "RESET";
      client.broadcast(dir);
    }
  }
 }
