$(document).ready(function() {
  $('.item').click(function() {
    var id = $(this).data('id');
    var type = $(this).data('type');

    alert("id: " + id + ", type: " + type);
  });
});
