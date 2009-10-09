import com.jeremynicoll.SoundOff;

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
}*/


ExternalInterface.marshallExceptions = true;
ExternalInterface.addCallback('initialize', initialize);
ExternalInterface.addCallback('call', eCall);
ExternalInterface.addCallback('get', varGet);
ExternalInterface.addCallback('set', varSet);
ExternalInterface.addCallback('uid', setUID);
ExternalInterface.addCallback('callback', setCallback);

function initialize() {
  return true;
}

function eCall(methodName, ...args) {
  if (args[0] is Array) {
    controller[methodName].apply(controller, args[0]);
  } else {
    controller[methodName].apply(controller, args);
  }
}

function varSet(varName, val) {
  controller[varName] = val;
}

function varGet(varName) {
  return controller[varName];
}

function setUID(newUID) {
  uid = newUID;
}

function setCallback() {}