$(document).ready(function() {
  $("#seed-list").treeview({ collapsed: true });
  
  $('button.edit').button({ icons: { primary: 'ui-icon-pencil' } });
  $('input.edit').button({ icons: { primary: 'ui-icon-pencil' } });
  
  $.widget( "custom.taggedcomplete", $.ui.autocomplete, {
    _renderItem: function(ul, item) {
      innerspan = $("<span></span>")
              .text(item.type)
              .addClass(item.type)
              .attr("id", "query-tag");
      tag = $("<span></span>").prepend(innerspan);
      
      return $("<li></li>")
        .data("item.autocomplete", item)
        .append($("<a></a>").text(item.label)
        .prepend(tag)).appendTo(ul);
    }
  });
  
  $("#query").taggedcomplete({
    source: PATHS.queries_search,
    select: function( event, ui ) {
      
      $("#type").val(ui.item.type);
      $("#id").val(ui.item.id);
      
      console.log( ui.item ?
        "Selected: " + ui.item.value + " aka " + ui.item.id + " type: " + ui.item.type:
        "Nothing selected, input was " + this.value );
    }
  });
  
  $("#tabs").tabs({
    select: function() { return $(this).index($(document.location.hash)); }
  });

  var searchSummaryTable;
  searchSummaryTable = $("#search-summary-table").dataTable({
    bJQueryUI: true,
    bAutoWidth: false,
    iDisplayLength: 10,
    sPaginationType: "full_numbers",
    fnDrawCallback: function(oSettings) {
      $('#search-summary-table tbody tr td:not(.actions-column)').each(function() {
        // var pos = searchHistoryTable.fnGetPosition(this);
        //         $(this).click(function() {
        //           window.location.href = "/" + oSettings.aoData[pos[0]]._aData[0];
        //         });
        // console.log(oSettings)
      });
    }
  });
  
  var searchDetailTable;
  searchHistoryTable = $("#search-detail-table").dataTable({
    bJQueryUI: true,
    bAutoWidth: false,
    iDisplayLength: 10,
    sPaginationType: "full_numbers",
    fnDrawCallback: function(oSettings) {
      $('#search-detail-table tbody tr td:not(.actions-column)').each(function() {
        // var pos = searchHistoryTable.fnGetPosition(this);
        //         $(this).click(function() {
        //           window.location.href = "/" + oSettings.aoData[pos[0]]._aData[0];
        //         });
        // console.log(oSettings)
      });
    }
  });
});