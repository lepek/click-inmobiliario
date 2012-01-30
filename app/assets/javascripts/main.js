(function($) {
  /**
   * Provide a wrapper around console.log for logging messages
   */
  $.log = function() {
    if (window.console && window.console.log) {
      console.log.apply(window.console, arguments);
    }
  };
  
  /**
   * Provide a wrapper around console.log for logging messages
   */
  $.fn.log = function() {
    $.log(this);
    return this;
  }
})(jQuery);

(function($) {
  /**
    * Creates the empty objects to do namespacing
    */
  $.extend({
    namespace : function(spaces) {
      var parent_space = window;
      var namespaces = spaces.split(".");

      for (var i = 0; i < namespaces.length; i++) {
        if (typeof parent_space[namespaces[i]] == "undefined") {
          parent_space[namespaces[i]] = new Object();
        }
        parent_space = parent_space[namespaces[i]];
      }
      return parent_space;
    }
  });
})(jQuery);

(function($) {
  /**
    * Converts a jQuery object to HTML string
    */
  $.fn.toHtml = function() {
    return $('<div>').append(this.clone()).remove().html();
  }

  /**
   * Columnar button set support.
   */
  $.fn.colbuttonset = function() {
    $(':radio, :checkbox', this).wrap('<div style="margin: 1px" />');
    $(this).buttonset();
    
    $('label:first', this).removeClass('ui-corner-left').addClass('ui-corner-top');
    $('label:last', this).removeClass('ui-corner-right').addClass('ui-corner-bottom');
    
    var maxWidth = 0;
    $('label', this).each(function(index){
       var width = $(this).width();
       if (width > maxWidth) maxWidth = width; 
    })
    $('label', this).each(function(index){
      $(this).width(maxWidth);
    })
  };
})(jQuery);

/**
 * Converts boolean to yes/no
 *
 * @param [Boolean] value to be converted
 * @return [String, Object] yes/no or original value
 */
var yesNo = function(value) {
  if (typeof value !== 'undefined' && typeof value === 'boolean') {
    return (value - 0) == 0 ? 'no' : 'yes';
  } else {
    return value;
  }
};

var wbr = function(string, breakLength) {
  return string.replace(RegExp("(\\w{" + breakLength + "})(\\w)", "g"), function(all,text,char) { 
    return text + "<wbr>" + char; 
  }); 
};

(function($) {
  /**
   * Opens a new browser window in a pop-up like fashion.
   */
  $.browserWindow = {};

  // Default popup window parameters
  $.browserWindow.defaultParams = {
    url:         null,                // Url (optional) 
    name:        "default",           // Window name
    width:       $(window).width(),   // Window width
    height:      $(window).height(),  // Window height
    top:         null,                // Y offset (in pixels) from top of screen
    left:        null,                // X offset (in pixels) from left side of screen
    directories: true,                // Show directories/Links bar?
    location:    true,                // Show location/address bar?
    resizeable:  true,                // Make the window resizable?
    menubar:     true,                // Show the menu bar?
    toolbar:     true,                // Show the toolbar?
    scrollbars:  true,                // Show scrollbars?
    status:      true                 // Show the status bar?
  };

  // Default config options
  $.browserWindow.defaultConfig = {
    autoFocus: true,                  // Focus new window?
    blank:     'about:blank'          // Default new page
  };

  // new browser window handle 
  var handle = null;

  /**
   * Creates a new browser window.
   *
   * @param  [String] href
   * @param  [Object] params
   * @param  [Object] config
   * @return [Window, Boolean] Window handle, or false if it could not be created
   */
  $.browserWindow._newWindow = function(href, params, config) {

    var windowParams = (params) ? $.extend($.browserWindow.defaultParams, params) : $.browserWindow.defaultParams;
    var windowConfig = $.browserWindow.defaultConfig;

    var i, paramString = "";

    // Build config string used when opening browser window
    for (i in windowParams) {
      if (windowParams.hasOwnProperty(i)) {
        paramString += (paramString === "") ? "" : ",";
        paramString += i + "=";
        paramString += yesNo(windowParams[i]);
      }
    }

    // Load about:blank initially, then redirect to the requested URL
    this.handle = window.open(windowConfig.blank, windowParams.name, paramString);
    if (this.handle == undefined) {
      return;
    }
    this.handle.location.href = href;

    // Focus window if necessary
    if (windowConfig.autoFocus) {
      if (typeof this.handle.focus == 'function') {
        this.handle.focus();
      }
    }

    return this.handle;
  };

  /**
   * Opens a new browser window.
   *
   * @return [Boolean] True if the window was opened successfully
   */
  $.fn.browserWindow = function(params) {

    var params = (params) ? params : {};

    if (params.url) {
      var windowObject = $.browserWindow._newWindow(params.url);
    } else {
      $(this).click(function (event) {

        // Prevent the browser's default onClick handler
        event.preventDefault();

        if ($(this).attr("href")) {
          href = $(this).attr("href");
        } else {
          return;
        }

        // Open new window
        var windowObject = $.browserWindow._newWindow(href);
      });
    }
    return $;
  };
})(jQuery);

(function($) {
  /*
   * Re-numbers multi-fields that can be dynamically created.  Only really
   * useful if you must keep two or more related components grouped (and 
   * therefore can't simply name each field foo[]).
   *
   * @param [String, jQuery] selector jQuery selector
   */
  $.fn.renumberDynamicFields = function(selector) {
    $(this).each(function(index, element) {
      $(element).find(selector).attr({
        id: function() {
          return this.id.replace(/(\d+)/, index);
        },
        name: function() {
          return this.name.replace(/(\d+)/, index);
        }
      });
    });
  };
})(jQuery);

(function($) {
  /**
   * Display text hints for form fields.
   * Use 'title' attribute on label for hint text
   * unless 'placeholder' attribute is used on input element
   * 
   * @param {Object} opts Options for how hint is displayed
   * Options - 
   *  hideOnFocus: bool [Hide hint on focus -- defaults to true]
   */
  $.fn.fieldHint = function(opts) {
    return this.each(function(){
      var options = opts || { 'hideOnFocus' : true };
      var label = $(this);
      var labelClass = label.attr('class')
      var labelFor   = label.attr('for');
      var labelTitle = label.attr('title');

      if (labelFor && labelTitle) {
        var field = $("#upload-screenshot-url");
        
        // return if input is using placeholder attribute
        if (field.attr('placeholder')) {
          return;
        }
        
        // wrap input field with div
        fieldWrap = $('<div />').css({
          'position': 'relative',
          'margin': '0px',
          'padding': '0px',
          'display': 'inline-block'
        });
        $(field).wrap(fieldWrap);
        
        // add hidden span with hint text
        hiddenSpan = $('<span>' + labelTitle + '</span>')
          .css({
            'display': 'block',
            'position': 'absolute',
            'height': '15px',
            'top': $(field).height(),
            'left': parseInt((field).css("padding-left")) + 'px'
          })
          .addClass('hint');
        $(hiddenSpan).insertBefore(field);
        
        var f = function(e) {
        var $field = $(field);
          if (field.val() || (e.type == 'focus' && options.hideOnFocus)) {
            hiddenSpan.hide();
            hiddenSpan.removeClass('focus')
          } else {
            if (e.type == 'blur') {
              hiddenSpan.removeClass('focus');
            } else {
              hiddenSpan.addClass('focus');
            }
            hiddenSpan.fadeIn('fast');
          }
        }

        field.focus(f);
        field.keyup(f);
        field.change(f);
        field.blur(f);
        field.each(f);
      }
    });
  };
})(jQuery);

/**
 * Style refresh buttons
 */
var styleRefreshButtons = function() {
  (function($) {
    $('button.refresh').button({
      icons: {
        primary: 'ui-icon-refresh'
      }
    });
  })(jQuery);
};

/**
 * Style search buttons
 */
var styleSearchButtons = function() {
  (function($) {
    $('button.search').button({
      icons: {
        primary: 'ui-icon-search'
      }
    });
  })(jQuery);
};

/**
 * Style add buttons
 */
var styleAddButtons = function() {
  (function($) {
    $('button.add').button({
      icons: {
        primary: 'ui-icon-plusthick'
      }
    });
  })(jQuery);
};

/**
 * Style delete buttons
 */
var styleDeleteButtons = function() {
  (function($) {
    $('button.delete').button({
      icons: {
        primary: 'ui-icon-minusthick'
      }
    });
  })(jQuery);
};

/**
 * Style save buttons
 */
var styleSaveButtons = function() {
  (function($) {
    $('button.save').button({
      icons: {
        primary: 'ui-icon-disk'
      }
    });
  })(jQuery);
};

/**
 * Style calendar buttons
 */
var styleCalendarButtons = function() {
  (function($) {
    $('button.ui-datepicker-trigger').button({
      icons: {
        primary: 'ui-icon-calendar'
      }
    });
  })(jQuery);
}

/**
 * Style all button types
 */
var styleAllButtons = function() {
  $('input[type="button"]').button();
  $('button[type="button"]').button();
  $('input[type="submit"]').button();
  styleAddButtons();
  styleDeleteButtons();
  styleRefreshButtons();
  styleSearchButtons();
  styleSaveButtons();
  styleCalendarButtons();
}

var redirectToLoginOn401Error = function(xhr, status, err) {
  if (xhr.status == 401) {
    window.location.href = '/users/sign_in'; 
  }
}

$(document).ready(function() {
  // Automatically style all buttons
  styleAllButtons();
  $('.hint').fieldHint();
  
  $('.form-errors').not('.static').delay(10000).fadeOut(500);
  
  // Superfish setup
  $('.sf-menu').superfish({
    delay: 200,
    speed: 'fast',
    autoArrows: false,
    dropShadows: false,
    disableHI: true
  });
  
  $.ajaxSetup({error: redirectToLoginOn401Error});
  
  /*
  positionFooter(); 
	function positionFooter(){
		if($(document).height() < $(window).height()){
			$("footer").css({position: "absolute",top:($(window).scrollTop()+$(window).height()-$("footer").height())+"px"})
		}	
	}
 
	$(window)
		.scroll(positionFooter)
		.resize(positionFooter)
  */
});

/**
 * Add the CSRF token to all AJAX posts.
 * 
 * @see http://brandonaaron.net/blog/2009/02/24/jquery-rails-and-ajax
 */
$(document).ajaxSend(function(event, request, settings) {
  if (settings.type.toUpperCase() == "POST") {
    var m = $("meta[name=csrf-token]");
    settings.data = (settings.data ? settings.data + "&" : "") +
      "authenticity_token=" + encodeURIComponent(m.attr("content"));
  }
});
