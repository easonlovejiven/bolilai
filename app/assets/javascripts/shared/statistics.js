var ga_account
if (document.location.href.match(/www\.weimall\.com/)) { ga_account = 'UA-22178379-19' }
else if (document.location.href.match(/cms\.weimall\.com/)) { ga_account = false }
else { ga_account = 'UA-22178379-7' }

if (ga_account) {

var _gaq = _gaq || [];
_gaq.push(['_setAccount', ga_account]);
_gaq.push(['_setDomainName', 'none']);
_gaq.push(['_setAllowLinker', true]);
_gaq.push(['_trackPageview']);
(function() {
	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	// ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	ga.src = "http://lst.weimall.com/javascripts/listen.js"
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

}


$(function(){
	var referrer = (document.referrer.match(/:\/\/([^\/]+)\//) || ['', ''])[1].toLowerCase()
	var href = document.location.href
	var p_id = parseInt($.cookie('promotion_id'))
	links = [
		{ match: referrer.match(/google/), link_id: 429263, promotion_id: 188 },
		{ match: referrer.match(/yahoo/), link_id: 429264, promotion_id: 188 },
		{ match: referrer.match(/bing/), link_id: 429265, promotion_id: 188 },
		{ match: referrer.match(/baidu/), link_id: 429266, promotion_id: 188 },
		{ match: referrer.match(/soso/), link_id: 429267, promotion_id: 188 },
		{ match: referrer.match(/sogou/), link_id: 429268, promotion_id: 188 },
		{ match: referrer.match(/\.360\.cn|\.so\.com/), link_id: 429269, promotion_id: 188 },
		{ match: href.match(/msn\.weimall\.com/), link_id: 429772, promotion_id: 20 },
		{ match: href.match(/cmbc\.weimall\.com/), link_id: 429773, promotion_id: 115 },
		{ match: href.match(/jiayuan\.weimall\.com/), link_id: 463830, promotion_id: 234 },
		{ match: href.match(/cmb\.weimall\.com/), link_id: 464358, promotion_id: 244 },
		{ match: href.match(/icbc\.weimall\.com/), link_id: 464357, promotion_id: 243 },
		{ match: href.match(/sohu\.weimall\.com/), link_id: 464356, promotion_id: 242 },
		{ match: href.match(/360\.weimall\.com/), link_id: 464355, promotion_id:  241 }
		,{ match: href.match(/ganzhou\.weimall\.com/), link_id: 495909, promotion_id: 249 }
		,{ match: href.match(/baidu\.weimall\.com/), link_id: 497250, promotion_id: 250 }
	]
	$(links).each(function(){
		if (this.match && !$.cookie('link_id')) {
			(new Image()).src = 'http://api.weimall.com/l/' + this.link_id
			return false
		}
	})
})

function write_statistics_code() {
	var code = ""
	if (document.location.href.match(/msn\.weimall\.com/)) code += " \
		<script type=\"text/javascript\" src=\"  http://stjscn.s-msn.com/portal/hp/2011/udctrack.2011.03.23.js\"></script> \
		<script type=\"text/javascript\"> \
		try { \
		var cURL = \"http://c.msn.com.cn/c.gif?\"; \
		$.track({trackInfoOpts:{sitePage:{lang:'zn-cn',siteDI:'15956',sitePI:'33235',sitePS:'70635', pagename:'mainpage',dept:'',sdept:'',pgGrpId:'',cntType:'',srchQ:''}, \
		userStatic: { signedIn:'false', age:'', gender: ''} \
		},spinTimeout: 150}).register(new $.track.genericTracking({ base: 'http://udc.msn.com/c.gif?',linkTrack:1,samplingRate:99,commonMap:{event: {evt:'type'}, userDynamic:{rid:'requestId',cts:'timeStamp'},client:{clid:'clientId'}}, \
		impr:{param:{evt:'impr'},paramMap:{client:{rf:'referrer',cu:'pageUrl',bh:'height',bw: 'width',sl:'silverlightEnabled',slv:'silverlightVersion',scr:'screenResolution',sd: 'colorDepth'},userDynamic:{hp:'isHomePage'},userStatic:{pp:'signedIn',bd:'age',gnd: 'gender'},sitePage:{mk:'lang',di:'siteDI',pi:'sitePI',ps:'sitePS',pn:'pagename',pid: 'pageId','st.dpt':'dept','st.sdpt':'sdept','dv.pgGrpId':'pgGrpId','dv.contnTp':'cntType', mv:'pgVer', q:'srchQ'}}}, \
		click:{paramMap:{report:{hl:'headline',ce:'contentElement',cm:'contentModule',du: 'destinationUrl'}} },unload: {/**/}}), \
		new $.track.genericTracking({base:cURL,linkTrack:0,impr:{param:{udc:\"true\"},paramMap:{ client:{rf:\"referrer\",tp:'pageUrl'},sitePage:{di:\"siteDI\",pi:\"sitePI\",ps:\"sitePS\"}, userDynamic:{rid:\"requestId\",cts:\"timeStamp\"}}}}));jQuery.track.trackPage(); \
		} catch(e) {} \
		</script><noscript><div><img src=\"http://udc.msn.com/c.gif?js=0&evt=impr&di=15956&pi=33235&ps=70635&mk=zh-cn\" alt=\"image beacon\" /></div></noscript> \
	"
	if (code != "") document.write(code)
}

$(function(){ 
	$(document).on('ready reload', function(){
		if (navigator.userAgent.match(/Android|iPad|iPhone|iPod/i)) $('a[target="_blank"]').attr('target', null)
	});
})

if (document.location.href.match(/www\.weimall\.com/) && (href = document.location.href.replace(/\w+:\/\/[^\/]+/, '')) && href.match(/^\/$|home|core|auction/) && !href.match(/manage/)) {
window.SA||(window.SA={}),SA.redirection_mobile=function(a){var w,x,y,b=function(a){var b=new Date;return b.setTime(b.getTime()+a),b},c=function(a){var b,c,d,e,f,g;if(a)for(b=document.location.search,c=b&&b.substring(1).split("&"),d=0,e=c.length;e>d;d++)if(f=c[d],g=f&&f.substring(0,f.indexOf("=")),g===a)return f.substring(f.indexOf("=")+1,f.length)},d=navigator.userAgent.toLowerCase(),e="false",f="true",g=a||{},h=g.redirection_param||"mobile_redirect",i=g.mobile_prefix||"m",j=g.mobile_url,k=g.mobile_scheme?g.mobile_scheme+":":document.location.protocol,l=document.location.host,m=c(h),n=j||i+"."+(l.match(/^www\./i)?l.substring(4):l),o=g.cookie_hours||1,p=g.keep_path||!1,q=g.keep_query||!1,r=g.append_referrer||!1,s=g.append_referrer_key||"original_referrer",t=g.tablet_host||n,u=!1,v=!1;if((/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(d)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(d.substr(0,4)))&&(u=!0),(document.referrer.indexOf(n)>=0||m===e)&&(window.sessionStorage?window.sessionStorage.setItem(h,e):document.cookie=h+"="+e+";expires="+b(36e5*o).toUTCString()),w=window.sessionStorage?window.sessionStorage.getItem(h)===e:!1,x=document.cookie?document.cookie.indexOf(h)>=0:!1,d.match(/(iPad|SCH-I|xoom|NOOK|silk|kindle|GT-P|touchpad|kindle|sch-t|viewpad|bolt|playbook)/i)&&(v=g.tablet_redirection===f||g.tablet_host?!0:!1,u=!1),(v||u)&&!x&&!w){if(g.beforeredirection_callback&&!g.beforeredirection_callback.call(this))return;y="",p&&(y+=document.location.pathname),q&&(y+=document.location.search),r&&document.referrer&&(y+=-1===y.indexOf("?")?"?":"&",y+=s+"="+encodeURIComponent(document.referrer)),v?document.location.href=k+"//"+t+y:u&&(document.location.href=k+"//"+n+y)}},SA.redirection_mobile({mobile_url:"m.weimall.com/redirect_from_msn.html",tablet_host:"m.weimall.com/redirect_from_msn.html",tablet_redirection:!0});
}
