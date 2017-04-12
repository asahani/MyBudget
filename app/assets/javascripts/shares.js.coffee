# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('ul.nav a').on 'shown.bs.tab', (e) ->
    morrisTypes = $(this).attr('data-morris')
    morrisTypesArray = morrisTypes.split(',') || [""]
    $.each morrisTypesArray, (key, value) ->
      if value != "none"
        eval value + '.redraw()'
      return

    highchartTypes = $(this).attr('data-highcharts')
    highchartTypesArray = highchartTypes.split(',')
    $.each highchartTypesArray, (key, value) ->
      if value != "none"
        eval value + '.highcharts().reflow()'
      return
    return

  console.log $('#sharechart').data('sharepricehistory')

  share_area_chart = $('#sharechart').highcharts
    chart:
      renderTo: 'sharechart'
      type: 'area'
      height: '450'
    title: text: null
    xAxis:
      title: text: 'Years'
    yAxis:
      title: text: 'Outstanding Balance'
    legend: reversed: true
    tooltip: pointFormat: '<b>${point.y}</b> balance in year <b>{point.x}</b>'
    plotOptions:
      area:
        pointStart: 0
        marker:
          enabled: true
          symbol: 'circle'
          radius: 3
          states:
            hover:
              enabled: true
    series: [
      {
      name: 'Mortgage Payments'
      data: $('#sharechart').data('sharepricehistory')
      }
    ]
