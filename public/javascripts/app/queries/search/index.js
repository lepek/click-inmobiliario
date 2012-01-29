$(document).ready(function() {
  var searchHistoryTable;
  searchHistoryTable = $("#search-history-table").dataTable({
    bJQueryUI: true,
    bAutoWidth: false,
    iDisplayLength: 10,
    sPaginationType: "full_numbers",
    fnDrawCallback: function(oSettings) {
      $('#search-history-table tbody tr td:not(.actions-column)').each(function() {
        // var pos = searchHistoryTable.fnGetPosition(this);
        //         $(this).click(function() {
        //           window.location.href = "/" + oSettings.aoData[pos[0]]._aData[0];
        //         });
        console.log(oSettings)
      });
      
      
      $('button.summary').button({ icons: { primary: 'ui-icon-document' } });
      $('button.detail').button({ icons: { primary: 'ui-icon-circle-zoomin' } });
      $('button.export').button({ icons: { primary: 'ui-icon-disk' } });
    }
  });
});