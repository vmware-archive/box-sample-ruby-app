/* Handles all of the javascript effects for the dashboard */

/* Pane navigation actions */
$(document).ready(function() {
  // Adds a new pane right after the selected one.
  function add_next_pane(pane, data) {
    data = "<td class=\"pane\">" + data + "</td>";
    $(data).hide().insertAfter(pane).show('fast');
  }

  // Hides and then removes any panes after the selected one.
  function remove_next_panes(pane) {
    pane.nextAll().hide('fast', function() { $(this).remove; });
  }

  // Handles click events on any clickable items.
  $('.item.clickable').live('click', function() {
    var id = $(this).data('id');
    var type = $(this).data('type');
    var pane = $(this).closest('.pane');

    // Replace any selected items in this pane with this item
    $('.item.selected', pane).removeClass('selected');
    $(this).addClass('selected');

    // Remove any existing panes to the right of this one
    remove_next_panes(pane);

    // Add a new pane for the loading spinny
    add_next_pane(pane, "<div class=\"spinny\"></div>");

    // Make an AJAX request for the data to insert in the new pane
    $.get(type + '/' + id, function(data) {
      // Remove any new panes to the right, including the spinny
      remove_next_panes(pane);

      // Add a new pane with this data
      add_next_pane(pane, data);
    });
  });
});

/* File/Folder creation logic */
$(document).ready(function() {
  // Inserts a new item in the third row. (below buttons, above folders)
  function add_new_item(item_box, data) {
    last_button = $('.item:nth-child(2)', item_box);
    $(data).insertAfter(last_button).hide().show('fast');
  }

  // The button to add a new folder.
  $('.add_folder.button').live('click', function() {
    var item_box = $(this).closest('.item-box');
    var parent_id = item_box.data('id');

    // Get and insert the form to add a new folder.
    $.get("folder/add/" + parent_id, function(data) {
      add_new_item(item_box, data);
    });
  });

  // The button to add a new file.
  $('.add_file.button').live('click', function() {
    var item_box = $(this).closest('.item-box');
    var parent_id = item_box.data('id');

    // Get an insert the form to add a new file.
    $.get("file/add/" + parent_id, function(data) {
      add_new_item(item_box, data);
    });
  });

  // Handles when the add folder form was submitted.
  $('form.add_folder').live('submit', function() {
    var item = $(this).closest('.item');
    var name = $('input[name="name"]', this).val();
    var parent_id = $('input[name="parent"]', this).val();

    // Replaces the form with a spinny, so it can't be submitted twice.
    $(this).hide().after("<div class=\"spinny\"></div>");

    // Add the new folder and the returned information about it.
    $.post("folder/add/" + parent_id, { name: name }, function(data) {
      item.replaceWith(data).hide().show('fast');
    });

    // Prevent the default form behavoir.
    return false;
  });

  // Submits the form once a file has been selected.
  $('form.add_file :file').live('change', function() {
    $(this).closest('form').submit();
  });

  // Handles when the add file form was submitted.
  $('form.add_file').live('submit', function() {
    // Hide the form and show a spinny.
    $(this).hide().after("<div class=\"spinny\"></div>");

    // Note: Adding files does not use AJAX because of technical limitations.
    // You can find many jQuery plugins to help you do this.
  });

  // Make the button button actually act like a submit button.
  $('.submit').live('click', function() {
    $(this).closest('form').submit();
  });
});
