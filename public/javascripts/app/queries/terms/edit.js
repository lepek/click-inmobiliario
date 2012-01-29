$(document).ready(function() {
  var origLangs = $("#languages-hidden select");
  $.data(document.body, 'origLangs', origLangs);

  $("input#term_categories").autoSuggest(PATHS.categories_search, {
    selectedValuesProp: "id", 
    startText: "",
    asHtmlID: "categories",
    preFill: TERM_CATEGORIES,
    resultsHighlight: false,
    keyDelay: 0
  });

  var updateLanguages = function() {
    var selectedLangs = [];
    var baseLangList = $.data(document.body, 'origLangs').clone();

    // find selected languages
    $(".translation-language select").each(function() {
      selectedLangs.push($(this).val());
    });

    // remove selected languages from each select element
    $("#term-translations li").each(function() {
      var selectedVal = ($(this).index() != 0) ? $(this).find('select').val() : 'en';
      $(this).find('select').remove();
      var langList = baseLangList.clone();

      // remove, but leave 'prompt' and selected options
      $(langList).find('option').each(function() {
        if ($.inArray($(this).attr('value'), selectedLangs) > -1
          && $(this).attr('value') != ""
          && $(this).attr('value') != selectedVal) {
          $(this).remove();
        }
      });

      if ($(this).attr("id") != "en") {
        $(this).find('.translation-language').html(langList);
        if (selectedVal) {
          $(this).find('select').val(selectedVal);
        }
      }

      var input  = $(this).find('input');
      var select = $(this).find('select');
      select.attr('name', 'term[languages][' + selectedVal + ']');
      select.attr('id', 'term_languages_' + selectedVal);
      input.attr('name', 'term[translations][' + selectedVal + ']');
      input.attr('id', 'term_translations_' + selectedVal);
    });
  }

  var toggleDeleteButtons = function(parent) {
    var deleteButtons = parent.children('button.delete');
    if (parent.length == 1) {
      deleteButtons.hide();
    } else {
      deleteButtons.show();
      $(deleteButtons.get(0)).hide();
    }
    styleDeleteButtons();
  };

  var updateTranslations = function() {
    var termTranslations = $('#term-translations li');
    toggleDeleteButtons(termTranslations);
  }
  
  $('#queries_term_indexType').live('change', function() {
    toggleLanguageSelect();
  });
  
  var toggleLanguageSelect = function() {
    if ($("#queries_term_indexType").val() == "4") { // language
      $(".translation-language select").show();
      $(".translation-language span").hide();
    } else if ($("#queries_term_indexType").val()) {
      $(".translation-language select").hide();
      $(".translation-language span").show();
      $(".translation-language span").html(
        $("#queries_term_indexType option:selected").text().charAt(0).toUpperCase()
        + $("#queries_term_indexType option:selected").text().slice(1)
      );
    }
  }

  $('#translation-add button.add').click('click', function() {
    var last = $('#term-translations li').get(-1);
    var clone = $(last).clone();

    clone.hide();
    clone.insertAfter(last);
    clone.slideDown('fast');

    clone.removeAttr('id');
    clone.find('input').val('').removeAttr('name').removeAttr('id').attr('disabled', 'disabled');
    clone.find('select').val('').removeAttr('name').removeAttr('id');
    
    updateLanguages();
    updateTranslations();
  });

  $('.term-translation button.delete').live('click', function() {
    $(this).parent('li').remove();
    updateLanguages();
    updateTranslations();
  });

  $('.term-translation select').live('change', function() {
    $(this).attr('name', 'term[languages][' + $(this).val() + ']');
    $(this).attr('id', 'term_languages_' + $(this).val());
    $(this).closest('li').attr('id', $(this).val());
    $(this).closest('li').find('input').attr('name', 'term[translations][' + $(this).val() + ']');
    $(this).closest('li').find('input').attr('id', 'term_languages_' + $(this).val());
    if ($(this).val() == '') {
      $(this).closest('li').find('input').attr('disabled', 'disabled');
    } else {
      $(this).closest('li').find('input').removeAttr('disabled');
    }
  });

  // Disable unused language selects, otherwise the empty values
  // can errors with Rack::Utils::normalize_params
  $('.edit_queries_term').submit(function() {
    $(".translation-language select").each(function() {
      if ($(this).val() == '') {
        $(this).attr('disabled', 'disabled');
      }
    });
  });
  
  toggleLanguageSelect();
  //updateLanguages();
  updateTranslations();
  styleAllButtons();
});