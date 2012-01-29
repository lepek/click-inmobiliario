$(document).ready(function() {
  var seedListsTable;
  seedListsTable = $("#seed-lists-table").dataTable({
    bJQueryUI: true,
    bAutoWidth: false,
    iDisplayLength: 10,
    bSort: true,
    bFilter: true,
    bLengthChange: true,
    sPaginationType: "full_numbers",
    sAjaxSource: PATHS.seed_lists,
    bStateSave: true,
    bProcessing: true,
    bServerSide: true,
    aoColumns: [
      {"bVisible": false, "bSearchable": false},
      {"sWidth": "40%"},
      {"sWidth": "20%"},
      {"sWidth": "20%"},
      {"sWidth": "20%", 
        "fnRender": function(object) {
          var date = new Date.parse(object.aData[object.iDataColumn]);
          return date.toString('MMM d, yyyy h:mm tt');
        }, 
        "bUseRendered": false
      }
    ],
    fnDrawCallback: function(oSettings) {
      styleAllButtons();
      $('#seed-lists-table tbody tr').each(function() {
        var pos = seedListsTable.fnGetPosition(this);
        $(this).click(function() {
          window.location.href = PATHS.seed_lists + "/" + oSettings.aoData[pos]._aData[0];
        });
      });
    }
  });
});