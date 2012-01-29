$(document).ready(function() {
  $(".toggle").click(function() {
    var nextRow = $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick").closest("tr").next();
    while (nextRow.hasClass("nested")) {
      nextRow.toggle();
      nextRow = nextRow.next();
    }    
  });
});