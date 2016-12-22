window.App = {
    simpleCaptcha: function () {
        var $nextCaptcha = $('#nextCaptcha');
        if ($nextCaptcha.data("events") && $nextCaptcha.data("events")['click']) {
            return false;
        }
        $nextCaptcha.on('click', function () {
            $.getJSON('/captcha.json', {type: 'sign_up'}, function (json) {
                if (json) {
                    var $img = $nextCaptcha.parent().find('img');
                    $img.attr("src", json.img);
                }
                $img.show();
            })
        });
        $nextCaptcha.trigger('click')
    },
    handleValidation: function ($form, rules, messages, addValidateFun) {
        if (typeof rules == 'function') {
            addValidateFun = rules;
            rules = {}
        } else if (typeof messages == 'function') {
            addValidateFun = rules;
            messages = {}
        }
        $form.on('submit', function () {
            if (addValidateFun && !addValidateFun($form)) {
                return false;
            }
        });
    },
    handleRjsCb: function ($eml, validate, addValidateFun) {
        // 按钮绑定的rjs 和 form 绑定的Rjs
        if (typeof validate == 'function') {
            addValidateFun = validate;
            validate = true
        }
        validate = !(validate == false);
        if (validate && $eml.is('form')) {
            App.handleValidation($eml, addValidateFun);
        }
        $eml.on('ajax:success', function (event, data) {
            if (data.success) {
                toastr.success(data.msg, '成功:');
                if ($eml.is('form')) {
                    $eml.get(0).reset();
                }
                if ($eml.attr('data-reload')) {
                    window.location.reload();
                } else if (data.location) {
                    window.location.href = data.location;
                }
            } else {
                if (data.errors) {
                    data.msg += App.flattenMsg(data.errors)
                }
                toastr.warning(data.msg, '失败:');
            }
        }).on("ajax:error", function (event, data) {
            data = $.parseJSON(data.responseText);
            if (data) {
                if (data.success) {
                    toastr.success(data.msg, '成功:');
                    if ($eml.is('form')) {
                        $eml.get(0).reset();
                    }
                    if (data.location) {
                        window.location.href = data.location;
                    } else if ($eml.attr('data-reload')) {
                        window.location.reload();
                    }
                } else {
                    if (data.errors) {
                        data.msg += App.flattenMsg(data.errors)
                    }
                    toastr.warning(data.msg, '失败:');
                }
            } else {
                toastr.error('未知错误！', '错误:');
            }
        });
        return $eml;
    }, addFavorite: function () {
        var _t, _u;
        _t = document.title;
        _u = location.href;
        try {
            window.external.addFavorite(_u, _t);
        } catch (e) {
            try {
                window.sidebar.addPanel(_t, _u, '');
            }
            catch (e) {
                alert("抱歉，您所使用的浏览器无法完成此操作。" +
                "\n请使用Ctrl+D进行添加。");
            }
        }
    }, guid: function () {
        var d = new Date().getTime();
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = (d + Math.random() * 16) % 16 | 0;
            d = Math.floor(d / 16);
            return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });
    }
};
