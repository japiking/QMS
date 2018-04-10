/**
 * @설명 : 데이터값 변경[정규식]
 * @param strValue1 : 변경 원본 값
 * @param strValue2 : 변경 후 값
 * @예제 : "TESTAAA".replaceAll("AAA", "BBB")
 */
String.prototype.replaceAll = function(strValue1, strValue2) {
    return this.split(strValue1).join(strValue2);
};
/**
 * @설명 : 문자열 좌우 공백제거
 * @param str : 대상 데이터
 * @returns : 공백 제거된 데이터
 * @예제 : "TESTAAA   ".trim() 
 */
String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/g, "");
};