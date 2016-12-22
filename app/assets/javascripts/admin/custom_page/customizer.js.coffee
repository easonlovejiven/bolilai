$ ->
  $('#search_submit').on 'click', ->
    inputs = $('#search_form :input')
    $('#search_form').find("input[name$='[like]']").each ->
      value = $(this).attr('value').strip()
      $(this).attr('value', '%' + value + '%') if (value != '' && !value.match(/\%/))
    inputs.each -> $(this).attr('disabled', true) if ($(this).attr('value').strip() == '')
    loadPages = (num) ->
      $.ajax
        type: 'get'
        url: '/admin/pages.json'
        data: $('#search_form :input').serialize()+"&page="+num
        context: this,
        success: (data) ->
          html = $.makeArray($(data.pages).map(-> '<a class="page" data-id="' + this.id + '" href="/admin/pages/' + this.id + '/preview" title="' + this.id + ' ' + this.name + '" target="_blank"><img src="' + this.snapshot + '" /><label class="page_label" style="display: none"><input type="checkbox" hidden="hidden" class="page_checkbox" name="page_checkbox_' + this.id + '" checked="checked" />&nbsp;复制</label></a>')).join('')
          $('#old_pages').html(html)
          $("#pagination-here").bootpag({total: data.total_pages, maxVisible: 5})
    loadPages()
    inputs.prop('disabled', false)
    false
  $('#search_submit').click()
  $('#pagination-here').bootpag({total: 1, page: 1, maxVisible: 5, leaps: true}).on "page", (event, num)->
    $('#page').val(num);
    $('#search_submit').click();
  $('#old_pages, #new_pages').sortable
    connectWith: ".pages"
    opacity: 0.5
    revert: 100
    cursor: "move"
    helper: 'clone'
    cancel: '.tablenav, input, label'
    stop: -> $('#new_pages_fields').trigger('update')
  $('#new_pages_fields').on 'update', ->
    html = $.makeArray($('#new_pages .page').map((index) -> '<input type="hidden" name="custom_page_page[pages_pages_attributes][' + index + '][child_id]" value="' + $(this).data('id') + '" />' + (if $(this).find(':checkbox').prop('checked') then '<input type="hidden" name="custom_page_page[pages_pages_attributes][' + index + '][_copy]" value="1" />' else ''))).join('')
    $('#new_pages_fields').html(html)
  $(document).on 'mousedown', '.page_label', -> $(this).find('input').prop('checked',
    !$(this).find('input').prop('checked')); $('#new_pages_fields').trigger('update')
  $(document).on 'click', '.page_label', -> false
  $(document).on 'click', '#old_pages .page', ->
    $('#new_pages').append($(this).clone())
    $('#new_pages_fields').trigger('update')
    $(this).remove()
    false
