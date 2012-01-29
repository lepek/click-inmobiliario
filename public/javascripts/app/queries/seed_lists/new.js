$(document).ready(function() {
  if ($('#create_type_text').is(':checked')) {
    $("#form-text").show();
    $("#form-client-project").hide();
    $("#form-upload").hide();
  } else if ($('#create_type_upload').is(':checked')) {
    $("#form-text").hide();
    $("#form-upload").show();
    $("#form-client-project").hide();
  } else if ($('#create_type_client_project').is(':checked')) {
    $("#form-text").hide();
    $("#form-client-project").show();
    $("#form-upload").hide();
  }
  
  $("#create_type_text").click(function() {
    $("#form-text").show();
    $("#form-client-project").hide();
    $("#form-upload").hide();
  });
  
  $("#create_type_upload").click(function() {
    $("#form-text").hide();
    $("#form-upload").show();
    $("#form-client-project").hide();
  });

  $("#create_type_client_project").click(function() {
    $("#form-text").hide();
    $("#form-client-project").show();
    $("#form-upload").hide();
  });  
});