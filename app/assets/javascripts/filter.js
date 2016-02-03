$(document).ready(function () {
  var $vendors = $('.vendor');
  var $categories = $('.category');
  var $orders = $('.order');

  $('#vendor_filter_name').on('keypress', function () {
    var currentName = this.value.toLowerCase();

    $vendors.each(function (index, vendor) {
      var $vendor = $(vendor);
      var $vendorName = $vendor.find('h2 span').text().toLowerCase();

      if ($vendorName.startsWith(currentName)) {
        $vendor.show();
      } else {
        $vendor.hide();
      }
    });
  });

  $('#category_filter_name').on('keypress', function () {
    var currentName = this.value.toLowerCase();

    $categories.each(function (index, category) {
      var $category = $(category);
      var $categoryName = $category.find('h2').text().toLowerCase();

      if ($categoryName.startsWith(currentName)) {
        $category.show();
      } else {
        $category.hide();
      }
    });
  });

  $('#order_status').on('change', function () {
    var currentStatus = $('#order_status :selected').text();

    $orders.each(function (index, order) {
      var $order = $(order);
      var $orderStatus = $order.find('.order_status').text();

      if ($orderStatus === currentStatus || currentStatus === 'all') {
        $order.show();
      } else {
        $order.hide();
      }
    });
  });
});
