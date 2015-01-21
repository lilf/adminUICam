;(function($, UI){
  $.extend($.fn, {
    ukMargin: function(){
      var ele = $(this), obj;
      if (!ele.data("stackMargin")) {
          obj = new UI.stackMargin(ele, UI.Utils.options(ele.attr("data-uk-margin")));
      }
      return this;
    }
  })
})(jQuery, jQuery.UIkit)
