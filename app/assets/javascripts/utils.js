$.fn.presence = function() {
  return this.exists() && this;
};

$.fn.exists = function() {
  return !!this.length;
};
