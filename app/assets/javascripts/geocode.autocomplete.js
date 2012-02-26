$(document).ready(function () {
	
	var geocoder = new google.maps.Geocoder();	
	$('.geocode_autocomplete').live('focus', function () {
  
	  $(this).autocomplete({
	    source: function(request, response) {
	      geocoder.geocode( {'address': request.term}, function(results, status) {
	        response($.map(results, function(item) {
	        		
	        		var searched_addr_componets = ['route', 'street_number', 'locality'],
	        			addr_components_to_exclude_in_input = ['locality'],
	        			found_addr = {},
	        			value = '';
	        		
	        		$.each(item.address_components, function (i,e) {
	        			if (e.types != "undefined") {
	        				if ($.inArray(e.types[0], searched_addr_componets) != -1) {
	        					found_addr[e.types[0]] = e.long_name;		
	        				} 
	        			}
	        		});
	        		$.each(searched_addr_componets, function (i,e) {
	        			if (found_addr[e] != undefined && $.inArray(e, addr_components_to_exclude_in_input) == -1) {
	        				value += found_addr[e] + ' ';
	        			}
	        		});
	          
	          return {
	            label: item.formatted_address,
	            value: $.trim(value),
	            location: found_addr.locality,
	            addr: value
	          }
	        }));
	      })
	    },
	    minLength: 2,
	    select: function (event, ui) {
	    	$("select[id*='location'] option").each(function(i,e) {
					if ($.trim(e.text.toUpperCase()) == $.trim(ui.item.location.toUpperCase())) {
						$(e).attr("selected", "selected");
					}
				});
			}
	  });
	});		
});