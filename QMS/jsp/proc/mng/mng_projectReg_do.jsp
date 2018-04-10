<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>

<%@ include file="/jsp/inc/inc_common.jsp" %>

<%
	String prj_nm			= StringUtil.null2void(request.getParameter("PROJECTNAME"));
	String bigoi			= StringUtil.null2void(request.getParameter("BIGO"));
	String pm_id			= StringUtil.null2void(request.getParameter("PROJECTMANAGERID"));
	String prj_start_date 	= StringUtil.null2void(request.getParameter("PROJECTSTARTDATE"));
	String prj_end_date	  	= StringUtil.null2void(request.getParameter("PROJECTENDDATE"));
	String prj_gbn	  		= StringUtil.null2void(request.getParameter("PROC_GBN"));
	String prj_id 	  		= StringUtil.null2void(request.getParameter("PROJECT_ID"));
	try{
		Map<String,String> param1		= new HashMap<String,String>();
		String rlt = new String("");
		param1.put("USERID", pm_id);
		try{
			Map<String,String> map = qmsDB.selectOne("QMS_SUPERUSER.USERINFO_R001", param1);
			rlt = map.get("CNT");
		}catch(Exception e1){
			rlt = "0";	
		}
		
		if("0".equals(rlt)){
			// PM�� ID�� ��ϵ� ����ڰ� �ƴҰ�� ������Ϻ��� �ϵ��� �����Ѵ�.
			out.println("<script type='text/javascript'>							");
			out.println("	alert('����� ��� �޴��� ���� PM�� ����Ͻʽÿ�.');	");
			out.println("</script>													");
		} else {
			
			if("U".equals(prj_gbn)){
				// ������Ʈ���� ����
				Map<String,String> param2		= new HashMap<String,String>();
				param2.put("PROJECTMANAGERID", 	pm_id);
				param2.put("PROJECTNAME", 		prj_nm);
				param2.put("PROJECTSTARTDATE", 	prj_start_date);
				param2.put("PROJECTENDDATE", 	prj_end_date);
				param2.put("BIGO", 				bigoi);
				param2.put("PROJECTID", 		prj_id);
				int dbRlt					= qmsDB.update("QMS_SUPERUSER.PROJECTINFO_U001",param2);
				
				// ������Ʈ������������(PM ���̵� ����)
				Map<String,String> param3		= new HashMap<String,String>();
				param3.put("USERID", 			pm_id);
				param3.put("PROJECTID", 		prj_id);
				int dbRlt2					= qmsDB.update("QMS_SUPERUSER.PROJECTUSERINFO_U001",param3);
				
			} else {
				// ������ƮID ����
				prj_id = DBSeqUtil.getProjectId();
				
				// ������Ʈ ���� �Է�
				Map<String,String> param2 = new HashMap<String,String>();
				param2.put("PROJECTID", 			prj_id);
				param2.put("PROJECTNAME", 			prj_nm);
				param2.put("PROJECTSTARTDATE", 		prj_start_date);
				param2.put("PROJECTENDDATE", 		prj_end_date);
				param2.put("PROJECTMANAGERID", 		pm_id);
				param2.put("BIGO", 					bigoi);
				int dbRlt2					= qmsDB.insert("QMS_SUPERUSER.PROJECTINFO_C001",param2);
				
				// �������� �������� �Է�
				Map<String,String> param3 = new HashMap<String,String>();
				param3.put("PROJECTID", 			prj_id);
				param3.put("USERID", 				pm_id);
				param3.put("BIGO", 					prj_nm+"������Ʈ PM�Դϴ�.");
				
				int dbRlt3						= qmsDB.update("QMS_SUPERUSER.PROJECTUSERINFO_C001",param3);
				
				List<Map<String,String>> list	= qmsDB.selectList("QMS_SUPERUSER.MENUTYPE_R001");
				if(null != list && !list.isEmpty()){
					Map<String,String> dataMap	= null;
					for(int i=0; i <list.size(); i++){
						dataMap	= list.get(i);
						
						// ����Ʈ �޴����� �Է�
						Map<String, Object> param6 = new HashMap<String, Object>();
						param6.put("PROJECTID", 			prj_id);
						param6.put("BOARD_ID", 				DBSeqUtil.getBoardId());
						param6.put("SORT_SEQ", 				i+1);
						param6.put("MENU_TYPE_ID", 			dataMap.get("MENU_TYPE_ID"));
						param6.put("KOR_MENU_NAME", 		dataMap.get("MENU_KR_NAME"));
						int dbRlt6		= qmsDB.insert("QMS_SUPERUSER.MENU_C001",param6);
						
					}
				}
			}
			out.println("<script type='text/javascript'>		");
			out.println("	alert('���� ó�� �Ǿ����ϴ�.');		");
			out.println("</script>								");
		}
	} catch(Exception e){
		out.println("<script type='text/javascript'>			");
		out.println("	alert('ó���� ������ �߻��Ͽ����ϴ�.');	");
		out.println("</script>									");
		e.printStackTrace(System.out);
		if (qmsDB != null)
			try { qmsDB.rollback(); } catch (Exception e1) {}
	} finally{
		if (qmsDB != null)
			try { qmsDB.close(); } catch (Exception e1) {}
	}

	// �α��� ȭ������ �̵�
	out.println("<script type='text/javascript'>				");
	out.println("	location.href='/QMS/jsp/view/index.jsp';	");
	out.println("</script>										");
%>