# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  Morris.Bar
    element: 'annual'
    data: $('#annual').data('budgetitems')
    xkey: 'category'
    ykeys: ['budgeted_amount']
    labels: ['budgeted_amount']

  console.log $('#annual2').data('amount')
  console.log $('#annual2').data('budgetcategories')
  $('#annual2').highcharts
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

  $('#annual3').highcharts
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

  Morris.Line
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
