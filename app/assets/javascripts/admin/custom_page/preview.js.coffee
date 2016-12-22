#= require plugins/jquery.facebox
#= require shared/html_escape
#= require shared/framekiller
#= require core/underscore-min
#= require plugins/handlebars-v1.3.0

$ ->
  $("input[id^='auction_page_content_']").each (index)->
    $(this).data('content', JSON.parse($(this).val() || '{}'))
  $('#preview_edit').click ->
    $(this).hide()
    $('#preview_submit, #preview_cancel').show()
    false
  $('#preview_cancel').click ->
    $('#preview_submit, #preview_cancel').hide()
    $('#preview_edit').show()
    false
  $('body').on 'click', '.preview_link', (event) ->
    return true unless event.which == 1
    window.open($(this).attr('href'),
      '_blank') if typeof($(this).attr('href')) != 'undefined' && !$('#preview_submit').is(':visible')
    false
  $(".widget").hover ->
    $("#widget_editor").css({
      top: $(this).offset().top - 28,
      left: $(this).offset().left,
      width: $(this).width(),
      height: $(this).height() + 28
    })
    $("#widget_editor").attr("data-widget-target", $(this).attr("data-widget-id"))
  $('body').on 'click', "#widget_editor .edit_btn", (event) ->
    return true unless event.which == 1
    return false unless $('#preview_submit').is(':visible')
    widgetId = $("#widget_editor").attr("data-widget-target");
    pageId = widgetId.match(/_(\d+)$/).pop();
    widget = $('[data-widget-id=' + widgetId + ']');
    html = '<div class="preview_table" data-preview-id=' + widgetId + '><div><a href="#" class="close" onclick="$.facebox.close(); return false;"></a><h2>' + "编辑" + '</h2><table class="form-table"><tbody></tbody></table><div class="submit"><input type="submit" name="" value="确定" id="preview_confirm" /></div></div></div>'
    $.facebox(html)
    configuration = widget.data('configuration')
    $(configuration).each (index)->
      section_data = this
      #      fields_data = eval("$('#auction_page_content').data('content')" + this.source.map((r) -> '["' + r + '"]').join(''))
      fields_data = eval("$('#auction_page_content_" + pageId + "').data('content')" + this.source.map((r) -> '["' + r + '"]').join(''))
      section_name = this.name
      multiable = section_data.multi
      section_html = $('<div class="widget_section"><div class="header"><span>' + h(this.name) + '</span></span></div>')
      section_html.find(".header").append('<a class="new_btn">新增</a>') if multiable
      section_html.data("source", this.source)
      section_html.data("multi", this.multi)
      $('.preview_table tbody').append(section_html)
      $(fields_data).each (index)->
        item_html = $('<div class="section_item"></div>')
        item_html.append('<a class="del_btn">删除<a>') if multiable
        item_html.appendTo(section_html)
        field_data = this;
        $(section_data.fields).each ->
          value = field_data[this.attr]
          value = "" if $.type(value) == "undefined"
          input = (if this.input == 'textarea' then '<textarea></textarea>' else '<input type="text" size="20" value=' + h(value) + '>')
          field_html = $('<span class="field_item"><label>' + h(this.name) + '</label>' + input + '</span>')
          field_html.data('attr', this.attr)
          item_html.prepend(field_html)
        item_html.prepend('<span class="index">' + (index + 1) + '</span>') if multiable
      $(section_html).on "click", ".new_btn", ->
        items = section_html.find(".section_item")
        new_item = items.first().clone(true)
        new_item.find("input").val("")
        new_item.find(".index").text(items.length + 1)
        section_html.append(new_item)
        return false
      $(section_html).on "click", ".del_btn", ->
        section_item = $(this).parents(".section_item")
        section_item.remove()
        items = section_html.find(".section_item")
        items.each (index)->
          $(this).find(".index").text(index + 1)
        return false
      $(document).on "click", ".item .del_btn", ->
        $(this).parents(".item").remove();
        return false
    $('#facebox').css
      left: $(window).width() / 2 - ($('#facebox .popup').width() / 2)
      top: getPageScroll()[1] + getPageHeight() / 2 - ($('#facebox .popup').height() / 2)
    false
  $(document).on 'click', '#preview_confirm', ->
    preview_table = $(this).closest('.preview_table')
    widgetId = preview_table.attr("data-preview-id");
    pageId = widgetId.match(/_(\d+)$/).pop();
    preview_table.find('.widget_section').each ->
      source = $(this).data('source')
      multi = $(this).data('multi')
      attrs = []
      $(this).find(".section_item").each (index)->
        attr = {}
        $(this).find(".field_item").each (index)->
          value = $(this).find("input").val()
          attr[$(this).data("attr")] = value if $.trim(value) != ""
        if multi
          attrs.push(attr)
        else
          attrs = attr
      eval("$('#auction_page_content_" + pageId + "').data('content')" + source.map((r) -> '["' + r + '"]').join('') + ' = ' + JSON.stringify(attrs))
    $('#auction_page_content_' + pageId).val(JSON.stringify($('#auction_page_content' + pageId).data('content'), null,
      '  '))
    $.facebox.close()
    false
  $(document).on "submit", "#preview_form", ->
    data = {}
    $("input[id^='auction_page_content_']").each (index)->
      pageId = $(this).data("page-id")
      data[pageId] = $(this).data("content")
    $("#auction_page_content").val(JSON.stringify(data));
    $(this).get(0).submit();
