(function($) {
  /**
   * Utilities for manipulating screenshot uploads 
   * 
   * @param {String} data Data uri of uploaded screenshot
   * @param {String} url Screenshot url
   * @author svanhess
   */
  Screenshot = function(data, url) {
    this.url  = url;
    this.data = data;    
  };
  
  // default thumbnail dimensions
  Screenshot.thumb = {
    TALL: "100% 200px",
    WIDE: "200px 100%",
    POSITION: "center"
  }
  
  // Screenshot constants
  Screenshot.prototype.thumb  = [];
  Screenshot.prototype.height = null;
  Screenshot.prototype.width  = null;
  Screenshot.prototype.fancyImage = [];
  
  // current count of screenshot elements
  Screenshot.prototype.count = function() { return $('.new-thumb').length; }
    
  // Thumbnail creation
  Screenshot.prototype.addThumbnail = function() {    
    this.thumb = $([
        '<div id="screenshot-container">',
        '<a class="new-thumb" rel="thumb">',
        '<div class="thumb-url">',
        '<div class="thumb-url-spacer">',
        '<span id="thumb-url-inner">', this.url, '</span>',
        '</div>', '</div>', '</a>',
        '<a class="thumb-delete"></a>',
        '</div>'].join("\n"));

    // Add image data URI to thumbnail container
    var uri = ["url(\"", this.data, "\")"].join('');
  
    $(this.thumb).children('.new-thumb').css({
      'background-image': uri,
      'background-repeat': 'no-repeat'
    });
  
    dropzone = $('body').data('dropzone')
    $(this.thumb).insertAfter(dropzone);
    
    return this;  
  };

  // Add screenshot to fancybox gallery
  Screenshot.prototype.addFancyImage = function() {
    var screenshot  = this,
        hiddenImage = new Image();
  
    $(hiddenImage)
      .attr('src', this.data)
      .css('display', 'none');
            
    $(hiddenImage).load(function() {
      var hiddenHeight = this.height, // avoiding confusion
          hiddenWidth  = this.width;
      screenshot.updateDimensions(hiddenHeight, hiddenWidth);

      screenshot.createFancyImage();
      screenshot.updateThumbSize();
      screenshot.updateGallery();    
    });
  
    $("body").append(hiddenImage);
    
    this.addHiddenFields();
    return this;
  };

  /**
   * Update screenshot dimensions
   * @param {String} height
   * @param {String} width
   */
  Screenshot.prototype.updateDimensions = function(height, width) {
    this.height = height;
    this.width  = width;
    return this;
  };
  
  /**
   * Create fancybox image.
   * Used as content source for addToGallery()
   */
  Screenshot.prototype.createFancyImage = function() {
    this.fancyImage = new Image();
    
    $(this.fancyImage)
      .attr('src', this.data)
      .css({
        'display': 'block',
        'max-width': this.width,
        'width': 800,
        'max-height': this.height
      });
    return this;
  };
  
  // Update thumbnail size based on dimensions of full screenshot
  Screenshot.prototype.updateThumbSize = function() {    
    var backgroundSize = Screenshot.thumb.TALL,
        backgroundPosition = Screenshot.thumb.POSITION;
    
    if (this.width > this.height) {
      backgroundSize = Screenshot.thumb.WIDE;
    }
    
    $(this.thumb).children('.new-thumb')
      .css({
        'background-size': backgroundSize,
        '-moz-background-size': backgroundSize,
        '-webkit-background-size': backgroundSize,
        'background-position': backgroundPosition
      });
    return this;
  };
  
  /**
   * Create fancybox gallery.
   * Exposed function to be used on initial page load
   */
  Screenshot.createGallery = function(elem) {
    if (!elem) return;
    
    $(elem).fancybox({
      autoScale: false,
      autoDimensions: true,
      href: $(elem).attr('imagepath')
    });
    
    $('body').data('fancyimages', elem);
  }
  
  // Add screenshot to fancybox gallery
  Screenshot.prototype.updateGallery = function() {    
    var fancyImages = $('body').data('fancyImages') || [],
        screenshot = this,
        newImage = $(this.thumb).children('.new-thumb');
        
    fancyImages.push(newImage);
    
    // remove references to old gallery images
    $('body').removeData('fancyimages');
    
    $(fancyImages).each(function() {
      image = $(this)
      if ($(image).attr('imagepath')) {
        $(image).fancybox({
          autoScale: false,
          autoDimensions: true,
          href: $(image).attr('imagepath')
        });
      } else {
        screenshot
        $(image).fancybox({
          type: 'html',
          autoScale: false,
          autoDimensions: true,
          content: screenshot.fancyImage
        });
      }
      
      // add reference to new gallery images
      $('body').data('fancyimages', image);
    });
  };
  
  // Append screenshot data as hidden form elements
  Screenshot.prototype.addHiddenFields = function() {  
    var hiddenUrl = [
      '<input',
      ' type="hidden"',
      ' name="screenshots[' + this.count + '][url]"',
      ' value="' + this.url + '"',
      '>'
    ].join('');
  
    var hiddenData = [
      '<input',
      ' type="hidden"',
      ' name="screenshots[' + this.count + '][data]"',
      ' value="' + escape(this.data.replace("data:image/png;base64,","")) + '"',
      '>'
    ].join('');
  
    $(hiddenUrl).insertAfter(this.thumb);
    $(hiddenData).insertAfter(this.thumb);
  };
})(jQuery);