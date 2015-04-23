#= require dragdealer
#= require sankey

#<!--WINDOW RESIZE-->        
sizecorrection = Math.max(0, 220 - parseInt(window.innerWidth * 0.2))

checksize = ->
  if window.innerWidth < 600 or window.innerHeight < 300
    alert 'The recommended minimum resolution is 600 x 300.\n Yours is ' + window.innerWidth + ' x ' + window.innerHeight + '.'
  setTimeout (->
    d3.select('#social').transition().style 'opacity', 1
    return
  ), 3000
  return

draw = (nodes, links) ->
  data =
    'nodes': nodes
    'links': links
  change data
  return

#window.onresize = ->
  #window.location.reload()
  #return

#<!--DATA INIT-->
data = 
  'nodes': []
  'links': []
#<!--SANKEY DIAGRAM-->
padding = 28
paddingmultiplier = 50
lowopacity = 0.3
highopacity = 0.7
format2Number = d3.format(',.2f')
formatNumber = d3.format(',.0f')

format = (a) ->
  formatNumber a

format2 = (a) ->
  format2Number a

color = d3.scale.category20()
d3.select('#chart').style 'width', document.getElementById('chart').offsetWidth - sizecorrection
#d3.select('#titlebar').style 'width', document.getElementById('titlebar').offsetWidth - sizecorrection
margin = 
  top: 70
  right: 10
  bottom: 30
  left: 40
width = document.getElementById('chart').offsetWidth - margin.left - margin.right
height = document.getElementById('chart').offsetHeight - margin.bottom - 90
svg = d3.select('#chart').append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
sankey = d3.sankey().nodeWidth(30).nodePadding(padding).size([
  width
  height
])
path = sankey.reversibleLink()

change = (d) ->

  b = (i) ->
    #dragmove
    d3.select(this).attr 'transform', 'translate(' + (i.x = Math.max(0, Math.min(width - i.dx, d3.event.x))) + ',' + (i.y = Math.max(0, Math.min(height - i.dy, d3.event.y))) + ')'
    sankey.relayout()
    f.attr 'd', path(1)
    h.attr 'd', path(0)
    e.attr 'd', path(2)
    return

  padding = paddingmultiplier * (1 - 0.5) + 3
  svg.selectAll('g').remove()
  sankey = d3.sankey().nodeWidth(30).nodePadding(padding).size([
    width
    height
  ])
  sankey.nodes(d.nodes).links(d.links).layout 500
  g = svg.append('g').selectAll('.link').data(d.links).enter().append('g').attr('class', 'link').sort((j, i) ->
    i.dy - j.dy
  )
  h = g.append('path').attr('d', path(0))
  f = g.append('path').attr('d', path(1))
  e = g.append('path').attr('d', path(2))
  g.attr('fill', (i) ->
    i.source.color = color(i.source.name.replace(RegExp(' .*'), ''))
  ).attr('opacity', lowopacity).on('mouseover', (d) ->
    d3.select(this).style 'opacity', highopacity
    return
  ).on('mouseout', (d) ->
    d3.select(this).style 'opacity', lowopacity
    return
  ).append('title').text (i) ->
    i.source.name + ' → ' + i.target.name + '\n' + format2(i.value)
  c = svg.append('g').selectAll('.node').data(d.nodes).enter().append('g').attr('class', 'node').attr('transform', (i) ->
    'translate(' + i.x + ',' + i.y + ')'
  ).call(d3.behavior.drag().origin((i) ->
    i
  ).on('dragstart', ->
    @parentNode.appendChild this
    return
  ).on('drag', b))
  c.append('rect').attr('height', (i) ->
    i.dy
  ).attr('width', sankey.nodeWidth()).style('fill', (i) ->
    i.color = color(i.name.replace(RegExp(' .*'), ''))
  ).style('stroke', (i) ->
    d3.rgb(i.color).darker 2
  ).on('mouseover', (d) ->
    svg.selectAll('.link').filter((l) ->
      l.source == d or l.target == d
    ).transition().style 'opacity', highopacity
    return
  ).on('mouseout', (d) ->
    svg.selectAll('.link').filter((l) ->
      l.source == d or l.target == d
    ).transition().style 'opacity', lowopacity
    return
  ).on('dblclick', (d) ->
    svg.selectAll('.link').filter((l) ->
      l.target == d
    ).attr 'display', ->
      if d3.select(this).attr('display') == 'none'
        'inline'
      else
        'none'
    return
  ).append('title').text (i) ->
    i.name + '\n' + format2(i.value)
  c.append('text').attr('x', -6).attr('y', (i) ->
    i.dy / 2
  ).attr('dy', '.35em').attr('text-anchor', 'end').attr('transform', null).text((i) ->
    i.name
  ).filter((i) ->
    i.x < width / 2
  ).attr('x', 6 + sankey.nodeWidth()).attr 'text-anchor', 'start'
  c.append('text').attr('x', (i) ->
    -i.dy / 2
  ).attr('y', (i) ->
    i.dx / 2 + 6
  ).attr('transform', 'rotate(270)').attr('text-anchor', 'middle').text((i) ->
    if i.dy > 50
      return format(i.value)
    return
  ).attr('fill', 'white').attr 'stroke', 'black'
  return

chart = $ '#chart'

draft = chart.data 'draft'
sent = chart.data 'sent'
viewed = chart.data 'viewed'
accepted = chart.data 'accepted'
declined = chart.data 'declined'

nodes = [{ name: 'Draft' }, { name: 'Sent' }, { name: 'Accepted' }, { name: 'Declined' }]
links = [
  { source: 0, target: 0, value: draft - sent }, 
  { source: 0, target: 1, value: sent }, 
  { source: 1, target: 2, value: accepted }, 
  { source: 1, target: 3, value: declined }
]

if draft > 0 && sent > 0 && viewed > 0 && accepted > 0 && declined > 0
  draw(nodes, links)
else
  svg.append('text').attr('x', '32%').attr('y', 5).attr('font-size', 16).text("You don't have enough quote data to draw this chart.")

