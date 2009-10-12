var SoundOff = {
  swfLocation : 'soundoff.swf',
  containerID : '_soundOffContainer',
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
    SoundOff.container = c;
  }
  
  // Quick & dirty IE detection
  var msie = (navigator.appVersion.indexOf("MSie") != -1) && !window.opera;
  
  var fo = document.createElement('object');
  fo.setAttribute('height', 1);
  fo.setAttribute('width', 1);
  fo.style.position = 'absolute';
  fo.style.top = 0;
  fo.style.left = 0;
  
  if (msie) {
    fo.setAttribute('classid', "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000");
    var p = document.createElement('param');
    p.setAttribute('name', 'movie');
    p.setAttribute('value', SoundOff.swfLocation);
    fo.appendChild(p);
  } else {
    fo.setAttribute('type', "application/x-shockwave-flash");
    fo.setAttribute('data', SoundOff.swfLocation);
  }
  
  
  SoundOff.container.appendChild(fo);
  this.flashObj = fo;
  this.initializeTimer = setInterval(this.bind(this.isInitialized, this), 100);
  SoundOff.list.push(this);
  this.thisIndex = SoundOff.list.length - 1;
  this.deferredCalls.push(['setUID', this.thisIndex]);
}

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
      this.flashObj.initialize();
      this.initialized = true;
      clearInterval(this.initializeTimer);
      var i, a;
      for (var i=0; a = this.deferredCalls[i]; i++ ) {
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
    //console.info('Dispatching event: ' + event, obj);
    var i, e;
    this.events[event] = this.events[event] || [];
    for (i=0; e = this.events[event][i]; i++) { this.bind(e, this)(obj); }
  }
};

