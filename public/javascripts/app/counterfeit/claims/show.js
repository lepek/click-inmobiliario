$(document).ready(function() {
  $(".claims").claims();
  
  var slides_options = {
    preload: true,
    play: 0,
    pause: 2500,
    hoverPause: true,
    generatePagination: false
  };
  $('.details > .screenshots').slides(slides_options);
  $('.transactions .screenshots').slides(slides_options);
  
  var rejectDialog;
  $(".reject-claim").click(function() {
    
    if (rejectDialog == null) {
      rejectDialog = $("#reject-claim-reason").dialog({
        title: "Reason for Rejecting Claim",
        resizable: false,
        modal: true,
        draggable: false,
        width: "330px"
      });
      
      $("#reject-claim-reason .cancel").click(function() {
        rejectDialog.dialog("close");
      });
    } else {
      rejectDialog.dialog("open");
    }
  });
  
  $(".progress-bar").progressBar({
    color: function(progress) {
      if (progress < 50) {
        return "green";
      } else if (progress < 70) {
        return "yellow";
      } else if (progress < 100) {
        return "orange";
      } else {
        return "red";
      }
    }
  });
  
});

/**
 * Toggle the claims in the investigation. Ensure that the selected claim is toggled open by
 * default.
 */
(function($) {
  var methods = {
    init: function(options) {
      var that = this;
      $(".toggle", that).click(function() {
        methods.onToggle.apply(that, [$(this).closest("li")]);
        $(this).blur();
      });
      
      $("li.active", that).each(function(index, active) {
        methods.onToggle.apply(that, [active]);
      });

      // Expand claim details if an ID is given in the anchor
      var path = document.location.toString();
      if (path.match("#")) {
        try {
          var anchor = path.split("#")[1];
          methods.onToggle.apply(that, [$("#claim-" + anchor + " .details").closest("li")]);
        } catch (ex) {
          // Ignore.
        }
      }
    },
    
    onToggle: function(li) {
      if ($(".details", li).toggleClass("hidden").hasClass("hidden")) {
        $("a.toggle", li).text("more...");
      } else {
        $("a.toggle", li).text("less...")
      }
    }
  }
  $.fn.claims = function(method) {
    // Method calling logic
    if (methods[method]) {
      return methods[ method ].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || ! method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' +  method + ' does not exist');
    }
  }
})(jQuery);
