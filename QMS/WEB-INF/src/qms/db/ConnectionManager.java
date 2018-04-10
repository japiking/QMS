package qms.db;

import java.sql.Connection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ConnectionManager {

	private static final ConnectionManager manager	= new ConnectionManager();

	private ConnectionManager() {
	}
	
	public static ConnectionManager getInstance() {
		return manager;
	}
	
	public Connection getConnection() throws Exception {
		 Context initCtx	= new InitialContext();
		 Context envCtx		= (Context)initCtx.lookup("java:comp/env");
		 DataSource ds		= (DataSource)envCtx.lookup("jdbc/QMS");
		 
		 return ds.getConnection();
	}
	
}
