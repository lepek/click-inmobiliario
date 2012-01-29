(function($) {
  /**
   * Drag and drop functionality
   * for uploading screenshots
   * 
   * @example $("#foo").dropZone()
   * @desc Create dropzone for drag and drop uploads
   *       and attach it to the '#foo' DOM node
   * @author svanhess
   */
  $.fn.dropZone = function() {
    var innerHtml, payload
        dropzone = this,
        dropzoneText = "Drag an image file here to upload";
    
    innerHtml = $([
      '<span><div id="drag-message">',
      '<strong>Image upload</strong><br/>',
      dropzoneText,
      '</div>',
      '<div id="progress-message"></div>',
      '</span>'].join("\n"));
    
    $(dropzone).append(innerHtml);
    
    /**
     * Drag and drop listeners.
     * Events:
     *  dragstart, dragover, and dragleave:
     *    - handle styling of the dropzone.
     *  drop:
     *    - handles collection of screenshot data
     */
    $(dropzone).bind("dragstart", function(event) {
      event.dataTransfer.effectAllowed = 'any';
    }, true);

    $(dropzone).bind("dragover", function(event) {
      event.stopPropagation();
      event.preventDefault();
      $(this).addClass("hover");
    }, true);

    $(dropzone).bind("dragleave", function(event) {
      event.stopPropagation();
      event.preventDefault();
      $(this).removeClass("hover");
    }, true);

    $(dropzone).bind("drop", function(event) {
      event.stopPropagation();
      event.preventDefault();

      payload = {}
      payload.file = event.originalEvent.dataTransfer.files[0];
            
      $('body').data('fileName', payload.file.fileName);
      
      if (!payload.file || !payload.file.type.match('image/png')) {
        messageShow('File is not an image', { 'error' : true });
      } else if (payload.file.fileSize > 5242880) { // 5 MB
        messageShow('File is too big (> 5MB)', { 'error' : true });
      } else {
        showUploadDialog(payload);
      }
    }, true);
    
    // Expose dropzone target
    $('body').data('dropzone', $(this));
  };
  
  // Create drag and drop modal window
  var showUploadDialog = function(payload) {
    var modal, input, dialog,
        dropzone = getDropZone(),
        dialogText = "Enter the URL of the screenshot you are uploading:",
        modalName  = "modal",
        inputName  = "upload-screenshot-url";

    // destroy previous modal
    destroyModal();
    
    modal = $(['<div id="' + modalName + '">',
               '<form name="modal-form" id="modal-form">',
               '<p><label for="' + inputName + '" title="http://www.example.com">', dialogText, '</label>',
               '<span id="payload-filename">File: ', $('body').data('fileName'), '</span></p>',
               '</form>',
               '</div>'].join("\n"));
                   
    input = $('<input></input>')
              .attr({
                'type': 'text', 
                'value': '',
                'id': inputName,
                'name': inputName
              })
              .css('width', 450)
              .addClass(inputName)
              .addClass('required')
              .addClass('url');
    
    $(modal).find("label").append(input);
    $("body").append(modal);
    $('body').data('modal', modal); 
    
    // must be called after input is written to DOM
    $(modal).find("label").fieldHint({'hideOnFocus': false});
    
    // init dialog
    $(modal).dialog({
      title:       "Upload screenshot",
      dialogClass: "upload-modal",
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
            $(dropzone).trigger("dragleave");
            destroyModal();
            return;
          }
        }, {
          text: 'Continue',
          id: 'continue',
          click: function() {
            payload.url = input.val();
            if ($("#modal-form").validate().element(".required")) {
              $.log('heyo')
              new DragDropUpload(payload);
              destroyModal();
            }
            return;
          }
        }
      ],
      close: function(event, ui) {
        $(dropzone).trigger("dragleave");
        destroyModal();
      }
    });

    // Handle 'Return' keypress in modal input field
    $(input).keypress(function(event) {
      if (event.keyCode == '13') {
        event.preventDefault();
        console.log($(".upload-modal :button#continue"))
        $(".upload-modal :button#continue").trigger('click'); // jquery-ui
        destroyModal();
      }
    });

    // display dialog
    $(modal).dialog('open');
  };
  
  var getDropZone = function() {
    return $('body').data('dropzone') || false;
  }
  
  var getModal = function() {
    return $('body').data('modal') || false;
  }
  
  var destroyModal = function() {
    var modal = $('body').data('modal');
    $(modal).remove();
    $('body').removeData('modal');
  }
  
  /**
   * File reading functionality for drag and drop upload
   */
  DragDropUpload = function(payload) {
    this.payload = payload;    
    this.file    = payload.file;
    this.url     = payload.url;
        
    if (arguments.length) this.process();
  };

  DragDropUpload.prototype.statusBar = DragDropUpload.statusBar = function() {
    statusBar = $("#progressbar");
    if (!statusBar) {
      statusBar = $('<div id="progressbar"></div>').progressbar();
      statusBar.progressbar("value", 0);
      $(statusBar).insertAfter("#progress-message").show();
    }
    return statusBar;
  }
  
  DragDropUpload.prototype.process = function() {
    reader = this.createReader();
    reader.readAsDataURL(this.file);
  };

  DragDropUpload.prototype.createReader = function() {
    var reader = new FileReader(),
        url = this.url,
        statusBar = this.statusBar();
        
    reader.onerror = errorHandler;
    reader.onprogress = updateProgress;
    
    reader.onabort = function(event) {
      messageShow('File read cancelled');
    };

    reader.onloadstart = function(event) {
      // Starting FileReader -- Show progress
      messageInit();
    };

    reader.onloadend = function(event) {
      // Ensure that the progress bar displays 100% at the end.
      statusBar.progressbar("value", 100);

      $('#dropzone').trigger("dragleave");

      messageShow('Upload Complete');
      messageReset(500);
    };

    reader.onload = (function(theFile) {
      return function(e) {
        data = e.target.result;
        var screenshot = new Screenshot(data, url);
        screenshot.addThumbnail();
        screenshot.addFancyImage();
      };
    })(this.file);
    
    return reader;
  };
  
  DragDropUpload.prototype.reset = function() {
    $('#dropzone').trigger("dragleave");
    messageReset(delay);
  };
    
  /**
  * Methods for displaying statuses to user
  * These messages will show in the dropzone only
  */
  var uploadStarted  = false,
      uploadError    = false,
      uploadProgress = {},
      statusBar      = DragDropUpload.getStatusBar;
   
  var messageInit = function() {
    $("#drag-message").hide();
    $("#progress-message").html('0% Complete').show();
    uploadStarted = true;          
    return;
  };
  
  var messageShow = function(message, uploadError) {
    if (!uploadStarted) messageInit();
    if (uploadError) $("#progress-message").addClass('message-error');
    $("#progress-message").html(message)
  };

  var messageReset = function(delay) {
    $("#progressbar, #progress-message")
      .delay(delay)
      .fadeOut(200, function() {
        $("#drag-message").delay(200).show();
        hideStatus();
      });
  };
  
  var hideStatus = function() {
    $(statusBar).hide();
  }
    
  var errorHandler = function(event) {
    switch(event.target.error.code) {
      case event.target.error.NOT_FOUND_ERR:
        messageShow('File Not Found!');
        break;
      case event.target.error.NOT_READABLE_ERR:
        messageShow('File is not readable');
        break;
      case event.target.error.ABORT_ERR:
        break; // noop
      default:
        messageShow('An error occurred reading this file.');
    };
  };

  var updateProgress = function(event) {
    // event is an ProgressEvent.
    if (event.lengthComputable) {
      var percentLoaded = Math.round((event.loaded / event.total) * 100);
      // Increase the progress bar length.
      if (percentLoaded < 100) {
        $("#progress-message").html(percentLoaded + '% Complete');
        statusBar.progressbar("value", percentLoaded);
      }
    }
  };    
})(jQuery);
