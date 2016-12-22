$(function () {
    $(function () {
        $('.slides:not(.slided)').each(function () {
            var defaults = {
                container: 'slides_container',
                next: 'slides_next',
                prev: 'slides_prev',
                paginationClass: 'slides_pagination',
                generatePagination: false,
                generateNextPrev: false,
                effect: 'slide',
                crossfade: true,
                hoverPause: true,
                play: 5000,
                animationStart: $.proxy(function () {
                    $(this).trigger('animationStart.slides');
                }, this),
                animationComplete: $.proxy(function () {
                    $(this).trigger('animationComplete.slides');
                }, this)
            };
            $(this).addClass('slided').slides($.extend(defaults, $(this).data('options')));
        });
    });
});
