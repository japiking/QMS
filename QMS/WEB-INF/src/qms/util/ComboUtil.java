package qms.util;

import java.util.List;
import java.util.Map;
import java.util.Set;

import qms.db.DBSessionManager;
import qms.db.QueryHelper;

public class ComboUtil {

	// ��� ������ ������ �Ӽ����� ����� �ִ� �޺�, 0��° value, 1��° text, 2��° ���ʹ� �Ӽ�
	// param0 select ����
	// param1 �޺�Name
	// param2 Default���ð�
	public static String makeExtendCombo(String sql, String comboName,String valuename, String textname, String selectedvalue, Map<String,String> param) throws Exception {
		StringBuffer combo	= new StringBuffer();
		DBSessionManager qmsDB = null;
		try{
			qmsDB = new DBSessionManager();
			combo.append("<select name='" + comboName + "'>");
			
			List<Map<String,String>> userList	= qmsDB.selectList(sql, param);
			
			if( userList != null && userList.size() > 0 ) {
				Map<String,String> userMap	= null;
				for( int i = 0; i < userList.size(); i++ ) {
					userMap	= userList.get(i);
					
					Set<String> tempSet = userMap.keySet();
					String[] array = tempSet.toArray(new String[0]);
					
					combo.append("<option value='"+userMap.get(valuename.toUpperCase())+"'");
					if(array.length > 2) {
						
						for(int j = 0; j< array.length; j++) {
							combo.append(" " + array[j]  + "='" + userMap.get(array[j]) + "'");
						}
					}
					
					if( selectedvalue != null && !"".equals(selectedvalue) && selectedvalue.equals(userMap.get(0)) ) {
						combo.append(" selected");
					}
					combo.append(">"+userMap.get(textname.toUpperCase())+"</option>");
				}
			}
			
			combo.append("</select>");
		
		}catch(Exception e){
			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
		}finally{
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
		}
		
		return combo.toString();
	}
	
}
