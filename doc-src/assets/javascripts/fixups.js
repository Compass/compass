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