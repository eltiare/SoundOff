package com.jeremynicoll {
  
  import flash.events.Event;
  
  public class SongEvent extends Event {
    public static const COMPLETE:String = "songComplete";
    public static const STOP:String = "songStop";
    public static const PAUSE:String = "songPause";
    public static const PLAY:String = "songPlay";
    public static const SOUND_STOP:String = 'soundStop';
    public static const PROGRESS:String = 'songProgress';
    public static const NEW:String = 'songNew';
    public static const ID3:String = 'songID3';
    public static const LOAD:String = 'songLoad';
    
    public static const CONSTANTS:Array = [
      COMPLETE,
      STOP,
      PAUSE,
      PLAY,
      SOUND_STOP,
      PROGRESS,
      NEW,
      ID3,
      LOAD
    ];
    
    public var attrs:Object = {};
    
    private var label:String;
    
    public function SongEvent(label:String, songId:String) {
      super(label);
      this.label = label;
      attrs.songId = songId;
    }
    
    public function getLabel():String {
      return label;
    }
    
    public function merge(obj):void {
      var v;
      obj = obj || {};
      for ( v in obj) { attrs[v] = obj[v]; }
    }
    
  }  
}

