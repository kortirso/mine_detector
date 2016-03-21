$(function() {
    this.oncontextmenu = function() {return false;};
    $('#mines').on('click', '.square', function(e) {
        x = $(this).data('x');
        y = $(this).data('y');
        $.post('http://localhost:3000/square/' + x + y + '/1');
    })
    .on('mousedown', '.square', function(e) {
        if(e.which == 2 || e.which == 3) {
            x = $(this).data('x');
            y = $(this).data('y');
            $.post('http://localhost:3000/square/' + x + y + '/2');
        }
    });
});