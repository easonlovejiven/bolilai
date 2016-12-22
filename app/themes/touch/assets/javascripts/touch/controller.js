var products_index_controller = {
    initialize: function (e, a, t, i) {
        var s = $(".collect_fav_ico").data("brand-id"), n = decodeURIComponent(window.location.search).trim().replace("?", "");
        window.location.href.indexOf("where[brand_id]") > -1 && (get_cookie("No") && "fanship" == get_cookie("Mark") ? fanship.add(get_cookie("No"), function (e) {
            e && e.fanship && $(".collect_fav_ico").addClass("push").data("id", e.fanship.id)
        }) : app.get_user() && fanship.get(s, function (e) {
            e && e.fanships[0] && $(".collect_fav_ico").addClass("push").data("id", e.fanships[0].id)
        }));
        {
            var r = $(".products_content");
            r.find(".product").length
        }
        this.fanship_event($(".collect_fav_ico")), this.spread_detail($(".brand_more")),
            this.ids = i, this.brand_height = $(".brand_information").height() + 20,
            this.total_height = this.brand_height, this.height = DeviceInfo.height, this.scan_mode = this.get_mode() ? this.get_mode() : "small",
            "" != this.ids || window.location.href.indexOf("filter=") > -1 ? (0 == this.ids.length && (this.set_style(),
                $(".filter_sorry_txt").removeClass("hide")),
            -1 != window.location.href.indexOf("ids=") || setTimeout(function () {
                $(".mode_ico, .filter_ico").removeClass("hide")
            }, 10), this.load_pros(t)) : ($(".list_array").addClass("hide"), $(".title").removeClass("list_item")),
            this.order_event(e, a), this.scroll_load();
        var o = 38 * $(".array_item").length + 16;
        $(".left_blank, .right_blank").css("height", o), $(".bottom_blank").css("height", DeviceInfo.height - o), $(".left_blank, .right_blank, .bottom_blank").bind("click touchstart", function (e) {
            e.preventDefault(), $(".list_array").removeClass("push"), $("#array_fixed").addClass("hide")
        }), this.change_scan(t), this.show_filter($(".filter_ico")), this.filter = {
            category: this.set_category(!1),
            select: {},
            current: [],
            filters: {},
            option_id: "",
            sort: ""
        }, this.deeplink = {
            init: "",
            current: "",
            pathname: "",
            go_href: !0
        }, app.push_event($(".up_page.use, .down_page.use"), 100), 0 == $(".products_list .product").length && $(".mode_ico").addClass("hide"), this.handle_deeplink(n)
    }, set_style: function () {
        $(".filter_sorry_txt").css($(".brand_information").length > 0 ? {
            height: "40px",
            "margin-top": (DeviceInfo.height - 90 - $(".brand_information").height()) / 2 + "px"
        } : $(".multibuy_information").length > 0 ? {
            height: "40px",
            "margin-top": (DeviceInfo.height - 90 - $(".multibuy_information").height()) / 2 + "px"
        } : {height: "40px", "margin-top": (DeviceInfo.height - 90) / 2 + "px"})
    }, load_pros: function (e) {
        "small" == this.scan_mode ? (dex = .344, views.product_style(dex), this.pro_height = parseInt(DeviceInfo.width * dex) + 80, this.change_height()) : (dex = .75, views.product_style(dex), e.addClass("large"), $(".products_content").addClass("big_mode"), this.pro_height = parseInt(DeviceInfo.width * dex) + 80, this.change_height()), this.pro_css(), this.get_products(0, this.show_pros())
    }, set_category: function (e) {
        var a = decodeURIComponent(e ? this.deeplink.current : window.location.search).trim(), t = -1 == a.indexOf("category1_id"), i = -1 == a.indexOf("category2_id"), s = -1 == a.indexOf("category3_id");
        return t && i ? "category1_id" : !t && i ? "category2_id" : t && !i ? "category1_id" : t || i || !s ? void 0 : "category3_id"
    }, spread_detail: function (e) {
        var a = this;
        e.bind(itap_event, function () {
            e.parent().toggleClass("show"), a.brand_height = $(".brand_information").height() + 20, a.total_height = a.brand_height, setTimeout(function () {
                app.iscroll.refresh()
            }, 100)
        })
    }, fanship_event: function (e) {
        var a = $(e), t = a.data("brand-id");
        a.bind(itap_event, function () {
            var e = $(this);
            if (e.hasClass("push")) {
                var a = e.data("id");
                fanship.remove(a, function (a) {
                    a && e.attr("data-id", "").removeClass("push")
                })
            } else if (e.toggleClass("push"), app.get_user())fanship.add(t, function (a) {
                a && a.fanship && ($("#small_tip").removeClass("hide").addClass("pro").html("\u54c1\u724c\u6536\u85cf\u6210\u529f"), setTimeout(function () {
                    $("#small_tip").addClass("hide")
                }, 1e3), e.addClass("push").data("id", a.fanship.id))
            }); else {
                var i, s = navigator.userAgent.toLowerCase();
                "micromessenger" == s.match(/MicroMessenger/i) ? i = "wechat" : "aliapp" == s.match(/AliApp/i) && (i = "alipay"), i ? (app.authorize_login(i, window.location.href), app.handle_cookie("Mark", "fanship"), app.handle_cookie("No", t)) :
                    ($("#login_layer, #login_register_layer").removeClass("hide"), app.layer_appear($("#login_register_layer")), $("#main").append('<input type="hidden" id="fanship" data-id="' + t + '">'))
            }
        })
    }, show_filter: function (e) {
        var a = this;
        e.bind(itap_event, function () {
            $("#array_fixed").addClass("hide"), e.hasClass("push") || (e.addClass("push"), a.filter_title(), $(".filter_item").remove(), $("body").hasClass("firefox") ? setTimeout(function () {
                $(".filter_none_txt").addClass("hide"), $(".filter_sorry_txt").addClass("hide"), $("#loading").removeClass("hide"), e.removeClass("push"), a.get_pros(function () {
                    a.filter_init()
                })
            }, 300) : $("#filter_layer").one("webkitTransitionEnd", function () {
                $(".filter_none_txt").addClass("hide"), $(".filter_sorry_txt").addClass("hide"), $("#loading").removeClass("hide"), e.removeClass("push"), a.get_pros(function () {
                    a.filter_init()
                })
            }))
        })
    }, handle_deeplink: function (e) {
        function a() {
            d.deeplink.pathname = window.location.pathname + "?" + r, d.deeplink.init = 0 != p.length ? p.join("&") : t, d.deeplink.current = t
        }

        var t = "", i = "", s = [], n = [], r = "", o = ["ids", "where", "order", "values", "keyword"], d = this, l = e.split("&"), c = 0, p = [];
        if ($.each(l, function (e, a) {
                a.indexOf("filter") > -1 && (i = a), a.indexOf("title") > -1 && (r = a);
                var n = a.split("=")[0], d = !1;
                for (var l in o)n.indexOf(o[l]) > -1 && (d = !0);
                d && (s.push(a), t = t + ("" == t ? "" : "&") + a)
            }), "" != i && (t = t + "&" + i), l = s, "" != i && (n = i.split("=")[1].split(",")), 0 != n.length) {
            var h = [], u = [], _ = [];
            for (var v in l) {
                var f = !1;
                for (var m in n)"" != n[m] && l[v].indexOf(n[m]) > -1 && -1 == l[v].indexOf("order") && (f = !0);
                if (f) {
                    var g = l[v].indexOf("where") > -1 ? "where" : "values", y = "", C = "";
                    if (C = l[v].split("=")[1], y = l[v].split("=")[0].split("[]")[0].split(g)[1].replace("[", "").replace("]", ""), d.filter.select[y] || (d.filter.select[y] = {}), y.indexOf("brand") > -1)h.push(C); else if (y.indexOf("category") > -1)u.push(C); else if ("price" == y)_.push(C); else if ("color" == y) {
                        var b = {
                            "\u767d": "white",
                            "\u68d5": "palm",
                            "\u6a59": "orange",
                            "\u7070": "grey",
                            "\u7c89": "pink",
                            "\u7d2b": "purple",
                            "\u7ea2": "red",
                            "\u7eff": "green",
                            "\u84dd": "blue",
                            "\u9ec4": "yellow",
                            "\u9ed1": "black",
                            "\u94f6": "silver",
                            "\u5f69": "colorful"
                        };
                        d.filter.select[y][C] = {
                            active: "active",
                            count: 0,
                            id: b[C],
                            initial: "",
                            name: C,
                            value: C,
                            show: !0
                        }
                    } else d.filter.select[y][C] = {
                        active: "active",
                        count: 0,
                        id: C,
                        initial: "",
                        name: C,
                        value: C,
                        show: !0
                    }
                } else-1 == l[v].indexOf("title") && p.push(l[v])
            }
            if (0 != h.length && (c++, d.filter.select.brand_id = {}, products.get_brand(h.join(","), function (e) {
                    $.each(e, function (e, a) {
                        d.filter.select.brand_id[a.name] = {
                            active: "active",
                            count: 0,
                            id: a.id,
                            initial: a.initial,
                            name: a.name,
                            value: a.name,
                            show: !0
                        }
                    }), c--, 0 == c && a()
                })), 0 != u.length) {
                c++;
                var w = n.indexOf("category1_id") > -1;
                w = w ? "category1_id" : n.indexOf("category2_id") > -1 ? "category2_id" : "category3_id", d.filter.category = w, d.filter.select[w] = {}, products.get_category(u.join(","), function (e) {
                    $.each(e, function (e, a) {
                        d.filter.select[w][a.name] = {
                            active: "active",
                            count: 0,
                            id: a.id,
                            initial: "",
                            name: a.name,
                            value: a.name,
                            show: !0
                        }
                    }), c--, 0 == c && a()
                })
            }
            if (0 != _.length)for (var m = 0; m + 2 <= _.length;) {
                var x = _[m] + "-" + _[m + 1], k = {
                    active: "active",
                    count: 0,
                    id: x,
                    initial: "",
                    name: x,
                    value: x,
                    show: !0
                };
                d.filter.select.price[x] = k, m += 2
            }
        }
        0 == c && a()
    }, get_pros: function (e) {
        var a = this, t = this.deeplink.current + this.filter.sort;
        this.get_filter(t, function (t) {
            $.isEmptyObject(a.filter.select) || $.each(a.filter.select, function (e, a) {
                t && !t[e] && (t[e] = a)
            }), t && a.create_filters(t), $(".filter_main .content").children().remove(), a.filter_html(), setTimeout(function () {
                e()
            }, 10)
        })
    }, create_filters: function (e) {
        var a = [], t = [];
        this.filter.filters = e, $.each(e, function (e) {
            t.push(e)
        }), t.sort();
        for (var i in t) {
            var s = e[t[i]];
            a.push({data: s, name: t[i]})
        }
        this.filter.current = a.sort(this.filter_sort)
    }, get_filter: function (e, a) {
        var t = this;
        products.get_pros(e, function (e) {
            if (Math.ceil(e.data.length / 60) <= 1 ? $(".page.clear_fix").addClass("hide") : $(".page.clear_fix").removeClass("hide"), 0 == e.data.length)a(); else {
                $(".filter_sorry_txt").addClass("hide"), $(".index_page").html("<span>1</span>/" + Math.ceil(e.data.length / 60)), t.ids = e.data.slice(0, 60).map(function (e) {
                    return e.id
                });
                var i = JSON.parse(e.products_facet);
                "category1_id" == t.filter.category && delete i.category2_id && delete i.category3_id, "category2_id" == t.filter.category && delete i.category3_id, $.each(i, function (e, a) {
                    if ("values" == e)for (var t in a)i[a[t].name] = a[t].options
                }), delete i.values, a(i)
            }
        })
    }, filter_sort: function (e, a) {
        var t = {
            target: 1,
            category1_id: 2,
            category2_id: 2,
            category3_id: 2,
            brand_id: 3,
            price: 4,
            measure: 5,
            color: 6
        };
        return t[e.name] || (t[e.name] = 7), t[a.name] || (t[a.name] = 7), t[e.name] - t[a.name]
    }, filter_title: function () {
        $("#filter_layer .title").removeClass("filter"), $("#filter_layer .title").html("<p>\u7b5b\u9009</p><p class='ellipsis'></p>");
        var e = $("#filter_layer");
        e.removeClass("hide"), app.layer_appear(e)
    }, filter_init: function () {
        var e = $(".filter_main");
        this.filter_scroll || (this.filter_scroll = new IScroll(e[0], {
            scrollX: !1,
            scrollY: !0,
            hasHorizontalScrollbar: !1,
            hasVerticalScrollbar: !0,
            momentum: !0,
            scrollbars: !0,
            mouseWheel: !0,
            interactiveScrollbars: !0,
            shrinkScrollbars: "clip",
            fadeScrollbars: !0
        }), e.height(DeviceInfo.height - 50)), this.filter_scroll.refresh(), this.filter_confirm($(".confirm_ico")), this.filter_option($(".filter_item")), this.filter_clear($(".cancel_ico"))
    }, filter_clear: function (e) {
        var a = this;
        e.bind(itap_event, function () {
            e.hasClass("push") || (e.addClass("push"), a.deeplink.go_href ? (a.deeplink.current = a.deeplink.init, a.filter = {
                category: a.set_category(!0),
                select: {},
                current: [],
                filters: {},
                option_id: "",
                sort: a.filter.sort
            }, $(".filter_main .content").children().remove(), $("#loading").removeClass("hide"), a.get_pros(function () {
                a.filter_init()
            })) : ($("#filter_layer .title").find("p:last-child").html("\u6240\u6709"), $(".filter_item.active").removeClass("active"), delete a.filter.select[a.filter.option_id], a.deeplink.current = a.deeplink.init + "&" + $.param(a.filter.select)))
        })
    }, filter_option: function (e) {
        var a = this;
        e.unbind().bind(itap_event, function () {
            var e = $(this).data("id"), t = a.filter.select;
            $(this).addClass("active"), a.deeplink.go_href = !1, a.filter.option_id = e, $(".filter_main .content").children().remove(), $("#loading").removeClass("hide"), $.isEmptyObject(t) ? a.option_html(e) : (a.create_params_(), a.get_pros_options(function () {
                a.option_html(e)
            }))
        })
    }, get_pros_options: function (e) {
        var a = this, t = this.deeplink.current;
        this.get_filter(t, function (t) {
            $.isEmptyObject(a.filter.select) || $.each(a.filter.select, function (e, a) {
                t && !t[e] && (t[e] = a)
            }), t && a.create_filters(t), e()
        })
    }, option_html: function (e) {
        function a() {
            var e = [];
            for (var a in n)e.push(n[a].value);
            return e
        }

        function t(e) {
            var a = {};
            for (var t in n)a[n[t].value] = n[t].count;
            for (var t in e)e[t].count = a[e[t].id];
            return e
        }

        function i(e) {
            $("#loading").addClass("hide");
            var a = $(".filter_main .content");
            e instanceof Array ? (a.append(e[0]), $(".filter_main").addClass("has_index").after(e[1])) : a.append(e), o.filter_scroll.refresh(), o.item_event(), o.filter.select[o.filter.option_id] ? $(".filter_layer .cancel_ico").removeClass("push") : (o.filter.select[o.filter.option_id] = {}, $(".filter_layer .cancel_ico").addClass("push")), o.set_title()
        }

        var e = this.filter.option_id, s = e, n = this.filter.filters[e], r = "", o = this;
        if (e.indexOf("brand") > -1) {
            var d = a(n);
            0 == d.length ? (r = o.brand_html(d), i(r)) : products.get_brand(d.join(","), function (e) {
                e = t(e), r = o.brand_html(e), i(r), $($(".index_inner > div:first-child").addClass("active")), setTimeout(function () {
                    o.index_event()
                }, 10)
            })
        } else if (e.indexOf("category") > -1) {
            var d = a(n);
            0 == d.length ? (r = o.category_html(d), i(r)) : products.get_category(d.join(","), function (e) {
                e = t(e), r = o.category_html(e), i(r)
            })
        } else r = o[s + "_html"] ? o[s + "_html"](n) : o.value_html(n), i(r)
    }, set_title: function () {
        var e = [], a = "\u6240\u6709", t = $("#filter_layer .title"), i = {
            category3_id: "\u5206\u7c7b",
            category2_id: "\u5206\u7c7b",
            category1_id: "\u5206\u7c7b",
            brand_id: "\u54c1\u724c",
            price: "\u4ef7\u683c",
            measure: "\u5c3a\u7801",
            color: "\u989c\u8272",
            target: "\u6027\u522b"
        };
        t.addClass("filter"), $.each(this.filter.select[this.filter.option_id], function (a) {
            e.push(decodeURIComponent(a))
        }), 0 != e.length && (a = e.join("\u3001")), t.find("p:first-child").html(i[this.filter.option_id] ? i[this.filter.option_id] : this.filter.option_id), t.find("p:last-child").html(a)
    }, item_event: function () {
        var e = this;
        $(".filter_item").bind(itap_event, function () {
            var a = $(this).data("params"), t = $(this).data("id"), i = $(this).attr("id");
            if ($(this).hasClass("active"))delete e.filter.select[e.filter.option_id][a]; else {
                var s = {active: "active", id: t, value: a, count: 0, initial: i, name: a, show: !0};
                e.filter.select[e.filter.option_id] || (e.filter.select[e.filter.option_id] = {}), e.filter.select[e.filter.option_id][a] = s
            }
            $(this).toggleClass("active");
            var s = e.filter.select[e.filter.option_id], n = $("#filter_layer .title"), r = [];
            $.isEmptyObject(s) ? (n.find("p:last-child").html("\u6240\u6709"), $(".filter_layer .cancel_ico").addClass("push")) : ($.each(s, function (e) {
                r.push(decodeURIComponent(e))
            }), n.find("p:last-child").html(r.join("\u3001")), $(".filter_layer .cancel_ico").removeClass("push"))
        })
    }, index_event: function () {
        var e = this;
        $(".index_inner div").bind(itap_event, function () {
            var a = $(this), t = a.find("span:first-child").html();
            a.addClass("active").siblings("div").removeClass("active"), e.filter_scroll.scrollToElement($("#" + t)[0], 200)
        })
    }, create_params: function () {
        var e = {
            where: {},
            values: {}
        }, a = ["brand_id", "target", "category1_id", "category2_id", "category3_id", "measure", "price", "color"], t = this;
        $.each(this.filter.select, function (i, s) {
            $.isEmptyObject(s) && delete t.filter.select[i], a.indexOf(i) > -1 ? (e.where[i] = [], "price" == i ? $.each(s, function (a, t) {
                e.where[i].push({gteq: a.split("-")[0], lteq: a.split("-")[1]}), t.show = !0
            }) : "color" == i || "measure" == i ? $.each(s, function (a, t) {
                e.where[i].push(decodeURIComponent(t.name)), t.show = !0
            }) : $.each(s, function (a, t) {
                e.where[i].push(t.id), t.show = !0
            })) : (e.values[i] = [], $.each(s, function (a, t) {
                e.values[i].push(t.id), t.show = !0
            }))
        }), "" != $.param(e) ? this.deeplink.current = this.deeplink.init + "&" + $.param(e) : delete this.filter.select[this.filter.option_id]
    }, create_params_: function () {
        var e = {
            where: {},
            values: {}
        }, a = ["brand_id", "target", "category1_id", "category2_id", "category3_id", "measure", "price", "color"], t = this;
        $.each(this.filter.select, function (i, s) {
            a.indexOf(i) > -1 && i != t.filter.option_id ? (e.where[i] = [], "price" == i ? $.each(s, function (a) {
                e.where[i].push({gteq: a.split("-")[0], lteq: a.split("-")[1]})
            }) : "color" == i || "measure" == i ? $.each(s, function (a, t) {
                e.where[i].push(decodeURIComponent(t.name)), t.show = !0
            }) : $.each(s, function (a, t) {
                e.where[i].push(t.id)
            })) : i != t.filter.option_id && (e.values[i] = [], $.each(s, function (a, t) {
                e.values[i].push(t.id)
            }))
        }), this.deeplink.current = this.deeplink.init + "&" + $.param(e)
    }, filter_confirm: function (e) {
        var a, t = this;
        a = -1 != window.location.search.indexOf("from=ulife_app") ? "&from=ulife_app" : "", e.unbind().bind(itap_event, function (e) {
            e.preventDefault(), e.stopPropagation(), app.iscroll.enable(), $(".filter_none_txt").addClass("hide");
            var i = $(this);
            if (i.addClass("push"), setTimeout(function () {
                    i.removeClass("push")
                }, 300), t.deeplink.go_href) {
                var s = [], n = ["brand_id", "target", "category1_id", "category2_id", "category3_id", "measure", "price", "color"], r = "";
                $.each(t.filter.select, function (e) {
                    n.indexOf(e) > -1 ? s.push(e) : -1 == s.indexOf("values") && s.push("values")
                }), t.create_params();
                var o = t.deeplink.current;
                "" != s.join(",") && (o = o + "&filter=" + s.join(",")), $(".array_box").attr("data-params", o), r = t.deeplink.pathname.indexOf("?") == t.deeplink.pathname.length - 1 ? t.deeplink.pathname + o + a : t.deeplink.pathname + "&" + o + a, decodeURIComponent(r) != decodeURIComponent(window.location.pathname + window.location.search) ? window.location.href = r : t.deeplink.current = o, $("#filter_layer").removeClass("appear").addClass("hide")
            } else $(".filter_main").removeClass("has_index"), $("#filter_layer .title").removeClass("filter"), $("#filter_layer .title").html("<p>\u7b5b\u9009</p><p class='ellipsis'></p>"), $(".filter_main .content").children().remove(), $(".brand_index").remove(), $("#loading").removeClass("hide"), t.create_params(), t.get_pros(function () {
                i.removeClass("push"), t.deeplink.go_href = !0, t.filter_init()
            })
        })
    }, filter_html: function () {
        var e = {
            target: "\u6027\u522b",
            category1_id: "\u5206\u7c7b",
            category2_id: "\u5206\u7c7b",
            category3_id: "\u5206\u7c7b",
            brand_id: "\u54c1\u724c",
            price: "\u4ef7\u683c",
            measure: "\u5c3a\u7801",
            color: "\u989c\u8272"
        }, a = this, t = a.filter.current, i = "", s = this.filter.select, n = !1;
        $.each(t, function (a, t) {
            var r = "\u6240\u6709";
            if (s && s[t.name] && "color" != t.name) {
                var o = [];
                $.each(s[t.name], function (e) {
                    n = !0, o.push(e)
                }), r = decodeURIComponent(o.join("\u3001")), "" == r && (r = "\u6240\u6709"), i += "<div class='filter_item border_1px' data-id='" + t.name + "'><span class='right enter_ico sprites'></span><p class='choose ellipsis right'>" + r + "</p><div class='riddling_name left'>" + (e[t.name] ? e[t.name] : t.name) + "</div></div>"
            } else if (s && s[t.name] && "color" == t.name) {
                var d = "", l = 0, c = parseInt(DeviceInfo.width / 54) - 1;
                $.each(s[t.name], function (e, a) {
                    l > c || (l++, n = !0, d += "<p class='color color_circle left " + a.id + "' data-name='" + e + "'>")
                }), l > 3 && (d += "<p class='ellipsis color right'>...</p>"), i += "<div class='filter_item border_1px' data-id='" + t.name + "'><span class='right enter_ico sprites'></span><div class='more_color right " + (l > 3 ? "overstep" : "") + "'>" + d + "</div><div class='riddling_name left'>" + (e[t.name] ? e[t.name] : t.name) + "</div></div>"
            } else i += "<div class='filter_item border_1px' data-id='" + t.name + "'><span class='right enter_ico sprites'></span><p class='choose ellipsis right'>" + r + "</p><div class='riddling_name left'>" + (e[t.name] ? e[t.name] : t.name) + "</div></div>"
        }), $("#loading").addClass("hide"), n ? $(".filter_layer .cancel_ico").removeClass("push") : $(".filter_layer .cancel_ico").addClass("push"), "" == i ? ($(".filter_layer .cancel_ico").removeClass("push"), $(".filter_none_txt").removeClass("hide").css("margin-top", (DeviceInfo.height - 71) / 2 + "px")) : ($(".filter_none_txt").addClass("hide"), $(".filter_main .content").append(i))
    }, category_html: function (e) {
        function a(e) {
            t += "<div class='filter_item border_1px " + e.active + "' data-params='" + e.value + "' data-id='" + e.id + "'><div class='riddling_name left ellipsis'><span class='right_ico sprites left'></span>" + e.value + "</div><span class='amount right'>" + e.count + "\u4ef6</span></div>"
        }

        var t = "", i = this.filter.select[this.filter.option_id];
        if ($.isArray(e) && e.length > 1)for (var s in e) {
            i && i[e[s].name] && (i[e[s].name].show = !1);
            var n = {
                id: e[s].id,
                value: e[s].name,
                count: e[s].count,
                active: i && i[e[s].name] ? i[e[s].name].active : ""
            };
            a(n)
        } else $(".filter_none_txt").removeClass("hide"), t = "";
        return t
    }, brand_html: function (e) {
        function a(e, a) {
            var t = e.initial.toLowerCase()[0], i = a.initial.toLowerCase()[0];
            return t > i ? 1 : i > t ? -1 : e.order > a.order ? -1 : e.order < a.order ? 1 : 0
        }

        function t(e) {
            n += "<div class='filter_item border_1px " + e.active + "' data-params='" + e.value + "' data-id='" + e.id + "' id='" + e.initial + "'><div class='riddling_name left ellipsis'><span class='right_ico sprites left'></span>" + e.value + "</div><span class='amount right'>" + e.count + "\u4ef6</span></div>"
        }

        views.filter_style();
        var i = [], s = [], n = "", r = "", o = [], d = this.filter.select[this.filter.option_id], l = [];
        if ($.isArray(e) && e.length > 1) {
            for (var c in e)i.push(e[c]), d && d[e[c].name] && (d[e[c].name].show = !1);
            i = i.sort(a);
            for (var c in i) {
                s.push(i[c].initial);
                var p = {
                    id: i[c].id,
                    initial: i[c].initial,
                    value: i[c].name,
                    count: i[c].count,
                    active: d && d[i[c].name] ? d[i[c].name].active : ""
                };
                t(p)
            }
            if (n = "<div class='brand_content'>" + n + "</div>", l.push(n), o = s.join(",").match(/([^,]+)(?!.*,\1(,|$))/gi), null !== o && o.length >= 5 && i.length > 20) {
                for (var h = [0, 0, 0, 0, 0], u = 0, _ = 0, v = [], c = 0; c < o.length; c++)h[u] += 1, u = (u + 1) % 5;
                u = 0;
                for (var c in h)_ += h[c], v.push(o.slice(u, _)), u += parseInt(h[c]);
                var r = "";
                for (var c in v) {
                    var f = "";
                    for (var m in v[c])f += 0 == m ? "<span>" + v[c][m] + "</span>" : "<span>" + v[c][m] + "</span>";
                    var g = (DeviceInfo.height - 70 - 13 * o.length) / (v.length - 1);
                    r += "<div style='margin-top:" + g + "px;'>" + f + "</div>"
                }
                r = "<div class='brand_index' data-length='" + v.length + "' data-letters='" + o.length + "'><div class='index_inner'>" + r + "</div></div>"
            }
            return r ? (l.push(r), l) : n
        }
        return $(".filter_none_txt").removeClass("hide"), n = ""
    }, color_html: function (e) {
        function a(e) {
            i += "<div class='color filter_item border_1px " + e.active + "' data-params='" + e.value + "' data-id='" + e.id + "'><div class='riddling_name left ellipsis'><span class='right_ico sprites left'></span><span class='" + e.id + " color_circle left'></span>" + e.value + "\u8272</div><span class='amount right'>" + e.count + "\u4ef6</span></div>"
        }

        var t = {
            "\u767d": "white",
            "\u68d5": "palm",
            "\u6a59": "orange",
            "\u7070": "grey",
            "\u7c89": "pink",
            "\u7d2b": "purple",
            "\u7ea2": "red",
            "\u7eff": "green",
            "\u84dd": "blue",
            "\u9ec4": "yellow",
            "\u9ed1": "black",
            "\u94f6": "silver",
            "\u5f69": "colorful"
        }, i = "", s = this.filter.select[this.filter.option_id];
        if ($.isArray(e) && e.length > 1)for (var n in e) {
            s && s[e[n].value] && (s[e[n].value].show = !1);
            var r = {
                value: e[n].value,
                id: t[e[n].value],
                count: e[n].count,
                active: s && s[e[n].value] ? s[e[n].value].active : ""
            };
            a(r)
        } else $(".filter_none_txt").removeClass("hide"), i = "";
        return i
    }, price_html: function (e) {
        function a(e) {
            t += "<div class='filter_item border_1px " + e.active + "' data-params='" + e.value + "' data-id='" + e.value + "' id='" + e.value + "'><div class='riddling_name left ellipsis'><span class='right_ico sprites left'></span>" + e.value + "</div><span class='amount right'>" + e.count + "\u4ef6</span></div>"
        }

        var t = "", i = this.filter.select[this.filter.option_id];
        if ($.isArray(e) && e.length > 1)for (var s in e) {
            i && i[e[s].value.join("-")] && (i[e[s].value.join("-")].show = !1);
            var n = {
                value: e[s].value.join("-"),
                count: e[s].count,
                active: i && i[e[s].value.join("-")] ? i[e[s].value.join("-")].active : ""
            };
            a(n)
        } else $(".filter_none_txt").removeClass("hide"), t = "";
        return t
    }, value_html: function (e) {
        function a(e) {
            t += "<div class='filter_item border_1px " + e.active + "' data-params='" + e.value + "' data-id='" + e.value + "'><div class='riddling_name left ellipsis'><span class='right_ico sprites left'></span>" + e.value + "</div><span class='amount right'>" + e.count + "\u4ef6</span></div>"
        }

        var t = "", i = this.filter.select[this.filter.option_id];
        if ($.isArray(e) && e.length > 1)for (var s in e) {
            i && i[e[s].value] && (i[e[s].value].show = !1);
            var n = {value: e[s].value, count: e[s].count, active: i && i[e[s].value] ? i[e[s].value].active : ""};
            a(n)
        } else $(".filter_none_txt").removeClass("hide"), t = "";
        return t
    }, measure_html: function (e) {
        function a(e, a) {
            var t, i, s = ["XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL", "XXXXL"];
            if (isNaN(Number(e.value))) {
                if (!(s.indexOf(e.value) > -1))return 0;
                t = s.indexOf(e.value), i = s.indexOf(a.value)
            } else t = Number(e.value), i = Number(a.value);
            return i > t ? -1 : t > i ? 1 : 0
        }

        function t(e) {
            i += "<div class='filter_item border_1px " + e.active + "' data-params='" + e.value.replace(/\'/g, "%27") + "' data-id='" + e.value.replace(/\'/g, "%27") + "'><div class='riddling_name left ellipsis'><span class='right_ico sprites left'></span>" + e.value.replace(/\%27/g, "'") + "</div><span class='amount right'>" + e.count + "\u4ef6</span></div>"
        }

        if ($.isArray(e) && e.length > 1) {
            e.sort(a);
            var i = "", s = this.filter.select[this.filter.option_id];
            for (var n in e) {
                s && s[e[n].value.replace(/\'/g, "%27")] && (s[e[n].value.replace(/\'/g, "%27")].show = !1);
                var r = {
                    value: e[n].value,
                    count: e[n].count,
                    active: s && s[e[n].value.replace(/\'/g, "%27")] ? s[e[n].value.replace(/\'/g, "%27")].active : ""
                };
                t(r)
            }
        } else $(".filter_none_txt").removeClass("hide"), i = "";
        return i
    }, target_html: function (e) {
        function a(e) {
            t += "<div class='filter_item border_1px " + e.active + "' data-params='" + e.value + "' data-id='" + e.value + "'><div class='riddling_name left ellipsis'><span class='right_ico sprites left'></span>" + e.value + "</div><span class='amount right'>" + e.count + "\u4ef6</span></div>"
        }

        var t = "", i = this.filter.select[this.filter.option_id];
        if ($.isArray(e) && e.length > 1)for (var s in e) {
            i && i[e[s].value] && (i[e[s].value].show = !1);
            var n = {value: e[s].value, count: e[s].count, active: i && i[e[s].value] ? i[e[s].value].active : ""};
            a(n)
        } else $(".filter_none_txt").removeClass("hide"), t = "";
        return t
    }, change_scan: function (e) {
        var a = this;
        e.bind(itap_event, function () {
            $("#array_fixed").addClass("hide");
            var t = (app.iscroll, 0), i = 0;
            i = e.hasClass("large") ? Math.round((-app.iscroll.y - a.brand_height) / a.pro_height / 2) : 2 * Math.round((-app.iscroll.y - a.brand_height) / a.pro_height), e.toggleClass("large"), $(".products_content").children().remove(), setTimeout(function () {
                if ($(".products_content").toggleClass("big_mode"), e.hasClass("large")) {
                    dex = .75, a.pro_height = parseInt(DeviceInfo.width * dex) + 79, a.scan_mode = "large";
                    try {
                        window.localStorage.setItem("scan_mode", "large")
                    } catch (s) {
                    }
                } else {
                    dex = .344, a.pro_height = parseInt(DeviceInfo.width * dex) + 79, a.scan_mode = "small";
                    try {
                        window.localStorage.setItem("scan_mode", "small")
                    } catch (s) {
                    }
                }
                t = i * a.pro_height + a.brand_height, a.pro_css(), a.change_height(), views.product_style(dex), -1 * app.iscroll.y <= $(".brand_information").height() ? a.get_products(0, a.show_pros()) : app.iscroll.scrollTo(0, -t, 200)
            }, 10)
        })
    }, order_event: function (e, a) {
        var t, i = this;
        t = -1 != window.location.search.indexOf("from=ulife_app") ? "&from=ulife_app" : "", 0 == $(".array_item.active").length && $($(".array_item")[0]).addClass("active"), e.bind(itap_event, function () {
            e.toggleClass("push"), $("#array_fixed").toggleClass("hide")
        }), a.bind(itap_event, function () {
            var e, a = $(this), s = a.data("params"), n = (a.find("p").html(), $(".array_item.active").data("params"));
            a.addClass("push").addClass("active"), a.siblings().removeClass("active"), setTimeout(function () {
                a.removeClass("push")
            }, 200), $("#array_fixed").toggleClass("hide"), i.deeplink.current = i.deeplink.current.replace(n, ""), i.filter.sort = s, i.deeplink.current += i.filter.sort, e = i.deeplink.pathname.indexOf("?") == i.deeplink.pathname.length - 1 ? i.deeplink.pathname + i.deeplink.current + t : i.deeplink.pathname + "&" + i.deeplink.current + t, 0 != $(".down_page.right").length && $(".down_page.right").attr("data-href", e).removeClass("disabled"), window.location.href = e
        }), $("#array_fixed").bind("click touchstart", function (e) {
            e.preventDefault(), e.stopPropagation()
        })
    }, scroll_load: function () {
        var e = this;
        app.iscroll.on("scrollEnd", function () {
            var a = -this.y;
            position = "large" == e.scan_mode ? Math.round((a - e.total_height) / e.pro_height) + e.show_pros() : 2 * Math.round((a - e.total_height) / e.pro_height) + e.show_pros(), position - e.show_pros() >= 0 && e.get_products(position - e.show_pros(), position)
        })
    }, pro_css: function () {
        var e = "", a = this.ids.length, t = this.scan_mode;
        if (a / 2 != 0 && (a += 1), "small" == t)for (var i = 1; a >= i; i++)e = i % 2 != 0 ? e + ".id_" + i + "{top:" + parseInt(i / 2) * this.pro_height + "px}" : e + ".id_" + i + "{top:" + parseInt(i / 2 - 1) * this.pro_height + "px;}"; else for (var i = 1; a >= i; i++)e = e + ".id_" + i + "{top:" + parseInt(i - 1) * this.pro_height + "px}";
        var s = ['<style id="pro_index_css" type="text/css">', e, "</style>"];
        null == document.getElementById("pro_index_css") ? $("head").append(s.join(" ")) : document.getElementById("pro_index_css").innerHTML = e
    }, lasy_load: function (e) {
        var a = ($(e), "large" == this.scan_mode ? .75 : .344), t = parseInt(DeviceInfo.width * a);
        get_cookie("ratio") && (t *= get_cookie("ratio")), $.each(e, function (e, a) {
            if ("" == $(a).attr("src")) {
                var i = app.pic($(a).data("src"), t), s = new Image;
                $(s).bind("load", function () {
                    $(a).attr("src", i).addClass("pro_width pro_height"), $(a).parent("div").addClass("pro_width pro_height loaded")
                }).bind("error", function () {
                    $(a).complete && ($(a).addClass("pro_width pro_height"), $(a).parent("div").addClass("pro_width pro_height failed"))
                }), s.src = i
            }
        })
    }, get_products: function (e, a) {
        e - 2 >= 0 && (e -= 2), a + 2 <= this.ids.length && (a += 2);
        var t = this, i = [], s = e, n = [];
        for (var r in this.ids.slice(e, a))s++, 0 == $(".id_" + s).length && (n.push(s), i.push(this.ids.slice(e, a)[r]));
        var o = decodeURIComponent(window.location.search).indexOf("from=ulife_app") > -1 ? !0 : !1, d = o ? "ulife_price_pro" : "", l = o ? "" : "\uffe5";
        if (i.length > 0) {
            var c = "", p = "", h = "<p class='pro_prefix pro_width ellipsis'></p>";
            for (var r in i) {
                p = n[r] % 2 == 0 ? "<div class='pro_width right product id_" + n[r] +
                "'><div class='wrap_110 img_wrap pro_img pro_width pro_height right'><img class='pro_width pro_height' data-src=''></div>" +
                "<p class='products_name ellipsis pro_width right'></p><span class='products_price " + d + " clear_fix pro_width right'></span>" + h + "<em></em>" +
                "<div class='down_shadow'></div></div>" : "<div class='pro_width left product id_" + n[r] +
                "'><div class='wrap_110 img_wrap pro_img pro_width pro_height'><img class='pro_width pro_height' data-src=''></div>" +
                "<p class='products_name ellipsis pro_width'></p><span class='products_price " + d + " clear_fix pro_width'></span>" + h + "<em></em><div class='down_shadow'></div></div>",
                    c += p
            }
            $(".products_content").addClass("products_list").append(c), app.push_event($(".products_content .product"), 100), products.get_info(i.join(","), function (e) {
                for (var a in e) {
                    var i = n[a];
                    if ("" != $.trim(e[a].prefix) && $(".id_" + i).find(".pro_prefix").html("\u3010" + e[a].prefix + "\u3011"), e[a].label && e[a].location_id && 1 != e[a].location_id) {
                        var s = "<div class='xgzy'>" + e[a].label + "</div>";
                        $(".id_" + i + " .img_wrap").prepend(s)
                    }
                    $(".id_" + i).data("href", "/products/" + e[a].id), $(".id_" + i).find("img").attr("data-src", e[a].major_pic_url), $(".id_" + i).find(".products_name").html(e[a].name), $(".id_" + i).find(".products_price").html(l + e[a].discount + "<em class='ele_logo'></em>"), $(".id_" + i).find("em").html(e[a].id), $(".id_" + i).find(".ele_logo").html("")
                }
                t.lasy_load($(".product img"), !1)
            })
        }
    }, change_height: function () {
        var e = 0;
        0 != this.ids.length && ("large" == this.scan_mode ? (e = this.pro_height * this.ids.length, $(".products_content").height(e)) : (e = this.pro_height * Math.round(this.ids.length / 2), $(".products_content").height(e)), app.iscroll.refresh())
    }, show_pros: function () {
        var e = Math.ceil(this.height / this.pro_height);
        return "large" == this.scan_mode ? e : 2 * e
    }, get_mode: function () {
        if ("" != document.cookie) {
            if (null == window.localStorage.getItem("scan_mode"))try {
                window.localStorage.setItem("scan_mode", "small")
            } catch (e) {
                return !1
            }
            return window.localStorage.getItem("scan_mode")
        }
    }
}, trades_new_controller = {
    initialize: function (e, a, t) {
        $(".pay_layer .down_pay").addClass("hide");
        var i = this;
        i.ulife = $(".order_form").data("ulife"), i.hwg = $(".order_form").data("hwg"), i.needelivery = !i.hwg && $(".order_form").data("needelivery"), i.delivery = $(".order_form").data("delivery"), $("#nav").addClass("hide"), i.select_paymode($(".pay_select .pay")), i.init(t), this.gene = this.get_gene(), "true" === i.ulife || "true" === i.hwg || (i.auto_choose(), trades_paymode_controller.paymode_event($(".mode_pay"), $(".pay_other"), i.needelivery, i.delivery)), this.person_address($(".receive_info")), this.input_events($(".idcard input"), 18), this.clear_txt($(".clear_txt"));
        var s = navigator.userAgent.toLowerCase();
         "micromessenger" == s.match(/MicroMessenger/i) ? $(".wechat_pay").removeClass("hide")  && $(".zhifubao").addClass("hide") :  $(".wechat_pay").addClass("hide");
          e.submit(function (e) {
            if (e.preventDefault(), !a.hasClass("push") && !a.hasClass("disabled")) {
              if (a.addClass("push"), $(".empty_address").length > 0)return alert("\u8bf7\u5148\u6dfb\u52a0\u6536\u8d27\u5730\u5740\u4fe1\u606f"), a.removeClass("push"), !1;
              if (i.hwg && $(".idcard input").val().length < 18)return alert($.trim($(".idcard input").val()) ? "\u8eab\u4efd\u8bc1\u53f7\u7801\u683c\u5f0f\u9519\u8bef" : "\u8bf7\u586b\u5199\u8eab\u4efd\u8bc1\u53f7\u7801"), a.removeClass("push"), !1;
              var t = $("#paymode");
              if ($(".online_pay").hasClass("active")) {
                var s = "\u62db\u5546\u94f6\u884c" == $(".online_pay.active p").html() ? "cmbchina" : "alipay";
                t.val(s)
              }
              self.hwg && null === $(".idcard input").attr("readonly") ? i.save_addr() : i.create_trade()
            }
          }), a.bind(click_event, function () {
            e.submit()
          }), app.layer($(".pay_layer")), this.later_handle($(".ignore_order")), this.resubmit($(".re_submit_order"), e), this.add_address($(".empty_address"))
    }, input_events: function (e, a) {
        e.bind("input", function () {
            var e = $(this), t = $.trim(e.val());
            t.length > a && e.val(t.slice(0, a)), e.next().hasClass("clear_txt") && e.next().toggleClass("hide", "" == t)
        }), e.bind("focus", function () {
            var e = $(this), t = $.trim(e.val());
            t.length > a && e.val(t.slice(0, a)), e.next().hasClass("clear_txt") && e.next().toggleClass("hide", "" == t)
        }), e.bind("blur", function () {
            {
                var e = $(this);
                $.trim(e.val())
            }
            e.next().hasClass("clear_txt") && e.next().addClass("hide")
        })
    }, clear_txt: function (e) {
        e.bind(itap_event, function () {
            $(this).prev().val(""), $(this).next().addClass("hide"), $(this).addClass("hide")
        })
    }, add_address: function (e) {
        if (e.length > 0) {
            var a = $("#address_layer");
            a.removeClass("hide"), a.css("height", DeviceInfo.height), $("#address_layer").css("-webkit-transform", "translate(0,0)"), a.addClass("appear")
        }
        e.bind(itap_event, function () {
            var e = $("#address_layer");
            e.removeClass("hide"), app.layer_appear(e)
        })
    }, save_addr: function () {
        var e = [], a = this;
        $(".order_form").serialize().split("&").forEach(function (a) {
            -1 != decodeURIComponent(a).indexOf("trade[contact]") && e.push(a)
        }), e = e.join("&"), contacts.save(e, a.create_trade)
    }, create_trade: function () {
        var e = this;
        $("#trade_client").val("true" === get_cookie("wechat") ? "wechat" : "phone_web");
        var a = $(".order_form").serialize();
        e.hwg || "true" !== e.needelivery || (a = a + "&trade[delivery_price]=" + e.delivery), trade.create(a, function (a) {
            if ($.isEmptyObject(a) || a.error)$(".submit_order").removeClass("push"), $("#fail_orderlayer h1").html("<span class='sprites fail_ico'></span>\u62b1\u6b49\uff0c\u8ba2\u5355\u63d0\u4ea4\u5931\u8d25"), $("#fail_orderlayer").removeClass("hide"); else {
                var t = $(".pay_select .pay.active p").html(), i = {
                    "\u62db\u5546\u94f6\u884c": "cmbchina",
                    "\u652f\u4ed8\u5b9d": "alipay",
                    "\u5fae\u4fe1": "wechat"
                }, s = function () {
                    if (e.hwg)$(".submit_order").removeClass("push"), window.location.href = 0 == a.payment_price ? "/trades/" + a.id + "?paymode=no_payment" : "/trades/" + a.id + "?paymode=alipay";
                    else if (i[t])$(".submit_order").removeClass("push"), window.location.href = 0 === a.payment_price && "true" === e.ulife ? "/trades/" + a.id + "?paymode=no_payment" : "/trades/" + a.id + "?paymode=" + i[t]; else if ("\u8d27\u5230\u4ed8\u6b3e" == t)0 == a.payment_price ? window.location.href = "/trades/" + a.id + "?paymode=no_payment" : trade._express_pay(a.id, function (e) {
                        window.location.href = e ? "/trades/" + a.id + "?paymode=express_success" : "/trades/" + a.id + "?paymode=express_failed", $(".submit_order").removeClass("push")
                    }); else {
                        $(".submit_order").removeClass("push");
                        var s = "";
                        "true" === e.ulife && (s = "?paymode=no_payment"), window.location.href = "/trades/" + a.id + s
                    }
                };
                "true" === e.ulife ? (app.clear_cookie("ulife"), s()) : s()
            }
        })
    }, resubmit: function (e, a) {
        e.bind(itap_event, function () {
            var e = $(this);
            e.hasClass("push") || (e.addClass("push"), a.submit(), setTimeout(function () {
                e.removeClass("push")
            }, 500))
        })
    }, later_handle: function (e) {
        e.bind(itap_event, function () {
            var e = $(this);
            e.addClass("push"), setTimeout(function () {
                e.removeClass("push"), $("#fail_orderlayer").addClass("hide"), $("#fail_url").addClass("hide")
            }, 100)
        })
    }, person_address: function (e) {
        if (!($(".empty_address").length > 0)) {
            var a = this;
            e.bind(itap_event, function () {
                $(".receive_info").addClass("push"), url = "true" === a.ulife ? "/contacts?from=ulife" : "true" === a.hwg ? "/contacts?from=hwg" : "/contacts", window.location.href = url
            })
        }
    }, select_paymode: function (e) {
        var a = this;
        $(e).bind(itap_event, function () {
            if (!$(".add_cart").hasClass("push")) {
                {
                    var e = $(this), t = $("#pay_layer");
                    t.find(".pay_body")
                }
                if (e.hasClass("online_pay"))trades_paymode_controller.show_layer(); else {
                    var i = "\u514d\u8fd0\u8d39";
                    "true" === a.needelivery && (i = "\u542b\u8fd0\u8d39\uffe5" + a.delivery), e.hasClass("mode_pay") ? $(".payment_mode_txt").html(e.data("name") + '\u652f\u4ed8<span class="transport_free">\uff08' + i + "\uff09</span>") : ($("#pay_layer").addClass("hide"), $(".online_pay p").html("\u5728\u7ebf\u652f\u4ed8"), $(".mode_pay").removeClass("active"), $(".payment_mode_txt").html('\u8d27\u5230\u4ed8\u6b3e<span class="transport_free">\uff08' + i + "\uff09</span>"))
                }
                e.addClass("active").siblings().removeClass("active")
            }
        })
    }, auto_choose: function () {
        function e(e, a) {
            var t = [];
            return $.each(e, function (e, i) {
                var s = $(i).data("value"), n = $(i).data("name");
                if ("none" != n)if ("voucher" == n) {
                    var r = a - s;
                    0 > r && (r = 0), t.push({
                        name: n,
                        value: $(i).attr("value"),
                        price: r,
                        html: $(i).html(),
                        params: $(i).attr("name"),
                        position: e
                    })
                } else {
                    var r = parseInt(a - a * s * .01);
                    t.push({
                        name: n,
                        value: $(i).attr("value"),
                        price: r,
                        html: $(i).html(),
                        params: $(i).attr("name"),
                        position: e
                    })
                }
            }), t = t.sort(function (e, a) {
                return e.price - a.price
            }), total_price += t[0].price, t[0]
        }

        function a(e, a) {
            var t = [];
            return $.each(e, function (e, i) {
                var s = $(i).data("value"), n = $(i).data("name");
                if ("none" != n && "multibuy" == n) {
                    s /= 0 == parseInt(s / 10) ? 10 : 100;
                    var r = parseInt(a * s);
                    t.push({
                        name: n,
                        value: $(i).attr("data-value"),
                        price: r,
                        html: $(i).html(),
                        params: $(i).attr("name"),
                        position: e
                    })
                }
            }), t = t.sort(function (e, a) {
                return a.price - e.price
            }), total_price += t[0].price, t[0]
        }

        function t(e) {
            var a = [];
            return $.each(e, function (e, t) {
                var i = $(t).data("value"), s = $(t).data("name");
                if ("none" != s)if ("voucher" == s) {
                    var n = d - i;
                    0 > n && (n = 0), a.push({
                        name: s,
                        value: $(t).attr("value"),
                        price: n,
                        html: $(t).html(),
                        params: $(t).attr("name"),
                        position: e
                    })
                } else {
                    var n = parseInt(d - d * i * .01);
                    a.push({
                        name: s,
                        value: $(t).attr("value"),
                        price: n,
                        html: $(t).html(),
                        params: $(t).attr("name"),
                        position: e
                    })
                }
            }), a = a.sort(function (e, a) {
                return e.price - a.price
            }), total_price += a[0].price, a[0]
        }

        function i(e, a) {
            $(".money").html("\uffe5" + total_price), a.attr("data-discount", e.price), a.attr("data-" + e.name, e.value), a.find(".bag_price").addClass("used"), a.find(".discount").addClass("active"), a.find("select").attr("name", e.params), a.find("select option")[e.position].selected = !0, a.find(".now_price").removeClass("hide").html("\uffe5" + e.price), $(a.find(".discount p")[0]).html('<span class="sprites s_add_ico left"></span><span class="ellipsis">' + e.html + "</span>"), n.price_update($(".order_product"))
        }

        var s = $("#user_info").data("level-id"), n = this;
        if (pro_num = $(".order_product.usable").length, total_price = 0, "true" === n.needelivery && (total_price = parseInt(n.delivery)), 1 == pro_num) {
            var r = $(".order_product.usable"), o = r.find("select option"), d = r.data("price"), l = r.data("multibuy-id"), c = $(".trade_m" + l).length;
            o.length > 1 && (l && c > 1 ? i(a(o, d), r) : i(t(o, d), r))
        } else pro_num > 1 && s > 1 ? $.each($(".order_product.usable"), function (t, s) {
            var n = $(s), r = n.find("select option"), o = n.data("price"), d = $(s).data("multibuy-id"), l = $(".trade_m" + d).length;
            r.length > 1 && (d && l > 1 ? i(a(r, o), n) : i(e(r, o), n))
        }) : pro_num > 1 && 1 == s && $.each($(".order_product.usable"), function (e, t) {
            var s, n = $(t), r = n.data("price"), o = $(t).data("multibuy-id"), d = $(".trade_m" + o).length;
            o && d > 1 ? (s = n.find("select option"), i(a(s, r), n)) : (s = n.find(".discount > p"), s.html('<span class="sprites s_add_ico left"></span><span class="ellipsis">\u9009\u62e9\u6298\u6263</span>'))
        })
    }, get_gene: function () {
        return 1 * $("#user_info").data("point")
    }, get_voucher: function () {
        var e = $(".user_msg").find(".voucher.usable"), a = {};
        return e.each(function (e, t) {
            var i = $(t), s = {
                id: i.data("id"),
                limitation: i.data("event-limitation"),
                amount: i.data("event-amount"),
                end: i.data("ended-at"),
                selected: !1
            };
            a[i.data("id")] = s
        }), a
    }, get_mall: function () {
        var e = $(".malls"), a = {};
        return e.each(function (e, t) {
            var i = $(t), s = {id: i.data("id"), percent: 1 * i.data("percent"), name: i.data("name")};
            a[i.data("id")] = s
        }), a
    }, get_vip: function () {
        var e = $("#user_info");
        return e.data("auction-user-percent") || e.data("auction-user-level-percent") || 0
    }, gene_option: function (e) {
        var a = [], t = this.get_gene(), i = '<option name="units[][percent]" data-name="gene" value="5" data-value="5">5000\u57fa\u56e0\u503c\u51cf5%</option>', s = '<option name="units[][percent]" data-name="gene" value="10" data-value="10">10000\u57fa\u56e0\u503c\u51cf10%</option>';
        return e && (t += 1e3 * e.data("gene")), t >= 5e3 && 1e4 > t ? a.push(i) : t >= 1e4 && (a.push(i), a.push(s)), a.join("")
    }, voucher_option: function (e) {
        var a = "", t = this.get_voucher();
        return $.each(t, function (t, i) {
            e >= 1 * i.limitation && !i.selected && (a += '<option name="units[][voucher_id]" data-name="voucher" value="' + i.id + '" data-value="' + i.amount + '">\u6ee1' + i.limitation + "\u51cf" + i.amount + "</option>")
        }), a
    }, vip_option: function (e) {
        var a = this, t = a.get_vip(), i = a.get_mall();
        if (0 != t ) {
            var s = t
            return parseInt(s) > 0 ? '<option name="units[][percent]" data-name="vip" value="' + s + '" data-value="' + s + '">\u4f7f\u7528vip\u6298\u6263\u51cf' + s + "%</option>" : ""
        }
        return ""
    }, multibuy_option: function (e) {
        if (e) {
            var a, t = $("#trade_multibuyid" + e), i = $(".trade_m" + e), s = i.length, n = function (t, i, s) {
                return percent = 100 - $("#trade_multibuy" + e).data(s), percent % 10 == 0 && (percent /= 10), a = '<option name="units[][multibuy_id]" data-name="multibuy" value="' + e + '" data-value="' + percent + '">\u8fde\u62cd\u6d3b\u52a8' + i + "\u4ef6" + percent + "\u6298\u4f18\u60e0</option>"
            };
            return 2 == s ? n(t, s, "two") : 3 == s ? n(t, s, "three") : s > 3 ? n(t, s, "four") : ""
        }
        return ""
    }, price_update: function (e) {
        var a = discount = 0;
        "true" === this.needelivery && (a = discount = parseInt(this.delivery)), $(e).each(function () {
            discount += 1 * $(this).data("discount"), a += 1 * $(this).data("price")
        }), a !== discount ? $(".derate").html("\u5df2\u51cf\u514d\uffe5" + (a - discount)).addClass("active") : $(".derate").html("\u5df2\u51cf\u514d\uffe5" + (a - discount)).removeClass("active"), 0 > discount && (discount = 0), $(".money").html("\uffe5" + discount)
    }, select_reset: function (e, a, t, i, s, n) {
        var r = this, o = r.get_gene(), d = r.get_voucher(), l = $(".order_product"), c = 0;
        $.each(l, function (e, a) {
            c += 1e3 * $(a).data("gene")
        }), $("#user_info").attr("data-point", this.gene - c), $(e).each(function () {
            var e = $(this), l = e.find("select"), c = $(l[0].options[l[0].selectedIndex]), p = "", h = (c.text(), c.data("name")), u = 0, _ = "";
            if (!l.parent().hasClass("hide")) {
                if (0 != l.val() ? 0 != e.data("voucher") ? (_ = r.multibuy_option(e.data("multibuy-id")) + r.vip_option(e.data("mall-id")) + r.gene_option() + r.voucher_option(e.data("price")), u = e.data("voucher"), d[e.data("voucher")] && (d[e.data("voucher")].selected = !1)) : 0 != e.data("gene") ? (o += 1e3 * e.data("gene"), _ = r.multibuy_option(e.data("multibuy-id")) + r.vip_option(e.data("mall-id")) + r.gene_option(e) + r.voucher_option(e.data("price")), u = e.data("gene"), o -= 1e3 * e.data("gene")) : 0 != e.data("vip") ? (u = e.data("vip"), _ = r.multibuy_option(e.data("multibuy-id")) + r.vip_option(e.data("mall-id")) + r.gene_option() + r.voucher_option(e.data("price"))) : e.data("multibuy-id") && (u = c[0].value, _ = r.multibuy_option(e.data("multibuy-id")) + r.vip_option(e.data("mall-id")) + r.gene_option() + r.voucher_option(e.data("price"))) : _ = r.multibuy_option(e.data("multibuy-id")) + r.vip_option(e.data("mall-id")) + r.gene_option() + r.voucher_option(e.data("price")), _) {
                    $.each(e.find(".discount"), function (e, a) {
                        $(a).hasClass("min_price") || $(a).removeClass("disabled")
                    });
                    var v = $(".user_msg").find(".voucher");
                    0 != e.data("voucher") && v.each(function (a, t) {
                        var i = $(t);
                        i.data("id") == e.data("voucher") && (_ = '<option name="units[][voucher_id]" data-name="voucher" value="' + i.data("id") + '" data-value="' + i.data("event-amount") + '">\u6ee1' + i.data("event-limitation") + "\u51cf" + i.data("event-amount") + "</option>" + _)
                    }), _ = '<option name="units[][percent]" data-name="none" value="0">\u9009\u62e9\u6298\u6263</option>' + _, l.html(_)
                } else if (l.parent(".discount").hasClass("active")) {
                    var v = $(".user_msg").find(".voucher");
                    0 != e.data("voucher") && v.each(function (a, t) {
                        var i = $(t);
                        i.data("id") == e.data("voucher") && (_ = '<option name="units[][percent]" data-name="none" value="0">\u9009\u62e9\u6298\u6263</option><option name="units[][voucher_id]" data-name="voucher" value="' + i.data("id") + '" data-value="' + i.data("event-amount") + '">\u6ee1' + i.data("event-limitation") + "\u51cf" + i.data("event-amount") + "</option>", l.html(_))
                    })
                } else l.html("").parent().addClass("disabled");
                if (e.hasClass("trade_m" + a)) {
                    var _, f, m, p = e.find("select"), g = e.data("price"), y = e.find(".bag_price"), C = e.find(".now_price"), b = e.find(".discount");
                    "multibuy" == i ? (p.attr("name", t), f = p.find('option[data-name="' + i + '"][value="' + a + '"]'), f[0].selected = !0, m = parseInt(0 == parseInt(s / 10) ? g * s / 10 : g * s / 100)) : b.find("p span:last-child").text() == n && l.find('option[data-name="' + h + '"][value="' + u + '"]')[0] ? (m = g, p.attr("name", ""), f = p.find('option[data-name=none][value="0"]'), f[0].selected = !0) : l.find('option[data-name="' + h + '"][value="' + u + '"]')[0].selected = !0, f && (m == g ? (b.removeClass("active"), y.removeClass("used"), C.addClass("hide")) : (b.addClass("active"), y.addClass("used"), C.removeClass("hide")), _ = f.text(), $(e.find(".discount p")[0]).html('<span class="sprites s_add_ico left"></span><span class="ellipsis">' + _ + "</span>"), e.attr("data-discount", m), C.html("\uffe5" + m), r.price_update($(".order_product")))
                } else l.find('option[data-name="' + h + '"][value="' + u + '"]')[0] && (l.find('option[data-name="' + h + '"][value="' + u + '"]')[0].selected = !0)
            }
        })
    }, init: function (e) {
        var a = this, t = $(e), i = a.get_gene(), s = a.get_voucher();
        t.each(function (e, n) {
            var r = $(n), o = a.multibuy_option(r.data("multibuy-id")) + a.vip_option(r.data("mall-id")) + a.gene_option() + a.voucher_option(r.data("price"));
            o ? (o = '<option name="units[][percent]" data-name="none" value="0">\u9009\u62e9\u6298\u6263</option>' + o, $("body").hasClass("qq") && r.bind(itap_event, function () {
                $(this).find("p").addClass("hide")
            }), r.find(".discount").children("select").append(o).bind("change", function () {
                function e(e, a, t, i, s, n) {
                    n = Math.floor(n), e.data("voucher", a).data("gene", t).data("vip", i).data("discount", n), 0 != e.data("voucher") && l.each(function (a, t) {
                        var i = $(t);
                        i.data("id") == e.data("voucher") && i.removeClass("usable")
                    })
                }

                var n = $(this), o = $(n[0].options[n[0].selectedIndex]), d = r.data("price"), l = $(".user_msg").find(".voucher");
                if (n.parent().toggleClass("active", 0 != n.val()), 0 == n.val() ? n.attr("name", "") : n.attr("name", o.attr("name")), s[r.data("voucher")] && (l.each(function (e, a) {
                        var t = $(a);
                        t.data("id") == r.data("voucher") && t.addClass("usable")
                    }), s[r.data("voucher")].selected = !1, e(r, n.val(), 0, 0, d)), i += 1e3 * r.data("gene"), "gene" == o.data("name") || "none" == o.data("name"))i -= 1e3 * n.val(), $("#user_info").data("point", i), d = parseInt(r.data("price") * (1 - .01 * n.val())), e(r, 0, n.val(), 0, 0, d); else if ("voucher" == o.data("name"))s[n.val()].selected = !0, d = parseInt(1 * r.data("price") - 1 * o.data("value")), e(r, n.val(), 0, 0, 0, d); else if ("vip" == o.data("name"))d = parseInt(r.data("price") * (1 - .01 * n.val())), e(r, 0, 0, n.val(), 0, d); else if ("multibuy" == o.data("name")) {
                    var c = r.data("multibuy");
                    c /= 0 == parseInt(c / 10) ? 10 : 100, d = parseInt(r.data("price") * c), e(r, 0, 0, 0, n.val(), d)
                }
                n.siblings("p").html('<span class="sprites s_add_ico left"></span><span class="ellipsis">' + o.text() + "</span>"), (r.data("discount") < 0 || 0 == r.data("discount")) && (r.find(".pro_detail span").html("\uffe50"), r.data("discount", 0));
                var p = r.find(".now_price"), h = r.find(".bag_price");
                p.html("\uffe5" + r.data("discount")), r.data("discount") != r.data("price") ? (p.removeClass("hide"), h.addClass("used")) : (p.addClass("hide"), h.removeClass("used")), a.price_update(t), r.find(".discount > p").removeClass("hide");
                var u = r.data("multibuy-id");
                if (num = $(".trade_m" + u).length, 2 > num)a.select_reset(r.siblings()); else {
                    var _ = o.attr("name"), v = o.data("name"), f = parseInt(o.data("value"));
                    data_text = $(n.find('option[data-name="multibuy"]')[0]).text(), a.select_reset(r.siblings(), u, _, v, f, data_text)
                }
            })) : r.find(".discount").addClass("hide")
        })
    }
}, trades_show_controller = {
    initialize: function (e) {
        var a = this;
        trade_id = $("#trade").data("id"), a.get_trade(trade_id, function (a) {
            e(a)
        })
    }, formatDate: function (e) {
        var a = this, t = e.getFullYear(), i = e.getMonth() + 1, s = e.getDate(), n = e.getHours(), r = e.getMinutes(), o = e.getSeconds();
        return i = a.doubleBit(i), s = a.doubleBit(s), n = a.doubleBit(n), r = a.doubleBit(r), o = a.doubleBit(o), t + "-" + i + "-" + s + " " + n + ":" + r + ":" + o
    }, doubleBit: function (e) {
        return 1 > e / 10 && (e = "0" + e), e
    }, get_trade: function (e, a) {
        var t = this;
        trade.get_trade(e, function (e) {
            function i(a, i, s) {
                for (var n = "", r = 0; r < e.units.length; r++) {
                    var o = e.units[r], d = o.item, l = "";
                    if (a && i)l = '<div class="trade_detail_box border_1px clear_fix" data-href="/products/' + d.product.id + '"><div class="left pic_link left pro_height img_wrap pro_width pro_img"><img class="pro_height pro_width" width="60" height="60" data-src="' + d.product.major_pic_url + '"></div><div class="down_shadow"></div><div class="bag_info pro_height right"><p class="bag_name">' + s + '</p><div class="bag_detail"><span class="right bag_price ulife">' + o.price + '<em class="ele_logo"></em></span></div><div class="down_shadow"></div></div></div>'; else {
                        var c = a ? "ulife" : "", p = a ? "" : "\uffe5";
                        l = d.measure ? '<div class="trade_detail_box border_1px clear_fix" data-href="/products/' + d.product.id + '"><div class="left pic_link left pro_height img_wrap pro_width pro_img"><img class="pro_height pro_width" width="60" height="60" data-src="' + d.product.major_pic_url + '"></div><div class="down_shadow"></div><div class="bag_info pro_height right"><p class="bag_name">' + d.product.name + '</p><div class="bag_detail"><span class="bag_size">' + d.measure + '</span><span class="bag_color">' + d.product.color_name + '</span><span class="right bag_price ' + c + '">' + p + o.price + '<em class="ele_logo"></em></span></div><div class="down_shadow"></div></div></div>' : '<div class="trade_detail_box border_1px clear_fix" data-href="/products/' + d.product.id + '"><div class="left pic_link left pro_height img_wrap pro_width pro_img"><img class="pro_height pro_width" width="60" height="60" data-src="' + d.product.major_pic_url + '"></div><div class="down_shadow"></div><div class="bag_info pro_height right"><p class="bag_name">' + d.product.name + '</p><div class="bag_detail"><span class="bag_color">' + d.product.color_name + '</span><span class="right bag_price ' + c + '">' + p + o.price + '<em class="ele_logo"></em></span></div><div class="down_shadow"></div></div></div>'
                    }
                    n += l
                }
                $(".pro_zone").removeClass("hide").html(n), t.lasy_load($("img"))
            }

            function s(a, t) {
                var i, s = a ? "ulife" : "", n = $("#loadingBtn").html(), r = {
                    audit: "\u5f85\u53d1\u8d27",
                    ship: "\u5f85\u53d1\u8d27",
                    prepare: "\u5f85\u53d1\u8d27",
                    complete: "\u5df2\u5b8c\u6210",
                    receive: "\u5f85\u6536\u8d27",
                    cancel: "\u5df2\u53d6\u6d88",
                    freezed: "\u51bb\u7ed3",
                    punished: "",
                    pay: "\u5f85\u4ed8\u6b3e"
                };
                i = "pay" == e.status ? '<div class="trade_pay_btn btn purple_bg right ' + s + '" data-id="' + e.id + '" data-price="' + e.payment_price + '">\u4ed8\u6b3e<div class="down_shadow"></div></div><div class="trade_cancel_btn btn right submit_order" data-id="' + e.id + '"><span>\u53d6\u6d88</span>' + n + "</div>" : "receive" == e.status ? e.delivery_identifier && e.delivery_time ? '<div data-href="/trades/' + e.id + '/delivery" class="trade_express_btn btn right submit_order">\u7269\u6d41<div class="down_shadow"></div></div>' : '<div data-id="' + e.id + '" class="trade_receive_btn btn purple_bg right"><span>\u6536\u8d27</span>' + n + "</div>" : t && "\u5df2\u5b8c\u6210" == r[e.status] ? '<div class="tic_btn right" data-href="/tickets"><span>\u67e5\u770b\u6d88\u8d39\u5238</span><div class="down_shadow"></div></div>' : '<p class="trade_status right">' + r[e.status] + "</p>";
                var o = e.payment_price > 0 || 0 == e.payment_price && !a ? "" : "hide", d = e.u_price > 0 ? "" : "hide", l = e.u_price > 0 && 0 == e.payment_price ? "hide" : "", c = e.payment_price > 0 && e.u_price > 0 ? !0 : !1, p = "hide" == l ? "" : "hide";
                i = i + '<div class="trade left"><p class="pro_price trade_sum">\u603b\u8ba1:<span class="money ' + o + " " + c + '">\uffe5' + e.payment_price + '</span></p><p class="add_u_money tic_st ' + d + '"><span class="uplus ' + l + '">+</span><span class="' + p + '">&nbsp;</span>' + e.u_price + '<em class="ele_logo"></em></p></div>', t || (i += '<p class="traffic_free"><em>\uff08\u514d\u8fd0\u8d39\uff09</em></p>'), $(".bottom_fix").removeClass("hide").html(i)
            }

            function n(e, a) {
                e && $("#check_pay .ignore_order, #success_pay .scan_order, #no_pay .scan_order").addClass("ulife"), a && $("#no_pay .success_order_body > p").css("color", "rgba(0,0,0,0)"), e || $("#no_pay h1").html('<span class="sprites success_ico"></span>\u8ba2\u5355\u5df2\u6210\u529f\u63d0\u4ea4')
            }

            if (e && void 0 != e) {
                var r = '<div class="trade_time clear_fix"><span class="left">\u6210\u4ea4\u65f6\u95f4</span><p class="right">' + t.formatDate(new Date(e.created_at)) + '</p></div><div class="trade_no clear_fix"><span class="left">\u8ba2\u5355\u7f16\u53f7</span><p class="right">' + e.identifier + "</p></div>";
                e.contact && (r = r + ' <div class="trade_detail clear_fix"><span class="left">\u6536\u8d27\u4fe1\u606f</span><p class="right clear_fix"><em class="left ellipsis">' + e.contact.name + '</em><em class="left">' + e.contact.mobile + '</em><em class="left addr">' + e.contact.province + e.contact.city + e.contact.town + e.contact.address + "</em></p></div>"), "receive" == e.status && trade.get_delivery(e.id, function (e) {
                    if (e && !e.error) {
                        var a = '<div class="new_express border_1px" data-href="/trades/' + l + '/delivery"><span class="dot left"><span class="right_border_1px"></span></span><div class="new_express_info"><h3 class="new_express_time ellipsis">' + t.formatDate(new Date(e[0].time)) + '</h3><h3 class="new_express_address ellipsis">' + e[0].address + '</h3></div><span class="order_enter enter_ico sprites" style="right: 6%;"></span><div class="down_shadow"></div></div>';
                        $(".trade_info").append(a)
                    }
                }), $(".trade_info").removeClass("hide").html(r);
                var o = !1, d = !1;
                if (e.units)if (1 == e.units.length) {
                    var l = e.units[0].item.product.id;
                    products.get_info(l, function (e) {
                        var t = e[0];
                        t && 60 == t.mall_id ? (o = !0, i(o, d, ""), s(o, d), n(o, d), a(!0)) : ulife.get_deal(l, function (e) {
                            e && e.length > 0 ? (o = !0, d = !0, i(o, d, e[0].name), s(o, d), n(o, d), a(!0)) : (i(o, d, ""), s(o, d), n(o, d), a(!0))
                        })
                    })
                } else i(o, d, ""), s(o, d), n(o, d), a(!0)
            } else void 0 == e ? (a(!1), alert("\u5bf9\u4e0d\u8d77\uff0c\u60a8\u7684\u8ba2\u5355\u4e0d\u5b58\u5728")) : (a(!1), alert("\u7f51\u7edc\u9519\u8bef"))
        })
    }, lasy_load: function (e) {
        var a = ($(e), parseInt(.1875 * DeviceInfo.width));
        get_cookie("ratio") && (a *= get_cookie("ratio")), $.each(e, function (e, t) {
            if ("" == $(t).attr("src")) {
                var i = app.pic($(t).data("src"), a), s = new Image;
                $(s).bind("load", function () {
                    $(t).attr("src", i).addClass("pro_width pro_height"), $(t).parent("div").addClass("pro_width pro_height loaded")
                }).bind("error", function () {
                    $(t).complete && ($(t).addClass("pro_width pro_height"), $(t).parent("div").addClass("pro_width pro_height failed"))
                }), s.src = i
            }
        })
    }
}, category_index_controller = {
    initialize: function (e, a, t, i, s) {
        var n = 38 * $(".array_item").length + 16;
        $(".left_blank, .right_blank").css("height", n), $(".bottom_blank").css("height", DeviceInfo.height - n), 0 == $(".array_item.active").length && $($(".array_item")[0]).addClass("active"), this.switch_event(t, e), this.close_layer(a, e, t), this.spread_event(s), app.push_event(i, 200), app.push_event($(".third_cate > div"), 200), $("#array_fixed").bind("click touchstart", function (e) {
            e.preventDefault(), e.stopPropagation()
        })
    }, switch_event: function (e, a) {
        e.bind(itap_event, function () {
            e.toggleClass("push"), e.hasClass("push") ? a.removeClass("hide") : a.addClass("hide"), a.bind("touchstart", function (e) {
                e.preventDefault()
            })
        })
    }, close_layer: function (e, a, t) {
        $(e).bind("click touchstart", function (e) {
            e.preventDefault(), a.addClass("hide"), t.removeClass("push")
        })
    }, spread_event: function (e) {
        var a = $(e);
        a.bind(itap_event, function () {
            var e = $(this), a = e.parent(".cate_list");
            setTimeout(function () {
                a.siblings().removeClass("active"), a.toggleClass("active"), app.iscroll.refresh(), a.hasClass("active") && !e.data("href") && (app.iscroll.scrollTo(0, 70 * -a.index(), 300), app.iscroll.resetPosition())
            }, 200), e.data("href") && (e.addClass("push"), setTimeout(function () {
                e.removeClass("push")
            }, 200), window.location.href = e.data("href"))
        })
    }
}, products_deals_controller = {
    initialize: function () {
        this.go_buy($(".exchange_btn")), this.rule_show($(".rule_bottom")), this.rule_hide($(".rule_c_top")), this.rule_hide($(".rule_top")), this.go_details($(".go_details"))
    }, go_details: function (e) {
        $(e).bind(itap_event, function () {
            var e = $(this);
            window.location.href = e.data("href")
        })
    }, go_buy: function (e) {
        $(e).bind(itap_event, function () {
            var e = $(this), a = e.parent("div"), t = parseInt(e.data("uyuan")), i = parseInt(e.data("usedu"));
            if (times = parseInt(e.data("times")), levels = parseInt(e.data("level")), !e.hasClass("grey_bg")) {
                if (e.addClass("push"), 1 > levels)a.find(".level_limit").removeClass("hide"), setTimeout(function () {
                    a.find(".level_limit").addClass("hide")
                }, 3e3); else if (i > t)a.find(".u_lack").removeClass("hide"), setTimeout(function () {
                    a.find(".u_lack").addClass("hide")
                }, 3e3); else if (0 >= times)a.find(".upper_limit").removeClass("hide"), setTimeout(function () {
                    a.find(".upper_limit").addClass("hide")
                }, 3e3); else {
                    var s = $(this).data("id");
                    cart.add_only(s, "", !1, "ulife", function () {
                        window.location.href = "/trades/new?from=ulife"
                    })
                }
                setTimeout(function () {
                    e.removeClass("push")
                }, 300)
            }
        })
    }, rule_show: function (e) {
        var a = this;
        $(e).bind(itap_event, function () {
            var e = $(this);
            e.addClass("push"), setTimeout(function () {
                e.removeClass("push")
            }, 300), $(".rule_layer").removeClass("hide"), setTimeout(function () {
                $(".rule_content").addClass("appear")
            }, 100), a.rule_scroll_init()
        })
    }, rule_hide: function (e) {
        var a = this;
        $(e).bind(itap_event, function () {
            var e = $(this);
            e.addClass("push"), setTimeout(function () {
                e.removeClass("push")
            }, 300), $(".rule_content").removeClass("appear"), setTimeout(function () {
                $(".rule_layer").addClass("hide")
            }, 300), a.rule_scroll_init()
        })
    }, rule_scroll_init: function () {
        this.rule_scroll || (this.rule_scroll = new IScroll($("#rule_wrapper")[0], {
            scrollX: !1,
            scrollY: !0,
            scrollbars: !0,
            fadeScrollbars: !0
        })), this.rule_scroll.refresh()
    }
}, voucher_controller = {
    initialize: function (e, a, t) {
        var i = this, s = $("input.voucher"), n = $(".main");
        a.bind(itap_event, function () {
            s.val(""), a.addClass("hide"), "" == s.val() && t.addClass("push")
        }), t.bind(itap_event, function () {
            var e = $(this);
            e.hasClass("push") || "" == s.val() || (e.addClass("push"), i.add_voucher(e))
        }), s.bind("input", function () {
            t.toggleClass("push", "" == $(this).val()), a.toggleClass("hide", "" == $(this).val())
        }), s.bind("blur", function () {
            "" == s.val() && t.addClass("push"), a.addClass("hide")
        }), s.bind("focus", function () {
            n.bind("click touchmove", function (e) {
                "INPUT" != e.target.tagName && (n.unbind(), s.blur())
            }), a.toggleClass("hide", "" == $(this).val())
        }), e.bind("submit", function (e) {
            e.preventDefault(), "" == s.val() ? s.blur() : i.add_voucher(t)
        })
    }, add_voucher: function (e) {
        voucher.add($(".voucher").val(), function (a) {
            var t = $(".voucher");
            if (t.blur(), t.val(""), a.voucher && !$.isEmptyObject(a.voucher)) {
                var i = a.voucher.event, s = "<div class='useful border_1px' style='height: 0; opacity: 0;'><div class='voucher_detail'><span class='voucher_name ellipsis'>" + i.name + "</span><span class='voucher_info ellipsis'>\u5355\u4ef6\u5546\u54c1\u6ee1" + i.limitation + "\u51cf" + i.amount + "</span><span class='voucher_date voucher_info ellipsis right'>" + i.ended_at.substr(0, 10) + "</span></div></div>";
                $(".vouchers").prepend(s), $($(".useful")[0]).animate({
                    height: "74px",
                    opacity: 1
                }, 300, "linear", function () {
                    setTimeout(function () {
                        alert("\u4ee3\u91d1\u5238\u6dfb\u52a0\u6210\u529f\uff01")
                    }, 150), e.addClass("push")
                })
            } else e.addClass("push"), alert("\u65e0\u6548\u7684\u4ee3\u91d1\u5238\u5e8f\u5217\u53f7\uff01")
        })
    }
}, trades_statistics = {
    initialize: function (e) {
        var a = this;
        trade_id = $("#trade").data("id"), a.get_trade(trade_id, function (a) {
            e(a)
        })
    }, get_trade: function (e, a) {
        trade.get_trade(e, function (e) {
            function t() {
                for (var a = e.contact ? e.contact.city : "", t = e.contact ? e.contact.province : "", i = e.contact ? e.contact.country : "", s = "<span id='trade_info' data-id='" + e.id + "' data-price='" + e.payment_price + "' data-city='" + a + "' data-province='" + t + "' data-country='" + i + "'></span>", n = 0; n < e.units.length; n++) {
                    var r = e.units[n], o = r.item, d = o.product.category2 ? o.product.category2.name : "";
                    s += "<span class='unit' data-pid='" + o.product.id + "' data-pname='" + o.product.name + "' data-pcatename='" + d + "' data-discount='" + r.discount + "'></span>"
                }
                $("#trade_detail").html(s)
            }

            e && void 0 != e && e.units ? (t(), a(!0)) : a(!1)
        })
    }, ga: function (e, a, t) {
        function i() {
            var e = $("#trade_info"), a = $(".unit"), t = ["_addTrans", e.data("id"), "", e.data("price"), "", "", e.data("city"), e.data("province"), e.data("country")];
            _gaq.push(t), a.each(function (a, t) {
                var i, s = $(t);
                i = ["_addItem", e.data("id"), s.data("pid"), s.data("pname"), s.data("pcatename"), s.data("discount"), "1"], _gaq.push(i)
            }), _gaq.push(["_trackTrans"])
        }

        var s = {
            geo: "cn",
            account_id: "VIZVRM3869",
            vertical: "ecommerce",
            type: "thank_you",
            orderid: e,
            orderprice: a
        };
        t.forEach(function (e, a) {
            var t = "pid" + (a + 1);
            s[t] = $(e).data("proid")
        }), window.vizLayer = s, function () {
            try {
                var e = document.createElement("script");
                e.type = "text/javascript", e.async = !0, e.src = ("https:" == document.location.protocol ? "https://cn-tags.vizury.com" : "http://cn-tags.vizury.com") + "/analyze/pixel.php?account_id=vst";
                var a = document.getElementsByTagName("script")[0];
                a.parentNode.insertBefore(e, a), e.onload = function () {
                    try {
                        pixel.parse()
                    } catch (e) {
                    }
                }, e.onreadystatechange = function () {
                    if ("complete" == e.readyState || "loaded" == e.readyState)try {
                        pixel.parse()
                    } catch (a) {
                    }
                }
            } catch (t) {
            }
        }(), $("#trade_info").length > 0 && $(".unit").length > 0 ? i() : trades_statistics.initialize(function (e) {
            e && i()
        })
    }
}, fanship_index_controller = {
    initialize: function (e, a, t) {
        var i = this;
        i.delete_event(a, e), 1 === $(".fan_has").length ? $(".edit_ico").removeClass("hide") : $(".edit_ico").addClass("hide"), $.each(t, function (e, a) {
            var t = $(a).find(".fan_name"), i = $(a).find(".fan_chinese"), s = t.height() + i.height() + 6;
            t.css("padding-top", (102 - s) / 2)
        })
    }, delete_event: function (e, a) {
        $(e).unbind().bind(itap_event, function (e) {
            e.preventDefault(), e.stopPropagation();
            var t = $(this), i = t.parents(".estop");
            id = t.data("id"), i.addClass("push"), setTimeout(function () {
                return confirm("\u786e\u8ba4\u5220\u9664\u54c1\u724c?") ? void fanship.remove(id, function (e) {
                    e && (i.parents(".fanship_brand").remove(), 0 == $(".fanship_brand").length && ($(".fanships").html('<div class="fan_empty"><p>\u60a8\u7684\u8d26\u53f7\u6682\u65e0\u6536\u85cf\u54c1\u724c</p></div>'), a.addClass("hide"), $(".back_ico").removeClass("hide")))
                }) : void i.removeClass("push")
            }, 100)
        })
    }
}, murmurs_show_controller = {
    initialize: function (e, a, t, i) {
        this.text_event(e), this.text_event(a), this.destroy(t);
        var s = i.height();
        i.css("margin-top", (124 - s) / 2 + "px");
        var n = navigator.userAgent.toLowerCase();
        ("iphone" == n.match(/iPhone/i) && "safari" == n.match(/Safari/i) && "ipod" != n.match(/iPod/i) && "ipad" != n.match(/iPad/i) || "micromessenger" == n.match(/MicroMessenger/i) && "iphone" == n.match(/iPhone/i) && "ipod" != n.match(/iPod/i) && "ipad" != n.match(/iPad/i)) && e.removeClass("hide"), document.addEventListener("WeixinJSBridgeReady", function () {
            WeixinJSBridge.call("hideOptionMenu")
        })
    }, destroy: function (e) {
        $(e).bind(itap_event, function () {
            var e = $(this);
            e.addClass("push"), confirm("\u9009\u62e9\u6e05\u9664\u540e\uff0c\u79d8\u8bed\u4e8c\u7ef4\u7801\u5219\u5931\u6548\uff0c\u4e0d\u518d\u663e\u793a\u8d60\u8a00\u5185\u5bb9\uff0c\u786e\u8ba4\u6e05\u9664?") ? $("form").submit() : e.removeClass("push")
        })
    }, text_event: function (e) {
        var a = $(e);
        a.bind(itap_event, function (e) {
            e.preventDefault(), e.stopPropagation();
            var a = $(this);
            a.hasClass("msg_thanks") ? (a.addClass("push"), setTimeout(function () {
                a.removeClass("push")
            }, 1e3), window.location.href = a.data("href")) : (a.toggleClass("push"), $(".products_board").toggleClass("hide"), app.iscroll.refresh(), a.hasClass("push") ? setTimeout(function () {
                var e = get_cookie("app");
                "false" == e ? window.scrollTo(0, 278) : window.scrollTo(0, 338)
            }, 500) : setTimeout(function () {
                window.scrollTo(0, 0)
            }, 100))
        })
    }
}, brand_show_controller = {
    initialize: function (e, a, t) {
        e[0] && (window.location.href.indexOf("add_fanship=true") > -1 ? (a.addClass("push"), fanship.add(t)) : fanship.get(t, function (e) {
            e && e.fanships[0] && a.addClass("push")
        }))
    }, collection_event: function (e, a, t) {
        var i = $(e);
        a.bind(itap_event, function () {
            if ($this = $(this), $this.hasClass("push"))$this.removeClass("push"), fanship.get(t, function (e) {
                if (e && e.fanships[0]) {
                    var a = e.fanships[0].id;
                    fanship.remove(a, function (e) {
                        e && ("" != window.location.search ? window.location.href = window.location.pathname : $this.removeClass("push"))
                    })
                }
            }); else if (i[0])$this.addClass("push"), fanship.add(t); else {
                var e = window.location;
                e.href = "/login?ref=" + e.pathname + "?add_fanship=true"
            }
        })
    }
}, user_center_controller = {
    initialize: function (e) {
        var a = this, t = $(".manage_set"), i = $("#manage_layer"), s = $("#complete_layer");
        a.other_event(e), a.change_page(t, i, s), app.push_event($(".last .user_item"), 200), a.input_method($("#manage_binding_form .clear_txt")), contact_new_controller.keyup_event($(".read_in.name input"), 20), contact_new_controller.keyup_event($(".read_in.psd input"), 20), contact_new_controller.keyup_event($(".read_in.rpsd input"), 20);
        var n = $("#manage_layer .clear_txt"), r = $("#manage_layer input");
        login_register_controller.input_event(r), login_register_controller.clear_text(n), $("#manage_binding_form").submit(function (e) {
            e.preventDefault();
            var a = $("#manage_binding_submit");
            a.hasClass("push") || (a.addClass("push"), $.each($("input"), function (e, a) {
                $(a).blur()
            }), $("#main").append('<input type="hidden" id="user">'), user.get_current(function (e) {
                e && e.connection && (id = e.connection.id, login_register_controller.login_check($("#manage_binding_form"), $(".manage_binding_btn"), id))
            }))
        }), $("#manage_binding_submit").unbind(itap_event).bind(itap_event, function (e) {
            e.preventDefault(), $("#manage_binding_form").submit()
        });
        var o = !1, d = null;
        a.password_blur(), a.email_blur(d, o, function (e) {
            d = e.flag, o = e.username_valid
        }), $("#setter").submit(function (e) {
            e.preventDefault();
            var t = $("#setter_submit");
            t.hasClass("push") || (t.addClass("push"), $.each($("input"), function (e, a) {
                $(a).blur()
            }), setTimeout(function () {
                a.check(o, d)
            }, 300))
        }), $("#setter_submit").unbind(itap_event).bind(itap_event, function (e) {
            e.preventDefault(), $("#setter").submit()
        })
    }, input_method: function (e) {
        login_register_controller.clear_text(e), $.each($(".email.read_in input"), function (e, a) {
            $(a).bind("input", function () {
                var e = $(this), a = e.val().indexOf("@"), t = $(".suffix_tip");
                if (-1 !== a) {
                    var i = e.val().slice(a + 1), s = login_register_controller.get_email_suffix(i);
                    if (s.length > 0) {
                        for (var n = "", r = 0; r < s.length; r++)n += '<span class="left">' + s[r] + "</span>";
                        n = '<div class="tip_angle"></div>' + n + '<div class="clear"></div>', t.removeClass("hide").html(n), login_register_controller.read_in(e, $(".suffix_tip span"), t)
                    } else t.addClass("hide")
                } else t.addClass("hide")
            })
        }), $("input").bind("input", function () {
            $(this).parent().find(".clear_txt").removeClass("hide")
        }).bind("blur", function () {
            $(this).parent().find(".clear_txt").addClass("hide"), $(".suffix_tip").addClass("hide")
        }).bind("focus", function () {
            $(this).parent().find(".clear_txt").toggleClass("hide", "" == $(this).val()), $(this).parent().find(".right_ico").addClass("hide")
        })
    }, check: function (e) {
        var a = $('input[name="core_account[email]"]'), t = $('input[name="core_account[password]"]'), i = $('input[name="core_account[repassword]"]'), s = $.trim(a.val()), n = $.trim(t.val()), r = $.trim(i.val()), o = $(".set_now"), d = this;
        if (0 === s.length)return o.removeClass("push"), login_register_controller.error("\u90ae\u7bb1\u4e0d\u80fd\u4e3a\u7a7a!");
        if (!e) {
            if ("true" === a.data("checked"))return o.removeClass("push"), login_register_controller.error("\u8be5\u90ae\u7bb1\u5df2\u6ce8\u518c!");
            if ("false" === a.data("checked"))return o.removeClass("push"), login_register_controller.error("\u90ae\u7bb1\u683c\u5f0f\u4e0d\u6b63\u786e!")
        }
        return n.length < 6 || r.length < 6 ? (t.blur(), o.removeClass("push"), login_register_controller.error("\u5bc6\u7801\u957f\u5ea6\u4e0d\u80fd\u5c0f\u4e8e6\u4f4d!")) : n.length > 20 || r.length > 20 ? (t.blur(), o.removeClass("push"), login_register_controller.error("\u5bc6\u7801\u957f\u5ea6\u4e0d\u80fd\u8d85\u8fc720\u4f4d!")) : n !== r ? (i.blur(), t.blur(), o.removeClass("push"), login_register_controller.error("\u4e24\u6b21\u5bc6\u7801\u8f93\u5165\u4e0d\u4e00\u81f4!")) : void d.add_account(s, n)
    }, add_account: function (e, a) {
        user.update_account(e, a, function (e) {
            e ? (app.handle_cookie("has_email", !0), window.location.href = "/user_center") : $(".set_now").removeClass("push")
        })
    }, password_blur: function () {
        var e = $('input[name="core_account[password]"]'), a = $('input[name="core_account[repassword]"]');
        e.blur(function () {
            var a = $.trim(e.val()), t = a.length;
            t > 5 && 21 > t ? e.next().removeClass("hide") : e.next().addClass("hide")
        }), a.blur(function () {
            var t = $.trim(e.val()), i = $.trim(a.val()), s = (t.length, i.length);
            s > 5 && 21 > s && t == i ? a.next().removeClass("hide") : a.next().addClass("hide")
        })
    }, email_blur: function (e, a, t) {
        var i = $('input[name="core_account[email]"]');
        i.blur(function () {
            var s = $.trim(i.val());
            i.next().addClass("hide"), a = !1, s && (Fv.checker.email_phone(s) ? user.need_captcha(s, function (s) {
                s && (i.data("checked", "true"), e = 1, s.account && !s.has_email ? a = !1 : (a = !0, i.next().removeClass("hide")), t({
                    flag: e,
                    username_valid: a
                }))
            }) : (i.data("checked", "false"), e = 0, i[0].blur(), t({flag: e, username_valid: a})))
        })
    }, other_event: function (e) {
        $(e).bind(itap_event, function () {
            var e = $(this), a = e.data("href");
            e.addClass("push"), setTimeout(function () {
                if (a)app.get_user() || (a = "/"), window.location.href = a; else {
                    var t = $("#manage_layer .order_load");
                    $("#nav").removeClass("hide"), $("#manage_layer, #account_set_layer").removeClass("hide"), app.layer_appear($("#account_set_layer")), "true" == get_cookie("has_email") ? (t.addClass("hide"), $(".set_new_account").addClass("hide"), $("#manage_layer, .manage_box").removeClass("hide")) : "false" == get_cookie("has_email") ? (t.addClass("hide"), $(".set_new_account").removeClass("hide"), $("#manage_layer, .manage_box").removeClass("hide")) : user.set_cookie(function (e) {
                        e && e.user_id && loading.if_has_email(e.user_id, function (e) {
                            t.addClass("hide"), e.flag ? (app.handle_cookie("has_email", !0), $(".set_new_account").addClass("hide")) : (app.handle_cookie("has_email", !1), $(".set_new_account").removeClass("hide")), $("#manage_layer, .manage_box").removeClass("hide")
                        })
                    }), login_register_controller.close_event($(".turnoff_ico"))
                }
                e.removeClass("push")
            }, 200)
        })
    }, change_page: function (e, a, t) {
        e.bind(itap_event, function () {
            {
                var e = $(this), i = $("#account_set_layer .clear_txt");
                $("#account_set_layer input")
            }
            $em = $("#account_set_layer em.right_ico"), login_register_controller.clear_text(i), $(".manage_set").hasClass("push") || (e.addClass("push"), $("input").val(""), $.each($("input"), function (e, a) {
                $(a).blur()
            }), $("input").blur(), $em.addClass("hide"), setTimeout(function () {
                e.removeClass("push"), a.addClass("hide"), t.removeClass("hide")
            }, 100))
        })
    }
}, products_search_controller = {
    initialize: function (e, a, t) {
        this.focus(a, t), this.blur(a, t), this.remove(a, t), this.records();
        var i = this;
        $("#search_submit").bind("submit", function (e) {
            e.preventDefault(), $.each($("input"), function (e, a) {
                $(a).blur()
            }), i.save_storage(a), setTimeout(function () {
                window.location.href = "/search?keyword=" + a.val()
            }, 300)
        }), $(".search_btn").bind(itap_event, function (e) {
            e.preventDefault(), $("#search_submit").submit()
        }), $(".search_item").bind(itap_event, function () {
            var e = $(this), a = window.localStorage.getItem("history"), t = e.text().trim();
            if (!e.hasClass("push")) {
                if (e.addClass("push"), a) {
                    var i = [];
                    i.push(t), a = window.localStorage.getItem("history").split(","), $.inArray(t, a) > -1 && a.splice($.inArray(t, a), 1), i = i.concat(a), window.localStorage.setItem("history", i)
                } else window.localStorage.setItem("history", t);
                setTimeout(function () {
                    e.removeClass("push"), e.data("href") && "" != e.data("href") && (e.hasClass("success_back") && "true" == get_cookie("ulife_app") ? window.UAPPJSBridge ? UAPPJSBridge.goto_ushop_page() : $(document).on("UAPPJSBridgeReady", function () {
                        UAPPJSBridge.goto_ushop_page()
                    }) : window.location.href = e.data("href"))
                }, 200)
            }
        }), this.tap_event($(".nav_list div"), $(".search_list")), this.clear_storage($(".clear_history_btn")), app.push_event(".search_list, .up_page.use, .down_page.use", 200)
    }, clear_storage: function (e) {
        e.bind(itap_event, function () {
            e.addClass("push");
            var a = '<div class="search_empty"><p>\u60a8\u8fd8\u6ca1\u6709\u641c\u7d22\u8bb0\u5f55</p></div>';
            $(".record_body").children().remove(), $(".record_body.search_list").html(a), window.localStorage.clear(), setTimeout(function () {
                e.removeClass("push")
            }, 100)
        })
    }, focus: function (e, a) {
        e.bind("input", function () {
            a.toggleClass("hide", !$(this).val())
        })
    }, blur: function (e, a) {
        e.bind("blur", function () {
            a.addClass("hide")
        })
    }, remove: function (e, a) {
        a.bind(itap_event, function () {
            e.val(""), $(this).addClass("hide"), $(".layer").children().remove()
        })
    }, save_storage: function (e) {
        if (!e.val())return !1;
        try {
            var a = [], t = {}, i = [];
            a.push(e.val()), window.localStorage.getItem("history") && (a = a.concat(window.localStorage.getItem("history").split(",")));
            for (var s in a)t[a[s]] || (t[a[s]] = [], i.push(a[s]));
            localStorage.setItem("history", i)
        } catch (n) {
        }
    }, tap_event: function (e, a) {
        var t = $(e);
        t.bind(itap_event, function (e) {
            e.preventDefault(), e.stopPropagation(), setTimeout(function () {
                app.iscroll.refresh()
            }, 300), $("#search_txt").blur();
            var i = $(this);
            t.removeClass("push"), $(this).siblings().removeClass("active"), $(this).addClass("active"), i.addClass("push"), a.addClass("hide"), $("." + i.data("class")).removeClass("hide")
        })
    }, records: function () {
        var e = localStorage.length, a = "", t = [];
        0 === e && (a = '<div class="search_empty"><p>\u60a8\u8fd8\u6ca1\u6709\u641c\u7d22\u8bb0\u5f55</p></div>');
        for (var i = window.localStorage.getItem("history") ? window.localStorage.getItem("history").split(",") : "", s = 0; s <= i.length; s++)t.push(i[s]);
        for (s in t) {
            if (10 == s)break;
            if (t[s]) {
                var n = ['<div class="border_1px search_item" data-href="/search?keyword=' + t[s] + '">' + t[s] + '<div class="down_shadow"></div></div>'];
                a += n.join("")
            }
        }
        "" == t && (a = '<div class="search_empty"><p>\u60a8\u8fd8\u6ca1\u6709\u641c\u7d22\u8bb0\u5f55</p></div>'), a && 0 != e && 0 != t && (a += '<div class="clear_history_btn btn">\u6e05\u9664\u5386\u53f2<div class="down_shadow"></div></div>'), $(".record_body.search_list").html(a)
    }
}, favorite_index_controller = {
    initialize: function (e, a, t) {
        var i = this;
        $(".favorite_pro").length > 0 ? $(".edit_ico").removeClass("hide") : $(".edit_ico").addClass("hide"), i.delete_event(a, e), app.on_off_event(e, a, t), app.stop_link(t), app.stop_link($(".pro_vip_pro")), app.stop_link($(".pro_sale_out")), app.push_event($(".favorite_pro"), 200)
    }, delete_event: function (e, a) {
        $(e).unbind().bind(itap_event, function (e) {
            e.preventDefault(), e.stopPropagation();
            var t = $(this), i = t.parents(".estop"), s = t.find("span").data("id");
            i.addClass("push"), setTimeout(function () {
                return confirm("\u786e\u8ba4\u5220\u9664\u5546\u54c1?") ? (t.parents(".estop").parents(".favorite_pro").remove(), 0 == $(".favorite_pro").length && ($(".favorites").html('<div class="fav_empty"><p>\u60a8\u7684\u8d26\u53f7\u6682\u65e0\u6536\u85cf\u5546\u54c1</p></div>'), a.addClass("hide"), $(".back_ico").removeClass("hide")), favorite.remove(s, function () {
                }), void 0) : void i.removeClass("push")
            }, 100)
        })
    }
}, trades_index_controller = {
    initialize: function () {
        this.bool = -1 != CONFIG.host.indexOf("www.barlar"), this.hwg = $("#trade").data("hwg"), this.taghwg = "false", this.wechatag = !1;
        var e = ($("#online_pay"), navigator.userAgent.toLowerCase());
        if ("micromessenger" == e.match(/MicroMessenger/i) && (this.wechatag = !0, $(".wechat_pay").removeClass("hide"),$(".zhifubao").addClass("hide")), this.bank = {
                cmbchina: "\u62db\u5546\u94f6\u884c",
                alipay: "\u652f\u4ed8\u5b9d",
                wechat: "\u5fae\u4fe1",
                cash: "\u8d27\u5230\u4ed8\u6b3e"
            }, 1 === $("#trade").length)if (this.paymode = window.location.search.replace("?paymode=", ""), this.id = $("section").data("id"), this.price = $(".money").html(), this.pricetag = this.price, this.bank[this.paymode])this.set_interval(); else if ("no_payment" == this.paymode)$("#no_pay").removeClass("hide"); else if ("express_success" == this.paymode) {
            if ($("#cash_pay").removeClass("hide"), this.bool) {
                var a = $("#" + this.id);
                a = a.length > 0 ? a.find(".vizlury") : $(".vizlury");
                var t = a.data("price"), i = a.data("orderid"), s = a.find(".prolist");
                trades_statistics.ga(i, t, s)
            }
        } else"express_failed" == this.paymode && ($("#fail_orderlayer h1").html("<span class='sprites fail_ico'></span>\u62b1\u6b49\uff0c\u8d27\u5230\u4ed8\u6b3e\u63d0\u4ea4\u5931\u8d25"), $("#fail_orderlayer").removeClass("hide"));
        if ($(".pay_layer .down_pay").removeClass("hide"), app.push_event($(".order_list.one .pro_img, .order_list.more, .all_pro, .trade_detail_box, .new_express, .up_page.use, .down_page.use"), 200), this.enter_event($(".order_list.one .bag_info")), app.layer($("#online_pay, #cash_pay, #check_pay, #success_pay, #fail_orderlayer, #pay_layer")), this.scan_order($(".scan_order")), this.select_option($(".cash_pay, .mode_pay")), this.later_handle($("#fail_orderlayer .ignore_order")), this.resubmit($("#fail_orderlayer .re_submit_order")), this.later_handle_address($("#fail_url .ignore_order")), this.resubmit_address($("#fail_url .re_submit_order")), app.push_event($(".order_nav > div, .trade_express_btn, .page > div"), 200), this.cancel_trade($(".trade_cancel_btn")), this.go_trade($(".trade_pay_btn")), this.recieve_trade($(".trade_receive_btn")), this.utic_status(), this.uchart(), window.location.search.indexOf("layer") > -1) {
            if (this.paymode = "wechat", 1 == window.location.search.split("&").length) {
                var n = window.location.search.split("&")[0].replace("?layer=", "");
                this.price = $(".pro_price .money").html()
            } else {
                var n = window.location.search.split("&")[2].replace("layer=", "");
                this.id = window.location.search.split("&")[1].replace("id=", ""), this.price = "\uffe5" + $("#" + this.id).data("price")
            }
            $("#" + n).removeClass("hide"), this.online_pay()
        }
    }, uchart: function () {
        if (null != $(".add_u_money.tic_st").text() && null != $(".money").text()) {
            var e = $(".add_u_money.tic_st").text().replace("+", "").trim().length, a = $(".money").text().replace("\uffe5", "").trim().length;
            if (e > a) {
                var t = e - a, i = "&nbsp;&nbsp;&nbsp;", s = 0;
                for (s = 1; t > s; s++)i += "&nbsp;&nbsp;";
                $(".money").html(i + $(".money").text())
            }
        }
    }, utic_status: function () {
        var e = $(".bottom_fix");
        $trade_status = e.find(".trade_status").length, $tic_btn = e.find(".tic_btn").length, $money = e.find(".money"), 1 > $trade_status ? 1 === $tic_btn && $money.hasClass("hide") ? $(".add_u_money").removeClass("tic_st") : $(".add_u_money").addClass("tic_st") : $(".add_u_money").removeClass("tic_st")
    }, later_handle_address: function (e) {
        e.bind(itap_event, function () {
            var e = $(this);
            $(".re_submit_order").hasClass("push") || (e.addClass("push"), $("#fail_url").addClass("hide"), setTimeout(function () {
                e.removeClass("push")
            }, 500))
        })
    }, resubmit_address: function (e) {
        var a = this;
        e.bind(itap_event, function () {
            var e = $(this);
            e.addClass("push"), a.get_mode(function (t) {
                if (-1 == t.indexOf("error")) {
                    var i = $("#online_pay .go_pay");
                    $(i[1]).addClass("hide"), $(i[0]).removeClass("hide"), $("#fail_url").addClass("hide"), $("#online_pay").find("h1").html("\u9009\u62e9\u7528" + a.bank[a.paymode] + "\u652f\u4ed8<p>" + "" + "</p>"), $("#online_pay").removeClass("hide"), a.go_pay($(".go_pay"), t)
                }
                e.removeClass("push")
            })
        })
    }, recieve_trade: function (e) {
        e.bind("tap", function () {
            var e = $(this), a = e.data("id");
            e.hasClass("push") || (e.addClass("push"), trade.receive(a, function () {
                e.removeClass("push"), window.location.href = "/trades/" + a
            }))
        })
    }, set_interval: function () {
        var e, a = $("#online_pay .go_pay");
        $(a[0]).addClass("hide"), $(a[1]).removeClass("hide"), $("#online_pay").find("h1").html("\u9009\u62e9\u7528" + this.bank[this.paymode] + "\u652f\u4ed8<p>" + "" + "</p>"), "\u8d27\u5230\u4ed8\u6b3e" == this.bank[this.paymode] ? ($("#online_pay").find(".success_order_body > p").addClass("hide"), e = "\u6b63\u5728\u83b7\u53d6\u8d27\u5230\u4ed8\u6b3e\u8bf7\u6c42") : (e = "\u6b63\u5728\u83b7\u53d6\u652f\u4ed8\u9875\u9762\u5730\u5740\u4fe1\u606f", $("#online_pay").find(".success_order_body > p").removeClass("hide")), $("#online_pay").find(".success_order_body .no_border p:nth-child(1)").html(e), $("#online_pay").removeClass("hide");
        var t = this;
        t.interval_round(), this.get_mode(function (e) {
            t.clearInterval_round(), t.go_pay($(".go_pay"), e)
        })
    }, interval_round: function () {
        var e = 0, a = $(".round");
        interval = setInterval(function () {
            3 == e ? (a.addClass("hide"), e = -1) : $(a[e]).removeClass("hide"), e++
        }, 400)
    }, clearInterval_round: function () {
        var e = $(".round");
        clearInterval(interval), e.addClass("hide"), e.parent().addClass("hide").prev().removeClass("hide")
    }, scan_order: function (e) {
        var a = this;
        e.unbind().bind(itap_event, function () {
            var t = $(this);
            t.addClass("push"), param = "", e.parent().parent().addClass("hide"), t.hasClass("ulife") && (param = "?from=order"), window.location.href = "/trades/" + a.id + param, setTimeout(function () {
                t.removeClass("push")
            }, 300)
        })
    }, resubmit: function (e) {
        var a = this;
        e.bind(itap_event, function () {
            $(this).addClass("push"), trade._express_pay(parseInt(a.id), function (e) {
                $(this).removeClass("push"), e && ($("#fail_orderlayer").addClass("hide"), $("#cash_pay").removeClass("hide"))
            })
        })
    }, later_handle: function (e) {
        e.bind(itap_event, function () {
            var e = $(this);
            e.addClass("push"), $("#fail_orderlayer").addClass("hide"), setTimeout(function () {
                e.removeClass("push")
            }, 500)
        })
    }, go_pay: function (e, a) {
        var t, i = this;
        t = 1 === $("#trade").length ? "info" : "index", a && -1 == a.indexOf("error") ? e.unbind(itap_event).bind(itap_event, function () {
            if ("wechat" == i.paymode)window.location.href = "/trades/paymode/" + i.id + "?params=" + t; else {
                var e = document.createElement("a"), s = document.createEvent("MouseEvents");
                e.target = "_blank", e.href = a, s.initEvent("click", !0, !0), e.dispatchEvent(s), i.online_pay(), $("#online_pay").addClass("hide"), $("#check_pay").removeClass("hide")
            }
        }) : ($("#online_pay").addClass("hide"), $("#fail_url").removeClass("hide"))
    }, check_trade: function (e) {
        var a = this;
        trade.get_trade(parseInt(this.id), function (t) {
            function i() {
                var e = $("#success_pay");
                e.find("h1").html("wechat" == a.paymode ? "\u9009\u62e9\u7528\u5fae\u4fe1\u6210\u529f\u652f\u4ed8<p>" + "" + "</p>" : "\u9009\u62e9\u7528" + a.bank[a.paymode] + "\u6210\u529f\u652f\u4ed8<p>" + "" + "</p>"), $(".fail_order_layer").addClass("hide"), e.removeClass("hide")
            }

            if (t && "pay" != t.status) {
                if (e.removeClass("push"), a.bool) {
                    var s = $("#" + a.id);
                    s = s.length > 0 ? s.find(".vizlury") : $(".vizlury");
                    var n = s.data("price"), r = s.data("orderid"), o = s.find(".prolist");
                    trades_statistics.ga(r, n, o)
                }
                i()
            } else trade[a.paymode + "_query"](parseInt(a.id), function (t) {
                if (e.removeClass("push"), t && "pay" != t.status) {
                    if (a.bool) {
                        var s = $("#" + a.id);
                        s = s.length > 0 ? s.find(".vizlury") : $(".vizlury");
                        var n = s.data("price"), r = s.data("orderid"), o = s.find(".prolist");
                        //trades_statistics.ga(r, n, o)
                    }
                    i()
                } else if ($("#check_pay").addClass("hide"), e.hasClass("ignore_order")) {
                    var d = $(".down_pay");
                    e.hasClass("ulife") ? d.addClass("hide") : d.removeClass("hide"), "true" === a.hwg || "true" === a.taghwg ? ($(".down_pay").addClass("hide"), $(".zhaoshang.banks").addClass("hide")) : ($(".down_pay").removeClass("hide"), $(".zhaoshang.banks").removeClass("hide")), trades_paymode_controller.show_layer()
                } else 1 != $("#trade").length && (window.location.href = "/trades/" + a.id)
            })
        })
    }, online_pay: function () {
        var e = this;
        $("#check_pay .re_submit_order").unbind(itap_event).bind(itap_event, function () {
            var a = $(this);
            a.hasClass("push") || $(".ignore_order").hasClass("push") || (a.addClass("push"), e.check_trade(a))
        }), $("#check_pay .ignore_order").unbind(itap_event).bind(itap_event, function () {
            var a = $(this);
            a.hasClass("push") || $(".re_submit_order").hasClass("push") || (a.addClass("push"), e.check_trade(a))
        })
    }, get_mode: function (e) {
        this.get_url(function (a) {
            e(a)
        })
    }, get_url: function (e) {
        var a = CONFIG.host + "/pay_success.html";
        if ("alipay" == this.paymode) {
            var t = "alipay_wap";
            ("true" === this.hwg || "true" === this.taghwg) && (t = "alipay_forex_wap"), a = window.location.origin + "/trades/" + this.id, trade.checkout(parseInt(this.id), a, t, "json", function (a) {
                e(a)
            })
        } else"cmbchina" == this.paymode ? trade.checkout(parseInt(this.id), a, null, "json", function (a) {
            e(a)
        }) : "wechat" == this.paymode && e("wechat")
    }, select_option: function (e) {
        var a = this;
        trades_paymode_controller.close_layer($(".pay_other")), e.unbind(itap_event).bind(itap_event, function () {
            var e = $(this), t = {
                "\u62db\u5546\u94f6\u884c": "cmbchina",
                "\u652f\u4ed8\u5b9d": "alipay",
                "\u5fae\u4fe1": "wechat",
                "\u8d27\u5230\u4ed8\u6b3e": "cash"
            };
            $(".on_pay > div,.down_pay > div").hasClass("active") || (e.addClass("active"), setTimeout(function () {
                e.removeClass("active"), $(".pay_body").removeClass("appear"), $("#pay_layer").addClass("hide"), $(".pay_other").css("width", "44%"), "\u8d27\u5230\u4ed8\u6b3e" == e.data("name") ? (a.paymode = t[e.data("name")], a.set_interval(), trade._express_pay(parseInt(a.id), function (e) {
                    if ($("#online_pay").addClass("hide"), e) {
                        if ($("#cash_pay").removeClass("hide"), a.bool) {
                            var t = $("#" + a.id);
                            t = t.length > 0 ? t.find(".vizlury") : $(".vizlury");
                            var i = t.data("price"), s = t.data("orderid"), n = t.find(".prolist");
                            trades_statistics.ga(s, i, n)
                        }
                    } else $("#fail_orderlayer h1").html("<span class='sprites fail_ico'></span>\u62b1\u6b49\uff0c\u8d27\u5230\u4ed8\u6b3e\u63d0\u4ea4\u5931\u8d25"), $("#fail_orderlayer").removeClass("hide")
                })) : (a.paymode = t[e.data("name")], a.set_interval())
            }, 300))
        })
    }, cancel_trade: function (e) {
        e.bind("tap", function () {
            var e = $(this), a = e.data("id");
            e.hasClass("push") || (e.addClass("push"), confirm("\u786e\u8ba4\u53d6\u6d88\u8ba2\u5355\uff1f") ? trade.cancel(a, function (t) {
                e.removeClass("push"), t && (window.location.href = "/trades/" + a)
            }) : e.removeClass("push"))
        })
    }, go_trade: function (e) {
        var a = $(e), t = this;
        a.bind(itap_event, function () {
            var e = $(this), a = (e.data("id"), $(".down_pay"));
            t.taghwg = t.hwg ? t.hwg : e.parents(".trade_box").data("hwg"), "true" === t.taghwg ? (a.addClass("hide"), $("#check_pay .ignore_order, #success_pay .scan_order").removeClass("ulife"), $(".wechat_pay.mode_pay, .zhaoshang.mode_pay").addClass("hide")) : e.hasClass("ulife") ? (a.addClass("hide"), $(".wechat_pay.mode_pay, .zhaoshang.mode_pay").removeClass("hide"), $("#check_pay .ignore_order, #success_pay .scan_order").addClass("ulife")) : (a.removeClass("hide"), $(".wechat_pay.mode_pay, .zhaoshang.mode_pay").removeClass("hide"), $("#check_pay .ignore_order, #success_pay .scan_order").removeClass("ulife")), t.wechatag || $(".wechat_pay.mode_pay").addClass("hide"), e.addClass("push"), t.id = e.data("id"), t.pricetag = t.price ? t.price : "\uffe5" + e.data("price"), trades_paymode_controller.show_layer(), setTimeout(function () {
                e.removeClass("push")
            }, 200)
        })
    }, enter_event: function (e) {
        e.bind(itap_event, function () {
            var e = $(this);
            e.addClass("push"), e.siblings("div").addClass("push"), window.location.href = e.data("href"), setTimeout(function () {
                e.removeClass("push"), e.siblings("div").removeClass("push")
            }, 200)
        })
    }
}, products_show_controller = {
    initialize: function (e, a, t, i, s, n) {
        var r = this;
        $wrapper = $(".img_wrap"), $slide = $(".slide"), $video = $(".video_player"), video_src = $wrapper.data("video"), index = video_src ? 1 : 0, length = 1 * $wrapper.data("width") + index, width = $wrapper.width(), direction = "landscape", r.ulife = $("#product").data("ulife"), r.hwg = $("#product").data("hwg"), r.if_product = $("#product").data("if-product"), $("#main").append('<input type="hidden" id="page" data-page="single">'), $("header .title").css("color", "#000"), $(".info_ico").removeClass("hide"), $.each($(".size_img_wrap img"), function (e, a) {
            var t = $(a), i = t.attr("src"), s = new Image;
            s.src = i, $(s).bind("load", function () {
                var e = s.width, a = h = s.height;
                e > DeviceInfo.width && (a = parseInt(.9 * DeviceInfo.width * h / e)), t.css("height", a), t.parent("a").css("height", a), app.iscroll.refresh()
            })
        }), r.load_img(video_src ? 2 : 1), $slide.find("li:nth-child(" + (index + 1) + ")").addClass("active"), $wrapper.children("div").css("width", width * length);
        var o = $(".bottom_fix"), d = parseInt(o.find(".pro_price").width()) - o.find("span:first-child").width() - 18;
        o.find(".zhe").css("width", d);
        var l = new IScroll($wrapper[0], {
            startX: 0 != $video.length ? -$(".pro_img").width() : 0,
            scrollX: !0,
            scrollY: !1,
            momentum: !1,
            snap: !0
        });
        0 != $video.length && (l.currentPage.pageX = 1, l.currentPage.x = -$(".pro_img").width()), l.on("beforeScrollStart", function () {
        }), l.on("scrollStart", function () {
            Math.abs(l.distY) > Math.abs(l.distX) && (l.initiated = !1)
        }), l.on("scrollEnd", function () {
            var e = l.currentPage.pageX + 1;
            r.indicator_update(e, $slide), r.load_img(e)
        });
        var c = $("#logined"), p = $("#product").data("id");
        get_cookie("No") && "favorite" == get_cookie("Mark") ? favorite.add(get_cookie("No"), function (e) {
            app.clear_cookie("Mark"), app.clear_cookie("No"), e && e.favorite && $(".collect_ico").addClass("push").attr("data-id", e.favorite.id)
        }) : app.get_user() && favorite.get(p, function (e) {
            e.favorites && e.favorites[0] && n.addClass("push").data("id", e.favorites[0].id)
        }), -1 != window.location.search.indexOf("?share=") && -1 != navigator.userAgent.toLowerCase().indexOf("micromessenger") && $("#wechat_share_tip").removeClass("hide"), app.close_tip_layer($("#wechat_share_tip")), r.img_event($wrapper.find("a"), l), r.img_event($(".product_img img"), l), r.close_img($("#close_img"), l), r.select_event(e, t, i), r.select_event(a, t, i), r.size_event(i, a, s), r.add_cart_event(s, p, i, t, e, a, c), r.favorite_event(n, c, p), r.position_event($("header .info_ico"), ".product_info"), r.position_event($(".box_right"), ".size_detail"), "true" != r.ulife && r.recommend(), "true" == r.ulife && "true" != r.if_product && ($("#product").addClass("ulife_pro_detail").css("height", "196px !important"), $(".product_info").addClass("ulife_shadow")), void 0 == $(".product_info").children()[0] && $(".info_ico").addClass("hide"), app.push_event($(".optional_box.color .border, .enter_multibuy"), 200)
    }, select_event: function (e, a, t) {
        var i = $(e), s = .81 * DeviceInfo.width - 26, n = parseInt((s - 40) / 58), r = .9 * DeviceInfo.width, o = parseInt((r - 40) / 58);
        r - 58 * o > 40 && (o += 1, $(".optional_box > .wrapper:nth-child(" + o + "n )").css("margin-right", "0")), 1 != $(".box_right").length ? ($(".optional_box.size > div").removeClass("box_left"), $(".optional_box > div .wrapper:nth-child(" + o + "n )").css("margin-right", "0")) : s - 58 * n > 40 && 1 == $(".box_right").length && (n += 1, $(".optional_box .box_left >.wrapper:nth-child(" + n + "n)").css("margin-right", "0")), $.each(t.find(".wrapper"), function (e, a) {
            var t = $(a).find("p"), i = t.text().length;
            5 == i ? t.addClass("size_13") : 6 == i ? t.addClass("size_12") : 7 == i ? t.addClass("size_11") : i >= 8 && t.addClass("size_9")
        }), i.bind(itap_event, function () {
            var e = $(this);
            e.toggleClass("active").siblings().removeClass("active"), e.hasClass("opt_color") ? (a.toggleClass("hide"), t.addClass("hide")) : e.hasClass("opt_size") ? (t.toggleClass("hide"), a.addClass("hide")) : (a.addClass("hide"), t.addClass("hide")), $(".box_right").css({
                "padding-top": ($(".box_left").height() - 54) / 2 + "px",
                "padding-bottom": ($(".box_left").height() - 54) / 2 + "px"
            }), app.iscroll.refresh()
        })
    }, size_event: function (e, a, t) {
        var i = $(e), s = this;
        i.find(".wrapper").bind(itap_event, function () {
            var e = $(this);
            if (!e.hasClass("no_size")) {
                e.addClass("active").siblings().removeClass("active"), $(".opt_size").html("<span>\u5c3a\u7801 <i>" + e.data("size") + "</i><em></em></span>"), setTimeout(function () {
                    a.removeClass("active"), i.addClass("hide")
                }, 100);
                var n = [], r = e.data("size");
                r && (n = $("#measure").text().split(","));
                for (var o in n) {
                    if (r == n[o])return void t.removeClass("false").addClass("true");
                    "true" === s.hwg ? (t.removeClass("false").addClass("true"), s.ulife_add_cart($("#product").data("id"), e.data("size"), "hwg")) : "true" === s.ulife ? (t.removeClass("false").addClass("true"), s.ulife_add_cart($("#product").data("id"), e.data("size"), "ulife")) : t.removeClass("true").addClass("false")
                }
                if (e.parent().parent(".optional_box.size").hasClass("add_size") && !t.hasClass("true")) {
                    t.removeClass("false").addClass("true");
                    var d = $("#product").data("id"), l = "retail_cart[product_id]=" + d + "&retail_cart[measure]=" + r;
                    return app.get_user() ? ($(".bottom_fix .btn").addClass("push"), "true" === s.hwg ? ($(".bottom_fix .btn").removeClass("push"), s.ulife_add_cart(d, r, "hwg")) : "true" === s.ulife ? ($(".bottom_fix .btn").removeClass("push"), s.ulife_add_cart(d, r, "ulife")) : cart.add_new(l, function (e) {
                        if (e && !e.error) {
                            $(".bottom_fix .btn").removeClass("push");
                            var a = parseInt($(".nav_cart em").text()) || 0;
                            $("#small_tip").removeClass("hide").addClass("cart").html("\u5df2\u6210\u529f\u52a0\u5165\u8d2d\u7269\u8f66"), $(".nav_cart > div").html('<span class="sprites"></span><em>' + (a + 1) + "</em>"), setTimeout(function () {
                                $("#small_tip").addClass("hide")
                            }, 1e3), $("#measure").html(r + "," + $("#measure").text())
                        } else $(".bottom_fix .btn").removeClass("push")
                    })) : cart.add_new(l, function (e) {
                        if (e && !e.error) {
                            var a = parseInt($(".nav_cart em").text()) || 0;
                            $("#small_tip").removeClass("hide").addClass("cart").html("\u5df2\u6210\u529f\u52a0\u5165\u8d2d\u7269\u8f66"), $(".nav_cart > div").html('<span class="sprites"></span><em>' + (a + 1) + "</em>"), setTimeout(function () {
                                $("#small_tip").addClass("hide")
                            }, 1e3), $("#measure").html(r + "," + $("#measure").text())
                        }
                    }), void e.parent().parent(".optional_box.size").removeClass("add_size")
                }
            }
        })
    }, position_event: function (e, a) {
        $(e).bind(itap_event, function () {
            var e = $(this);
            e.addClass("push"), app.iscroll.scrollToElement(a), setTimeout(function () {
                e.removeClass("push")
            }, 100)
        })
    }, ulife_add_cart: function (e, a, t) {
        var i = !1;
        "true" == this.if_product && (i = !0), cart.add_only(e, a, i, t, function () {
            a && $("#measure").html(a + "," + $("#measure").text())
        })
    }, add_cart_event: function (e, a, t, i, s, n) {
        var r = this;
        $(e).bind(itap_event, function (e) {
            e.preventDefault(), e.stopPropagation();
            var a = $(this), o = ($("#product").height(), $(".size .wrapper.active")), d = $("#main"), l = $(".uyuan_pro"), c = $(".u_lack"), p = $(".upper_limit"), h = $(".level_limit"), u = parseInt(l.data("uyuan")), _ = parseInt(l.data("pro")), v = parseInt(l.data("times"));
            if (levels = parseInt(l.data("level")), !a.hasClass("sale_out") && !a.hasClass("push")) {
                if (a.hasClass("false")) {
                    if (1 === n.length && 0 === o.length) {
                        t.removeClass("hide"), i.addClass("hide"), n.addClass("active"), s.removeClass("active"), t.addClass("add_size");
                        var f = $("#loading16"), m = '<p><span class="add_cart sprites"></span>\u8d2d\u4e70</p><span class="go_buy">\u7ed3\u7b97</span><div class="down_shadow"></div>';
                        return "true" === r.ulife && (m = '<p><span class="u_txt">U</span>\u5143\u8d2d\u4e70</p><p class="go_buy"><span class="u_txt">U</span>\u5143\u8d2d\u4e70</p><div class="down_shadow"></div>'), "true" === r.hwg && (m = "<div>\u7acb\u5373\u8d2d\u4e70</div>"), $(".bottom_fix .btn").html(m + f.html()), app.iscroll.refresh(), void app.iscroll.scrollToElement($(".opt_size")[0], 300)
                    }
                    var g = o.data("size") || "", y = $("#product").data("id"), _ = "retail_cart[product_id]=" + y + "&retail_cart[measure]=" + g;
                    if (a.removeClass("false").addClass("true"), "true" === r.hwg)return r.ulife_add_cart(y, g, "hwg"), void cart.get("hwg", function (e) {
                        e && e.num && (setTimeout(function () {
                            a.removeClass("push")
                        }, 300), window.location.href = "/trades/new?from=hwg")
                    });
                    if ("true" === r.ulife)r.ulife_add_cart(y, g, "ulife"); else {
                        a.addClass("push");
                        var m = '<p><span class="add_cart sprites"></span>\u8d2d\u4e70</p><span class="go_buy">\u7ed3\u7b97</span><div class="down_shadow"></div>';
                        "true" === r.ulife && (m = '<p><span class="u_txt">U</span>\u5143\u8d2d\u4e70</p><p class="go_buy"><span class="u_txt">U</span>\u5143\u8d2d\u4e70</p><div class="down_shadow"></div>'), "true" === r.hwg && (m = "<div>\u7acb\u5373\u8d2d\u4e70</div>"), $(".bottom_fix .btn").html(m)
                    }
                    return void cart.add_new(_, function (e) {
                        if (e && !e.error) {
                            a.removeClass("push");
                            var t = parseInt($(".nav_cart em").text()) || 0;
                            $("#small_tip").removeClass("hide").addClass("cart").html("\u5df2\u6210\u529f\u52a0\u5165\u8d2d\u7269\u8f66"), $(".nav_cart > div").html('<span class="sprites"></span><em>' + (t + 1) + "</em>"), setTimeout(function () {
                                $("#small_tip").addClass("hide")
                            }, 1e3), $("#measure").html(g + "," + $("#measure").text())
                        } else a.removeClass("push")
                    })
                }
                var f = $("#loading16"), m = '<p><span class="add_cart sprites"></span>\u8d2d\u4e70</p><span class="go_buy">\u7ed3\u7b97</span><div class="down_shadow"></div>';
                "true" === r.ulife && (m = '<p><span class="u_txt">U</span>\u5143\u8d2d\u4e70</p><p class="go_buy"><span class="u_txt">U</span>\u5143\u8d2d\u4e70</p><div class="down_shadow"></div>'), "true" === r.hwg && (m = "<div>\u7acb\u5373\u8d2d\u4e70</div>");
                var C;
                C = "true" === r.hwg ? "/trades/new?from=hwg" : "true" === r.ulife ? "/trades/new?from=ulife" : "/trades/new", a.addClass("push"), "true" === r.hwg ? ($(".bottom_fix .btn").html(m), r.ulife_add_cart($("#product").data("id"), "", "hwg"), cart.get("hwg", function (e) {
                    e && e.num && (setTimeout(function () {
                        a.removeClass("push")
                    }, 300), window.location.href = C)
                })) : "true" === r.ulife ? ($(".bottom_fix .btn").html(m), $("#measure").text() ? (a.removeClass("push"), 1 > levels ? (h.removeClass("hide"), setTimeout(function () {
                    h.addClass("hide")
                }, 3e3)) : _ > u ? (c.removeClass("hide"), setTimeout(function () {
                    c.addClass("hide")
                }, 3e3)) : cart.get("ulife", function (e) {
                    e && e.num && (setTimeout(function () {
                        a.removeClass("push")
                    }, 300), window.location.href = C)
                })) : (a.removeClass("push"), r.ulife_add_cart($("#product").data("id"), "", "ulife"), 1 > levels ? (h.removeClass("hide"), setTimeout(function () {
                    h.addClass("hide")
                }, 3e3)) : _ > u ? (c.removeClass("hide"), setTimeout(function () {
                    c.addClass("hide")
                }, 3e3)) : "false" == r.if_product && 1 > v ? (p.removeClass("hide"), setTimeout(function () {
                    p.addClass("hide")
                }, 3e3)) : window.location.href = C)) : ($(".bottom_fix .btn").html(m + f.html()), cart.get_new(function (e) {
                    if (e && e.retail_carts.length)if (a.removeClass("push"), 1 === e.retail_carts.length)if (app.get_user())window.location.href = C; else {
                        var t, i = navigator.userAgent.toLowerCase();
                        "micromessenger" == i.match(/MicroMessenger/i) ? t = "wechat" : "aliapp" == i.match(/AliApp/i) && (t = "alipay"), t ? (app.handle_cookie("Mark", "go_pay"), app.authorize_login(t, C)) :
                            ($("#login_layer, #login_register_layer").removeClass("hide"), app.layer_appear($("#login_register_layer")), d.append('<input type="hidden" id="go_pay">'))
                    } else e.retail_carts.length > 1 && (window.location.href = "/carts")
                }))
            }
        })
    }, favorite_event: function (e, a, t) {
        $(e).bind(itap_event, function () {
            var e = $(this);
            if (e.hasClass("push")) {
                var a = e.data("id");
                favorite.remove(a, function (a) {
                    a && e.attr("data-id", "").removeClass("push")
                })
            } else if (e.toggleClass("push"), app.get_user())favorite.add(t, function (a) {
                a && a.favorite && ($("#small_tip").removeClass("hide").addClass("pro").html("\u5546\u54c1\u6536\u85cf\u6210\u529f"), e.attr("data-id", a.favorite.id), setTimeout(function () {
                    $("#small_tip").addClass("hide")
                }, 1e3))
            }); else {
                var i, s = navigator.userAgent.toLowerCase();
                "micromessenger" == s.match(/MicroMessenger/i) ? i = "wechat" : "aliapp" == s.match(/AliApp/i) && (i = "alipay"), i ? (app.authorize_login(i, window.location.href), app.handle_cookie("Mark", "favorite"), app.handle_cookie("No", t)) :
                    ($("#login_layer, #login_register_layer").removeClass("hide"), app.layer_appear($("#login_register_layer")), $("#main").append('<input type="hidden" id="favorite" data-id="' + t + '">'))
            }
        })
    }, recommend: function () {
        var e = $("#product").data("id");
        products.get_recommend(e, function (e) {
            if (e) {
                var a = "", t = .344 * DeviceInfo.width;
                get_cookie("ratio") && (t *= get_cookie("ratio"));
                for (var i = 0; 4 > i; i++) {
                    var s = "";
                    i % 2 == 1 && (s = "right"), a = a + '<div class="product" data-href="/products/' + e.product_infos[i].id + '"><div class="img_wrap pro_img recommend_width recommend_height ' + s + ' "><img class="recommend_width recommend_height" width="110" height="110"data-src="' + app.pic(e.product_infos[i].major_pic_url, t) + '"><div class="down_shadow"></div></div><div class="clear"></div><p class="products_name ellipsis recommend_width ' + s + ' ">' + e.product_infos[i].name + '</p><span class="products_price clear_fix recommend_width ' + s + ' ">\uffe5' + e.product_infos[i].discount + "</span></div>"
                }
                $(".products_content").html(a), app.lasy_load($(".products_content img")), app.push_event($(".product"), 200)
            }
            app.iscroll.refresh()
        })
    }, img_event: function (e, a) {
        var t = this;
        $(e).bind(itap_event, function (e) {
            e.preventDefault(), e.stopPropagation();
            var i = $(this);
            if (!i.hasClass("ticket_img"))if (i.parent("a").hasClass("inverse") ? $("#pic_layer").addClass("inverse") : $("#pic_layer").removeClass("inverse"), i.hasClass("video_player"))window.location.href = i.data("href"); else {
                var s, n = document.createElement("img");
                if (n.src = i[0].src ? i[0].src : i.find("img")[0].src, $("#pic_layer").removeClass("hide").find(".img_wrapper").prepend(n), app.iscroll.disable(), a.disable(), s = (DeviceInfo.height - DeviceInfo.width) / 2, !i.parent("a").parent("div").hasClass("size_img")) {
                    var r = document.createElement("img");
                    $(r).bind("load", function () {
                        n.src = r.src
                    }).bind("error", function () {
                    }), r.src = i.data("origin")
                }
                $("#pic_layer > div").css({top: s, bottom: s}), t.scroll_init()
            }
        })
    }, close_img: function (e, a) {
        $(e).bind(itap_event, function () {
            $("#pic_layer").addClass("hide").find("img").remove(), app.iscroll.enable(), a.enable()
        })
    }, scroll_init: function () {
        var e = new IScroll($("#pic_layer > div")[0], {zoom: !0, scrollX: !0, scrollY: !0});
        e.on("touchmove", function (e) {
            e.preventDefault()
        }, !1), e.on("zoomStart", function () {
        }), e.on("zoomEnd", function () {
            var a = $("#pic_layer img").height();
            if (a > DeviceInfo.height)$("#pic_layer > div").css({top: 0, bottom: 0}); else {
                var t = (DeviceInfo.height - a) / 2;
                $("#pic_layer > div").css({top: t, bottom: t})
            }
            e.refresh()
        })
    }, load_img: function (e) {
        1 == e && video_src && $video.children("div").removeClass("hide");
        var a = "a:nth-of-type(" + e + ")", t = $("#loading"), i = $(".img_wrap").find(a);
        if (!i.find("img")[0]) {
            i.html(t.html());
            var s = document.createElement("img");
            s.width = "225", s.height = "225", $(s).bind("load", function () {
                i.html(s), $(s).addClass(i.hasClass("ticket_img") ? "ticket_img" : "pro_width pro_height"), $(s).parent("a").addClass("loaded")
            }).bind("error", function () {
                i.html(s), $(s).parent("a").addClass("failed")
            }), i.length > 0 && (s.src = i.data("src")), $("#loading").addClass("hide")
        }
    }, indicator_update: function (e, a) {
        var t = $(a);
        t.children(".active").removeClass("active"), t.find("li:nth-child(" + e + ")").addClass("active")
    }
}, trades_paymode_controller = {
    paymode_event: function (e, a, t, i) {
        var s = this;
        s.close_layer(a), e.bind(itap_event, function () {
            var e = $(this);
            e.addClass("active").siblings(".mode_pay").removeClass("active");
            var s = "\u514d\u8fd0\u8d39";
            "true" === t && (s = "\u542b\u8fd0\u8d39\uffe5" + i), setTimeout(function () {
                var t = e.data("name");
                $(".online_pay p").html(t), $(".payment_mode_txt").html(t + '\u652f\u4ed8<span class="transport_free">\uff08' + s + "\uff09</span>"), a.trigger("click")
            }, 100)
        })
    }, close_layer: function (e) {
        e.bind("click touchstart", function (e) {
            e.preventDefault();
            var a = $("#pay_layer"), t = a.find(".pay_body");
            t.removeClass("appear"), app.iscroll.enable(), setTimeout(function () {
                a.addClass("hide")
            }, 300), $(".zhaoshang").hasClass("active") || $(".zhifubao").hasClass("active") || $(".wechat_pay").hasClass("active") || ($(".online_pay").removeClass("active"), $(".pay_select .cash_pay").addClass("active"))
        })
    }, show_layer: function () {
        var e = $("#pay_layer"), a = e.find(".pay_body");
        e.removeClass("hide"), app.iscroll.disable(), setTimeout(function () {
            a.addClass("appear")
        }, 100)
    }
}, cart_index_controller = {
    initialize: function (e, a, t, i, s) {
        var n = this;
        $("#main").append('<input type="hidden" id="page" data-page="cart">'), $("#nav").addClass("hide"), 1 === $(".shopping_bag").length ? $(".edit_ico").removeClass("hide") : $(".edit_ico").addClass("hide"), n.select(e, a, t), n.remove(t), n.go_pay(s), n.set_multibuy(), app.stop_link(i)
    }, balance: function () {
        var e = $(".bag_price").map(function (e, a) {
            return $(a).html().replace("\uffe5", "")
        }), a = 0;
        for (var t in e)a += parseInt(e[t]);
        $(".bag_sum .sum").html("\uffe5" + a)
    }, set_multibuy: function () {
        var e = this;
        if (0 != $("#multibuyids").length) {
            var a = $("#multibuyids").text().split(",");
            for (var t in a) {
                var i, s, n, r, o, d = $(".m" + a[t]), l = d.find(".cart_enter_multibuy"), c = d.length, p = function (e, a, t) {
                    i = 100 - $("#multibuy" + e).data(t), isNaN(i) ? (o = '<span class="sprites multibuy_ico left"></span><p class="ellipsis">\u8fdb\u5165' + $("#multibuy" + e).data("one") + '</p><span class="sprites m_enter_ico right"></span>', l.html(o), $.each(d, function (e, a) {
                        var t = $(a).find(".bag_price"), i = $(a).find(".rebate_price");
                        n = $(a).data("discount"), i.html(""), t.html("\uffe5" + n)
                    })) : (i % 10 == 0 && (i /= 10), o = '<span class="sprites multibuy_ico left"></span><p class="ellipsis">\u5df2\u4eab\u53d7\u8fde\u62cd' + a + "\u4ef6" + i + '\u6298\u4f18\u60e0</p><span class="sprites m_enter_ico right"></span>', l.html(o), $.each(d, function (e, a) {
                        var t = $(a).find(".bag_price"), o = $(a).find(".rebate_price");
                        n = $(a).data("discount"), s = i / 100, 0 == parseInt(i / 10) && (s = i / 10), r = parseInt(n * s), o.html("\uffe5" + n + '<span class="underline"></span>'), t.html("\uffe5" + r)
                    }))
                };
                2 > c ? p(a[t], c, "one") : 2 == c ? p(a[t], c, "two") : 3 == c ? p(a[t], c, "three") : c > 3 && p(a[t], c, "four")
            }
            e.balance()
        }
    }, select: function (e, a, t) {
        $(e).bind(itap_event, function (e) {
            e.preventDefault(), e.stopPropagation();
            var i = $(this);
            i.toggleClass("active");
            var s = $(".bag_cancel.active"), n = s.length;
            a.html("\u5df2\u9009\u5b9a" + n + "\u4ef6\u5546\u54c1"), 0 === n ? t.removeClass("black_bg").addClass("grey_bg") : t.removeClass("grey_bg").addClass("black_bg")
        })
    }, remove: function (e) {
        $(e).bind("click touchstart", function (e) {
            e.preventDefault(), e.stopPropagation();
            var a = $(this), t = $(".bag_cancel.active"), i = [];
            if (!a.hasClass("grey_bg") && !a.hasClass("push")) {
                if (a.addClass("push"), $.each(t, function (e, a) {
                        $(a).data("id") && i.push(parseInt($(a).data("id")))
                    }), i.length > 0) {
                    var s = $("#loading16");
                    $(".bag_delete").html("<span>\u5220\u9664</span>" + s.html())
                }
                if (!confirm("\u786e\u8ba4\u5220\u9664?"))return void a.removeClass("push");
                for (var n = i.length, r = 0; r < i.length; r++)cart.del_new(i[r], function (e) {
                    e && !e.error && (n -= 1, 0 == n && (window.location.href = "/carts"))
                })
            }
        })
    }, go_pay: function (e) {
        var a = $(e), t = $("#main");
        a.unbind("click touchstart").bind("click touchstart", function () {
            var e = $(this), i = $(".pro_sale_out"), s = $(".pro_vip_pro");
            if (e.addClass("push"), "true" === a.data("hwg"))alert("\u8d2d\u7269\u8f66\u4e2d\u542b\u6709\u514d\u7a0e\u5e97\u5546\u54c1\uff0c\u9700\u8981\u5355\u72ec\u7ed3\u7b97"); else if (i.length > 0)alert("\u8bf7\u5148\u5220\u9664\u552e\u5b8c\u5546\u54c1"); else if (s.length > 0)alert("\u8bf7\u5148\u5220\u9664\u4e13\u5c5e\u5546\u54c1"); else if (app.get_user())window.location.href = "/trades/new"; else {
                var n, r = navigator.userAgent.toLowerCase();
                "micromessenger" == r.match(/MicroMessenger/i) ? n = "wechat" : "aliapp" == r.match(/AliApp/i) && (n = "alipay"), n ? (app.handle_cookie("Mark", "go_pay"), app.authorize_login(n, "/trades/new")) :
                    ($("#login_layer, #login_register_layer").removeClass("hide"), app.layer_appear($("#login_register_layer")), t.append('<input type="hidden" id="go_pay" >'))
            }
            setTimeout(function () {
                e.removeClass("push")
            }, 200)
        })
    }
}, help_detail_controller = {
    initialize: function () {
        $.each($(".size_img_wrap img"), function (e, a) {
            var t = $(a), i = t.attr("src"), s = new Image;
            s.src = i, $(s).bind("load", function () {
                var e = s.width, a = h = s.height;
                e > DeviceInfo.width && (a = parseInt(.9 * DeviceInfo.width * h / e)), t.css("height", a), t.parent("a").css("height", a), app.iscroll.refresh()
            })
        })
    }
};
