$(function(){
  $('span.color').each(function(i,e){
   e = $(e);
   e.after('<span class="swatch" style="background-color:'+e.text()+';"></span>');
  });
  $('span.arg[data-default-value]').each(function(i,e){
    e = $(e);
    e.attr("title", "Defaults to: " + e.attr("data-default-value"))
  });
});

/*;(function()
{
	typeof(require) != 'undefined' ? SyntaxHighlighter = require('shCore').SyntaxHighlighter : null;
	function Brush(){};
	Brush.prototype	= new SyntaxHighlighter.Highlighter();
	Brush.aliases	= ['sass', 'scss', 'css', 'html'];

	SyntaxHighlighter.brushes.Sass = Brush;

	typeof(exports) != 'undefined' ? exports.Brush = Brush : null;
})();*/
