(function($) {

	$.fn.replaceholder = function(options) {

		var $placeholder;

		(this.length > 0) ? $this = $(this) : $this = $('input[placeholder]');
		return $this.each(function() {

			settings = jQuery.extend(options);

			var $placeholder = $(this);

			if ($placeholder.length > 0) {

				var attrPh = $placeholder.attr('placeholder');

				$placeholder.attr('value', attrPh);
				$placeholder.bind('focus', function() {

					var $this = $(this);

					if($this.val() === attrPh)
						$this.val('').removeClass('placeholder');

				}).bind('blur', function() {

					var $this = $(this);

					if($this.val() === '')
						$this.val(attrPh).addClass('placeholder');

				});

			}

		});

	};

})(jQuery);

jQuery(function($){
  $(document).ready(function(){
    if (!Modernizr.input.placeholder) { $("input[placeholder], textarea[placeholder]").replaceholder() }
  })
})
