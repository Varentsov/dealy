var fixHelperModified = function(e, tr) {
    var $originals = tr.children();
    var $helper = tr.clone();
    $helper.children().each(function(index)
    {
        $(this).width($originals.eq(index).width())
    });
    return $helper;
};
/*
$(document).ready(function() {
   $(".sortable-tasks").sortable({
       helper: fixHelperModified
   })
});*/
$(document).ready(function() {
    $(".sortable-tasks").sortable({
        helper : fixHelperModified,
        update : function(event, ui)
        {
            //alert('sort order updated');

            // Display sort order - also checkout serialize() method in jQuery UI Docs
            console.log('sort order: ' + $(this).sortable('toArray').toString());
        }
    })
});