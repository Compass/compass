function changeTheme(theme, setCookie) {
  el = $('html');

  if (!theme) theme = el.hasClass('dark') ? 'light': 'dark';
  else if (el.hasClass(theme)) return;

  el.removeClass('light');
  el.removeClass('dark');
  el.addClass(theme);
  setThemePreference(theme);
}

function changeSyntax(style, setCookie){
  el = $('html');
  el.removeClass('scss'); el.removeClass('sass');
  el.addClass(style);
  setStyleSyntaxPreference(style);
}

function changeExampleStyleSyntax(style, setCookie){
  el = $('html');
  el.removeClass('scss'); el.removeClass('sass'); el.removeClass('css');
  el.addClass(style);
  setExampleStyleSyntaxPreference(style);
}

function changeExampleMarkupSyntax(markup){
  el = $('html');
  el.removeClass('haml'); el.removeClass('html');
  el.addClass(markup);
  setExampleMarkupSyntaxPreference(markup);
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
    changeTheme(theme, false);
  } else {
    changeTheme(defaultTheme, true);
  }
}

function setStyleSyntaxPreference (mainSyntax) {
  $.cookie("compass-syntax", null);
  $.cookie("compass-syntax", mainSyntax, { expires: 60 * 60 * 24 * 365 * 10, path: '/' });
}

function setExampleStyleSyntaxPreference (exampleStyle) {
  $.cookie("compass-example-style", null);
  $.cookie("compass-example-style", exampleStyle, { expires: 60 * 60 * 24 * 365 * 10, path: '/' });
}

function setExampleMarkupSyntaxPreference (exampleMarkup) {
  $.cookie("compass-example-markup", null);
  $.cookie("compass-example-markup", exampleMarkup, { expires: 60 * 60 * 24 * 365 * 10, path: '/' });
}

function getSyntaxPreference(defaultSyntax, defaultMarkup) {
  mainSyntaxCookie = $.cookie("compass-syntax");
  mainSyntax = (mainSyntaxCookie) ? mainSyntaxCookie : defaultSyntax;
  changeSyntax(mainSyntax);

  // add example styling preferences
  if ($('body').hasClass('demo')){
    markupCookie = $.cookie("compass-example-markup");
    styleCookie = $.cookie("compass-example-style");

    markup = (markupCookie) ? markupCookie : defaultMarkup;
    style = (styleCookie) ? styleCookie : defaultSyntax;

    changeExampleStyleSyntax(style)
    changeExampleMarkupSyntax(markup);
  }
}


getThemePreference('dark');

$('document').ready(function(){
  getSyntaxPreference('scss', 'html');

  $('#page').click(function(event){
    var target = $(event.target);

    // Set Main Syntax Preference
    if (target.parent().is('#syntax_pref')) {
      changeSyntax(target.attr("rel"), true);
      event.preventDefault();

    // Set Demo page syntax preferences
    } else if (target.parent().is('.syntax_pref')) {
      event.preventDefault();
      if (target.parent().parent().is('#markup')) {
        changeExampleMarkupSyntax(target.attr("rel"), true);
      } else {
        changeExampleStyleSyntax(target.attr("rel"), true);
      }

    // Set Theme preference
    } else if (target.is('#theme_pref') || target.parent().is('#theme_pref')) {
      changeTheme();
      event.preventDefault();

    // View source for mixins & functions
    } else if (target.attr("rel") == "view source") {
      $(target.attr("href")).toggle();
      event.preventDefault();
    }
  });
});
