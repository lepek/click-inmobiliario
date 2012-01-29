$(document).ready(function() {
  // Modify the URL validator to accept URLs without a protocol.
  jQuery.validator.addMethod('url', function(value, element) {
    return this.optional(element) || /^.+\.(.{2,4})((\?|:|\/|#).+)?$/.test(value);
  }, 'Please enter a valid URL.');
  
  var input = $('#crawl-search');
  input.validate({
    rules: {
      q: {
        required: true,
        url: true
      }
    },
    
    success: function(error) {
      $('.qtip').remove();
    },
    
    submitHandler: function(form) {
      form.submit();
    },
    
    errorPlacement: function(error, element) {
      $('.qtip').remove(); // Otherwise we get duplicates
      
      $(element).qtip({
        overwrite: false,
        content: error,
        show: {
          event: true,
          ready: true
        },
        hide: false,
        position: {
          corner: {
            target: 'bottomLeft',
            tooltip: 'topLeft'
          },
          adjust: {
            screen: true
          }
        },
        style: {
          name: 'red'
        }
      });
    }
  });
});

var setQueryUrl = function(url) {
  if (url == undefined || url == null || url == '') {
    return;
  }
  $('#crawl-search input[name="q"]').val(url);
}