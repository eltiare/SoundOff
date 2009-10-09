package com.jeremynicoll {
  
  import flash.events.Event;
  
  public class SongEvent extends Event {
    public static const COMPLETE:String = "songComplete";
    public static const STOP:String = "songStop";
    public static const PAUSE:String = "songPause";
    public static const PLAY:String = "songPlay";
    public static const SOUND_STOP:String = 'soundStop';
    private var label;
    
    public function SongEvent(label) {
      super(label);
      this.label = label;
    }
  }  
}

