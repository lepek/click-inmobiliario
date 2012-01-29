$(document).ready(function() {

  // Handle section click
  $('fieldset.inputs legend').click(function() {
    fancyToggle($(this));
  });

  // On section click, toggle visibility of link and inputs
  var fancyToggle = function(legend) {
    (fieldsVisible(legend)) ? fancyHide(legend) : fancyShow(legend);
  }

  // Shows a section
  var fancyShow = function(legend) {
    inputList = legend.next('ol');
    if (!fieldsVisible(legend)) {
      toggleLegendLink(legend);
      inputList.slideDown('fast');
      if (!inputList.hasClass('expanded')) { inputList.addClass('expanded'); }
      if (!legend.hasClass('expanded')) { legend.addClass('expanded'); }
    }
  }

  // Hides a section
  var fancyHide = function(legend) {
    inputList = legend.next('ol');
    if (fieldsVisible(legend)) {
      toggleLegendLink(legend);
      inputList.slideUp('fast', function() {
        inputList.removeClass('expanded');
        legend.removeClass('expanded');
      });
    }
  }
  
  // Toggle edit links on section click
  var toggleLegendLink = function(legend) {
    (fieldsVisible(legend)) ? $(legend).find('a').show() : $(legend).find('a').hide();
  }

  // Checks if section fields are visible
  var fieldsVisible = function(legend) {
    return $(legend).next('ol').is(':visible');
  }

  // Add section edit links on page load
  $('fieldset.inputs legend').each(function() {
    var sectionText = $(this).find('span').html();
    var linkHtml = document.createElement('a');
    $(linkHtml).html('Edit ' + sectionText);
    toggleLegendLink($(linkHtml));
    $(this).append(linkHtml);
  });

  // Buttonset for expanding/collapsing report sections
  $('#accordion-buttons').buttonset();

  // Expand all sections
  $('#accordion-all').change(function() {
    if ($(this).is(':checked')) {
      $('fieldset.inputs legend').each(function() {
        fancyShow($(this));
      });
    }
  });
  
  // Hide all sections
  $('#accordion-none').change(function() {
    if ($(this).is(':checked')) {
      $('fieldset.inputs legend').each(function() {
        fancyHide($(this));
      });
    }
  });

  // Expand incomplete
  $('#accordion-all').change(function() {
    if ($(this).is(':checked')) {
      $('fieldset.inputs legend.incomplete').each(function() {
        //fancyShow($(this));
      });
    }
  });

  // Set up wysiwyg editor(s)
  var editors = ['global_boarding_report_document_terms_and_conditions'];

  var setup_editors = function(editor_ids) {
    for (i = 0; i < editor_ids.length; i++) {
      var editor = editor_ids[i];
      var tmp = new nicEditor({
        iconsPath: '/javascripts/nicedit/nicEditorIcons.gif',
        buttonList: ['bgcolor']
      }).panelInstance(editor);

      // Need to wrap editor stuff so it can be properly floated
      divs = $('#' + editor).prevAll('div').andSelf();
      divs.addClass('editor-container');
      divs.wrapAll('<div class="editor" />');
    }
  }

  setup_editors(editors);

  // Dynamically add new multi-input form fields
  $('.multi-input-fields-add').click(function() {
    console.log(this)
    var container = $(this).parent('li');
    var rowClass = container.find("ul.multi-input-fields").length % 2 ? "even" : "odd";
    var fields = container.find("ul.multi-input-fields:first-child").clone(true);
    fields.find('input, select').val('');
    fields.addClass(rowClass).insertBefore($(this));
  });

  $(".multi-input-fields-remove").click(function() {
    $(this).parent().parent().remove();
  });

});

