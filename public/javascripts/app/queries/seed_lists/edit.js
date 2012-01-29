$(document).ready(function() {
  var seedUrlsTable;
  seedUrlsTable = $("#seed-list-urls").dataTable({
    bJQueryUI: true,
    bAutoWidth: true,
    iDisplayLength: 10,
    bSort: true,
    bFilter: true,
    bLengthChange: true,
    sPaginationType: "full_numbers",
    bStateSave: true
  });
});