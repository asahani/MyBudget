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
      height: '300'
      backgroundColor: 'transparent'
    title: text: null
    xAxis:
      title: text: 'Last Year'
      gridLineWidth: 1
    yAxis:
      title: text: 'Share Price ($)'
    legend: reversed: true
    tooltip: pointFormat: '<b>${point.y}</b> share price</b>'
    plotOptions:
      area:
        pointStart: 0
        marker:
          enabled: true
          symbol: 'circle'
          radius: 1
          states:
            hover:
              enabled: true
    series: [
      {
      name: 'Share Price'
      color: '#9fcc9f'
      data: $('#sharechart').data('sharepricehistory')
      }
    ]

    shares_area_chart = $('#shareschart').highcharts
      chart:
        renderTo: 'shareschart'
        type: 'area'
        height: '300'
        backgroundColor: 'transparent'
      title: text: null
      xAxis:
        title: text: 'Last Year'
        gridLineWidth: 1
      yAxis:
        title: text: 'Market Value ($)'
      legend: reversed: true
      tooltip: pointFormat: '<b>${point.y}</b> market value</b>'
      plotOptions:
        area:
          pointStart: 0
          marker:
            enabled: true
            symbol: 'circle'
            radius: 1
            states:
              hover:
                enabled: true
      series: [
        {
        name: 'Market Value'
        color: '#9fcc9f'
        data: $('#shareschart').data('sharespricehistory')
        }
      ]
