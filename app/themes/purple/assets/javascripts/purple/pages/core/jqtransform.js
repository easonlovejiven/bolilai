/*
 *
 * jqeraform
 * by mathieu vilaplana mvilaplana@dfc-e.com
 * Designer ghyslain armand garmand@dfc-e.com
 *
 *
 * Version 1.0 25.09.08
 * Version 1.1 06.08.09
 * Add event click on Checkbox and Radio
 * Auto calculate the size of a select element
 * Can now, disabled the elements
 * Correct bug in ff if click on select (overflow=hidden)
 * No need any more preloading !!
 * 
 * Modified on 2012-12-03
 * By phpcup
 * 
 * 
 ******************************************** */

(function ($) {
    var defaultOptions = {preloadImg: true};
    var jqeraformImgPreloaded = false;

    var jqeraformPreloadHoverFocusImg = function (strImgUrl) {
        //guillemets to remove for ie
        strImgUrl = strImgUrl.replace(/^url\((.*)\)/, '$1').replace(/^\"(.*)\"$/, '$1');
        var imgHover = new Image();
        imgHover.src = strImgUrl.replace(/\.([a-zA-Z]*)$/, '-hover.$1');
        var imgFocus = new Image();
        imgFocus.src = strImgUrl.replace(/\.([a-zA-Z]*)$/, '-focus.$1');
    };


    /***************************
     Labels
     ***************************/
    var jqeraformGetLabel = function (objfield) {
        var selfForm = $(objfield.get(0).form);
        var oLabel = objfield.next();
        if (!oLabel.is('label')) {
            oLabel = objfield.prev();
            if (oLabel.is('label')) {
                var inputname = objfield.attr('id');
                if (inputname) {
                    oLabel = selfForm.find('label[for="' + inputname + '"]');
                }
            }
        }
        // if(oLabel.is('label')){return oLabel.css('cursor','pointer');}
        return false;
    };

    /* Hide all open selects */
    var jqeraformHideSelect = function (oTarget) {
        var ulVisible = $('.jqeraformSelectWrapper ul:visible');
        ulVisible.each(function () {
            var oSelect = $(this).parents(".jqeraformSelectWrapper:first").find("select").get(0);
            //do not hide if click on the label object associated to the select
            if (!(oTarget && oSelect.oLabel && oSelect.oLabel.get(0) == oTarget.get(0))) {
                $(this).hide();
            }
        });
    };
    /* Check for an external click */
    var jqeraformCheckExternalClick = function (event) {
        if ($(event.target).parents('.jqeraformSelectWrapper').length === 0) {
            jqeraformHideSelect($(event.target));
        }
    };

    /* Apply document listener */
    var jqeraformAddDocumentListener = function () {
        $(document).mousedown(jqeraformCheckExternalClick);
    };

    /* Add a new handler for the reset action */
    var jqeraformReset = function (f) {
        var sel;
        $('.jqeraformSelectWrapper select', f).each(function () {
            sel = (this.selectedIndex < 0) ? 0 : this.selectedIndex;
            $('ul', $(this).parent()).each(function () {
                $('a:eq(' + sel + ')', this).click();
            });
        });
        $('a.jqeraformCheckbox, a.jqeraformRadio', f).removeClass('jqeraformChecked');
        $('input:checkbox, input:radio', f).each(function () {
            if (this.checked) {
                $('a', $(this).parent()).addClass('jqeraformChecked');
            }
        });
    };

    /***************************
     Buttons
     ***************************/
    $.fn.jqeraInputButton = function () {
        return this.each(function () {
            var newBtn = $('<button id="' + this.id + '" name="' + this.name + '" type="' + this.type + '" class="' + this.className + ' jqeraformButton"><span><span>' + $(this).attr('value') + '</span></span>')
                    .hover(function () {
                        newBtn.addClass('jqeraformButton_hover');
                    }, function () {
                        newBtn.removeClass('jqeraformButton_hover')
                    })
                    .mousedown(function () {
                        newBtn.addClass('jqeraformButton_click')
                    })
                    .mouseup(function () {
                        newBtn.removeClass('jqeraformButton_click')
                    })
                ;
            $(this).replaceWith(newBtn);
        });
    };

    /***************************
     Text Fields
     ***************************/
        // $.fn.jqeraInputText = function(){
        // 	return this.each(function(){
        // 		var $input = $(this);
        //
        // 		if($input.hasClass('jqtranformdone') || !$input.is('input')) {return;}
        // 		$input.addClass('jqtranformdone');
        //
        // 		var oLabel = jqeraformGetLabel($(this));
        // 		oLabel && oLabel.bind('click',function(){$input.focus();});
        //
        // 		var inputSize=$input.width();
        // 		if($input.attr('size')){
        // 			inputSize = $input.attr('size')*10;
        // 			$input.css('width',inputSize);
        // 		}
        //
        // 		$input.addClass("jqeraformInput").wrap('<div class="jqeraformInputWrapper"><div class="jqeraformInputInner"><div></div></div></div>');
        // 		var $wrapper = $input.parent().parent().parent();
        // 		$wrapper.css("width", inputSize+10);
        // 		$input
        // 			.focus(function(){$wrapper.addClass("jqeraformInputWrapper_focus");})
        // 			.blur(function(){$wrapper.removeClass("jqeraformInputWrapper_focus");})
        // 			.hover(function(){$wrapper.addClass("jqeraformInputWrapper_hover");},function(){$wrapper.removeClass("jqeraformInputWrapper_hover");})
        // 		;
        //
        // 		/* If this is safari we need to add an extra class */
        // 		// $.browser.safari && $wrapper.addClass('jqeraformSafari');
        // 		// $.browser.safari && $input.css('width',$wrapper.width()+16);
        // 		this.wrapper = $wrapper;
        //
        // 	});
        // };
    $.fn.jqeraInputText = function () {
        return this.each(function () {
            var $input = $(this);

            if ($input.hasClass('jqeraformdone') || !$input.is('input')) {
                return;
            }
            $input.addClass('jqeraformdone');

            var oLabel = jqeraformGetLabel($(this));
            oLabel && oLabel.bind('click', function () {
                $input.focus();
            });

            var inputSize = $input.width();
            if ($input.attr('size')) {
                inputSize = $input.attr('size') * 10;
                $input.css('width', inputSize);
            }

            // $input.addClass("jqeraformInput").wrap('<div class="jqeraformInputWrapper"><div class="jqeraformInputInner"><div></div></div></div>');
            $input.addClass("jqeraformInput").wrap('<div class="jqeraformInputWrapper"><div class="jqeraformInputInner"></div><!--[if IE]><span class="formleft"></span><span class="formright"></span><![endif]--></div>');
            // var $wrapper = $input.parent().parent().parent();
            var $wrapper = $input.parent().parent();
            // $wrapper.css("width", inputSize+10);
            $wrapper.css("width", inputSize);
            $input
                .focus(function () {
                    $wrapper.addClass("jqeraformInputWrapper_focus");
                })
                .blur(function () {
                    $wrapper.removeClass("jqeraformInputWrapper_focus");
                })
                .hover(function () {
                    $wrapper.addClass("jqeraformInputWrapper_hover");
                }, function () {
                    $wrapper.removeClass("jqeraformInputWrapper_hover");
                })
            ;
            this.wrapper = $wrapper;
        });
    };

    /***************************
     Check Boxes
     ***************************/
    $.fn.jqeraCheckBox = function () {
        return this.each(function () {
            if ($(this).hasClass('jqeraformHidden')) {
                return;
            }

            var $input = $(this);
            var inputSelf = this;

            //set the click on the label
            var oLabel = jqeraformGetLabel($input);
            oLabel && oLabel.click(function () {
                aLink.trigger('click');
            });

            var aLink = $('<a href="#" class="jqeraformCheckbox"></a>');
            //wrap and add the link
            $input.addClass('jqeraformHidden').wrap('<span class="jqeraformCheckboxWrapper"></span>').parent().prepend(aLink);
            //on change, change the class of the link
            $input.change(function () {
                this.checked && aLink.addClass('jqeraformChecked') || aLink.removeClass('jqeraformChecked');
                return true;
            });
            // Click Handler, trigger the click and change event on the input
            aLink.click(function () {
                //do nothing if the original input is disabled
                if ($input.attr('disabled')) {
                    return false;
                }
                //trigger the envents on the input object
                $input.trigger('mousedown').trigger('click').trigger("change");
                return false;
            });

            // set the default state
            this.checked && aLink.addClass('jqeraformChecked');
        });
    };
    /***************************
     Radio Buttons
     ***************************/
    $.fn.jqeraRadio = function () {
        return this.each(function () {
            if ($(this).hasClass('jqeraformHidden')) {
                return;
            }

            var $input = $(this);
            var inputSelf = this;

            oLabel = jqeraformGetLabel($input);
            oLabel && oLabel.click(function () {
                aLink.trigger('click');
            });

            var aLink = $('<a href="#" class="jqeraformRadio" rel="' + this.name + '"></a>');
            $input.addClass('jqeraformHidden').wrap('<span class="jqeraformRadioWrapper"></span>').parent().prepend(aLink);

            $input.change(function () {
                inputSelf.checked && aLink.addClass('jqeraformChecked') || aLink.removeClass('jqeraformChecked');
                return true;
            });
            // Click Handler
            aLink.click(function () {
                if ($input.attr('disabled')) {
                    return false;
                }
                $input.trigger('mousedown').trigger('click').trigger('change');

                // uncheck all others of same name input radio elements
                $('input[name="' + $input.attr('name') + '"]', inputSelf.form).not($input).each(function () {
                    $(this).attr('type') == 'radio' && $(this).trigger('change');
                });

                return false;
            });
            // set the default state
            inputSelf.checked && aLink.addClass('jqeraformChecked');
        });
    };

    /***************************
     TextArea
     ***************************/
        // $.fn.jqeraTextarea = function(){
        // 	return this.each(function(){
        // 		var textarea = $(this);
        //
        // 		if(textarea.hasClass('jqeraformdone')) {return;}
        // 		textarea.addClass('jqeraformdone');
        //
        // 		oLabel = jqeraformGetLabel(textarea);
        // 		oLabel && oLabel.click(function(){textarea.focus();});
        //
        // 		var strTable = '<table cellspacing="0" cellpadding="0" border="0" class="jqeraformTextarea">';
        // 		strTable +='<tr><td id="jqeraformTextarea-tl"></td><td id="jqeraformTextarea-tm"></td><td id="jqeraformTextarea-tr"></td></tr>';
        // 		strTable +='<tr><td id="jqeraformTextarea-ml">&nbsp;</td><td id="jqeraformTextarea-mm"><div></div></td><td id="jqeraformTextarea-mr">&nbsp;</td></tr>';
        // 		strTable +='<tr><td id="jqeraformTextarea-bl"></td><td id="jqeraformTextarea-bm"></td><td id="jqeraformTextarea-br"></td></tr>';
        // 		strTable +='</table>';
        // 		var oTable = $(strTable)
        // 				.insertAfter(textarea)
        // 				.hover(function(){
        // 					!oTable.hasClass('jqeraformTextarea-focus') && oTable.addClass('jqeraformTextarea-hover');
        // 				},function(){
        // 					oTable.removeClass('jqeraformTextarea-hover');
        // 				})
        // 			;
        //
        // 		textarea
        // 			.focus(function(){oTable.removeClass('jqeraformTextarea-hover').addClass('jqeraformTextarea-focus');})
        // 			.blur(function(){oTable.removeClass('jqeraformTextarea-focus');})
        // 			.appendTo($('#jqeraformTextarea-mm div',oTable))
        // 		;
        // 		this.oTable = oTable;
        // 		// if($.browser.safari){
        // 		// 	$('#jqeraformTextarea-mm',oTable)
        // 		// 		.addClass('jqeraformSafariTextarea')
        // 		// 		.find('div')
        // 		// 			.css('height',textarea.height())
        // 		// 			.css('width',textarea.width())
        // 		// 	;
        // 		// }
        // 	});
        // };
    $.fn.jqeraTextarea = function () {
        return this.each(function () {
            var textarea = $(this);

            if (textarea.hasClass('jqeraformdone')) {
                return;
            }
            textarea.addClass('jqeraformdone');

            var strTable = '<div class="jqeraformTextarea" id="jqeraformTextarea">';
            strTable += '<!--[if IE]><span class="formleft"></span><span class="formright"></span><![endif]-->';
            strTable += '</div>';

            var oTable = $(strTable)
                    .insertAfter(textarea)
                    .hover(function () {
                        !oTable.hasClass('jqeraformTextarea_focus') && oTable.addClass('jqeraformTextarea_hover');
                    }, function () {
                        oTable.removeClass('jqeraformTextarea_hover');
                    })
                ;

            textarea
                .focus(function () {
                    oTable.removeClass('jqeraformTextarea_hover').addClass('jqeraformTextarea_focus');
                })
                .blur(function () {
                    oTable.removeClass('jqeraformTextarea_focus');
                })
                // .appendTo($('#jqeraformTextarea',oTable))
                .appendTo($('#jqeraformTextarea'), oTable)
            ;
            this.oTable = oTable;
        });
    };

    /***************************
     Select
     ***************************/
        // $.fn.jqeraSelect = function(){
        // 	return this.each(function(index){
        // 		var $select = $(this);
        //
        // 		if($select.hasClass('jqeraformHidden')) {return;}
        // 		if($select.attr('multiple')) {return;}
        //
        // 		var oLabel  =  jqeraformGetLabel($select);
        // 		/* First thing we do is Wrap it */
        // 		var $wrapper = $select
        // 			.addClass('jqeraformHidden')
        // 			.wrap('<div class="jqeraformSelectWrapper"></div>')
        // 			.parent()
        // 		//	.css({zIndex: 10-index})
        // 		;
        //
        // 		/* Now add the html for the select */
        // 		$wrapper.prepend('<div><span></span><a href="#" class="jqeraformSelectOpen"></a></div><ul></ul>');
        // 		var $ul = $('ul', $wrapper).css('width',$select.width()).hide();
        // 		/* Now we add the options */
        // 		$('option', this).each(function(i){
        // 			var oLi = $('<li><a href="#" index="'+ i +'">'+ $(this).html() +'</a></li>');
        // 			$ul.append(oLi);
        // 		});
        //
        // 		/* Add click handler to the a */
        // 		$ul.find('a').click(function(){
        // 				$('a.selected', $wrapper).removeClass('selected');
        // 				$(this).addClass('selected');
        // 				/* Fire the onchange event */
        // 				if ($select[0].selectedIndex != $(this).attr('index') /* && $select[0].onchange*/) { $select[0].selectedIndex = $(this).attr('index'); /*$select[0].onchange();*/$select.change(); }
        // 				$select[0].selectedIndex = $(this).attr('index');
        // 				$('span:eq(0)', $wrapper).html($(this).html());
        // 				$ul.hide();
        // 				return false;
        // 		});
        // 		/* Set the default */
        // 		$('a:eq('+ this.selectedIndex +')', $ul).click();
        // 		$('span:first', $wrapper).click(function(){$("a.jqeraformSelectOpen",$wrapper).trigger('click');});
        // 		oLabel && oLabel.click(function(){$("a.jqeraformSelectOpen",$wrapper).trigger('click');});
        // 		this.oLabel = oLabel;
        //
        // 		/* Apply the click handler to the Open */
        // 		var oLinkOpen = $('a.jqeraformSelectOpen', $wrapper)
        // 			.click(function(){
        // 				//Check if box is already open to still allow toggle, but close all other selects
        // 				if( $ul.css('display') == 'none' ) {jqeraformHideSelect();}
        // 				if($select.attr('disabled')){return false;}
        //
        // 				$ul.slideToggle('fast', function(){
        // 					var offSet = ($('a.selected', $ul).offset().top - $ul.offset().top);
        // 					$ul.animate({scrollTop: offSet});
        // 				});
        // 				return false;
        // 			})
        // 		;
        //
        // 		// Set the new width
        // 		var iSelectWidth = $select.outerWidth();
        // 		var oSpan = $('span:first',$wrapper);
        // 		var newWidth = (iSelectWidth > oSpan.innerWidth())?iSelectWidth+oLinkOpen.outerWidth():$wrapper.width();
        // 		$wrapper.css('width',newWidth);
        // 		$ul.css('width',newWidth/*-2*/);
        // 		oSpan.css({width:iSelectWidth});
        //
        // 		// Calculate the height if necessary, less elements that the default height
        // 		//show the ul to calculate the block, if ul is not displayed li height value is 0
        // 		$ul.css({display:'block',visibility:'hidden'});
        // 		var iSelectHeight = ($('li',$ul).length)*($('li:first',$ul).height());//+1 else bug ff
        // 		(iSelectHeight < $ul.height()) && $ul.css({height:iSelectHeight,'overflow':'hidden'});//hidden else bug with ff
        // 		$ul.css({display:'none',visibility:'visible'});
        //
        // 	});
        // };


    $.fn.jqeraform = function (options) {
        var opt = $.extend({}, defaultOptions, options);

        /* each form */
        return this.each(function () {
            var selfForm = $(this);
            if (selfForm.hasClass('jqeraformdone')) {
                return;
            }
            selfForm.addClass('jqeraformdone');

            $('input:submit, input:reset, input[type="button"]', this).jqeraInputButton();
            $('input:text, input:password', this).jqeraInputText();
            $('input:checkbox', this).jqeraCheckBox();
            $('input:radio', this).jqeraRadio();
            $('textarea', this).jqeraTextarea();

            // if( $('select', this).jqeraSelect().length > 0 ){jqeraformAddDocumentListener();}
            selfForm.bind('reset', function () {
                var action = function () {
                    jqeraformReset(this);
                };
                window.setTimeout(action, 10);
            });

            //preloading dont needed anymore since normal, focus and hover image are the same one
            /*if(opt.preloadImg && !jqeraformImgPreloaded){
             jqeraformImgPreloaded = true;
             var oInputText = $('input:text:first', selfForm);
             if(oInputText.length > 0){
             //pour ie on eleve les ""
             var strWrapperImgUrl = oInputText.get(0).wrapper.css('background-image');
             jqeraformPreloadHoverFocusImg(strWrapperImgUrl);
             var strInnerImgUrl = $('div.jqeraformInputInner',$(oInputText.get(0).wrapper)).css('background-image');
             jqeraformPreloadHoverFocusImg(strInnerImgUrl);
             }

             var oTextarea = $('textarea',selfForm);
             if(oTextarea.length > 0){
             var oTable = oTextarea.get(0).oTable;
             $('td',oTable).each(function(){
             var strImgBack = $(this).css('background-image');
             jqeraformPreloadHoverFocusImg(strImgBack);
             });
             }
             }*/


        });
        /* End Form each */

    };
    /* End the Plugin */

})(jQuery);
				   