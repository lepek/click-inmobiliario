$(document).ready(function() {
  $("input#queries_term_name").autocomplete({
    source: function(request, response) {
      $.ajax({
        url: PATHS.terms_search,
        dataType: "json",
        delay: 0,
        data: {
          "q": request.term
        },
        success: function(data) {
          response($.map(data, function(item) { 
            return item.value;
          }))
        }
      });
    },
    minLength: 0
  });

  $("form[data-remote]").each(function(i, form) {
    var f = $(form);
    var loading = $("<span class='form-message' id='loading'></span>"),
        notice  = $("<span class='form-message' id='notice'></span>"),
        errors  = $("<span class='form-message' id='error'><ul></ul></span>");

    $("#message-container").append(loading.hide());
    $("#message-container").append(notice.hide());
    $("#message-container").append(errors.hide());
    
    // hide errors and notice and show spinner loading
    f.bind("ajax:loading", function() {  
      loading.show();
      errors.hide().empty();
      notice.hide().empty();
    })
    // hide loading indicator when finished
    f.bind("ajax:complete", function() {
      loading.hide();
    })
    // show notice on success
    f.bind("ajax:success", function(ev, data, status, xhr) {
      // all good
    })
    // show errors on failure
    f.bind("ajax:failure", function(ev, xhr, status) {
      loading.hide();
      notice.empty();
      errors.html("");
      $.parseJSON(xhr.responseText).forEach(function(msg) {
        console.log(msg)
        errors.append("<li>" + msg + "</li>");
      })
      $("#message-container").append(errors);
    })
  });
});