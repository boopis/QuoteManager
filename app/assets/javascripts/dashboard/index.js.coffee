#= require application
#= require d3
#= require liquidFillGauge
#= require dashboard/req_quote_stat

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
