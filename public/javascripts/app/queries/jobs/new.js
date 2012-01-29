$(document).ready(function() {
  // hide/show existing/new seed list panels
  $("#queries_job_seed_list_type_existing, #queries_job_seed_list_type_new").change(function () {
    toggleSeedListType(this)
  });

  // hide/show create type panels
  $("#queries_job_create_type_text, #queries_job_create_type_upload").change(function() {
    toggleCreateType(this);
  });

  function toggleSeedListType(seedListType) {
    if ($(seedListType).val() == 'existing') {
      $("#choose-existing-seed-list").show();
      $("#new-seed-list").hide();
    } else {
      $("#choose-existing-seed-list").hide();
      $("#new-seed-list").show();
    }
  }

  function toggleCreateType(createType) {
    var val = $(createType).val();
    (val == 'text') ? $("#form-text").show() : $("#form-text").hide();
    (val == 'client') ? $("#form-client-project").show() : $("#form-client-project").hide();
    (val == 'upload') ? $("#form-upload").show() : $("#form-upload").hide();
  }

  var seedListsTable;
  seedListsTable = $("#seed-lists-table").dataTable({
    bJQueryUI: true,
    bAutoWidth: false,
    iDisplayLength: 10,
    bSort: true,
    aaSorting: [[4,'desc']],
    bFilter: true,
    bLengthChange: true,
    sPaginationType: "full_numbers",
    sAjaxSource: PATHS.seed_lists,
    bStateSave: true,
    bProcessing: true,
    bServerSide: true,
    aoColumns: [
      {"bVisible": false, "bSearchable": false},
      {"sWidth": "25%", "sClass": "first"},
      {"sWidth": "10%", "bSearchable": false, "bSortable": false},
      {"sWidth": "20%", "bSearchable": false, "bSortable": false},
      {"sWidth": "20%",
        "fnRender": function(object) { return renderDate(object); },
        "bUseRendered": false,  
        "sClass": "last",
        "bSearchable": false}
    ],
    "fnRowCallback": function(nRow, aData, iDisplayIndex) {
      if (aData[0] == rowSelected) {
        $(nRow).addClass('row-selected');
      }
      return nRow;
    },
    fnDrawCallback: function(oSettings) { 
      styleAllButtons();
      $("#seed-lists-table tbody tr.row-selected td.first")
        .prepend('<span class="ui-icon ui-icon-check"></span>');
    }
  });
  
  function renderDate(object) {
    var dateString = object.aData[object.iDataColumn];
    var date = new Date.parse(dateString);
    return date.toString('MMM d, yyyy h:mm tt');
  }

  $('#seed-lists-table tbody tr').live('click', function () {
    var aData = seedListsTable.fnGetData(this);
    $("#queries_job_seed_list_id").val(aData[0]);
    $('#seed-lists-table tbody tr').removeClass('row-selected');
    $('#seed-lists-table tbody tr td').each(function() {
      $(this).find('.ui-icon').remove();
    });
    if (rowSelected != aData[0]) {
      $(this).addClass('row-selected');
      rowSelected = aData[0];
      $(this).find('.first').prepend('<span class="ui-icon ui-icon-check"></span>');
    } else {
      rowSelected = null;
      $(this).find('.first').find('ui-icon').remove();
    }
  });
  
  $('#queries_job_do_crawl').change(function(){
      var opt = $(this).find("option:selected");
      var span = $('<span>').addClass('tester').text(opt.text());

      if (opt.text() == "yes (without date range)") {
        $(".job-date").find('select').attr('disabled', 'disabled');
      } else {
        $(".job-date").find('select').removeAttr('disabled');
      }

      span.css({
          'font-family' : opt.css('font-family'),
          'font-style'  : opt.css('font-style'),
          'font-weight' : opt.css('font-weight'),
          'font-size'   : opt.css('font-size')
      });

      $('body').append(span);
      // The 30px is for select open icon - it may vary a little per-browser
      $(this).width(span.width()+30);
      span.remove();
  });

  $(".seed-list-buttons").buttonset();
  $(".upload-type-buttons").buttonset();
  toggleSeedListType($("#queries_job_seed_list_type_existing:checked, #queries_job_seed_list_type_new:checked"))
  toggleCreateType($("#queries_job_create_type_text:checked, #queries_job_create_type_upload:checked"));
  styleCalendarButtons();
});
