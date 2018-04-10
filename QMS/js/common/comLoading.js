$(function() {
	jex.addAjaxBefore	(function(xhr,setting) 		{ xhr.setRequestHeader("charset", "utf-8");});
	jex.addAjaxComplete	(function(xhr,textstatus) 	{});
});

jex.addAjaxBefore(function(dat, svt){
	ComUtil.showloading();
	return dat;
});

jex.setAjaxBeforeData(function(dat,svc) {
	ComUtil.showloading();
	return dat;
});

jex.setAjaxCompleteData(function(dat,svc) {
	ComUtil.hideloading();
	return dat;
	
});
