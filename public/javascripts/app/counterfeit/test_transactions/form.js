$(document).ready(function() {
  $("input.cancel").click(function() {
    $("input[name=return_action]").val("skip");
  });
  
  $("input.done").click(function() {
    $("input[name=return_action]").val("done");
  });
  
  $("input.continue").click(function() {
    $("input[name=return_action]").val("continue");
  });
});