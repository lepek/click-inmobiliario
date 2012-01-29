(function($) {

	var methods = {
		init: function(options) {
		  if (options == null) {
		    options = {}
		  }
		  
			var total = this.data("total");
			var current = $(".progress", this).data("current");
			var progress = current / total * 100;
			if (progress > 100) {
			  progress = 100;
			}
      
      var color = "green";
      
      if (options.color) {
        color = options.color(progress);
      }
      
			$(".progress", this).css("width", progress + "%").addClass(color);
		}
	};

	$.fn.progressBar = function(method) {
	  // Method calling logic
	  if (methods[method]) {
	    return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
	  } else if (typeof method === "object" || ! method) {
	    return methods.init.apply(this, arguments);
	  } else {
	    $.error("Method " +  method + " does not exist on jQuery.tooltip");
	  }
	}
})(jQuery);