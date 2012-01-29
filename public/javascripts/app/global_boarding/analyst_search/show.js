$(document).ready(function() {

  // submit the form to the API
  $("#gb-analyst-search-submit").click(function() {
    $("#search-results-container").show();
    $("#search-results").hide();
    $("#search-spinner").show();
    var search = $("#select-search").val();
    $.ajax({
      url: PATHS.search_url,
      type: 'PUT',
      success: function(data) { showData(data) },
      error: function(jqXHR, textStatus, errorThrown) 
               { showError(jqXHR) },
      data: $("form").serializeArray(),
      dataType: 'html'
    });
    return false;
  });

  function showData(data) {
    var search = $("#select-search");
    $("#search-results").html(data);
    $("#search-spinner").hide();
    $("#search-results").show();
  }

  function showError(jqXHR) {
    errorHtml = $(document.createElement('p'));
    errorHtml.text("Rails error doing search: "+jqXHR.statusText);
    $("#search-results").html(errorHtml);
    $("#search-spinner").hide();
    $("#search-results").show();
  }

  $("#select-search").change(function() {
    if ($("#select-search").val() == 'whois_contacts') {
      $("#main-form").hide();
      $("#whois-form").show();
    }else {
      $("#whois-form").hide();
      $("#main-form").show();
    }
  });

  $("#merchant-url-field").focus();

});
