if ($.cookie('promotion_id') == '247') {
    var _adwq = _adwq || [];
    _adwq.push(['_setAccount', 'u79om']);
    _adwq.push(['_setDomainName', '.weimall.com']);
    _adwq.push(['_trackPageview']);
    var adw_script = "<script src='http://d.emarbox.com/js/adw.js?adwa=u79om'></script>";
    $('head').prepend($(adw_script));
}
$(function () {
    $(document).on({
        mousedown: function () {
            window.go({
                target: $(this).data('target')
            }, '', $(this).attr('href'));
        }
    }, '.js_trade_pagination')
    $(document).on({
        mousedown: function () {
            node = $('#trade_' + $(this).data('id'));
            node.toggleClass('open');
            if (node.hasClass('open')) $('#trade_index').scrollTo(node, 300);
        }
    }, '.js_trade_bar')
    $(document).on({
        mousedown: function (event) {
            $('.js_trade_cancel_box, .js_trade_receive_box').each(function () {
                if ($(this).css('display') == 'none' || $.contains(this, event.target)) return
                $(this).stop(true, true).slideUp(100)
            })
        }
    }, '#trade_index')
    $(document).on({
        mousedown: function () {
            var id = $(this).data('id')
            setTimeout(function () {
                $('#trade_' + id + '_cancel_box').stop(true, true).slideDown(100)
            }, 1)
        }
    }, '.js_trade_cancel_button')
    $(document).on({
        mousedown: function () {
            $('#trade_' + $(this).data('id') + '_cancel_box').slideUp(100);
        }
    }, '.js_trade_cancel_box_cancel')
    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return;
            $('#trade_' + $(this).data('id') + '_cancel_box').slideUp(100);
            $.ajax({
                url: "/shop/trades/" + $(this).data('id') + "/cancel",
                type: "put",
                data: {'_method': 'put', 'format': 'js'},
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                },
                success: function () {
                    $('.js_trade_' + $(this).data('id') + '_current_status').hide();
                    $('.js_trade_' + $(this).data('id') + '_new_status').show();
                }
            });
        }
    }, '.js_trade_cancel_box_confirm')
    $(document).on({
        mousedown: function () {
            var id = $(this).data('id')
            setTimeout(function () {
                $('#trade_' + id + '_receive_box').stop(true, true).slideDown(100)
            }, 1)
        }
    }, '.js_trade_receive_button')
    $(document).on({
        mousedown: function () {
            $('#trade_' + $(this).data('id') + '_receive_box').slideUp(100);
        }
    }, '.js_trade_receive_box_cancel')
    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return;
            $('#trade_' + $(this).data('id') + '_receive_box').slideUp(100);
            $.ajax({
                url: "/shop/trades/" + $(this).data('id') + "/receive.js",
                type: "put",
                data: {'_method': 'put', 'format': 'js'},
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                },
                success: function () {
                    $('.js_trade_' + $(this).data('id') + '_current_status').hide();
                    $('.js_trade_' + $(this).data('id') + '_new_status').show();
                    $('.js_trade_' + $(this).data('id') + '_return_button').show();
                }
            });
        }
    }, '.js_trade_receive_box_confirm')
    $(document).on({
        mousedown: function () {
            var detail = $('#trade_' + $(this).data('id') + '_delivery_detail')
            if (detail.css('display') != 'none') {
                detail.hide();
                return
            }
            detail.show()
            if ($(this).hasClass('disabled')) return;
            $.ajax({
                url: "/shop/trades/" + $(this).data('id') + '/delivery_query.json',
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                },
                success: function (data) {
                    var steps_context = '';
                    if (data.steps) {
                        $.each(data.steps, function (k, v) {
                            steps_context += '<li><div class="express_times">' + v.time + '</div>';
                            if (v.location) {
                                steps_context += '<div class="express_text">' + h(v.location) + '</div>'
                            }
                            steps_context += '<div class="express_er">' + h(v.context) + '</div></li>';
                        })
                    } else if (data.steps_context) {
                        steps_context = data.steps_context
                    }
                    $('#trade_' + $(this).data('id') + '_delivery_detail ul').html(steps_context)
                }
            });
        }
    }, '.js_trade_delivery_button')
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/\D+/g, '').substring(0, 12)
            if (val != $(this).val()) $(this).val(val)
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#unit_return_name').focus().select()
        }
    }, '#unit_return_phone')
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/\s+/g, '').substring(0, 20)
            if (val != $(this).val()) $(this).val(val)
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#unit_return_province').focus().select()
        }
    }, '#unit_return_name')
    $(document).on({
        keyup: function (event) {
            if (event.keyCode == 13) $('#unit_return_city').focus().select()
        }
    }, '#unit_return_province')
    $(document).on({
        keyup: function (event) {
            if (event.keyCode == 13) $('#unit_return_branch').focus().select()
        }
    }, '#unit_return_city')
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/\s+/g, '').substring(0, 30)
            if (val != $(this).val()) $(this).val(val)
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#unit_return_account').focus().select()
        }
    }, '#unit_return_branch')
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/\D+/g, '').substring(0, 30)
            if (val != $(this).val()) $(this).val(val)
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_unit_confirm').mousedown()
        }
    }, '#unit_return_account')
    $(document).on({
        mousedown: function () {
            $('#trade_unit_form').submit();
        },
        click: function () {
            return false
        }
    }, '#trade_unit_confirm')
    $(document).on({
        submit: function () {
            if ($(this).hasClass('disabled')) return;
            $.ajax({
                url: '/shop/units/' + $(this).data('id') + '/returning.json',
                type: 'put',
                data: $(this).serialize(),
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                    $('#trade_unit_confirm').addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                    $('#trade_unit_confirm').removeClass('disabled');
                },
                success: function (data) {
                    if (data.error) return
                    $('#trade_unit_return').hide();
                    $('#trade_unit_success').show();
                }
            });
            return false
        }
    }, '#trade_unit_form')

    $(document).on({
        mousedown: function (event) {
            $('.js_trade_new_contacts_delete_box').each(function () {
                if ($(this).css('display') == 'none' || $.contains(this, event.target)) return
                $(this).stop(true, true).slideUp(100)
            })
        }
    }, '#trade_new_contacts')
    $(document).on({
        mousedown: function () {
            var id = $(this).data('id');
            $('#trade_new_contacts_' + id).addClass('open');
            $('#trade_new_contacts_' + id + '_radio').attr('checked', true).prev().click();
        }
    }, '.js_trade_new_contacts_edit');
    $(document).on({
        mousedown: function () {
            var id = $(this).data('id')
            setTimeout(function () {
                $('#trade_new_contacts_' + id + '_delete_box').stop(true, true).slideDown(100)
            }, 1)
        }
    }, '.js_trade_new_contacts_delete');
    $(document).on({
        mousedown: function () {
            $('#trade_new_contacts_' + $(this).data('id') + '_delete_box').stop(true, true).slideUp(100)
        }
    }, '.js_trade_new_contacts_delete_cancel');
    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return;
            var id = $(this).data('id');
            $.ajax({
                url: '/shop/contacts/' + id + '.json',
                type: 'delete',
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                },
                success: function () {
                    id = $(this).data('id');
                    $('#trade_new_contacts_' + id).remove();
                    if ($('.js_trade_new_contacts_radio:checked').length == 0) {
                        $('.js_trade_new_contacts_radio').first().attr('checked', true);
                        $('.js_trade_new_contacts_radio').first().parent().find('a').click();
                    }
                }
            });
        }
    }, '.js_trade_new_contacts_delete_confirm');
    $(document).on({
        mousedown: function () {
            var id = $(this).data('id');
            $('.js_trade_new_contacts_error').hide()
            $('#trade_new_contacts select, #trade_new_contacts input:text').attr('disabled', true).data('checking', false)
            $('#trade_new_contacts_' + id + ' select, #trade_new_contacts_' + id + ' input:text').attr('disabled', false);
            $('#trade_new_contacts select, #trade_new_contacts input:text').closest('.jqTransformInputWrapper').trigger('disabledchange')
            $('#trade_new_contacts_' + id + '_province').trigger('update_options')
            setTimeout(function () {
                $('#trade_new_contacts_' + id + '_name').focus().select()
                $('#trade_new_contacts_confirm').trigger('confirm')
            }, 100)
        }
    }, '.js_trade_new_contacts_radio');
    //$(document).on({
    //    change: function () {
    //        var id = $(this).data('id');
    //        var area = $('#trade_new_contacts_' + id + '_area').val();
    //        var local = $('#trade_new_contacts_' + id + '_local').val();
    //        $('#trade_new_contacts_' + id + '_phone').val(area + local);
    //    }
    //}, '.js_trade_new_contacts_area, .js_trade_new_contacts_local');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[\s\d]+/g, '').substring(0, 20)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        keyup: function (event) {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            if (event.keyCode == 13) $('#trade_new_contacts_' + id + '_mobile').focus().select()
        }
    }, '.js_trade_new_contacts_name');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 11)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        keyup: function (event) {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            if (event.keyCode == 13) $('#trade_new_contacts_' + id + '_area').focus().select()
        }
    }, '.js_trade_new_contacts_mobile');
    $(document).on({
        input: function () {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 4)
            if (val != $(this).val()) $(this).val(val)
            $('#trade_new_contacts_' + id + '_mobile').data('checking', false);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        blur: function () {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            $('#trade_new_contacts_' + id + '_mobile').data('checking', true);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        keyup: function (event) {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            if (event.keyCode == 13) $('#trade_new_contacts_' + id + '_local').focus().select()
        }
    }, '.js_trade_new_contacts_area');
    $(document).on({
        input: function () {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 8)
            if (val != $(this).val()) $(this).val(val)
            $('#trade_new_contacts_' + id + '_mobile').data('checking', false);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        blur: function () {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            $('#trade_new_contacts_' + id + '_mobile').data('checking', true);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        keyup: function (event) {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            if (event.keyCode == 13) $('#trade_new_contacts_' + id + '_province').focus().select()
        }
    }, '.js_trade_new_contacts_local');
    $(document).on({
        change: function () {
            $(this).data('checking', false);
            $('#trade_new_contacts_confirm').trigger('confirm');
        }
    }, '.js_trade_new_contacts_province, .js_trade_new_contacts_city');
    $(document).on({
        keyup: function (event) {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            if (event.keyCode == 13) $('#trade_new_contacts_' + id + '_city').focus().select()
        }
    }, '.js_trade_new_contacts_province');
    $(document).on({
        keyup: function (event) {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            if (event.keyCode == 13) $('#trade_new_contacts_' + id + '_town').focus().select()
        }
    }, '.js_trade_new_contacts_city');
    $(document).on({
        keyup: function (event) {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            if (event.keyCode == 13) $('#trade_new_contacts_' + id + '_address').focus().select()
        }
    }, '.js_trade_new_contacts_town');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/^\s+/g, '').substring(0, 50)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        keyup: function (event) {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            if (event.keyCode == 13) $('#trade_new_contacts_' + id + '_postcode').focus().select()
        }
    }, '.js_trade_new_contacts_address');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 6)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_contacts_confirm').trigger('confirm');
        },
        keyup: function (event) {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            if (event.keyCode == 13) $('#trade_new_contacts_confirm').mousedown();
        }
    }, '.js_trade_new_contacts_postcode');
    $(document).on({
        mousedown: function () {
            $(this).data('submitting', true).trigger('confirm');
        },
        confirm: function () {
            var id = $('.js_trade_new_contacts_radio:checked').val();
            var name_valid = $('#trade_new_contacts_' + id + '_name').val() != '';
            if (name_valid) $('#trade_new_contacts_' + id + '_name_error').hide();
            if (!name_valid && $('#trade_new_contacts_' + id + '_name').data('checking')) $('#trade_new_contacts_' + id + '_name_error').show();

            var mobile_presence = $('#trade_new_contacts_' + id + '_mobile').val() != '';
            //var area_presence = $('#trade_new_contacts_' + id + '_area').val() != '';
            //var local_presence = $('#trade_new_contacts_' + id + '_local').val() != '';
            var mobile_valid = $('#trade_new_contacts_' + id + '_mobile').val().match(/^1\d{10}$/);
            //var area_valid = $('#trade_new_contacts_' + id + '_area').val().match(/^\d{3,4}$/);
            //var local_valid = $('#trade_new_contacts_' + id + '_local').val().match(/^\d{5,8}$/);
            var mobile_or_phone_valid = (!mobile_presence || mobile_presence && mobile_valid) && (mobile_presence );
            if (mobile_or_phone_valid) $('#trade_new_contacts_' + id + '_mobile_error').hide();
            if (!mobile_or_phone_valid && $('#trade_new_contacts_' + id + '_mobile').data('checking')) $('#trade_new_contacts_' + id + '_mobile_error').show();

            var province_valid = $('#trade_new_contacts_' + id + '_province').val() != '';
            var city_valid = $('#trade_new_contacts_' + id + '_city').val() != '';

            var address_valid = $('#trade_new_contacts_' + id + '_address').val() != '';
            if (address_valid) $('#trade_new_contacts_' + id + '_address_error').hide();
            if (!address_valid && $('#trade_new_contacts_' + id + '_address').data('checking')) $('#trade_new_contacts_' + id + '_address_error').show();

            var postcode_valid = $('#trade_new_contacts_' + id + '_postcode').val().match(/^\d{6}$/);
            if (postcode_valid) $('#trade_new_contacts_' + id + '_postcode_error').hide();
            if (!postcode_valid && $('#trade_new_contacts_' + id + '_postcode').data('checking')) $('#trade_new_contacts_' + id + '_postcode_error').show();

            if (name_valid && mobile_or_phone_valid && province_valid && city_valid && address_valid && postcode_valid) $(this).removeClass('disabled');
            else $(this).addClass('disabled');

            if (!$(this).data('submitting') || $(this).hasClass('disabled')) {
                $(this).data('submitting', false);
                return;
            }
            $(this).data('submitting', false);

            $('#trade_new_contact_id').val($('#trade_new_contacts_' + id + '_id').val());
            $('#trade_new_contact_name').val($('#trade_new_contacts_' + id + '_name').val());
            $('#trade_new_contact_mobile').val($('#trade_new_contacts_' + id + '_mobile').val());
            $('#trade_new_contact_phone').val($('#trade_new_contacts_' + id + '_phone').val());
            $('#trade_new_contact_province').val($('#trade_new_contacts_' + id + '_province').val());
            $('#trade_new_contact_city').val($('#trade_new_contacts_' + id + '_city').val());
            $('#trade_new_contact_town').val($('#trade_new_contacts_' + id + '_town').val());
            $('#trade_new_contact_address').val($('#trade_new_contacts_' + id + '_address').val());
            $('#trade_new_contact_postcode').val($('#trade_new_contacts_' + id + '_postcode').val());
            $('#trade_new_summary_contact_text').trigger('update');
            $('#trade_new_summary_invoice_contact_same').change();
            if ($('#trade_new_summary_phone_contact').attr('checked')) $('#trade_new_summary_phone_contact').mousedown();
            $('.js_trade_new_module').hide();
            $('#trade_new_summary').show();
        }
    }, '#trade_new_contacts_confirm');

    $(document).on({
        mousedown: function () {
            $.facebox.close();
        }
    }, '#trade_new_cart_continue')
    var locate = function (options) {
        var address_fillin, constructor, locate_btn, running, user_agent;
        constructor = {
            country_field: '#auction_trade_contact_attributes_country',
            province_field: 'select.js_contact_province',
            city_field: 'select.js_contact_city',
            town_field: 'select.js_contact_town',
            address_field: ['input.js_trade_new_contacts_address', 'input#trade_new_contact_address'],
            locate_btn: '.locate_btn',
            loader_img: 'url(/assets/core/trades/locate_loader.gif)',
            locate_img: 'url(/assets/core/trades/locate_btn.png)'
        };
        options = $.extend(constructor, options);
        if (!$(options.locate_btn).length) {
            return true;
        }
        user_agent = navigator.userAgent;
        if (!navigator.geolocation) {
            $(options.locate_btn).hide();
            return true;
        }
        running = 0;
        address_fillin = function (country, province, city, town, address, _this_btn) {
            var parent, this_address;
            if (_this_btn.attr('id') == 'trade_new_locate_btn') {
                parent = 'body';
            }
            else {
                parent = '#trade_new_contacts_' + _this_btn.attr('id') + '_edit_area';
            }
            for (var i = options.address_field.length; i--;) {
                if ($(parent).find(options.address_field[i]).length) {
                    this_address = options.address_field[i];
                    break;
                }
            }
            $(parent).find(options.country_field).val(country);
            $(parent).find(options.province_field).val(province);
            $(parent).find(options.province_field).trigger('update_options');
            $(parent).find(options.province_field).trigger('change');
            $(parent).find(options.city_field).val(city);
            $(parent).find(options.province_field).trigger('update_options');
            $(parent).find(options.city_field).trigger('change');
            $(parent).find(options.town_field).val(town);
            $(parent).find(options.town_field).trigger('change');
            return $(parent).find(this_address).val(address);
        };
        return $(options.locate_btn).on('click', function () {
            if (running) {
                return true;
            }
            var _this_btn = $(this);
            running = 1;
            _this_btn.css('background-image', options.loader_img);
            return navigator.geolocation.getCurrentPosition(function (position) {
                var lat, lng;
                lat = position.coords.latitude;
                lng = position.coords.longitude;
                return $.ajax({
                    url: "http://api.map.baidu.com/geocoder/v2/?ak=5be13fae5fb7c8badca46b98801af4f3&callback=renderReverse&location=" + lat + "," + lng + "&output=json&pois=0&coordtype=wgs84ll",
                    dataType: 'jsonp'
                })
                    .done(function (location) {
                        var address_infomation;
                        if (location.status || !location.result.formatted_address) {
                            return true
                        }
                        address_infomation = location.result.addressComponent;
                        address_fillin('中国', address_infomation.province, address_infomation.city, address_infomation.district, address_infomation.street + address_infomation.street_number, _this_btn);
                        running = 0;
                        return _this_btn.css('background-image', options.locate_img);
                    })
                    .fail(function (error) {
                        running = 0;
                        return _this_btn.css('background-image', options.locate_img);
                    });
            }, function (error) {
                running = 0;
                return _this_btn.css('background-image', options.locate_img);
            }, {
                enableHighAccuracy: true,
                timeout: 5000,
                maximumAge: 60000
            });
        });
    };
    $(document).on({
        mousedown: function () {
            if (!$.cookie('user_id')) {
                $(this).addClass('disabled');
                if (document.location.href.match(/comm\.weimall\.com/)) window.open('/core/connections/new?redirect=%2Fhome%2Fconnections%2Fpopup%2F0%3Fredirect%3D%2Fshop%2Ftrades%2Fnew&site=comm', '', 'width=526, height=450');
                else window.go({target: "popup"}, '', '/core/sessions/new?redirect=%2Fshop%2Ftrades%2Fnew');
                return;
            }
            if ($(this).hasClass('disabled')) return;
            if (!document.contact_options) {
                $.ajax({
                    url: '/shop/contacts/options.js',
                    dataType: 'text',
                    context: this,
                    beforeSend: function () {
                        $(this).addClass('disabled');
                    },
                    complete: function () {
                        $(this).removeClass('disabled');
                    },
                    success: function (data) {
                        document.contact_options = eval('(' + data + ')')
                        $(this).removeClass('disabled').mousedown();
                    }
                });
                return;
            }
            $('.js_trade_new_cart_checkbox:checked').each(function () {
                $('#trade_new_summary_unit_' + $(this).data('i')).attr('keep', 'true');
            });
            $('#trade_new_form').data('cart', $.makeArray($('.js_trade_new_summary_unit[keep!=true]').map(function () {
                return 'units[' + (999 - parseInt($(this).data('i'))) + '][product_id]=' + $('#units_' + $(this).data('i') + '_product_id').val() + '&unit[' + (999 - parseInt($(this).data('i'))) + '][measure]=' + $('#units_' + $(this).data('i') + '_measure').val()
            })).join('&'))
            $('.js_trade_new_summary_unit[keep!=true]').remove();
            $('#trade_new_cart').hide();
            $('.js_contact_province').trigger('initialize_options');
            if ($('#trade_new_contact_id').val() == '') {
                $('#trade_new_contact').show();
                $('#trade_new_contact_name').focus().select()
            }
            else {
                $('#trade_new_summary').show();
            }
            locate();
        }
    }, '#trade_new_cart_confirm');

    $(document).on({
        mousedown: function () {
            var text = $(this).text();
            $("#trade_new_whisper_style_name").val(text);
        }
    }, '#select_whisper_style a');

    $(document).on({
        mousedown: function () {
            if (!$.cookie('user_id')) {
                $(this).addClass('disabled');
                if (document.location.href.match(/comm\.weimall\.com/)) window.open('/core/connections/new?redirect=%2Fhome%2Fconnections%2Fpopup%2F0%3Fredirect%3D%2Fshop%2Ftrades%2Fnew&site=comm', '', 'width=526, height=450');
                else window.go({target: "popup"}, '', '/core/sessions/new?redirect=%2Fshop%2Ftrades%2Fnew');
                return;
            }
            $('#trade_new_cart').hide();
            $('#trade_new_whisper_style').show();
            $('#trade_new_whisper_style_name').prop('disabled', false);
        }
    }, '#trade_new_cart_whisper');

    $(document).on({
        mousedown: function () {
            $('#trade_new_whisper_style').hide();
            $('#trade_new_whisper').show();
            $("#trade_whisper_content, #trade_whisper_to, #trade_whisper_from").prop('disabled', false);

            var check_value_length, ie_input;
            check_value_length = function (length) {
                var val;
                val = $(this).val().substring(0, length || 30);
                if (val !== $(this).val()) {
                    return $(this).val(val);
                }
            };
            ie_input = function (func, length) {
                var _this = this;
                return $(this)[0].attachEvent('onpropertychange', function () {
                    return func.call(_this, length);
                });
            };
            if ($.browser.msie && $.browser.version < 9) {
                ie_input.call($('#trade_whisper_to'), check_value_length, 10);
                ie_input.call($('#trade_whisper_from'), check_value_length, 10);
                ie_input.call($('#trade_whisper_content'), check_value_length, 70);
            } else {
                $('#trade_whisper_to').live('input', function () {
                    return check_value_length.call(this, 10);
                });
                $('#trade_whisper_from').live('input', function () {
                    return check_value_length.call(this, 10);
                });
                $('#trade_whisper_content').live('input', function () {
                    return check_value_length.call(this, 70);
                });
            }
        }
    }, '#trade_new_whisper_style_confirm');

    $(document).on({
        input: function () {
            var whisper_content_val = $('#trade_whisper_content').val().strip();
            var whisper_to_val = $('#trade_whisper_to').val().strip();
            var whisper_from_val = $('#trade_whisper_from').val().strip();
            if (whisper_content_val.length > 0 && whisper_to_val.length > 0 && whisper_from_val.length > 0) $('#trade_new_whisper_confirm').removeClass('disabled');
            else $('#trade_new_whisper_confirm').addClass('disabled');
        }
    }, '#trade_whisper_content, #trade_whisper_to, #trade_whisper_from');
    $(document).on({
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_whisper_content').focus().select();
        }
    }, '#trade_whisper_to');
    $(document).on({
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_whisper_confirm').mousedown();
        }
    }, '#trade_whisper_from');

    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return;
            $('#trade_new_cart').show();
            $('#trade_new_whisper').hide();
            $('#trade_new_cart_whisper_edit_box').show();
            $('#trade_new_cart_whisper').hide();
        }
    }, '#trade_new_whisper_confirm');

    $(document).on({
        mousedown: function () {
            $('#trade_new_cart').hide();
            $('#trade_new_whisper_style').show();
        }
    }, '#trade_new_cart_whisper_edit');

    $(document).on({
        mousedown: function () {
            $("#trade_new_whisper_style_name, #trade_whisper_content, #trade_whisper_to, #trade_whisper_from").prop("disabled", true);
            $('#trade_new_cart').show();
            $('#trade_new_whisper_style').hide();
            $('#trade_new_whisper').hide();

            $('#trade_new_cart_whisper_edit_box').hide();
            $('#trade_new_cart_whisper').show();
        }
    }, '#trade_new_cart_whisper_close');

    $(document).on({
        mousedown: function () {
            $('#trade_new_cart_whisper_edit_box').hide();
            $('#trade_new_cart_whisper').show();
            $("#trade_new_whisper_style_name, #trade_whisper_content, #trade_whisper_to, #trade_whisper_from").prop("disabled", true);
        }
    }, '#trade_new_cart_whisper_delete');

    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[\s\d]+/g, '').substring(0, 20)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_mobile').focus().select()
        }
    }, '#trade_new_contact_name');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 11)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_area').focus().select()
        }
    }, '#trade_new_contact_mobile');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 4)
            if (val != $(this).val()) $(this).val(val)
            $('#trade_new_contact_mobile').data('checking', false);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        blur: function () {
            $('#trade_new_contact_mobile').data('checking', true);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_local').focus().select()
        }
    }, '#trade_new_contact_area');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 8)
            if (val != $(this).val()) $(this).val(val)
            $('#trade_new_contact_mobile').data('checking', false);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        blur: function () {
            $('#trade_new_contact_mobile').data('checking', true);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_province_init').focus().select()
        }
    }, '#trade_new_contact_local');
    $(document).on({
        change: function () {
            $(this).data('checking', false);
            $('#trade_new_contact_confirm').trigger('confirm');
        }
    }, '#trade_new_contact_province_init, #trade_new_contact_city_init');
    $(document).on({
        change: function () {
            $('#trade_new_contact_province').val($(this).val());
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_city_init').focus().select()
        }
    }, '#trade_new_contact_province_init');
    $(document).on({
        change: function () {
            $('#trade_new_contact_city').val($(this).val());
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_town_init').focus().select()
        }
    }, '#trade_new_contact_city_init');
    $(document).on({
        change: function () {
            $('#trade_new_contact_town').val($(this).val());
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_address').focus().select()
        }
    }, '#trade_new_contact_town_init');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/^\s+/g, '').substring(0, 50)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_postcode').focus().select()
        }
    }, '#trade_new_contact_address');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 6)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_contact_confirm').trigger('confirm');
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_delivery_time').focus().select()
        }
    }, '#trade_new_contact_postcode');
    $(document).on({
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_contact_confirm').mousedown();
        }
    }, '#trade_new_contact_delivery_time');
    $(document).on({
        mousedown: function () {
            $(this).data('submitting', true).trigger('confirm');
        },
        confirm: function () {

            var name_valid = $('#trade_new_contact_name').val() != '';
            if (name_valid) $('#trade_new_contact_name_error').hide();
            if (!name_valid && $('#trade_new_contact_name').data('checking')) $('#trade_new_contact_name_error').show();

            var mobile_presence = $('#trade_new_contact_mobile').val() != '';
            //var area_presence = $('#trade_new_contact_area').val() != '';
            //var local_presence = $('#trade_new_contact_local').val() != '';
            var mobile_valid = $('#trade_new_contact_mobile').val().match(/^1\d{10}$/);
            //var area_valid = $('#trade_new_contact_area').val().match(/^\d{3,4}$/);
            //var local_valid = $('#trade_new_contact_local').val().match(/^\d{5,8}$/);
            var mobile_or_phone_valid = (!mobile_presence || mobile_presence && mobile_valid) && (mobile_presence );
            if (mobile_or_phone_valid) $('#trade_new_contact_mobile_error').hide();
            if (!mobile_or_phone_valid && $('#trade_new_contact_mobile').data('checking')) $('#trade_new_contact_mobile_error').show();

            var province_valid = $('#trade_new_contact_province_init').val() != '';
            var city_valid = $('#trade_new_contact_city_init').val() != '';

            var address_valid = $('#trade_new_contact_address').val() != '';
            if (address_valid) $('#trade_new_contact_address_error').hide();
            if (!address_valid && $('#trade_new_contact_address').data('checking')) $('#trade_new_contact_address_error').show();

            var postcode_valid = $('#trade_new_contact_postcode').val().match(/^\d{6}$/);
            if (postcode_valid) $('#trade_new_contact_postcode_error').hide();
            if (!postcode_valid && $('#trade_new_contact_postcode').data('checking')) $('#trade_new_contact_postcode_error').show();

            if (name_valid && mobile_or_phone_valid && province_valid && city_valid && address_valid && postcode_valid) $(this).removeClass('disabled');
            else $(this).addClass('disabled');

            if (!$(this).data('submitting') || $(this).hasClass('disabled')) {
                $(this).data('submitting', false);
                return;
            }
            $(this).data('submitting', false);

            var id = '';
            $('#trade_new_contacts__radio').mousedown().prev().click();
            $('#trade_new_contacts_' + id + '_id').val($('#trade_new_contact_id').val());
            $('#trade_new_contacts_' + id + '_name').val($('#trade_new_contact_name').val());
            $('#trade_new_contacts_' + id + '_mobile').val($('#trade_new_contact_mobile').val());
            $('#trade_new_contacts_' + id + '_phone').val($('#trade_new_contact_phone').val());
            //$('#trade_new_contacts_' + id + '_area').val($('#trade_new_contact_area').val());
            //$('#trade_new_contacts_' + id + '_local').val($('#trade_new_contact_local').val());
            $('#trade_new_contacts_' + id + '_province').val($('#trade_new_contact_province').val());
            $('#trade_new_contacts_' + id + '_province').trigger('update_options');
            $('#trade_new_contacts_' + id + '_city').val($('#trade_new_contact_city').val());
            $('#trade_new_contacts_' + id + '_province').trigger('update_options');
            $('#trade_new_contacts_' + id + '_town').val($('#trade_new_contact_town').val());
            $('#trade_new_contacts_' + id + '_province').trigger('update_options');
            $('#trade_new_contacts_' + id + '_address').val($('#trade_new_contact_address').val());
            $('#trade_new_contacts_' + id + '_postcode').val($('#trade_new_contact_postcode').val());
            $('#trade_new_summary_contact_text').trigger('update');
            if ($('#trade_new_contact_mobile').val() != '') $('#trade_new_summary_phone_contact').click();
            $('.js_trade_new_module').hide();
            $('#trade_new_summary').show();
        }
    }, '#trade_new_contact_confirm');

    $(document).on({
        change: function () {
            var index = $(this).data('index')
            $('#trade_new_summary_discount_' + index + '_point').val('').prop('disabled', $(this).val() != '' || $('#trade_new_summary_discount_' + index + '_point option').length <= 1)
            $('#trade_new_summary_discount_' + index + '_voucher').val('').prop('disabled', $(this).val() != '' || $('#trade_new_summary_discount_' + index + '_voucher option').length <= 1)
            $('#units_' + index + '_level_percent').val($(this).val())
            $('#trade_new_summary_unit_' + index + '_price').text(parseInt(parseInt($('#trade_new_summary_unit_' + index + '_original_price').text()) * (100 - (parseInt($(this).val()) || 0)) / 100))
            $('#trade_new_summary_total_price').trigger('update')
        }
    }, '.js_trade_new_summary_discount_percent')
    $(document).on({
        change: function () {
            var index = $(this).data('index')
            $('#trade_new_summary_discount_' + index + '_percent').val('').prop('disabled', $(this).val() != '' || $('#trade_new_summary_discount_' + index + '_percent option').length <= 1)
            $('#trade_new_summary_discount_' + index + '_voucher').val('').prop('disabled', $(this).val() != '' || $('#trade_new_summary_discount_' + index + '_voucher option').length <= 1)
            $('#units_' + index + '_point_percent').val($(this).val())
            $('#trade_new_summary_unit_' + index + '_price').text(parseInt(parseInt($('#trade_new_summary_unit_' + index + '_original_price').text()) * (100 - (parseInt($(this).val()) || 0)) / 100))
            $('#trade_new_summary_total_price').trigger('update')
            var original = $('#trade_new_summary_total_point').data('original')
            $('.js_trade_new_summary_discount_point option:selected').each(function () {
                original -= (parseInt($(this).val()) || 0) * 1000
            })
            $('#trade_new_summary_total_point').text(original)
            $('.js_trade_new_summary_discount_point').each(function () {
                var current = original + (parseInt($(this).val()) || 0) * 1000
                var html = $(this).outerHTML().replace(/<option[\s\S]*$/im, '').replace(/_change_attached="true"|jQuery\d*="\d*"/im, '') + '<option value="">请选择</option>' + (current >= 5000 ? '<option value="5" ' + ($(this).val() == '5' ? 'selected="selected"' : '') + '>使用5000基因值优惠5%</option>' : '') + (current >= 10000 ? '<option value="10" ' + ($(this).val() == '10' ? 'selected="selected"' : '') + '>使用10000基因值优惠10%</option>' : '') + '</select>'
                if ($(this).outerHTML().toLowerCase() != html) $(this).after(html).remove()
            })
            $('.js_trade_new_summary_discount_point').each(function () {
                var index = $(this).data('index')
                var percent_val = $('#trade_new_summary_discount_' + index + '_percent').val()
                var voucher_val = $('#trade_new_summary_discount_' + index + '_voucher').val()
                $(this).prop('disabled', $(this).find('option').length <= 1 || percent_val && percent_val != '' || voucher_val && voucher_val != '')
            })
        }
    }, '.js_trade_new_summary_discount_point')
    $(document).on({
        change: function () {
            var index = $(this).data('index')
            $('#trade_new_summary_discount_' + index + '_percent').val('').prop('disabled', $(this).val() != '' || $('#trade_new_summary_discount_' + index + '_percent option').length <= 1)
            //$('#trade_new_summary_discount_' + index + '_point').val('').prop('disabled', $(this).val() != '' || $('#trade_new_summary_discount_' + index + '_point option').length <= 1)
            $('#units_' + index + '_voucher_id').val($(this).val())
            var discount = parseInt($('#trade_new_summary_unit_' + index + '_original_price').text()) - (parseInt($(this).find('option:selected').text().match(/\d+$/)) || 0);
            if (discount < 0) {
                discount = 0;
            }
            $('#trade_new_summary_unit_' + index + '_price').text(discount);
            $('#trade_new_summary_total_price').trigger('update')
            $('.js_trade_new_summary_discount_voucher').each(function () {
                var that = this
                var index = $(this).data('index')
                var original_price = parseInt($('#trade_new_summary_unit_' + $(this).data('index') + '_original_price').text())
                var selected = $.makeArray($('.js_trade_new_summary_discount_voucher:not(#trade_new_summary_discount_' + index + '_voucher)').map(function () {
                    return parseInt($(this).val())
                }))
                var vouchers = $('#trade_new_summary_total_point').data('vouchers')
                var html = $(this).outerHTML().replace(/<option[\s\S]*$/im, '').replace(/_change_attached="true"|jQuery\d*="\d*"/im, '') + '<option value="">请选择</option>' + $.makeArray($(vouchers).map(function () {
                        return $.inArray(this.id, selected) > -1 || parseInt((this.name.match(/^[^\d]*(\d+)/) || ['', '0'])[1]) > original_price ? '' : '<option value="' + this.id + '" ' + (parseInt($(that).val()) == this.id ? 'selected="selected"' : '') + '>' + this.name + '</option>'
                    })).join('') + '</select>'
                if ($(this).outerHTML().toLowerCase() != html) $(this).after(html).remove()
            })
            $('.js_trade_new_summary_discount_voucher').each(function () {
                var index = $(this).data('index')
                var percent_val = $('#trade_new_summary_discount_' + index + '_percent').val()
                //var point_val = $('#trade_new_summary_discount_' + index + '_point').val()
                $(this).prop('disabled', $(this).find('option').length <= 1 || percent_val && percent_val != '')
            })
        }
    }, '.js_trade_new_summary_discount_voucher')
    $(document).on({
        click: function () {
            $(this).closest('select').change()
        }
    }, '.js_trade_new_summary_discount_point option, .js_trade_new_summary_discount_voucher option')
    $(document).on({
        update: function () {
            var sum = 0
            $('.js_trade_new_summary_unit_price').each(function () {
                sum += parseInt($(this).text())
            })
            $(this).text(sum)
        }
    }, '#trade_new_summary_total_price')
    $(document).on({
        mousedown: function () {
            var index = $(this).data('index')
            setTimeout(function () {
                $('#trade_new_summary_voucher_' + index + '_box').stop(true, true).slideDown(100)
            }, 1)
        },
        click: function () {
            var index = $(this).data('index')
            $('#trade_new_summary_voucher_' + index + '_input').focus().select()
        }
    }, '.js_trade_new_summary_voucher_add')
    $(document).on({
        mousedown: function (event) {
            $('.js_trade_new_summary_voucher_box, #trade_new_summary_card_activate_area, #trade_new_summary_card_newpwbox').each(function () {
                if ($(this).css('display') == 'none' || $.contains(this, event.target)) return
                $(this).stop(true, true).slideUp(100)
            })
        }
    }, '#trade_new_summary')
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\dA-Za-z]+/g, '').substring(0, 12)
            if (val != $(this).val()) $(this).val(val)
        },
        keyup: function (event) {
            var index = $(this).data('index')
            if (event.keyCode == 13) $('#trade_new_summary_voucher_' + index + '_submit').mousedown().click()
        }
    }, '.js_trade_new_summary_voucher_input')
    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return
            var index = $(this).data('index')
            var input = $('#trade_new_summary_voucher_' + index + '_input')
            if (input.val() == '') {
                $(this).trigger('error');
                return
            }
            $.ajax({
                type: 'put',
                url: '/shop/vouchers/0.json',
                data: {'voucher[identifier]': input.val()},
                dataType: 'json',
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled')
                },
                complete: function () {
                    $(this).removeClass('disabled')
                },
                success: function (data) {
                    if (data['error']) {
                        $(this).trigger('error');
                        return
                    }
                    var index = $(this).data('index')
                    $('#trade_new_summary_voucher_' + index + '_box').hide()
                    var vouchers = $('#trade_new_summary_total_point').data('vouchers')
                    vouchers.unshift({
                        id: data.voucher.id,
                        name: '满' + data.voucher.event.limitation + '减' + data.voucher.event.amount
                    })
                    $('#trade_new_summary_total_point').data(vouchers)
                    $('#trade_new_summary_discount_' + index + '_voucher').val('').change()
                },
                error: function () {
                    $(this).trigger('error')
                }
            })
        },
        error: function () {
            var index = $(this).data('index')
            var error = $('#trade_new_summary_voucher_' + index + '_error')
            $('#trade_new_summary_voucher_' + index + '_box').hide()
            $('#trade_new_summary_voucher_' + index + '_input').val('')
            error.show()
            setTimeout($.proxy(function () {
                this.hide()
            }, error), 3000)
        }
    }, '.js_trade_new_summary_voucher_submit')
    $(document).on({
        update: function () {
            var name = h($('#trade_new_contact_name').val()) || '';
            var mobile = h($('#trade_new_contact_mobile').val()) || '';
            var phone = h($('#trade_new_contact_phone').val()) || '';
            var province = h($('#trade_new_contact_province').val()) || '';
            var city = h($('#trade_new_contact_city').val()) || '';
            var town = h($('#trade_new_contact_town').val()) || '';
            var address = h($('#trade_new_contact_address').val()) || '';
            var postcode = h($('#trade_new_contact_postcode').val()) || '';
            $('#trade_new_summary_contact_text').html('<span>' + name + '</span><span>' + mobile + ' ' + province + city + town + address + '</span><span>' + postcode + '</span>');
        }
    }, '#trade_new_summary_contact_text');
    $(document).on({
        mousedown: function () {
            $('.js_trade_new_contacts_radio:checked').trigger('mousedown');
            $('.js_trade_new_module').hide();
            $('#trade_new_contacts').show();
        }
    }, '#trade_new_summary_change_contact');
    $(document).on({
        change: function () {
            $('#trade_new_summary_delivery_time').val($(this).val());
            var v = $('#trade_new_summary_delivery_time').val();
            $('#trade_new_summary_delivery_time').parents('.select_wrapper').html($('#trade_new_summary_delivery_time').parent().html().replace(/^[\s\S]*<select/i, '<select')).find('select').removeClass('jqTransformHidden').val(v).jqTransSelect();
        }
    }, '#trade_new_contact_delivery_time');
    $(document).on({
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_summary_phone_new').prop('disabled') ? $('#trade_new_summary_comment').focus().select() : $('#trade_new_summary_phone_new').focus().select()
        }
    }, '#trade_new_summary_delivery_time');
    $(document).on({
        change: function () {
            if (!$(this).attr('checked')) return;
            $('#trade_new_summary_phone_new').attr('disabled', false).change().focus().select()
            $('#trade_new_summary_phone_new').closest('.jqTransformInputWrapper').trigger('disabledchange')
        }
    }, '#trade_new_summary_phone_other');
    $(document).on({
        change: function () {
            if (!$(this).attr('checked')) return;
            $('#trade_new_summary_phone_new').attr('disabled', true).change();
            $("#trade_delivery_phone_error").hide();
            $('#trade_new_summary_phone_new').closest('.jqTransformInputWrapper').trigger('disabledchange')
            $('#trade_new_summary_phone_field').val($('#trade_new_contact_mobile').val());
            $('#trade_new_form').submit();
        }
    }, '#trade_new_summary_phone_contact');
    $(document).on({
        change: function () {
            var mobile_valid =$(this).val().match(/^1\d{10}$/);
            if($('#trade_new_summary_phone_other').attr('checked')){
                if(!mobile_valid) {
                    $("#trade_delivery_phone_error").show();
                }else{
                    $("#trade_delivery_phone_error").hide()
                }
            }
            $('#trade_new_summary_phone_field').val($(this).val());
            $('#trade_new_form').submit();
        },
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 11)
            if (val != $(this).val()) $(this).val(val)
            $('#trade_new_form').submit();
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_summary_comment').focus().select()
        }
    }, '#trade_new_summary_phone_new');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/^\s+/g, '').substring(0, 50)
            if (val != $(this).val()) $(this).val(val)
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_summary_confirm').mousedown();
        }
    }, '#trade_new_summary_comment');
    $(document).on({
        change: function () {
            $('#trade_new_form').submit();
        }
    }, '#trade_new_summary_term');
    $(document).on({
        change: function () {
            var area = $('#trade_new_contact_area').val();
            var local = $('#trade_new_contact_local').val();
            $('#trade_new_contact_phone').val(area + local);
        }
    }, '#trade_new_contact_area, #trade_new_contact_local');
    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('open')) {
                $(this).removeClass('open');
                $('#trade_new_summary_card_activate_area').hide();
                $('#trade_new_summary_card_area, #trade_new_summary_card_newpwbox').hide();
            } else {
                $(this).addClass('open');
                $('#trade_new_summary_card_area').show();
                $('#trade_new_summary_area').scrollTo($('.cardbox'), 300);
            }
        }
    }, '#trade_new_summary_card_open')
    $(document).on({
        mousedown: function () {
            $('#trade_new_summary_card_newpwbox').find('input').val('');
            setTimeout(function () {
                $('#trade_new_summary_card_newpwbox').stop(true, true).show()
            }, 1);
        },
        click: function () {
            setTimeout(function () {
                if ($('#trade_new_summary_card_newpw_area').css('display') == 'block' && $('#trade_new_summary_card_newpwbox').css('display') == 'block') {
                    $('#trade_new_summary_card_newpw_input')[0].focus()
                }
            }, 400)
        }
    }, '#trade_new_summary_card_newpwbox_switch')
    $(document).on({
        mousedown: function () {
            $('#trade_new_summary_card_activate_area').find('input').val('');
            setTimeout(function () {
                $('#trade_new_summary_card_activate_area').stop(true, true).show();
            }, 1);
        },
        click: function () {
            setTimeout(function () {
                if ($('#trade_new_summary_card_activate_area').css('display') == 'block' && $('#trade_new_summary_card_area').css('display') == 'block') {
                    $('#trade_new_summary_card_number')[0].focus()
                }
            }, 400)
        }
    }, '#trade_new_summary_card_activate_area_switch')

    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return;
            if ($('#trade_new_summary_card_newpw_input').val() != $('#trade_new_summary_card_newpw_confirm').val()) {
                $('#trade_new_summary_card_newpw_inconsistent').fadeIn(100).delay(2000).fadeOut(100);
                return;
            }
            $.ajax({
                url: $(this).data('url'),
                type: 'put',
                dataType: 'json',
                data: {'auction_user[password]': $('#trade_new_summary_card_newpw_input').val()},
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                    $('#trade_new_summary_card_newpwbox').hide();
                    $('#trade_new_summary_card_newpw_input, #trade_new_summary_card_newpw_confirm').val('');
                },
                success: function (data) {
                    if (data.error) {
                        $('#trade_new_summary_card_newpw_error').fadeIn(100).delay(2000).fadeOut(100);
                    } else {
                        $('#trade_new_summary_card_newpw_area').remove();
                        $('#trade_new_summary_card_box, #trade_new_summary_card_inspect').show();
                    }
                },
                error: function () {
                    $('#trade_new_summary_card_newpw_error').fadeIn(100).delay(2000).fadeOut(100);
                }
            });
        }
    }, '#trade_new_summary_card_newpw')
    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return;
            $.ajax({
                url: '/shop/cards/activate.json',
                type: 'put',
                dataType: 'json',
                data: {
                    'auction_card[number]': $('#trade_new_summary_card_number').val(),
                    'auction_card[password]': $('#trade_new_summary_card_password').val()
                },
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                    $('#trade_new_summary_card_number, #trade_new_summary_card_password').val('');
                },
                success: function (data) {
                    $('#trade_new_summary_card_activate_area').hide()
                    if (data.error) {
                        $('#trade_new_summary_card_activate_error').fadeIn(100).delay(2000).fadeOut(100);
                    } else {
                        $('#trade_new_summary_card_balance').text('￥' + (data.user_balance + data.cards_balance));
                        $.ajax({
                            url: $('#trade_new_summary_card_newpw_area').data('url'),
                            type: 'get',
                            dataType: 'json',
                            success: function (data) {
                                if (data.error) {
                                    return;
                                } else {
                                    if (data.user && data.user.auction_user) {
                                        if (parseInt(data.user.auction_user.balance) + parseInt(data.user.auction_user.cards_balance) <= 0) {
                                            return;
                                        } else if (data.user.auction_user.has_password) {
                                            if ($('#trade_new_summary_card_inspect_success').css('display') != 'block') {
                                                $('#trade_new_summary_card_no_card, #trade_new_summary_card_newpw_area').hide();
                                                $('#trade_new_summary_card_inspect').show();
                                            } else {
                                                $('#trade_new_summary_card_confirm_checkbox').trigger('change');
                                            }
                                        } else {
                                            $('#trade_new_summary_card_box, #trade_new_summary_card_no_card, #trade_new_summary_card_inspect').hide();
                                            $('#trade_new_summary_card_newpw_area').show();
                                        }
                                    }
                                }
                            }
                        });
                    }
                },
                error: function () {
                    $('#trade_new_summary_card_activate_error').fadeIn(100).delay(2000).fadeOut(100);
                }
            });
        }
    }, '#trade_new_summary_card_activate')

    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return;
            $.ajax({
                url: $(this).data('url'),
                type: 'get',
                dataType: 'json',
                data: {'auction_user[password]': $('#trade_new_summary_card_inspect_password').val()},
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                },
                success: function (data) {
                    if (data.is_valid) {
                        $('#trade_new_summary_card_inspect_password').attr('name', 'auction_user[password]').prop("disabled", false);
                        $('#trade_new_summary_card_confirm_checkbox').trigger('change');
                        $('#trade_new_summary_card_inspect').hide();
                        $('#trade_new_summary_card_inspect_success').show();
                    } else {
                        $('#trade_new_summary_card_inspect_error').fadeIn(100).delay(2000).fadeOut(100);
                    }
                },
                error: function () {
                    $('#trade_new_summary_card_inspect_error').fadeIn(100).delay(2000).fadeOut(100);
                }
            });
        }
    }, '#trade_new_summary_card_inspect_btn')

    $(document).on({
        change: function () {
            if (Boolean($(this).prop('checked'))) {
                $('.js_trade_new_summary_discount_point, .js_trade_new_summary_discount_percent, .js_trade_new_summary_discount_voucher').find("option:selected[value!='']").parent().find('option:first').attr('selected', true).trigger('change');
                $('.js_trade_new_summary_discount_point, .js_trade_new_summary_discount_percent, .js_trade_new_summary_discount_voucher').prop('disabled', true);
                $('#trade_new_summary_total_price').trigger('update');
                $('#trade_new_summary_card_total').remove()
                var card_balance = parseInt($('#trade_new_summary_card_balance').text().match(/\d+/));
                var total_price = parseInt($('#trade_new_summary_total_price').text().match(/\d+/));
                if (card_balance > total_price) {
                    $('#trade_new_summary_total_price').text(0);
                } else {
                    $('#trade_new_summary_total_price').text(total_price - card_balance).before("<span id='trade_new_summary_card_total' class='card_total'><span>" + total_price + "</span><span>-</span><span>" + card_balance + "</span><span>=</span></span>");
                }
                $('#trade_new_summary_card_inspect_password').prop("disabled", false);
            } else {
                $('#trade_new_summary_total_price').trigger('update');
                $('.js_trade_new_summary_discount_point, .js_trade_new_summary_discount_percent, .js_trade_new_summary_discount_voucher').prop('disabled', false)
                $('#trade_new_summary_card_total').remove()
                $('#trade_new_summary_card_inspect_password').prop("disabled", true);
            }
        }
    }, '#trade_new_summary_card_confirm_checkbox')

    $(document).on({
        mousedown: function () {
            $(this).hide();
            $('#trade_new_summary_invoice_area').show();
            $('#trade_new_summary_area').scrollTo($('#trade_new_summary_invoice_area'), 300);
            $('.js_trade_new_summary_invoice_input[type=radio]').prop('disabled', false).attr('checked', false).change();
            $('.js_trade_new_summary_invoice_input[type=text]').val('').change();
            $('#trade_new_form').submit()
        }
    }, '#trade_new_summary_invoice_open');
    $(document).on({
        mousedown: function () {
            $('#trade_new_summary_invoice_open').show();
            $('#trade_new_summary_invoice_area').hide();
            $('.js_trade_new_summary_invoice_input[type=radio]').prop('checked', false).prop('disabled', true).change()
            $('.js_trade_new_summary_invoice_input[type=text],.js_trade_new_summary_invoice_input[type=hidden]').val('').prop('disabled', true).change().data('checking', false)
            $('.js_trade_new_summary_invoice_input[type=text]').closest('.jqTransformInputWrapper').trigger('disabledchange')
            $('#trade_new_summary_invoice_different_name_error, #trade_new_summary_invoice_different_mobile_error, #trade_new_summary_invoice_different_address_error, #trade_new_summary_invoice_different_postcode_error').hide()
            $('#trade_new_form').submit()
        }
    }, '#trade_new_summary_invoice_cancel');
    $(document).on({
        change: function () {
            if (!$(this).attr('checked')) return;
            var personal = $('#trade_new_summary_invoice_title_personal');
            var company = $('#trade_new_summary_invoice_title_company');
            company.val('').blur().attr('disabled', true);
            personal.attr('disabled', false).focus().select()
            personal.closest('.jqTransformInputWrapper').trigger('disabledchange')
            company.closest('.jqTransformInputWrapper').trigger('disabledchange')
            $('#trade_new_summary_invoice_title').attr('disabled', false).val(personal.val());
        }
    }, '#trade_new_summary_invoice_type_personal');
    $(document).on({
        change: function () {
            if (!$(this).attr('checked')) return;
            var personal = $('#trade_new_summary_invoice_title_personal');
            var company = $('#trade_new_summary_invoice_title_company');
            personal.val('').blur().attr('disabled', true);
            company.attr('disabled', false).focus().select()
            personal.closest('.jqTransformInputWrapper').trigger('disabledchange')
            company.closest('.jqTransformInputWrapper').trigger('disabledchange')
            $('#trade_new_summary_invoice_title').attr('disabled', false).val(company.val());
        }
    }, '#trade_new_summary_invoice_type_company');
    $(document).on({
        input: function () {
            var val = $(this).val().strip().substring(0, 20)
            if (val != $(this).val()) $(this).val(val)
        }
    }, '#trade_new_summary_invoice_title_personal');
    $(document).on({
        input: function () {
            var val = $(this).val().strip().substring(0, 50)
            if (val != $(this).val()) $(this).val(val)
        }
    }, '#trade_new_summary_invoice_title_company');
    $(document).on({
        change: function () {
            if (!$(this).attr('checked')) return;
            $('.js_trade_new_summary_invoice_contact_input').attr('disabled', true).data('checking', false)
            $('.js_trade_new_summary_invoice_contact_input').closest('.jqTransformInputWrapper').trigger('disabledchange')
            $('#trade_new_summary_invoice_different_name_error, #trade_new_summary_invoice_different_mobile_error, #trade_new_summary_invoice_different_address_error, #trade_new_summary_invoice_different_postcode_error').hide()
            $('#trade_new_summary_invoice_contact_id').val($('#trade_new_contact_id').val());
            $('#trade_new_summary_invoice_contact_name').val($('#trade_new_contact_name').val());
            $('#trade_new_summary_invoice_contact_mobile').val($('#trade_new_contact_mobile').val());
            $('#trade_new_summary_invoice_contact_phone').val($('#trade_new_contact_phone').val());
            $('#trade_new_summary_invoice_contact_country').val($('#trade_new_contact_country').val());
            $('#trade_new_summary_invoice_contact_province').val($('#trade_new_contact_province').val());
            $('#trade_new_summary_invoice_contact_city').val($('#trade_new_contact_city').val());
            $('#trade_new_summary_invoice_contact_town').val($('#trade_new_contact_town').val());
            $('#trade_new_summary_invoice_contact_address').val($('#trade_new_contact_address').val());
            $('#trade_new_summary_invoice_contact_postcode').val($('#trade_new_contact_postcode').val());
            $('.js_trade_new_summary_invoice_input[type=hidden]').prop('disabled', false);
            $('#trade_new_form').submit();
        }
    }, '#trade_new_summary_invoice_contact_same');
    $(document).on({
        change: function () {
            if (!$(this).attr('checked')) return;
            $('.js_trade_new_summary_invoice_contact_input').attr('disabled', false)
            $('.js_trade_new_summary_invoice_contact_input').closest('.jqTransformInputWrapper').trigger('disabledchange')
            $('#trade_new_summary_invoice_area').find('.js_contact_province').trigger('update_options');
            $('#trade_new_summary_invoice_different_name').focus().select();
            $('.js_trade_new_summary_invoice_input[type=hidden]').prop('disabled', false);
            $('#trade_new_form').submit()
        }
    }, '#trade_new_summary_invoice_contact_different');
    $(document).on({
        change: function () {
            if (!$('#trade_new_summary_invoice_contact_different').attr('checked')) return;
            $('#trade_new_summary_invoice_contact_name').val($('#trade_new_summary_invoice_different_name').val());
            $('#trade_new_summary_invoice_contact_mobile').val($('#trade_new_summary_invoice_different_mobile').val());

            //var area = $('#trade_new_summary_invoice_different_area').val();
            //var local = $('#trade_new_summary_invoice_different_local').val();
            //$('#trade_new_summary_invoice_contact_phone').val(area + local);
            $('#trade_new_summary_invoice_contact_province').val($('#trade_new_summary_invoice_different_province').val());
            $('#trade_new_summary_invoice_contact_city').val($('#trade_new_summary_invoice_different_city').val());
            $('#trade_new_summary_invoice_contact_town').val($('#trade_new_summary_invoice_different_town').val());
            $('#trade_new_summary_invoice_contact_address').val($('#trade_new_summary_invoice_different_address').val());
            $('#trade_new_summary_invoice_contact_postcode').val($('#trade_new_summary_invoice_different_postcode').val());
        }
    }, '.js_trade_new_summary_invoice_contact_input');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[\s\d]+/g, '').substring(0, 20)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_form').submit();
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_form').submit();
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_summary_invoice_different_mobile').focus().select()
        }
    }, '#trade_new_summary_invoice_different_name');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 11)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_form').submit();
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_form').submit();
        },
        keyup: function (event) {
            //if (event.keyCode == 13) $('#trade_new_summary_invoice_different_area').focus().select()
        }
    }, '#trade_new_summary_invoice_different_mobile');
    //$(document).on({
    //    input: function () {
    //        var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 4)
    //        if (val != $(this).val()) $(this).val(val)
    //        $('#trade_new_summary_invoice_different_mobile').data('checking', false);
    //        $('#trade_new_form').submit();
    //    },
    //    blur: function () {
    //        $('#trade_new_summary_invoice_different_mobile').data('checking', true);
    //        $('#trade_new_form').submit();
    //    },
    //    keyup: function (event) {
    //        if (event.keyCode == 13) $('#trade_new_summary_invoice_different_local').focus().select()
    //    }
    //}, '#trade_new_summary_invoice_different_area');
    //$(document).on({
    //    input: function () {
    //        var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 8)
    //        if (val != $(this).val()) $(this).val(val)
    //        $('#trade_new_summary_invoice_different_mobile').data('checking', false);
    //        $('#trade_new_form').submit();
    //    },
    //    blur: function () {
    //        $('#trade_new_summary_invoice_different_mobile').data('checking', true);
    //        $('#trade_new_form').submit();
    //    },
    //    keyup: function (event) {
    //        if (event.keyCode == 13) $('#trade_new_summary_invoice_different_province').focus().select()
    //    }
    //}, '#trade_new_summary_invoice_different_local');
    $(document).on({
        change: function () {
            $(this).data('checking', false);
            $('#trade_new_form').submit();
        }
    }, '#trade_new_summary_invoice_different_province, #trade_new_summary_invoice_different_city');
    $(document).on({
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_summary_invoice_different_city').focus().select()
        }
    }, '#trade_new_summary_invoice_different_province');
    $(document).on({
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_summary_invoice_different_town').focus().select()
        }
    }, '#trade_new_summary_invoice_different_city');
    $(document).on({
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_summary_invoice_different_address').focus().select()
        }
    }, '#trade_new_summary_invoice_different_town');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/^\s+/g, '').substring(0, 50)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_form').submit();
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_form').submit();
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_summary_invoice_different_postcode').focus().select()
        }
    }, '#trade_new_summary_invoice_different_address');
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 6)
            if (val != $(this).val()) $(this).val(val)
            $(this).data('checking', false);
            $('#trade_new_form').submit();
        },
        blur: function () {
            $(this).data('checking', true);
            $('#trade_new_form').submit();
        },
        keyup: function (event) {
            if (event.keyCode == 13) $('#trade_new_summary_confirm').mousedown();
        }
    }, '#trade_new_summary_invoice_different_postcode');
    $(document).on({
        mousedown: function () {
            $('#trade_new_form').data('submitting', true).submit();
        }
    }, '#trade_new_summary_confirm');
    $(document).on({
        submit: function () {
            if($('#trade_new_summary_phone_other').attr('checked')){
                var delivery_phone_valid=$("#trade_new_summary_phone_new").val().match(/^1\d{10}$/)
                if(!delivery_phone_valid) {$("#trade_delivery_phone_error").show();}
            }else{
                delivery_phone_valid=true
            }
            if (!$('#trade_new_summary_invoice_contact_different').prop('checked') || $('#trade_new_summary_invoice_contact_different').prop('disabled')) {
                var invoice_valid = true;
            } else {
                var name_valid = $('#trade_new_summary_invoice_different_name').val() != '';
                if (name_valid) $('#trade_new_summary_invoice_different_name_error').hide();
                if (!name_valid && $('#trade_new_summary_invoice_different_name').data('checking')) $('#trade_new_summary_invoice_different_name_error').show();

                var mobile_presence = $('#trade_new_summary_invoice_different_mobile').val() != '';
                //var area_presence = $('#trade_new_summary_invoice_different_area').val() != '';
                //var local_presence = $('#trade_new_summary_invoice_different_local').val() != '';
                var mobile_valid = $('#trade_new_summary_invoice_different_mobile').val().match(/^1\d{10}$/);
                //var area_valid = $('#trade_new_summary_invoice_different_area').val().match(/^\d{3,4}$/);
                //var local_valid = $('#trade_new_summary_invoice_different_local').val().match(/^\d{5,8}$/);
                var mobile_or_phone_valid = (!mobile_presence || mobile_presence && mobile_valid) && (mobile_presence);
                if (mobile_or_phone_valid) $('#trade_new_summary_invoice_different_mobile_error').hide();
                if (!mobile_or_phone_valid && $('#trade_new_summary_invoice_different_mobile').data('checking')) $('#trade_new_summary_invoice_different_mobile_error').show();

                var province_valid = $('#trade_new_summary_invoice_different_province').val() != '';
                var city_valid = $('#trade_new_summary_invoice_different_city').val() != '';

                var address_valid = $('#trade_new_summary_invoice_different_address').val() != '';
                if (address_valid) $('#trade_new_summary_invoice_different_address_error').hide();
                if (!address_valid && $('#trade_new_summary_invoice_different_address').data('checking')) $('#trade_new_summary_invoice_different_address_error').show();

                var postcode_valid = $('#trade_new_summary_invoice_different_postcode').val().match(/^\d{6}$/);
                if (postcode_valid) $('#trade_new_summary_invoice_different_postcode_error').hide();
                if (!postcode_valid && $('#trade_new_summary_invoice_different_postcode').data('checking')) $('#trade_new_summary_invoice_different_postcode_error').show();

                var invoice_valid = name_valid && mobile_or_phone_valid && province_valid && city_valid && address_valid && postcode_valid;
            }

            var term_valid = $('#trade_new_summary_term').prop('checked');
            var summary_voucher_valid = !$('.js_trade_new_summary_voucher_submit').hasClass('disabled');
            var summary_card_valid = !$('#trade_new_summary_card_newpw,#trade_new_summary_card_activate,#trade_new_summary_card_inspect_btn').hasClass('disabled');

            if (invoice_valid && term_valid && summary_voucher_valid && summary_card_valid && delivery_phone_valid) $('#trade_new_summary_confirm').removeClass('disabled');
            else $('#trade_new_summary_confirm').addClass('disabled');

            if (!$(this).data('submitting') || $(this).hasClass('disabled') || $('#trade_new_summary_confirm').hasClass('disabled')) {
                $(this).data('submitting', false);
                return;
            }
            $(this).data('submitting', false);

            if ($(this).hasClass('disabled')) return;
            $.ajax({
                url: '/shop/trades.js',
                type: 'post',
                data: $(this).serialize(),
                dataType: 'json',
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                    $('#trade_new_summary_confirm').addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled')
                },
                success: function (data) {
                    $.ajax({
                        type: 'post',
                        url: '/shop/trades/update_cart.json',
                        data: $(this).data('cart')
                    })
                    window.go({pushState: true, updateTitle: true, target: "popup"}, '', '/shop/trades/' + data['id']);

                    if (typeof(_gaq) != 'undefined') {
                        _gaq.push(['_addTrans',
                            '' + data.id,           // transaction ID - required
                            'weimall', // affiliation or store name
                            '' + data.price,          // total - required
                            '',           // tax
                            '',          // shipping
                            data.contact.city,       // city
                            data.contact.province,     // state or province
                            data.contact.country             // country
                        ]);
                        $(data.units).each(function () {
                            _gaq.push(['_addItem',
                                '' + data.id,           // transaction ID - necessary to associate item with transaction
                                '' + this.item.product.id,           // SKU/code - required
                                this.item.product.name,        // product name
                                this.item.product.category2.name,   // category or variation
                                this.price,          // unit price - required
                                '1'               // quantity - required
                            ]);
                        })
                        _gaq.push(['_trackTrans']);
                    }
                    if ($.cookie('promotion_id') == '247') {
                        _adwq.push(['_setDataType', 'order']);
                        _adwq.push(['_setCustomer', $.cookie('user_id')]);
                        _adwq.push(['_setOrder', data.id, data.price]);
                        for (var i = data.units.length; i--;) {
                            _adwq.push(['_setItem', data.units[i].item.product.id, data.units[i].item.product.name, data.units[i].price, '1', data.units[i].item.product.category2.id, data.units[i].item.product.category2.name]);
                        }
                        _adwq.push(['_trackTrans']);
                    }
                },
                error: function () {
                    $('#trade_new_summary_confirm_tip').stop(true, true).show();
                    setTimeout(function () {
                        $('#trade_new_summary_confirm_tip').stop(true, true).fadeOut(500)
                    }, 2000)
                    $('#trade_new_summary_confirm').removeClass('disabled')
                }
            });
        }
    }, '#trade_new_form');

    $(document).on({
        mousedown: function () {
            $('.js_trade_new_cart_checkbox').each(function () {
                if ($(this).attr('checked') || $(this).attr('disabled')) return;
                $(this).attr('checked', true).change();
            });
        }
    }, '#trade_new_cart_checkall')
    $(document).on({
        calc: function () {
            var total = 0;
            $('.js_trade_new_cart_checkbox:checked').each(function () {
                total += parseInt($(this).data('price'))
            });
            $(this).text(total);
            $('#trade_new_summary_total_price').text(total)
            if ($('.js_trade_new_cart_checkbox:checked').length == 0) $('#trade_new_cart_confirm').addClass('disabled');
            else $('#trade_new_cart_confirm').removeClass('disabled');
        }
    }, '#trade_new_cart_total')
    $(document).on({
        change: function () {
            $('#trade_new_cart_total').trigger('calc');
        }
    }, '.js_trade_new_cart_checkbox')
    $(document).on({
        mousedown: function (event) {
            $('.js_trade_new_cart_delete_box').each(function () {
                if ($(this).css('display') == 'none' || $.contains(this, event.target)) return
                $(this).stop(true, true).slideUp(100)
            })
        }
    }, '#trade_new_cart')
    $(document).on({
        mousedown: function () {
            var i = $(this).data('i')
            setTimeout(function () {
                $('#trade_new_cart_' + i + '_delete_box').stop(true, true).slideDown(100)
            }, 1)
        }
    }, '.js_trade_new_cart_delete')
    $(document).on({
        mousedown: function () {
            $('#trade_new_cart_' + $(this).data('i') + '_delete_box').stop(true, true).slideUp(100)
        }
    }, '.js_trade_new_cart_delete_cancel')
    $(document).on({
        mousedown: function () {
            var d = {};
            $('.js_trade_new_cart_checkbox[data-i!=' + $(this).data('i') + ']').map(function () {
                u = $(this).data('unit');
                d['units[' + (999 - parseInt($(this).data('i'))) + '][product_id]'] = u['product_id']
                d['units[' + (999 - parseInt($(this).data('i'))) + '][measure]'] = u['measure']
            });
            $.ajax({
                url: '/shop/trades/update_cart.js',
                type: 'post',
                data: d,
                context: this,
                beforeSend: function () {
                    $(this).addClass('disabled');
                },
                complete: function () {
                    $(this).removeClass('disabled');
                },
                beforeSend: function () {
                    $('#trade_new_cart_' + $(this).data('i') + '_delete_box').slideUp(100);
                },
                success: function () {
                    $('#trade_new_cart_' + $(this).data('i') + ', #trade_new_summary_unit_' + $(this).data('i')).remove()
                    $('#trade_new_cart_total').trigger('calc');
                }
            });
        }
    }, '.js_trade_new_cart_delete_confirm')
    $(document).on({
        input: function () {
            var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 11)
            if (val != $(this).val()) $(this).val(val)
        }
    }, '#trade_payment_delivery_phone')
    $(document).on({
        change: function () {
            if (!$(this).attr('checked')) return true
            $('#trade_payment_service_is_online').prop('checked', false).change();
            $('#trade_payment_delivery_phone').prop('disabled', false);
            $('#trade_payment_delivery_phone').closest('.jqTransformInputWrapper').trigger('disabledchange')
        }
    }, '#trade_payment_service_express');
    $(document).on({
        change: function () {
            if (!$(this).attr('checked')) return true
            $('#trade_payment_service_is_online').prop('checked', false).change();
            $('#trade_payment_delivery_phone').prop('disabled', true);
            $('#trade_payment_delivery_phone').closest('.jqTransformInputWrapper').trigger('disabledchange')
        }
    }, '#trade_payment_service_request');
    $(document).on({
        change: function () {
            if (!$(this).attr('checked')) return true
            $('#trade_payment_service_is_online').prop('checked', true).change();
            $('#trade_payment_delivery_phone').prop('disabled', true);
            $('#trade_payment_delivery_phone').closest('.jqTransformInputWrapper').trigger('disabledchange')
        }
    }, '.js_trade_payment_service_online');
    $(document).on({
        change: function () {
            if (!$(this).attr('checked') || $('.js_trade_payment_service_online:checked').length) return true;
            $('.js_trade_payment_service_online:first').prop('checked', true).trigger('change').trigger('click').prev().trigger('click');
            $('#trade_payment_service_express, #trade_payment_service_request').prop('checked', false).change();
        }
    }, '#trade_payment_service_is_online');
    $(document).on({
        mousedown: function () {
            var post_servrice = ['^unionpay$', '^cmbc$', '^pab$', '^boc_creditcard$', '^boc$', '^comm_creditcard$', '^yeepay_', '^cmbchina_creditcard_', '^icbc$', '^pab_pay$'];
            var _this = this;
            if ($.grep(post_servrice, function (item, index) {
                    return RegExp(item).test($(_this).val())
                }).length > 0) {
                $.ajax({
                    url: '/shop/trades/' + $('#trade_payment_form').data('id') + '/checkout.json',
                    type: 'get',
                    data: {'_method': 'get', 'trade[payment_service]': $(this).val()},
                    context: this,
                    beforeSend: function () {
                        $('#trade_payment_confirm').addClass('disabled');
                    },
                    complete: function () {
                        $('#trade_payment_confirm').removeClass('disabled');
                    },
                    success: function (data) {
                        if (Boolean(data.url)) $(this).data('checkout_url', data.url);
                    }
                });
            }
        }
    }, '.js_trade_payment_service_online');
    $(document).on({
        click: function () {
            if ($(this).hasClass('disabled')) return;
            if ($('#trade_payment_service_express').prop('checked')) {
                $.ajax({
                    url: '/shop/trades/' + $('#trade_payment_form').data('id') + '/express_pay.js',
                    type: 'post',
                    data: {'_method': 'put', 'trade[delivery_phone]': $('#trade_payment_delivery_phone').val()},
                    context: this,
                    beforeSend: function () {
                        $(this).addClass('disabled loading');
                    },
                    complete: function () {
                        $(this).removeClass('disabled loading');
                    },
                    success: function () {
                        $('#trade_show_payment').hide();
                        $('#trade_show_express').show();
                    }
                });
            } else if ($('#trade_payment_service_request').prop('checked')) {
                window.open('/statics/shop/checkout/?id=' + $('#trade_payment_form').data('id'));
            } else {
                var post_servrice = ['^unionpay$', '^cmbc$', '^pab$', '^boc_creditcard$', '^boc$', '^comm_creditcard$', '^yeepay_', '^cmbchina_creditcard_', '^icbc$', '^pab_pay$'];
                var service = $('#trade_payment_form :checked[id!=trade_payment_service_is_online]:first');
                var service_name = $(service).val();
                if ($.grep(post_servrice, function (item, index) {
                        return RegExp(item).test(service_name)
                    }).length > 0) {
                    var check_url = $(service).data('checkout_url');
                    var url = service_name.match(/^cmbchina_creditcard_/) ? check_url.match(/[^&]*/) : check_url.match(/[^?]*/);
                    var options = service_name.match(/^cmbchina_creditcard_/) ? check_url.replace(/[^&]*\&/, '') : check_url.replace(/[^?]*\?/, '')
                    if (!Boolean(check_url.length)) service.trigger('mousedown');
                    $form = $('<form />', {
                        method: 'post',
                        id: 'pay_online_post_form',
                        target: '_blank',
                        action: url
                    });
                    $('#trade_payment_form').after($form);
                    $(decodeURIComponent(options).split('&')).each(function () {
                        $('<input />', {
                            type: "hidden",
                            name: this.split('=')[0],
                            val: this.replace(/[^=]*=/, '')
                        }).appendTo($form);
                    });
                    $("<input/>", {
                        type: "hidden",
                        name: "authenticity_token",
                        val: $("meta[name='csrf-token']").attr("content")
                    }).appendTo($form);
                    $('#pay_online_post_form').submit();
                    $('#trade_payment_process').show();
                    $('#pay_online_post_form').remove();
                } else {
                    window.open('/shop/trades/' + $('#trade_payment_form').data('id') + '/checkout?' + $('#trade_payment_form').serialize());
                    $('#trade_payment_process').show();
                }
            }
            return false
        }
    }, '#trade_payment_confirm');
    $(document).on({
        submit: function () {
            $('#trade_payment_confirm').click();
        }
    }, '#trade_payment_form');
    $(document).on({
        mousedown: function () {
            if ($(this).hasClass('disabled')) return;
            var payment_service = $('.js_trade_payment_service_online:checked').val();
            $.ajax({
                url: '/shop/trades/' + $(this).data('id') + '/' + (payment_service.match(/^(cmbchina|boc|comm)_creditcard|pab_pay$/) ? payment_service : payment_service.replace(/_.*/, '')) + '_query.json',
                type: 'put',
                dataType: 'json',
                context: this,
                beforeSend: function () {
                    $(this).addClass('loading')
                    $(this).siblings().addClass('disabled')
                },
                complete: function () {
                    $(this).removeClass('loading')
                    $(this).siblings().removeClass('disabled')
                },
                success: function (data) {
                    $('#trade_payment_process').hide();
                    if (data['trade'] && data['trade']['payment_service']) {
                        $('#trade_show_payment').hide();
                        $('#trade_show_online').show();
                    } else {
                        $('#trade_payment_problem').show();
                    }
                }
            });
        }
    }, '#trade_payment_process_success, #trade_payment_process_failure');
    $(document).on({
        mousedown: function () {
            $('#trade_payment_problem').hide();
            $('#trade_payment_service_express').prop('checked', true).change().prev().click();
        }
    }, '#trade_payment_problem_express');
    $(document).on({
        mousedown: function () {
            $('#trade_payment_problem').hide();
            $('#trade_payment_service_request').prop('checked', true).change().prev().click();
        }
    }, '#trade_payment_problem_request');
    $(document).on({
        mousedown: function () {
            $('#trade_payment_problem').hide();
            $('.js_trade_payment_service_online:first').prop('checked', true).change().prev().click();
        }
    }, '#trade_payment_problem_online');

    $(document).on({
        update_options: function () {
            var province = $(this);
            var provinces = document.contact_options.provinces;
            var different = $.makeArray(province.find('option').map(function () {
                    return $(this).text();
                })).slice(1, 99999).sort().join() != $.makeArray($(provinces).map(function () {
                    return this.name;
                })).sort().join();
            if (different) {
                // var province_val = province.val();
                var province_wrapper = province.parents('.select_wrapper');
                province_wrapper.html(province_wrapper.html().replace(/^[\s\S]*<select/i, '<select').replace(/<option[\s\S]*<\/option>/i, '<option value="">选择省份</option>' + $.makeArray($(provinces).map(function () {
                        return '<option value="' + this['name'] + '" ' + (this['name'] == province.val() ? ' selected="selected"' : '') + '>' + this['name'] + '</option>'
                    })).join('')));
                var province = province_wrapper.find('select');
                // province.val(province_val);
                //province.removeClass('jqTransformHidden').jqTransSelect();
            }
            province.prop('disabled', !provinces.length)

            var city = $('.js_contact_city_' + province.data('id'));
            if (!city.length) return;
            var cities = province.val() != '' && (a = $(provinces).filter(function () {
                    return this['name'] == province.val();
                })[0]) && a['cities'] || [];
            var different = $.makeArray(city.find('option').map(function () {
                    return $(this).text();
                })).slice(1, 99999).sort().join() != $.makeArray($(cities).map(function () {
                    return this.name;
                })).sort().join();
            if (different) {
                // var city_val = city.val();
                var city_wrapper = city.parents('.select_wrapper');
                city_wrapper.html(city_wrapper.html().replace(/^[\s\S]*<select/i, '<select').replace(/<option[\s\S]*<\/option>/i, '<option value="">选择城市</option>' + $.makeArray($(cities).map(function () {
                        return '<option value="' + this['name'] + '" ' + (this['name'] == city.val() ? ' selected="selected"' : '') + '>' + this['name'] + '</option>'
                    })).join('')));
                var city = city_wrapper.find('select');
                // city.val(city_val);
                //city.removeClass('jqTransformHidden').jqTransSelect();
            }
            city.prop('disabled', !cities.length)

            var town = $('.js_contact_town_' + city.data('id'));
            if (!town.length) return;
            var towns = city.val() != '' && (a = $(cities).filter(function () {
                    return this['name'] == city.val();
                })[0]) && a['towns'] || [];
            var different = $.makeArray(town.find('option').map(function () {
                    return $(this).text();
                })).slice(1, 99999).sort().join() != $.makeArray($(towns).map(function () {
                    return this.name;
                })).sort().join();
            if (different) {
                // var town_val = town.val();
                var town_wrapper = town.parents('.select_wrapper');
                town_wrapper.html(town_wrapper.html().replace(/^[\s\S]*<select/i, '<select').replace(/<option[\s\S]*<\/option>/i, '<option value="">选择区</option>' + $.makeArray($(towns).map(function () {
                        return '<option value="' + this['name'] + '" ' + (this['name'] == town.val() ? ' selected="selected"' : '') + '>' + this['name'] + '</option>'
                    })).join('')));
                var town = town_wrapper.find('select');
                // town.val(town_val);
                //town.removeClass('jqTransformHidden').jqTransSelect();
            }
            town.prop('disabled', !towns.length)
        },
        initialize_options: function () {
            if (!document.contact_options) {
                $.ajax({
                    url: '/shop/contacts/options.js',
                    dataType: 'text',
                    context: this,
                    success: function (data) {
                        document.contact_options = eval('(' + data + ')')
                        $(this).trigger('initialize_options')
                    }
                });
                return;
            }
            if ($(this).data('inited') || !document.contact_options) return;
            $(this).trigger('update_options').data('inited', true);
        }
    }, '.js_contact_province');
    $(document).bind('reload', function () {
        $('.js_contact_province').trigger('initialize_options');
    });
    $(document).on({
        change: function () {
            $('.js_contact_province_' + $(this).data('id')).trigger('update_options');
        }
    }, '.js_contact_province, .js_contact_city');
});
