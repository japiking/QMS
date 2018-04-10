package qms.db;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.executor.BatchResult;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.mapping.ResultMap;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.apache.log4j.Logger;

import qms.util.BizUtil;

public class DBSessionManager implements SqlSession{
	
	public static final int _SQLERROR_DUPLICATED = -2;	//중복되는 값이 있는경우
	public static final int _DEFAULT_INT = 0;
	public boolean isShowLog = true;
	static Logger LOG = Logger.getLogger(DBSessionManager.class);
	//Expceiton
	public static final String _DuplicateKeyException = "DuplicateKeyException";
		
	private SqlSession sqlSession = null;
	
	public DBSessionManager(){
		try{
			sqlSession = DBConnectManager.getInstance().getDBSession().openSession(true);
			
			if(sqlSession == null) { 
				LOG.debug("sqlSession is Null");
			}
		} catch(Exception e){
			e.printStackTrace();
			if(sqlSession != null) try{sqlSession.close();} catch(Exception e1){}
		}
	}
	
	public <T> T selectOne(String paramString) {
		log(paramString, null);
		return sqlSession.selectOne(paramString);
	}

	public <T> T selectOne(String paramString, Object paramObject) {
		log(paramString, paramObject);
		return sqlSession.selectOne(paramString, paramObject);
	}

	public <E> List<E> selectList(String paramString) {
		List<E> list = null;
		try{
			log(paramString, null);
			list = sqlSession.selectList(paramString);
			list = this.putAllResultMapColumns(paramString, list);
		}catch(PersistenceException pe){
			BizUtil.processSqlException(pe);
			throw pe;
		}
		
		return list;
	}

	public <E> List<E> selectList(String paramString, Object paramObject) {
		List<E> list = null;
		try{
			log(paramString, paramObject);
			list = sqlSession.selectList(paramString, paramObject);
			list = this.putAllResultMapColumns(paramString, list);
		}catch(PersistenceException pe){
			BizUtil.processSqlException(pe);
			throw pe;
		}
		
		return list;
	}

	public <E> List<E> selectList(String paramString, Object paramObject,
			RowBounds paramRowBounds) {
		log(paramString, paramObject);
		return sqlSession.selectList(paramString, paramObject, paramRowBounds);
	}

	public <K, V> Map<K, V> selectMap(String paramString1, String paramString2) {
		return sqlSession.selectMap(paramString1, paramString2);
	}

	public <K, V> Map<K, V> selectMap(String paramString1, Object paramObject,
			String paramString2) {
		log(paramString1, paramObject);
		return sqlSession.selectMap(paramString1, paramObject, paramString2);
	}

	public <K, V> Map<K, V> selectMap(String paramString1, Object paramObject,
			String paramString2, RowBounds paramRowBounds) {
		log(paramString1, paramObject);
		return sqlSession.selectMap(paramString1, paramObject, paramString2, paramRowBounds);
	}

	public void select(String paramString, Object paramObject,
			ResultHandler paramResultHandler) {
		log(paramString, paramObject);
		sqlSession.select(paramString, paramObject, paramResultHandler);
	}

	public void select(String paramString, ResultHandler paramResultHandler) {
		sqlSession.select(paramString, paramResultHandler);
		
	}

	public void select(String paramString, Object paramObject,
			RowBounds paramRowBounds, ResultHandler paramResultHandler) {
		log(paramString, paramObject);
		sqlSession.select(paramString, paramObject, paramRowBounds, paramResultHandler);
		
	}

	public int insert(String paramString) {
		return this.insert(paramString, false);
	}
	
	public int insert(String paramString, boolean checkException) {
		int cnt = _DEFAULT_INT;
		String errorCode = new String("");
		
		try{
			log(paramString, null);
			cnt = sqlSession.insert(paramString);
		}catch(PersistenceException pe){
			errorCode = BizUtil.processSqlException(pe);
			if(checkException && ("-803".equals(errorCode) || _DuplicateKeyException.equals(errorCode)) ){
				cnt = _SQLERROR_DUPLICATED;
			}else{
				throw pe;
			}
		}
		return cnt;
	}
	
	public int insert(String paramString, Object paramObject) {
		return this.insert(paramString, paramObject, false);
	}
	
	public int insert(String paramString, Object paramObject, boolean checkException) {
		int cnt = _DEFAULT_INT;
		String errorCode = new String("");

		try{
			log(paramString, paramObject);
			cnt = sqlSession.update(paramString, paramObject);
		}catch(PersistenceException pe){
			errorCode = BizUtil.processSqlException(pe);
			if(checkException && ("-803".equals(errorCode) || _DuplicateKeyException.equals(errorCode)) ){
				cnt = _SQLERROR_DUPLICATED;
			}else{
				throw pe;
			}
		}
		return cnt;
	}

	public int update(String paramString) {
		int cnt = _DEFAULT_INT;
		try{
			log(paramString, null);
			cnt = sqlSession.update(paramString);
		}catch(PersistenceException pe){
			BizUtil.processSqlException(pe);
			throw pe;
		}
		return cnt;
	}

	public int update(String paramString, Object paramObject) {
		int cnt = _DEFAULT_INT;
		
		try{
			log(paramString, paramObject);
			cnt = sqlSession.update(paramString , paramObject);
		}catch(PersistenceException pe){
			BizUtil.processSqlException(pe);
			throw pe;
		}
		return cnt;
	}

	public int delete(String paramString) {
		int cnt = _DEFAULT_INT;
		
		try{
			log(paramString, null);
			cnt = sqlSession.delete(paramString);
		}catch(PersistenceException pe){
			BizUtil.processSqlException(pe);
			throw pe;
		}
		return cnt;
	}

	public int delete(String paramString, Object paramObject) {
		int cnt = _DEFAULT_INT;
		
		try{
			log(paramString, paramObject);
			cnt = sqlSession.delete(paramString, paramObject);
		}catch(PersistenceException pe){
			BizUtil.processSqlException(pe);
			throw pe;
		}
		return cnt;
	}

	public void commit() {
		sqlSession.commit();
		
	}

	public void commit(boolean paramBoolean) {
		sqlSession.commit(paramBoolean);
		
	}

	public void rollback() {
		sqlSession.rollback();
	}

	public void rollback(boolean paramBoolean) {
		sqlSession.rollback(paramBoolean);
	}

	public List<BatchResult> flushStatements() {
		sqlSession.flushStatements();
		return null;
	}

	public void close() {
		try{
			sqlSession.close();
		}catch(Exception e){}
	}

	public void clearCache() {
		sqlSession.clearCache();
	}

	public Configuration getConfiguration() {
		return sqlSession.getConfiguration();
	}

	public <T> T getMapper(Class<T> paramClass) {
		return sqlSession.getMapper(paramClass);
	}

	public Connection getConnection() {
		return sqlSession.getConnection();
	}
	
	/**
	 * 컬럼의 데이터가 없는 경우에도 Key를 Map에 넣고 value는 "" 으로 처리해준다.
	 * @param paramString
	 * @param list
	 * @return list
	 */
	private <E> List<E> putAllResultMapColumns(String paramString, List<E> list){
		MappedStatement mapStat = sqlSession.getConfiguration().getMappedStatement(paramString);
    	ResultMap resultMap = null;
    	Set rstMapColumns = null;				//resultMap의 컬럼
    	Iterator rstMapColumnsIter = null;
    	Map listMap = new HashMap();			//쿼리수행후 나온 Map
    	String rstMapColumn = new String("");
    	List<E> rstlist = list;
    	try{
			if (null != mapStat){
				if(!mapStat.getResultMaps().isEmpty() && 1 == mapStat.getResultMaps().size()){
					resultMap = (ResultMap) mapStat.getResultMaps().get(0);
					if(!resultMap.getMappedColumns().isEmpty()){
						rstMapColumns = resultMap.getMappedColumns();
						for(int i=0; i < list.size(); i++){
							rstMapColumnsIter = rstMapColumns.iterator();
			        		listMap = (HashMap) list.get(i);
			        		while(rstMapColumnsIter.hasNext()){
			        			rstMapColumn = (String) rstMapColumnsIter.next();
			        			if(!listMap.containsKey(rstMapColumn)){
			        				listMap.put(rstMapColumn, "");
			        			}
			        		}
			        		list.set(i, (E) listMap);
			        	}
					}
				}
			}
    	}catch(Exception e){
    		LOG.debug("### Exception putAllResultMapColumns ###");
    		return list;
    	}
		
		return rstlist;
	}

	public void showQueryLog (boolean bShow) {
		isShowLog = bShow;
	}
	
	/**
	 * SQL LOG
	 * @param paramString
	 * @param paramObject
	 */
	private void log(String paramString, Object paramObject) {
		if (!isShowLog) return;
		try {
			StringBuilder builder	= new StringBuilder();
			builder.append("\n===========================================================================\n");
			builder.append("SQL_ID : "+paramString+"\n");
			builder.append("---------------------------------------------------------------------------\n            ");
			BoundSql boundSql		= sqlSession.getConfiguration().getMappedStatement(paramString).getBoundSql(paramObject);
			builder.append(boundSql.getSql()+"\n");
			builder.append("---------------------------------------------------------------------------\n");
			List<ParameterMapping> params	= boundSql.getParameterMappings();
			for( int i = 0; i < params.size(); i++ ) {
				builder.append("Parameters - "+params.get(i).getProperty() + " : " + ((Map)paramObject).get(params.get(i).getProperty())+"\n");
			}
			builder.append("===========================================================================\n");
			LOG.debug(builder.toString());
		} catch(Exception e){}
	}
	
}
