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

  dashboard_summary_bar_chart = $('#dashboardsummaryreport').highcharts
    chart:
      renderTo: 'dashboardsummaryreport'
      height: '400'
      backgroundColor: null
    title:
      text: 'Annual Summary'
      style: {
        "color": "#94ABBA"
      }
    xAxis:
      categories: $('#dashboardsummaryreport').data('overallsummarymonths')
      crosshair: true
      labels:
        style: {
          "color": "#ddd"
        }
    yAxis:
      title:
        text: 'Amount ($)'
        style: {
          "color": "#ddd"
        }
      gridLineColor: "#445664"
      labels:
        style: {
          "color": "#ddd"
        }
    legend: {
      itemStyle:{
        'color':'#ddd'
      }
    }
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
        data: $('#dashboardsummaryreport').data('overallsummaryincomes')
      }
      {
        type: 'column'
        name: 'Expenses'
        data: $('#dashboardsummaryreport').data('overallsummaryexpenses')
      }
      {
        type: 'column'
        name: 'Savings'
        data: $('#dashboardsummaryreport').data('overallsummarysavings')
      }
      {
        type: 'spline',
        name: 'Savings Potential',
        data: $('#dashboardsummaryreport').data('incomeexpensedifference'),
        marker: {
            lineWidth: 1,
            lineColor: Highcharts.getOptions().colors[3],
            fillColor: 'white'
        }
      }
      {
        type: 'pie',
        name: 'Total consumption',
        data: $('#dashboardsummaryreport').data('overallpiedata'),
        center: [30, 20],
        size: 100,
        showInLegend: false,
        dataLabels: {
            enabled: false
        }
      }
    ]

  summary_bar_chart = $('#summaryreport').highcharts
    chart:
      renderTo: 'summaryreport'
      height: '300'
      backgroundColor: null
    title:
      text: 'Annual Summary'
    xAxis:
      categories: $('#summaryreport').data('overallsummarymonths')
      crosshair: true
    yAxis:
      title:
        text: 'Amount ($)'
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
        name: 'Savings Potential',
        data: $('#summaryreport').data('incomeexpensedifference'),
        marker: {
            lineWidth: 1,
            lineColor: Highcharts.getOptions().colors[3],
            fillColor: 'white'
        }
      }
      {
        type: 'pie',
        name: 'Total consumption',
        data: $('#summaryreport').data('overallpiedata'),
        center: [30, 20],
        size: 100,
        showInLegend: false,
        dataLabels: {
            enabled: false
        }
      }
    ]

  # console.log $('#topcategoriespiechart').data('topcategoriesdata')
  top_categories_pie = $('#topcategoriespiechart').highcharts
    chart:
      renderTo: 'topcategoriespiechart'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
      type: 'pie'
      backgroundColor: 'transparent'
      height: '350'
    title: text: null
    tooltip: pointFormat: '{series.name}: <b>${point.expense:.1f}</b>'
    legend: {
      itemStyle:{
        'color':'#ddd'
      }
    }
    plotOptions: pie:
      borderColor: "#ddd"
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
      data: $('#topcategoriespiechart').data('topcategoriesdata')
    } ]

  # console.log $('#goalspiechartdashboard').data('goalspiechartdatadashboard')
  goals_pie_dashboard = $('#goalspiechartdashboard').highcharts
    chart:
      renderTo: 'goalspiechartdashboard'
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
      data: $('#goalspiechartdashboard').data('goalspiechartdatadashboard')
    } ]

  expenses_vs_budget_bar_chart = $('#monthlybudgetvsexpensesreport').highcharts
    chart:
      renderTo: 'monthlybudgetvsexpensesreport'
      height: '300'
      backgroundColor: null
    title: text: null
    xAxis:
      categories: $('#monthlybudgetvsexpensesreport').data('overallsummarymonths')
      crosshair: true
      labels:
        style: {
          "color": "#ddd"
        }
    yAxis:
      title: text: null
      gridLineColor: "#445664"
      labels:
        style: {
          "color": "#ddd"
        }
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>${point.y:.2f}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
    }
    legend: {
      itemStyle:{
        'color':'#ddd'
      }
    }
    series: [
      {
        type: 'column'
        name: 'Expenses'
        data: $('#monthlybudgetvsexpensesreport').data('monthlyexpenses')
      }
      {
        type: 'spline',
        name: 'Budget',
        data: $('#monthlybudgetvsexpensesreport').data('yearlybudgetedamount'),
        lineWidth: 3,
        lineColor: Highcharts.getOptions().colors[3],
        marker: {
            enabled: false
        }
      }
    ]

  expenses_bar_chart = $('#monthlyexpensesreport').highcharts
    chart:
      renderTo: 'monthlyexpensesreport'
      type: 'column'
      height: '300'
      backgroundColor: null
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
      backgroundColor: null
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

  # Category Reports Page
  console.log $('#categoriesreportpiechart').data('categoriesreportdata')
  top_categories_for_report_pie = $('#categoriesreportpiechart').highcharts
    chart:
      renderTo: 'categoriesreportpiechart'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
      type: 'pie'
      backgroundColor: 'transparent'
      height: '600'
    title: text: null
    tooltip: pointFormat: '{series.name}: <b>${point.expense:.1f}</b>'
    legend: {
      itemStyle:{
        'color':'#ddd'
      }
    }
    plotOptions: pie:
      borderColor: "#ddd"
      allowPointSelect: true
      cursor: 'pointer'
      dataLabels:
        enabled: true
        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
        style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      showInLegend: true
    series: [ {
      name: 'Expense'
      colorByPoint: true
      data: $('#categoriesreportpiechart').data('categoriesreportdata')
    } ]

    # Master Category Reports Page
    console.log $('#mastercategoriesreportpiechart').data('mastercategoriesreportdata')
    top_master_categories_for_report_pie = $('#mastercategoriesreportpiechart').highcharts
      chart:
        renderTo: 'mastercategoriesreportpiechart'
        plotBackgroundColor: null
        plotBorderWidth: null
        plotShadow: false
        type: 'pie'
        backgroundColor: 'transparent'
        height: '600'
      title: text: null
      tooltip: pointFormat: '{series.name}: <b>${point.expense:.1f}</b>'
      legend: {
        itemStyle:{
          'color':'#ddd'
        }
      }
      plotOptions: pie:
        borderColor: "#ddd"
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels:
          enabled: true
          format: '<b>{point.name}</b>: {point.percentage:.1f} %'
          style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
        showInLegend: true
      series: [ {
        name: 'Expense'
        colorByPoint: true
        data: $('#mastercategoriesreportpiechart').data('mastercategoriesreportdata')
      } ]

    # Payee Reports Page
    console.log $('#payeesreportpiechart').data('payeesreportdata')
    top_payee_for_report_pie = $('#payeesreportpiechart').highcharts
      chart:
        renderTo: 'payeesreportpiechart'
        plotBackgroundColor: null
        plotBorderWidth: null
        plotShadow: false
        type: 'pie'
        backgroundColor: 'transparent'
        height: '600'
      title: text: null
      tooltip: pointFormat: '{series.name}: <b>${point.expense:.1f}</b>'
      legend: {
        itemStyle:{
          'color':'#ddd'
        }
      }
      plotOptions: pie:
        borderColor: "#ddd"
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels:
          enabled: true
          format: '<b>{point.name}</b>: {point.percentage:.1f} %'
          style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
        showInLegend: true
      series: [ {
        name: 'Expense'
        colorByPoint: true
        data: $('#payeesreportpiechart').data('payeesreportdata')
      } ]
