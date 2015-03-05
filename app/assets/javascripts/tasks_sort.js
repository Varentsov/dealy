var fixHelperModified = function(e, tr) {
    var $originals = tr.children();
    var $helper = tr.clone();
    $helper.children().each(function(index)
    {
        $(this).width($originals.eq(index).width())
    });
    return $helper;
};

var findIds = function() {
    var ids = [];
    var current_elems = $('.sortable-tasks').children().toArray();
    for (var i = 0; i < current_elems.length; i++) {
        ids.push(current_elems[i].id)
    }
    return ids;
};

var who_sorting = function(current_ids, new_ids, pressed_id) {
    //console.log(pressed_id);
    //console.log(current_ids);
    //console.log(new_ids);

    var sort = [];
    var flag = true;

    for (var i = new_ids.length - 1; i >= 0; i--) {
        if ((new_ids[i] != pressed_id) && flag) {
            sort[i] = null;
        }
        else {
            sort[i] = new_ids[i];
            flag = false;
        }
    }
    console.log(sort);
    return sort;
};

$(document).ready(function() {
    var new_sor_ids;
    var current_ids;
    var pressed_id;

    current_ids = findIds();

    $(".sortable-tasks tr").mousedown(function() {
        pressed_id = this.id
    });

    $(".sortable-tasks").sortable({
        helper : fixHelperModified,
        update : function(event, ui) {
            new_sor_ids = findIds();
            var new_ids = who_sorting(current_ids, new_sor_ids, pressed_id);
            current_ids = new_sor_ids;
            var ajax_sort = $.ajax({
                type: "POST",
                url: "/tasks/edit_sort.js",
                data: { ids: new_ids.toString(), pressed_id: pressed_id },
                success: function(response) {
                    console.log(response.status)
                }
            });
        }
    });
});