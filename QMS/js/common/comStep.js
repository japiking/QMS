/**
 * ComUtil 정리
 */
var _comStep = function(){
	this.curStep = "";	//현재 step
	this.stepStack = new Array();
};
_comStep.instance = new _comStep();
_comStep.getInstance = function() {
	return _comStep.instance;
};

/**
 * 요청한 step을 보여줍니다.
 * @param stepId 보여주고싶은 StepId
 */
_comStep.prototype.showStep = function(stepId, isScroll){
	if(isScroll == null) isScroll = true;
	ComStep.curStep = stepId;
	this.stepStack.push(stepId);
	$('[com-step-id]').hide();
	$('[com-step-include-id]').hide();
	
	var opt_include = $('[com-step-id="'+stepId+'"]').attr("com-step-include");
	if("true" == opt_include){
		$('[com-step-include-id="step98"]').show();
	}
	
	$('[com-step-id="'+stepId+'"]').show();
	
	if(isScroll) ComUtil.moveScrollTop();
};
/**
 * 이전 step을 보여줍니다.
 * @param step_id 보여주고싶은 step_id
 */
_comStep.prototype.showPreStep = function(){
	var step_id = ComStep.getPrevStepNo();
	
	$('[com-step-id]').hide();
	$('[com-step-include-id]').hide();
	
	var opt_include = $('[com-step-id="'+step_id+'"]').attr("com-step-include");
	if("true" == opt_include){
		$('[com-step-include-id="step98"]').show();
	}
	this.stepStack.push(step_id);
	ComStep.curStep = step_id;
	$('[com-step-id="'+step_id+'"]').show();
	ComUtil.moveScrollTop();
};
/**
 * 모든 step을 숨깁니다.
 */
_comStep.prototype.hideAllStep = function(){
	$('[com-step-id]').hide();
	$('[com-step-include-id]').hide();
	$("#comTab").hide();
};
/**
 * 이전 step을 가져온다.
 */
_comStep.prototype.getPrevStepNo = function(){
	var step_id = "";
	if(this.stepStack.length > 1 ){
		step_id = this.stepStack.pop();
		step_id = this.stepStack.pop();
	} else if(this.stepStack.length == 1 ){
		step_id = this.stepStack.pop();
	} else {
		// 이전 step이 더이상 없는 경우에는 현제 step 반환
		step_id = ComStep.curStep;
	}
	return step_id;
};

var ComStep = _comStep.getInstance();
