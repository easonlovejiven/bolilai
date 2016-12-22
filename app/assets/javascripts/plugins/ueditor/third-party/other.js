

// plugins/snapscreen.js
/**
 * 截屏插件，为UEditor提供插入支持
 * @file
 * @since 1.4.2
 */
UE.plugin.register('snapscreen', function (){

    var me = this;
    var snapplugin;

    function getLocation(url){
        var search,
            a = document.createElement('a'),
            params = utils.serializeParam(me.queryCommandValue('serverparam')) || '';

        a.href = url;
        if (browser.ie) {
            a.href = a.href;
        }


        search = a.search;
        if (params) {
            search = search ? search + params:'?' + params;
            search = search.replace(/[&]+/ig, '&');
        }
        return {
            'port': a.port,
            'hostname': a.hostname,
            'path': a.pathname + search ||  + a.hash
        }
    }

    return {
        commands:{
            /**
             * 字体背景颜色
             * @command snapscreen
             * @method execCommand
             * @param { String } cmd 命令字符串
             * @example
             * ```javascript
             * editor.execCommand('snapscreen');
             * ```
             */
            'snapscreen':{
                execCommand:function (cmd) {
                    var url, local, res;
                    var lang = me.getLang("snapScreen_plugin");

                    if(!snapplugin){
                        var container = me.container;
                        var doc = me.container.ownerDocument || me.container.document;
                        snapplugin = doc.createElement("object");
                        try{snapplugin.type = "application/x-pluginbaidusnap";}catch(e){
                            return;
                        }
                        snapplugin.style.cssText = "position:absolute;left:-9999px;width:0;height:0;";
                        snapplugin.setAttribute("width","0");
                        snapplugin.setAttribute("height","0");
                        container.appendChild(snapplugin);
                    }

                    function onSuccess(rs){
                        try{
                            rs = eval("("+ rs +")");
                            if(rs.state == 'SUCCESS'){
                                var opt = me.options;
                                me.execCommand('insertimage', {
                                    src: opt.snapscreenUrlPrefix + rs.url,
                                    _src: opt.snapscreenUrlPrefix + rs.url,
                                    alt: rs.title || '',
                                    floatStyle: opt.snapscreenImgAlign
                                });
                            } else {
                                alert(rs.state);
                            }
                        }catch(e){
                            alert(lang.callBackErrorMsg);
                        }
                    }
                    url = me.getActionUrl(me.getOpt('snapscreenActionName'));
                    local = getLocation(url);
                    setTimeout(function () {
                        try{
                            res =snapplugin.saveSnapshot(local.hostname, local.path, local.port);
                        }catch(e){
                            me.ui._dialogs['snapscreenDialog'].open();
                            return;
                        }

                        onSuccess(res);
                    }, 50);
                },
                queryCommandState: function(){
                    return (navigator.userAgent.indexOf("Windows",0) != -1) ? 0:-1;
                }
            }
        }
    }
});


// plugins/insertparagraph.js
/**
 * 插入段落
 * @file
 * @since 1.2.6.1
 */


/**
 * 插入段落
 * @command insertparagraph
 * @method execCommand
 * @param { String } cmd 命令字符串
 * @example
 * ```javascript
 * //editor是编辑器实例
 * editor.execCommand( 'insertparagraph' );
 * ```
 */

UE.commands['insertparagraph'] = {
    execCommand : function( cmdName,front) {
        var me = this,
            range = me.selection.getRange(),
            start = range.startContainer,tmpNode;
        while(start ){
            if(domUtils.isBody(start)){
                break;
            }
            tmpNode = start;
            start = start.parentNode;
        }
        if(tmpNode){
            var p = me.document.createElement('p');
            if(front){
                tmpNode.parentNode.insertBefore(p,tmpNode)
            }else{
                tmpNode.parentNode.insertBefore(p,tmpNode.nextSibling)
            }
            domUtils.fillNode(me.document,p);
            range.setStart(p,0).setCursor(false,true);
        }
    }
};



// plugins/webapp.js
/**
 * 百度应用
 * @file
 * @since 1.2.6.1
 */


/**
 * 插入百度应用
 * @command webapp
 * @method execCommand
 * @remind 需要百度APPKey
 * @remind 百度应用主页： <a href="http://app.baidu.com/" target="_blank">http://app.baidu.com/</a>
 * @param { Object } appOptions 应用所需的参数项， 支持的key有： title=>应用标题， width=>应用容器宽度，
 * height=>应用容器高度，logo=>应用logo，url=>应用地址
 * @example
 * ```javascript
 * //editor是编辑器实例
 * //在编辑器里插入一个“植物大战僵尸”的APP
 * editor.execCommand( 'webapp' , {
 *     title: '植物大战僵尸',
 *     width: 560,
 *     height: 465,
 *     logo: '应用展示的图片',
 *     url: '百度应用的地址'
 * } );
 * ```
 */

//UE.plugins['webapp'] = function () {
//    var me = this;
//    function createInsertStr( obj, toIframe, addParagraph ) {
//        return !toIframe ?
//                (addParagraph ? '<p>' : '') + '<img title="'+obj.title+'" width="' + obj.width + '" height="' + obj.height + '"' +
//                        ' src="' + me.options.UEDITOR_HOME_URL + 'themes/default/images/spacer.gif" style="background:url(' + obj.logo+') no-repeat center center; border:1px solid gray;" class="edui-faked-webapp" _url="' + obj.url + '" />' +
//                        (addParagraph ? '</p>' : '')
//                :
//                '<iframe class="edui-faked-webapp" title="'+obj.title+'" width="' + obj.width + '" height="' + obj.height + '"  scrolling="no" frameborder="0" src="' + obj.url + '" logo_url = '+obj.logo+'></iframe>';
//    }
//
//    function switchImgAndIframe( img2frame ) {
//        var tmpdiv,
//                nodes = domUtils.getElementsByTagName( me.document, !img2frame ? "iframe" : "img" );
//        for ( var i = 0, node; node = nodes[i++]; ) {
//            if ( node.className != "edui-faked-webapp" ){
//                continue;
//            }
//            tmpdiv = me.document.createElement( "div" );
//            tmpdiv.innerHTML = createInsertStr( img2frame ? {url:node.getAttribute( "_url" ), width:node.width, height:node.height,title:node.title,logo:node.style.backgroundImage.replace("url(","").replace(")","")} : {url:node.getAttribute( "src", 2 ),title:node.title, width:node.width, height:node.height,logo:node.getAttribute("logo_url")}, img2frame ? true : false,false );
//            node.parentNode.replaceChild( tmpdiv.firstChild, node );
//        }
//    }
//
//    me.addListener( "beforegetcontent", function () {
//        switchImgAndIframe( true );
//    } );
//    me.addListener( 'aftersetcontent', function () {
//        switchImgAndIframe( false );
//    } );
//    me.addListener( 'aftergetcontent', function ( cmdName ) {
//        if ( cmdName == 'aftergetcontent' && me.queryCommandState( 'source' ) ){
//            return;
//        }
//        switchImgAndIframe( false );
//    } );
//
//    me.commands['webapp'] = {
//        execCommand:function ( cmd, obj ) {
//            me.execCommand( "inserthtml", createInsertStr( obj, false,true ) );
//        }
//    };
//};

UE.plugin.register('webapp', function (){
    var me = this;
    function createInsertStr(obj,toEmbed){
        return  !toEmbed ?
        '<img title="'+obj.title+'" width="' + obj.width + '" height="' + obj.height + '"' +
        ' src="' + me.options.UEDITOR_HOME_URL + 'themes/default/images/spacer.gif" _logo_url="'+obj.logo+'" style="background:url(' + obj.logo
        +') no-repeat center center; border:1px solid gray;" class="edui-faked-webapp" _url="' + obj.url + '" ' +
        (obj.align && !obj.cssfloat? 'align="' + obj.align + '"' : '') +
        (obj.cssfloat ? 'style="float:' + obj.cssfloat + '"' : '') +
        '/>'
            :
        '<iframe class="edui-faked-webapp" title="'+obj.title+'" ' +
        (obj.align && !obj.cssfloat? 'align="' + obj.align + '"' : '') +
        (obj.cssfloat ? 'style="float:' + obj.cssfloat + '"' : '') +
        'width="' + obj.width + '" height="' + obj.height + '"  scrolling="no" frameborder="0" src="' + obj.url + '" logo_url = "'+obj.logo+'"></iframe>'

    }
    return {
        outputRule: function(root){
            utils.each(root.getNodesByTagName('img'),function(node){
                var html;
                if(node.getAttr('class') == 'edui-faked-webapp'){
                    html =  createInsertStr({
                        title:node.getAttr('title'),
                        'width':node.getAttr('width'),
                        'height':node.getAttr('height'),
                        'align':node.getAttr('align'),
                        'cssfloat':node.getStyle('float'),
                        'url':node.getAttr("_url"),
                        'logo':node.getAttr('_logo_url')
                    },true);
                    var embed = UE.uNode.createElement(html);
                    node.parentNode.replaceChild(embed,node);
                }
            })
        },
        inputRule:function(root){
            utils.each(root.getNodesByTagName('iframe'),function(node){
                if(node.getAttr('class') == 'edui-faked-webapp'){
                    var img = UE.uNode.createElement(createInsertStr({
                        title:node.getAttr('title'),
                        'width':node.getAttr('width'),
                        'height':node.getAttr('height'),
                        'align':node.getAttr('align'),
                        'cssfloat':node.getStyle('float'),
                        'url':node.getAttr("src"),
                        'logo':node.getAttr('logo_url')
                    }));
                    node.parentNode.replaceChild(img,node);
                }
            })

        },
        commands:{
            /**
             * 插入百度应用
             * @command webapp
             * @method execCommand
             * @remind 需要百度APPKey
             * @remind 百度应用主页： <a href="http://app.baidu.com/" target="_blank">http://app.baidu.com/</a>
             * @param { Object } appOptions 应用所需的参数项， 支持的key有： title=>应用标题， width=>应用容器宽度，
             * height=>应用容器高度，logo=>应用logo，url=>应用地址
             * @example
             * ```javascript
             * //editor是编辑器实例
             * //在编辑器里插入一个“植物大战僵尸”的APP
             * editor.execCommand( 'webapp' , {
             *     title: '植物大战僵尸',
             *     width: 560,
             *     height: 465,
             *     logo: '应用展示的图片',
             *     url: '百度应用的地址'
             * } );
             * ```
             */
            'webapp':{
                execCommand:function (cmd, obj) {

                    var me = this,
                        str = createInsertStr(utils.extend(obj,{
                            align:'none'
                        }), false);
                    me.execCommand("inserthtml",str);
                },
                queryCommandState:function () {
                    var me = this,
                        img = me.selection.getRange().getClosedNode(),
                        flag = img && (img.className == "edui-faked-webapp");
                    return flag ? 1 : 0;
                }
            }
        }
    }
});

// plugins/template.js
///import core
///import plugins\inserthtml.js
///import plugins\cleardoc.js
///commands 模板
///commandsName  template
///commandsTitle  模板
///commandsDialog  dialogs\template
UE.plugins['template'] = function () {
    UE.commands['template'] = {
        execCommand:function (cmd, obj) {
            obj.html && this.execCommand("inserthtml", obj.html);
        }
    };
    this.addListener("click", function (type, evt) {
        var el = evt.target || evt.srcElement,
            range = this.selection.getRange();
        var tnode = domUtils.findParent(el, function (node) {
            if (node.className && domUtils.hasClass(node, "ue_t")) {
                return node;
            }
        }, true);
        tnode && range.selectNode(tnode).shrinkBoundary().select();
    });
    this.addListener("keydown", function (type, evt) {
        var range = this.selection.getRange();
        if (!range.collapsed) {
            if (!evt.ctrlKey && !evt.metaKey && !evt.shiftKey && !evt.altKey) {
                var tnode = domUtils.findParent(range.startContainer, function (node) {
                    if (node.className && domUtils.hasClass(node, "ue_t")) {
                        return node;
                    }
                }, true);
                if (tnode) {
                    domUtils.removeClasses(tnode, ["ue_t"]);
                }
            }
        }
    });
};

// plugins/autoupload.js
/**
 * @description
 * 1.拖放文件到编辑区域，自动上传并插入到选区
 * 2.插入粘贴板的图片，自动上传并插入到选区
 * @author Jinqn
 * @date 2013-10-14
 */
UE.plugin.register('autoupload', function (){

    function sendAndInsertFile(file, editor) {
        var me  = editor;
        //模拟数据
        var fieldName, urlPrefix, maxSize, allowFiles, actionUrl,
            loadingHtml, errorHandler, successHandler,
            filetype = /image\/\w+/i.test(file.type) ? 'image':'file',
            loadingId = 'loading_' + (+new Date()).toString(36);

        fieldName = me.getOpt(filetype + 'FieldName');
        urlPrefix = me.getOpt(filetype + 'UrlPrefix');
        maxSize = me.getOpt(filetype + 'MaxSize');
        allowFiles = me.getOpt(filetype + 'AllowFiles');
        actionUrl = me.getActionUrl(me.getOpt(filetype + 'ActionName'));
        errorHandler = function(title) {
            var loader = me.document.getElementById(loadingId);
            loader && domUtils.remove(loader);
            me.fireEvent('showmessage', {
                'id': loadingId,
                'content': title,
                'type': 'error',
                'timeout': 4000
            });
        };

        if (filetype == 'image') {
            loadingHtml = '<img class="loadingclass" id="' + loadingId + '" src="' +
            me.options.themePath + me.options.theme +
            '/images/spacer.gif" title="' + (me.getLang('autoupload.loading') || '') + '" >';
            successHandler = function(data) {
                var link = urlPrefix + data.url,
                    loader = me.document.getElementById(loadingId);
                if (loader) {
                    loader.setAttribute('src', link);
                    loader.setAttribute('_src', link);
                    loader.setAttribute('title', data.title || '');
                    loader.setAttribute('alt', data.original || '');
                    loader.removeAttribute('id');
                    domUtils.removeClasses(loader, 'loadingclass');
                }
            };
        } else {
            loadingHtml = '<p>' +
            '<img class="loadingclass" id="' + loadingId + '" src="' +
            me.options.themePath + me.options.theme +
            '/images/spacer.gif" title="' + (me.getLang('autoupload.loading') || '') + '" >' +
            '</p>';
            successHandler = function(data) {
                var link = urlPrefix + data.url,
                    loader = me.document.getElementById(loadingId);

                var rng = me.selection.getRange(),
                    bk = rng.createBookmark();
                rng.selectNode(loader).select();
                me.execCommand('insertfile', {'url': link});
                rng.moveToBookmark(bk).select();
            };
        }

        /* 插入loading的占位符 */
        me.execCommand('inserthtml', loadingHtml);

        /* 判断后端配置是否没有加载成功 */
        if (!me.getOpt(filetype + 'ActionName')) {
            errorHandler(me.getLang('autoupload.errorLoadConfig'));
            return;
        }
        /* 判断文件大小是否超出限制 */
        if(file.size > maxSize) {
            errorHandler(me.getLang('autoupload.exceedSizeError'));
            return;
        }
        /* 判断文件格式是否超出允许 */
        var fileext = file.name ? file.name.substr(file.name.lastIndexOf('.')):'';
        if ((fileext && filetype != 'image') || (allowFiles && (allowFiles.join('') + '.').indexOf(fileext.toLowerCase() + '.') == -1)) {
            errorHandler(me.getLang('autoupload.exceedTypeError'));
            return;
        }

        /* 创建Ajax并提交 */
        var xhr = new XMLHttpRequest(),
            fd = new FormData(),
            params = utils.serializeParam(me.queryCommandValue('serverparam')) || '',
            url = utils.formatUrl(actionUrl + (actionUrl.indexOf('?') == -1 ? '?':'&') + params);

        fd.append(fieldName, file, file.name || ('blob.' + file.type.substr('image/'.length)));
        fd.append('type', 'ajax');
        xhr.open("post", url, true);
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
        xhr.addEventListener('load', function (e) {
            try{
                var json = (new Function("return " + utils.trim(e.target.response)))();
                if (json.state == 'SUCCESS' && json.url) {
                    successHandler(json);
                } else {
                    errorHandler(json.state);
                }
            }catch(er){
                errorHandler(me.getLang('autoupload.loadError'));
            }
        });
        xhr.send(fd);
    }

    function getPasteImage(e){
        return e.clipboardData && e.clipboardData.items && e.clipboardData.items.length == 1 && /^image\//.test(e.clipboardData.items[0].type) ? e.clipboardData.items:null;
    }
    function getDropImage(e){
        return  e.dataTransfer && e.dataTransfer.files ? e.dataTransfer.files:null;
    }

    return {
        outputRule: function(root){
            utils.each(root.getNodesByTagName('img'),function(n){
                if (/\b(loaderrorclass)|(bloaderrorclass)\b/.test(n.getAttr('class'))) {
                    n.parentNode.removeChild(n);
                }
            });
            utils.each(root.getNodesByTagName('p'),function(n){
                if (/\bloadpara\b/.test(n.getAttr('class'))) {
                    n.parentNode.removeChild(n);
                }
            });
        },
        bindEvents:{
            //插入粘贴板的图片，拖放插入图片
            'ready':function(e){
                var me = this;
                if(window.FormData && window.FileReader) {
                    domUtils.on(me.body, 'paste drop', function(e){
                        var hasImg = false,
                            items;
                        //获取粘贴板文件列表或者拖放文件列表
                        items = e.type == 'paste' ? getPasteImage(e):getDropImage(e);
                        if(items){
                            var len = items.length,
                                file;
                            while (len--){
                                file = items[len];
                                if(file.getAsFile) file = file.getAsFile();
                                if(file && file.size > 0) {
                                    sendAndInsertFile(file, me);
                                    hasImg = true;
                                }
                            }
                            hasImg && e.preventDefault();
                        }

                    });
                    //取消拖放图片时出现的文字光标位置提示
                    domUtils.on(me.body, 'dragover', function (e) {
                        if(e.dataTransfer.types[0] == 'Files') {
                            e.preventDefault();
                        }
                    });

                    //设置loading的样式
                    utils.cssRule('loading',
                        '.loadingclass{display:inline-block;cursor:default;background: url(\''
                        + this.options.themePath
                        + this.options.theme +'/images/loading.gif\') no-repeat center center transparent;border:1px solid #cccccc;margin-left:1px;height: 22px;width: 22px;}\n' +
                        '.loaderrorclass{display:inline-block;cursor:default;background: url(\''
                        + this.options.themePath
                        + this.options.theme +'/images/loaderror.png\') no-repeat center center transparent;border:1px solid #cccccc;margin-right:1px;height: 22px;width: 22px;' +
                        '}',
                        this.document);
                }
            }
        }
    }
});

// plugins/autosave.js
UE.plugin.register('autosave', function (){

    var me = this,
    //无限循环保护
        lastSaveTime = new Date(),
    //最小保存间隔时间
        MIN_TIME = 20,
    //auto save key
        saveKey = null;

    function save ( editor ) {

        var saveData;

        if ( new Date() - lastSaveTime < MIN_TIME ) {
            return;
        }

        if ( !editor.hasContents() ) {
            //这里不能调用命令来删除， 会造成事件死循环
            saveKey && me.removePreferences( saveKey );
            return;
        }

        lastSaveTime = new Date();

        editor._saveFlag = null;

        saveData = me.body.innerHTML;

        if ( editor.fireEvent( "beforeautosave", {
                content: saveData
            } ) === false ) {
            return;
        }

        me.setPreferences( saveKey, saveData );

        editor.fireEvent( "afterautosave", {
            content: saveData
        } );

    }

    return {
        defaultOptions: {
            //默认间隔时间
            saveInterval: 500
        },
        bindEvents:{
            'ready':function(){

                var _suffix = "-drafts-data",
                    key = null;

                if ( me.key ) {
                    key = me.key + _suffix;
                } else {
                    key = ( me.container.parentNode.id || 'ue-common' ) + _suffix;
                }

                //页面地址+编辑器ID 保持唯一
                saveKey = ( location.protocol + location.host + location.pathname ).replace( /[.:\/]/g, '_' ) + key;

            },

            'contentchange': function () {

                if ( !saveKey ) {
                    return;
                }

                if ( me._saveFlag ) {
                    window.clearTimeout( me._saveFlag );
                }

                if ( me.options.saveInterval > 0 ) {

                    me._saveFlag = window.setTimeout( function () {

                        save( me );

                    }, me.options.saveInterval );

                } else {

                    save(me);

                }


            }
        },
        commands:{
            'clearlocaldata':{
                execCommand:function (cmd, name) {
                    if ( saveKey && me.getPreferences( saveKey ) ) {
                        me.removePreferences( saveKey )
                    }
                },
                notNeedUndo: true,
                ignoreContentChange:true
            },

            'getlocaldata':{
                execCommand:function (cmd, name) {
                    return saveKey ? me.getPreferences( saveKey ) || '' : '';
                },
                notNeedUndo: true,
                ignoreContentChange:true
            },

            'drafts':{
                execCommand:function (cmd, name) {
                    if ( saveKey ) {
                        me.body.innerHTML = me.getPreferences( saveKey ) || '<p>'+domUtils.fillHtml+'</p>';
                        me.focus(true);
                    }
                },
                queryCommandState: function () {
                    return saveKey ? ( me.getPreferences( saveKey ) === null ? -1 : 0 ) : -1;
                },
                notNeedUndo: true,
                ignoreContentChange:true
            }
        }
    }

});

// plugins/charts.js
UE.plugin.register('charts', function (){

    var me = this;

    return {
        bindEvents: {
            'chartserror': function () {
            }
        },
        commands:{
            'charts': {
                execCommand: function ( cmd, data ) {

                    var tableNode = domUtils.findParentByTagName(this.selection.getRange().startContainer, 'table', true),
                        flagText = [],
                        config = {};

                    if ( !tableNode ) {
                        return false;
                    }

                    if ( !validData( tableNode ) ) {
                        me.fireEvent( "chartserror" );
                        return false;
                    }

                    config.title = data.title || '';
                    config.subTitle = data.subTitle || '';
                    config.xTitle = data.xTitle || '';
                    config.yTitle = data.yTitle || '';
                    config.suffix = data.suffix || '';
                    config.tip = data.tip || '';
                    //数据对齐方式
                    config.dataFormat = data.tableDataFormat || '';
                    //图表类型
                    config.chartType = data.chartType || 0;

                    for ( var key in config ) {

                        if ( !config.hasOwnProperty( key ) ) {
                            continue;
                        }

                        flagText.push( key+":"+config[ key ] );

                    }

                    tableNode.setAttribute( "data-chart", flagText.join( ";" ) );
                    domUtils.addClass( tableNode, "edui-charts-table" );



                },
                queryCommandState: function ( cmd, name ) {

                    var tableNode = domUtils.findParentByTagName(this.selection.getRange().startContainer, 'table', true);
                    return tableNode && validData( tableNode ) ? 0 : -1;

                }
            }
        },
        inputRule:function(root){
            utils.each(root.getNodesByTagName('table'),function( tableNode ){

                if ( tableNode.getAttr("data-chart") !== undefined ) {
                    tableNode.setAttr("style");
                }

            })

        },
        outputRule:function(root){
            utils.each(root.getNodesByTagName('table'),function( tableNode ){

                if ( tableNode.getAttr("data-chart") !== undefined ) {
                    tableNode.setAttr("style", "display: none;");
                }

            })

        }
    }

    function validData ( table ) {

        var firstRows = null,
            cellCount = 0;

        //行数不够
        if ( table.rows.length < 2 ) {
            return false;
        }

        //列数不够
        if ( table.rows[0].cells.length < 2 ) {
            return false;
        }

        //第一行所有cell必须是th
        firstRows = table.rows[ 0 ].cells;
        cellCount = firstRows.length;

        for ( var i = 0, cell; cell = firstRows[ i ]; i++ ) {

            if ( cell.tagName.toLowerCase() !== 'th' ) {
                return false;
            }

        }

        for ( var i = 1, row; row = table.rows[ i ]; i++ ) {

            //每行单元格数不匹配， 返回false
            if ( row.cells.length != cellCount ) {
                return false;
            }

            //第一列不是th也返回false
            if ( row.cells[0].tagName.toLowerCase() !== 'th' ) {
                return false;
            }

            for ( var j = 1, cell; cell = row.cells[ j ]; j++ ) {

                var value = utils.trim( ( cell.innerText || cell.textContent || '' ) );

                value = value.replace( new RegExp( UE.dom.domUtils.fillChar, 'g' ), '' ).replace( /^\s+|\s+$/g, '' );

                //必须是数字
                if ( !/^\d*\.?\d+$/.test( value ) ) {
                    return false;
                }

            }

        }

        return true;

    }

});

// plugins/section.js
/**
 * 目录大纲支持插件
 * @file
 * @since 1.3.0
 */
UE.plugin.register('section', function (){
    /* 目录节点对象 */
    function Section(option){
        this.tag = '';
        this.level = -1,
            this.dom = null;
        this.nextSection = null;
        this.previousSection = null;
        this.parentSection = null;
        this.startAddress = [];
        this.endAddress = [];
        this.children = [];
    }
    function getSection(option) {
        var section = new Section();
        return utils.extend(section, option);
    }
    function getNodeFromAddress(startAddress, root) {
        var current = root;
        for(var i = 0;i < startAddress.length; i++) {
            if(!current.childNodes) return null;
            current = current.childNodes[startAddress[i]];
        }
        return current;
    }

    var me = this;

    return {
        bindMultiEvents:{
            type: 'aftersetcontent afterscencerestore',
            handler: function(){
                me.fireEvent('updateSections');
            }
        },
        bindEvents:{
            /* 初始化、拖拽、粘贴、执行setcontent之后 */
            'ready': function (){
                me.fireEvent('updateSections');
                domUtils.on(me.body, 'drop paste', function(){
                    me.fireEvent('updateSections');
                });
            },
            /* 执行paragraph命令之后 */
            'afterexeccommand': function (type, cmd) {
                if(cmd == 'paragraph') {
                    me.fireEvent('updateSections');
                }
            },
            /* 部分键盘操作，触发updateSections事件 */
            'keyup': function (type, e) {
                var me = this,
                    range = me.selection.getRange();
                if(range.collapsed != true) {
                    me.fireEvent('updateSections');
                } else {
                    var keyCode = e.keyCode || e.which;
                    if(keyCode == 13 || keyCode == 8 || keyCode == 46) {
                        me.fireEvent('updateSections');
                    }
                }
            }
        },
        commands:{
            'getsections': {
                execCommand: function (cmd, levels) {
                    var levelFn = levels || ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'];

                    for (var i = 0; i < levelFn.length; i++) {
                        if (typeof levelFn[i] == 'string') {
                            levelFn[i] = function(fn){
                                return function(node){
                                    return node.tagName == fn.toUpperCase()
                                };
                            }(levelFn[i]);
                        } else if (typeof levelFn[i] != 'function') {
                            levelFn[i] = function (node) {
                                return null;
                            }
                        }
                    }
                    function getSectionLevel(node) {
                        for (var i = 0; i < levelFn.length; i++) {
                            if (levelFn[i](node)) return i;
                        }
                        return -1;
                    }

                    var me = this,
                        Directory = getSection({'level':-1, 'title':'root'}),
                        previous = Directory;

                    function traversal(node, Directory) {
                        var level,
                            tmpSection = null,
                            parent,
                            child,
                            children = node.childNodes;
                        for (var i = 0, len = children.length; i < len; i++) {
                            child = children[i];
                            level = getSectionLevel(child);
                            if (level >= 0) {
                                var address = me.selection.getRange().selectNode(child).createAddress(true).startAddress,
                                    current = getSection({
                                        'tag': child.tagName,
                                        'title': child.innerText || child.textContent || '',
                                        'level': level,
                                        'dom': child,
                                        'startAddress': utils.clone(address, []),
                                        'endAddress': utils.clone(address, []),
                                        'children': []
                                    });
                                previous.nextSection = current;
                                current.previousSection = previous;
                                parent = previous;
                                while(level <= parent.level){
                                    parent = parent.parentSection;
                                }
                                current.parentSection = parent;
                                parent.children.push(current);
                                tmpSection = previous = current;
                            } else {
                                child.nodeType === 1 && traversal(child, Directory);
                                tmpSection && tmpSection.endAddress[tmpSection.endAddress.length - 1] ++;
                            }
                        }
                    }
                    traversal(me.body, Directory);
                    return Directory;
                },
                notNeedUndo: true
            },
            'movesection': {
                execCommand: function (cmd, sourceSection, targetSection, isAfter) {

                    var me = this,
                        targetAddress,
                        target;

                    if(!sourceSection || !targetSection || targetSection.level == -1) return;

                    targetAddress = isAfter ? targetSection.endAddress:targetSection.startAddress;
                    target = getNodeFromAddress(targetAddress, me.body);

                    /* 判断目标地址是否被源章节包含 */
                    if(!targetAddress || !target || isContainsAddress(sourceSection.startAddress, sourceSection.endAddress, targetAddress)) return;

                    var startNode = getNodeFromAddress(sourceSection.startAddress, me.body),
                        endNode = getNodeFromAddress(sourceSection.endAddress, me.body),
                        current,
                        nextNode;

                    if(isAfter) {
                        current = endNode;
                        while ( current && !(domUtils.getPosition( startNode, current ) & domUtils.POSITION_FOLLOWING) ) {
                            nextNode = current.previousSibling;
                            domUtils.insertAfter(target, current);
                            if(current == startNode) break;
                            current = nextNode;
                        }
                    } else {
                        current = startNode;
                        while ( current && !(domUtils.getPosition( current, endNode ) & domUtils.POSITION_FOLLOWING) ) {
                            nextNode = current.nextSibling;
                            target.parentNode.insertBefore(current, target);
                            if(current == endNode) break;
                            current = nextNode;
                        }
                    }

                    me.fireEvent('updateSections');

                    /* 获取地址的包含关系 */
                    function isContainsAddress(startAddress, endAddress, addressTarget){
                        var isAfterStartAddress = false,
                            isBeforeEndAddress = false;
                        for(var i = 0; i< startAddress.length; i++){
                            if(i >= addressTarget.length) break;
                            if(addressTarget[i] > startAddress[i]) {
                                isAfterStartAddress = true;
                                break;
                            } else if(addressTarget[i] < startAddress[i]) {
                                break;
                            }
                        }
                        for(var i = 0; i< endAddress.length; i++){
                            if(i >= addressTarget.length) break;
                            if(addressTarget[i] < startAddress[i]) {
                                isBeforeEndAddress = true;
                                break;
                            } else if(addressTarget[i] > startAddress[i]) {
                                break;
                            }
                        }
                        return isAfterStartAddress && isBeforeEndAddress;
                    }
                }
            },
            'deletesection': {
                execCommand: function (cmd, section, keepChildren) {
                    var me = this;

                    if(!section) return;

                    function getNodeFromAddress(startAddress) {
                        var current = me.body;
                        for(var i = 0;i < startAddress.length; i++) {
                            if(!current.childNodes) return null;
                            current = current.childNodes[startAddress[i]];
                        }
                        return current;
                    }

                    var startNode = getNodeFromAddress(section.startAddress),
                        endNode = getNodeFromAddress(section.endAddress),
                        current = startNode,
                        nextNode;

                    if(!keepChildren) {
                        while ( current && domUtils.inDoc(endNode, me.document) && !(domUtils.getPosition( current, endNode ) & domUtils.POSITION_FOLLOWING) ) {
                            nextNode = current.nextSibling;
                            domUtils.remove(current);
                            current = nextNode;
                        }
                    } else {
                        domUtils.remove(current);
                    }

                    me.fireEvent('updateSections');
                }
            },
            'selectsection': {
                execCommand: function (cmd, section) {
                    if(!section && !section.dom) return false;
                    var me = this,
                        range = me.selection.getRange(),
                        address = {
                            'startAddress':utils.clone(section.startAddress, []),
                            'endAddress':utils.clone(section.endAddress, [])
                        };
                    address.endAddress[address.endAddress.length - 1]++;
                    range.moveToAddress(address).select().scrollToView();
                    return true;
                },
                notNeedUndo: true
            },
            'scrolltosection': {
                execCommand: function (cmd, section) {
                    if(!section && !section.dom) return false;
                    var me = this,
                        range = me.selection.getRange(),
                        address = {
                            'startAddress':section.startAddress,
                            'endAddress':section.endAddress
                        };
                    address.endAddress[address.endAddress.length - 1]++;
                    range.moveToAddress(address).scrollToView();
                    return true;
                },
                notNeedUndo: true
            }
        }
    }
});



// plugins/simpleupload.js
/**
 * @description
 * 简单上传:点击按钮,直接选择文件上传
 * @author Jinqn
 * @date 2014-03-31
 */
UE.plugin.register('simpleupload', function (){
    var me = this,
        isLoaded = false,
        containerBtn;

    function initUploadBtn(){
        var w = containerBtn.offsetWidth || 20,
            h = containerBtn.offsetHeight || 20,
            btnIframe = document.createElement('iframe'),
            btnStyle = 'display:block;width:' + w + 'px;height:' + h + 'px;overflow:hidden;border:0;margin:0;padding:0;position:absolute;top:0;left:0;filter:alpha(opacity=0);-moz-opacity:0;-khtml-opacity: 0;opacity: 0;cursor:pointer;';

        domUtils.on(btnIframe, 'load', function(){

            var timestrap = (+new Date()).toString(36),
                wrapper,
                btnIframeDoc,
                btnIframeBody;

            btnIframeDoc = (btnIframe.contentDocument || btnIframe.contentWindow.document);
            btnIframeBody = btnIframeDoc.body;
            wrapper = btnIframeDoc.createElement('div');

            wrapper.innerHTML = '<form id="edui_form_' + timestrap + '" target="edui_iframe_' + timestrap + '" method="POST" enctype="multipart/form-data" action="' + me.getOpt('serverUrl') + '" ' +
            'style="' + btnStyle + '">' +
            '<input id="edui_input_' + timestrap + '" type="file" accept="image/*" name="' + me.options.imageFieldName + '" ' +
            'style="' + btnStyle + '">' +
            '</form>' +
            '<iframe id="edui_iframe_' + timestrap + '" name="edui_iframe_' + timestrap + '" style="display:none;width:0;height:0;border:0;margin:0;padding:0;position:absolute;"></iframe>';

            wrapper.className = 'edui-' + me.options.theme;
            wrapper.id = me.ui.id + '_iframeupload';
            btnIframeBody.style.cssText = btnStyle;
            btnIframeBody.style.width = w + 'px';
            btnIframeBody.style.height = h + 'px';
            btnIframeBody.appendChild(wrapper);

            if (btnIframeBody.parentNode) {
                btnIframeBody.parentNode.style.width = w + 'px';
                btnIframeBody.parentNode.style.height = w + 'px';
            }

            var form = btnIframeDoc.getElementById('edui_form_' + timestrap);
            var input = btnIframeDoc.getElementById('edui_input_' + timestrap);
            var iframe = btnIframeDoc.getElementById('edui_iframe_' + timestrap);

            domUtils.on(input, 'change', function(){
                if(!input.value) return;
                var loadingId = 'loading_' + (+new Date()).toString(36);
                var params = utils.serializeParam(me.queryCommandValue('serverparam')) || '';

                var imageActionUrl = me.getActionUrl(me.getOpt('imageActionName'));
                var allowFiles = me.getOpt('imageAllowFiles');

                me.focus();
                me.execCommand('inserthtml', '<img class="loadingclass" id="' + loadingId + '" src="' + me.options.themePath + me.options.theme +'/images/spacer.gif" title="' + (me.getLang('simpleupload.loading') || '') + '" >');

                function callback(){
                    try{
                        var link, json, loader,
                            body = (iframe.contentDocument || iframe.contentWindow.document).body,
                            result = body.innerText || body.textContent || '';
                        json = (new Function("return " + result))();
                        link = me.options.imageUrlPrefix + json.url;
                        if(json.state == 'SUCCESS' && json.url) {
                            loader = me.document.getElementById(loadingId);
                            loader.setAttribute('src', link);
                            loader.setAttribute('_src', link);
                            loader.setAttribute('title', json.title || '');
                            loader.setAttribute('alt', json.original || '');
                            loader.removeAttribute('id');
                            domUtils.removeClasses(loader, 'loadingclass');
                        } else {
                            showErrorLoader && showErrorLoader(json.state);
                        }
                    }catch(er){
                        showErrorLoader && showErrorLoader(me.getLang('simpleupload.loadError'));
                    }
                    form.reset();
                    domUtils.un(iframe, 'load', callback);
                }
                function showErrorLoader(title){
                    if(loadingId) {
                        var loader = me.document.getElementById(loadingId);
                        loader && domUtils.remove(loader);
                        me.fireEvent('showmessage', {
                            'id': loadingId,
                            'content': title,
                            'type': 'error',
                            'timeout': 4000
                        });
                    }
                }

                /* 判断后端配置是否没有加载成功 */
                if (!me.getOpt('imageActionName')) {
                    errorHandler(me.getLang('autoupload.errorLoadConfig'));
                    return;
                }
                // 判断文件格式是否错误
                var filename = input.value,
                    fileext = filename ? filename.substr(filename.lastIndexOf('.')):'';
                if (!fileext || (allowFiles && (allowFiles.join('') + '.').indexOf(fileext.toLowerCase() + '.') == -1)) {
                    showErrorLoader(me.getLang('simpleupload.exceedTypeError'));
                    return;
                }

                domUtils.on(iframe, 'load', callback);
                form.action = utils.formatUrl(imageActionUrl + (imageActionUrl.indexOf('?') == -1 ? '?':'&') + params);
                form.submit();
            });

            var stateTimer;
            me.addListener('selectionchange', function () {
                clearTimeout(stateTimer);
                stateTimer = setTimeout(function() {
                    var state = me.queryCommandState('simpleupload');
                    if (state == -1) {
                        input.disabled = 'disabled';
                    } else {
                        input.disabled = false;
                    }
                }, 400);
            });
            isLoaded = true;
        });

        btnIframe.style.cssText = btnStyle;
        containerBtn.appendChild(btnIframe);
    }

    return {
        bindEvents:{
            'ready': function() {
                //设置loading的样式
                utils.cssRule('loading',
                    '.loadingclass{display:inline-block;cursor:default;background: url(\''
                    + this.options.themePath
                    + this.options.theme +'/images/loading.gif\') no-repeat center center transparent;border:1px solid #cccccc;margin-right:1px;height: 22px;width: 22px;}\n' +
                    '.loaderrorclass{display:inline-block;cursor:default;background: url(\''
                    + this.options.themePath
                    + this.options.theme +'/images/loaderror.png\') no-repeat center center transparent;border:1px solid #cccccc;margin-right:1px;height: 22px;width: 22px;' +
                    '}',
                    this.document);
            },
            /* 初始化简单上传按钮 */
            'simpleuploadbtnready': function(type, container) {
                containerBtn = container;
                me.afterConfigReady(initUploadBtn);
            }
        },
        outputRule: function(root){
            utils.each(root.getNodesByTagName('img'),function(n){
                if (/\b(loaderrorclass)|(bloaderrorclass)\b/.test(n.getAttr('class'))) {
                    n.parentNode.removeChild(n);
                }
            });
        },
        commands: {
            'simpleupload': {
                queryCommandState: function () {
                    return isLoaded ? 0:-1;
                }
            }
        }
    }
});

// plugins/serverparam.js
/**
 * 服务器提交的额外参数列表设置插件
 * @file
 * @since 1.2.6.1
 */
UE.plugin.register('serverparam', function (){

    var me = this,
        serverParam = {};

    return {
        commands:{
            /**
             * 修改服务器提交的额外参数列表,清除所有项
             * @command serverparam
             * @method execCommand
             * @param { String } cmd 命令字符串
             * @example
             * ```javascript
             * editor.execCommand('serverparam');
             * editor.queryCommandValue('serverparam'); //返回空
             * ```
             */
            /**
             * 修改服务器提交的额外参数列表,删除指定项
             * @command serverparam
             * @method execCommand
             * @param { String } cmd 命令字符串
             * @param { String } key 要清除的属性
             * @example
             * ```javascript
             * editor.execCommand('serverparam', 'name'); //删除属性name
             * ```
             */
            /**
             * 修改服务器提交的额外参数列表,使用键值添加项
             * @command serverparam
             * @method execCommand
             * @param { String } cmd 命令字符串
             * @param { String } key 要添加的属性
             * @param { String } value 要添加属性的值
             * @example
             * ```javascript
             * editor.execCommand('serverparam', 'name', 'hello');
             * editor.queryCommandValue('serverparam'); //返回对象 {'name': 'hello'}
             * ```
             */
            /**
             * 修改服务器提交的额外参数列表,传入键值对对象添加多项
             * @command serverparam
             * @method execCommand
             * @param { String } cmd 命令字符串
             * @param { Object } key 传入的键值对对象
             * @example
             * ```javascript
             * editor.execCommand('serverparam', {'name': 'hello'});
             * editor.queryCommandValue('serverparam'); //返回对象 {'name': 'hello'}
             * ```
             */
            /**
             * 修改服务器提交的额外参数列表,使用自定义函数添加多项
             * @command serverparam
             * @method execCommand
             * @param { String } cmd 命令字符串
             * @param { Function } key 自定义获取参数的函数
             * @example
             * ```javascript
             * editor.execCommand('serverparam', function(editor){
             *     return {'key': 'value'};
             * });
             * editor.queryCommandValue('serverparam'); //返回对象 {'key': 'value'}
             * ```
             */

            /**
             * 获取服务器提交的额外参数列表
             * @command serverparam
             * @method queryCommandValue
             * @param { String } cmd 命令字符串
             * @example
             * ```javascript
             * editor.queryCommandValue( 'serverparam' ); //返回对象 {'key': 'value'}
             * ```
             */
            'serverparam':{
                execCommand:function (cmd, key, value) {
                    if (key === undefined || key === null) { //不传参数,清空列表
                        serverParam = {};
                    } else if (utils.isString(key)) { //传入键值
                        if(value === undefined || value === null) {
                            delete serverParam[key];
                        } else {
                            serverParam[key] = value;
                        }
                    } else if (utils.isObject(key)) { //传入对象,覆盖列表项
                        utils.extend(serverParam, key, true);
                    } else if (utils.isFunction(key)){ //传入函数,添加列表项
                        utils.extend(serverParam, key(), true);
                    }
                },
                queryCommandValue: function(){
                    return serverParam || {};
                }
            }
        }
    }
});

// plugins/insertfile.js
/**
 * 插入附件
 */
UE.plugin.register('insertfile', function (){

    var me = this;

    function getFileIcon(url){
        var ext = url.substr(url.lastIndexOf('.') + 1).toLowerCase(),
            maps = {
                "rar":"icon_rar.gif",
                "zip":"icon_rar.gif",
                "tar":"icon_rar.gif",
                "gz":"icon_rar.gif",
                "bz2":"icon_rar.gif",
                "doc":"icon_doc.gif",
                "docx":"icon_doc.gif",
                "pdf":"icon_pdf.gif",
                "mp3":"icon_mp3.gif",
                "xls":"icon_xls.gif",
                "chm":"icon_chm.gif",
                "ppt":"icon_ppt.gif",
                "pptx":"icon_ppt.gif",
                "avi":"icon_mv.gif",
                "rmvb":"icon_mv.gif",
                "wmv":"icon_mv.gif",
                "flv":"icon_mv.gif",
                "swf":"icon_mv.gif",
                "rm":"icon_mv.gif",
                "exe":"icon_exe.gif",
                "psd":"icon_psd.gif",
                "txt":"icon_txt.gif",
                "jpg":"icon_jpg.gif",
                "png":"icon_jpg.gif",
                "jpeg":"icon_jpg.gif",
                "gif":"icon_jpg.gif",
                "ico":"icon_jpg.gif",
                "bmp":"icon_jpg.gif"
            };
        return maps[ext] ? maps[ext]:maps['txt'];
    }

    return {
        commands:{
            'insertfile': {
                execCommand: function (command, filelist){
                    filelist = utils.isArray(filelist) ? filelist : [filelist];

                    var i, item, icon, title,
                        html = '',
                        URL = me.getOpt('UEDITOR_HOME_URL'),
                        iconDir = URL + (URL.substr(URL.length - 1) == '/' ? '':'/') + 'dialogs/attachment/fileTypeImages/';
                    for (i = 0; i < filelist.length; i++) {
                        item = filelist[i];
                        icon = iconDir + getFileIcon(item.url);
                        title = item.title || item.url.substr(item.url.lastIndexOf('/') + 1);
                        html += '<p style="line-height: 16px;">' +
                        '<img style="vertical-align: middle; margin-right: 2px;" src="'+ icon + '" _src="' + icon + '" />' +
                        '<a style="font-size:12px; color:#0066cc;" href="' + item.url +'" title="' + title + '">' + title + '</a>' +
                        '</p>';
                    }
                    me.execCommand('insertHtml', html);
                }
            }
        }
    }
});

// ui/cellalignpicker.js
///import core
///import uicore
(function () {
    var utils = baidu.editor.utils,
        Popup = baidu.editor.ui.Popup,
        Stateful = baidu.editor.ui.Stateful,
        UIBase = baidu.editor.ui.UIBase;

    /**
     * 该参数将新增一个参数： selected， 参数类型为一个Object， 形如{ 'align': 'center', 'valign': 'top' }， 表示单元格的初始
     * 对齐状态为： 竖直居上，水平居中; 其中 align的取值为：'center', 'left', 'right'; valign的取值为: 'top', 'middle', 'bottom'
     * @update 2013/4/2 hancong03@baidu.com
     */
    var CellAlignPicker = baidu.editor.ui.CellAlignPicker = function (options) {
        this.initOptions(options);
        this.initSelected();
        this.initCellAlignPicker();
    };
    CellAlignPicker.prototype = {
        //初始化选中状态， 该方法将根据传递进来的参数获取到应该选中的对齐方式图标的索引
        initSelected: function(){

            var status = {

                    valign: {
                        top: 0,
                        middle: 1,
                        bottom: 2
                    },
                    align: {
                        left: 0,
                        center: 1,
                        right: 2
                    },
                    count: 3

                },
                result = -1;

            if( this.selected ) {
                this.selectedIndex = status.valign[ this.selected.valign ] * status.count + status.align[ this.selected.align ];
            }

        },
        initCellAlignPicker:function () {
            this.initUIBase();
            this.Stateful_init();
        },
        getHtmlTpl:function () {

            var alignType = [ 'left', 'center', 'right' ],
                COUNT = 9,
                tempClassName = null,
                tempIndex = -1,
                tmpl = [];


            for( var i= 0; i<COUNT; i++ ) {

                tempClassName = this.selectedIndex === i ? ' class="edui-cellalign-selected" ' : '';
                tempIndex = i % 3;

                tempIndex === 0 && tmpl.push('<tr>');

                tmpl.push( '<td index="'+ i +'" ' + tempClassName + ' stateful><div class="edui-icon edui-'+ alignType[ tempIndex ] +'"></div></td>' );

                tempIndex === 2 && tmpl.push('</tr>');

            }

            return '<div id="##" class="edui-cellalignpicker %%">' +
                '<div class="edui-cellalignpicker-body">' +
                '<table onclick="$$._onClick(event);">' +
                tmpl.join('') +
                '</table>' +
                '</div>' +
                '</div>';
        },
        getStateDom: function (){
            return this.target;
        },
        _onClick: function (evt){
            var target= evt.target || evt.srcElement;
            if(/icon/.test(target.className)){
                this.items[target.parentNode.getAttribute("index")].onclick();
                Popup.postHide(evt);
            }
        },
        _UIBase_render:UIBase.prototype.render
    };
    utils.inherits(CellAlignPicker, UIBase);
    utils.extend(CellAlignPicker.prototype, Stateful,true);
})();


// plugins/convertcase.js
/**
 * 大小写转换
 * @file
 * @since 1.2.6.1
 */

/**
 * 把选区内文本变大写，与“tolowercase”命令互斥
 * @command touppercase
 * @method execCommand
 * @param { String } cmd 命令字符串
 * @example
 * ```javascript
 * editor.execCommand( 'touppercase' );
 * ```
 */

/**
 * 把选区内文本变小写，与“touppercase”命令互斥
 * @command tolowercase
 * @method execCommand
 * @param { String } cmd 命令字符串
 * @example
 * ```javascript
 * editor.execCommand( 'tolowercase' );
 * ```
 */
UE.commands['touppercase'] =
    UE.commands['tolowercase'] = {
        execCommand:function (cmd) {
            var me = this;
            var rng = me.selection.getRange();
            if(rng.collapsed){
                return rng;
            }
            var bk = rng.createBookmark(),
                bkEnd = bk.end,
                filterFn = function( node ) {
                    return !domUtils.isBr(node) && !domUtils.isWhitespace( node );
                },
                curNode = domUtils.getNextDomNode( bk.start, false, filterFn );
            while ( curNode && (domUtils.getPosition( curNode, bkEnd ) & domUtils.POSITION_PRECEDING) ) {

                if ( curNode.nodeType == 3 ) {
                    curNode.nodeValue = curNode.nodeValue[cmd == 'touppercase' ? 'toUpperCase' : 'toLowerCase']();
                }
                curNode = domUtils.getNextDomNode( curNode, true, filterFn );
                if(curNode === bkEnd){
                    break;
                }

            }
            rng.moveToBookmark(bk).select();
        }
    };



// plugins/indent.js
/**
 * 首行缩进
 * @file
 * @since 1.2.6.1
 */

/**
 * 缩进
 * @command indent
 * @method execCommand
 * @param { String } cmd 命令字符串
 * @example
 * ```javascript
 * editor.execCommand( 'indent' );
 * ```
 */
UE.commands['indent'] = {
    execCommand : function() {
        var me = this,value = me.queryCommandState("indent") ? "0em" : (me.options.indentValue || '2em');
        me.execCommand('Paragraph','p',{style:'text-indent:'+ value});
    },
    queryCommandState : function() {
        var pN = domUtils.filterNodeList(this.selection.getStartElementPath(),'p h1 h2 h3 h4 h5 h6');
        return pN && pN.style.textIndent && parseInt(pN.style.textIndent) ?  1 : 0;
    }

};


// plugins/print.js
/**
 * 打印
 * @file
 * @since 1.2.6.1
 */

/**
 * 打印
 * @command print
 * @method execCommand
 * @param { String } cmd 命令字符串
 * @example
 * ```javascript
 * editor.execCommand( 'print' );
 * ```
 */
UE.commands['print'] = {
    execCommand : function(){
        this.window.print();
    },
    notNeedUndo : 1
};



// plugins/preview.js
/**
 * 预览
 * @file
 * @since 1.2.6.1
 */

/**
 * 预览
 * @command preview
 * @method execCommand
 * @param { String } cmd 命令字符串
 * @example
 * ```javascript
 * editor.execCommand( 'preview' );
 * ```
 */
UE.commands['preview'] = {
    execCommand : function(){
        var w = window.open('', '_blank', ''),
            d = w.document;
        d.open();
        d.write('<!DOCTYPE html><html><head><meta charset="utf-8"/><script src="'+this.options.UEDITOR_HOME_URL+'ueditor.parse.js"></script><script>' +
        "setTimeout(function(){uParse('div',{rootPath: '"+ this.options.UEDITOR_HOME_URL +"'})},300)" +
        '</script></head><body><div>'+this.getContent(null,null,true)+'</div></body></html>');
        d.close();
    },
    notNeedUndo : 1
};


// plugins/selectall.js
/**
 * 全选
 * @file
 * @since 1.2.6.1
 */

/**
 * 选中所有内容
 * @command selectall
 * @method execCommand
 * @param { String } cmd 命令字符串
 * @example
 * ```javascript
 * editor.execCommand( 'selectall' );
 * ```
 */
UE.plugins['selectall'] = function(){
    var me = this;
    me.commands['selectall'] = {
        execCommand : function(){
            //去掉了原生的selectAll,因为会出现报错和当内容为空时，不能出现闭合状态的光标
            var me = this,body = me.body,
                range = me.selection.getRange();
            range.selectNodeContents(body);
            if(domUtils.isEmptyBlock(body)){
                //opera不能自动合并到元素的里边，要手动处理一下
                if(browser.opera && body.firstChild && body.firstChild.nodeType == 1){
                    range.setStartAtFirst(body.firstChild);
                }
                range.collapse(true);
            }
            range.select(true);
        },
        notNeedUndo : 1
    };


    //快捷键
    me.addshortcutkey({
        "selectAll" : "ctrl+65"
    });
};

// plugins/directionality.js
/**
 * 设置文字输入的方向的插件
 * @file
 * @since 1.2.6.1
 */
(function() {
    var block = domUtils.isBlockElm ,
        getObj = function(editor){
//            var startNode = editor.selection.getStart(),
//                parents;
//            if ( startNode ) {
//                //查找所有的是block的父亲节点
//                parents = domUtils.findParents( startNode, true, block, true );
//                for ( var i = 0,ci; ci = parents[i++]; ) {
//                    if ( ci.getAttribute( 'dir' ) ) {
//                        return ci;
//                    }
//                }
//            }
            return domUtils.filterNodeList(editor.selection.getStartElementPath(),function(n){return n && n.nodeType == 1 && n.getAttribute('dir')});

        },
        doDirectionality = function(range,editor,forward){

            var bookmark,
                filterFn = function( node ) {
                    return   node.nodeType == 1 ? !domUtils.isBookmarkNode(node) : !domUtils.isWhitespace(node);
                },

                obj = getObj( editor );

            if ( obj && range.collapsed ) {
                obj.setAttribute( 'dir', forward );
                return range;
            }
            bookmark = range.createBookmark();
            range.enlarge( true );
            var bookmark2 = range.createBookmark(),
                current = domUtils.getNextDomNode( bookmark2.start, false, filterFn ),
                tmpRange = range.cloneRange(),
                tmpNode;
            while ( current &&  !(domUtils.getPosition( current, bookmark2.end ) & domUtils.POSITION_FOLLOWING) ) {
                if ( current.nodeType == 3 || !block( current ) ) {
                    tmpRange.setStartBefore( current );
                    while ( current && current !== bookmark2.end && !block( current ) ) {
                        tmpNode = current;
                        current = domUtils.getNextDomNode( current, false, null, function( node ) {
                            return !block( node );
                        } );
                    }
                    tmpRange.setEndAfter( tmpNode );
                    var common = tmpRange.getCommonAncestor();
                    if ( !domUtils.isBody( common ) && block( common ) ) {
                        //遍历到了block节点
                        common.setAttribute( 'dir', forward );
                        current = common;
                    } else {
                        //没有遍历到，添加一个block节点
                        var p = range.document.createElement( 'p' );
                        p.setAttribute( 'dir', forward );
                        var frag = tmpRange.extractContents();
                        p.appendChild( frag );
                        tmpRange.insertNode( p );
                        current = p;
                    }

                    current = domUtils.getNextDomNode( current, false, filterFn );
                } else {
                    current = domUtils.getNextDomNode( current, true, filterFn );
                }
            }
            return range.moveToBookmark( bookmark2 ).moveToBookmark( bookmark );
        };

    /**
     * 文字输入方向
     * @command directionality
     * @method execCommand
     * @param { String } cmdName 命令字符串
     * @param { String } forward 传入'ltr'表示从左向右输入，传入'rtl'表示从右向左输入
     * @example
     * ```javascript
     * editor.execCommand( 'directionality', 'ltr');
     * ```
     */

    /**
     * 查询当前选区的文字输入方向
     * @command directionality
     * @method queryCommandValue
     * @param { String } cmdName 命令字符串
     * @return { String } 返回'ltr'表示从左向右输入，返回'rtl'表示从右向左输入
     * @example
     * ```javascript
     * editor.queryCommandValue( 'directionality');
     * ```
     */
    UE.commands['directionality'] = {
        execCommand : function( cmdName,forward ) {
            var range = this.selection.getRange();
            //闭合时单独处理
            if(range.collapsed){
                var txt = this.document.createTextNode('d');
                range.insertNode(txt);
            }
            doDirectionality(range,this,forward);
            if(txt){
                range.setStartBefore(txt).collapse(true);
                domUtils.remove(txt);
            }

            range.select();
            return true;
        },
        queryCommandValue : function() {
            var node = getObj(this);
            return node ? node.getAttribute('dir') : 'ltr';
        }
    };
})();



// plugins/horizontal.js
/**
 * 插入分割线插件
 * @file
 * @since 1.2.6.1
 */

/**
 * 插入分割线
 * @command horizontal
 * @method execCommand
 * @param { String } cmdName 命令字符串
 * @example
 * ```javascript
 * editor.execCommand( 'horizontal' );
 * ```
 */
UE.plugins['horizontal'] = function(){
    var me = this;
    me.commands['horizontal'] = {
        execCommand : function( cmdName ) {
            var me = this;
            if(me.queryCommandState(cmdName)!==-1){
                me.execCommand('insertHtml','<hr>');
                var range = me.selection.getRange(),
                    start = range.startContainer;
                if(start.nodeType == 1 && !start.childNodes[range.startOffset] ){

                    var tmp;
                    if(tmp = start.childNodes[range.startOffset - 1]){
                        if(tmp.nodeType == 1 && tmp.tagName == 'HR'){
                            if(me.options.enterTag == 'p'){
                                tmp = me.document.createElement('p');
                                range.insertNode(tmp);
                                range.setStart(tmp,0).setCursor();

                            }else{
                                tmp = me.document.createElement('br');
                                range.insertNode(tmp);
                                range.setStartBefore(tmp).setCursor();
                            }
                        }
                    }

                }
                return true;
            }

        },
        //边界在table里不能加分隔线
        queryCommandState : function() {
            return domUtils.filterNodeList(this.selection.getStartElementPath(),'table') ? -1 : 0;
        }
    };
//    me.addListener('delkeyup',function(){
//        var rng = this.selection.getRange();
//        if(browser.ie && browser.version > 8){
//            rng.txtToElmBoundary(true);
//            if(domUtils.isStartInblock(rng)){
//                var tmpNode = rng.startContainer;
//                var pre = tmpNode.previousSibling;
//                if(pre && domUtils.isTagNode(pre,'hr')){
//                    domUtils.remove(pre);
//                    rng.select();
//                    return;
//                }
//            }
//        }
//        if(domUtils.isBody(rng.startContainer)){
//            var hr = rng.startContainer.childNodes[rng.startOffset -1];
//            if(hr && hr.nodeName == 'HR'){
//                var next = hr.nextSibling;
//                if(next){
//                    rng.setStart(next,0)
//                }else if(hr.previousSibling){
//                    rng.setStartAtLast(hr.previousSibling)
//                }else{
//                    var p = this.document.createElement('p');
//                    hr.parentNode.insertBefore(p,hr);
//                    domUtils.fillNode(this.document,p);
//                    rng.setStart(p,0);
//                }
//                domUtils.remove(hr);
//                rng.setCursor(false,true);
//            }
//        }
//    })
    me.addListener('delkeydown',function(name,evt){
        var rng = this.selection.getRange();
        rng.txtToElmBoundary(true);
        if(domUtils.isStartInblock(rng)){
            var tmpNode = rng.startContainer;
            var pre = tmpNode.previousSibling;
            if(pre && domUtils.isTagNode(pre,'hr')){
                domUtils.remove(pre);
                rng.select();
                domUtils.preventDefault(evt);
                return true;

            }
        }

    })
};



// plugins/time.js
/**
 * 插入时间和日期
 * @file
 * @since 1.2.6.1
 */

/**
 * 插入时间，默认格式：12:59:59
 * @command time
 * @method execCommand
 * @param { String } cmd 命令字符串
 * @example
 * ```javascript
 * editor.execCommand( 'time');
 * ```
 */

/**
 * 插入日期，默认格式：2013-08-30
 * @command date
 * @method execCommand
 * @param { String } cmd 命令字符串
 * @example
 * ```javascript
 * editor.execCommand( 'date');
 * ```
 */
UE.commands['time'] = UE.commands["date"] = {
    execCommand : function(cmd, format){
        var date = new Date;

        function formatTime(date, format) {
            var hh = ('0' + date.getHours()).slice(-2),
                ii = ('0' + date.getMinutes()).slice(-2),
                ss = ('0' + date.getSeconds()).slice(-2);
            format = format || 'hh:ii:ss';
            return format.replace(/hh/ig, hh).replace(/ii/ig, ii).replace(/ss/ig, ss);
        }
        function formatDate(date, format) {
            var yyyy = ('000' + date.getFullYear()).slice(-4),
                yy = yyyy.slice(-2),
                mm = ('0' + (date.getMonth()+1)).slice(-2),
                dd = ('0' + date.getDate()).slice(-2);
            format = format || 'yyyy-mm-dd';
            return format.replace(/yyyy/ig, yyyy).replace(/yy/ig, yy).replace(/mm/ig, mm).replace(/dd/ig, dd);
        }

        this.execCommand('insertHtml',cmd == "time" ? formatTime(date, format):formatDate(date, format) );
    }
};

// plugins/insertcode.js
/**
 * 插入代码插件
 * @file
 * @since 1.2.6.1
 */

UE.plugins['insertcode'] = function() {
    var me = this;
    me.ready(function(){
        utils.cssRule('pre','pre{margin:.5em 0;padding:.4em .6em;border-radius:8px;background:#f8f8f8;}',
            me.document)
    });
    me.setOpt('insertcode',{
        'as3':'ActionScript3',
        'bash':'Bash/Shell',
        'cpp':'C/C++',
        'css':'Css',
        'cf':'CodeFunction',
        'c#':'C#',
        'delphi':'Delphi',
        'diff':'Diff',
        'erlang':'Erlang',
        'groovy':'Groovy',
        'html':'Html',
        'java':'Java',
        'jfx':'JavaFx',
        'js':'Javascript',
        'pl':'Perl',
        'php':'Php',
        'plain':'Plain Text',
        'ps':'PowerShell',
        'python':'Python',
        'ruby':'Ruby',
        'scala':'Scala',
        'sql':'Sql',
        'vb':'Vb',
        'xml':'Xml'
    });

    /**
     * 插入代码
     * @command insertcode
     * @method execCommand
     * @param { String } cmd 命令字符串
     * @param { String } lang 插入代码的语言
     * @example
     * ```javascript
     * editor.execCommand( 'insertcode', 'javascript' );
     * ```
     */

    /**
     * 如果选区所在位置是插入插入代码区域，返回代码的语言
     * @command insertcode
     * @method queryCommandValue
     * @param { String } cmd 命令字符串
     * @return { String } 返回代码的语言
     * @example
     * ```javascript
     * editor.queryCommandValue( 'insertcode' );
     * ```
     */

    me.commands['insertcode'] = {
        execCommand : function(cmd,lang){
            var me = this,
                rng = me.selection.getRange(),
                pre = domUtils.findParentByTagName(rng.startContainer,'pre',true);
            if(pre){
                pre.className = 'brush:'+lang+';toolbar:false;';
            }else{
                var code = '';
                if(rng.collapsed){
                    code = browser.ie && browser.ie11below ? (browser.version <= 8 ? '&nbsp;':''):'<br/>';
                }else{
                    var frag = rng.extractContents();
                    var div = me.document.createElement('div');
                    div.appendChild(frag);

                    utils.each(UE.filterNode(UE.htmlparser(div.innerHTML.replace(/[\r\t]/g,'')),me.options.filterTxtRules).children,function(node){
                        if(browser.ie && browser.ie11below && browser.version > 8){

                            if(node.type =='element'){
                                if(node.tagName == 'br'){
                                    code += '\n'
                                }else if(!dtd.$empty[node.tagName]){
                                    utils.each(node.children,function(cn){
                                        if(cn.type =='element'){
                                            if(cn.tagName == 'br'){
                                                code += '\n'
                                            }else if(!dtd.$empty[node.tagName]){
                                                code += cn.innerText();
                                            }
                                        }else{
                                            code += cn.data
                                        }
                                    })
                                    if(!/\n$/.test(code)){
                                        code += '\n';
                                    }
                                }
                            }else{
                                code += node.data + '\n'
                            }
                            if(!node.nextSibling() && /\n$/.test(code)){
                                code = code.replace(/\n$/,'');
                            }
                        }else{
                            if(browser.ie && browser.ie11below){

                                if(node.type =='element'){
                                    if(node.tagName == 'br'){
                                        code += '<br>'
                                    }else if(!dtd.$empty[node.tagName]){
                                        utils.each(node.children,function(cn){
                                            if(cn.type =='element'){
                                                if(cn.tagName == 'br'){
                                                    code += '<br>'
                                                }else if(!dtd.$empty[node.tagName]){
                                                    code += cn.innerText();
                                                }
                                            }else{
                                                code += cn.data
                                            }
                                        });
                                        if(!/br>$/.test(code)){
                                            code += '<br>';
                                        }
                                    }
                                }else{
                                    code += node.data + '<br>'
                                }
                                if(!node.nextSibling() && /<br>$/.test(code)){
                                    code = code.replace(/<br>$/,'');
                                }

                            }else{
                                code += (node.type == 'element' ? (dtd.$empty[node.tagName] ?  '' : node.innerText()) : node.data);
                                if(!/br\/?\s*>$/.test(code)){
                                    if(!node.nextSibling())
                                        return;
                                    code += '<br>'
                                }
                            }

                        }

                    });
                }
                me.execCommand('inserthtml','<pre id="coder"class="brush:'+lang+';toolbar:false">'+code+'</pre>',true);

                pre = me.document.getElementById('coder');
                domUtils.removeAttributes(pre,'id');
                var tmpNode = pre.previousSibling;

                if(tmpNode && (tmpNode.nodeType == 3 && tmpNode.nodeValue.length == 1 && browser.ie && browser.version == 6 ||  domUtils.isEmptyBlock(tmpNode))){

                    domUtils.remove(tmpNode)
                }
                var rng = me.selection.getRange();
                if(domUtils.isEmptyBlock(pre)){
                    rng.setStart(pre,0).setCursor(false,true)
                }else{
                    rng.selectNodeContents(pre).select()
                }
            }



        },
        queryCommandValue : function(){
            var path = this.selection.getStartElementPath();
            var lang = '';
            utils.each(path,function(node){
                if(node.nodeName =='PRE'){
                    var match = node.className.match(/brush:([^;]+)/);
                    lang = match && match[1] ? match[1] : '';
                    return false;
                }
            });
            return lang;
        }
    };

    me.addInputRule(function(root){
        utils.each(root.getNodesByTagName('pre'),function(pre){
            var brs = pre.getNodesByTagName('br');
            if(brs.length){
                browser.ie && browser.ie11below && browser.version > 8 && utils.each(brs,function(br){
                    var txt = UE.uNode.createText('\n');
                    br.parentNode.insertBefore(txt,br);
                    br.parentNode.removeChild(br);
                });
                return;
            }
            if(browser.ie && browser.ie11below && browser.version > 8)
                return;
            var code = pre.innerText().split(/\n/);
            pre.innerHTML('');
            utils.each(code,function(c){
                if(c.length){
                    pre.appendChild(UE.uNode.createText(c));
                }
                pre.appendChild(UE.uNode.createElement('br'))
            })
        })
    });
    me.addOutputRule(function(root){
        utils.each(root.getNodesByTagName('pre'),function(pre){
            var code = '';
            utils.each(pre.children,function(n){
                if(n.type == 'text'){
                    //在ie下文本内容有可能末尾带有\n要去掉
                    //trace:3396
                    code += n.data.replace(/[ ]/g,'&nbsp;').replace(/\n$/,'');
                }else{
                    if(n.tagName == 'br'){
                        code  += '\n'
                    }else{
                        code += (!dtd.$empty[n.tagName] ? '' : n.innerText());
                    }

                }

            });

            pre.innerText(code.replace(/(&nbsp;|\n)+$/,''))
        })
    });
    //不需要判断highlight的command列表
    me.notNeedCodeQuery ={
        help:1,
        undo:1,
        redo:1,
        source:1,
        print:1,
        searchreplace:1,
        fullscreen:1,
        preview:1,
        insertparagraph:1,
        elementpath:1,
        insertcode:1,
        inserthtml:1,
        selectall:1
    };
    //将queyCommamndState重置
    var orgQuery = me.queryCommandState;
    me.queryCommandState = function(cmd){
        var me = this;

        if(!me.notNeedCodeQuery[cmd.toLowerCase()] && me.selection && me.queryCommandValue('insertcode')){
            return -1;
        }
        return UE.Editor.prototype.queryCommandState.apply(this,arguments)
    };
    me.addListener('beforeenterkeydown',function(){
        var rng = me.selection.getRange();
        var pre = domUtils.findParentByTagName(rng.startContainer,'pre',true);
        if(pre){
            me.fireEvent('saveScene');
            if(!rng.collapsed){
                rng.deleteContents();
            }
            if(!browser.ie || browser.ie9above){
                var tmpNode = me.document.createElement('br'),pre;
                rng.insertNode(tmpNode).setStartAfter(tmpNode).collapse(true);
                var next = tmpNode.nextSibling;
                if(!next && (!browser.ie || browser.version > 10)){
                    rng.insertNode(tmpNode.cloneNode(false));
                }else{
                    rng.setStartAfter(tmpNode);
                }
                pre = tmpNode.previousSibling;
                var tmp;
                while(pre ){
                    tmp = pre;
                    pre = pre.previousSibling;
                    if(!pre || pre.nodeName == 'BR'){
                        pre = tmp;
                        break;
                    }
                }
                if(pre){
                    var str = '';
                    while(pre && pre.nodeName != 'BR' &&  new RegExp('^[\\s'+domUtils.fillChar+']*$').test(pre.nodeValue)){
                        str += pre.nodeValue;
                        pre = pre.nextSibling;
                    }
                    if(pre.nodeName != 'BR'){
                        var match = pre.nodeValue.match(new RegExp('^([\\s'+domUtils.fillChar+']+)'));
                        if(match && match[1]){
                            str += match[1]
                        }

                    }
                    if(str){
                        str = me.document.createTextNode(str);
                        rng.insertNode(str).setStartAfter(str);
                    }
                }
                rng.collapse(true).select(true);
            }else{
                if(browser.version > 8){

                    var txt = me.document.createTextNode('\n');
                    var start = rng.startContainer;
                    if(rng.startOffset == 0){
                        var preNode = start.previousSibling;
                        if(preNode){
                            rng.insertNode(txt);
                            var fillchar = me.document.createTextNode(' ');
                            rng.setStartAfter(txt).insertNode(fillchar).setStart(fillchar,0).collapse(true).select(true)
                        }
                    }else{
                        rng.insertNode(txt).setStartAfter(txt);
                        var fillchar = me.document.createTextNode(' ');
                        start = rng.startContainer.childNodes[rng.startOffset];
                        if(start && !/^\n/.test(start.nodeValue)){
                            rng.setStartBefore(txt)
                        }
                        rng.insertNode(fillchar).setStart(fillchar,0).collapse(true).select(true)
                    }

                }else{
                    var tmpNode = me.document.createElement('br');
                    rng.insertNode(tmpNode);
                    rng.insertNode(me.document.createTextNode(domUtils.fillChar));
                    rng.setStartAfter(tmpNode);
                    pre = tmpNode.previousSibling;
                    var tmp;
                    while(pre ){
                        tmp = pre;
                        pre = pre.previousSibling;
                        if(!pre || pre.nodeName == 'BR'){
                            pre = tmp;
                            break;
                        }
                    }
                    if(pre){
                        var str = '';
                        while(pre && pre.nodeName != 'BR' &&  new RegExp('^[ '+domUtils.fillChar+']*$').test(pre.nodeValue)){
                            str += pre.nodeValue;
                            pre = pre.nextSibling;
                        }
                        if(pre.nodeName != 'BR'){
                            var match = pre.nodeValue.match(new RegExp('^([ '+domUtils.fillChar+']+)'));
                            if(match && match[1]){
                                str += match[1]
                            }

                        }

                        str = me.document.createTextNode(str);
                        rng.insertNode(str).setStartAfter(str);
                    }
                    rng.collapse(true).select();
                }


            }
            me.fireEvent('saveScene');
            return true;
        }


    });

    me.addListener('tabkeydown',function(cmd,evt){
        var rng = me.selection.getRange();
        var pre = domUtils.findParentByTagName(rng.startContainer,'pre',true);
        if(pre){
            me.fireEvent('saveScene');
            if(evt.shiftKey){

            }else{
                if(!rng.collapsed){
                    var bk = rng.createBookmark();
                    var start = bk.start.previousSibling;

                    while(start){
                        if(pre.firstChild === start && !domUtils.isBr(start)){
                            pre.insertBefore(me.document.createTextNode('    '),start);

                            break;
                        }
                        if(domUtils.isBr(start)){
                            pre.insertBefore(me.document.createTextNode('    '),start.nextSibling);

                            break;
                        }
                        start = start.previousSibling;
                    }
                    var end = bk.end;
                    start = bk.start.nextSibling;
                    if(pre.firstChild === bk.start){
                        pre.insertBefore(me.document.createTextNode('    '),start.nextSibling)

                    }
                    while(start && start !== end){
                        if(domUtils.isBr(start) && start.nextSibling){
                            if(start.nextSibling === end){
                                break;
                            }
                            pre.insertBefore(me.document.createTextNode('    '),start.nextSibling)
                        }

                        start = start.nextSibling;
                    }
                    rng.moveToBookmark(bk).select();
                }else{
                    var tmpNode = me.document.createTextNode('    ');
                    rng.insertNode(tmpNode).setStartAfter(tmpNode).collapse(true).select(true);
                }
            }


            me.fireEvent('saveScene');
            return true;
        }


    });


    me.addListener('beforeinserthtml',function(evtName,html){
        var me = this,
            rng = me.selection.getRange(),
            pre = domUtils.findParentByTagName(rng.startContainer,'pre',true);
        if(pre){
            if(!rng.collapsed){
                rng.deleteContents()
            }
            var htmlstr = '';
            if(browser.ie && browser.version > 8){

                utils.each(UE.filterNode(UE.htmlparser(html),me.options.filterTxtRules).children,function(node){
                    if(node.type =='element'){
                        if(node.tagName == 'br'){
                            htmlstr += '\n'
                        }else if(!dtd.$empty[node.tagName]){
                            utils.each(node.children,function(cn){
                                if(cn.type =='element'){
                                    if(cn.tagName == 'br'){
                                        htmlstr += '\n'
                                    }else if(!dtd.$empty[node.tagName]){
                                        htmlstr += cn.innerText();
                                    }
                                }else{
                                    htmlstr += cn.data
                                }
                            })
                            if(!/\n$/.test(htmlstr)){
                                htmlstr += '\n';
                            }
                        }
                    }else{
                        htmlstr += node.data + '\n'
                    }
                    if(!node.nextSibling() && /\n$/.test(htmlstr)){
                        htmlstr = htmlstr.replace(/\n$/,'');
                    }
                });
                var tmpNode = me.document.createTextNode(utils.html(htmlstr.replace(/&nbsp;/g,' ')));
                rng.insertNode(tmpNode).selectNode(tmpNode).select();
            }else{
                var frag = me.document.createDocumentFragment();

                utils.each(UE.filterNode(UE.htmlparser(html),me.options.filterTxtRules).children,function(node){
                    if(node.type =='element'){
                        if(node.tagName == 'br'){
                            frag.appendChild(me.document.createElement('br'))
                        }else if(!dtd.$empty[node.tagName]){
                            utils.each(node.children,function(cn){
                                if(cn.type =='element'){
                                    if(cn.tagName == 'br'){

                                        frag.appendChild(me.document.createElement('br'))
                                    }else if(!dtd.$empty[node.tagName]){
                                        frag.appendChild(me.document.createTextNode(utils.html(cn.innerText().replace(/&nbsp;/g,' '))));

                                    }
                                }else{
                                    frag.appendChild(me.document.createTextNode(utils.html( cn.data.replace(/&nbsp;/g,' '))));

                                }
                            })
                            if(frag.lastChild.nodeName != 'BR'){
                                frag.appendChild(me.document.createElement('br'))
                            }
                        }
                    }else{
                        frag.appendChild(me.document.createTextNode(utils.html( node.data.replace(/&nbsp;/g,' '))));
                    }
                    if(!node.nextSibling() && frag.lastChild.nodeName == 'BR'){
                        frag.removeChild(frag.lastChild)
                    }


                });
                rng.insertNode(frag).select();

            }

            return true;
        }
    });
    //方向键的处理
    me.addListener('keydown',function(cmd,evt){
        var me = this,keyCode = evt.keyCode || evt.which;
        if(keyCode == 40){
            var rng = me.selection.getRange(),pre,start = rng.startContainer;
            if(rng.collapsed && (pre = domUtils.findParentByTagName(rng.startContainer,'pre',true)) && !pre.nextSibling){
                var last = pre.lastChild
                while(last && last.nodeName == 'BR'){
                    last = last.previousSibling;
                }
                if(last === start || rng.startContainer === pre && rng.startOffset == pre.childNodes.length){
                    me.execCommand('insertparagraph');
                    domUtils.preventDefault(evt)
                }

            }
        }
    });
    //trace:3395
    me.addListener('delkeydown',function(type,evt){
        var rng = this.selection.getRange();
        rng.txtToElmBoundary(true);
        var start = rng.startContainer;
        if(domUtils.isTagNode(start,'pre') && rng.collapsed && domUtils.isStartInblock(rng)){
            var p = me.document.createElement('p');
            domUtils.fillNode(me.document,p);
            start.parentNode.insertBefore(p,start);
            domUtils.remove(start);
            rng.setStart(p,0).setCursor(false,true);
            domUtils.preventDefault(evt);
            return true;
        }
    })
};

// plugins/anchor.js
/**
 * 锚点插件，为UEditor提供插入锚点支持
 * @file
 * @since 1.2.6.1
 */
UE.plugin.register('anchor', function (){

    return {
        bindEvents:{
            'ready':function(){
                utils.cssRule('anchor',
                    '.anchorclass{background: url(\''
                    + this.options.themePath
                    + this.options.theme +'/images/anchor.gif\') no-repeat scroll left center transparent;cursor: auto;display: inline-block;height: 16px;width: 15px;}',
                    this.document);
            }
        },
        outputRule: function(root){
            utils.each(root.getNodesByTagName('img'),function(a){
                var val;
                if(val = a.getAttr('anchorname')){
                    a.tagName = 'a';
                    a.setAttr({
                        anchorname : '',
                        name : val,
                        'class' : ''
                    })
                }
            })
        },
        inputRule:function(root){
            utils.each(root.getNodesByTagName('a'),function(a){
                var val;
                if((val = a.getAttr('name')) && !a.getAttr('href')){
                    a.tagName = 'img';
                    a.setAttr({
                        anchorname :a.getAttr('name'),
                        'class' : 'anchorclass'
                    });
                    a.setAttr('name')

                }
            })

        },
        commands:{
            /**
             * 插入锚点
             * @command anchor
             * @method execCommand
             * @param { String } cmd 命令字符串
             * @param { String } name 锚点名称字符串
             * @example
             * ```javascript
             * //editor 是编辑器实例
             * editor.execCommand('anchor', 'anchor1');
             * ```
             */
            'anchor':{
                execCommand:function (cmd, name) {
                    var range = this.selection.getRange(),img = range.getClosedNode();
                    if (img && img.getAttribute('anchorname')) {
                        if (name) {
                            img.setAttribute('anchorname', name);
                        } else {
                            range.setStartBefore(img).setCursor();
                            domUtils.remove(img);
                        }
                    } else {
                        if (name) {
                            //只在选区的开始插入
                            var anchor = this.document.createElement('img');
                            range.collapse(true);
                            domUtils.setAttributes(anchor,{
                                'anchorname':name,
                                'class':'anchorclass'
                            });
                            range.insertNode(anchor).setStartAfter(anchor).setCursor(false,true);
                        }
                    }
                }
            }
        }
    }
});
// plugins/pagebreak.js
/**
 * 分页功能插件
 * @file
 * @since 1.2.6.1
 */
UE.plugins['pagebreak'] = function () {
    var me = this,
        notBreakTags = ['td'];
    me.setOpt('pageBreakTag','_ueditor_page_break_tag_');

    function fillNode(node){
        if(domUtils.isEmptyBlock(node)){
            var firstChild = node.firstChild,tmpNode;

            while(firstChild && firstChild.nodeType == 1 && domUtils.isEmptyBlock(firstChild)){
                tmpNode = firstChild;
                firstChild = firstChild.firstChild;
            }
            !tmpNode && (tmpNode = node);
            domUtils.fillNode(me.document,tmpNode);
        }
    }
    //分页符样式添加

    me.ready(function(){
        utils.cssRule('pagebreak','.pagebreak{display:block;clear:both !important;cursor:default !important;width: 100% !important;margin:0;}',me.document);
    });
    function isHr(node){
        return node && node.nodeType == 1 && node.tagName == 'HR' && node.className == 'pagebreak';
    }
    me.addInputRule(function(root){
        root.traversal(function(node){
            if(node.type == 'text' && node.data == me.options.pageBreakTag){
                var hr = UE.uNode.createElement('<hr class="pagebreak" noshade="noshade" size="5" style="-webkit-user-select: none;">');
                node.parentNode.insertBefore(hr,node);
                node.parentNode.removeChild(node)
            }
        })
    });
    me.addOutputRule(function(node){
        utils.each(node.getNodesByTagName('hr'),function(n){
            if(n.getAttr('class') == 'pagebreak'){
                var txt = UE.uNode.createText(me.options.pageBreakTag);
                n.parentNode.insertBefore(txt,n);
                n.parentNode.removeChild(n);
            }
        })

    });

    /**
     * 插入分页符
     * @command pagebreak
     * @method execCommand
     * @param { String } cmd 命令字符串
     * @remind 在表格中插入分页符会把表格切分成两部分
     * @remind 获取编辑器内的数据时， 编辑器会把分页符转换成“_ueditor_page_break_tag_”字符串，
     *          以便于提交数据到服务器端后处理分页。
     * @example
     * ```javascript
     * editor.execCommand( 'pagebreak'); //插入一个hr标签，带有样式类名pagebreak
     * ```
     */

    me.commands['pagebreak'] = {
        execCommand:function () {
            var range = me.selection.getRange(),hr = me.document.createElement('hr');
            domUtils.setAttributes(hr,{
                'class' : 'pagebreak',
                noshade:"noshade",
                size:"5"
            });
            domUtils.unSelectable(hr);
            //table单独处理
            var node = domUtils.findParentByTagName(range.startContainer, notBreakTags, true),

                parents = [], pN;
            if (node) {
                switch (node.tagName) {
                    case 'TD':
                        pN = node.parentNode;
                        if (!pN.previousSibling) {
                            var table = domUtils.findParentByTagName(pN, 'table');
//                            var tableWrapDiv = table.parentNode;
//                            if(tableWrapDiv && tableWrapDiv.nodeType == 1
//                                && tableWrapDiv.tagName == 'DIV'
//                                && tableWrapDiv.getAttribute('dropdrag')
//                                ){
//                                domUtils.remove(tableWrapDiv,true);
//                            }
                            table.parentNode.insertBefore(hr, table);
                            parents = domUtils.findParents(hr, true);

                        } else {
                            pN.parentNode.insertBefore(hr, pN);
                            parents = domUtils.findParents(hr);

                        }
                        pN = parents[1];
                        if (hr !== pN) {
                            domUtils.breakParent(hr, pN);

                        }
                        //table要重写绑定一下拖拽
                        me.fireEvent('afteradjusttable',me.document);
                }

            } else {

                if (!range.collapsed) {
                    range.deleteContents();
                    var start = range.startContainer;
                    while ( !domUtils.isBody(start) && domUtils.isBlockElm(start) && domUtils.isEmptyNode(start)) {
                        range.setStartBefore(start).collapse(true);
                        domUtils.remove(start);
                        start = range.startContainer;
                    }

                }
                range.insertNode(hr);

                var pN = hr.parentNode, nextNode;
                while (!domUtils.isBody(pN)) {
                    domUtils.breakParent(hr, pN);
                    nextNode = hr.nextSibling;
                    if (nextNode && domUtils.isEmptyBlock(nextNode)) {
                        domUtils.remove(nextNode);
                    }
                    pN = hr.parentNode;
                }
                nextNode = hr.nextSibling;
                var pre = hr.previousSibling;
                if(isHr(pre)){
                    domUtils.remove(pre);
                }else{
                    pre && fillNode(pre);
                }

                if(!nextNode){
                    var p = me.document.createElement('p');

                    hr.parentNode.appendChild(p);
                    domUtils.fillNode(me.document,p);
                    range.setStart(p,0).collapse(true);
                }else{
                    if(isHr(nextNode)){
                        domUtils.remove(nextNode);
                    }else{
                        fillNode(nextNode);
                    }
                    range.setEndAfter(hr).collapse(false);
                }

                range.select(true);

            }

        }
    };
};

// plugins/wordimage.js
///import core
///commands 本地图片引导上传
///commandsName  WordImage
///commandsTitle  本地图片引导上传
///commandsDialog  dialogs\wordimage

UE.plugin.register('wordimage',function(){
    var me = this,
        images = [];
    return {
        commands : {
            'wordimage':{
                execCommand:function () {
                    var images = domUtils.getElementsByTagName(me.body, "img");
                    var urlList = [];
                    for (var i = 0, ci; ci = images[i++];) {
                        var url = ci.getAttribute("word_img");
                        url && urlList.push(url);
                    }
                    return urlList;
                },
                queryCommandState:function () {
                    images = domUtils.getElementsByTagName(me.body, "img");
                    for (var i = 0, ci; ci = images[i++];) {
                        if (ci.getAttribute("word_img")) {
                            return 1;
                        }
                    }
                    return -1;
                },
                notNeedUndo:true
            }
        },
        inputRule : function (root) {
            utils.each(root.getNodesByTagName('img'), function (img) {
                var attrs = img.attrs,
                    flag = parseInt(attrs.width) < 128 || parseInt(attrs.height) < 43,
                    opt = me.options,
                    src = opt.UEDITOR_HOME_URL + 'themes/default/images/spacer.gif';
                if (attrs['src'] && /^(?:(file:\/+))/.test(attrs['src'])) {
                    img.setAttr({
                        width:attrs.width,
                        height:attrs.height,
                        alt:attrs.alt,
                        word_img: attrs.src,
                        src:src,
                        'style':'background:url(' + ( flag ? opt.themePath + opt.theme + '/images/word.gif' : opt.langPath + opt.lang + '/images/localimage.png') + ') no-repeat center center;border:1px solid #ddd'
                    })
                }
            })
        }
    }
});

// plugins/dragdrop.js
UE.plugins['dragdrop'] = function (){

    var me = this;
    me.ready(function(){
        domUtils.on(this.body,'dragend',function(){
            var rng = me.selection.getRange();
            var node = rng.getClosedNode()||me.selection.getStart();

            if(node && node.tagName == 'IMG'){

                var pre = node.previousSibling,next;
                while(next = node.nextSibling){
                    if(next.nodeType == 1 && next.tagName == 'SPAN' && !next.firstChild){
                        domUtils.remove(next)
                    }else{
                        break;
                    }
                }


                if((pre && pre.nodeType == 1 && !domUtils.isEmptyBlock(pre) || !pre) && (!next || next && !domUtils.isEmptyBlock(next))){
                    if(pre && pre.tagName == 'P' && !domUtils.isEmptyBlock(pre)){
                        pre.appendChild(node);
                        domUtils.moveChild(next,pre);
                        domUtils.remove(next);
                    }else  if(next && next.tagName == 'P' && !domUtils.isEmptyBlock(next)){
                        next.insertBefore(node,next.firstChild);
                    }

                    if(pre && pre.tagName == 'P' && domUtils.isEmptyBlock(pre)){
                        domUtils.remove(pre)
                    }
                    if(next && next.tagName == 'P' && domUtils.isEmptyBlock(next)){
                        domUtils.remove(next)
                    }
                    rng.selectNode(node).select();
                    me.fireEvent('saveScene');

                }

            }

        })
    });
    me.addListener('keyup', function(type, evt) {
        var keyCode = evt.keyCode || evt.which;
        if (keyCode == 13) {
            var rng = me.selection.getRange(),node;
            if(node = domUtils.findParentByTagName(rng.startContainer,'p',true)){
                if(domUtils.getComputedStyle(node,'text-align') == 'center'){
                    domUtils.removeStyle(node,'text-align')
                }
            }
        }
    })
};

