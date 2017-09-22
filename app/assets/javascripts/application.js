// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap-sprockets
//= require atlant/plugins/bootstrap/bootstrap-colorpicker
//= require atlant/plugins/bootstrap/bootstrap-datepicker
//= require atlant/plugins/bootstrap/bootstrap-file-input
//= require atlant/plugins/bootstrap/bootstrap-select
//= require atlant/plugins/icheck/icheck.min
//= require atlant/plugins/mcustomscrollbar/jquery.mCustomScrollbar.min
//= require atlant/plugins/scrolltotop/scrolltopcontrol
//= require atlant/plugins/morris/raphael-min
//= require atlant/plugins/morris/morris.min
//= require atlant/plugins/rickshaw/d3.v3
//= require atlant/plugins/jvectormap/jquery-jvectormap-1.2.2.min
//= require atlant/plugins/jvectormap/jquery-jvectormap-world-mill-en
//= require atlant/plugins/bootstrap/bootstrap-datepicker
//= require atlant/plugins/bootstrap/bootstrap-tagsinput.min
//= require atlant/plugins/sparkline/jquery.sparkline.min
//= require atlant/plugins/knob/jquery.knob.min
//= require atlant/plugins/ion/ion.rangeSlider.min
//= require atlant/plugins/owl/owl.carousel.min
//= require atlant/plugins/moment.min
//= require atlant/plugins/daterangepicker/daterangepicker
//= require atlant/plugins/tagsinput/jquery.tagsinput.min
//= require atlant/plugins/dropzone/dropzone.min
//= require atlant/plugins/fullcalendar/fullcalendar.min
//= require atlant/plugins/datatables/jquery.dataTables.min
//= require atlant/demo_tables
//= require atlant/plugins
//= require atlant/actions
//= require highcharts/highcharts
//= require_self

$(document).ready(function() {
  var clickOnBudgetModal = function(){
    $('body').on('click', 'edit-budget-item-modal-link', function(){
      $('#editBudgetItemModal').modal('show');
    });
  }

  clickOnBudgetModal();

  var clickOnNewTransactionModal = function(){
    $('body').on('click', 'new-transaction-modal-link', function(){
      $('#newTransactionModal').modal('show');
    });
  }

  clickOnNewTransactionModal();

});
