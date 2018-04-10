package qms.db;

import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

public class QueryHelper {
	static Logger LOG = Logger.getLogger(QueryHelper.class);
	public static int execute(String sql, Object[] param) throws SQLException {
		int result				= 0;
		Connection conn			= null;
		PreparedStatement pstmt	= null;
		try {
			LOG.debug("SQL [\n"+sql+"\n]");
			
			conn		= ConnectionManager.getInstance().getConnection();
			pstmt		= conn.prepareStatement(sql);
			if( param != null && param.length > 0  ) {
				for( int i = 0; i < param.length; i++ ) {
					pstmt.setObject(i+1, param[i]);
					LOG.debug("parameter index ["+i+"] ["+param[i]+"]");
				}
			}
			
			result		= pstmt.executeUpdate();
			
		} catch(SQLException e){
			throw e;
		} catch(Exception e) {
			throw new SQLException(e);
		} finally {
			if( pstmt != null ) try{ pstmt.close(); }catch(Exception e){}
			if( conn != null ) try{ conn.close(); }catch(Exception e){}
		}
		
		return result;
	}
	public static int execute(String sql, Object[] param,int idx) throws java.sql.SQLException {
		int result				= 0;
		java.sql.Connection conn			= null;
		java.sql.PreparedStatement pstmt	= null;
		try {
			LOG.debug("SQL [\n"+sql+"\n]");
			
			conn		= qms.db.ConnectionManager.getInstance().getConnection();
			pstmt		= conn.prepareStatement(sql);

			
			if( param != null && param.length > 0  ) {
				for( int i = 0; i < param.length; i++ ) {
					
					if(i == idx ){					
						pstmt.setCharacterStream(i+1, new StringReader((String)param[i]), ((String)param[i]).length());
					}else{
						pstmt.setObject(i+1, param[i]);
					}				
				}
			}
			
			result		= pstmt.executeUpdate();
			
		} catch(java.sql.SQLException e){
			throw e;
		} catch(Exception e) {
			throw new java.sql.SQLException(e);
		} finally {
			if( pstmt != null ) try{ pstmt.close(); }catch(Exception e){}
			if( conn != null ) try{ conn.close(); }catch(Exception e){}
		}
		
		return result;
	}
	

	public static Map<String,String> select(String sql, Object[] param) throws SQLException {
		Map<String, String> result	= new HashMap<String,String>();
		
		Connection conn			= null;
		PreparedStatement pstmt	= null;
		ResultSet rs			= null;
		try {
			LOG.debug("SQL [\n"+sql+"\n]");
			
			conn		= ConnectionManager.getInstance().getConnection();
			pstmt		= conn.prepareStatement(sql);
			if( param != null && param.length > 0  ) {
				for( int i = 0; i < param.length; i++ ) {
					pstmt.setObject(i+1, param[i]);
					LOG.debug("parameter index ["+i+"] ["+param[i]+"]");
				}
			}
			
			rs	= pstmt.executeQuery();
			if( rs == null || !rs.next() ) {
				throw new SQLException("조회 데이터가 없습니다.");
			}
			
			ResultSetMetaData meta	= rs.getMetaData();
			int colCnt				= meta.getColumnCount();
			String[] colNames		= new String[colCnt];
			for( int i = 0; i < colCnt; i++ ) {
				colNames[i]			= meta.getColumnName(i+1).toUpperCase();
			}
			
			for( int i = 0; i < colNames.length; i++ ) {
				result.put(colNames[i], rs.getString(colNames[i]));
			}
			
		} catch(SQLException e){
			throw e;
		} catch(Exception e) {
			throw new SQLException(e);
		} finally {
			if( rs != null ) try{ rs.close(); }catch(Exception e){}
			if( pstmt != null ) try{ pstmt.close(); }catch(Exception e){}
			if( conn != null ) try{ conn.close(); }catch(Exception e){}
		}
		
		return result;
	}
	
	public static Map<String,String> selectXX(String sql, Object[] param) throws SQLException {
		Map<String, String> result	= new HashMap<String,String>();
		
		Connection conn			= null;
		PreparedStatement pstmt	= null;
		ResultSet rs			= null;
		try {
			LOG.debug("SQL [\n"+sql+"\n]");
			
			conn		= ConnectionManager.getInstance().getConnection();
			pstmt		= conn.prepareStatement(sql);
			if( param != null && param.length > 0  ) {
				for( int i = 0; i < param.length; i++ ) {
					pstmt.setObject(i+1, param[i]);
					LOG.debug("parameter index ["+i+"] ["+param[i]+"]");
				}
			}
			
			rs	= pstmt.executeQuery();
			if( rs == null || !rs.next() ) {
				LOG.debug("SQL Result Count [NULL]");
				return result;
			}
			
			ResultSetMetaData meta	= rs.getMetaData();
			int colCnt				= meta.getColumnCount();
			String[] colNames		= new String[colCnt];
			
			LOG.debug("SQL Result Count ["+colCnt+"]");
			for( int i = 0; i < colCnt; i++ ) {
				colNames[i]			= meta.getColumnName(i+1).toUpperCase();
			}
			
			for( int i = 0; i < colNames.length; i++ ) {
				result.put(colNames[i], rs.getString(colNames[i]));
			}
			
		} catch(SQLException e){
			throw e;
		} catch(Exception e) {
			throw new SQLException(e);
		} finally {
			if( rs != null ) try{ rs.close(); }catch(Exception e){}
			if( pstmt != null ) try{ pstmt.close(); }catch(Exception e){}
			if( conn != null ) try{ conn.close(); }catch(Exception e){}
		}
		
		return result;
	}

	
	public static List<Map<String,String>> selectList(String sql, Object[] param) throws SQLException {
		List<Map<String, String>> result	= new ArrayList<Map<String,String>>();
		
		Connection conn			= null;
		PreparedStatement pstmt	= null;
		ResultSet rs			= null;
		try {
			LOG.debug("SQL [\n"+sql+"\n]");
			
			conn		= ConnectionManager.getInstance().getConnection();
			pstmt		= conn.prepareStatement(sql);
			if( param != null && param.length > 0  ) {
				for( int i = 0; i < param.length; i++ ) {
					pstmt.setObject(i+1, param[i]);
					LOG.debug("parameter index ["+i+"] ["+param[i]+"]");
				}
			}
			
			rs	= pstmt.executeQuery();
			if( rs != null ) {
				Map<String,String> data	= null;
				
				ResultSetMetaData meta	= rs.getMetaData();
				int colCnt				= meta.getColumnCount();
				String[] colNames		= new String[colCnt];
				
				LOG.debug("SQL Result ColumnCount ["+colCnt+"]");
				for( int i = 0; i < colCnt; i++ ) {
					colNames[i]			= meta.getColumnName(i+1).toUpperCase();
				}
				
				
				while( rs.next() ) {
					LOG.debug("SQL Result ["+rs.getString(colNames[0])+"]");
					data	= new HashMap<String,String>();
					for( int i = 0; i < colNames.length; i++ ) {
						data.put(colNames[i], rs.getString(colNames[i]));
					}
					
					result.add(data);
				}
			} else {
				LOG.debug("SQL Result Count [NULL]");
			}
			
		} catch(SQLException e){
			throw e;
		} catch(Exception e) {
			throw new SQLException(e);
		} finally {
			if( rs != null ) try{ rs.close(); }catch(Exception e){}
			if( pstmt != null ) try{ pstmt.close(); }catch(Exception e){}
			if( conn != null ) try{ conn.close(); }catch(Exception e){}
		}
		
		return result;
	}
	
}
