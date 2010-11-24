function changeTheme(theme) {
  el = $('html');

  if (!theme) theme = el.hasClass('dark') ? 'light': 'dark';
  else if (el.hasClass(theme)) return;

  el.removeClass('light');
  el.removeClass('dark');
  el.addClass(theme);
  setThemePreference(theme);
}

function changeSyntax(syntax) {
  el = $('html');

  if (!syntax) {
    syntax = el.hasClass('scss') ? 'sass': 'scss';
  } else if (el.hasClass(syntax)) {
    return;
  }
  el.removeClass('scss');
  el.removeClass('sass');
  el.addClass(syntax);
  setSyntaxPreference(syntax);
}

function setThemePreference(theme) {
  $.cookie("compass-theme", null);
  $.cookie("compass-theme", theme, {
    expires: 60 * 60 * 24 * 365 * 10,
    path: '/'
  });
}
function getThemePreference(defaultTheme) {
  theme = $.cookie("compass-theme");
  if (theme) {
    changeTheme(theme);
  } else {
    changeTheme(defaultTheme);
  }
}
function setSyntaxPreference(syntax) {
  $.cookie("compass-syntax", null);
  $.cookie("compass-syntax", syntax, {
    expires: 60 * 60 * 24 * 365 * 10,
    path: '/'
  });
}
function getSyntaxPreference(defaultSyntax) {
  syntax = $.cookie("compass-syntax");
  if (syntax){
    changeSyntax(syntax);
  } else {
    changeSyntax(defaultSyntax);
  }
}


getThemePreference('dark');
getSyntaxPreference('scss');

$('document').ready(function(){
  $('#page').click(function(event){
    var target = $(event.target);
    if (target.parent().is('#syntax_pref')) {
      changeSyntax(target.attr("rel"));
      event.preventDefault();
    } else if (target.is('#theme_pref') || target.parent().is('#theme_pref')) {
      changeTheme();
      event.preventDefault();
    } else if (target.attr("rel") == "view source") {
      $(target.attr("href")).toggle();
      event.preventDefault();
    }
  });
});