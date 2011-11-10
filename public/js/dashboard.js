$(document).ready(function() {
  $('li.item').live('click', function() {
    var id = $(this).data('id');
    var type = $(this).data('type');
    var column = $(this).closest('td');

    $('li.item.selected', column).removeClass('selected');
    $(this).addClass('selected');

    remove_next_columns(column);
    spinny = add_next_column(column, "<div class=\"spinny\"></div>");

    $.get(type + '/' + id, function(data) {
      spinny.remove();
      add_next_column(column, data);
    });
  });

  $('.add_folder').live('click', function() {
    var id = $(this).closest('ul.item-box').data('id');
    var column = $(this).closest('td');

    $.get("folder/add/" + id, function(data) {
      data = $("<li>" + data + "</li>");
      data.insertBefore($('li.item', column).first());
      data.hide().show('fast');
    });
  });

  $('.add_file').live('click', function() {

  });

  $('.add_folder_form .submit').live('click', function() {
    var form = $(this).closest('.add_folder_form');
    var name = $('input', form).val();
    var parent_id = form.data('parent');

    $.post("folder/add/" + parent_id, { name: name }, function(data) {
      form.closest('li').html(data).addClass('item');
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
