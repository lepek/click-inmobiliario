$(document).ready(function() {
  // Set up the data tables.
  $('#spreadsheet-statistics table').dataTable({
    bJQueryUI: true,
    bPaginate: false,
    bLengthChange: false,
    bFilter: false,
    bSort: false,
    bInfo: false,
    aoColumnDefs: [{ sWidth: '200px', aTargets: [0] }]
  });
  
  $('#form .on-hold').buttonset();
  
  $('#spreadsheet-actions .refine-button')
    .button({ icons: { primary: 'ui-icon-folder-open' }})
    .click(function() { window.open(googleRefineUrl); });
    
  $('#spreadsheet-actions .download-button')
    .button({ icons: { primary: 'ui-icon-arrowthickstop-1-s' }})
    .click(function() { window.open(spreadsheetDownloadUrl); });
  
  $('#history table').dataTable({
    aaSorting: '',
    aoColumns: [{ 'bSortable': false }],
    iDisplayLength : 3,
    aLengthMenu: [3, 5, 10],
    oLanguage: {sZeroRecords: "No notes have been added."}
  });
});
