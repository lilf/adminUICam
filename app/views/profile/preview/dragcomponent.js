module.exports = function() {

// $(function() {
    $( "#component_type div" )
    .draggable({
      appendTo: "#components",
      helper: "clone"
    });

    $( "#components ul.ui-components-list" )
    .droppable({
      activeClass: "ui-state-default",
      hoverClass: "ui-state-hover",
      accept: ":not(.ui-sortable-helper)",
      drop: function( event, ui ) {
        $( this ).find( ".placeholder" ).remove();
        $( this ).children().removeClass('active-component');
        $( "<li></li>" ).addClass("component active-component").html( ui.draggable.html() )
        .appendTo( this )
        .on('mouseenter', function(e) {
          // FIXME: console.log(e) many times trigger when button clicked
          if($('button.remove-component', this).length) return;
          $('<button>', {text: 'x'}).addClass('remove-component').appendTo($(this));
        })
        .on('click', 'button.remove-component', function() {
          $li = $(this).parent();
          $parent = $li.parent();
          if ($li.hasClass('active-component')) $li.trigger('deactive:component');
          $li.children().each(function() {
            return $(this).trigger('dispose:component');
          });
          $li.remove();

          if (!$parent.children().length) {
            $parent.html($('<li>', {
              text: 'add your components here'
            }).addClass('placeholder'));
          }
        })
        .on('mouseleave', function() {
          $('button.remove-component', this).remove();
        })

        .trigger('profile:active');
      }
    })
    .sortable({
      items: "li:not(.placeholder)",
      sort: function() {
        $( this ).removeClass( "ui-state-default" )
      }
    })

    // .selectable({
    //   stop: function( event, ui) {
    //     $(this).children().removeClass("active-component");
    //     $( ui.selectable )().addClass("active-component").trigger('profile:active');}
    // });

  // });
};
