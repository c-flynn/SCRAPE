// Navigation actions based on received broadcast messages
// Each screens actions need to be different due to different OCD camera positions
// See OCD reference page for explanations and examples - http://gdsstudios.com/processing/libraries/ocd/reference/
 void navActions(){
  if (client.messageAvailable()) {
    String[] way = client.getDataMessage();
    switch(wallChar){
      // Nav actions for front screen
      case 'f':
        if (way[0].equals("LEFT")){
          camSelected.pan(-(rotVar));
        }
        else if (way[0].equals("RIGHT")){
          camSelected.pan(rotVar);
        }
        else if (way[0].equals("UP")){
          camSelected.dolly(-(linVar));
        }
        else if (way[0].equals("DOWN")){
          camSelected.dolly(linVar);
        }
        else if (way[0].equals("RESET")){
          camSelected.jump(0,0,client.getLWidth()/2);
          camSelected.aim(0,0,0); 
        }
        break;
      // Nav actions for rear(stern) screen
      case 's':
        if (way[0].equals("LEFT")){
          camSelected.pan(-(rotVar));
        }
        else if (way[0].equals("RIGHT")){
          camSelected.pan(rotVar);
        }
        else if (way[0].equals("UP")){
          camSelected.dolly(linVar);
        }
        else if (way[0].equals("DOWN")){
          camSelected.dolly(-(linVar));
        }
        else if (way[0].equals("RESET")){
          camSelected.jump(0,0,client.getLWidth()/2);
          camSelected.aim(0,0,client.getLWidth()); 
        }
        break;
      // Nav actions for left screen  
      case 'l':
        if (way[0].equals("LEFT")){
          camSelected.pan(-(rotVar));
        }
        else if (way[0].equals("RIGHT")){
          camSelected.pan(rotVar);
        }
        else if (way[0].equals("UP")){
          camSelected.truck(linVar);
        }
        else if (way[0].equals("DOWN")){
          camSelected.truck(-(linVar));
        }
        else if (way[0].equals("RESET")){
          camSelected.jump(0,0,client.getLWidth()/2);
          camSelected.aim(-1,0,client.getLWidth()/2); 
        }
        break;
      // Nav actions for right screen  
      case 'r':
        if (way[0].equals("LEFT")){
          camSelected.pan(-(rotVar));
        }
        else if (way[0].equals("RIGHT")){
          camSelected.pan(rotVar);
        }
        else if (way[0].equals("UP")){
          camSelected.truck(-(linVar));
        }
        else if (way[0].equals("DOWN")){
          camSelected.truck(linVar);
        }
        else if (way[0].equals("RESET")){
          camSelected.jump(0,0,client.getLWidth()/2);
          camSelected.aim(1,0,client.getLWidth()/2); 
        }
        break;
      // Nav actions for top screen  
      case 't':
        if (way[0].equals("LEFT")){
          camSelected.roll(radians(rolVar));
        }
        else if (way[0].equals("RIGHT")){
          camSelected.roll(-(radians(rolVar)));
        }
        else if (way[0].equals("UP")){
          camSelected.boom(linVar);
        }
        else if (way[0].equals("DOWN")){
          camSelected.boom(-(linVar));
        }
        else if (way[0].equals("RESET")){
          camSelected = new Camera(this, 0, 0, client.getLWidth()/2, 0, -1, client.getLWidth()/2, 0, 0, -1, fov2, 1, nrClip, frClip);
        }
        break;
      // Nav actions for bottom screen  
      case 'b':
        if (way[0].equals("LEFT")){
          camSelected.roll(-(radians(rolVar)));
        }
        else if (way[0].equals("RIGHT")){
          camSelected.roll(radians(rolVar));
        }
        else if (way[0].equals("UP")){
          camSelected.boom(-(linVar));
        }
        else if (way[0].equals("DOWN")){
          camSelected.boom(linVar);
        }
        else if (way[0].equals("RESET")){
          camSelected = new Camera(this, 0, 0, client.getLWidth()/2, 0, 1, client.getLWidth()/2, 0, 0, 1, fov2, 1, nrClip, frClip);
        }
        break;
    }  
  }
 }
