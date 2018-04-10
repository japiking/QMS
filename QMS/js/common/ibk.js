	$(function(){ 
		function initTabs() {
			$('.tab a').bind('click',function(e) {
				e.preventDefault();
				var thref = $(this).attr("href").replace(/#/, '');
				$('.tab a').removeClass('on');
				$(this).addClass('on');
				$('.tab_con').removeClass('active');
				$('#'+thref).addClass('active');
			});
		}
		initTabs();
	})