$(function () {
    $(document).on({
        submit: function () {
            var val = $(this).find('input:text').val().strip()
            var url = $(this).attr('action').replace(/keyword=___/, val == '' ? '' : 'keyword=' + encodeURIComponent(val))
            window.go({pushState: true}, '', url)
            return false
        }
    }, '#product_search_form')
    $(document).on('reload', function () {
        $('.js_product_facet_field:not(.loaded)').each(function () {
            $(this).addClass('loaded');
            var list = $(this).find('.js_product_facet_list');
            if (list.height() > parseInt(list.find('a').css('line-height')) * 1.5) list.find('.js_product_facet_more').show().data('height', list.height());
            // list.removeClass('open');
            list.height(32);
        });
        if (!$('#product_facet_expand').hasClass('open')) $('#product_facet_expand_area').hide();
    });
    $(document).on({
        mousedown: function () {
            // $(this).closest('.js_product_facet_list').toggleClass('open');
            $(this).closest('.js_product_facet_list').stop(true, true).animate({height: $(this).text() == '更多' ? $(this).data('height') : 32}, 'fast');
            $(this).toggleClass('open').text($(this).text() == '更多' ? '收起' : '更多');
        }
    }, '.js_product_facet_more');
    $(document).on({
        mousedown: function () {
            $(this).closest('.js_product_facet_list_category').stop(true, true).animate({height: $(this).text() == '更多' ? $(this).data('height') : 100}, 'fast');
            $(this).toggleClass('open').text($(this).text() == '更多' ? '收起' : '更多');
        }
    }, '.js_product_facet_more_category');
    $(document).on({
        mousedown: function () {
            $('#product_facet_expand_area').slideToggle('fast', $.proxy(function () {
                $(this).toggleClass('open');
            }, this));
        }
    }, '#product_facet_expand');
    $(document).on({
        mousedown: function (event) {
            if (event.which != 1 && typeof(event.which) != 'undefined') return true;
            var dom_id = $(this).data('dom_id')
            $('#' + dom_id).stop(true, true)
            window.go({
                target: $(this).data('target'),
                replace: [(new RegExp('product_' + $(this).data('id'), 'g')), dom_id],
                updateTitle: false,
                callback: $.proxy(function () {
                    $('.js_product.large').hide().removeClass('large').addClass('small').remove('.js_product_detail').show()
                    $('#' + $(this).attr('id')).hide().removeClass('small').addClass('large').show()
                    var top = this.offset().top - getPageHeight() / 2 + $(this).height() / 2
                    $.scrollTo(top > 0 ? top : 0, 0)
                    // $(document).trigger('autoload');
                    if ($.cookie('user_id')) {
                        $.ajax({
                            type: 'post',
                            url: '/auction/hits.json',
                            data: {'hit[product_id]': $(this).data('id')}
                        })
                    }
                }, $('#' + dom_id))
            }, '', $(this).attr('href'));
        },
        mouseenter: function () {
            if ($(this).data('prefetch_pic')) return;
            $(this).data('prefetch_pic', true);
            $('<img/>').attr('src', $(this).data('pic'));
        }
    }, '.js_product_link')
    $(document).on({
        mousedown: function (event) {
            var dom_id = $(this).data('dom_id');
            if ($('#' + dom_id + '_same_box').length && $(event.target).attr('id') != '' + dom_id + '_same_link') $('#' + dom_id + '_same_link').mousedown();
            // if (!$(event.target).closest('a,video,object,embed').length) $.scrollTo($('#'+dom_id).offset().top - getPageHeight()/2 + $('#'+dom_id).height()/2, 500)
        }
    }, '.js_product_detail')
    $(document).on({
        mousedown: function () {
            var dom_id = $(this).data('dom_id');
            $('#' + dom_id).hide().removeClass('large').addClass('small').remove('.js_product_detail').fadeIn(1500)
            var top = $('#' + dom_id).offset().top - getPageHeight() / 2 + $('#' + dom_id).height() / 2
            $.scrollTo(top > 0 ? top : 0, 0)
        }
    }, '.js_product_close_button')
    $(document).on({
        mousedown: function () {
            var dom_id = $(this).data('dom_id');
            var name = $(this).data('name');
            $('#' + dom_id + '_content').stop(true, true).scrollTo('#' + dom_id + '_tabcontent_' + name, 300)
        }
    }, '.js_product_tab')
    $(document).on({
        mousedown: function () {
            var dom_id = $(this).data('dom_id');
            if ($('#' + dom_id + '_same_box').length) {
                $('#' + dom_id + '_same_box').remove();
            } else {
                $('#' + dom_id + '_same_loading').after($('#' + dom_id + '_same_loading').text());
                $('#' + dom_id + '_same_box').slideDown(100);
            }
        },
        click: function () {
            return false;
        }
    }, '.js_product_same_link')
    $(document).on({
        _scroll: function () {
            var dom_id = $(this).data('dom_id')
            var that = this
            var current = $.grep($(this).children(), function (element, index) {
                return $(element).offset().top - $(that).offset().top + $(element).height() >= 250
            })[0]
            var name = $(current).data('name')
            $('#' + dom_id + '_tab_' + name).addClass('current').siblings().removeClass('current')
            // $('#'+dom_id+'_sold').css('display', name != 'match' ? 'block' : 'none')
            $('#' + dom_id + '_image_nav').css('display', name == 'image' ? 'block' : 'none')
            if (name == 'image') {
                var offset = $('#' + dom_id + '_tabcontent_image').offset().top - $(that).offset().top + $('#' + dom_id + '_tabcontent_image').height() - 285
                if (!$.browser.msie || $.browser.version >= 9) $('#' + dom_id + '_image_nav').css('opacity', offset > 200 ? 1 : offset < 0 ? 0 : offset / 200.0)

                var index = $($.grep($('#' + dom_id + '_tabcontent_image').children(), function (element, index) {
                    return $(element).offset().top - $(that).offset().top + $(element).height() >= 250
                })[0]).data('index')
                var current = $('#' + dom_id + '_small_image_' + index)
                $('.js_' + dom_id + '_small_image.current').removeClass('current')
                current.addClass('current')
                $('#' + dom_id + '_prev_image').css('display', index == 0 ? 'none' : 'block')
                $('#' + dom_id + '_next_image').css('display', index == $('#' + dom_id + '_image_list').children().length - 1 ? 'none' : 'block')
                var offset = current.parent().parent().offset().top - current.parent().offset().top - parseInt(current.closest('ul').css('margin-top'))
                var list = $('#' + dom_id + '_image_list')
                if (list.is(':animated')) {
                }
                else if (offset < -240) list.animate({'margin-top': '-=300px'}, 200)
                else if (offset > 0) list.animate({'margin-top': '+=300px'}, 200)
            }
        }
    }, '.js_product_content')
    $(document).bind('reload', function () {
        $('.js_product_content').scroll(function () {
            $(this).trigger('_scroll')
        })
    })
    $(document).on({
        mousedown: function () {
            var dom_id = $(this).data('dom_id');
            $('.js_' + dom_id + '_small_image.current').parent().prev().children().mousedown()
        }
    }, '.js_product_prev_image')
    $(document).on({
        mousedown: function () {
            var dom_id = $(this).data('dom_id');
            $('.js_' + dom_id + '_small_image.current').parent().next().children().mousedown()
        }
    }, '.js_product_next_image')
    $(document).on({
        mousedown: function (event) {
            if (event && event.which == 3) return true
            var dom_id = $(this).data('dom_id');
            var index = $(this).data('index')
            $('#' + dom_id + '_content').stop(true, true).scrollTo('#' + dom_id + '_preview_' + index, 300)
        },
        click: function () {
            return false;
        }
    }, '.js_product_small_image')
    $(document).on({
        mousedown: function () {
            $(this).hide();
        },
        mousemove: function (event) {
            if ($.browser.msie && $.browser.version <= 6 && Math.random() * 2 < 1) return;
            $(this).css('background-position', '' + (($(this).offset().left - event.pageX) * 550 / 450) + 'px ' + (($(this).offset().top - event.pageY) * 550 / 450) + 'px');
        }
    }, '.js_product_preview_large')
    $(document).on({
        mousedown: function (event) {
            $(this).prev().css('background-image', 'url("' + $(this).prev().data('pic') + '")').css('background-position', '' + (($(this).offset().left - event.pageX) * 550 / 450) + 'px ' + (($(this).offset().top - event.pageY) * 550 / 450) + 'px').show()
        }
    }, '.js_product_preview_medium')
    $(document).on({
        mousedown: function (event) {
            if (event.which != 1) return true;
            var dom_id = $(this).data('dom_id');
            var new_dom_id = 'product_' + parseInt(Math.random() * 999999);
            var id = $(this).data('id')
            if ((a = $('.js_product[data-id=' + id + '] .js_product_link')) && a.length) {
                a.mousedown();
                return;
            }
            $('#' + dom_id).after('<div id="' + new_dom_id + '" class="list_block js_product item small" data-id="' + id + '" style="display:none;"></div>')
            window.go({
            	target: new_dom_id,
            	replace: [(new RegExp('product_'+id,'g')), new_dom_id],
            	updateTitle: false,
            	callback: $.proxy(function(){
            		$('.js_product.large').hide().removeClass('large').addClass('small').remove('.js_product_detail').show()
            		$(this).removeClass('small').addClass('large').css('display', 'inline-block')
            		var top = $(this).offset().top - getPageHeight()/2 + $(this).height()/2
            		$.scrollTo(top > 0 ? top : 0, 0)
            		$(document).trigger('autoload');
            	}, $('#'+new_dom_id)),
            	skip_location: true
            }, '', $(this).attr('href'));
        }
    }, '.js_product_relate')
    $(document).on({
        mousedown: function () {
            var dom_id = $(this).data('dom_id');
            var attribute_id = $(this).data('attribute_id');
            $('#' + dom_id + '_panel_' + attribute_id + '_expando').slideToggle(300);
            $('#' + dom_id + '_panel_' + attribute_id).toggleClass('open').toggleClass('hide');
        }
    }, '.js_product_panel_link')
    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('current') || $(this).hasClass('Missing_code')) return false;
            var dom_id = $(this).data('dom_id');
            $('#' + dom_id + '_measure_list').removeClass('stipshow');
            $('#' + dom_id + '_buynow').data('measure', $(this).data('measure'));
            $('#' + dom_id + '_measure_name').html($(this).data('measure'));
            $('.js_' + dom_id + '_measure.current').removeClass('current');
            $(this).addClass('current');
            $('#' + dom_id + '_tab_spec').mousedown();
        }
    }, '.js_product_measure')
    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return;
            var dom_id = $(this).data('dom_id');
            if ($('#' + dom_id + '_measure_list').length && !$('.js_' + dom_id + '_measure.current').length) {
                $('#' + dom_id + '_measure_list').addClass('stipshow');
                $('#' + dom_id + '_tab_spec').mousedown();
                return;
            }
            $.ajax({
                url: '/shop/trades/add_to_cart.json',
                type: 'post',
                data: {
                    _format: 'js',
                    'units[][product_id]': $(this).data('id'),
                    'units[][measure]': $(this).data('measure')
                },
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                },
                success: function () {
                    window.go({target: "popup"}, '', '/shop/trades/new');
                }
            });
        }
    }, '.js_product_buynow')
    $(document).on({
        mousedown: function () {
            window.go({
                updateTitle: false,
                callback: $.proxy(function () {
                    $('#product_help_list a:nth(' + (parseInt($(this).data('order')) - 1) + ')').mousedown();
                }, this)
            }, '', $(this).attr('href'));
        }
    }, '.js_product_help_outlink');
    $(document).on({
        mousedown: function () {
            $('#product_brands_textarea_' + $(this).data().type).after($('#product_brands_textarea_' + $(this).data().type).text()).remove()
            $('.js_product_brands_list').hide();
            $('#product_brands_list_' + $(this).data().type).show();
            $('.js_product_brands_nav.current').removeClass('current');
            $('#product_brands_nav_' + $(this).data().type).addClass('current');
            $('.js_product_brands_link.current').removeClass('current');
            $(this).addClass('current');
            $.scrollTo($('#product_brands_' + $(this).data().name).offset().top + ($('.purple_header').css('position') == 'fixed' ? -33 : 0), 500)
        }
    }, '.js_product_brands_link')
    $(document).on({
        click: function () {
            var detail = $(this).closest('.js_product_detail')
            window.open(["http://service.weibo.com/share/share.php?url=http%253A%2F%2F", document.location.host, "%2Fauction%2Fproducts%2F", detail.data('id'), "&type=6&count=1&appkey=49476465&title=", encodeURIComponent(detail.find('.title').text()), "&pic=", encodeURIComponent(detail.find('.js_product_tabcontent_image img.preview').attr('src')), "&ralateUid=1851945663&md=", (new Date()).valueOf()].join(''), '', ['toolbar=0,status=0,resizable=1,width=650,height=700,left=', (screen.width - 650) / 2, ',top=', (screen.height - 700) / 2].join(''))
            return false
        }
    }, '.product_share_weibo')
    $(document).on({
        mousedown: function () {
            var detail = $(this).closest('.js_product_detail')
            $.facebox(['<div class="share_wechat"><h3 class="wechat_title">分享到微信朋友圈<a href="#" class="close">×</a></h3><div class="wechat_body"><img class="pic" src="http://s.jiathis.com/qrcode.php?url=http%3A%2F%2F', document.location.host, '%2Fauction%2Fproducts%2F', detail.data('id'), '" onclick="$.facebox.close()" /></div><div class="wechat_tip">打开微信，点击底部的“发现”，使用 “扫一扫” 即可将网页分享到我的朋友圈。</div></div>'].join(''))
        }
    }, '.product_share_wechat')
});

//==================图片放大镜效果=====================
$(function () {
    $(".jqzoom", '#productPic').jqueryzoom({xzoom: 400, yzoom: 400});
    // pics图片区域
    var $specScroll = $(".spec-scroll", '#productPic');
    var tempLength = 0; //临时变量,当前移动的长度
    var moveNum = 2; //每次移动的数量
    var moveTime = 300; //移动速度,毫秒
    var scrollDiv = $(".items ul", $specScroll); //进行移动动画的容器
    var scrollItems = $(".items ul li", $specScroll); //移动容器里的集合
    var viewNum = 5; //设置每次显示图片的个数量
    //图片预览小图移动效果,页面加载时触发
    var moveLength = scrollItems.eq(0).width() * moveNum; //计算每次移动的长度
    var countLength = (scrollItems.length - viewNum) * scrollItems.eq(0).width(); //计算总长度,总个数*单个长度

    //鼠标经过预览图片函数
    $('ul', $specScroll).on('hover', 'img', function () {
        var $this = $(this);
        $('.jqzoom img', '#productPic').attr("src", $this.attr("bimg")).attr('jqimg', $this.attr("jqimg"));
    });

    //下一张
    $(".next", $specScroll).on("click", function () {
        if (tempLength < countLength) {
            if ((countLength - tempLength) > moveLength) {
                scrollDiv.animate({left: "-=" + moveLength + "px"}, moveTime);
                tempLength += moveLength;
            } else {
                scrollDiv.animate({left: "-=" + (countLength - tempLength) + "px"}, moveTime);
                tempLength += (countLength - tempLength);
            }
        }
    });
    //上一张
    $(".prev", $specScroll).on("click", function () {
        if (tempLength > 0) {
            if (tempLength > moveLength) {
                scrollDiv.animate({left: "+=" + moveLength + "px"}, moveTime);
                tempLength -= moveLength;
            } else {
                scrollDiv.animate({left: "+=" + tempLength + "px"}, moveTime);
                tempLength = 0;
            }
        }
    });
});
