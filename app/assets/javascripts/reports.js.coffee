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
      height: '300'
    title: text: 'Overall Summary'
    xAxis:
      categories: $('#summaryreport').data('overallsummarymonths')
      crosshair: true
    yAxis:
      title: text: 'Amount ($)'
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>${point.y:.2f}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
    }
    series: [
      {
        type: 'column'
        name: 'Incomes'
        data: $('#summaryreport').data('overallsummaryincomes')
      }
      {
        type: 'column'
        name: 'Expenses'
        data: $('#summaryreport').data('overallsummaryexpenses')
      }
      {
        type: 'column'
        name: 'Savings'
        data: $('#summaryreport').data('overallsummarysavings')
      }
      {
        type: 'spline',
        name: 'Average',
        data: [3000, 2000.67, 3000, 4000.33, 3333.33,3000, 2000.67, 3000, 4000.33, 3333.33,3000, 2000.67],
        marker: {
            lineWidth: 2,
            lineColor: Highcharts.getOptions().colors[3],
            fillColor: 'white'
        }
      }
      {
        type: 'pie',
        name: 'Total consumption',
        data: [{
            name: 'Income',
            y: 19827.00,
            color: Highcharts.getOptions().colors[0]
        }, {
            name: 'Expenses',
            y: 4249.48,
            color: Highcharts.getOptions().colors[1]
        }, {
            name: 'Savings',
            y: 1900,
            color: Highcharts.getOptions().colors[2]
        }],
        center: [100, 80],
        size: 100,
        showInLegend: false,
        dataLabels: {
            enabled: false
        }
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
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>${point.y:.2f}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
    }
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
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>${point.y:.2f}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
    }
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
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>${point.y:.2f}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
    }
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
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>${point.y:.2f}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
    }
    series: [
      {
        name: 'Overall Savings'
        data: $('#overallsavingsreport').data('overallsavings')
      }
    ]
