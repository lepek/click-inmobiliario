$(document).ready(function() {
  /**
   * Enable Toggle-Box functionality
   */
  $(".toggle-box .toggle-box-header").click(function() {
    // Assume that the panel directly follows the header
    var panel = $(this).next();
    
    // Make sure there isn't already an animation playing
    // Changing mid-animation will cause toggling to permanently break
    if (!panel.is('.ui-effects-wrapper')) {
    
      // Show/hide the panel
      if ($(this).is('.active')) {
        $(this).removeClass("active");
        $(this).addClass("inactive");
      } else {
        // Style all buttonsets within the div that haven't already been styled
        panel.find(".buttonset:not(.ui-buttonset)").buttonset();
        $(this).removeClass("inactive");
        $(this).addClass("active");
      }
      
      // Animate opening after the buttonsets have been styled
      panel.toggle('blind', null, 'fast');
      
      // Change the icon on the toggle-box header
      var icon = $(this).children('.ui-icon');
      if (icon.is('.ui-icon-triangle-1-e')) {
        icon.removeClass("ui-icon-triangle-1-e");
        icon.addClass("ui-icon-triangle-1-s");
      } else {
        icon.removeClass("ui-icon-triangle-1-s");
        icon.addClass("ui-icon-triangle-1-e");
      }
    }
    return false;
  });
  
  /**
   * Activate all buttonsets within panels that are already open.
   */
  $('.toggle-box-panel:not(.default-closed)').find(".buttonset").buttonset();
});
