/*
 * Dynamic conditional select elements populated via Ajax
 * http://remysharp.com/2007/09/18/auto-populate-multiple-select-boxes/
 */
(function ($) {
    $.fn.selectChain = function (options) {
        var defaults = {
            key: "id",
            value: "label",
            param: this.name,
            prompt: false,
            error: function (xhr, desc, er) {
                // add whatever debug you want here.
                alert("an error occurred");
            }
        };
        
        var settings = $.extend({}, defaults, options);
        
        if (!(settings.target instanceof $)) settings.target = $(settings.target);
        
        return this.each(function () {
            var $$ = $(this);

            $$.change(function () {
                var data = null;
                if (typeof settings.data == 'string') {
                    data = settings.data + '&' + settings.param + '=' + $$.val();
                } else if (typeof settings.data == 'object') {
                    data = settings.data;
                    data[settings.param] = $$.val();
                }
                
                settings.target.empty();
                
                $.ajax({
                    url: settings.url,
                    data: data,
                    type: (settings.type || 'get'),
                    dataType: 'json',
                    success: function (j) {
                        var i = 0, o = null;
                        
                        if (settings.prompt) {
                          var prompt = {};
                          prompt[settings.key] = '';
                          prompt[settings.value] = settings.prompt;
                          j = [prompt].concat(j);
                        }
                        
                        for (i = 0; i < j.length; i++) {
                            // required to get around IE bug (http://support.microsoft.com/?scid=kb%3Ben-us%3B276228)
                            o = document.createElement("OPTION");
                            o.value = typeof j[i] == 'object' ? j[i][settings.key] : j[i];
                            o.text = typeof j[i] == 'object' ? j[i][settings.value] : j[i];
                            settings.target.get(0).options[i] = o;
                        }

			// hand control back to browser for a moment
			setTimeout(function () {
			    settings.target
                                .find('option:first')
                                .attr('selected', 'selected')
                                .parent('select')
                                .trigger('change');
			}, 0);
                    },
                    error: settings.error
                });
            });
        });
    };
})(jQuery);
