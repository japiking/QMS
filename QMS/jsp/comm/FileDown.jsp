<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="qms.util.LogUtil"%>
<%@ page import="qms.util.PropertyUtil"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.jsp.*"%>
<%@ page import="javax.servlet.http.*" %>


<%
//	request.setCharacterEncoding("euc-kr");
  //아래 getServletContext().getRealPath("/") 는 서버의 절대 경로를 받아온다
  //String path = getServletContext().getRealPath("/uploadfile");
  
  String path = "";
  String realPath = PropertyUtil.getInstance().getProperty("rootPath");
  // ISO-8895-1 인코딩은 대부분의 브라우저에 설정된 기본 문자셋 이라고 함
  // 그니깐 euc-kr로 가져온 바이트를 브라우저 설정 문자셋으로 바꾼것     
  String fileName = request.getParameter("filename");
  
  fileName = URLDecoder.decode(fileName);
  
  path 		= realPath + fileName.substring(5, fileName.lastIndexOf("/"));
  fileName 	= fileName.substring(fileName.lastIndexOf("/")+1);
  
  File file = new File(path, fileName);
  
  LogUtil.getInstance().debug("File 명 ::"+fileName);
  LogUtil.getInstance().debug("File 경로 ::"+path);
  
  if (!file.exists() || !file.isFile() ) 
  {
	  LogUtil.getInstance().debug("파일이 존재하지 않음");
	  response.setStatus(HttpServletResponse.SC_NOT_FOUND);
	  return ;
  }
	if (download(request, response, file, out) != null)
	{
		return;
	}
%>
<%!

/** 다운로드 버퍼 크기 */
private static final int BUFFER_SIZE = 8192; // 8kb

/** 문자 인코딩 */
private static final String CHARSET = "utf-8";


/**
 * 지정된 파일을 다운로드 한다.
 * 
 * @param request
 * @param response
 * @param file
 * @out	JSP내장객체 JspWriter(out로 선언되어 있음)
 * @pageContext	JSP내장객체 PageContext(pageContext로 선언되어 잇음)
 * 
 * @throws ServletException
 * @throws IOException
 */
public static JspWriter download(HttpServletRequest request, HttpServletResponse response, File file, JspWriter out) throws ServletException, IOException 
{
    return download(request, response, file, out, null);
}
public static JspWriter download(HttpServletRequest request, HttpServletResponse response, File file, JspWriter out, PageContext pageContext) throws ServletException, IOException 
{
    return download(request, response, file, file.getName(), out, pageContext);
}

/**
 * 지정된 파일을 다운로드 한다.
 * 
 * @param request
 * @param response
 * @param file
 * @param fileNm 다운로드할 파일명
 * @out	JSP내장객체 JspWriter(out로 선언되어 있음)
 * @pageContext	JSP내장객체 PageContext(pageContext로 선언되어 잇음)
 * 
 * @throws ServletException
 * @throws IOException
 */
public static JspWriter download(HttpServletRequest request, HttpServletResponse response, File file, String fileNm, JspWriter out) throws ServletException, IOException  
{
	  return download(request, response, file, fileNm, out, null);
}

public static JspWriter download(HttpServletRequest request, HttpServletResponse response, File file, String fileNm, JspWriter out, PageContext pageContext) throws ServletException, IOException
{
	    String mimetype = request.getSession().getServletContext().getMimeType(file.getName());
	    
	    if (file == null || !file.exists() || file.length() <= 0 || file.isDirectory()) {
	      throw new IOException("잘못된 파일입니다. MIME TYPE :: " + mimetype);
	    }
	    InputStream is = null;
	    try {
	      is = new FileInputStream(file);
	      return download(request, response, is, fileNm, file.length(), mimetype, out);
	    } finally {
	      try { is.close(); } catch (Exception ex) {;}
	    }
	  }


public static JspWriter download(HttpServletRequest request, HttpServletResponse response, String data, String filename, String mimetype, JspWriter out) throws ServletException, IOException
{
	  return download(request, response, data, filename, data.getBytes().length, mimetype, out, null);
}


public static JspWriter download(HttpServletRequest request, HttpServletResponse response, String data, String filename, long filesize, String mimetype, JspWriter out) throws ServletException, IOException
{
	  return download(request, response, data, filename, filesize, mimetype, out, null);
}

public static JspWriter download(HttpServletRequest request, HttpServletResponse response, String data, String filename, long filesize, String mimetype, JspWriter out, PageContext pageContext) throws ServletException, IOException
{
	  return download(request, response, new ByteArrayInputStream(data.getBytes(CHARSET)), filename, filesize, mimetype, out, pageContext);
}


/**
 * 해당 입력 스트림으로부터 오는 데이터를 다운로드 한다.
 * 
 * @param request
 * @param response
 * @param is		  입력 스트림
 * @param filename 파일 이름
 * @param filesize 파일 크기
 * @param mimetype MIME 타입 지정
 * @out	JSP내장객체 JspWriter(out로 선언되어 있음)
 * @pageContext	JSP내장객체 PageContext(pageContext로 선언되어 잇음)
 * 
 * @throws ServletException
 * @throws IOException
 */

public static JspWriter download(HttpServletRequest request, HttpServletResponse response, InputStream is, String filename, long filesize, String mimetype, JspWriter out) throws ServletException, IOException
{
	  return download(request, response, is, filename, filesize, mimetype, out, null);
}

public static JspWriter download(HttpServletRequest request, HttpServletResponse response, InputStream is, String filename, long filesize, String mimetype, JspWriter out, PageContext pageContext) throws ServletException, IOException
{
  String mime = mimetype;

  if (mimetype == null || mimetype.length() == 0) {
    mime = "application/octet-stream;";
  }
  
  if (out != null)
  {
  	out.clear();                    // 이거 자바로 밀어넣자.	
  }
  if (pageContext != null)
  {
  	out = pageContext.popBody();
  }

  byte[] buffer = new byte[BUFFER_SIZE];

  response.setContentType(mime + "; charset=" + CHARSET);
  
  String userAgent = request.getHeader("User-Agent");
  LogUtil.getInstance().debug("userAgent::"+userAgent);
  if (userAgent.indexOf("MSIE 5.5") > -1) { // MS IE 5.5 이하
    response.setHeader("Content-Disposition", "filename=\"" + URLEncoder.encode(filename, "UTF-8") + "\";");
  } else if (userAgent.indexOf("MSIE") > -1) { // MS IE (보통은 6.x 이상 가정)
    response.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(filename, "UTF-8") + "\";");
  } else { // 모질라나 오페라
    response.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(filename, "UTF-8") + "\";");
  }

  // 파일 사이즈가 정확하지 않을때는 아예 지정하지 않는다.
  if (filesize > 0) {
    response.setHeader("Content-Length", "" + filesize);
  }
  
  BufferedInputStream fin = null;
  BufferedOutputStream outs = null;
  
  try {
    fin = new BufferedInputStream(is);
    outs = new BufferedOutputStream(response.getOutputStream());
    int read = 0;

    while ((read = fin.read(buffer)) != -1) {
      outs.write(buffer, 0, read);
    }
  } finally {
    try { outs.close();	} catch (Exception ex1) {;}
    try { fin.close();	} catch (Exception ex2) {;}
  }
  return out;
}


%>