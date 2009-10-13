/*
 * SoundOff 
 *
 * A JavaScript/Flash combination to play songs and manage playlists.
 *
 * Copyright (c) 2099 Jeremy Nicoll ( http://jeremynicoll.com )
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
*/

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
    
    public function SongEvent(label:String, songId) {
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

