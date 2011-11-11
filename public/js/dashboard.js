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
      remove_next_columns(column);
      add_next_column(column, data);
    });
  });
});

$(document).ready(function() {
  $('.add_folder.button').live('click', function() {
    var id = $(this).closest('ul.item-box').data('id');
    var column = $(this).closest('td');

    $.get("folder/add/" + id, function(data) {
      data = $("<li>" + data + "</li>");
      data.insertBefore($('li.item', column).first());
      data.hide().show('fast');
    });
  });

  $('.add_file.button').live('click', function() {
    var id = $(this).closest('ul.item-box').data('id');
    var column = $(this).closest('td');

    $.get("file/add/" + id, function(data) {
      data = $("<li>" + data + "</li>");
      data.insertBefore($('li.item', column).first());
      data.hide().show('fast');
    });
  });

  $('form.add_folder').live('submit', function() {
    var item = $(this).closest('li');
    var name = $('input[name="name"]', this).val();
    var parent_id = $(this).data('parent');

    $(this).hide('fast');
    $(this).after("<div class=\"spinny\"></div>");

    $.post("folder/add/" + parent_id, { name: name }, function(data) {
      item.html(data).addClass('item').hide().show('fast');
    });

    return false;
  });

  $('form.add_file').live('submit', function() {
    $(this).hide('fast');
    $(this).after("<div class=\"spinny\"></div>");
  });

  $('.submit').live('click', function() {
    $(this).closest('form').submit();
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
