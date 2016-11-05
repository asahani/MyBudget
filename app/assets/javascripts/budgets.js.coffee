# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
mb = "new"
ml = "new2"
misc_top_spending = "misc"
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


  mb = Morris.Bar
    element: 'annual'
    data: $('#annual').data('budgetitems')
    xkey: 'category'
    ykeys: ['budgeted_amount']
    labels: ['budgeted_amount']
    preUnits: '$'


  misc_top_spending = Morris.Bar
    element: 'misc'
    data: $('#misc').data('misctopexpenses')
    xkey: 'category'
    ykeys: ['spend']
    labels: ['Expense']
    preUnits: '$'

  misc_pie = $('#miscmasterexpenseschart').highcharts
    chart:
      renderTo: 'miscmasterexpenseschart'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
      type: 'pie'
      backgroundColor: 'transparent'
    title: text: 'Top Miscellaneous Expenses'
    tooltip: pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    plotOptions: pie:
      allowPointSelect: true
      cursor: 'pointer'
      dataLabels:
        enabled: false
        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
        style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      showInLegend: true
    series: [ {
      name: 'Expense'
      colorByPoint: true
      data: $('#miscmasterexpenseschart').data('miscpiedata')
    } ]

  console.log $('#expensebreakdownchart').data('budgetbreakdowndata')
  total_pie = $('#expensebreakdownchart').highcharts
    chart:
      renderTo: 'expensebreakdownchart'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
      type: 'pie'
      backgroundColor: 'transparent'
    title: text: 'Income Distribution'
    tooltip: pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    plotOptions: pie:
      allowPointSelect: true
      cursor: 'pointer'
      dataLabels:
        enabled: false
        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
        style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      showInLegend: true
    series: [ {
      name: 'Expense'
      colorByPoint: true
      data: $('#expensebreakdownchart').data('budgetbreakdowndata')
    } ]

  console.log $('#annual2').data('amount')

  c1 = $('#annual2').highcharts
    chart:
      renderTo: 'annual2'
      type: 'bar'
    title: text: 'Stacked bar chart'
    xAxis: categories: $('#annual2').data('budgetcategories')
    yAxis:
      title: text: 'Percentage spent of budget'
    legend: reversed: true
    plotOptions: series: stacking: 'percent'
    series: [
      {
      name: 'balance'
      data: $('#annual2').data('balance')
      }
      {
      name: 'expenses'
      data: $('#annual2').data('expenses')
      }
    ]

  c2 = $('#annual3').highcharts
    chart:
      renderTo: 'annual3'
      type: 'bar'
    title: text: 'Stacked bar chart'
    xAxis: categories: $('#annual3').data('budgetcategories')
    yAxis:
      title: text: 'Budget vs Expenses'
    legend: reversed: true
    series: [
      {
      name: 'Expenses'
      data: $('#annual3').data('expenses')
      }
      {
      name: 'Budget'
      data: $('#annual3').data('amount')
      }
    ]

  ml = Morris.Line
    element: 'annual4'
    data: [
      {
        y: '2012'
        a: 100
      }
      {
        y: '2011'
        a: 80
      }
      {
        y: '2010'
        a: 75
      }
      {
        y: '2009'
        a: 70
      }
      {
        y: '2008'
        a: 65
      }
      {
        y: '2007'
        a: 60
      }
      {
        y: '2006'
        a: 55
      }
    ]
    xkey: 'y'
    ykeys: [ 'a' ]
    labels: [ 'Series A' ]
