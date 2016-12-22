function update_contact_confirm($form) {
    if (!$form.is('form')) {
        $form = $form.parents('form');
    }
    var id = $form.attr('data-id') || '';
    var name_valid = $('#receiving_list_' + id + '_name').val() != '';
    if (name_valid || $('#receiving_list_' + id + '_name').data('inprocess')) {
        $('#receiving_list_' + id + '_name_error').hide();
    } else {
        $('#receiving_list_' + id + '_name_error').show();
    }

    var mobile_valid = $('#receiving_list_' + id + '_mobile').val() && $('#receiving_list_' + id + '_mobile').val().match(/^1\d{10}$/);
    if (mobile_valid || $('#receiving_list_' + id + '_mobile').data('inprocess')) {
        $('#receiving_list_' + id + '_mobile_error').hide();
    } else {
        $('#receiving_list_' + id + '_mobile_error').show();
    }

    var province_valid = $('#receiving_list_' + id + '_province').val() != '';
    var city_valid = $('#receiving_list_' + id + '_city').val() != '';
    var address_valid = $('#receiving_list_' + id + '_address').val() != '';
    if (address_valid || $('#receiving_list_' + id + '_address').data('inprocess')) {
        $('#receiving_list_' + id + '_address_error').hide();
    } else {
        $('#receiving_list_' + id + '_address_error').show();
    }

    var postcode_valid = $('#receiving_list_' + id + '_postcode').val() && $('#receiving_list_' + id + '_postcode').val().match(/^\d{6}$/);
    if (postcode_valid || $('#receiving_list_' + id + '_postcode').data('inprocess')) {
        $('#receiving_list_' + id + '_postcode_error').hide();
    } else {
        $('#receiving_list_' + id + '_postcode_error').show();
    }

    return name_valid && mobile_valid && province_valid && city_valid && address_valid && postcode_valid
}
$(document).on({
    mousedown: function (event) {
        $('.js_receiving_list_delete_box').each(function () {
            if ($(this).css('display') == 'none' || $.contains(this, event.target)) return
            $(this).stop(true, true).slideUp(100)
        })
    }
}, '#receiving_list')
$(document).on({
    mousedown: function () {
        var id = $(this).data('id');
        $('#receiving_list_' + id).addClass('open');
        //$('#receiving_list_' + id + '_radio').attr('checked', true).prev().click();
    }
}, '.js_receiving_list_edit');
$(document).on({
    mousedown: function () {
        var id = $(this).data('id')
        setTimeout(function () {
            $('#receiving_list_' + id + '_delete_box').stop(true, true).slideDown(100)
        }, 1)
    }
}, '.js_receiving_list_delete');
$(document).on({
    mousedown: function () {
        $('#receiving_list_' + $(this).data('id') + '_delete_box').stop(true, true).slideUp(100)
    }
}, '.js_receiving_list_delete_cancel');
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
                $('#receiving_list_' + id).remove();
                if ($('.js_receiving_list_radio:checked').length == 0) {
                    $('.js_receiving_list_radio').first().attr('checked', true);
                    $('.js_receiving_list_radio').first().parent().find('a').click();
                }
            }
        });
    }
}, '.js_receiving_list_delete_confirm');

$(document).on({
    input: function () {
        var val = $(this).val().replace(/[\s\d]+/g, '').substring(0, 20);
        if (val != $(this).val()) $(this).val(val);
        $(this).data('inprocess', true);
        update_contact_confirm($(this));
    },
    blur: function () {
        $(this).data('inprocess', false);
        update_contact_confirm($(this));
    },
    keyup: function (event) {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        if (event.keyCode == 13) $('#receiving_list_' + id + '_mobile').focus().select()
    }
}, '.js_receiving_list_name');
$(document).on({
    input: function () {
        var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 11)
        if (val != $(this).val()) $(this).val(val)
        $(this).data('inprocess', true);
        update_contact_confirm($(this));
    },
    blur: function () {
        $(this).data('inprocess', false);
        update_contact_confirm($(this));
    },
    keyup: function (event) {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        if (event.keyCode == 13) $('#receiving_list_' + id + '_area').focus().select()
    }
}, '.js_receiving_list_mobile');
$(document).on({
    input: function () {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 8)
        if (val != $(this).val()) $(this).val(val)
        $(this).data('inprocess', true);
    },
    blur: function () {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        $(this).data('inprocess', false);
        update_contact_confirm($(this));
    },
    keyup: function (event) {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        if (event.keyCode == 13) $('#receiving_list_' + id + '_province').focus().select()
    }
}, '.js_receiving_list_local');
$(document).on({
    change: function () {
        $(this).data('inprocess', true);
        update_contact_confirm($(this));
        $(this).data('inprocess', false);
    }
}, '.js_receiving_list_province, .js_receiving_list_city');
$(document).on({
    keyup: function (event) {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        if (event.keyCode == 13) $('#receiving_list_' + id + '_city').focus().select()
    }
}, '.js_receiving_list_province');
$(document).on({
    keyup: function (event) {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        if (event.keyCode == 13) $('#receiving_list_' + id + '_town').focus().select()
    }
}, '.js_receiving_list_city');
$(document).on({
    keyup: function (event) {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        if (event.keyCode == 13) $('#receiving_list_' + id + '_address').focus().select()
    }
}, '.js_receiving_list_town');
$(document).on({
    input: function () {
        var val = $(this).val().replace(/^\s+/g, '').substring(0, 50)
        if (val != $(this).val()) $(this).val(val)
        $(this).data('inprocess', true);
    },
    blur: function () {
        $(this).data('inprocess', false);
        update_contact_confirm($(this));
    },
    keyup: function (event) {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        if (event.keyCode == 13) $('#receiving_list_' + id + '_postcode').focus().select()
    }
}, '.js_receiving_list_address');
$(document).on({
    input: function () {
        var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 6)
        if (val != $(this).val()) $(this).val(val)
        $(this).data('inprocess', true);
        update_contact_confirm($(this));
    },
    blur: function () {
        $(this).data('inprocess', false);
        update_contact_confirm($(this));
    },
    keyup: function (event) {
        var $form = $(this).parents('form');
        var id = $form.attr('data-id');
        if (event.keyCode == 13) $('#receiving_list_confirm').mousedown();
    }
}, '.js_receiving_list_postcode');


