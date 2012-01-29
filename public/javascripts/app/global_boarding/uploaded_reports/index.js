$(document).ready(function() {

  $('a[id|="edit-report-button"]').each(function(index) {
    var matches = $(this).attr("id").match(/^edit-report-button-(\d+)$/);
    var reportId = matches[1];
    $(this).click(function(e) {
      $.fancybox({
        "href": "/global_boarding/uploaded_reports/"+reportId+"/edit"
      });
      e.stopPropagation();
    });
  });

});