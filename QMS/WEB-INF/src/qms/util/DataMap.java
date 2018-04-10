package qms.util;

import java.io.PrintStream;
import java.io.Serializable;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class DataMap extends HashMap implements Serializable {
	private static final long serialVersionUID = -7517688282979333170L;

	public DataMap() {
		super(500);
	}

	public DataMap(int initialCapacity) {
		super(initialCapacity);
	}

	public DataMap(Map map) {
		super(map);
	}

	public Object get(String name) {
		Object obj = super.get(name);
		return obj;
	}

	public void put(String name, int value) {
		super.put(name, new Integer(value));
	}

	public void put(String name, long value) {
		super.put(name, new Long(value));
	}

	public void put(String name, float value) {
		super.put(name, new Float(value));
	}

	public void put(String name, double value) {
		super.put(name, new Double(value));
	}

	public void put(String name, boolean value) {
		super.put(name, new Boolean(value));
	}

	public String getNVLString(String paramName) {
		String value = getString(paramName);

		if ((value == null) || (value.trim().length() == 0))
			return "";

		return value.trim();
	}

	public String getstr(String paramName) {
		return getNVLString(paramName);
	}

	public String getNVLString(String paramName, String defaultValue) {
		String value = getString(paramName);
		if ((value == null) || (value.trim().length() == 0))
			return defaultValue;

		return value;
	}

	public String getString(String paramName) {
		Object obj = super.get(paramName);
		if (obj == null) {
			return "";
		}
		return obj.toString();
	}

	public int getInt(String paramName) throws NumberFormatException {
		String value = getString(paramName);
		if (value == null) {
			return 0;
		}
		return Integer.parseInt(value);
	}

	public long getLong(String paramName) throws NumberFormatException {
		String value = getString(paramName);
		if (value == null) {
			return 0L;
		}
		return Long.parseLong(value);
	}

	public String getParameter(String paramName){
		String str = getString(paramName);
		return str;
	}

	public String getParameter(String paramName, String defaultValue) {
		String str = getString(paramName);
		return str;
	}

	public Object getObjectParameter(String paramName, Object defaultObj) {
		Object obj = get(paramName);
		if (obj == null) {
			return defaultObj;
		}
		return obj;
	}

	public String toString() {
		if (isEmpty()) {
			return "DataMap is empty.===============";
		}
		StringBuffer buf = new StringBuffer(2000);
		Set keySet = super.keySet();
		Iterator i = keySet.iterator();
		String key = null;
		Object item = null;
		while (i.hasNext()) {
			key = (String) i.next();
			item = get(key);
			if (item == null) {
				buf.append(key).append("=null\n");
			} else if (item instanceof String) {
				if (key.endsWith("pwd")) {
					item = "****";
				}
				buf.append(key).append("=[").append(item).append("]\n");
			} else if ((item instanceof Integer) || (item instanceof Long)
					|| (item instanceof Double) || (item instanceof Float)
					|| (item instanceof Boolean)) {
				buf.append(key).append("=[").append(item).append("]\n");
			} else if (item instanceof String[]) {
				String[] data = (String[]) item;
				buf.append(key).append("=[");

				for (int j = 0; j < data.length; ++j) {
					buf.append(data[j]).append(',');
					buf.append("] Array Size:").append(j).append(" \n");
				}
			} else {
				buf.append(key).append("=[").append(item)
						.append("] ClassName:")
						.append(item.getClass().getName()).append("\n");
			}
		}
		buf.append("end of DataMap info ============================\n");
		return buf.toString();
	}

	public String getDataMapInfo() {
		return toString();
	}
	public static void main(String[] args) {
		DataMap map = new DataMap();
	}
	
}