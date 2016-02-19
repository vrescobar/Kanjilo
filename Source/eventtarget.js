// Workaround for Safari and Internet Explorer
if (EventTarget == undefined) {
    //alert('EventTarget is undefined');
    function EventTarget() {
      var eventTarget = document.createDocumentFragment();
      function delegate(method) {
        this[method] = eventTarget[method].bind(eventTarget);
      }
      [
        "addEventListener",
        "dispatchEvent",
        "removeEventListener"
      ].forEach(delegate, this);
    }
}
