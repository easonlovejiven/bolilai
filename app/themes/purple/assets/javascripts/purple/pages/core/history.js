$(function () {
    $(document).on('mousedown', 'a', function (event) {
        var a = $(event.target).closest('a');
        if (event.which != 1 || (a.attr('href') || '#').match(/#/) || (/^_/.test(a.attr('target'))) || (/:\/\//.test(a.attr('href')) && !(new RegExp('://' + document.domain + '/')).test(a.attr('href')) && a.attr('target', '_blank')) || a.attr('prevent') || a.data('prevent') || a[0].onlick) return true;
        if(a.data("remote")){return false}
        window.go({target: a.data('target') || a.attr('target'), pushState: true}, '', a.attr('href'));
        return false;
    }).on('click', 'a', function (event) {
        var a = $(event.target).closest('a');
        if (event.which != ($.browser.msie && $.browser.version < 9 ? 0 : 1) || (/^_/.test(a.attr('target'))) || (/:\/\//.test(a.attr('href')) && !(new RegExp('://' + document.domain + '/')).test(a.attr('href')) && a.attr('target', '_blank'))) return true;
        return false;
    });
    $(document).bind({
        autoload: function () {
            if ($('#facebox').length && $('#facebox').css('display') != 'none') return
            if ($('body').hasClass('loading') || !(a = $('.js_more_page')).length || $(window).scrollTop() + $(window).height() < a.offset().top + a.height()) return;
            window.go($.extend({
                target: a.data('target') || a.attr('target'), scrollTo: false, callback: function () {
                    setTimeout(function () {
                        $(document).trigger('autoload');
                    }, 1);
                }
            }, a.data('options') || {}), '', a.attr('href'));
        },
        reload: function () {
            $(this).trigger('autoload');
        }
    });
    $(window).bind({
        scroll: function () {
            //if ($.browser.msie && $.browser.version < 8 && Math.random() > 0.3) return;
            //if ($(document).autoload_timer) return;
            //$(document).autoload_timer = setTimeout(function () {
            //}, 500);
            //$(document).trigger('autoload');
        },
        popstate: function (event) {
            var state = window.history.state || event.originalEvent && event.originalEvent.state;
            if (!state || window.history.ver && window.history.ver == state['ver']) return;
            window.go($.extend(state, {updateTitle: true}), '', state['url']);
        }
    });
    window.go = function (data, title, url) {
        url = url.replace(/^https?:\/\/[^\/]*/, '')
        //if (window.history.loader && window.history.loader.readyState > 0 && window.history.loader.readyState < 4) window.history.loader.abort();
        var options = $.extend({
            target: 'body',
            prerender: true,
            scrollTo: null,
            pushState: false,
            updateTitle: true,
            autoFocus: true,
            callback: function () {
            }
        }, data);
        // if ((options.target == 'body' || options.target == 'product_list') && $.browser.msie && $.browser.version <= 6) return document.location.href = url
        if (options.target == "popup") {
            $.ajax({
                url: url,
                timeout: 60000,
                beforeSend: function () {
                    $('body').addClass('loading');
                },
                complete: function () {
                    $('body').removeClass('loading');
                    setTimeout(function () {
                        $('body').removeClass('loading');
                    }, 1);
                },
                success: function (data) {
                    try {
                        var target = options['target'] || 'body';
                        var elem = $('#' + target);
                        if (data.match(/popup_window/) && !$('#popup_window_original').length && !$('#facebox #' + target).length) {
                            html = (new RegExp("div_popup_window_begin -->([\\s\\S]+)<!-- div_popup_window_end", "")).exec(data)[1];
                            $.facebox(html);
                            if (options['autoFocus'] && (input = $('#facebox input:text, #facebox textarea, #facebox select').first()) && input.is(':enabled:visible')) input.focus().select()
                            if (typeof(_gaq) != 'undefined' && _gaq) _gaq.push(['_trackPageview', url])
                            if (options['callback']) options['callback'].call();
                            return;
                        }
                        // if ($.browser.msie && $.browser.version <= 6) {
                        // 	$.__page_count = ($.__page_count || 0) + 1;
                        // 	if ($.__page_count > 10 && target == 'body') { document.location.href = url; return; }
                        // }
                        if ($('#facebox').css('display') == 'block' && !$('#facebox #' + target).length) $(document).trigger('close.facebox');
                        var html = data;
                        if (options['replace']) html = html.replace(options['replace'][0], options['replace'][1]);
                        html = (new RegExp("div_" + target + "_begin -->([\\s\\S]+)<!-- div_" + target + "_end", "")).exec(html)[1];
                        elem.html(html);
                        // if (options['autoFocus'] && (input = $('input:text, input:password, textarea, select').first()) && input.is(':enabled:visible')) input.focus().select()
                        if (options.updateTitle) document.title = (r = /<title>(.+)<\/title>/.exec(data.substring(0, 1000))) && r[1].replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"') || '珀丽莱-全球顶级时尚奢侈品在线零售商'
                        if (options['prerender'] && !($.browser.msie && $.browser.version <= 6) && (r = /<link rel="prerender" href="([^"]+)" \/><link rel="prefetch" href="([^"]+)" \/>/.exec(data.substring(0, 1000)))) setTimeout($.proxy(function () {
                            $.ajax({url: this['url']});
                        }, {url: r[1]}), 500);
                        var _top = $(window).scrollTop()
                        if (options['scrollTo'] != false && $(window).scrollTop() - $(options['scrollTo'] || elem).offset().top > 30) $.scrollTo($(options['scrollTo'] || elem), 0);
                        var top = $(window).scrollTop()
                        if (top == _top) $.scrollTo(top + (top % 2 ? -1 : 1), 0)
                        if (options['pushState'] && window.history.pushState) window.history.pushState({
                            ver: (window.history.ver = parseInt(Math.random() * 100000000)),
                            url: url
                        }, '', url);
                        if (typeof(_gaq) != 'undefined' && _gaq) _gaq.push(['_trackPageview', url])
                        if (options['callback']) options['callback'].call();
                        $(document).trigger('reload');
                    } catch (e) {
                        throw(e) // document.location = url
                    }
                },
                error: function () {
                    // document.location = url
                }
            });
        } else {
            window.location.href = url;
        }
    };
    if (window.history.replaceState) window.history.replaceState({
        ver: (window.history.ver = parseInt(Math.random() * 100000000)),
        url: (document.location.href)
    }, '', (document.location.href));
    //if (!window.history.pushState) {
    //    window.history.pushState = function (state, title, url) {
    //        //$.history.pop = false;
    //        //$.history.load('!' + url.replace(/^https?:\/\/[^\/]*/, ''))
    //    };
    //    $.history.init(function (hash) {
    //        if (!$.history.pop) {
    //            $.history.pop = true;
    //            return;
    //        }
    //        window.go({}, '', hash.replace(/^https?:\/\/[^\/]*/, '').replace(/^#?!?/, ''));
    //    }, {unescape: ":/?%=&"});
    //}
});
