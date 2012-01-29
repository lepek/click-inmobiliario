$(document).ready(function() {

  $('a[id|="upload-report-button"]').each(function(index) {
    var matches = $(this).attr("id").match(/^upload-report-button-(\d+)$/);
    var requestId = matches[1];
    $(this).click(function(e) {
      $.fancybox({
        "href": "/global_boarding/uploaded_reports/new?request_id="+requestId
      });
      e.stopPropagation();
    });
  });

});
