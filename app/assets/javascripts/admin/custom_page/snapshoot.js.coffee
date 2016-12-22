page = require('webpage').create()
system = require 'system'

page.injectJs('vendor/assets/javascripts/plugins/base64/base64.js')

content = page.evaluate (s) ->
  Base64.decode(s)
, JSON.parse(system.args[2]).cont

page.content = content

page.viewportSize = page.evaluate ->
  {'width': document.body.scrollWidth, 'height': document.body.scrollHeight}

page.evaluate ->
  document.body.style.backgroundColor = 'white'
  document.body.style.margin = '0px'

page.onLoadFinished = ->
  page.render(system.args[1])
  phantom.exit()
