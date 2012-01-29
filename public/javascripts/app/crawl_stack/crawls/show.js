$(document).ready(function() {
  
  $('button.download').button({
    icons: { primary: 'ui-icon-arrowthickstop-1-s' }
  });
  
  $('#event-table').dataTable({
    bJQueryUI: true,
    iDisplayLength: 25,
    bSort: true,
    bSortClasses: false,
    bFilter: false,
    bLengthChange: false,
    sPaginationType: 'full_numbers',
    aoColumnDefs: [
      {
        fnRender: function(oObj) {
          var d = oObj.aData[oObj.iDataColumn];
          if (typeof(d) == 'undefined' || d == null || d == '') {
            return '';
          }
          return Date.parse(d).toString('MMM d, yyyy HH:mm:ss');
        },
        aTargets: [0, 1]
      },
      {
        fnRender: function(oObj) {
          var val = oObj.aData[oObj.iDataColumn];
          if (val == undefined || val == null || val == '') {
            return '';
          }
          
          return val + ' seconds';
        },
        aTargets: [2],
        bUseRendered: false
      }
    ]
  });
  
  $('#hit-table').dataTable({
    bJQueryUI: true,
    iDisplayLength: 25,
    bSort: false,
    bSortClasses: false,
    bFilter: false,
    bLengthChange: false,
    sPaginationType: 'full_numbers',
    bProcessing: true
  });
  
  $('#profile-table').dataTable({
    bJQueryUI: true,
    bSort: false,
    bPaginate: false,
    bFilter: false,
    bLengthChange: false,
    bInfo: false,
    bProcessing: true
  });
  
  $('#tabs').tabs();
});
