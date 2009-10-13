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

var SoundOff = {
  swfLocation : 'soundoff.swf',
  containerID : 'soundOffContainer',
  expressInstallLocation : 'expressInstall.swf',
  container : null,
  list : []
};

SoundOff.Object = function() {
  if (!SoundOff.container) {
    var c = document.createElement('div');
    c.style.position = 'absolute';
    c.style.top = 0;
    c.style.left = 0;
    document.body.appendChild(c);
    c.style.zIndex = -1;
    SoundOff.container = c;
  }
  
  this.thisIndex = SoundOff.list.length;
  SoundOff.list.push(this);
  this.swfID = 'SoundOffContainer' + this.thisIndex;
  
  var div = document.createElement('div');
  div.setAttribute('id', this.swfID);
  SoundOff.container.appendChild(div);
  
  swfobject.embedSWF(SoundOff.swfLocation, this.swfID, "1", "1", "9.0.0", SoundOff.expressInstallLocation);
  
  this.deferredCalls.push(['setUID', this.thisIndex]);
  this.initializeTimer = setInterval(this.bind(this.isInitialized, this), 100);
};

SoundOff.Object.prototype = {
  initialized : false,
  initializeTimer : null,
  deferredCalls : [],
  events : {},
  thisIndex : null,
  
  addToList : function(id, filePath) {
    this.call('addToList', arguments);
  },
  
  removeFromList : function(id) {
    this.call('removeFromList', arguments);
  },
  
  play : function(pos) {
    if (arguments[0] === null) { arguments[0] = -1;}
    this.call('play', arguments);
  },
  
  playAtPercent : function(pos) {
    this.call('playAtPercent', arguments);
  },
  
  seek : function(pos) {
    this.call('seek', arguments);
  },
  
  seekToPercent : function() {
    this.call('seekToPercent', arguments);
  },
  
  playNext : function() {
    this.call('playNext');
  },
  
  playPrev : function() {
    this.call('playPrev');
  },
  
  stop : function() {
    this.call('stop');
  },
  
  pause : function() {
    this.call('pause');
  },
  
  /* for internal use only */
  call : function() {
    var methodName = arguments[0];
    var i, args = [], a, ta;
    ta = typeof arguments[1] ==  'object' ? arguments[1] : arguments;
    for (i = typeof arguments[1] ==  'object' ? 0 : 1; (a = ta[i]) !== undefined; i++) { args.push(a);}
    
    if (this.initialized) {
      this.flashObj.call(methodName, args);
    } else {
      this.deferredCalls.push(['call', methodName, args]);
    }
  },
  
  /* Use this to set the value of a variable on the player */
  setVal : function(name, val) {
    if (this.initialized) {
      this.flashObj.set(name, val);
    } else {
      this.deferredCalls.push('set', name, val);
    }
  },
  
  /* Use this to get the value of a variable on the player. If the flash
    player is not initialized, this will return null.
    The only other solution that I could think of was to freeze the
    browser with a loop until it became available, but this would be
    bad if the player never initalized for some reason. */
  getVal : function(name) {
    if (this.initialized) {
      return this.flashObj.get(name);
    } else {
      return null;
    }
  },
  
  /* for internal use only */
  isInitialized : function() {
    try {
      this.flashObj = document.getElementById(this.swfID);
      this.flashObj.initialize();
      this.initialized = true;
      clearInterval(this.initializeTimer);
      var i, a;
      for (i=0; a = this.deferredCalls[i]; i++ ) {
        switch(a.length) {
          case 2:
            this[a[0]](a[1]);
            break;
          case 3:
            this[a[0]](a[1], a[2]);
            break;
        }
        
      }
    } catch(e) {}
  },
  
  /* for internal use only */
  bind : function (f, obj) {
    return function() { return f.apply(obj, arguments); };
  },
  
  /* for internal use only */
  setUID : function(uid) {
    this.flashObj.uid(uid);
  },
  
  addListener : function(event, func) {
    var i, e;
    this.events[event] = this.events[event] || [];
    for (i=0; e = this.events[event][i]; i++) { if (func === e) { return false; } }
    this.events[event].push(func);
    return true;
  },
  
  removeListener : function(event, func) {
    var i, e;
    this.events[event] = this.events[event] || [];
    for (i=0; e = this.events[event][i]; i++) {
      if (func === e) {
        this.events[event].splice(i, 1);
        break;
      }
    }
  },
  
  dispatchEvent : function (event, obj) {
//    console.info('Dispatching event: ' + event, obj);
    var i, e;
    this.events[event] = this.events[event] || [];
    for (i=0; e = this.events[event][i]; i++) { this.bind(e, this)(obj); }
  }
};

