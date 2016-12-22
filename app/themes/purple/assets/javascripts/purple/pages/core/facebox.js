$(function(){
	$.facebox.settings.overlay = false;
	$.facebox.settings.loadingImage = '/';
	$.facebox.settings.closeImage = '/';
	$.facebox.settings.faceboxHtml = '<div id="facebox" style="display:none;"><div class="popup"><div class="content"></div></div></div>';
	
	$(document).bind('init.facebox', function() { 
		// $('a[rel*=facebox]').facebox();
	});
	$(document).bind('loading.facebox', function() {
		$('body').addClass('loading');
		$('#facebox .content').attr('id', 'popup_window');
	});
	$(document).bind('beforeReveal.facebox', function() {
		// $('div#facebox_overlay:nth-child(2n)').remove();
	});
	$(document).bind('reveal.facebox', function() { 
		// $('#facebox_overlay').unbind('click');
		$($.browser.msie && $.browser.version < 8 ? 'html' : 'body').css('overflow-y', 'hidden')
		if (!$('.facebox_overlay').length) $('body').append('<div class="facebox_overlay">&nbsp;</div>');
		$(document).trigger('locate.facebox');
		$(document).trigger('reload');
		$('body').removeClass('loading');
	});
	$(document).bind('close.facebox', function() { 
		$($.browser.msie && $.browser.version < 8 ? 'html' : 'body').css('overflow-y', 'scroll')
		$('.facebox_overlay').remove();
		$('#facebox .content').html('')
		setTimeout(function(){ $(document).trigger('autoload'); }, 500);
	});
	$(document).bind('locate.facebox', function() {
		if (!$('#facebox .popup').length || $('#facebox .popup').css('display') == 'none') return
		$('#facebox').css({
			left: $(window).width() / 2 - ($('#facebox .popup').width() / 2),
			top: getPageScroll()[1] + getPageHeight() / 2 - ($('#facebox .popup').height() / 2)
		});
	});
	$(window).bind('resize', function() {
		$(document).trigger('locate.facebox');
	});
	$(window).bind('scroll', function() {
		if ($.browser.msie || navigator.userAgent.match(/Mobi|iPhone|iPad|Android|Fennec/i) || !$('#facebox .popup').length || $('#facebox .popup').css('display') == 'none') return
		$(document).trigger('locate.facebox')
		// clearTimeout($(document).data().scrollEndTimer);
		// $(document).data().scrollEndTimer = setTimeout(function(){ $(document).trigger('locate.facebox'); }, 100);
	});
	$(document).on({
		mousedown: function(){
			$(document).trigger('close.facebox');
			return false;
		},
		click: function(){
			return false;
		}
	}, '#facebox .close, #facebox .js_facebox_close');
});



// getPageScroll() by quirksmode.com
function getPageScroll() {
  var xScroll, yScroll;
  if (self.pageYOffset) {
    yScroll = self.pageYOffset;
    xScroll = self.pageXOffset;
  } else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
    yScroll = document.documentElement.scrollTop;
    xScroll = document.documentElement.scrollLeft;
  } else if (document.body) {// all other Explorers
    yScroll = document.body.scrollTop;
    xScroll = document.body.scrollLeft;
  }
  return new Array(xScroll,yScroll)
}

// Adapted from getPageSize() by quirksmode.com
function getPageHeight() {
  var windowHeight
  if (self.innerHeight) {	// all except Explorer
    windowHeight = self.innerHeight;
  } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
    windowHeight = document.documentElement.clientHeight;
  } else if (document.body) { // other Explorers
    windowHeight = document.body.clientHeight;
  }
  return windowHeight
}
