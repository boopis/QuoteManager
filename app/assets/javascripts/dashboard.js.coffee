#= require application
#= require d3
#= require liquidFillGauge

# Current resource usage
storageUsed = $('#storage-used').data 'percent'
formsUsed = $('#forms-used').data 'percent'
requestsUsed = $('#requests-used').data 'percent'

# Storage usage
config1 = liquidFillGaugeDefaultSettings()
config1.circleColor = '#FF7777'
config1.textColor = '#FF4444'
config1.textSize = 0.7
config1.waveTextColor = '#FFAAAA'
config1.waveColor = '#FFDDDD'
config1.circleThickness = 0.2
config1.textVertPosition = 0.5
config1.waveHeight = 0.15
config1.waveOffset = 0.25
config1.waveAnimateTime = 1000
loadLiquidFillGauge 'storage-used', storageUsed, config1

# Forms used
config2 = liquidFillGaugeDefaultSettings()
config2.circleColor = "#808015"
config2.textColor = "#555500"
config2.textSize = 0.7
config2.waveTextColor = "#FFFFAA"
config2.waveColor = "#AAAA39";
config2.circleThickness = 0.2
config2.textVertPosition = 0.5
config2.waveHeight = 0.15
config2.waveOffset = 0.25
config2.waveAnimateTime = 1000
loadLiquidFillGauge 'forms-used', formsUsed, config2

# Requests used
config3 = liquidFillGaugeDefaultSettings()
config3.circleThickness = 0.2
config3.textSize = 0.7
config3.textVertPosition = 0.5
config3.waveHeight = 0.15
config3.waveOffset = 0.25
config3.waveAnimateTime = 1000
loadLiquidFillGauge 'requests-used', requestsUsed, config3

# Render Request & Quote statistic
# no data has been rendered yet
firstLoad = true
# D3 Objects
svg = undefined
gStroke = undefined
gColor = undefined
gTextTitle = undefined
gTextValue = undefined
textValue = undefined
textTitle = undefined
circleStroked = undefined
circleColored = undefined
clip = undefined
# the rendering function, get's called on new data arrival

render = (data) ->
  # data points and sum
  dataPoints = []
  dataCount = 0
  dataSum = 0
  for x of data
    dataSum += data[x]
    dataCount++
  # width and height of the SVG canvas ( parent DIV element )   
  canvasWidth = $('#canvas').width()
  canvasHeight = $('#canvas').height()
  PI = 3.141
  # starting angle for the bowls
  angle = -PI / 2
  # equally space out the bowles
  diffAngle = 2 * PI / dataCount
  # colors in order
  fillColors = [
    'steelblue'
    'orange'
    'purple'
    'darkred'
    'green'
  ]
  strokeColors = [
    'steelblue'
    'darkorange'
    'purple'
    'darkred'
    'darkgreen'
  ]
  # offset for the center of bowles
  offsetX = canvasWidth / 2
  offsetY = canvasHeight / 2
  minDimension = Math.min(canvasWidth, canvasHeight) * 0.80
  # bowl size and distance
  circleRadius = 100
  circleDistance = 200
  # animation duration in ms
  transitionDuration = 500
  i = 0
  # create datapoints
  for field of data
    value = data[field]
    percentage = value / dataSum
    dataPoints.push
      value: value
      percentage: percentage
      x: Math.round(offsetX + Math.cos(angle) * circleDistance)
      y: Math.round(offsetY + Math.sin(angle) * circleDistance)
      index: field
      fillColor: fillColors[i % fillColors.length]
      strokeColor: strokeColors[i % strokeColors.length]
      title: field
      description: value + ' ( ' + Math.round(percentage * 100) + ' % )'
      clipHeightOffset: Math.round((1 - percentage) * circleRadius * 2)
      uniqueid: 'dataseg-' + i
    angle += diffAngle
    i++
  # maybe this is the first data we know of, so setup the D3 objects
  if firstLoad
    #//////////////////////////
    # d3
    svg = d3.select('#svg')
    gStroke = d3.select('#svg').select('#stroke')
    gColor = d3.select('#svg').select('#color')
    gTextTitle = d3.select('#svg').select('#title')
    gTextValue = d3.select('#svg').select('#value')
    #//////////////////////////
    # clipping      
    clip = svg.selectAll('clipPath').data(dataPoints)
    clip.exit().remove()
    clip.enter().append('clipPath').append 'rect'
    #//////////////////////////
    # circle - colored  
    circleColored = gColor.selectAll('circle').data(dataPoints)
    circleColored.exit().remove()
    circleColored.enter().append('circle').attr('r', circleRadius).attr('fill', (d) ->
      d.fillColor
    ).attr('clip-path', (d) ->
      'url(#' + d.uniqueid + ')'
    ).attr 'style', 'stroke:rgb(0,0,0);stroke-width:0;z-index:10000;'
    circleColored.attr('cx', (d) ->
      d.x
    ).attr 'cy', (d) ->
      d.y
    #//////////////////////////     
    # circle stroked
    circleStroked = gStroke.selectAll('circle').data(dataPoints)
    circleStroked.exit().remove()
    circleStroked.enter().append('circle').attr('r', circleRadius).attr('style', (d) ->
      'stroke:' + d.strokeColor + ';stroke-width:2;fill:white;filter:url(#dropshadow)'
    ).attr('cx', (d) ->
      d.x
    ).attr 'cy', (d) ->
      d.y
    #//////////////////////////
    # text title
    textTitle = gTextTitle.selectAll('text').data(dataPoints)
    textTitle.exit().remove()
    textTitle.enter().append 'text'
    #////////////////////////// 
    # text value
    textValue = gTextValue.selectAll('text').data(dataPoints)
    textValue.exit().remove()
    textValue.enter().append 'text'
  # update the D3 objects with new data points and styles
  clip.data(dataPoints).attr('id', (d) ->
    d.uniqueid
  ).select('rect').transition().duration(transitionDuration).attr('x', (d) ->
    d.x - circleRadius
  ).attr('y', (d) ->
    d.y - circleRadius + d.clipHeightOffset
  ).attr('width', circleRadius * 2).attr 'height', circleRadius * 2
  circleColored.data(dataPoints).transition().attr('cx', (d) ->
    d.x
  ).attr 'cy', (d) ->
    d.y
  circleStroked.data(dataPoints).transition().attr('cx', (d) ->
    d.x
  ).attr 'cy', (d) ->
    d.y
  textTitle.data(dataPoints).transition().duration(transitionDuration).attr('style', 'font-weight:bold;text-align:center;').attr('x', (d) ->
    d.x - 20
  ).attr('y', (d) ->
    d.y - 30 - circleRadius + d.clipHeightOffset
  ).text (d) ->
    d.title
  textValue.data(dataPoints).transition().duration(transitionDuration).attr('x', (d) ->
    d.x - 30
  ).attr('y', (d) ->
    d.y - 10 - circleRadius + d.clipHeightOffset
  ).text (d) ->
    d.description
  # not a first load any more
  firstLoad = false
  return
