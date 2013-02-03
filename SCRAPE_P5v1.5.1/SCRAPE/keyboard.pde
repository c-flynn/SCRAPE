// Keypad actions broadcasted
 void keyPressed() {
   // Broadcast basic keyboard movements
   if (key == CODED) {
     if (keyCode == LEFT) {
       dir = "LEFT";
       client.broadcast(dir);
     }
     else if (keyCode == RIGHT) {
       dir = "RIGHT";
       client.broadcast(dir);
     }
     else if (keyCode == UP) {
       dir = "UP";
       client.broadcast(dir);
     }
     else if (keyCode == DOWN) {
       dir = "DOWN";
       client.broadcast(dir);
     }
    }
    // Resets camera position.  TODO: add smooth transition
    else if (key == 32) {
      dir = "RESET";
      client.broadcast(dir);
    }
 }
