package com.jeremynicoll {
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;
  import flash.media.SoundLoaderContext;

  import flash.net.URLRequest;
  
  import flash.utils.Timer;
  
  import flash.events.Event;
  import flash.events.ProgressEvent;
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
    private var progressTimer:Timer;

    private var loaded:Boolean = false;
    
    public function Song(uid:String = null, location:String = null):void {
      if(uid) { id = uid; }
      if(location) {
        this.location = location;
        load(new URLRequest(location));
        loadInitialized = true;
      }
      progressTimer = new Timer(250);
      progressTimer.addEventListener(TimerEvent.TIMER, sendProgress);
      progressTimer.start();
    }
    
    public function seek(pos:int):void {
      trackPos = pos;
      if (this.isPlaying) { play(pos); }
    }
    
    public override function play(newPos:Number = 0, loops:int = 0, transform:SoundTransform = null):SoundChannel {
      if (soundChannel) { soundChannel.stop(); }
      var st = transform || new SoundTransform(volume);
      var pos:int = newPos == -1 ? trackPos : newPos;
      soundChannel = super.play(pos, loops, st);
      isPlaying = true;
      soundChannel.addEventListener('soundComplete', songComplete);
      sendEvent(SongEvent.PLAY);
      return soundChannel;
    }
    
    public override function load(url:URLRequest, context:SoundLoaderContext = null):void {
      loadInitialized = true;
      this.addEventListener('id3', sendID3);
      super.load(url, context);
    }
    
    public function pause():void {
      trackPos = soundChannel.position;
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
    
    public function getSoundChannel():SoundChannel {
      return soundChannel;
    }
    
    public function setVolume(vol:Number):void {
      if (soundChannel) soundChannel.soundTransform = new SoundTransform(vol);
      volume = vol;
    }

    public function getVolume():Number {
      return volume;
    }
    
    public function fadeTo(vol:Number, seconds:int):void {
      this.fadeVolFrom = volume;
      this.fadeVolTo = vol;
      if (timer) { timer.stop(); }
      timer = new Timer(100, seconds * 10);
      timer.addEventListener(TimerEvent.TIMER, fade);
      timer.start();
    }
    
    private function realStop(reset:Boolean):void {
      if (reset) { trackPos = 0; }
      isPlaying = false;
      soundChannel.stop();
    }
    
    private function songComplete(e:Event) {
      sendEvent(SongEvent.COMPLETE);
    }
    
    private function sendEvent(label:String, attrs:Object = null) {
      var se:SongEvent = new SongEvent(label, id);
      se.merge(attrs);
      dispatchEvent(se);
    }
    
    private function fade(e:TimerEvent):void {
      var percent:Number = e.target.currentCount / e.target.repeatCount;
      var diff = fadeVolFrom - fadeVolTo;
      var v = fadeVolFrom - diff * percent;
      setVolume(v);
    }
    
    private function sendProgress(e:TimerEvent):void {
      if (!loaded) {
        sendEvent(SongEvent.LOAD, {
          bytesLoaded : bytesLoaded,
          bytesTotal : bytesTotal
        });
        if (bytesLoaded >= bytesTotal) { loaded = true; }
      }
      if (isPlaying) {
        sendEvent(SongEvent.PROGRESS, {
          leftPeak    : soundChannel.leftPeak,
          rightPeak   : soundChannel.rightPeak,
          position    : soundChannel.position,
          length      : this.length,
          isBuffering : this.isBuffering
        });
      }
    }
    
    public function sendID3(e:Event = null):void {
      sendEvent(SongEvent.ID3, this.id3);
    }
    
  }
  
}