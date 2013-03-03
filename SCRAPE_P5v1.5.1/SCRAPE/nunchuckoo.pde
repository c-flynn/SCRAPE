// Access the arduino + nunchuck control data
import processing.serial.*;

// ASCII code 10 denotes a line feed
final int LINE_FEED = 10;
// NOTE: The baud rate set on the arduino, in this code and the connected computer must be the same
final int BAUD_RATE = 19200;

Serial arduinoPort;

 void nunchuckoo(){
  try{
    // Checks ports to see if a serial device is connected
    String[] ports = Serial.list();
    if(ports.length < 1){
      println("NOTICE: uh oh....your serial list is empty.  You don't appear to have your arduino and nunchuck connected!" + '\n');
    }
    else{  
      println("NOTICE: serial list is : ");
      println(ports);
      println("If your nunchuck and arduino are plugged in and not working, check that you are specifying the correct serial list port and that BAUD rates are correct on the computers COM port and also that there is no RXTX Version mismatch on processing output window. See https://github.com/c-flynn/Nunchuckoo/issues for more info" + '\n');
      // Using the printed serial list you should be able to determine which port your nunchuck is plugged into
      // This will help you determine which array index number needs to be used for serial.list()array below
      arduinoPort = new Serial(this, Serial.list()[0], BAUD_RATE);
      arduinoPort.bufferUntil(LINE_FEED);
    }
  }
  catch(Exception e){
    println(e);
    println("NOTICE: Could not run nunchuckoo! Ensure that your wii nunchuck and arduino are connected correctly" + '\n');
  }
 }

 //-------------------------------------------------------------  
 // Arduino + nunchuck actions read, interpreted and broadcasted
 void serialEvent(Serial port) {
   final String arduinoData = port.readStringUntil(LINE_FEED);
   if (arduinoData != null) {
     final int[] data = int(split(trim(arduinoData), ' '));
     if (data.length == 7) {
       // data[0] is joystick left/right
       // data[1] is joystick forward/back
       // data[2] is Tilt left/right
       // data[3] is Tilt forward/back
       // data[4] is not currently used
       // data[5] is z button
       // data[6] is c button
     if (data[0] < 60) {
       dir = "LEFT";
       client.broadcast(dir);
     }
     else if(data[0] > 190) {
       dir = "RIGHT";
       client.broadcast(dir);
     }
     else if(data[1] > 190) {
       dir = "UP";
       client.broadcast(dir);
     }
     else if(data[1] < 60) {
       dir = "DOWN";
       client.broadcast(dir);
     }
     //The z button has to be pressed for tilt left to work
     else if (data[2] < 400 && data[5] == 1) {
       dir = "LEFT";
       client.broadcast(dir);
     }
     //The z button has to be pressed for tilt right to work
     else if(data[2] > 600 && data[5] == 1) {
       dir = "RIGHT";
       client.broadcast(dir);
     }
     //The z button has to be pressed for tilt forward to work
     else if(data[3] > 650 && data[5] == 1) {
       dir = "UP";
       client.broadcast(dir);
     }
     //The z button has to be pressed for tilt back to work
     else if(data[3] < 450 && data[5] == 1) {
       dir = "DOWN";
       client.broadcast(dir);
     }
     // Resets camera position.  TODO: add smooth transition
     else if(data[6] == 1){
       dir = "RESET";
       client.broadcast(dir);
     }
    }
   }
   //else{println("NOTICE: Your nunchuck appears to be connected but no data is coming through. Check that the serial port you are using is correct, the baud rates are correct (& matching) and that your arduino is pushing data (You can use the arduino IDE serial monitor to verify)" + '\n');}
 }


