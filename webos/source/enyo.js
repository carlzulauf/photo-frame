// enyo.kind({
//    name : "enyo.powermng",
//    kind : enyo.VFlexBox,
//    components : [{
//       name : "startActivity",
//       kind : "PalmService",
//       service : "palm://com.palm.power/com/palm/power",
//       method : "activityStart",
//       onSuccess : "startActivitySuccess",
//       onFailure : "startActivityFailure",
//       subscribe : true
//     },
//     {
//       name : "endActivity",
//       kind : "PalmService",
//       service : "palm://com.palm.power/com/palm/power",
//       method : "activityEnd",
//       onSuccess : "endActivitySuccess",
//       onFailure : "endtActivityFailure",
//       subscribe : true
//     }],
//     startActivityNow: function() {
//       this.$.startActivity.call({"id": "com.palmdts.enyo.powermng.example-1", "duration_ms":5000});
//     },
//     endActivityNow: function() {
//       this.$.endActivity.call({"id": })
//     },
//     startActivitySuccess: function(inSender, inResponse) {
//       this.log("Start activity success, results=" + enyo.json.stringify(inResponse));
//     },
//     // Log errors to the console for debugging
//     startActivityFailure: function(inSender, inError, inRequest) {
//       this.log("Failure");
//       this.log(enyo.json.stringify(inError));
//     }
// });

(function(scope) {
  var debugQueue = [];
  scope.$d = null;
  scope.debugEnabled = false;
  scope.debug = function(message) {
    if (message) debugQueue.push(message);
    if (scope.$d) {
      while (debugQueue.length > 0) {
        var msg = debugQueue.shift();
        scope.$d.append(msg + "\n<br>\n");
      }
    }
  }
  $(function(){
    if (scope.debugEnabled) {
      scope.$d = $("#debug-box");
      scope.debug();
    }
  });
})(window);

enyo.kind({
  name: "EnyoFrame",
  kind: enyo.VFlexBox,
  keptScreen: false,
  screenKeeper: null,
  w: null,
  constructor: function() {
    var that = this;
    $(function(){
      window.photos = new PhotoFrame();
      that.keepScreen();
    })
  },
  keepScreen: function() {
    if (!this.keptScreen) {
      debug("Start blockScreenTimeout");
      this.keptScreen = true;
      try {
        this.w = Object.extended(enyo.windows.getWindows()).values().first();
        enyo.windows.setWindowProperties(this.w, {'blockScreenTimeout': true});
        this.keepScreenTimer();
        debug("Got through keepScreen successfully");
      } catch(e) {
        debug("Error: " + e);
      }
    }
  },
  keepScreenTimer: function() {
    debug("Setting up refresh interval");
    var that = this;
    this.screenKeeper = window.setInterval(function(){
      enyo.windows.setWindowProperties(that.w, {'blockScreenTimeout': true});
      debug("Refreshed blockScreenTimeout");
    }, 300000);
  }
});

enyo.setFullScreen(true);
