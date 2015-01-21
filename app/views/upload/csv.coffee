csv = ->

csv.readFile = (file, encoding, callback) ->
  return alert 'file is not a csv.' unless /(csv|excel)/.test file.type
  reader = new FileReader
  reader.onload = -> callback reader.result
  reader.readAsText file, encoding

csv.save2csv = (name, text) ->
    BOM = '\uFEFF'
    csv = if /win/.test navigator.platform.toLowerCase() then BOM + csv else csv
    blob = new Blob [csv], type: 'text/csv;charset=utf-8'
    saveAs blob, 'converted_' + name

csv.parseFile = (file, encoding, callback) ->
  @readFile file, encoding, (text) => callback @parseText text

csv.parseText = (text) ->
  data = $.parse text, header: false

  delimiter: @detectDelimiter text
  position: @detectPosition data.results
  text: text

csv.parse = ->
  $.parse arguments...

csv.detectDelimiter = (text) ->
  return '\t' if /\t/.test text
  return ',' if /,/.test text
  return false

csv.detectPosition = (matrix) ->
    x_array = []
    y = 0

    x_array.push @testEmptyCells(array) for array in matrix

    y = x_array.indexOf 0

    x = x_array[0]

    [x, y]

csv.testEmptyCells = (arr) ->
  emptyLength = 0
  for d in arr
    if d is ''
      emptyLength++
    else
      return emptyLength

  emptyLength

module.exports = csv
