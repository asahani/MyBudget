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

  summary_bar_chart = $('#summaryreport').highcharts
    chart:
      renderTo: 'summaryreport'
      type: 'column'
      height: '300'
    title: text: 'Overall Summary'
    xAxis:
      categories: $('#summaryreport').data('overallsummarymonths')
      crosshair: true
    yAxis:
      title: text: 'Amount ($)'
    series: [
      {
        name: 'Incomes'
        data: $('#summaryreport').data('overallsummaryincomes')
      }
      {
        name: 'Expenses'
        data: $('#summaryreport').data('overallsummaryexpenses')
      }
      {
        name: 'Savings'
        data: $('#summaryreport').data('overallsummarysavings')
      }
    ]

  expenses_bar_chart = $('#monthlyexpensesreport').highcharts
    chart:
      renderTo: 'monthlyexpensesreport'
      type: 'column'
      height: '300'
    title: text: 'Monthly Expenses'
    xAxis:
      categories: $('#monthlyexpensesreport').data('overallsummarymonths')
      crosshair: true
    yAxis:
      title: text: 'Amount ($)'
    series: [
      {
        name: 'Expenses'
        data: $('#monthlyexpensesreport').data('monthlyexpenses')
      }
    ]

  overall_expenses_bar_chart = $('#overallexpensesreport').highcharts
    chart:
      renderTo: 'overallexpensesreport'
      type: 'column'
      height: '300'
    title: text: 'Overall Expenses'
    xAxis:
      categories: $('#overallexpensesreport').data('overallsummarymonths')
      crosshair: true
    yAxis:
      title: text: 'Amount ($)'
    series: [
      {
        name: 'Overall Expenses'
        data: $('#overallexpensesreport').data('overallexpenses')
      }
    ]

  savings_bar_chart = $('#monthlysavingsreport').highcharts
    chart:
      renderTo: 'monthlysavingsreport'
      type: 'column'
      height: '300'
    title: text: 'Monthly Savings'
    xAxis:
      categories: $('#monthlysavingsreport').data('overallsummarymonths')
      crosshair: true
    yAxis:
      title: text: 'Amount ($)'
    series: [
      {
        name: 'Savings'
        data: $('#monthlysavingsreport').data('monthlysavings')
      }
    ]

  overall_savings_bar_chart = $('#overallsavingsreport').highcharts
    chart:
      renderTo: 'overallsavingsreport'
      type: 'column'
      height: '300'
    title: text: 'Overall Savings'
    xAxis:
      categories: $('#overallsavingsreport').data('overallsummarymonths')
      crosshair: true
    yAxis:
      title: text: 'Amount ($)'
    series: [
      {
        name: 'Overall Savings'
        data: $('#overallsavingsreport').data('overallsavings')
      }
    ]
