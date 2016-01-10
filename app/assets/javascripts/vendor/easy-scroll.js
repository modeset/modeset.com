(function(){
  var easyScroll = {};
  window.easyScroll = easyScroll;

  var startScrollY,
      scrollDist,
      frame,
      frames;

  function easeInOutQuad(t, b, c, d) {
    if ((t/=d/2) < 1) return c/2*t*t + b;
    return -c/2 * ((--t)*(t-2) - 1) + b;
  };

  function animateScroll() {
    frame++;
    if(frame <= frames) requestAnimationFrame(animateScroll);
    var percentComplete = frame / frames;
    var scrollProgress = scrollDist * easeInOutQuad(percentComplete, 0, 1, 1);
    window.scrollTo(0, Math.round((startScrollY - scrollProgress)));
  }

  easyScroll.scrollByY = function(duration, scrollAmount) {
    startScrollY = easyScroll.scrollY();
    scrollDist = scrollAmount;
    frame = 0;
    frames = Math.floor(duration / 16);
    requestAnimationFrame(animateScroll);
  };

  easyScroll.scrollToEl = function(duration, el, offset) {
    easyScroll.scrollByY(duration, -el.getBoundingClientRect().top + offset);
  };

  easyScroll.scrollY = function() {
    return window.scrollY || window.pageYOffset;
  };
})();
