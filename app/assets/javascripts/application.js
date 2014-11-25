// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ru.js
//= require jcarousel/jquery.jcarousel
//= require jcarousel/jquery.jcarousel-autoscroll
//= require jquery.infinitescroll
//= require custom/justified
//= require_directory .

(function($) {
  $.fn.renderFormErrors = function(errors){
    this.clearPreviousErrors();
    var model = this.data('model');

    // show error messages in input form-group help-block
    $.each(errors, function(field, messages){
      if (messages.length > 0) {
          var input = $('#'+model+'_'+field);
          input.closest('.form-group').addClass('has-error').find('.help-block').html(messages.join(' & '));
      }
  });
  };

  $.fn.clearPreviousErrors = function(){
    $('.form-group.has-error', this).each(function(){
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    });
  };

  $.fn.setFadeAble = function(baseElementSelector, affectElementSelector, maxOpacity) {
    maxOpacity = typeof maxOpacity !== 'undefined' ? maxOpacity : 1;
    $(this).find(baseElementSelector).on('mouseenter', function () {
      $(this).find(affectElementSelector).fadeTo('faset', maxOpacity);
    });
    $(this).find(baseElementSelector).on('mouseleave', function(){
      $(this).find(affectElementSelector).stop().fadeOut();
    });
  };

  $.fn.jumpToHash = function(hash, offsetY) {
    var el = $(this).find(hash);
    if ( el.length ) {
      $(this).scrollTop(el.offset().top-offsetY);
      return true;
    }
    return false;
  };
}(jQuery));
