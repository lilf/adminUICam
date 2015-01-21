module.exports = (name, grouped) ->
  category = _.keys grouped
  data = _.chain grouped
    .values()
    .map (group) -> group.length
    .value()

  legend:
    data: [name]
  xAxis: [
    type: 'category'
    data: category
  ]
  yAxis: [
    type: 'value'
    splitArea: {show: true}
  ]
  series: [
    name: name
    type: 'bar'
    data: data
  ]
