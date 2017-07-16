# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
//= require simplecalendar

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

# Morris Charts
# ===============
  mb = Morris.Bar
    element: 'annual'
    data: $('#annual').data('budgetitems')
    xkey: 'category'
    ykeys: ['budgeted_amount']
    labels: ['budgeted_amount']
    preUnits: '$'

  # Stats Page: Miscellaneous Master Categrories Chart
  misc_master_expenses_bar = Morris.Bar
    element: 'miscellaneousmasterbarchart'
    data: $('#miscellaneousmasterbarchart').data('misctopexpenses')
    xkey: 'category'
    ykeys: ['spend']
    labels: ['Expense']
    barColors: ["#A45764"]
    preUnits: '$'

  #Stats Page: Miscellaneous Expenses bar graph
  misc_expenses_bar = Morris.Bar
    element: 'miscexpenses'
    data: $('#miscexpenses').data('miscexpenses')
    xkey: 'category'
    ykeys: ['spend']
    labels: ['Expense']
    preUnits: '$'

  #Stats Page: Payee Expenses bar graph
  console.log $('#payeespendbarchart').data('payeespenddata')
  payee_spend_bar = Morris.Bar
    element: 'payeespendbarchart'
    data: $('#payeespendbarchart').data('payeespenddata')
    xkey: 'payee'
    ykeys: ['spend']
    labels: ['Expense']
    barColors: ["#A5C8DA"]
    preUnits: '$'

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

# Highcharts
# ===============
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

  # console.log $('#expensebreakdownchart').data('budgetbreakdowndata')

  # Budget Dashboard: Income vs Expenses Percentage breakdown pie chart
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

  # console.log $('#annual2').data('amount')

  budgeted_percentage_spent_categories = $('#budget_percentage_spent').highcharts
    chart:
      renderTo: 'budget_percentage_spent'
      type: 'bar'
      height: '600'
    title: text: null
    xAxis: categories: $('#budget_percentage_spent').data('budgetcategories')
    yAxis:
      title: text: '% spent of budget'
    legend: reversed: true
    plotOptions: series: stacking: 'percent'
    series: [
      {
      name: 'balance'
      data: $('#budget_percentage_spent').data('balance')
      }
      {
      name: 'expenses'
      color: '#B4757F'
      data: $('#budget_percentage_spent').data('expenses')
      }
    ]

  c2 = $('#annual3').highcharts
    chart:
      renderTo: 'annual3'
      type: 'bar'
      height: '600'
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

  # Stats Page: Income vs Expenses Summary Chart
  stats_summary_bar = $('#summarybarchart').highcharts
    chart:
      renderTo: 'summarybarchart'
      type: 'column'
      height: '300'
    title: text: null
    xAxis:
      categories: [
        $('#summarybarchart').data('budgetmonth')
      ]
      crosshair: true
    yAxis:
      min: 0
      title: text: 'Amount ($)'
    tooltip:
      headerFormat: '<span style="font-size:10px">{point.key}</span><table>'
      pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>${point.y:.1f}</b></td></tr>'
      footerFormat: '</table>'
      shared: true
      useHTML: true
    plotOptions: column:
      pointPadding: 0.2
      borderWidth: 0
    series: [
      {
        name: 'Income'
        data: [
          $('#summarybarchart').data('income')
        ]
      }
      {
        name: 'Expenses'
        data: [
          $('#summarybarchart').data('expenses')
        ]
      }
      {
        name: 'Miscellaneous'
        data: [
          $('#summarybarchart').data('misc')
        ]
      }
      {
        name: 'Savings'
        data: [
          $('#summarybarchart').data('savings')
        ]
      }
    ]
  # Stats Page: Miscellaneous Categories Pie Chart (top 10)
  console.log $('#misccategoriespiechart').data('misccategoriesdata')
  stats_misc_categories_pie = $('#misccategoriespiechart').highcharts
    chart:
      renderTo: 'misccategoriespiechart'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
      type: 'pie'
      backgroundColor: 'transparent'
      height: '300'
    title: text: null
    tooltip: pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    plotOptions: pie:
      allowPointSelect: true
      cursor: 'pointer'
      colors: do ->
        colors = []
        base = '#FFAFAF'
        i = undefined
        i = 0
        while i < 10
          colors.push Highcharts.Color(base).brighten((i - 3) / 7).get()
          i += 1
        colors
      dataLabels:
        enabled: false
        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
        style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      showInLegend: true
    series: [ {
      name: 'Expense'
      colorByPoint: true
      data: $('#misccategoriespiechart').data('misccategoriesdata')
    } ]

  # Stats Page: Miscellaneous Master Categories Pie Chart (top 10)
  # console.log $('#misccategoriespiechart').data('misccategoriesdata')
  stats_misc_master_categories_pie = $('#miscmastercategoriespiechart').highcharts
    chart:
      renderTo: 'miscmastercategoriespiechart'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
      type: 'pie'
      backgroundColor: 'transparent'
      height: '300'
    title: text: null
    tooltip: pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    plotOptions: pie:
      allowPointSelect: true
      cursor: 'pointer'
      colors: do ->
        colors = []
        base = '#FFAFAF'
        i = undefined
        i = 0
        while i < 10
          colors.push Highcharts.Color(base).brighten((i - 3) / 7).get()
          i += 1
        colors
      dataLabels:
        enabled: false
        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
        style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      showInLegend: true
    series: [ {
      name: 'Expense'
      colorByPoint: true
      data: $('#miscmastercategoriespiechart').data('miscmastercategoriesdata')
    } ]

  # Stats Page: Payee spend Pie Chart (top 10)
  # console.log $('#payeepiechart').data('payeepiechartdata')
  payee_spend_pie = $('#payeepiechart').highcharts
    chart:
      renderTo: 'payeepiechart'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
      type: 'pie'
      backgroundColor: 'transparent'
      height: '300'
    title: text: null
    tooltip: pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    plotOptions: pie:
      allowPointSelect: true
      cursor: 'pointer'
      colors: do ->
        colors = []
        base = '#A5C8DA'
        i = undefined
        i = 0
        while i < 10
          colors.push Highcharts.Color(base).brighten((i - 3) / 7).get()
          i += 1
        colors
      dataLabels:
        enabled: false
        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
        style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      showInLegend: true
    series: [ {
      name: 'Expense'
      colorByPoint: true
      data: $('#payeepiechart').data('payeepiechartdata')
    } ]

  calendar.init('ajax')  
