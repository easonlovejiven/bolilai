$(function(){
	if (document.location.href.match(/msn\.weimall\.com/)) {
		$('body').addClass('msn layout_msn');
		if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="960" height="220" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/msn_header"></iframe>');
		if ($('#iframe_footer').html() == '') $('#iframe_footer').html('<iframe width="960" height="120" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/msn_footer"></iframe>');
		$(document).bind('reload', function(){ document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '名品特卖_MSN中文网') })
	} else if (document.location.href.match(/cmbc\.weimall\.com/)) {
		$('body').addClass('cmbc layout_cmbc');
		if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="960" height="192" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="http://www.cmbc.com.cn/shop/top.html"></iframe>');
		if ($('#iframe_footer').html() == '') $('#iframe_footer').html('<iframe width="960" height="170" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/cmbc_footer"></iframe>');
		$(document).bind('reload', function(){ document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '奢侈品_民生商城') })
	} else if (document.location.href.match(/comm\.weimall\.com/)) {
		$('body').addClass('layout_comm');
		if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="960" height="90" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/comm_header"></iframe>');
		if ($('#iframe_footer').html() == '') $('#iframe_footer').html('<iframe width="960" height="150" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/comm_footer"></iframe>');
		$(document).bind('reload', function(){
			document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '奢侈品_交通银行积分乐园')
			if ($.user.is_login() && $(".comm_user").length == 0) $('<div class="comm_user">您好，交通银行信用卡积分乐园用户</div>').insertBefore('.purple_header')
			$('.youKnow, .guarantee, .gene, .share_box, .top_tips, .ctips').hide()
		})
	} else if (document.location.href.match(/qqcb\.weimall\.com/)){
		if ($.cookie('site') == 'qq' || $.cookie('user_id') == null) {
			$('#iframe_header').hide();
			$(document).bind('reload', function(){  $('.umy').text(decodeURIComponent($.cookie('user_name'))) });
		}
		else {
			$('#iframe_header').show();
			$('body').addClass('layout_qqcb');
			if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="960" height="25" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/qqcb_header"></iframe>');
			$(document).bind('reload', function(){ document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '珀丽莱_QQ彩贝'); $('.umy').text(decodeURIComponent($.cookie('user_name'))) })
		}
	}else if (document.location.href.match(/jiayuan\.weimall\.com/)) {
		$('body').addClass('jiayuan layout_jiayuan');
		if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="960" height="93" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/jiayuan_header"></iframe>');
		$(document).bind('reload', function(){ document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '相亲礼物_世纪佳缘交友网') })
	} else if (document.location.search == '?flash') {
		$('body').addClass('layout_flash')
		if ($('#iframe_header').html() == '') $('#iframe_header').css('background-color', '#44122B').height(83).html('<iframe width="100%" height="83" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/flash_header"></iframe>')
	}else if (document.location.href.match(/cmb\.weimall\.com/)) {
		$('body').addClass('layout_cmb');
		if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="960" height="108" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/cmb_header"></iframe>');
		$(document).bind('reload', function(){ document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '珀丽莱奢侈品_招商银行') })

	}else if (document.location.href.match(/icbc\.weimall\.com/)) {
		$('body').addClass('layout_icbc');
		if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="960" height="115" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/icbc_header"></iframe>');
		$(document).bind('reload', function(){ document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '珀丽莱_中国工商银行') })

	}else if (document.location.href.match(/sohu\.weimall\.com/)) {
		$('body').addClass('layout_sohu');
		if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="980" height="116" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/sohu_header"></iframe>');
		$(document).bind('reload', function(){ document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '珀丽莱奢侈品_搜狐') })

	}else if (document.location.href.match(/360\.weimall\.com/)) {
		$('body').addClass('layout_360');
		if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="960" height="130" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/lux360_header"></iframe>');
		$(document).bind('reload', function(){ document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '珀丽莱奢侈品_360') })
	}else if (document.location.href.match(/baidu\.weimall\.com/)) {
		$('body').addClass('layout_baidu');
		if ($('#iframe_header').html() == '') $('#iframe_header').html('<iframe width="960" height="134" scrolling="no" height="0" frameborder="0" marginwidth="0" marginheight="0" src="/core/layouts/baidu_header"></iframe>');
		$(document).bind('reload', function(){ document.title = document.title.replace(/珀丽莱-全球顶级科技公司|珀丽莱$/, '珀丽莱奢侈品_百度购物') })
	} else {
		$('body').addClass('layout_weimall');
	}

	//if ($('#layout_footer').html() == '') {
	//	if (document.location.href.match(/msn\.weimall\.com|cmbc\.weimall\.com|comm\.weimall\.com/)) {
	//	}
	//	else if (document.location.search == '?flash') {
	//	}
	//	else {
	//		var html = '<div class="indeMaster"><div class="copyright"><a target="_blank" rel="nofollow" href="/about">关于珀丽莱</a><a target="_blank" rel="nofollow" href="/experience.html" class="u">体验之旅</a><a target="_blank" rel="nofollow" href="/about/report" class="u">媒体报道</a><a target="_blank" rel="nofollow" href="/about/contact">合作垂询</a><a target="_blank" href="/about/links">友情链接</a><a rel="nofollow" href="/core/reports/new">用户反馈</a></div><a target="_blank" rel="nofollow" href="http://weibo.com/youzhong" class="weibo">微博</a><a target="_blank" rel="nofollow" href="/mobile.html" class="mobile">移动版</a><a target="_blank" rel="nofollow" href="/auction/pages/weipai?flash" class="weixin">微信</a><a target="_blank" rel="nofollow" href="https://online.unionpay.com/" class="team01">银联特约商户</a><a target="_blank" rel="nofollow" href="http://www.ectrustprc.org.cn/certificate.id/certificater.php?id=10095214" class="team02">中国电子商务诚信单位</a><a target="_blank" rel="nofollow" href="http://www.315online.com.cn/member/315110033.html" class="team03">网上交易保障中心</a><a target="_blank" rel="nofollow" href="https://www.itrust.org.cn/yz/pjwx.asp?wm=1783308270" class="team04">网站信用良好</a><a target="_blank" rel="nofollow" href="https://search.szfw.org/cert/l/CX20121222002107002162" class="team05">诚信网站</a></div>'
	//	}
	//	if (typeof(html) != 'undefined' && html != '') $('#layout_footer').html(html)
	//}

});

