var path = window.location.pathname;

	if ($('.path').length == 1) { // lnb
	}


// S : gnb
$('#newHeader').load('publishing.html #newHeader:eq(0)>*', function () {
			// 메뉴활성화 재선언
			var loca = $('.path').text().replace(/ /g, ""),
			loca1 = loca.split('>')[1], //기업뱅킹
			loca2 = loca.split('>')[2], //기업온라인
			loca3 = loca.split('>')[3], //1depth
			loca4 = loca.split('>')[4], //2depth
			loca5 = loca.split('>')[5]; //3depth

			loca = $('.path').text().replace(/ /g, "");

			if (loca3.indexOf('조회') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(0) > a').addClass('on02');
			} else if (loca3.indexOf('이체') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(1) > a').addClass('on02');
			} else if (loca3.indexOf('외환') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(2) > a').addClass('on02');
			} else if (loca3.indexOf('전자결제') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(3) > a').addClass('on02');
			} else if (loca3.indexOf('공과금') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(4) > a').addClass('on02');
			} else if (loca3.indexOf('대출') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(5) > a').addClass('on02');
			} else if (loca3.indexOf('예금/펀드/신탁') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(6) > a').addClass('on02');
			} else if (loca3.indexOf('부가서비스') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(7) > a').addClass('on02');
			} else if (loca3.indexOf('자금관리') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(8) > a').addClass('on02');
			} else if (loca3.indexOf('신용카드') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(9) > a').addClass('on02');
			} else if (loca3.indexOf('서비스관리') != -1) {
				$('#gnb li #gnbMenuId > ul > li:eq(10) > a').addClass('on02');
			}


			$('#gnb li #gnbMenuId > ul > li').hover(function(event){
					var $this = $(this);
					var $li = $this.children('ul').css('display','block');

					$this.addClass('ative');
					$this.children('ul').children('li').fadeIn();
					$this.children(':first').addClass('d2On2');

					if ( $li.length > 0 ) {
						var $iframe = $('#iframe_id').show().offset($li.offset());
						$iframe.width( $li.outerWidth() );
						$iframe.height( $li.outerHeight() );
					}

				}, function(event) {
					var $this = $(this);
					var $li = $(this).children('ul').css('display','none');
					$this.children('ul').children('li').css('display','none');
					$this.removeClass('ative');
					$this.children(':first').removeClass('d2On2');
					$('#iframe_id').hide();
				});

	});
// E : gnb


// S : footer
$('#newFooter').load('publishing.html #newFooter>*', function () {
	});
// E : footer


// S : lnb
	$('#lnb').load('publishing.html #lnb>*', function () {
	
		// 메뉴활성화 재선언
		var loca = $('.path').text().replace(/ /g, ""),
			loca1 = loca.split('>')[1], //기업뱅킹
			loca2 = loca.split('>')[2], //기업온라인
			loca3 = loca.split('>')[3], //1depth
			loca4 = loca.split('>')[4], //2depth
			loca5 = loca.split('>')[5]; //3depth

		loca = $('.path').text().replace(/ /g, "");

		// 조회
		if (loca3.indexOf('조회') != -1) {
				if (loca4.indexOf('계좌현황') != -1) {
					$('.menuList li:eq(0)').addClass('on');
				} else if (loca4.indexOf('예금거래내역') != -1) {
					$('.menuList li:eq(1)').addClass('on');
				} else if (loca4.indexOf('과거거래내역') != -1) {
					$('.menuList li:eq(2)').addClass('on');
				} else if (loca4.indexOf('대출계좌') != -1) {
					$('.menuList li:eq(3)').addClass('on');
				} else if (loca4.indexOf('당좌계좌') != -1) {
					$('.menuList li:eq(4)').addClass('on');
				} else if (loca4.indexOf('CMS계좌') != -1) {
					$('.menuList li:eq(5)').addClass('on');
				} else if (loca4.indexOf('보관어음') != -1) {
					$('.menuList li:eq(6)').addClass('on');
				} else if (loca4.indexOf('주류카드') != -1) {
					$('.menuList li:eq(7)').addClass('on');
				} 
				/*else if (loca4.indexOf('신용카드') != -1) {
					$('.menuList li:eq(8)').addClass('on');
					$('.menuList li:eq(8) ul.list02').show();
				} */ else {}
		}
		//이체
		else if (loca3.indexOf('이체') != -1) {
				if (loca4.indexOf('계좌이체') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('예약이체') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('자동이체') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('대량이체') != -1) {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('당행외화이체') != -1) {
					$('.menuList > li:eq(4)').addClass('on');
					$('.menuList > li:eq(4) ul.list02').show();
				} else if (loca4.indexOf('타행외화이체') != -1) {
					$('.menuList > li:eq(5)').addClass('on');
					$('.menuList > li:eq(5) ul.list02').show();
				} else if (loca4.indexOf('글로벌이체') != -1) {
					$('.menuList > li:eq(6)').addClass('on');
					$('.menuList > li:eq(6) ul.list02').show();
				} else {}
		}

		//외환/수출입
		else if (loca3.indexOf('외환') != -1) {
			//alert(loca);
				if (loca4.indexOf('외화송금') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('외환매매') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('수입') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('수출') != -1) {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('수수료') != -1) {
					$('.menuList > li:eq(4)').addClass('on');
					$('.menuList > li:eq(4) ul.list02').show();
				} else if (loca4.indexOf('TSU OAT') != -1) {
					$('.menuList > li:eq(5)').addClass('on');
					$('.menuList > li:eq(5) ul.list02').show();
				} else if (loca4.indexOf('인터넷EDI') != -1) {
					$('.menuList > li:eq(6)').addClass('on');
				}  else if (loca4.indexOf('환리스크관리') != -1) {
					$('.menuList > li:eq(7)').addClass('on');
					$('.menuList > li:eq(7) ul.list02').show();
				} else {}
		}

		//공과금 (UTBL)
		else if (loca3.indexOf('공과금') != -1) {
			//alert(loca);
				if (loca4.indexOf('공과금납부') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('지로요금') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('관세') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('국세/지방세/범칙금') != -1) {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('사회보험료') != -1) {
					$('.menuList > li:eq(4)').addClass('on');
					$('.menuList > li:eq(4) ul.list02').show();
				} else if (loca4.indexOf('각종요금') != -1) {
					$('.menuList > li:eq(5)').addClass('on');
					$('.menuList > li:eq(5) ul.list02').show();
				} else {}
		}

		//대출(LOAN)
		else if (loca3.indexOf('대출') != -1) {
				if (loca4.indexOf('대출상환및이자납부') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('대출항목별조회') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('여신한도내거래') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('인터넷자동대출서비스') != -1) {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('대출거래현황요약') != -1) {
					$('.menuList > li:eq(4)').addClass('on');
				} else {}
		}

		//예금/펀드/신탁 (SAFD)
		else if (loca3.indexOf('예금') != -1) {
			//alert(loca);
				if (loca4.indexOf('인터넷예금') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('인터넷외화예금') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('인터넷펀드') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('퇴직연금') != -1) {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('퇴직신탁') != -1) {
					$('.menuList > li:eq(4)').addClass('on');
					$('.menuList > li:eq(4) ul.list02').show();
				} else if (loca4.indexOf('자금관리특정금전신탁') != -1) {
					$('.menuList > li:eq(5)').addClass('on');
					$('.menuList > li:eq(5) ul.list02').show();
				} else {}
		}

		//부가서비스(ADSV)
		else if (loca3.indexOf('부가서비스') != -1) {
			
				if (loca4.indexOf('가상계좌') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('SMS통지/승인서비스') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('소액계좌정리') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('휴면계좌정리') != -1) {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('무통장거래정리') != -1) {
					$('.menuList > li:eq(4)').addClass('on');
					$('.menuList > li:eq(4) ul.list02').show();
				} else if (loca4.indexOf('자기앞수표조회') != -1) {
					$('.menuList > li:eq(5)').addClass('on');
					$('.menuList > li:eq(5) ul.list02').show();
				} else if (loca4.indexOf('은행조회서조회/출력') != -1) {
					$('.menuList > li:eq(6)').addClass('on');
					$('.menuList > li:eq(6) ul.list02').show();
				} else if (loca4.indexOf('원천징수영수증발급') != -1) {
					$('.menuList > li:eq(7)').addClass('on');
					$('.menuList > li:eq(7) ul.list02').show();
				} else if (loca4.indexOf('계좌비밀번호등록') != -1) {
					$('.menuList > li:eq(8)').addClass('on');
					$('.menuList > li:eq(8) ul.list02').show();
				} else if (loca4.indexOf('대출이자안내서비스') != -1) {
					$('.menuList > li:eq(9)').addClass('on');
					$('.menuList > li:eq(9) ul.list02').show();
				} else if (loca4.indexOf('통장사본출력') != -1) {
					$('.menuList > li:eq(10)').addClass('on');
					$('.menuList > li:eq(10) ul.list02').show();
				} else {}
		}

		//전자결제(ELSM)
		else if (loca3.indexOf('전자결제') != -1) {
			//alert(loca);
				if (loca4.indexOf('인터넷약정') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('판매기업(매출채권)') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('구매기업(매입채무)') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('전자어음') != -1) {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('조달청네트워크론') != -1) {
					$('.menuList > li:eq(4)').addClass('on');
					$('.menuList > li:eq(4) ul.list02').show();
				} else if (loca4.indexOf('B2B결제서비스') != -1) {
					$('.menuList > li:eq(5)').addClass('on');
					$('.menuList > li:eq(5) ul.list02').show();
				}  else if (loca4.indexOf('전자세금계산서') != -1) {
					$('.menuList > li:eq(6)').addClass('on');
					$('.menuList > li:eq(6) ul.list02').show();
				} else {}
		}

		//신용카드 (CARD)
		else if (loca3.indexOf('신용카드') != -1) {
			//alert(loca);
				if (loca4.indexOf('신용카드') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
				} else {}
		}

		/*//환리스크관리
		else if (loca.indexOf('환리스크관리') != -1) {
			//alert(loca);
				if (loca4.indexOf('포지션현황') {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('평가손익') {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('위험도분석') {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('위험도분석Simulation') {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('환리스크관리의이해') {
					$('.menuList > li:eq(4)').addClass('on');
					$('.menuList > li:eq(4) ul.list02').show();
				} else if (loca4.indexOf('') != -1) {
					$('.menuList > li:eq(5)').addClass('on');
					$('.menuList > li:eq(5) ul.list02').show();
				} else {}
		}*/

		//서비스관리 (SVMG)
		else if (loca3.indexOf('서비스관리') != -1) {
			//alert(loca);
				if (loca4.indexOf('고객기본정보') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('인터넷뱅킹정보') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('전자금융결재관리') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('내부통제관리') != -1) {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('관계회사계좌통합관리') != -1) {
					$('.menuList > li:eq(4)').addClass('on');
					$('.menuList > li:eq(4) ul.list02').show();
				} else if (loca4.indexOf('Reporting서비스') != -1) {
					$('.menuList > li:eq(5)').addClass('on');
					$('.menuList > li:eq(5) ul.list02').show();
				} else if (loca4.indexOf('수수료관리') != -1) {
					$('.menuList > li:eq(6)').addClass('on');
					$('.menuList > li:eq(6) ul.list02').show();
				} else {}
		}

		//결재함
		else if (loca3.indexOf('결재함') != -1) {
			//alert(loca);
				if (loca4.indexOf('결재하기') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('진행중인결재내역') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('결재완료내역') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else {}
		}

		//거래함
		else if (loca3.indexOf('거래함') != -1) {
			//alert(loca);
				if (loca4.indexOf('진행중인거래내역') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('거래완료내역') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else {}
		}

		//로그인
		else if (loca3.indexOf('로그인') != -1) {
			//alert(loca);
				if (loca4.indexOf('로그인') != -1) {
					$('.menuList > li:eq(0)').addClass('on');
					$('.menuList > li:eq(0) ul.list02').show();
				} else if (loca4.indexOf('패스워드등록(신규)') != -1) {
					$('.menuList > li:eq(1)').addClass('on');
					$('.menuList > li:eq(1) ul.list02').show();
				} else if (loca4.indexOf('아이디찾기') != -1) {
					$('.menuList > li:eq(2)').addClass('on');
					$('.menuList > li:eq(2) ul.list02').show();
				} else if (loca4.indexOf('패스워드재등록(분실)') != -1) {
					$('.menuList > li:eq(3)').addClass('on');
					$('.menuList > li:eq(3) ul.list02').show();
				} else if (loca4.indexOf('이용고객등록') != -1) {
					$('.menuList > li:eq(4)').addClass('on');
					$('.menuList > li:eq(4) ul.list02').show();
				} else {}
		}





	});
// E: lnb