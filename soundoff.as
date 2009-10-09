import com.jeremynicoll.SoundOff;
import com.jeremynicoll.SongEvent;

var controller:SoundOff = new SoundOff();
var uid;

/*controller.addToList('1', 'file:///srv/Merb/jeremy-nicoll/public/songs/bragtime.mp3');
controller.addToList('2', 'file:///srv/Merb/jeremy-nicoll/public/songs/snowfall.mp3');
controller.currentIndex = 1;
//controller.seek(4.35 * 60 * 1000);
controller.play();

var timer = new Timer(3000, 1);
timer.addEventListener(TimerEvent.TIMER, pauseController);
timer.start();


function pauseController(e:Event) {
  controller.pause();
  controller.play();
}*/o


var i:int, e:String;
for (i=0; e = SongEvent.CONSTANTS[i]; i++) { controller.addEventListener(e, sendEvent); }

ExternalInterface.marshallExceptions = true;
ExternalInterface.addCallback('call', eCall);
ExternalInterface.addCallback('get', varGet);
ExternalInterface.addCallback('set', varSet);
ExternalInterface.addCallback('uid', setUID);

ExternalInterface.addCallback('initialize', initialize);


function initialize():Boolean {
  return true;
}

function eCall(methodName, ...args):void {
  if (args[0] is Array) {
    controller[methodName].apply(controller, args[0]);
  } else {
    controller[methodName].apply(controller, args);
  }
}

function varSet(varName, val):void {
  controller[varName] = val;
}

function varGet(varName):* {
  return controller[varName];
}

function setUID(newUID):void {
  uid = newUID;
}

function sendEvent(e:SongEvent):void {
  try {
    // This craps out sometimes - need to find out why.
    ExternalInterface.call(
      'SoundOff.list['+ uid +'].dispatchEvent',
      e.getLabel(),
      e.attrs
    );
  } catch(err) {
    var v;
    for (v in e.attrs) { trace(v + ' : ' + e.attrs[v]); }
  }
  
}