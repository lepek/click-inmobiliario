/* This function validates that there are no duplicates selected in the available
 * header mappings. */
function validate() {
  var headers = $('#unidentified_headers > div[class="header_block"] > select');
  var header_array = headers.toArray();

    /* We reset the colors on every validation because it is too complicated to try
     * to figure out what colors were marked and what weren't. The experience does
     * change for the user. */
  $('#unidentified_headers > div[id*="header_"]').each(
      function(i) {
          $(this).removeClass("validation_fail");
      }
  );

  var result = true;

  /* We do two loops here so that we can mark both boxes that have duplicate
   * headers selected. */
  for (var i = 0; i < header_array.length; i++) {
      var header = header_array[i];

      for (var k = 0; k < header_array.length; k++) {
          var inner = header_array[k];

          if (i != k && inner.value == header.value) {
              $(inner.parentNode).addClass("validation_fail");
              result = false;
          }
      }
  }

  return result;
}