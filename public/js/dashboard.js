$(document).ready(function() {
  $('li.item').live('click', function() {
    var id = $(this).data('id');
    var type = $(this).data('type');
    var column = $(this).parents('td');

    $('li.item.selected', column).removeClass('selected');
    $(this).addClass('selected');

    remove_next_columns(column);
    spinny = add_next_column(column, "<div class=\"spinny\"></div>");

    var action = (type == 'folder') ? 'items' : 'preview';

    $.get(action + '/' + id, function(data) {
      spinny.remove();
      add_next_column(column, data);
    });
  });
});

function add_next_column(column, data, speed) {
  speed = speed || 'fast';
  data = "<td class=\"pane\">" + data + "</td>";

  return $(data).hide().insertAfter(column).show(speed);
}

function remove_next_columns(column, speed) {
  speed = speed || 'fast';

  column.nextAll().hide(speed, function() {
    $(this).remove;
  });
}
