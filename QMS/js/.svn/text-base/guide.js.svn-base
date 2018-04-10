
// working board
(function($){

			$.fn.listToggle=function(){
				var target = $(".workList p");
				//target.next().hide();
				target.each(function(){
					var tt = $(this);
					var tr = tt.next().find("tr").length;
					var td = tt.next().find('tr>td:last-child');
					var completeNm = td.length;
					td.each(function(){
						if($(this).text() == ""){
							completeNm -= 1
						}
					});
					var total = tt.find(".total");
					var complete = tt.find(".completed");
					complete.text(completeNm);
					total.text(tr-1);
					//var rate = complete / total ; 
					//alert(rate);

				/*	tt.toggle(function(){
						target.next().slideUp(200);
						tt.next().slideDown(200);
					},function(){
					   // target.next().slideUp(200);
						tt.next().slideUp(200);
					});*/
				});
			}

			/*$.fn.totalToggle=function(){
				var target = $(".workList p");
				var btn = $("button");
				btn.each(function(){
					$(this).click(function(){
						var dt = $(this).attr("title");
						if(dt=="allopen"){
							target.next().slideDown(200);
						}else{
							target.next().slideUp(200);
						}
					});
				});
			}
*/
			$.fn.selName=function(){
				var ts = $(this);
				ts.each(function(){
					var str;
					$(this).find("select").change(function () {
					  $(this).find("option:selected").each(function () { // 여기서 option:secleted를 해준 이유는 select의 특성때문에... change가 된다는건 selected된다는거....
						   str = $(this).text(); // selected 된 것의 텍스트를 가지고 온다는거...
					  });
					  var pub = $(this).parent().parent().parent().parent().find('.publisher');
					  pub.each(function(){
						var pubtxt = $(this).text();
						if(pubtxt == str){
							$(this).parent().show();
						}else{
							$(this).parent().hide();
						}
					  });
					  if(str == '작업자') pub.parent().show(); // 전체보기
					})
				});
			}

		})(jQuery);

		$(function(){
			$(".workList").listToggle();
			//$("body").totalToggle();
			$(".tableType1").selName();
		});


/* tab */
		$(function(){
			if($('.tab-wrap').length>0){
				$('.tab-wrap').tooltip('basicTab');
			}
		});


		(function($){
			var methods = {
				
				// basic tab
				basicTab : function () {
				   // List Tab Navigation
					var tab_wrap = $('div.tab-wrap'),
						tt = tab_wrap.find('h3');

						tab_wrap.find('.tab-conts').hide();
						tab_wrap.find('.tab-conts:first').show();

						/* 120717 컨텐츠 영역의 높이값 체크 위해 추가된 내용1 */
						var targetHeight = tab_wrap.find('.tab-conts:first').height();
						var tab_wrapHeight = targetHeight + 80;
						tab_wrap.height(tab_wrapHeight);
						/* end  */

					tt.each( function(){
						var target = $(this);
						target.find("a").on( "click", function(){

					if(!target.parent().hasClass('noAction')) { // 페이지 이동만 할경우 tab-wrap에 noAction 클래스를 같이준다.

						/* 120717 컨텐츠 영역의 높이값 체크 위해 추가된 내용2 */
						targetHeight = target.next('.tab-conts').height();
						tab_wrapHeight = targetHeight + 80;
						tab_wrap.height(tab_wrapHeight);
						/* end  */

						tt.next('div.tab-conts').hide(); // h3 next의 모든 tab-conts를 숨긴다.
						target.next('.tab-conts').show(); // target인 클릭한 next인 tab-conts를 보여준다.

						target.addClass('active').siblings('h3').removeClass('active'); // 클릭한 h3에 클래스를 add시키고 형제들은 제거

							};
						});
					});
				}

			};

			$.fn.tooltip = function(method){
				if(methods[method]){
				return methods[method].apply(this, Array.prototype.slice.call(arguments,1));
				}else if(typeof method === 'object' || !method){
					return methods.init.apply(this,arguments);
				}else{
					$.error('method'+method+'does not exist on jQuery.tooltip');
				}
			};


		})(jQuery);


		$(function() {
			$("#show").toggle(
					function(){
						$("#update").show();
					},
					function(){
						$("#update").hide();
					});
		});