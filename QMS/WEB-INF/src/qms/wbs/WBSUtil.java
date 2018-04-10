package qms.wbs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import qms.db.DBSessionManager;
import qms.util.LogUtil;


public class WBSUtil {
	
	public static WBSNode makeWBSTree(String strProjectId) throws Exception {
		WBSNode rootNode = new WBSNode();
		rootNode.setTaskLevel("0");
		rootNode.setTaskCode("root");
		List<Map<String,String>> statMaplist  = null;
		DBSessionManager qmsDB = new DBSessionManager();
		Map<String,String> param =  new HashMap<String,String>();
		param.put("PROJECT_ID", strProjectId);
		try{
			statMaplist = qmsDB.selectList("QMS_BBS_LIST.WBS_R001",param);
		} catch (Exception e) {
			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
		} finally {
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
		}
				
		for (int i = 0; i < statMaplist.size(); i++) {
			WBSNode node = MapToWBSNode(statMaplist.get(i));
			append(rootNode, node);
		}
		return rootNode;
	}

	public static void append(WBSNode rootNode, WBSNode node) {
		if ("1".equals(node.getTaskLevel())) {
			rootNode.appendChild(node);
		} else {
			WBSNode parentNode = findParentNode(rootNode, node);
			parentNode.appendChild(node);
		}
	}

	public static WBSNode findParentNode(WBSNode startNode, WBSNode node) {
		WBSNode parentNode = null;
		Vector<WBSNode> children = startNode.getChildren();
		String strTaskLevel = node.getTaskLevel();
		int nTaskLevel = Integer.parseInt(strTaskLevel);
		if(children.size()==0 || children == null ){
			if ( node.getTaskCode().startsWith(startNode.getTaskCode()) ){
				parentNode = node;
			}
		}else{
			for (int i = 0; i < children.size(); i++) {
				WBSNode Lnode = children.get(i);
				int nLnodeTaskLevel = Integer.parseInt(Lnode.getTaskLevel());
				if ( node.getTaskCode().startsWith(Lnode.getTaskCode()) ){
					if( nTaskLevel == (nLnodeTaskLevel + 1) ) {
						parentNode = Lnode;
					}else{
						parentNode = findParentNode(Lnode,node);
					}
				}
			}
		}
		return parentNode;
	}
	
	public static WBSNode findNode(WBSNode startNode, String strTaskCode){
		WBSNode retNode = null;
		Vector<WBSNode> children = startNode.getChildren();
		if(strTaskCode.equals(startNode.getTaskCode())){
			return startNode;
		}
		for (int i = 0; i < children.size(); i++) {
			WBSNode tempNode = children.get(i);
			retNode = findNode(tempNode,strTaskCode);
			if(retNode != null){
				return retNode;
			}
		}
		if(strTaskCode.equals(startNode.getTaskCode())){
			retNode = startNode;
		}
		return retNode;
	}
	
	public static void treeTraval(WBSNode node){
		if (!node.isLeafNode()) {
			for(int i = 0 ; i < node.getChildren().size(); i++){
				WBSNode tempNode = node.getChildren().get(i);
				LogUtil.getInstance().debug("TASK_LEVEL::"+node.getTaskLevel()+"\tTASK_CODE:"+node.getTaskCode() +"\tLEAF_COUNT:"+ node.getLeafCount());
				treeTraval(tempNode);
			}
		}else{
			LogUtil.getInstance().debug("leaf_TASK_LEVEL::"+node.getTaskLevel()+"\tTASK_CODE:"+node.getTaskCode() +"\tLEAF_COUNT:"+ node.getLeafCount());
		}
	}
	
	public static WBSNode MapToWBSNode(Map appendNodeMap) {
		WBSNode wbsNode = new WBSNode();
		wbsNode.setTaskCode((String) appendNodeMap.get("TASK_CODE"));
		wbsNode.setTaskLevel((String) appendNodeMap.get("TASK_LEVEL"));
		wbsNode.setNodeAttribute(appendNodeMap);
		return wbsNode;
	}
}