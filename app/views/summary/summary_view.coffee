ItemView = require './item_view'

module.exports = class SummaryView extends Backbone.View

  template: require './templates/summary'


  initialize: ->
    @listenTo @collection, 'add', @renderItem


  render: ->
    @$el.html @template()
    @$list = @$ 'tbody'

    this

  renderItem: (model)->
    item_view = new ItemView model: model
    @$list.append item_view.render().el


  getTableOption: ->
    $('.uk-table').dataTable {
      dom: 'T<"clear">lfrtip',
      "autoWidth": true,
      paging: false,
      # columnDefs: [
      #   { type: 'chinese-string', targets: 8 }
      # ],
      # "columns": [
      #   { "width": "20%", "targets": 0 }
      # ],
      tableTools: {
        "sSwfPath": "/copy_csv_xls_pdf.swf",
        "aButtons": [
          "copy",
          {
            "sExtends": 'csv',
            "sTitle": "澳門婦女數據資料庫總覽",
            "bBomInc": true
          }
          # {
          #   "sExtends": 'xls',
          #   "sTitle": "澳门妇委会数据资料总览表",
          #   "sFileName": "*.xls",
          #   "bBomInc": true,
          #   "sCharSet": "utf16le"
          # }
          # {
          #   "sExtends": 'pdf',
          #   "sTitle": "澳门妇委会数据资料总览表",
          #   "sPdfSize": "letter",
          #   "bBomInc": true
          # }
          "print"
        ]
      }
    }








