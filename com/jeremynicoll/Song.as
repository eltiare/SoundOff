package com.jeremynicoll {
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;
  import flash.media.SoundLoaderContext;

  import flash.events.Event;
  
  import flash.net.URLRequest;
  
  import flash.utils.Timer;
  import flash.events.TimerEvent;  

  
  public class Song extends Sound {
    public var id:String;
    public var loadInitialized:Boolean = false;
    
    private var trackPos:int = 0;
    private var isPlaying:Boolean = false;
    private var soundChannel:SoundChannel;
    private var volume:Number = 1;
    private var location:String;
    
    private var fadeVolFrom:Number;
    private var fadeVolTo:Number;
    private var timer:Timer;

    
    public function Song(uid:String = null, location:String = null):void {
      if(uid) { id = uid; }
      if(location) {
        this.location = location;
        load(new URLRequest(location));
        loadInitialized = true;
      }
    }
    
    public function seek(pos:int):void {
      trace("Seeking to " + pos);
      trackPos = pos;
      if (this.isPlaying) { play(pos); }
    }
    
    public override function play(newPos:Number = 0, loops:int = 0, transform:SoundTransform = null):SoundChannel {
      if (soundChannel) { soundChannel.stop(); }
      var st = transform || new SoundTransform(volume);
      trace(trackPos);
      var pos:int = newPos == -1 ? trackPos : newPos;
      trace("Playing at position "  + pos + ", volume "  + volume);
      soundChannel = super.play(pos, loops, st);
      trace(soundChannel);
      isPlaying = true;
      soundChannel.addEventListener('soundComplete', songComplete);
      sendEvent(SongEvent.PLAY);
      return soundChannel;
    }
    
    public override function load(url:URLRequest, context:SoundLoaderContext = null):void {
      loadInitialized = true;
      super.load(url, context);
    }
    
    public function pause():void {
      trackPos = soundChannel.position;
      trace('Pausing at ' + trackPos);
      sendEvent(SongEvent.SOUND_STOP);
      sendEvent(SongEvent.PAUSE);
      realStop(false);
    }
    
    public function stop():void {
      sendEvent(SongEvent.SOUND_STOP);
      sendEvent(SongEvent.STOP);
      realStop(true);
    }
    
    public function position():Number {
      return isPlaying ? soundChannel.position : trackPos;
    }
    
    public function playing():Boolean {
      return isPlaying;
    }
    
    public function setVolume(vol:Number):void {
      if (soundChannel) soundChannel.soundTransform = new SoundTransform(vol);
      volume = vol;
    }
    
    public function fadeTo(vol:Number, seconds:int):void {
      this.fadeVolFrom = volume;
      this.fadeVolTo = vol;
      if (timer) { timer.stop(); }
      timer = new Timer(100, seconds * 10);
      timer.addEventListener(TimerEvent.TIMER, fade);
      timer.start();
    }
    
    public function getVolume():Number {
      return volume;
    }
    
    private function realStop(reset:Boolean):void {
      if (reset) { trackPos = 0; }
      isPlaying = false;
      trace("stopping!");
      trace(trackPos);
      soundChannel.stop();
    }
    
    private function songComplete(e:Event) {
      sendEvent(SongEvent.COMPLETE);
    }
    
    private function sendEvent(label) {
      trace("New event: " + label);
      dispatchEvent(new SongEvent(label));
    }
    
    private function fade(e:TimerEvent):void {
      var percent:Number = e.target.currentCount / e.target.repeatCount;
      var diff = fadeVolFrom - fadeVolTo;
      var v = fadeVolFrom - diff * percent;
      setVolume(v);
    }
    
  }
  
}