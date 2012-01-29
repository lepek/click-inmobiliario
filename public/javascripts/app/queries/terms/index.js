$(document).ready(function() {
  $('#terms').dataTable({
    bJQueryUI: true,
    sPaginationType: 'full_numbers',
    aoColumns: [
      {"bVisible": false, "bSearchable": false},
      {"sWidth": "45%"},
      {"sWidth": "45%",
       "fnRender": function(object) {
         var dateString = object.aData[object.iDataColumn];
         var trimmedString = dateString.slice(0, dateString.indexOf('.'))
         var date = new Date.parseExact(trimmedString, 'yyyy-MM-ddTHH:mm:ss');
         return date.toString('MMM d, yyyy h:mm tt');
       }
      },
      {"bVisible": false, "bSearchable": false},
      {"sWidth": "10%"}
    ],
  });
});