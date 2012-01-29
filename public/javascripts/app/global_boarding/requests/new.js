$(document).ready(function() {
  $("a#show-add-new-project").fancybox();

  $("a#close-fancybox").click(function() {
    $.fancybox.close();
  })
})