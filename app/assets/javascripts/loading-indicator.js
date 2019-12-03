App.LoadingIndicator = {
  show() {
    return this.element().show();
  },

  hide() {
    return this.element().hide();
  },

  element() {
    return $('#loading').presence() || $('body').prepend(this.html);
  },

  html: "<div id='loading'><div><i class='icon-spinner icon-spin icon-4x'></i></div></div>"
};
