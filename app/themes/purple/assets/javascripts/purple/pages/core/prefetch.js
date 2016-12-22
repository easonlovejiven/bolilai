$(function () {
    if (!$weimall || !$weimall.server.perform_caching || $.browser.msie && $.browser.version < 8) return;
    $(document).on('mouseenter', 'a.prefetch, .prefetch a', function () {
        if (/:\/\//.test($(this).attr('href')) && !(new RegExp('://' + document.domain + '/')).test($(this).attr('href'))) return;
        if ($.grep($(document).data('prefetch_list') || [], $.proxy(function (t) {
                return t == $(this).attr('href');
            }, this)).length) return true;
        if ($(this).data('prefetch_mouseleave')) {
            clearTimeout($(this).data('prefetch_mouseleave'));
            $(this).data('prefetch_mouseleave', null);
        }
        if ($(this).data('prefetch_mouseenter') || $(this).data('prefetch_done') || $('body').hasClass('loading')) return;
        $(this).data('prefetch_mouseenter', setTimeout($.proxy(function () {
            if ($.grep($(document).data('prefetch_list') || [], $.proxy(function (t) {
                    return t == $(this).attr('href');
                }, this)).length) return true;
            if ($(this).attr('href')) $.ajax({url: $(this).attr('href')});
            // $(this).data('prefetch_done', true);
            $(document).data('prefetch_list', ($(document).data('prefetch_list') || []).concat([$(this).attr('href')]));
        }, this), 500));
    }).on('mouseleave', 'a.prefetch, .prefetch a', function () {
        if (/:\/\//.test($(this).attr('href')) && !(new RegExp('://' + document.domain + '/')).test($(this).attr('href'))) return;
        if ($.grep($(document).data('prefetch_list') || [], $.proxy(function (t) {
                return t == $(this).attr('href');
            }, this)).length) return true;
        if (!$(this).data('prefetch_mouseenter') || $(this).data('prefetch_mouseleave') || $(this).data('prefetch_done')) return;
        $(this).data('prefetch_mouseleave', setTimeout($.proxy(function () {
            clearTimeout($(this).data('prefetch_mouseenter'));
            $(this).data('prefetch_mouseenter', null);
        }, this), 100));
    });
});
