$(document).ready(function() {
  $("fieldset.terms input").click(function() {
    if ($('.warning-message').is(":hidden")) {
      if ($.browser.mozilla) {
        $('.warning-message').animate({ opacity: 0, top: "+=95px" }, 0);
        $(".warning-message").show().animate({ opacity: 1, top: "-=15px" }, 800);
      } else {
        $('.warning-message').animate({ opacity: 0, top: "+=15px" }, 0);
        $(".warning-message").show().animate({ opacity: 1, top: "-=15px" }, 800);
      }
    }
  });
});