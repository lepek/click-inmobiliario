$(document).ready(function() {
  $("#tabs").tabs({
    select: function() { return $(this).index($(document.location.hash)); }
  });
  $("#ad-hoc").tabs({
    select: function() { return $(this).index($(document.location.hash)); }
  }).addClass('ui-tabs-vertical ui-helper-clearfix');
  $("#query-manager").tabs({
    select: function() { return $(this).index($(document.location.hash)); }
  }).addClass('ui-tabs-vertical ui-helper-clearfix');
  
  $("ul.ui-tabs-nav a").click(function(){
    History.pushState(null,null,$(this).attr('href'));
    History.replaceState(null,null,$(this).attr('href'));
  });

  var queryManagerTab = ['queries', 'categories', 'terms', 'query-manager'];
  $.address.init(function(event) {})
   .bind('externalChange', null, function(event) {
      var tab = event.value.substr(1)
      if ($.inArray(tab, queryManagerTab) > -1) {
        $("#tabs").tabs('select', 1);
        var tabIndex = (tab != 'query-manager') ? queryManagerTab.indexOf(tab) : 0;
        $("#query-manager").tabs('select', tabIndex);
      } else {
        $("#tabs").tabs('select', 0);
      }
  });
});

function renderDate(object) {
  var dateString = object.aData[object.iDataColumn];
  var trimmedString = dateString.slice(0, dateString.indexOf('.'))
  var date = new Date.parseExact(trimmedString, 'yyyy-MM-ddTHH:mm:ss');
  return date.toString('MMM d, yyyy h:mm tt');
}