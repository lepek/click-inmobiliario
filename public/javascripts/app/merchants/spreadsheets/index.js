// Capitalizes a string, by uppercasing the first character.
String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.substr(1);
};

// Formats an integer with commas
function addCommas(nStr) {
  nStr += '';
  x = nStr.split('.');
  x1 = x[0];
  x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',' + '$2');
  }
  return x1 + x2;
}

// A hidden column--used for the spreadsheet identifier, for instance.
var hiddenColumn = {
  bVisible: false,
  bSearchable: false
};

// A smaller column for displaying a single-word action status
var actionColumn = {
  sWidth: "75px",
  fnRender: function(object) {
    return object.aData[object.iDataColumn].capitalize();
  }
};

var fileSourceColumn = {
  sWidth: "75px",
  fnRender: function(object) {
    return object.aData[object.iDataColumn].capitalize();
  }
};

// A column for displaying the spreadsheet status, with a hold icon
var statusColumn = {
  sWidth: "75px",
  fnRender: function(object) {
    var onHold = object.aData[object.iDataColumn-1];
    var holdIcon = "";
    if (onHold == "true") {
      holdIcon = ' <span class="ui-icon ui-icon-locked" title="On Hold"></span>';
    }
    return object.aData[object.iDataColumn].capitalize() + holdIcon;
  }
};

// A column for displaying the spreadsheet status, with a hold icon
var rowsColumn = {
  bSearchable: false,
  sWidth: "50px",
  fnRender: function(object) {
    return addCommas(object.aData[object.iDataColumn]);
  }
};

// A column for displaying a name
var nameColumn = {
  sWidth: "110px"
};

// A date column, which formats an incoming date appropriately.
var dateColumn = {
  bSearchable: false,
  bUseRendered: false,
  sWidth: "40px",
  fnRender: function(object) {
    var dateString = object.aData[object.iDataColumn];
    var trimmedString = dateString.slice(0, dateString.indexOf('.'))
    var date = new Date.parseExact(trimmedString, 'yyyy-MM-ddTHH:mm:ss');
    if (date != null) {
      return date.toString('MM/dd/yy');
    } else {
      return null;
    }
  }
}

$(document).ready(function() {
  // Set up the data table.
  $('#spreadsheets-list-table').dataTable({
    sAjaxSource: spreadsheetsUrl,
    bJQueryUI: true,
    sPaginationType: 'full_numbers',
    aLengthMenu: [10, 25],
    bProcessing: true,

    /* Prevent data tables from adding a cache-busting timestamp to each call */
    "fnServerData": function ( sSource, aoData, fnCallback ) {
        /* Add some data to send to the source, and send as 'POST' */
        aoData.push( { "name": "data_type", "value": "json" } );
        $.ajax( {
            "dataType": 'json',
            "type": "GET",
            "url": sSource,
            "data": aoData,
            "success": fnCallback
        } );
    },
    fnRowCallback: function(element, data, index) {
      $(element).click(function() {
        window.location = spreadsheetsUrl + '/' + data[0];
      });
      return element;
    },
    aoColumns: [
      hiddenColumn, // Spreadsheet ID
      hiddenColumn, // Organization ID
      nameColumn, // Organization Name
      null, // Project Name
      actionColumn, // File Action
      fileSourceColumn, // File Source
      hiddenColumn, // Hold Status
      statusColumn, // Status
      rowsColumn, // Number of Rows in Spreadsheet
      nameColumn, // Assigned To
      dateColumn // Date Uploaded
    ],
    aaSorting: [[7, 'desc']] // Date Uploaded
  });
  
  // Set up the cascading drop-downs.  When organization is selected,
  // projects are updated.
  var forms = ['spreadsheet', 'export'];
  for (var i = 0; i < forms.length; i++) {
    var defaultPrompt = 'Select a project...';
    if (forms[i] == "export") {
      defaultPrompt = "All Projects";
    }
    var organizationElementId = '#' + forms[i] + '_organization_id';
    $(organizationElementId).selectChain({
      param: 'organization',
      target: $('#'+forms[i]+'_project_id'),
      url: projectsUrl,
      data: { ajax: true, for_select: true },
      prompt: defaultPrompt,
      error: redirectToLoginOn401Error
    }).trigger('change');
  }
  
  // Perform some minimal form validation for uploaded spreadsheets.
  $('#new_merchants_spreadsheet').submit(function() {
    var required = [
      $('#spreadsheet_organization_id').val(),
      $('#spreadsheet_project_id').val(),
      $('#spreadsheet_file_action').val(),
      $('#spreadsheet_file').val() ];
    
    for (var i = 0; i < required.length; i++) {
      if (required[i] == '') {
        // This is a crappy way to notify users.
        alert('All fields are required.');
        return false;
      }
    }
    
    return true;
  });
  
  // Set up the data picker for the export date range.
  var dates = $('#export_date_from, #export_date_to').datepicker({
    defaultDate: '+1w',
    changeMonth: true,
    changeYear: true,
    onSelect: function(selectedDate) {
      var option = (this.id == 'export_date_from') ? 'minDate' : 'maxDate';
      var instance = $(this).data('datepicker');
      var dateFormat = instance.settings.dateFormat || $.datepicker._defaults.dateFormat;
      var date = $.datepicker.parseDate(dateFormat, selectedDate, instance.settings);
      dates.not(this).datepicker('option', option, date);
    }
  });
});
