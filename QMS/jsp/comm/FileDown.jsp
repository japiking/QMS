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
  //�Ʒ� getServletContext().getRealPath("/") �� ������ ���� ��θ� �޾ƿ´�
  //String path = getServletContext().getRealPath("/uploadfile");
  
  String path = "";
  String realPath = PropertyUtil.getInstance().getProperty("rootPath");
  // ISO-8895-1 ���ڵ��� ��κ��� �������� ������ �⺻ ���ڼ� �̶�� ��
  // �״ϱ� euc-kr�� ������ ����Ʈ�� ������ ���� ���ڼ����� �ٲ۰�     
  String fileName = request.getParameter("filename");
  
  fileName = URLDecoder.decode(fileName);
  
  path 		= realPath + fileName.substring(5, fileName.lastIndexOf("/"));
  fileName 	= fileName.substring(fileName.lastIndexOf("/")+1);
  
  File file = new File(path, fileName);
  
  LogUtil.getInstance().debug("File �� ::"+fileName);
  LogUtil.getInstance().debug("File ��� ::"+path);
  
  if (!file.exists() || !file.isFile() ) 
  {
	  LogUtil.getInstance().debug("������ �������� ����");
	  response.setStatus(HttpServletResponse.SC_NOT_FOUND);
	  return ;
  }
	if (download(request, response, file, out) != null)
	{
		return;
	}
%>
<%!

/** �ٿ�ε� ���� ũ�� */
private static final int BUFFER_SIZE = 8192; // 8kb

/** ���� ���ڵ� */
private static final String CHARSET = "utf-8";


/**
 * ������ ������ �ٿ�ε� �Ѵ�.
 * 
 * @param request
 * @param response
 * @param file
 * @out	JSP���尴ü JspWriter(out�� ����Ǿ� ����)
 * @pageContext	JSP���尴ü PageContext(pageContext�� ����Ǿ� ����)
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
 * ������ ������ �ٿ�ε� �Ѵ�.
 * 
 * @param request
 * @param response
 * @param file
 * @param fileNm �ٿ�ε��� ���ϸ�
 * @out	JSP���尴ü JspWriter(out�� ����Ǿ� ����)
 * @pageContext	JSP���尴ü PageContext(pageContext�� ����Ǿ� ����)
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
	      throw new IOException("�߸��� �����Դϴ�. MIME TYPE :: " + mimetype);
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
 * �ش� �Է� ��Ʈ�����κ��� ���� �����͸� �ٿ�ε� �Ѵ�.
 * 
 * @param request
 * @param response
 * @param is		  �Է� ��Ʈ��
 * @param filename ���� �̸�
 * @param filesize ���� ũ��
 * @param mimetype MIME Ÿ�� ����
 * @out	JSP���尴ü JspWriter(out�� ����Ǿ� ����)
 * @pageContext	JSP���尴ü PageContext(pageContext�� ����Ǿ� ����)
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
  	out.clear();                    // �̰� �ڹٷ� �о����.	
  }
  if (pageContext != null)
  {
  	out = pageContext.popBody();
  }

  byte[] buffer = new byte[BUFFER_SIZE];

  response.setContentType(mime + "; charset=" + CHARSET);
  
  String userAgent = request.getHeader("User-Agent");
  LogUtil.getInstance().debug("userAgent::"+userAgent);
  if (userAgent.indexOf("MSIE 5.5") > -1) { // MS IE 5.5 ����
    response.setHeader("Content-Disposition", "filename=\"" + URLEncoder.encode(filename, "UTF-8") + "\";");
  } else if (userAgent.indexOf("MSIE") > -1) { // MS IE (������ 6.x �̻� ����)
    response.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(filename, "UTF-8") + "\";");
  } else { // ������ �����
    response.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(filename, "UTF-8") + "\";");
  }

  // ���� ����� ��Ȯ���� �������� �ƿ� �������� �ʴ´�.
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