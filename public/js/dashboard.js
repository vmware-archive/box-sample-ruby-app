function add_next_column(column, data, speed) {
  speed = speed || 'fast';
  data = "<td class=\"item_column\">" + data + "</td>";

  return $(data).hide().insertAfter(column).show(speed);
}

function remove_next_columns(column, speed) {
  speed = speed || 'fast';

  column.nextAll().hide(speed, function() {
    $(this).remove;
  });
}

$(document).ready(function() {
  $('.item').live('click', function() {
    var id = $(this).data('id');
    var type = $(this).data('type');
    var column = $(this).parents('.item_column')

    remove_next_columns(column);
    spinny = add_next_column(column, "<div class=\"spinny\"></div>");

    var action = (type == 'folder') ? 'navigate' : 'preview';

    $.get(action + '/' + id, function(data) {
      spinny.remove();
      add_next_column(column, data);
    });
  });
});
