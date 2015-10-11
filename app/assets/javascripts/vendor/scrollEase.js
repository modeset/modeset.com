function scrollEase(scrollDuration, scrollAmount) {
  var scrollHeight = window.scrollY,
      scrollStep = Math.PI / ( scrollDuration / 15 ),
      cosParameter = scrollAmount / 2;
  var destY = scrollHeight - scrollAmount,
      scrollCount = 0,
      scrollProgress = 0;
  function step () {
    setTimeout(function() {
      scrollCount = scrollCount + 1;
      scrollProgress = cosParameter - cosParameter * Math.cos( scrollCount * scrollStep );
      window.scrollTo( 0, ( scrollHeight - scrollProgress ) );
      if ( Math.abs(window.scrollY - destY) > 1.1 && scrollCount * scrollStep < Math.PI ) {
        requestAnimationFrame(step);
      }
    }, 15 );
  }
  requestAnimationFrame(step);
}
