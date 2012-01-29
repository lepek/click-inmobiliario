var createCrawlTable = function(query, path) {
  var crawlsTable;
  
  crawlsTable = $('#crawls-table').dataTable({
    bJQueryUI: true,
    iDisplayLength: 10,
    bSort: false,
    bSortClasses: false,
    bFilter: false,
    bLengthChange: false,
    sPaginationType: 'full_numbers',
    bProcessing: true,
    bServerSide: true,
    sAjaxSource: path + '?q=' + query,
    fnDrawCallback: function() {
      $('td').bind('mouseenter', function() {
        $(this).parent().children().each(function() {
          $(this).addClass('datatable-row-highlight');
        });
      });
      
      $('td').bind('mouseleave', function() {
        $(this).parent().children().each(function() {
          $(this).removeClass('datatable-row-highlight');
        });
      });
    },
    aoColumns: [
      {
        bVisible: false
      }, null, null, null, null, null, null
    ],
    aoColumnDefs: [
      {
        fnRender: function(oObj) {

          var date = oObj.aData[oObj.iDataColumn];
          if (date == undefined || date == null || date == '' || date.length == 0) {
            return 'Unknown';
          }
          
          /*
           * Remove the milliseconds as it breaks Datejs
           * @see http://code.google.com/p/datejs/issues/detail?id=103
           */
          date = date.substring(0, date.indexOf('.'));
          parsedDate = Date.parseExact(date, 'yyyy-MM-dd HH:mm:ss');
          if (parsedDate != null) {
            return parsedDate.toString('MMM d, yyyy');
          } else {
            return 'Unknown';
          }
        },
        aTargets: [1]
      }, {
        fnRender: function(oObj) {
          /* We need to cut the displayed URL down to a manageable size because the
           * input could potentially be extremely large. */
          var url = oObj.aData[oObj.iDataColumn];
          var max_url_length = 200;

          /* Only output ellipsis when we have sliced the end off the URL. */
          return url.length > max_url_length ?
            url.substring(0, max_url_length) + '...' : url;
        },
        aTargets: [2]
      }, {
        fnRender: function(oObj) {
          var n = oObj.aData[oObj.iDataColumn];
          if (n == undefined || n == null || n == '' || n == 0) {
            return 0;
          }
          return $.formatNumber(n, {format: '#,###'});
        },
        aTargets: [4, 5]
      }, {
        fnRender: function(oObj) {
          var statusEnum = oObj.aData[oObj.iDataColumn];
          if (statusEnum == undefined || statusEnum == null || statusEnum == '' || statusEnum == 0) {
            return '';
          }
          
          var status = statusEnum.toLowerCase().replace(/_/g, ' ');
          return status.charAt(0).toUpperCase() + status.slice(1);
        },
        aTargets: [6]
      }],
      fnRowCallback: function(nRow, aData, iDisplayIndex) {
        $(nRow).click(function() {
          window.location.href = path + '/' + aData[0] + '?q=' + query;
        });
        
        return nRow;
      }
  });
}