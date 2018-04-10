/*
 * tab
 */

//$(window).load(function(){
//		loaded();
//});

$.fn.tab = function(){
    return this.each(function(){
        var $this = $(this);
        var $tabList = $(this).find('li'); 

        var tabSetting = function(){
            $this.each(function() {   
                $tabList.eq(0).addClass('selected').find('.blind').html('현재메뉴 선택됨');
                $tabList.each(function(){  
                    $(this).find('a').append('<span class="blind">메뉴</span>');  
                    if ($(this).hasClass('selected')){
                        var showTab = $(this).find('a').attr('href');   
                        $(showTab).show(); 
                        $(this).find('.blind').html('현재메뉴 선택됨')
                    };  
                });
            });
            tabClick();                     
        }
        var tabClick = function(){
            $this.each(function() { 
                $tabList.each(function() {
                    $(this).on("click", function(e) {   
                        $tabList.removeClass('selected');
                        $(this).addClass('selected').siblings().find('.blind').html('메뉴');
                        var activeTab = $(this).find('a').attr('href');
                        $(activeTab).show().siblings('.tab_content').hide();

                        if ($(this).hasClass('selected'))
                            {$(this).find('.blind').html('현재메뉴 선택됨')};
                        e.preventDefault();
                    });
                });
            });
        }
        tabSetting();
    });     
} 
$('.tabs').tab();

/*
 * a:hover, button :hover 
 */
function atouch(){
    var _a = $('a');
    var _btn = $('button');

    $(_a).on({
        touchstart: function() { $(this).addClass('ahover');},
        touchmove: function() { $(this).removeClass('ahover');},
        touchend: function() { $(this).removeClass('ahover');}
    });

    $(_btn).on({
        touchstart: function() { $(this).addClass('bhover');},
        touchmove: function() { $(this).removeClass('bhover');},
        touchend: function() { $(this).removeClass('bhover');}
    });
} atouch();

/*
 * accordion 
 */
function accordion(){
    $("dl.accordion dt>a").append('<span class="arr">답변닫힘</span>');
    $("dl.accordion dt").click(function(e){
        if($("+dd",this).css("display")=="none"){
            $("dl.accordion dd").slideUp(300, "swing");
            $("+dd",this).slideDown(300, "swing");		            
            $("dl.accordion dt").removeClass("over");
            $("dl.accordion .arr").html("답변닫힘");
            $(this).addClass("over");
            $(this).find(".arr").html("답변열림");
        }else{
        	$("+dd",this).slideUp(300, "swing");
        	$(this).removeClass("over");
        	$(this).find(".arr").html("답변닫힘");
        }        
        e.preventDefault();
    });
} accordion();

/* search delete button */
$('.search').click(function(){
   $(".btn_delete").css('display','block');
   $(".bar").css('display','block');
}).blur(function(){
    if($(this).val() == ''){
        $(".btn_delete").css('display','none');
        $(".bar").css('display','none');
    } else {
        $(".btn_delete").css('display','block');
        $(".bar").css('display','block');
    }
}).change(function(){
    if($(this).val() == ''){
        $(".btn_delete").css('display','none');
        $(".bar").css('display','none');
    } else {
        $(".btn_delete").css('display','block');
        $(".bar").css('display','block');
    }
}).blur();


