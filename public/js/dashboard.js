function add_next_column(column, new_column, speed) {
  speed = speed || 'fast'

  return $(new_column).hide().insertAfter(column).show(speed);
}

function remove_next_columns(column, speed) {
  speed = speed || 'fast'

  column.nextAll().hide(speed, function() {
    $(this).remove;
  });
}

function generate_spinny() {
  return "<td class='item_column'><div class='spinny'></div></td>";
}

$(document).ready(function() {
  $('.item').live('click', function() {
    var id = $(this).data('id');
    var type = $(this).data('type');
    var column = $(this).parents('.item_column')

    remove_next_columns(column);
    spinny = add_next_column(column, generate_spinny(), 0);

    var action = (type == 'folder') ? 'navigate' : 'preview';

    $.get(action + '/' + id, function(data) {
      spinny.remove();
      add_next_column(column, data)
    });
  });
});
