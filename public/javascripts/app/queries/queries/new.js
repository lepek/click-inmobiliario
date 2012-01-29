$(document).ready(function() {
  $('body').data("categoryData", null);
  $('body').data("termData", null);

  DATA_TYPES = {
    category: "category",
    term: "term"
  }
  
  $("input[name=match]").autoSuggest(PATHS.queries_search, {
    selectedValuesProp: "id", 
    startText: "",
    asHtmlID: "match",
    preFill: QUERY_MATCH,
    resultsHighlight: false,
    keyDelay: 0,
    formatList: function(data, elem) {
      innerspan = $("<span></span>")
              .text(data.type)
              .addClass(data.type)
              .attr("id", "query-tag");
      tag = $("<span></span>").prepend(innerspan);
      
      return elem.prepend(tag).append(data.value);
    },
    selectionAdded: function(elem, data) {
      $(elem).addClass(data.type)
      updateData(data, "match");
      updateList("match");
    }
  });
  
  $("input[name=dontmatch]").autoSuggest(PATHS.queries_search, {
    selectedValuesProp: "id", 
    startText: "",
    asHtmlID: "dontmatch",
    preFill: QUERY_DONTMATCH,
    resultsHighlight: false,
    keyDelay: 0,
    formatList: function(data, elem){
      innerspan = $("<span></span>")
              .text(data.type)
              .addClass(data.type)
              .attr("id", "query-tag");
      tag = $("<span></span>").prepend(innerspan);
      
      return elem.prepend(tag).append(data.value);
    },
    selectionAdded: function(elem, data) {
      updateData(data, "dontmatch");
      updateList("dontmatch");
    }
  });
  
  function updateData(selectionData, matchType) {
    for (key in DATA_TYPES) {
      if (selectionData.type = DATA_TYPES[key]) {
        data = getData(matchType, DATA_TYPES[key]);
        data[selectionData.id] = selectionData;
        $('body').data(matchType + DATA_TYPES[key], data);
      }
    }
  }
  
  function updateList(matchType) {
    $('#query-preview').show();
    htmlString = (matchType == "match") ? "<span>Matching</span>&nbsp;" 
                                        : "<span>Not matching</span>&nbsp;";
    $("#query-" + matchType).html(htmlString);
    categoryData = getData(matchType, DATA_TYPES.category);
    termData = getData(matchType, DATA_TYPES.term);
    queryObject = mergeObjects(categoryData, termData);
    queryArray = [];
    for (var key in queryObject) {
      queryArray.push(queryObject[key].value);
    }
    printString = queryArray.join(', ');
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
  
  styleCalendarButtons();
});