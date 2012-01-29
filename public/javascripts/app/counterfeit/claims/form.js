$(document).ready(function() {
  
  // Manage screenshots
  $(".screenshots").attachments({removeInputName: "remove_screenshot"});
  
  // Manage affidavits
  $(".affidavits").attachments({removeInputName: "remove_affidavit"});
  
  $("#counterfeit_claim_brand_id").change(function() {
    $(document).trigger("counterfeit.claim.brand.change", $(this).val());
  });

  $('.datepicker').datepicker({dateFormat: 'yy-mm-dd'});
});

/**
 * Plugin to manage attachments on the form. Attachments are screenshots and
 * affidavits.
 */
(function($) {
  
  var removeInputName;
  
  var canAdd;
  
  var methods = {
      
    init: function(options) {
      this.removeInputName = options.removeInputName;
      methods.initAdd.apply(this);
      methods.initRemove.apply(this);
      methods.initClear.apply(this);
    },
    
    /**
     * First set of inputs cannot be removed but they can be cleared. Initialize the 'clear'
     * button so that when clicked, the first set of fields are set to empty.
     */
    initClear: function() {
      $(".remove", this).click(function() {
        $("input", $(this).closest(".attachment")).val(null);
      });
    },
    
    /**
     * Initialize the button to add an additional set of fields.
     */
    initAdd: function() {
      var that = this;
      $(".add", this).click(function() {
        var attachments = $.makeArray($(".attachment", that));
        var last = attachments.pop();
        
        if (!$("input[type=file]", last).val()) {
          $(last).effect("shake", {times: 3, distance: 10}, 30);
          return;
        }
        var clone = $(last).clone();

        var remove = $("<a>").addClass("remove").attr("href", "javascript:;").text("Remove").click(function() {
          $(this).closest(".attachment").remove();
        });
        
        clone.insertAfter(last);
        $(".remove", clone).remove();
        $("input", clone).val(null);
        clone.prepend(remove);
      });
    },
    
    /**
     * Additional fields can be removed after the first set. Initialize the
     * remove behavior.
     */
    initRemove: function() {
      var that = this;
      $(".existing .remove", this).click(function() {
        $(this).closest("li").remove();

        if ($(".existing li", that).length == 0) {
          $(".existing", that).hide();
        }

        $(".existing").append(
          $("<input>")
          .attr("type", "hidden")
          .attr("name", that.removeInputName + "[]")
          .val($(this).data("id"))
        );
      });
    }
  };
  
  $.fn.attachments = function(method) {
    if (methods[method]) {
      return methods[ method ].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || ! method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' +  method + ' does not exist');
    }
  }
})(jQuery);

/**
 * Plugin to lazily add new trademarks to system.
 */
(function($) {
  
  var FORM_SELECTOR = "#add-trademark";
  
  var trademarksUrl;
    
  var methods = {
    init: function(options) {
      var that = this;
      this.trademarksUrl = options.trademarksUrl;
      
      if (options.canAdd) {
        this.find(".input").append($("<a>").text("Add Trademark").addClass("add").attr("href", "javascript:;").click(function() {
          methods.click.apply(that);
        }));
      }
      
      methods.maybeHide.apply(this);
      
      $(FORM_SELECTOR).submit(function(event) {
        event.preventDefault();
        methods.onSubmit.apply(that);
        return false;
      });
      
      $(document).bind("counterfeit.claim.brand.change", function(event, brandId) {
        methods.onBrandChanged.apply(that, [brandId]);
      });
    },
    
    click: function() {
      $(FORM_SELECTOR).dialog({
        title: "Add New Trademark",
        resizable: false,
        modal: true,
        width: 410,
        draggable: false
      });
    },
    
    onBrandChanged: function(brandId) {
      $("select option", this).remove();
      methods.maybeHide.apply(this);
      $("input[name=trademark[brand_id]]", $(FORM_SELECTOR)).val(brandId);
      var that = this;
      
      $.ajax({
        url: this.trademarksUrl,
        dataType: "json",
        data: {brand_id: brandId},
        type: "get",
        success: function(trademarks) {
          for (var i = 0; i < trademarks.length; i++) {
            methods.addTrademark.apply(that, [trademarks[i], false]);
          }
          
          methods.maybeHide.apply(that);
        }
      });
    },
    
    onSubmit: function() {
      
      var form = $(FORM_SELECTOR);
      var that = this;
      
      var input = $("input[type=text]", form);
      if (!input.val()) {
        input.effect("shake", {times: 3, distance: 10}, 30);
        return false;
      }
        
      $.ajax({  
        url: $(form).attr("action"), 
        data: $(form).serialize(),
        dataType: "json",
        type: "post",
        success: function(data) {
          methods.addTrademark.apply(that, [data, true]);
          
          $("input[type=text]", form).val("");
          $(form).dialog("close");
          $(".no-trademarks", that).hide();
          $("input[type=submit]", form).attr("disabled", null).text("Add Trademark");
        }
      });
      
      $("input[type=submit]", form).attr("disabled", "disabled").text("Saving...");
    },
    
    addTrademark: function(trademark, selected) {
      $("select", this).append(
        $("<option>")
          .text(trademark.country_code + " " + trademark.registration_number)
          .attr("value", trademark.id)
          .attr("selected", selected ? "selected" : null)
      ).show();
    },
    
    maybeHide: function() {
      $(".no-trademarks", this).remove();
      if ($("select option", this).length == 0) {
        $("select", this).hide();
        $("<p>").addClass("no-trademarks").text("There are no trademarks.").insertAfter($("select", this));
      }
    }
  }
  
  $.fn.trademarks = function(method) {
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
