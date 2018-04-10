package qms.wbs;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import qms.util.DateTime;

public class WBSNode {
	private String taskCode;
	private String taskLevel;
	private Map<String, String> nodeAttribute = new HashMap<String, String>();
	private Vector<WBSNode> children = new Vector<WBSNode>();
	
	
	public Map<String, String> getNodeAttribute() {
		return nodeAttribute;
	}

	public void setNodeAttribute(Map<String, String> nodeAttribute) {
		this.nodeAttribute = nodeAttribute;
	}


	public String getTaskCode() {
		return taskCode;
	}

	public void setTaskCode(String taskCode) {
		this.taskCode = taskCode;
	}

	public String getTaskLevel() {
		return taskLevel;
	}

	public void setTaskLevel(String taskLevel) {
		this.taskLevel = taskLevel;
	}
	
	public Vector<WBSNode> getChildren() {
		return children;
	}

	public void setChildren(Vector<WBSNode> children) {
		this.children = children;
	}

	/**
	 * ��������� ���� ���
	 * @return ������ ����� ��� true �ƴϸ� false
	 */
	public boolean isLeafNode() {
		if (children != null && children.size() > 0) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * @return ������ ������� ���� ����
	 */
	public int getLeafCount() {
		int leafCount = 0;
		if (!isLeafNode()) {
			for(int i = 0 ; i < children.size(); i++){
				WBSNode node = children.get(i);
				leafCount += node.getLeafCount();
			}
		} else {
			return 1;
		}
		return leafCount;
	}
	
	/**
	 * @return ������ Ư��Ű, ���� �Ǽ� ��������
	 */
	public int getSumValue(String strKey, String strValue) {
		int count = 0;
		if (!isLeafNode()) {
			for(int i = 0 ; i < children.size(); i++){
				WBSNode node = children.get(i);
				count += node.getSumValue(strKey,strValue);
			}
		} else {
			if( getNodeAttribute().get(strKey).equals(strValue)){
				return 1;
			}else{
				return 0;
			}
		}
		return count;
	}
	
	
	public String getAttribute(String strKey){
		return getNodeAttribute().get(strKey);
	}
	
	/**
	 * 
	 * @param strKey ��¥ Ű�ʵ�
	 * @param strDate	��������
	 * @return	���� �Ǽ�
	 */
	public int getSumValueDate(String strKey, String strDate) {
		int count = 0;
		if ( strDate == null){
			String today      = DateTime.getInstance().getDate("yyyy-mm-dd");
			strDate = today;
		}
		if (!isLeafNode()) {
			for(int i = 0 ; i < children.size(); i++){
				WBSNode node = children.get(i);
				count += node.getSumValueDate(strKey,strDate);
			}
		} else {
			if( getAttribute(strKey).compareTo(strDate) <= 0){
				return 1;
			}else{
				return 0;
			}
		}
		return count;
	}
	
	public int getSumValueDate(String strKey) {
		return getSumValueDate(strKey, null);
	}
		
	
	/**
	 * ����߰�
	 * @param node
	 */
	public void appendChild(WBSNode node){
		children.add(node);
	}


}