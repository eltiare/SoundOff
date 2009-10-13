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

import com.jeremynicoll.SoundOff;
import com.jeremynicoll.SongEvent;

var controller:SoundOff = new SoundOff();
var uid;

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
  //try {
    ExternalInterface.call(
      'SoundOff.list['+ uid +'].dispatchEvent',
      e.getLabel(),
      e.attrs
    );
  //} catch(e) {}
}