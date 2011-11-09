$(document).ready(function() {
  $('.item').live('click', function() {
    var id = $(this).data('id');
    var type = $(this).data('type');
    var column = $(this).parents('.item_column')
    var table = column.parent();

    column.nextAll().hide('fast');

    $.get("navigate/" + id, function(data) {
      table.append(data);
    });
  });
});
