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

  console.log $('#goalspiechart').data('goalspiechartdata')
  goals_pie = $('#goalspiechart').highcharts
    chart:
      renderTo: 'goalspiechart'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
      type: 'pie'
      backgroundColor: 'transparent'
      height: '350'
    title: text: null
    tooltip: pointFormat: '{series.name}: <b>${point.amount:.1f}</b>'
    legend: {
      itemStyle:{
        'color':'#999'
      }
    }
    plotOptions: pie:
      # borderColor: "#ddd"
      allowPointSelect: true
      cursor: 'pointer'
      dataLabels:
        enabled: false
        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
        style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      showInLegend: true
    series: [ {
      name: 'Amount'
      colorByPoint: true
      data: $('#goalspiechart').data('goalspiechartdata')
    } ]
