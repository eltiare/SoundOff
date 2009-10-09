package com.jeremynicoll {  import com.jeremynicoll.Song;  import com.jeremynicoll.SongEvent;
  import flash.media.ID3Info;  import flash.media.SoundChannel;
    import flash.net.URLRequest;  import flash.external.ExternalInterface;
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
//  import flash.utils.Timer;
//  import flash.events.TimerEvent;  

    public class SoundOff extends EventDispatcher {        public var fade:Boolean = false;    public var loop:Boolean = false;    public var fadeTime:int = 2;    public var currentIndex:int = 0;
        private var list:Array = [];        private var primaryPlayer:Song;    private var secondaryPlayer:Song;    
    private var volume:Number = 1;        public function addToList(uid:String, location:String):Boolean {      this.list.push({ 'id' : uid, 'location' : location });      return true;    }        public function removeFromList(uid:String):Boolean {      var hsh, index:int, i:int;      for (i = 0; hsh = this.list[i] ; i++) { if(hsh.id === uid) { index = i; } }      if (index) {        this.list.splice(index, 1);        return true;      } else {        return false;      }    }        public function play(pos = null):void {      if (pos === null) { pos = -1; }
      loadCurrent();
      var sc:SoundChannel = primaryPlayer.play(pos);    }
    
    public function seek(pos:int):void {
      primaryPlayer.seek(pos);
    }        public function pause():void {      primaryPlayer.pause();    }        public function stop():void {      primaryPlayer.stop();    }        public function playPrev():void {      playThis(currentIndex == 0 ? list.length - 1 : currentIndex - 1);    }        public function playNext():void {
      playThis(currentIndex == list.length - 1 ? 0 : currentIndex + 1);    }        public function setVolume(vol:Number):void {      volume = vol;
      primaryPlayer.setVolume(vol);    }        public function getVolume():Number {      return volume;    }
    
    public function currentTrack():Song {
      return primaryPlayer;
    }        private function getByUID(uid:String) {      var hsh, index:int, i:int;      for (i = 0; hsh = this.list[i] ; i++) { if(hsh.id === uid) { index = i; } }      if (index) { return list[index]; }      else { return false; }    }        private function playThis(index:int):void {
      var changed:Boolean = currentIndex != index;
      currentIndex = index;
      switchPlayers();      loadCurrent();
      if (changed) { dispatchEvent(new SongEvent(SongEvent.NEW, primaryPlayer.id)); }
            if (this.fade) {        if (!fadeTime || fadeTime < 1) { fadeTime = 1; }
        primaryPlayer.setVolume(0);
        primaryPlayer.play();
        primaryPlayer.fadeTo(volume, fadeTime);
        secondaryPlayer.fadeTo(0, fadeTime);      } else {
        secondaryPlayer.stop();
        primaryPlayer.setVolume(volume);
        primaryPlayer.play();      }      primaryPlayer.sendID3();      primaryPlayer.addEventListener(SongEvent.COMPLETE, songComplete);    }    
    private function loadCurrent():void {
      if (!(primaryPlayer && primaryPlayer.loadInitialized) || primaryPlayer.id != list[currentIndex].id) {
        var i, e;
        primaryPlayer = new Song(list[currentIndex].id, list[currentIndex].location);
        for (i=0; e = SongEvent.CONSTANTS[i]; i++) { primaryPlayer.addEventListener(e, sendThru); }
      }
    }
        private function switchPlayers():void {      var sp = secondaryPlayer;      secondaryPlayer = primaryPlayer;      primaryPlayer = sp;    }
    
    private function songComplete(e:Event) {
      if (loop || currentIndex != list.length - 1) playNext();
    }
    
    private function sendThru(e:SongEvent) {
      var se:SongEvent = new SongEvent(e.getLabel(), e.attrs.id);
      se.merge(e.attrs);
      dispatchEvent(se);
    }      }}