$(document).ready(function() {
  $('body').data("categoryData", null);
  $('body').data("termData", null);
  
  var showWarning = function() {
    if ($('.warning-message').is(":hidden") && 
        match.isReady() === true && 
        notmatch.isReady() === true) {
      $('.warning-message').animate({ opacity: 0, top: "+=15px" }, 0);
      $(".warning-message").show().animate({ opacity: 1, top: "-=15px" }, 800);
    }
  }
  
  // Closures for setting isReady booleans for 
  // match and notmatch autosuggest areas
  var match = (function() {
    var ready = false;
    return {
      setIsReady: function() {
        ready = true;
      },
      isReady: function() {
        return ready;
      }
    }
  })();
  
  var notmatch = (function() {
    var ready = false;
    return {
      setIsReady: function() {
        ready = true;
      },
      isReady: function() {
        return ready;
      }
    }
  })();

  DATA_TYPES = {
    category: "category",
    term: "term"
  }

  $("input[name=matching]").autoSuggest(PATHS.queries_search, {
    selectedValuesProp: "id", 
    startText: "",
    asHtmlID: "matching",
    preFill: QUERY_MATCH,
    resultsHighlight: false,
    keyDelay: 0,
    neverSubmit: true,
    formatList: function(data, elem) {
      innerspan = $("<span></span>")
              .text(data.type)
              .addClass(data.type)
              .attr("id", "query-tag");
      tag = $("<span></span>").prepend(innerspan);
      
      return elem.prepend(tag).append(data.value);
    },
    selectionAdded: function(elem, data) {
      $(elem).addClass(data.type);
      if (data.revision != data.newest_revision) {
        elem.addClass("old");
        elem.append("<span class='ui-icon ui-icon-refresh'></span>");
        if (!data.newest_revision && data.revision) {
          elem.addClass("deleted");
        }
        displayRevisionHelpText();
      }
      addSelectionData(elem, data, "matching");
      updateTermList("matching");
      showWarning();
    },
    selectionRemoved: function(elem) {
      removeSelection(elem);
    }
  });

  $("input[name=notmatching]").autoSuggest(PATHS.queries_search, {
    selectedValuesProp: "id", 
    startText: "",
    asHtmlID: "notmatching",
    preFill: QUERY_DONTMATCH,
    resultsHighlight: false,
    keyDelay: 0,
    neverSubmit: true,
    formatList: function(data, elem){
      innerspan = $("<span></span>")
              .text(data.type)
              .addClass(data.type)
              .attr("id", "query-tag");
      tag = $("<span></span>").prepend(innerspan);
      
      return elem.prepend(tag).append(data.value);
    },
    selectionAdded: function(elem, data) {
      $(elem).addClass(data.type);
      if (data.revision != data.newest_revision) {
        elem.addClass("old");
        elem.append("<span class='ui-icon ui-icon-refresh'></span>");
        if (!data.newest_revision && data.revision) {
          elem.addClass("deleted");
        }
        displayRevisionHelpText();
      }
      addSelectionData(elem, data, "notmatching");
      updateTermList("notmatching");
      showWarning();
    },
    selectionRemoved: function(elem) {
      removeSelection(elem);
    }
  });
  
  function displayRevisionHelpText() {
    if (!$("#revision-help").is(":visible")) {
      $("#revision-help").show();
    }
  }
  
  function displayRevisionHover(elem) {
    var qtip = $(elem).qtip("api");
    var elem_data = $(elem).data('selection_data');
    var current_value = (elem_data.text != '') ? elem_data.text : '[null]'
    var deletedMsg = "This item has been deleted. Clicking on the item will delete it from the query.  This term will automatically be removed from future versions of this query.";
    var html = '';

    if (elem.hasClass("deleted")) {
      html = deletedMsg;
      qtip.updateContent(html);
      $(elem).data('qtip-updated', true);
      return;
    }
    
    var successCallback = function(result) {
                             var new_value = '';
                             if (elem_data.type == 'term') {
                               new_value = result.translations[0].value;
                             }else  {
                               new_value = result.text
                             }
                             html = compareRevisionHtml(current_value, new_value);
                             qtip.updateContent(html);
                             $(elem).data('qtip-updated', true);
    };
    var errorCallback = function(jqXHR, textStatus, errorThrown) {
                             // in case it wasn't caught that it is deleted before
                             if (jqXHR.status == 404) {
                               html = deletedMsg;
                               $(elem).addClass("deleted");
                             }else {
                               html = "An unknown error has occurred fetching this item.";
                             }
                             qtip.updateContent(html);
                             $(elem).data('qtip-updated', true);
    };
 

    if (!$(elem).data('qtip-updated')) {
      var url = "";
      if (elem_data.type == 'term') {
        url = PATHS.terms + "/" + elem_data.id + '.js'
      }else {
        url = PATHS.categories + "/" + elem_data.id + '.js'
      } 
      $.ajax({
        url: url,
        dataType: "json",
        success: successCallback,
        error: errorCallback
      });
    }   
  }
  
  function compareRevisionHtml(old_value, new_value) {
    var html = '';
    if ((old_value.length > 200) || (new_value.length > 200)) {
      html = 'The terms in this category have changed.';
    }
    else {
      html = ["<span class='label'>This version:</span>",
                "<code>", old_value, "</code>",
                "<span class='divider'></span>",
                "<span class='label'>Latest version:</span>",
                "<code>", new_value, "</code>"].join('');
    }
    html += ["<div class='update'>",
             "Click<span class='ui-icon ui-icon-refresh'></span>below to update",
             "</div>"].join('');
    return html;
  }
  
  $('.as-selection-item.old').live('mouseover', function(){
    displayRevisionHover($(this));
  });
  
  $('.as-selection-item.old').each(function(){
    $(this).qtip({
       content: 'loading...',
       show: { 
         effect: { type: 'grow' },
         when: { event: 'mouseover' }
       },
       hide: 'mouseout',
       position: {
         corner: {
            target: 'topMiddle',
            tooltip: 'bottomMiddle'
         },
         adjust: { y: 3 }
       },
       style: { tip: 'bottomMiddle' }
    });
  })
  
  $('.as-selection-item.old').live('click', function() {
    if ($(this).hasClass("deleted")) {
      removeSelection($(this));
      return;
    }
    $(this).qtip("hide");
    $(this).qtip("disable");
    
    $(this).removeClass("old");
    $(this).find("span").remove();
    $("#" + $(this).data('hidden_id')).remove();
    
    var selection_data = $(this).data("selection_data");
    selection_data.revision = selection_data.newest_revision
    addSelectionData(this, selection_data, $(this).data('match_type'));
    
    var that = this;
    if (selection_data.type == 'term') {
      $.get(PATHS.terms + "/" + selection_data.id + '.js', function(result) {
        var new_value = result.translations[0].value;
        selection_data.text = new_value;
        updateTermList($(that).data('match_type'));
      }, "json");
    } else {
      $.get(PATHS.categories + "/" + selection_data.id + '.js', function(result) {
        var new_value = result.text;
        selection_data.text = new_value;
        updateTermList($(that).data('match_type'));
      }, "json");
    }

    if ($(".as-selection-item.old").length == 0) {
      $("#revision-help").hide();
    }
  });
  
  $("#update-all").click(function(){
    $('.as-selection-item.old').trigger('click');
  });
  

  function addSelectionData(elem, selectionData, matchType) {
    $(elem).data('hidden_id', selectionData.type + '_' + matchType + '_' + selectionData.id);
    $(elem).data('selection_data', selectionData);
    $(elem).data('match_type', matchType);

    for (key in DATA_TYPES) {
      if (selectionData.type == DATA_TYPES[key]) {
        data = getData(matchType, DATA_TYPES[key]);
        data[selectionData.id] = selectionData;
        $('body').data(matchType + DATA_TYPES[key], data);
        var hidden_input = generateHiddenInput(selectionData, matchType);
        $("#selections").append(hidden_input);
      }
    }
  }
  
  /** 
   * Method to generate hidden input fields for category
   * and term selecions.  Produces:
   *  <input type="hidden" name="term-match[#termId#][#revision#]" value="The Term" />
   *  <input type="hidden" name="category-match[#categoryId#][#revision#]" value="The Category" />
   *  etc ...
   */
  function generateHiddenInput(selectionData, matchType) {
    return [
      '<input',
      ' type="hidden"',
      ' id="', selectionData.type, '_', matchType, '_', selectionData.id, '"',
      ' name="', selectionData.type, '_', matchType, '[', selectionData.id, '][', selectionData.revision,']"',
      ' value="', selectionData.value, '"',
      ' />'
    ].join("");
  }

  function removeSelection(elem) {
    deleteData(elem)
    if ($(elem).hasClass('old')) { 
      $(elem).qtip("hide");
      $(elem).qtip("disable");
    };
    $("#" + elem.data('hidden_id')).remove();
    $("#" + elem.data('hidden_id') + ".container").remove();
    $(elem).remove();
    if ($(".as-selection-item.old").length == 0) {
      $("#revision-help").hide();
    }
  }

  function deleteData(elem) {
    var selection_data = $(elem).data('selection_data');
    var match_type = $(elem).data('match_type');
    delete $('body').data(match_type + selection_data.type)[selection_data.id];
  }

  function updateTermList(matchType) {
    $('#query-preview').show();
    htmlString = (matchType == "matching") ? "<span class='label'>Matching</span>" 
                                           : "<span class='label'>Not matching</span>";
    $("#query-" + matchType).html(htmlString);
    var categoryData = getData(matchType, DATA_TYPES.category);
    var termData = getData(matchType, DATA_TYPES.term);
        
    queryObject = mergeObjects(categoryData, termData);
    queryArray = [];
    
    for (var key in queryObject) {
      var text = (queryObject[key].text != '') ? queryObject[key].text : '[null]'
      var containerId = queryObject[key].type + '_' + matchType + '_' + queryObject[key].id;
      queryArray.push('<span class="container" id="' + containerId + '">'
                    + '<table cellpadding="0" cellspacing="0"><tr><td>'
                    + '<span class="type ' + queryObject[key].type + '">' 
                    + queryObject[key].value + '</span></td><td>'
                    + '<code>' + text + '</code>'
                    + '</table></td></tr>'
                    + '</span>');
    }
    
    printString = '<div>' + queryArray.join('') + '</div>';
    $("#query-" + matchType).append(printString);
  }

  function getData(matchType, dataType) {
    data = $('body').data(matchType + dataType);
    if (data == null) {
      data = {};
    }
    return data;
  }

  function mergeObjects(obj1,obj2){
      var obj3 = {};
      for (attrname in obj1) { obj3[attrname] = obj1[attrname]; }
      for (attrname in obj2) { obj3[attrname] = obj2[attrname]; }
      return obj3;
  }
  
  $('button.change').click(function(){
    $("#queries-wrapper").slideToggle();
    $("div#query").slideToggle();
  })

  match.setIsReady();
  notmatch.setIsReady();

  $("#legend li.category").click(function(){
    window.location = PATHS.new_category
  });
  
  $("#legend li.term").click(function(){
    window.location = PATHS.new_term
  });
  
  $("#revision-dropdown").click(function(e){
    e.preventDefault();
    e.stopPropagation();
    $("#revision-list").toggle();
    // $("#revision-dropdown .ui-icon").toggleClass('ui-icon-triangle-1-s');
    // $("#revision-dropdown .ui-icon").toggleClass('ui-icon-triangle-1-n');
  });
  
  $("html").click(function(e){
    if ($("#revision-list").is(":visible")) {
      $("#revision-list").hide();
    }
  });
  
  $('button.run').button({ icons: { primary: 'ui-icon-circle-triangle-e' } });
  $('button.change').button({ icons: { primary: 'ui-icon-transferthick-e-w' } });
  
  var modalWindow = (function() {
    var trigger = true;
    return {
      preventTrigger: function() {
        trigger = false;
      },
      canTrigger: function() {
        return trigger;
      }
    }
  })();
  
  $("button.copy").live('click',function(e){
    e.preventDefault();
    if (modalWindow.canTrigger()) {
      showModalDialog();
    }
  });

  // Create 'save as' modal window
  var showModalDialog = function() {
    var modal, input, dialog,
        dialogText = "Save as:",
        inputName  = "query[name]";

    // destroy previous modal
    destroyModal();
    
    modal = $(['<div id="modal">',
               '<p><label for="' + inputName + '">', dialogText, '</label>',
               '<input type="hidden" name="submit_action" value="copy" />',
               '</div>'].join("\n"));
                   
    input = $('<input></input>')
              .attr({
                'type': 'text', 
                'value': $("#query-name").text().trim() + " copy",
                'id': 'query-name-input',
                'name': inputName
              })
              .css('width', 450)
              .addClass(inputName)
              .addClass('required');
                  
    $(modal).find("label").append(input);
    $("body").append(modal);
    $('body').data('modal', modal); 
    
    // must be called after input is written to DOM
    $(modal).find("label").fieldHint({ 'hideOnFocus': false });
    $(modal).find("input#query-name-input").select();
    
    // init dialog
    $(modal).dialog({
      title:       "Save query as...",
      dialogClass: "save-as-modal",
      modal:       true,
      resizable:   false,
      draggable:   false,
      height:      220,
      width:       500,
      autoOpen:    false,
      buttons: [
        {
          text: 'Cancel',
          id: 'cancel',
          click: function() {
            destroyModal();
            return;
          }
        }, {
          text: 'Save',
          id: 'save',
          click: function() {
            modalWindow.preventTrigger();
            $("#query-form").append($("div#modal").clone().hide());
            $("#query-form").submit();
            return;
          }
        }
      ],
      close: function(event, ui) {
        destroyModal();
      }
    });

    // Handle 'Return' keypress in modal input field
    $(input).keypress(function(event) {
      if (event.keyCode == '13') {
        event.preventDefault();
        $(".save-as-modal :button#continue").trigger('click'); // jquery-ui
        destroyModal();
      }
    });

    // display dialog
    $(modal).dialog('open');
  };
  
  var destroyModal = function() {
    var modal = $('body').data('modal');
    $(modal).remove();
    $('body').removeData('modal');
  }
});
