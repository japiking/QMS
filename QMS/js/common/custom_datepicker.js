$.datepicker.regional['ko'] = {
			   //showOn: "both", // ��ư�� �ؽ�Ʈ �ʵ� ��� Ķ������ �����ش�.
			   //buttonImage: "/images/common/icon_calender.gif", // ��ư �̹���
			   //buttonImageOnly: true, // ��ư�� �ִ� �̹����� ǥ���Ѵ�.
			   changeMonth: true, // ���� �ٲܼ� �ִ� ����Ʈ �ڽ��� ǥ���Ѵ�.
			   changeYear: true, // ���� �ٲ� �� �ִ� ����Ʈ �ڽ��� ǥ���Ѵ�.
			   minDate: '-100y', // ���糯¥�κ��� 100���������� ���� ǥ���Ѵ�.
			   nextText: '���� ��', // next �������� ����.
			   prevText: '���� ��', // prev �������� ����.
			   numberOfMonths: [1,1], // �ѹ��� �󸶳� ���� ���� ǥ���Ұ��ΰ�. [2,3] �� ���, 2(��) x 3(��) = 6���� ���� ǥ���Ѵ�.
			   stepMonths: 1, // next, prev ��ư�� Ŭ�������� �󸶳� ���� ���� �̵��Ͽ� ǥ���ϴ°�. 
			   yearRange: 'c-2:c+2', // �⵵ ���� ����Ʈ�ڽ��� ���� �⵵���� ����, ���ķ� ���� ������ ǥ���Ұ��ΰ�.
			   showButtonPanel: true, // Ķ���� �ϴܿ� ��ư �г��� ǥ���Ѵ�. 
			   currentText: '���ó�¥' , // ���� ��¥�� �̵��ϴ� ��ư �г�
			   closeText: '�ݱ�',  // �ݱ� ��ư �г�
			   dateFormat: "yy-mm-dd", // �ؽ�Ʈ �ʵ忡 �ԷµǴ� ��¥ ����.
			   //showAnim: "slide", //�ִϸ��̼��� �����Ѵ�.
			   
			   showMonthAfterYear: true , // ��, ����� ����Ʈ �ڽ��� ��,�� ������ �ٲ��ش�. 
			   monthNames: ['1��','2��','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��'],
			   monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
			   dayNames: ['��','��','ȭ','��','��','��','��'],
			   dayNamesShort: ['��','��','ȭ','��','��','��','��'],
			   dayNamesMin: ['��','��','ȭ','��','��','��','��'],
			   weekHeader: 'Wk',
			   firstDay: 0,
			   isRTL: false,
			   yearSuffix: '' 
		};
			  $.datepicker.setDefaults($.datepicker.regional['ko']);
//�޷��̺�Ʈ
function datepicker_view(el) {
	$(el).datepicker({
	dateFormat : 'yy-mm-dd',
	showAnim: "slide"
	});
}