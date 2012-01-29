/*
 * Build a dataTable from many queries.
 */
(function($) {  
  // Number of seconds in a day.
  var SECONDS_IN_DAY = 86400;
  
  // Number of seconds in a week.
  var SECONDS_IN_WEEK = 604800;
  
  // Local timezone offset. Assume PST
  var LOCAL_TIMEZONE_OFFSET = -8;
  
  // Array of the active queries.
  var queries = [];
  
  // Datatable that holds the aggregate of all sub-queries / dataTables.
  var dt = null;
  
  // The Google Visualization graph.
  var graph = null;
  
  // A list of the columns currently being displayed
  var displayedColumns = [0];
  
  var colors = ['green', 'red', 'blue', 'orange', 'purple'];
  
  // Query all the datasources, building up a single dataTable.
  var query = function(start, end, clientId, showTrend, showActive, callback) {
    queries = [];
    
    // Reset the dataTable
    dt = null;

    // Which endpoint should we query?
    // This will depend on how large of a timespan we are looking at.
    var dif = Math.floor((end.valueOf() - start.valueOf()) / 1000);

    var endpoint = DAILY_ENDPOINT;
    if (dif <= SECONDS_IN_DAY) {
      endpoint = FIVE_MINUTE_ENDPOINT;
    } else if (dif <= SECONDS_IN_WEEK) {
      endpoint = HOURLY_ENDPOINT;
    }
    
    // Get the right set of queries
    var queryStrings = null;
    if (showActive) {
      queryStrings = getActiveQueries(start, end, clientId);
    } else {
      queryStrings = getCompletedQueries(start, end, clientId);
    }
    
    // Determine what kind of callback should be used
    var myCallback = callback;
    if (!showTrend) {
      // We want to show the cumulative
      myCallback = function(dataTable) {
        dataTable = summate(dataTable);
        callback(dataTable);
      }
    }
    // Execute all the queries
    for (var i = 0; i < queryStrings.length; i++) {
      execute(queryStrings[i], endpoint, myCallback);
    }
  };
  
  var getActiveQueries = function(start, end, clientId) {
    return [
      getInQueueQuery(start, end, clientId),
      getInCrawlQuery(start, end, clientId),
      getInKeywordQuery(start, end, clientId),
      getInAuditQuery(start, end, clientId)
    ];
  }
  
  var getCompletedQueries = function(start, end, clientId) {
    return [
      getQueuedQuery(start, end, clientId),
      getCrawledQuery(start, end, clientId),
      getKeywordQuery(start, end, clientId),
      getAuditedQuery(start, end, clientId),
      getErrorQuery(start, end, clientId)
    ];
  }
  
  // Find the running sum
  var summate = function(dataTable) {
    var copy = dataTable.clone();
    copy.sort([{ column: 0 }]);
    var numCols = copy.getNumberOfColumns();
    for (var i = 1; i < numCols; i++) {
      var n = copy.getNumberOfRows();
      var rt = 0; // Running total
      for (var j = 0; j < n; j++) {
        rt += copy.getValue(j, i);
        copy.setCell(j, i, rt);
      }
    }
    
    return copy;
  };
  
  var execute = function(query, endpoint, callback) {
    var gq = new google.visualization.Query(endpoint, {sendmethod: 'xhr'});
    gq.setQuery(query.query);

    gq.send(function(response) {
      // If gq is no longer in queries array, ignore.
      var found = false;
      for (var i = 0; i < queries.length; i++) {
        if (queries[i] == gq) {
          found = true;
        }
      }
      
      if (!found) {
        $.log('Query results are no longer needed. Throwing this away.');
        return;
      }
            
      var d = response.getDataTable();
      for (var i = 0; i < query.labels.length; i++) {
        d.setColumnLabel(i, query.labels[i]);
      }

      gq.complete = true;
      gq.dt = d;

      var isComplete = true;
      for (var i = 0; i < queries.length; i++) {
        if (!queries[i].complete) {
          isComplete = false;
        }
      }
      
      if (isComplete) {
        for (var i = 0; i < queries.length; i++) {
          // Join the results with any existing results.
          dt = join(dt, queries[i].dt);
        }
        
        var dateFormatter = new google.visualization.DateFormat({
          pattern: 'MMM dd HH:mm', 
          timeZone: LOCAL_TIMEZONE_OFFSET
        });
        dateFormatter.format(dt, 0);
        
        var numFormatter = new google.visualization.NumberFormat({fractionDigits: 0});
        var numCols = dt.getNumberOfColumns();
        for (var i = 1; i < numCols; i++) {
          numFormatter.format(dt, i);
        }
        callback(dt);
      }
    });
    
    queries[queries.length] = gq;
  };
  
  var join = function(dt1, dt2) {
    if (dt1 == null) {
      timestampToDate(dt2);
      return dt2;
    }
    
    if (dt2 == null) {
      timestampToDate(dt1);
      return dt1;
    }
    
    timestampToDate(dt1);
    timestampToDate(dt2);
    
    // Keep all columns from table 1.
    var c1 = new Array();
    for (var i = 1; i < dt1.getNumberOfColumns(); i++) {
      c1[i - 1] = i;
    }
    
    // Keep all columns from table 2.
    var c2 = new Array();
    for (var i = 1; i < dt2.getNumberOfColumns(); i++) {
      c2[i - 1] = i;
    }
    
    // Join tables 1 and 2, keeping all columns.
    return google.visualization.data.join(dt1, dt2, 'full', [[0,0]], c1, c2);
  };
  
  /**
   * Datetime fields are not automatically being converted
   * to javascript Date objects when the raw JSON is read into
   * the Google DataTable object. This function converts the
   * specified date column from a string timestamp to a date
   * object.
   */
  var timestampToDate = function(dataTable, dateColIndex) {
    if (typeof(dateColIndex) == 'undefined' || dateColIndex == null) {
      dateColIndex = 0;
    }
    
    var numRows = dataTable.getNumberOfRows();
    for (var i = 0; i < numRows; i++) {
      var d = dataTable.getValue(i, dateColIndex);
      if (typeof(d) == 'string') {
        d = Date.parse(d);
        dataTable.setCell(i, dateColIndex, d);
      }
    }
  };

  var getErrorQuery = function(startTime, endTime, clientId) {
    return buildCompletedQuery(startTime, endTime, clientId, ['ERROR'], 'Error');
  }
  
  var getQueuedQuery = function(startTime, endTime, clientId) {
    return buildCompletedQuery(startTime, endTime, clientId, ['CRAWL_REQUESTED'], 'Queued');
  }
  
  var getCrawledQuery = function(startTime, endTime, clientId) {
    return buildCompletedQuery(startTime, endTime, clientId, [
      'CRAWL_SESSION_TIMEOUT',
      'CRAWL_EXHAUSTED',
      'CRAWL_FAILED_START',
      'CRAWL_STOP_SIGNAL',
      'CRAWL_DOCSTORE_FAILED',
      'CRAWL_REDIRECT',
      'CRAWL_PARKED'],
      'Crawled');
  }
  
  var getKeywordQuery = function(startTime, endTime, clientId) {
    return buildCompletedQuery(startTime, endTime, clientId, [
      'KEYWORD_SUCCESS',
      'KEYWORD_FAILURE'],
      'Queried');
  }
  
  var getAuditedQuery = function(startTime, endTime, clientId) {
    return buildCompletedQuery(startTime, endTime, clientId, [
      'PCI2_AUDITS_ACTIONED',
      'PCI2_AUDIT_NO_ACTIONS',
      'PCI2_AUDIT_FAILURE'],
      'Audit generated');
  }
  
  var buildCompletedQuery = function(startTime, endTime, clientId, statuses, label) {
    startTime = dateToString(startTime);
    endTime   = dateToString(endTime);
    
    var query = 'SELECT start_time, sum(population) WHERE (status = "' + statuses[0] + '"';
    for (var i = 1; i < statuses.length; i++) {
      query += ' OR status = "' + statuses[i] + '"'
    }
    query += ')';
    query += ' AND start_time >= "' + startTime + '"';
    query += ' AND start_time < "' + endTime + '"';
    
    if (typeof(clientId) == 'undefined' || clientId == null || clientId == 0) {
      query += ' AND client_id IS NULL'
    } else {
      query += ' AND client_id = ' + clientId
    }
    
    query += ' GROUP BY start_time ORDER BY start_time desc';
    
    return {
      query: query,
      labels: ['Date', label]
    }
  }
  
  var getInQueueQuery = function(startTime, endTime, clientId) {
    return buildActiveQuery(startTime, endTime, clientId, 
      'CRAWL_REQUESTED', 'Queueing');
  }
  
  var getInCrawlQuery = function(startTime, endTime, clientId) {
    return buildActiveQuery(startTime, endTime, clientId, 
      'CRAWL_STARTED', 'Crawling');
  }
  
  var getInKeywordQuery = function(startTime, endTime, clientId) {
    return buildActiveQuery(startTime, endTime, clientId, 
      'KEYWORD_REQUESTED', 'Querying');
  }
  
  var getInAuditQuery = function(startTime, endTime, clientId) {
    return buildActiveQuery(startTime, endTime, clientId, 
      'PCI2_AUDIT_REQUESTED', 'Audit generating');
  }
  
  var buildActiveQuery = function(startTime, endTime, clientId, status, label) {
    startTime = dateToString(startTime);
    endTime = dateToString(endTime);
    
    var query = 'SELECT start_time, num_events_current WHERE status = "' + status + '"';
    query += ' AND start_time >= "' + startTime + '"';
    query += ' AND start_time < "' + endTime + '"';
    
    if (typeof(clientId) == 'undefined' || clientId == null || clientId == 0) {
      query += ' AND client_id IS NULL'
    } else {
      query += ' AND client_id = ' + clientId
    }
    query += ' ORDER BY start_time DESC';
    
    return {
      query: query,
      labels: ['Date', label]
    }
  }
  
  var dateToString = function(date) {
    if (typeof(date) == 'string') {
      return date;
    }
    
    return date.toString('yyyy-MM-dd HH:mm:ss');
  }
  
  var getColors = function(dt) {
    var colorList = [];
    var visCols = dt.getViewColumns();
    for (var i = 1; i < visCols.length; i++) {
      colorList[i-1] = getColorForColIndex(visCols[i]);
    }

    return colorList;
  }
  
  /**
   * Get the color for a given index.
   */
  var getColorForColIndex = function(colIndex) {
    colIndex = colIndex - 1;
    if (colIndex < 0 || colIndex >= colors.length) {
      return 'black';
    }
    
    return colors[colIndex];
  }
  
  var getChartOptions = function(dt) {
    var c = getColors(dt);
    if (c.length == 0) {
      c = ['black'];
    }
    
    return {
      legend: 'none',
      lineWidth: 1,
      vAxis: {
        minValue: 0
      },
      colors: c
    }
  }
  
  /**
   * Search for a value in a given array. Uses binary
   * search so it is assumed the given array is sorted.
   *
   * @return boolean True if the array contains the value.
   */
  var contains = function (sortedArray, val) {
    var mid = 0;
    var low = 0;
    var high = sortedArray.length;
    while (high >= low) {
      
      mid = Math.floor(low + (high - low) / 2);
      if (sortedArray[mid] == val) {
        return true;
      }
      
      if (sortedArray[mid] < val) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    
    return false;
  }
  
  /**
   * Create the chart visualization. This method kicks off a number things
   * including the actual queries to get the data from the server, the generation
   * of the visualization and the generation of a legend.
   *
   * @param Date start The lower bound of the data range (inclusive)
   * @param Date end The upper bound of the data range (exclusive)
   * @param Boolean showTrend True if the trend line is being shown.
   * @param Boolean showActive True if the active data is being shown.
   * @param Boolean maintainCols True if same columns should be hidden.
   */
  $.fn.cs2chart = function(start, end, clientId, showTrend, showActive, maintainCols) {
    $('#chart-container').addClass('loading');

    // Instantiate graph
    graph = new google.visualization.LineChart(this[0]);
    var el = this;
    
    query(start, end, clientId, showTrend, showActive, function(dataTable) {
      $('#chart-container').removeClass('loading');
      
      if (dataTable.getNumberOfRows() == 0) {
        var message = $('<span>').text('No data found.');
        el.empty().append(message);
        return;
      }
      
      $('#chart').removeClass('placeholder');
      
      var dataView = new google.visualization.DataView(dataTable);
      el.append($('#legend').legend(dataView, graph, !showTrend, showActive, maintainCols));
      
      dataView.setColumns(displayedColumns);
      graph.draw(dataView, getChartOptions(dataView));
    });
  }
  
  $.fn.legend = function(dataView, graph, isCumulative, isActive, maintainCols) {
    var labels = [];
    var sums   = [];
    
    var summedDataview = dataView;
    if (!isCumulative && !isActive) {
      summedDataview = new google.visualization.DataView(summate(dataView.toDataTable()));
    }

    // re-index number of cols to display, if necessary
    if (!maintainCols) {
      n = summedDataview.getNumberOfColumns();
      displayedColumns = [];
      while (n--) { displayedColumns[n] = n; }
      displayedColumns.sort();
    }
    
    for (var i = 1; i < summedDataview.getNumberOfColumns(); i++) {
      labels[labels.length] = summedDataview.getColumnLabel(i);
      sums[sums.length] = summedDataview.getValue(dataView.getNumberOfRows() - 1, i);
    }
    
    this.empty();
    
    var ul = $('<ul>');
    for (var i = 0; i < labels.length; i++) {
      var li = $('<li>');
      addCheckbox(li, i + 1, dataView, graph);
      
      var sum = sums[i];
      if (sum == null) {
        sum = 0;
      } else {
        sum = $.formatNumber(sum, {format: '#,###'});
      }
      li.append($('<span>').addClass('sum').text(sum));
      
      ul.append(li);
    }
    
    this.append($('<span>').addClass('heading').text('Display:'));
    this.append(ul);
  }
  
  var addCheckbox = function(el, columnIndex, dataView, graph) {
    var label = dataView.getColumnLabel(columnIndex);
    
    el.append($('<input>').attr({
      id: 'status-cb-' + columnIndex,
      type: 'checkbox',
      checked: contains(displayedColumns, columnIndex)
    }).change(function(event) {
      if ($(this).attr('checked')) {
        displayedColumns[displayedColumns.length] = columnIndex;
        dataView.setColumns(displayedColumns);
      } else {
        
        dataView.hideColumns([columnIndex]);
        var temp = [];
        for (var i = 0; i < displayedColumns.length; i++) {
          if (displayedColumns[i] != columnIndex) {
            temp[temp.length] = displayedColumns[i];
          }
        }
        
        displayedColumns = temp;
      }
      
      graph.draw(dataView, getChartOptions(dataView));
    })).append($('<label>').attr({
      'for': 'status-cb-' + columnIndex
    }).text(label).attr('style', 'color: ' + getColorForColIndex(columnIndex)));
  }
})(jQuery);

var initialize = function() {
  var selected     = null;
  var showTrend    = true;
  var showActive   = true;
  var startDate    = null;
  var endDate      = null;
  var clientId     = null;
  var maintainCols = false; // If visible cols should be maintained or reset
  
  var onTimeRangeChange = function(start, end, event) {
    if (selected == event.target) {
      return;
    }
    
    selected = event.target;
    startDate = start;
    endDate = end;
    refresh();
  };
  
  var refresh = function() {
    $('#chart').cs2chart(startDate, endDate, clientId, showTrend, showActive, maintainCols);
    maintainCols = true;
  }
  
  $('#day').click(function(event) {
    onTimeRangeChange(new Date().addDays(-1), new Date(), event);
  });
  
  $('#week').click(function(event) {
   onTimeRangeChange(new Date().addDays(-7), new Date(), event);
  });
  
  $('#month').click(function(event) {
    onTimeRangeChange(new Date().addDays(-30), new Date(), event);
  });
  
  $('#year').click(function(event) {
   onTimeRangeChange(new Date().addDays(-365), new Date(), event);
  });
  
  // Create button sets from designated choices.
  $('.choice').buttonset();
  $('.choice-column').colbuttonset();

  var activeToggle = $('#active-choice');
  var completedToggle = $('#completed-choice');
  
  var trendToggle = $('#trend-choice');
  var cumulativeToggle = $('#cumulative-choice');
  
  activeToggle.click(function(event) {
    showActive = true;
    maintainCols = false;
    trendToggle.attr('checked', 'checked');
    trendToggle.click();
    cumulativeToggle.button('disable');
    cumulativeToggle.button('refresh');
  });
  
  completedToggle.click(function(event) {
    showActive = false;
    maintainCols = false;
    cumulativeToggle.button('enable');
    refresh();
  });
  
  trendToggle.click(function(event) {
    showTrend = true;
    refresh();
  });
  
  cumulativeToggle.click(function(event) {
    showTrend = false;
    refresh();
  });
  
  $('#day').click();
  cumulativeToggle.button('disable');
  
  $('#organization_id').change(function(event, ui) {
    clientId = $('#organization_id').val();
    refresh();
  });

  // Refresh every minute.
  setInterval(refresh, 1000 * 60);
}

// Load the Visualization API and the piechart package.
google.load('visualization', '1', { 'packages': ['corechart'] });

// Set a callback to run when the Google Visualization API is loaded.
google.setOnLoadCallback(initialize);

$(document).ready(function() {
  $('#organization_id').combobox();
  
  $('#stats').dataTable({
    bJQueryUI: true,
    bSort: false,
    bPaginate: false,
    bFilter: false,
    bLengthChange: false,
    bInfo: false
  });
});