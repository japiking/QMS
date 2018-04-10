package qms;

import org.apache.log4j.Logger;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.PropertyConfigurator;

public class SampleLog {

	// Logger Ŭ������ �ν��Ͻ��� �޾ƿ´�.
	static Logger logger = Logger.getLogger(SampleLog.class);

	public SampleLog() {
	}

	public static void main(String[] args) {
		/*
		 * �ַܼ� �α� ��� ���� ������ ����, �� ������ ���ٸ� ��� �޼����� ��µǸ鼭 ������ �ߴܵȴ�.
		 */
		// BasicConfigurator.configure();
		PropertyConfigurator.configure("/home/qms/WebContent/WEB-INF/properties/qms.properties");
		logger.debug("[DEBUG] Hello log4j.");
		logger.info("[INFO]  Hello log4j.");
		logger.warn("[WARN]  Hello log4j.");
		logger.error("[ERROR] Hello log4j.");
		logger.fatal("[FATAL] Hello log4j.");
	}
}
