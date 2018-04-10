package qms.util;

import java.util.Map;

import qms.db.DBSessionManager;

public class DBSeqUtil{
	/**
	 * ���ο� ������Ʈ ID�� �����ؼ� �����Ѵ�.
	 * @return
	 */
	public static String getProjectId(){
		String prj_id	= new String();
		DBSessionManager qmsDB = null;
		try{
			qmsDB = new DBSessionManager();
			Map<String,String> map = qmsDB.selectOne("QMS_SEQ_INFO.PROJECT_SEQ_R001");
			
			String seq	= StringUtil.null2void(map.get("PRJ_SEQ")).trim();
			prj_id			= "PRJ_"+ BizUtil.getPadString(seq, 10, "0");
		}catch(Exception e){
			e.printStackTrace(System.out);
			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
		}finally{
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
		}
		return prj_id;
	}
	/**
	 * ���ο� �Խ���(�޴�) ID�� �����ؼ� �����Ѵ�.
	 * @return
	 */
	public static String getBoardId(){
		String id		= new String();
		DBSessionManager qmsDB = null;
		try{
			qmsDB = new DBSessionManager();
			Map<String,String> map = qmsDB.selectOne("QMS_SEQ_INFO.BOARDID_SEQ_R001");
			
			String seq	= StringUtil.null2void(map.get("BRD_SEQ")).trim();
			id			= "BRD_"+ BizUtil.getPadString(seq, 10, "0");
		}catch(Exception e){
			e.printStackTrace(System.out);
			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
		}finally{
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
		}
		return id;
	}
	/**
	 * ���ο� �Խù� ID�� �����ؼ� �����Ѵ�.
	 * @return
	 */
	public static String getBbsId(){
		DBSessionManager qmsDB = null;
		String id		= new String();
		try{
			qmsDB = new DBSessionManager();
			Map<String,String> map = qmsDB.selectOne("QMS_SEQ_INFO.BBS_NUM_SEQ_R001");
			
			String seq	= StringUtil.null2void(map.get("BBS_SEQ")).trim();
			id			= "BBS_"+ BizUtil.getPadString(seq, 10, "0");
		}catch(Exception e){
			e.printStackTrace(System.out);
			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
		} finally{
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
		}
		return id;
	}
	/**
	 * ���ο� ��� ID�� �����ؼ� �����Ѵ�.
	 * @return
	 */
	public static String getCommentId(){
		DBSessionManager qmsDB = null;
		String id		= new String();
		try{
			qmsDB = new DBSessionManager();
			Map<String,String> map = qmsDB.selectOne("QMS_SEQ_INFO.BBS_CMT_SEQ_R001");
			String seq	= StringUtil.null2void(map.get("CMT_SEQ")).trim();
			id			= "CMT_"+ BizUtil.getPadString(seq, 10, "0");
		}catch(Exception e){
			e.printStackTrace(System.out);
			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
		}finally{
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
		}
		return id;
	}
}