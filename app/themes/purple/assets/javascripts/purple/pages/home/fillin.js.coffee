$ ->
	fillin()
	
fillin = (option)->
	constructor = 
		id : ["user_signup_account_email","user_login_account_login"]
		wrap : ".jqTransformInputWrapper"
		mail : ["qq.com","163.com","126.com","sohu.com","sina.com","189.cn","gmail.com","hotmail.com","139.com"]
		list : ".fillin"
		item : "li"
		hover : "fillin_hover"
		
	op = $.extend constructor,option
	$doc = $(document)

	# define $ul and bind with functions
	$ul = $('<ul class="'+op.list[1..]+'"></ul>')
	$ul.on 'mouseover mousemove',(event)->
		$(this).css("cursor","pointer")
		e = event or window.event
		_this = e.target or e.srcElement
		_this_name = _this.localName or _this.nodeName
		if _this_name.toLowerCase() is op.item
			$(this).children(".#{op.hover}").removeClass(op.hover)
			$(_this).addClass(op.hover)
			
	$ul.on 'mouseout',(event)->
		$(this).children(".#{op.hover}").removeClass(op.hover)
		$(this).css("cursor","")
	
	$ul.on 'mousedown',(event)->
		e = event or window.event
		_this = e.target or e.srcElement
		$(this).prev().find('input').val($(_this).text())

	$ul.on 'click',(event)->
		if $(this).parent().siblings().find('input#user_signup_account_password').length then $(this).parent().siblings().find('input#user_signup_account_password').focus()
		else $(this).parent().siblings().find('input#user_login_account_password').focus()
	
	$doc.on 'focusout',(event)->
		e = event or window.event
		_this = e.target or e.srcElement
		exist = yes for _id in op.id when $(_this).is("##{_id}")
		if exist then $(op.list).filter(':visible').delay(100).hide(1)
	
	$doc.on 'keyup',(event)->
		e = event or window.event
		_this = e.target or e.srcElement
		exist = yes for _id in op.id when $(_this).is("##{_id}")
		if exist
			k = e.keyCode
			if k not in [38,40,13]
				val = $(_this).val()
				if val
					# append $ul.clone
					if not $(op.list).length
						$ul.css("width",$(_this).innerWidth()+12)
						# $ul.css({"left":$(_this).offset().left,"top":$(_this).offset().top+$(_this).outerHeight()})
						$(_this).parents(op.wrap).after($ul.clone(1))
					li = ''
					flag = val.indexOf '@'
					arr = []
					if flag isnt -1
						arr[0] = val[0...flag]
						arr[1] = val[flag+1..]
					else
						arr[0] = val
						arr[1] = ''
					for mail in op.mail
						if mail and mail is arr[1]
							li = ""
							break;
						else if mail.indexOf(arr[1]) isnt -1
							li = li + '<li id="'+mail+'">'+arr[0]+'@'+mail+'</li>'
					if li
						$(op.list).html(li)
						$(op.list).scrollTop 0
						$(op.list).children('li').first().addClass(op.hover)
						if not $(op.list).filter(':visible').length then $(op.list).show()
					else 
						$(op.list).filter(':visible').hide(1)
				else 
					$(op.list).filter(':visible').hide(1)

	# define arrow key event
	$doc.on 'keydown',(event)->
		e = event or window.event
		_this = e.target or e.srcElement
		exist = yes for _id in op.id when $(_this).is("##{_id}")
		if exist
			k = e.keyCode
			if k in [38,40,13]
				if $(op.list).length
					li_hei = $(op.list).children('li').first().outerHeight()
					ul_hei = $(op.list).innerHeight()
					switch k
						when 38 ## arrow up
							if not $(op.list).children(".#{op.hover}").length
								$(op.list).children().eq(($(op.list).scrollTop()+ul_hei)//li_hei-1).addClass(op.hover)
								$(op.list).prev().find('input').val($(op.list).children(".#{op.hover}").text())
							else if $(op.list).children(".#{op.hover}").prev().length
								$(op.list).children(".#{op.hover}").prev().addClass(op.hover).end().removeClass(op.hover)
								$(op.list).prev().find('input').val($(op.list).children(".#{op.hover}").text())
								if $(op.list).scrollTop()
									if li_hei + $(op.list).children(".#{op.hover}").position().top < li_hei
										$(op.list).scrollTop($(op.list).scrollTop() - li_hei)
								return false
						when 40 ## arrow down
							if not $(op.list).children(".#{op.hover}").length
								$(op.list).children().eq(Math.round($(op.list).scrollTop()/li_hei)).addClass(op.hover)
								$(op.list).prev().find('input').val($(op.list).children(".#{op.hover}").text())
							else if $(op.list).children(".#{op.hover}").next().length
								$(op.list).children(".#{op.hover}").next().addClass(op.hover).end().removeClass(op.hover)
								$(op.list).prev().find('input').val($(op.list).children(".#{op.hover}").text())
								if li_hei + $(op.list).children(".#{op.hover}").position().top > ul_hei
									$(op.list).scrollTop($(op.list).scrollTop() + li_hei)
						when 13
							if $(op.list).children(".#{op.hover}").length
								$(op.list).prev().find('input').val($(op.list).children(".#{op.hover}").text())
								$(op.list).filter(':visible').hide(1)