package qms;

public class Const {

	public static final String QMS_SESSION_ID			= "QMS_SESSION_ID";						// QMS 세션ID
	public static final String QMS_SESSION_MENU			= "QMS_SESSION_MENU";					// QMS 세션 메뉴정보
	public static final String ERROR_RETURN_URL			= "ERROR_RETURN_URL";					// 에러화면에서 이동할 페이지
	
	public static final String URL_VIEW_ERROR			= "/QMS/jsp/comm/error.jsp";			// 에러페이지
	public static final String URL_VIEW_INTRO			= "/QMS/jsp/main.jsp";					// 인트로 URL
	public static final String URL_VIEW_LOGIN			= "/QMS/jsp/main.jsp";					// 로그인 URL
	public static final String URL_VIEW_FIRST			= "/QMS/jsp/view/index.jsp";			// 로그인 첫 페이지
	
	public static final String URL_VIEW_WQ10001			= "/QMS/jsp/view/WQ10001.jsp";			// 프로젝트 등록
	
	
	public static final String URL_VIEW_PASSWORD_REG	= "/QMS/jsp/view/Q00102.jsp";		// 비밀번호 등록 URL
	
	public static final String URL_VIEW_Q10101			= "/QMS/jsp/view/Q10101.jsp";		// 실적등록
	public static final String URL_VIEW_Q10102			= "/QMS/jsp/view/Q10102.jsp";		// 실적변경
	public static final String URL_VIEW_Q10103			= "/QMS/jsp/view/Q10103.jsp";		// 실적상세조회
	public static final String URL_VIEW_Q10104			= "/QMS/jsp/view/Q10104.jsp";		// 실적엑셀다운로드
	
	public static final String URL_VIEW_Q80101			= "/QMS/jsp/view/Q80101.jsp";		// 실적등록 : 메핑 임시
	public static final String URL_VIEW_Q80102			= "/QMS/jsp/view/Q80102.jsp";		// 실적변경 : 메핑 임시
	public static final String URL_VIEW_Q80103			= "/QMS/jsp/view/Q80103.jsp";		// 실적상세조회 : 메핑 임시
	
	public static final String URL_VIEW_Q80201			= "/QMS/jsp/view/Q80201.jsp";		// ASIS 메핑
	public static final String URL_VIEW_Q80202			= "/QMS/jsp/view/Q80202.jsp";		// ASIS 메핑
	
	public static final String URL_VIEW_Q20101			= "/QMS/jsp/view/Q20101.jsp";		// 업무기준통계
	public static final String URL_VIEW_Q20201			= "/QMS/jsp/view/Q20201.jsp";		// 담당기준통계
	public static final String URL_VIEW_Q20202			= "/QMS/jsp/view/Q20202.jsp";		// 개발그룹통계
	
	public static final String URL_VIEW_Q20301			= "/QMS/jsp/view/Q20301.jsp";		// 압별실적내역
	public static final String URL_VIEW_Q20401			= "/QMS/jsp/view/Q20401.jsp";		// 예상공정율
	
	public static final String URL_VIEW_Q30101			= "/QMS/jsp/view/Q30101.jsp";		// 결과 & 결함등록(Open) LIST
	public static final String URL_VIEW_Q30102			= "/QMS/jsp/view/Q30102.jsp";		// 결과 & 결함등록(Open) 등록
	public static final String URL_VIEW_Q30103			= "/QMS/jsp/view/Q30103.jsp";		// 테스트 완료 등록
	public static final String URL_VIEW_Q30104			= "/QMS/jsp/view/Q30104.jsp";		// 결함등록내역 상세조회
	
	public static final String URL_VIEW_Q30201			= "/QMS/jsp/view/Q30201.jsp";		// 결함분류(Assign) LIST
	public static final String URL_VIEW_Q30202			= "/QMS/jsp/view/Q30202.jsp";		// 결함분류(Assign) 등록
	public static final String URL_VIEW_Q30203			= "/QMS/jsp/view/Q30202.jsp";		// 결함분류(Assign) 상세조회  등록페이지와 동일 호출
	public static final String URL_VIEW_Q30204			= "/QMS/jsp/view/Q30204.jsp";		// 결함분류(Assign) 결함등록 취소
	
	public static final String URL_VIEW_Q30301			= "/QMS/jsp/view/Q30301.jsp";		// 결함조치(Fixed)  LIST
	public static final String URL_VIEW_Q30302			= "/QMS/jsp/view/Q30302.jsp";		// 결함조치(Fixed)  등록
	public static final String URL_VIEW_Q30303			= "/QMS/jsp/view/Q30302.jsp";		// 결함조치(Fixed)  상세조회  등록페이지와 동일 호출
	public static final String URL_VIEW_Q30304			= "/QMS/jsp/view/Q30304.jsp";		// 결함조치(Fixed)  조치자 변경
	
	public static final String URL_VIEW_Q30401			= "/QMS/jsp/view/Q30401.jsp";		// 결함확인(Close)  LIST
	public static final String URL_VIEW_Q30402			= "/QMS/jsp/view/Q30402.jsp";		// 결함확인(Close)  등록
	public static final String URL_VIEW_Q30403			= "/QMS/jsp/view/Q30402.jsp";		// 결함확인(Close)  상세조회  등록페이지와 동일 호출
	
	public static final String URL_VIEW_Q30501			= "/QMS/jsp/view/Q30501.jsp";		// 결함처리내역조회  LIST
	public static final String URL_VIEW_Q30502			= "/QMS/jsp/view/Q30502.jsp";		// 결함처리내역상세  LIST
	
	public static final String URL_VIEW_Q30601			= "/QMS/jsp/view/Q30601.jsp";		// 테스트 통계
	public static final String URL_VIEW_Q30602			= "/QMS/jsp/view/Q30602.jsp";		// 테스트 통계 : 조치자별
	
	public static final String URL_VIEW_Q50101			= "/QMS/jsp/view/Q50101.jsp";		// PT관리
	public static final String URL_VIEW_Q50102			= "/QMS/jsp/view/Q50102.jsp";		// PT등록및변경
	
	public static final String URL_VIEW_Q50201			= "/QMS/jsp/view/Q50201.jsp";		// 코드목록
	public static final String URL_VIEW_Q50202			= "/QMS/jsp/view/Q50202.jsp";		// 코드원장추가
	public static final String URL_VIEW_Q50203			= "/QMS/jsp/view/Q50203.jsp";		// 코드내역 조회 및 추가
	
	public static final String URL_VIEW_Q60101			= "/QMS/jsp/view/Q60101.jsp";		// 사용자목록
	public static final String URL_VIEW_Q60102			= "/QMS/jsp/view/Q60102.jsp";		// 사용자원장추가
	
	public static final String URL_VIEW_Q50301			= "/QMS/jsp/view/Q50301.jsp";		// PT등록및변경

	public static final String URL_VIEW_Q90101			= "/QMS/jsp/view/Q90101.jsp";		// 공지 목록
	public static final String URL_VIEW_Q90102			= "/QMS/jsp/view/Q90102.jsp";		// 공지 등록
	public static final String URL_VIEW_Q90103			= "/QMS/jsp/view/Q90103.jsp";		// 공지 상세
	public static final String URL_VIEW_Q90104			= "/QMS/jsp/view/Q90104.jsp";		// 공지 수정/삭제
	
	public static final String URL_VIEW_Q90201			= "/QMS/jsp/view/Q90201.jsp";		// 공유 목록
	public static final String URL_VIEW_Q90202			= "/QMS/jsp/view/Q90202.jsp";		// 공유 등록
	public static final String URL_VIEW_Q90203			= "/QMS/jsp/view/Q90203.jsp";		// 공유 상세
	public static final String URL_VIEW_Q90204			= "/QMS/jsp/view/Q90204.jsp";		// 공유  수정/삭제
	
	public static final String URL_VIEW_Q90301			= "/QMS/jsp/view/Q90301.jsp";		// 테스트데이터 목록
	public static final String URL_VIEW_Q90302			= "/QMS/jsp/view/Q90302.jsp";		// 테스트데이터 등록
	public static final String URL_VIEW_Q90303			= "/QMS/jsp/view/Q90303.jsp";		// 테스트데이터 상세
	public static final String URL_VIEW_Q90304			= "/QMS/jsp/view/Q90304.jsp";		// 테스트데이터  수정/삭제
	
	public static final String URL_VIEW_Q90401			= "/QMS/jsp/view/Q90401.jsp";		// 보고서 업무기준통계
	
	public static final String URL_VIEW_Q90501_tmp			= "/QMS/jsp/view/Q90501_tmp.jsp";		// ISSUE 목록
	
	public static final String URL_VIEW_Q90501			= "/QMS/jsp/view/Q90501.jsp";		// ISSUE 목록
	public static final String URL_VIEW_Q90502			= "/QMS/jsp/view/Q90502.jsp";		// ISSUE 등록
	public static final String URL_VIEW_Q90503			= "/QMS/jsp/view/Q90503.jsp";		// ISSUE 상세
	public static final String URL_VIEW_Q90504			= "/QMS/jsp/view/Q90504.jsp";		// ISSUE 활동 수정/삭제
	
	public static final String URL_PROC_LOGIN			= "/QMS/jsp/proc/Q00101_proc.jsp";	// 로그인 처리 URL
	public static final String URL_PROC_LOGOUT			= "/QMS/jsp/proc/LOGOUT_proc.jsp";	// 로그아웃 URL
	public static final String URL_PROC_PASSWORD_REG	= "/QMS/jsp/proc/Q00102_proc.jsp";	// 비밀번호등록 URL
	
	public static final String URL_PROC_Q10102			= "/QMS/jsp/proc/Q10102_proc.jsp";	// 실적변경 PROC
	
	public static final String URL_PROC_Q80102			= "/QMS/jsp/proc/Q80102_proc.jsp";	// 실적변경 PROC : 메핑 임시
	public static final String URL_PROC_Q80202			= "/QMS/jsp/proc/Q80202_proc.jsp";	// 메핑 변경
	
	public static final String URL_PROC_Q30102			= "/QMS/jsp/proc/Q30102_proc.jsp";	// 결함등록 PROC
	public static final String URL_PROC_Q30103			= "/QMS/jsp/proc/Q30103_proc.jsp";	// 테스트 완료 등록 PROC
	
	public static final String URL_PROC_Q30202			= "/QMS/jsp/proc/Q30202_proc.jsp";	// 분류등록 PROC
	public static final String URL_PROC_Q30204			= "/QMS/jsp/proc/Q30204_proc.jsp";	// 결함등록 취소 PROC
	
	public static final String URL_PROC_Q30302			= "/QMS/jsp/proc/Q30302_proc.jsp";	// 조치등록 PROC
	public static final String URL_PROC_Q30304			= "/QMS/jsp/proc/Q30304_proc.jsp";	// 조치자 변경 PROC
	
	public static final String URL_PROC_Q30402			= "/QMS/jsp/proc/Q30402_proc.jsp";	// 확인등록 PROC
	
	public static final String URL_PROC_Q50102			= "/QMS/jsp/proc/Q50102_proc.jsp";	// PT 등록및변경처리
	
	public static final String URL_PROC_Q50202			= "/QMS/jsp/proc/Q50202_proc.jsp";	// 코드원장 등록 처리
	public static final String URL_PROC_Q50203			= "/QMS/jsp/proc/Q50203_proc.jsp";	// 코드내역 변경 처리
			
	public static final String URL_PROC_Q60101			= "/QMS/jsp/proc/Q60101_proc.jsp";	// 사용자원장 삭제/비번초기화 처리
	public static final String URL_PROC_Q60102			= "/QMS/jsp/proc/Q60102_proc.jsp";	// 사용자원장 등록 처리
	
	public static final String URL_PROC_Q50301			= "/QMS/jsp/proc/Q50301_proc.jsp";	// 일별실적 등록
	
	public static final String URL_PROC_Q90102			= "/QMS/jsp/proc/Q90102_proc.jsp";	// 공지 등록
	public static final String URL_PROC_Q90104			= "/QMS/jsp/proc/Q90104_proc.jsp";	// 공지 수정/삭제
	
	public static final String URL_PROC_Q90202			= "/QMS/jsp/proc/Q90202_proc.jsp";	// 공유 등록
	public static final String URL_PROC_Q90204			= "/QMS/jsp/proc/Q90204_proc.jsp";	// 공유 수정/삭제
	public static final String URL_PROC_Q90205			= "/QMS/jsp/proc/Q90205_proc.jsp";	// 공유 reply 등록/삭제	

	public static final String URL_PROC_Q90302			= "/QMS/jsp/proc/Q90302_proc.jsp";	// 테스트데이터 등록
	public static final String URL_PROC_Q90304			= "/QMS/jsp/proc/Q90304_proc.jsp";	// 테스트데이터 수정/삭제
	public static final String URL_PROC_Q90305			= "/QMS/jsp/proc/Q90305_proc.jsp";	// 테스트데이터 reply 등록/삭제	
	
	public static final String URL_PROC_Q90502			= "/QMS/jsp/proc/Q90502_proc.jsp";	// 테스트데이터 등록
	public static final String URL_PROC_Q90504			= "/QMS/jsp/proc/Q90504_proc.jsp";	// 테스트데이터 수정/삭제
	public static final String URL_PROC_Q90505			= "/QMS/jsp/proc/Q90505_proc.jsp";	// 테스트데이터 reply 등록/삭제	

	public static final String CHECKBOX_ALL				= "ALL";
	
}